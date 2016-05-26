<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_evalua.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Encuesta Así soy yo"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")

if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
ruta = "test.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
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
		   " pers_tnombre as nombres, pers_tape_paterno as ap_paterno, pers_tape_materno as ap_materno, pers_temail," & vbCrLf &_
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
		     " from encuesta_asi_soy_yo b  " & vbCrLf &_
		     " where cast(pers_ncorr as varchar)= '"&pers_ncorr&"'" 
contestada = conexion.consultaUno(c_contestada)
set f_encuesta = new CFormulario
f_encuesta.Carga_Parametros "asi_soy_yo.xml", "encuesta"
f_encuesta.Inicializar conexion
if contestada = "S" then
consulta = " select a.pers_ncorr, b.* " & vbCrLf &_
		   " from personas a left outer join encuesta_asi_soy_yo b  " & vbCrLf &_
		   "  on a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		   " where cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"'" 
else
	consulta = " select '"&pers_ncorr&"' as pers_ncorr,'"&cod_carrera&"' as carr_ccod "
end if		   

'response.Write("<pre>"&consulta&"</pre>")
f_encuesta.Consultar consulta
f_encuesta.Siguiente



%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Asi soy yo 2007 - Encuesta Universidad del Pac&iacute;fico</title>
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
		
		document.edicion.elements["encu[0][ciud_ccod]"].disabled=false;	
	}
	else
	{
			
		document.edicion.elements["encu[0][ciud_ccod]"].disabled=true;
	}

}
function codeudor_papa(valor)
{
//alert("valor "+valor);
	if (valor =='S')
	{
		
		document.edicion.elements["fpapa[0][ciud_ccod]"].disabled=false;	
	}
	else
	{
			
		document.edicion.elements["fpapa[0][ciud_ccod]"].disabled=true;
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
</script>
</head>

<body>
<p align="center" class="Estilo35">&quot;As&iacute; soy yo&quot;</p>
<p align="center"><span class="Estilo34">CUESTIONARIO SOBRE CARACTERISTICAS  <br />
   PERSONALES Y ESTRATEGIAS DE ESTUDIO  </span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion">
<input type="hidden" name="encu[0][pers_ncorr]" value="<%=pers_ncorr%>">
<input type="hidden" name="encu[0][carr_ccod]" value="<%=cod_carrera%>">
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr valign="bottom">
				<td width="100" height="24" background="images/borde_superior.jpg"><span class="Estilo46">Así soy yo</span></td>
			    <td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
			    <td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta%>"> Test</a></font></td>
				<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
			    <td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta3%>"> Encuesta</a></font></td>
				<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>

				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
			    <td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta2%>"> Mis Datos</a></font></td>
				<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>

				<td bgcolor="#FFFFFF">&nbsp;</td>
			</tr>
		</table>
	</td>
	<td width="29" height="24" bgcolor="#FFFFFF">&nbsp;</td>
</tr>
<tr>
	<td width="25" height="24" background="images/lado_izquierda.jpg" align="right"><img width="18" height="24" src="images/borde_superior.jpg"></td>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" aling="left" width="646">
		<table width="646" border="0" align="left" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
			<td align="left"><p class="Estilo27">::  Introducci&oacute;n </p>
				<p class="Estilo31">El  objetivo de esta encuesta es poder conocerte un poco m&aacute;s y entregarte una  atenci&oacute;n  personalizada e integral. A continuaci&oacute;n te pedimos que contestes  las siguientes preguntas.Requiere alrededor de 10 minutos de tu tiempo.</p>
			    <table width="90%" border="0" bgcolor="#FFFFFF">
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
				  <% if contestada <> "S" then %>
				  <tr>
					<td class="Estilo31" width="20%">Carrera</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%=carrera%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Edad</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("edad")%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Fono Fijo</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("pers_tfono")%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Fono Celular  </td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("pers_tcelular")%></td>
				  </tr>
				   <tr>
					<td class="Estilo31" width="20%">E-mail</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("pers_temail")%></td>
				  </tr>
				  <%else%>
				  <tr><td colspan="3" align="center"><p class="Estilo31"><span class="Estilo27">Tus Respuestas fueron grabadas Correctamente.<br> Muchas Gracias.</span></p></td></tr>
				  <%end if%>
			  </table>
			 <% if contestada <> "S" then %>
			  <br />
				<br />
				<hr size="1" noshade="noshade" />
				
			  <p class="Estilo36">&iquest;Vienes a estudiar desde provincia?</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0">
				  <tr>
					<td width="30" valign="top" class="Estilo31"><p align="center">
						<input name="encu[0][de_provincia]" type="radio" value="S"  onclick="valida_ciudad(this.value);"/>
					</p></td>
					<td width="237" valign="top" class="Estilo31">Si</td>
					<td width="30" valign="top" class="Estilo31"><p align="center">
						<input name="encu[0][de_provincia]" type="radio" value="N" onClick="valida_ciudad(this.value);" checked />
					</p></td>
					<td width="253" valign="top" class="Estilo31">No</td>
				  </tr>
				  <tr>
					<td colspan="2" valign="top" class="Estilo31"><p>En caso de responder afirmativamente <br />
					  &iquest;De D&oacute;nde?</p></td>
					<td colspan="2" valign="top" class="Estilo31"><p>
						<%f_encabezado.DibujaCampo("ciud_ccod")%>
					</p></td>
				  </tr>
			  </table>
			  <br />
				<br />
				<hr size="1" noshade="noshade" />
				<p class="Estilo27">:: Estrategias de Estudio</p>
			    <p class="Estilo31"><strong><em> 1) </em></strong>&ldquo;Me pongo en acción para alcanzar las metas que me propongo;&rdquo;</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_1")%></td>
				  </tr>	
			  </table>
			  <hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 2) </em></strong>&ldquo;Me cuesta organizarme para estudiar;&rdquo;</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_2")%></td>
				  </tr>
				</table>
				<hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 3) </em></strong>&ldquo;Me distraigo fácilmente en clases y/o cuando estudio;&rdquo;</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_3")%></td> 
				  </tr>
			  </table>
			  <hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 4) </em></strong>&ldquo;Creo que lograr mis metas académicas depende principalmente de mi esfuerzo y trabajo;&rdquo;</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_4")%></td>
				  </tr>
			  </table>
			  <hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 5) </em></strong>&ldquo;Me siento responsable de mis acciones y decisiones;&rdquo;</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				<tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_5")%></td>
				</tr>
			  </table>
			  <hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 6) </em></strong>&ldquo;Puedo trabajar con personas que piensan y/o trabajan distinto a mí&rdquo;</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_6")%></td>
				  </tr>
				</table>  
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 7) </em></strong>&ldquo;Pienso que algunos ramos de mi carrera serán muy difíciles de afrontar exitosamente&rdquo;</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_7")%></td>
				  </tr>
				</table>  
				<hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 8) </em></strong>&ldquo;Suelo plantearme metas concretas en el ámbito académico&rdquo;:</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_8")%></td>
				  </tr>
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 9) </em></strong>&ldquo;Me doy por vencido/a fácilmente cuando no obtengo los resultados esperados&rdquo;</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_9")%></td>
				  </tr>
				</table>
			  <br />
				<br />
			  <p class="Estilo31"><strong><em> 10) </em></strong>&ldquo;Si me va mal en una prueba, puedo aceptarlo y pensar en cómo cambiarlo&rdquo;</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_10")%></td>
				  </tr>
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 11) </em></strong>&ldquo;Complemento la materia de clases con otras fuentes de información (libros, artículos, internet)&rdquo;</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_11")%></td>
				  </tr>
				</table>  
				<br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 12) </em></strong>&ldquo;Me siento capaz de cumplir las metas que me propongo&rdquo;</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_12")%></td>
				  </tr>
				</table>  
				<br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 13) </em></strong>&ldquo;Cuando recuerdo mis errores escolares, me desanimo&rdquo;</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_13")%></td>
				  </tr>
			  </table>
			  <br />
				<br />
			  <p class="Estilo42"><strong><em> 14) </em></strong>&ldquo;Sé como manejar mi motivación hacia asignaturas que no me entretienen ni gustan&rdquo;</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				<tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_14")%></td>
				</tr>
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo42"><strong><em> 15) </em></strong>&ldquo;Creo que tengo los recursos y habilidades suficientes para sacar adelante la carrera que estudio&rdquo;:</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_15")%></td>
				  </tr>
				</table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 16) </em></strong>&ldquo;Cuando trabajo con otros soy capaz de ceder en mis propuestas, en pos de un objetivo común&rdquo;:</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_16")%></td>
				  </tr>
				</table>  
				<br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 17) </em></strong>&ldquo;Puedo esforzarme en una materia o ramo, pese a que me aburra y/o esté cansado/a&quot;</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_17")%></td>
				  </tr>
				</table>
				
			  <p class="Estilo31"><strong><em> 18) </em></strong>&ldquo;Elaboro esquemas y/o resúmenes cuando leo y/o tomo apuntes&rdquo;: </p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_18")%></td>
				  </tr>
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 19)</em></strong>&ldquo;Tengo confianza en que podré manejar adecuadamente los desafíos y tareas de mi carrera&rdquo;:</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_19")%></td>
				  </tr>
				</table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 20) </em></strong>&ldquo;Puedo pedir ayuda cuando no entiendo una materia&rdquo;:</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_20")%></td>
				  </tr>
				</table>  
				<br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo27">:: Manejo del Estrés</p>
				<p class="Estilo43">Marca la alternativa que corresponda, recordando c&oacute;mo ha sido tu  vida el <strong>&uacute;ltimo mes</strong>. </p>

				<p class="Estilo31"><strong><em> 21) </em></strong>&ldquo;Duermo bien y me siento descansada/o&rdquo;:</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_21")%></td>
				  </tr>
				</table>
			  <br />
				<br />
			  <p class="Estilo31"><strong><em> 22) </em></strong>&ldquo;Me siento capaz de manejar el estrés o la tensión en mi vida&rdquo;:</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_22")%></td>
				  </tr>
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 23) </em></strong>&ldquo;Me cuesta manejar mi ansiedad frente a pruebas y exámenes&rdquo;:</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_23")%></td>
				  </tr>
				</table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 24) </em></strong>&ldquo;Tengo dificultades para realizar presentaciones orales y/o hablar en público&rdquo;:</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_24")%></td>
				  </tr>
				</table>
			  <br />
				<br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo27">:: Emociones y Comunicación </p>
				<p class="Estilo43">Responde considerando las <strong>&uacute;ltimas 2 semanas</strong>. </p>
			  <p class="Estilo31"><strong><em> 25) </em></strong>&ldquo;Puedo expresar mis emociones&rdquo;:</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				<tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_25")%></td>
				</tr>
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 26) </em></strong>&ldquo;Me siento enojada/o o agresiva/o, la mayor parte del día&rdquo;</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_26")%></td>
				  </tr>
				</table>
			  <br />
				<br />
				<hr size="1" noshade="noshade" />
			  <p class="Estilo31"><em><strong><em> 27) </em></strong>&ldquo;Me he sentido triste y/o desanimado/a la mayor parte del día, casi todos los días&rdquo;</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_27")%></td>
				  </tr>
				</table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo31"><em><strong><em> 28) </em></strong>&ldquo;Siento que he perdido la capacidad de disfrutar con las actividades que antes me satisfacían&rdquo;</p>
			   <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_28")%></td>
				  </tr>
				</table>
			  <br />
			  <hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo31"><em><strong><em> 29) </em></strong>&ldquo;Me es difícil decir que no cuando me piden algo y no quiero hacerlo&rdquo;</p>
			   <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_29")%></td>
				  </tr>
				</table>
			    <br />
			  <hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo31"><em><strong><em> 30) </em></strong>&ldquo;Me cuesta aceptar críticas &rdquo;</p>
			   <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("asi_30")%></td>
				  </tr>
				</table>
			  <%end if%>
			  <br /></td>
		  </tr>
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
<%if contestada <> "S" then %>
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" align="center" width="646">
		<table width="646" border="0" align="center" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
			<td width="617"><p align="left" class="Estilo31"><em>Comentarios&nbsp;&nbsp;</em>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <strong>
			  <textarea name="encu[0][comentarios]" cols="100" rows="4" class="Estilo25" id="TO-N"></textarea>
			</strong></p>    </td>
		  </tr>
		  <tr>
			<td width="617"><p align="center" class="Estilo31"><%f_botonera.dibujaBoton "guardar"%></p>    </td>
		  </tr>
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
<%end if%>
</form>
<p align="center"><strong>&nbsp;<span class="Estilo45">&iexcl;Muchas gracias por  tu colaboraci&oacute;n! </span></strong><span class="Estilo45"><br />
  Para conversar los temas de la  encuesta y resolver dudas ac&eacute;rcate a la <br />
  <span class="Estilo46">DAE (Direcci&oacute;n de Asuntos  Estudiantiles)</span> en el 3er piso o llamando al 3665366-3665350</span></p>
<p align="center" class="Estilo31">&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
</tr>
</table>
</body>

</html>
