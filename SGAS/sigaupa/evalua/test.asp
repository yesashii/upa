<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_evalua.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Tests de caracterización"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
portal_alum=Request.QueryString("porta_alumno")
if portal_alum="" then
portal_alum="S"
 
end if

if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
ruta = "asi_soy_yo.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
ruta2 = "tus_datos.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
ruta3 = "estilo_aprendizaje.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
consulta_periodo=" select max(b.peri_ccod) "&_
                 " from alumnos a, ofertas_academicas b "&_
				 " where cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"' and a.emat_ccod in (1)" &_
				 " and a.ofer_ncorr = b.ofer_ncorr "
				 

q_peri_ccod = conexion.consultaUno(consulta_periodo)

'response.Write(consulta_matr)
carrera = conexion.consultaUno("Select carr_tdesc from alumnos a, ofertas_Academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod=1 and c.carr_ccod=d.carr_ccod")

cod_carrera = conexion.consultaUno("Select d.carr_ccod from alumnos a, ofertas_Academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod=1 and c.carr_ccod=d.carr_ccod")

'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "asi_soy_yo.xml", "botonera"

pers_ncorr_temporal=pers_ncorr

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "asi_soy_yo.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = " select pers_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut, " & vbCrLf &_
		   " pers_tnombre as nombres, pers_tape_paterno as ap_paterno, pers_tape_materno as ap_materno, " & vbCrLf &_
		   " datediff(year,pers_fnacimiento,getDate()) as edad, " & vbCrLf &_
		   " pers_tfono, pers_tcelular  " & vbCrLf &_
		   " from personas  " & vbCrLf &_
		   " where cast(pers_ncorr as varchar)= '" & pers_ncorr & "' "
		   

'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
'----------------------------------------------------------------------------------------------------
'debemos ver si el alumno ya contestó la encuesta.
c_contestada = " select case count (*) when 0 then 'N' else 'S' end " & vbCrLf &_
		     " from encuesta_test b  " & vbCrLf &_
		     " where cast(pers_ncorr as varchar)= '"&pers_ncorr&"'" 
contestada = conexion.consultaUno(c_contestada)


set f_encuesta = new CFormulario
f_encuesta.Carga_Parametros "asi_soy_yo.xml", "encuesta"
f_encuesta.Inicializar conexion
if contestada = "S" then
consulta = " select a.pers_ncorr, b.* " & vbCrLf &_
		   " from personas a left outer join encuesta_test b  " & vbCrLf &_
		   "  on a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		   " where cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"'" 
else
	consulta = " select '"&pers_ncorr&"' as pers_ncorr,'"&cod_carrera&"' as carr_ccod "
end if		   

'response.Write("<pre>"&consulta&"</pre>")
f_encuesta.Consultar consulta
f_encuesta.Siguiente



set f_respuesta = new CFormulario
f_respuesta.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_respuesta.Inicializar conexion
if contestada = "S" then

	consulta = "select nombre,ec,o_r,ca,ea,ca_ec,ea_or,"& vbCrLf &_
"case when ea_or > 0 and ca_ec >0  then 'DIVERGENTE' when ea_or < 0 and ca_ec >0  then 'ACOMODADOR' when ea_or > 0 and ca_ec < 0  then 'ASIMILADOR' when ea_or < 0 and ca_ec <0  then 'CONVERGENTE' when ea_or = 0 and ca_ec >0  then 'ACOMODADOR/DIVERGENTE' when ea_or > 0 and ca_ec =0  then 'DIVERGENTE/ASIMILADOR' when ea_or = 0 and ca_ec < 0  then 'ASIMILADOR/CONVERGENTE' when ea_or < 0 and ca_ec = 0  then 'ACOMODADOR/CONVERGENTE' when ea_or = 0 and ca_ec = 0  then 'ACOMODADOR/CONVERGENTE/ASIMILADOR/DIVERGENTE'  end as tipo"& vbCrLf &_

