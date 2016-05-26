<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_dir_docente_rr_hh.asp"-->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
pers_ncorr_q=request.QueryString("pers_ncorr")
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_satifaccion.xml", "botonera"

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "encuesta_satifaccion.xml", "encabezado"
f_encabezado.Inicializar conexion

q_pers_nrut=negocio.obtenerUsuario


'///////////configuracion de periodo academico///////////
'colocar el semestre a evaluar
peri_ccod="236"				

'para la variable peri_ccod2 si es el 1 semestre se escribe el codigo correspondiente , si el el 2° sem debe colocarse el codigo del 2° sem y el 3 trimestre separado por una 
'coma  ej. 220,221 
peri_ccod2="236"					
'//////////////////////////////


pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&q_pers_nrut&")")
nombre=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno from personas where pers_nrut="&q_pers_nrut&"")
peri=conexion.ConsultaUno("select peri_tdesc from periodos_academicos where peri_ccod="&peri_ccod&"") 
if pers_ncorr_q <>"" then
pers_ncorr=pers_ncorr_q
end if
consulta = " select ''" 
		   
		   

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_encabezado.Consultar consulta
f_encabezado.Siguiente


'pers_ncorr=23921
consulta ="select protic.obtener_codigo_carreras_con_clases("&pers_ncorr&","&peri_ccod&")" 
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
carr_ccod=conexion.ConsultaUno(consulta)
'response.Write("<pre>pers_ncorr= "&pers_ncorr&"</pre>")
if pers_ncorr="24834" then
carr_ccod="51,920,110"
end if
if pers_ncorr="109748" then
carr_ccod="850"
end if
if pers_ncorr="24270"then
carr_ccod="880,870,25,29"
end if

if pers_ncorr="24221"then
carr_ccod="47 "
end if
if pers_ncorr="11917"then
carr_ccod="12,910,900,890,99"
end if
if pers_ncorr="122992"then
carr_ccod="100,101,102"
end if

if pers_ncorr="99187"then
carr_ccod="820"
end if

'A partir del año 2014 se solicitó diferenciación de docentes por sedes para diferentes periodos, por eso dependiendo de la fecha se mostrara las sedes que correspondan
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
sedes_filtro = "1"  

'if v_mes_actual = 6 and v_dia_actual >= 2 and v_dia_actual <= 15 then
'  sedes_filtro = "1,4"
'elseif v_mes_actual = 6 and v_dia_actual >= 16 and v_dia_actual <= 17 then
'  sedes_filtro = "1,4,9"  
'elseif v_mes_actual = 6 and v_dia_actual >= 18 and v_dia_actual <= 21 then
'  sedes_filtro = "9"  
'end if

if v_mes_actual = 10 and v_dia_actual >= 11 and v_dia_actual <= 31 then
	sedes_filtro = "1,4,9"  
end if
if v_mes_actual = 11 and v_dia_actual >= 1 and v_dia_actual <= 30 then
	sedes_filtro = "1,4,9"  
end if
if v_mes_actual = 12 and v_dia_actual >= 1 and v_dia_actual <= 28 then
	sedes_filtro = "1,4,9"  
end if

'fin del filtro sedes
'"select asig_tdesc,b.asig_ccod from asignaturas a, secciones b, bloques_horarios c, bloques_profesores d"& vbCrLf &_
'"where a.asig_ccod=b.asig_ccod"& vbCrLf &_
'"and b.secc_ccod=c.secc_ccod"& vbCrLf &_
'"and b.peri_ccod=214"& vbCrLf &_
'"and c.bloq_ccod=d.bloq_ccod"& vbCrLf &_
'"and d.pers_ncorr="&pers_ncorr&""& vbCrLf &_
'"group by b.asig_ccod,asig_tdesc order by asig_tdesc"

'f_encuesta.Siguiente
 'while f_secciones.siguiente
 'asig_ccod=f_asignatura.ObtenerValor("asig_ccod")  