"from (select distinct cast(p.pers_nrut as varchar) + '-' + p.pers_xdv as rut, p.pers_tape_paterno + ' ' + p.pers_tape_materno + ' ' + p.pers_tnombre as 						               	nombre,carr_tdesc as carrera, post_npaa_verbal as Paa_verbal,post_npaa_matematicas as paa_mate,protic.trunc(et.fecha)as fecha,"& vbCrLf &_
"preg_2_a + preg_3_a + preg_4_a + preg_5_a + preg_7_a + preg_8_a as ec,"& vbCrLf &_
"preg_1_b + preg_3_b +preg_6_b + preg_7_b + preg_8_b + preg_9_b  as o_r,"& vbCrLf &_
"preg_2_c + preg_3_c +preg_4_c + preg_5_c + preg_8_c + preg_9_c as ca,"& vbCrLf &_
"preg_1_d + preg_3_d +preg_6_d + preg_7_d + preg_8_d + preg_9_d as ea,"& vbCrLf &_
"((((preg_1_d + preg_3_d +preg_6_d + preg_7_d + preg_8_d + preg_9_d)-(preg_1_b + preg_3_b +preg_6_b + preg_7_b + preg_8_b + preg_9_b))*-1)+3)as ea_or,"& vbCrLf &_
"((((preg_2_c + preg_3_c +preg_4_c + preg_5_c + preg_8_c + preg_9_c)-(preg_2_a + preg_3_a + preg_4_a + preg_5_a + preg_7_a + preg_8_a))*-1)+2)as ca_ec"& vbCrLf &_

 
"from encuesta_test et,personas p,alumnos a,postulantes po,ofertas_academicas oa, especialidades esp,carreras car"& vbCrLf &_
"where et.pers_ncorr=p.pers_ncorr"& vbCrLf &_
"and et.pers_ncorr=a.pers_ncorr"& vbCrLf &_
"and a.ofer_ncorr=oa.ofer_ncorr"& vbCrLf &_
"and oa.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod>2007) "& vbCrLf &_
"and oa.espe_ccod=esp.espe_ccod"& vbCrLf &_
"and esp.carr_ccod=car.carr_ccod"& vbCrLf &_
"and a.post_ncorr=po.post_ncorr"& vbCrLf &_
"and et.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"'))aa"
else
consulta="select ''"		   
end if
'response.Write("<pre>"&consulta&"</pre>")
f_respuesta.Consultar consulta
f_respuesta.Siguiente

'response.Write(portal_alum)
'response.Write("<br>"&contestada)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Tests de caracterización</title>
<style type="text/css">
<!--
.Estilo25 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
}
body {
	background-color: #dae4fa;
}
.Estilo26 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10pt;
}
.Estilo27 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16pt;
	font-weight: bold;
	color: #FF7F00;
}
.Estilo31 {
	font-size: 10pt;
	font-family: Arial, Helvetica, sans-serif;
}
.Estilo34 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }
.Estilo35 {
	font-weight: bold;
	font-size: 36px;
	font-style: italic;
	color: #FF7F00;
}
.Estilo36 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; }
.Estilo37 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; font-weight: bold; }
.Estilo42 {font-size: 10pt; color: #000000; font-family: Arial, Helvetica, sans-serif;}
.Estilo43 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #333333; }
.Estilo45 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; }
.Estilo46 {
	color: #FF6600;
	font-weight: bold;
}
-->
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
var trabaja;
trabaja = 0;
function valida_ciudad(valor)
{
//alert("valor "+valor);
	if (valor =='S')
	{
		document.edicion.elements["encu[0][ciud_ccod]"].id="TO-N";	
	}
	else
	{
		document.edicion.elements["encu[0][ciud_ccod]"].id="TO-S";	
	}
}



function activar_variable(valor)
{
    if(valor=='S')
	{trabaja = 1;}
	else
	{trabaja = 2;}
}

function validar()
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=5;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name!="encu[0][de_provincia]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 return true;
  }
  else
  {
   alert("Debe responder la encuesta antes de grabar,\n aún faltan preguntas por contestar.");
   return false;
  }
}
function revisar(indice,letra,campo)
{   
	var formulario = document.edicion;
	var valor_ingresado = formulario.elements[campo].value;
	if ((valor_ingresado!="1") && (valor_ingresado!="2") && (valor_ingresado!="3") && (valor_ingresado!="4"))
	{
		alert("Los valores a ingresar como respuesta deben estar dentro del rango 1-4");
		formulario.elements[campo].value="";
	}
	else
	{
	   if ((letra=="a")&&((valor_ingresado==formulario.elements["preg_"+indice+"_b"].value)||(valor_ingresado==formulario.elements["preg_"+indice+"_c"].value)||(valor_ingresado==formulario.elements["preg_"+indice+"_d"].value)) )
		{
			alert("Los valores a ingresar como respuesta ya fue ingresado en otra opción de la misma pregunta, le recordamos que estos no deben repetirse");
			formulario.elements[campo].value="";
		}
	   else if ((letra=="b")&&((valor_ingresado==formulario.elements["preg_"+indice+"_a"].value)||(valor_ingresado==formulario.elements["preg_"+indice+"_c"].value)||(valor_ingresado==formulario.elements["preg_"+indice+"_d"].value)) )
		{
			alert("Los valores a ingresar como respuesta ya fue ingresado en otra opción de la misma pregunta, le recordamos que estos no deben repetirse");
			formulario.elements[campo].value="";
		}	
	   else  if ((letra=="c")&&((valor_ingresado==formulario.elements["preg_"+indice+"_b"].value)||(valor_ingresado==formulario.elements["preg_"+indice+"_a"].value)||(valor_ingresado==formulario.elements["preg_"+indice+"_d"].value)) )
		{
			alert("Los valores a ingresar como respuesta ya fue ingresado en otra opción de la misma pregunta, le recordamos que estos no deben repetirse");
			formulario.elements[campo].value="";
		}
	   else  if ((letra=="d")&&((valor_ingresado==formulario.elements["preg_"+indice+"_b"].value)||(valor_ingresado==formulario.elements["preg_"+indice+"_c"].value)||(valor_ingresado==formulario.elements["preg_"+indice+"_a"].value)) )
		{
			alert("Los valores a ingresar como respuesta ya fue ingresado en otra opción de la misma pregunta, le recordamos que estos no deben repetirse");
			formulario.elements[campo].value="";
		}
	}
	
}

</script>
</head>
<%if portal_alum="S" then%>
<body >
<%else%>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#84a6d3" background="images/fondo.jpg">
<%end if%>
<p align="center" class="Estilo35">&quot;Test&quot;</p>
<p align="center"><span class="Estilo34">CUESTIONARIO SOBRE <br />
   LA FORMA EN QUE APRENDO</span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion">
<input type="hidden" name="encu[0][pers_ncorr]" value="<%=pers_ncorr%>">
<input type="hidden" name="encu[0][carr_ccod]" value="<%=cod_carrera%>">
<table width="700" border="0" cellpadding="0" cellspacing="0">
<%if portal_alum="S" then%>
<tr>
	<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr valign="bottom">
				<td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta%>">Así soy yo</a></font></td>
			    <td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				
				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
			    <td width="100" height="24" background="images/borde_superior.jpg"><span class="Estilo46">Test</span></td>
			    <td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				
				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
			    <td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta3%>"> Encuesta</a></font></td>
				<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				
								

				<td bgcolor="#FFFFFF">&nbsp;</td>
			</tr>
		</table>
	</td>
	<td width="29" height="24" bgcolor="#FFFFFF">&nbsp;</td>
</tr>
<%end if%>
<tr>
<%if portal_alum="N" then%>
	<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<%else%>
	<td width="25" height="24" background="images/lado_izquierda.jpg" align="right"><img width="18" height="24" src="images/borde_superior.jpg"></td>
	<%end if%>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>