' wend



cd = CHR(34)
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>- Encuesta Universidad del Pac&iacute;fico</title>
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
	font-size: 12pt;
	font-weight:normal;
	color: #FF7F00;
}
.Estilo31 {
	font-size: 10pt;
	font-family: Arial, Helvetica, sans-serif;
}
.Estilo34 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }
.Estilo35 {
	font-weight: bold;
	font-size: 16px;
	font-style: italic;
	color: #000000;
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




<script type="text/javascript">

function ir(valor,valor2)
{
valor3=<%=pers_ncorr%>

window.location=("asignaturas.asp?pers_ncorr="+valor+"&carr_ccod="+valor2+"&dirpers="+valor3+"")

}
function vovler()
{

valor2=<%=pers_ncorr%>;
window.location=("menu_salida.asp")
}
</script>
</head>

<body>
<!--<p align="center" class="Estilo35">&quot;Encuesta Egresados de RR PP&quot;</p>-->
<p align="center"><span class="Estilo34">  </span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion">
<input type="hidden" name="encu[0][pers_ncorr]" value="<%=pers_ncorr%>">

<table width="700" border="0" cellpadding="0" cellspacing="0">

<tr>
	<td width="25" height="24" background="images/lado_izquierda.jpg" align="right"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" aling="left" width="646">
		<table width="763" border="0" align="left" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
		  
			<td width="723" align="left">
				<table width="298">
					<tr>
						<td align="center">
							<p class="Estilo35">VICERRECTORÍA ACADÉMCIA DIRECCIÓN DE DOCENCIA</p>
						</td>
					</tr>
				</table>
				<br />
				<table width="654" align="center">
					<tr>
						<td align="center">
							<p class="Estilo35"><strong>CUESTIONARIO DE   EVALUACI&Oacute;N DOCENTE</strong></p>
						</td>
					</tr>
				</table>
					<br /> 
					<br />


			    <table width="90%" border="0" bgcolor="#FFFFFF" align="center">
                  <tr>
                    <td class="Estilo31" >Bienvenido(a)  Sr(a) </td>
                    <td width="81%" align="left" class="Estilo31"><strong><%=nombre%></strong></td>
                  </tr>
                  <tr>
                    <td class="Estilo31" width="19%">Periodo Academico</td>
                    <td class="Estilo31" align="left"><strong><%=peri%></strong></td>
                  </tr>
			      </table>
			  <br/>
			  <hr align="left" width="100%" size="1" noshade="noshade" />
				
				<p class="Estilo27">Haga clic en el icono <strong>secciones</strong> para Evaluar al Docente  </p>
				
				<table width="100%" >
				
			   <tr>
			    <td colspan="2"><strong>Docentes</strong></td>
				</tr>
				
				
				<%
				
					
					
					set f_docentes = new CFormulario
					f_docentes.Carga_Parametros "tabla_vacia.xml", "tabla"
					f_docentes.Inicializar conexion

					consulta_sec ="select d.pers_ncorr,pers_tape_paterno+' '+pers_tnombre as nombre from asignaturas a, secciones b, bloques_horarios c, bloques_profesores d,carreras e,personas f"& vbCrLf &_
									"where a.asig_ccod=b.asig_ccod"& vbCrLf &_
									"and b.secc_ccod=c.secc_ccod"& vbCrLf &_
									"and b.peri_ccod in ("&peri_ccod2&")"& vbCrLf &_
									"and c.bloq_ccod=d.bloq_ccod"& vbCrLf &_
									"and b.carr_ccod in ("&carr_ccod&")"& vbCrLf &_
									"and b.carr_ccod=e.carr_ccod"& vbCrLf &_
									"and d.pers_ncorr=f.pers_ncorr"& vbCrLf &_
									"and b.sede_ccod in ("&sedes_filtro&") "& vbCrLf &_
									"and tpro_ccod=1"& vbCrLf &_
									"group by d.pers_ncorr,pers_tnombre,pers_tape_paterno order by nombre"
					'response.Write(consulta_sec)
					f_docentes.Consultar consulta_sec
					
					conta=0
				%>
				
				<%while f_docentes.Siguiente%>
				
				<%conta=conta+1
				pers_ncorr_do=f_docentes.ObtenerValor("pers_ncorr")
				'carr_ccod="800,8"
					consul_completa="select count(distinct b.secc_ccod) from asignaturas a, secciones b, bloques_horarios c, bloques_profesores d,carreras e"& vbCrLf &_
					"where a.asig_ccod=b.asig_ccod"& vbCrLf &_
					"and b.secc_ccod=c.secc_ccod"& vbCrLf &_
					"and b.peri_ccod in ("&peri_ccod2&")"& vbCrLf &_
					"and c.bloq_ccod=d.bloq_ccod"& vbCrLf &_
					"and d.pers_ncorr="&pers_ncorr_do&""& vbCrLf &_
					"and b.carr_ccod=e.carr_ccod"& vbCrLf &_
					"and b.carr_ccod in("&carr_ccod&")"& vbCrLf &_
					"and tpro_ccod=1"& vbCrLf &_
					"and b.secc_ccod not in (select secc_ccod from dir_encuesta_docente_hhrr ff where ff.pers_ncorr=d.pers_ncorr)"
					'response.Write("<br>"&consul_completa)
					completados=conexion.ConsultaUno(consul_completa)
					'response.Write(evaluada)
					
				'if completados<>"0" then
				btn2="<a class='example7' href="& cd &"javascript:ir('"&pers_ncorr_do&"','"&carr_ccod&"')"& cd &";><img src="&""&"Images/ver.png"&""&" border="&""&"0"&""&" width="&""&"65"&""&" height="&""&"65"&""&" alt="&""&"VOLVER AL HOME"&""&"></a>"
				edit="&nbsp;"
				'else
				'btn2="<img src="&""&"Images/listo4.png"&""&" border="&""&"0"&""&" width="&""&"80"&""&" height="&""&"70"&""&" alt="&""&"VOLVER AL HOME"&""&">"
				'edit="<a href="& cd &"javascript:ir('"&pers_ncorr_do&"','"&carr_ccod&"')"& cd &";><img src="&""&"Images/editar.png"&""&" border="&""&"0"&""&" width="&""&"65"&""&" height="&""&"65"&""&" alt="&""&"VOLVER AL HOME"&""&"></a>"
				'end if	
				%>
				
				 <%if conta=1 then%>
				 <tr align="center">
				 <%end if%>
				 <%if conta=2 then%>
				 
				 <%end if%>
					 <td>
					 <table align="center" width="100%">
						<tr>
							<td width="50%" align="left"><%=f_docentes.ObtenerValor("nombre")%></td>
							<td width="25%" align="left"><%=btn2%></td>
							<td width="25%" align="left"><%=edit%></td>
						</tr>
					 </table>
					</td>
					
			
				<% if conta=2 then
					conta=0
					end if
				%>
				<%wend%>
				</tr>
				<tr>
				<td>&nbsp; </td>
				</tr>
				
				</table>
				<table width="100%">
			   <tr>
			   <td width="36%" align="rigth" valign="top" class="Estilo31"></td>
					
				
					<td width="10%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:vovler();">
												
						<img src="Images/salir.png" border="0" width="65" height="65" alt="¿Cómo funciona?"></td>
					
					<td width="11%" align="center" valign="top"></td>
						<td width="43%" align="left" valign="top" class="Estilo31">&nbsp;</td>
				  </tr>
			  </table>
			    <br />
			
				<br />
				<hr size="1" noshade="noshade" />
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

</form>
<p align="center"><strong>&nbsp;<span class="Estilo45">&iexcl;Muchas gracias por  tu colaboraci&oacute;n! </span></strong><span class="Estilo45"><br />
  
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
</tr>
</table>
</body>

</html>