<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" aling="left" width="646">
		<table width="646" border="0" align="left" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  
		  <tr>
		 <p class="Estilo27">:: Test </p>
			<td align="left">
									
			  <table width="87%" border="0" bgcolor="#FFFFFF">
				  <tr>
					<td class="Estilo31" width="20%">Nombres</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("nombres")%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Apellido Paterno</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("ap_paterno")%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Apellido Materno</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("ap_materno")%></td>
				  </tr>
				   <% if contestada <> "S"  then %>
				  <tr>
					<td class="Estilo31" width="20%">Carrera</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%=carrera%></td>
				  </tr>
				<% if contestada <> "S" and portal_alum="N" then %>
					<tr>
						<td colspan="3">	
								<table width="100%" height="109">
									<tr>
									  <td width="100%" class="Estilo31">
										<p align="center" class="Estilo31"><span class="Estilo27">No has Rendido el Test.</span>
									  </td>
									</tr>
						  </table>
						</td>		
					</tr>			
					<%end if%>
				  <%else%>
				  <tr><td colspan="3" align="center"><p class="Estilo31"><span class="Estilo27">Tus Respuestas fueron grabadas Correctamente.<br> Muchas Gracias.</span>
				  
				  <tr>
				  	<td colspan="3">
					
						<table width="574" height="109">
							<tr>
							  <td class="Estilo31">
								De acuerdo a los resultados obtenidos en el test de D. Kolb, tu estilo de aprendizaje es <strong><%f_respuesta.DibujaCampo("tipo")%></strong>.

<BR />
Para conocer las técnicas de aprendizaje más adecuadas, de acuerdo a tus resultados, y obtener  recomendaciones para mejorar tus logros académico, te sugerimos trabajar con el material didáctico de tu CD interactivo.</td>
							</tr>
						</table>
					<%end if%>
					
					
					</td>
				  </tr>
				
			  </table>
			 <% if contestada <> "S" and portal_alum="S" then %>
			 
			 
			 <table width="646" >
			 
						 
			
				<p class="Estilo31">	
						  <br><br>
						  <br><br>
						  
						  A continuación se presenta un cuestionario compuesto por nueve filas (horizontales), identificadas por los números 1 al 9.<br>
				                    Deberás asignar un puntaje de 1 a 4, en los casilleros de cada una de las preguntas. No puedes repetir un puntaje dentro de una fila.<br>
									Coloca 4 puntos a la situación que te reporte más beneficios cuando aprendes, y  asigna los puntajes “3”, “2” y “1” a las restantes situaciones planteadas en la fila, en función de la efectividad que tienen éstas en tu forma de aprender.<br>
									<br><br>
									4: esta situación es la que mejor refleja la forma en que aprendo.<br>
									3: esta situación refleja bastante la forma en que aprendo.<br>
									2: esta situación refleja medianamente la forma en que aprendo.<br> 
									1: esta situación es la que menos refleja la forma en que aprendo.
				</p>
									
			 </table>
			 
			 
			 
			   <tr><td align="center"><p align="center" class="Estilo31"><%f_botonera.dibujaBoton "guardar2"%></p></td></tr>
			  <%end if%>
			
			  
		  
		</table>
</td>
	<td width="29" background="images/lado_derecha.gif"></td>
</tr>
<tr>
	<td width="25" height="27" background="images/borde_inferior.jpg"><img width="25" height="27" src="images/inferior_izquierda.jpg"></td>
	<td width="646" height="27" background="images/borde_inferior.jpg">&nbsp;</td>
	<td width="29" height="27"><img width="29" height="27" src="images/inferior_derecha.jpg"></td>
</tr>
</table>

</form>
<%if portal_alum="S" then%>
<p align="center"><strong>&nbsp;<span class="Estilo45">&iexcl;Muchas gracias por  tu colaboraci&oacute;n! </span></strong><span class="Estilo45"><br />
  Para conversar los temas de la  encuesta y resolver dudas ac&eacute;rcate a la <br />
  <span class="Estilo46">DAE (Direcci&oacute;n de Asuntos  Estudiantiles)</span> en el 3er piso o llamando al 3665366-3665350</span></p>
  <%end if%>
<p align="center" class="Estilo31">&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
</tr>
</table>
</body>

</html>
