<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_otec.asp"-->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
dcur_ncorr=request.QueryString("dcur_ncorr")
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

'pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&q_pers_nrut&")")
consulta = " select ''" 
'dcur_ncorr=86		   
		   

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_encabezado.Consultar consulta
f_encabezado.Siguiente

set f_modulos = new CFormulario
f_modulos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_modulos.Inicializar conexion
'pers_ncorr=23921
consulta = "select c.mote_ccod, mote_tdesc "& vbCrLf &_
"from diplomados_cursos a,"& vbCrLf &_
"mallas_otec b,"& vbCrLf &_
"modulos_otec c"& vbCrLf &_
"where a.dcur_ncorr=b.dcur_ncorr"& vbCrLf &_
"and b.mote_ccod=c.mote_ccod"& vbCrLf &_
"and a.dcur_ncorr="&dcur_ncorr&""


f_modulos.Consultar consulta
rut_alumn=negocio.ObtenerUsuario
' wend


'f_encuesta.Siguiente
 'while f_secciones.siguiente
 'asig_ccod=f_asignatura.ObtenerValor("asig_ccod")  
' wend
'response.Write("<pre>"&consulta&"</pre>")

'response.End()
dirpers=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&negocio.obtenerUsuario&")")
dcurr_tdesc=conexion.ConsultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&dcur_ncorr&"")
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

<script language="JavaScript">

function ir(valor,valor2,valor3)
{
window.location=("encuesta.asp?dcurr_ncorr="+valor+"&pers_ncorr="+valor2+"&seot_ncorr="+valor3+"")

}
function vovler()
{

valor2=<%=dcur_ncorr%>;
window.location=("programas.asp?dcur_ncorr="+valor2+"")
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
<input type="hidden" name="encu[0][carr_ccod]" value="<%=carr_ccod%>">

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
				<br />
				<table width="654" align="center">
					<tr>
						<td align="center">
							<p class="Estilo35"><strong>CUESTIONARIO DE OPINIÓN DOCENTE</strong></p>
						</td>
					</tr>
				</table>
					<br /> 
					<br />


			    <table width="90%" border="0" bgcolor="#FFFFFF" align="center">
                  <tr>
                    <td class="Estilo27" width="17%">Programa</td>
                    <td class="Estilo27" width="2%">:</td>
                    <td width="81%" align="left" class="Estilo27"><strong><%=dcurr_tdesc%></strong></td>
                  </tr>
                 </table>
			  <br/>
			  <hr align="left" width="100%" size="1" noshade="noshade" />
				
				<p class="Estilo31"><strong>Seleccione el Relator a Evaluar</strong> </p>
				
				<table width="100%" >
				<%while f_modulos.Siguiente %>
			   <tr>
			    <td colspan="2" valign="top"><strong>M&oacute;dulo: <%=f_modulos.ObtenerValor("mote_tdesc")%></strong></td>
				</tr>
				
				
				<%
				 		
				
					mote_ccod=f_modulos.ObtenerValor("mote_ccod")
					
					set f_relatores = new CFormulario
					f_relatores.Carga_Parametros "tabla_vacia.xml", "tabla"
					f_relatores.Inicializar conexion

					consulta_sec = "select c.mote_ccod,d.seot_ncorr,g.pers_ncorr,mote_tdesc,a.dcur_ncorr,d.seot_ncorr,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre"& vbCrLf &_
									"from diplomados_cursos a,"& vbCrLf &_
									"mallas_otec b,"& vbCrLf &_
									"modulos_otec c,"& vbCrLf &_
									"secciones_otec d,"& vbCrLf &_
									"bloques_horarios_otec e,"& vbCrLf &_
									"bloques_relatores_otec f,"& vbCrLf &_
									"personas g"& vbCrLf &_
									"where a.dcur_ncorr=b.dcur_ncorr "& vbCrLf &_
									"and b.mote_ccod=c.mote_ccod"& vbCrLf &_
									"and a.dcur_ncorr="&dcur_ncorr&""& vbCrLf &_
									"and b.maot_ncorr=d.maot_ncorr"& vbCrLf &_
									"and d.seot_ncorr=e.seot_ncorr"& vbCrLf &_
									"and e.bhot_ccod=f.bhot_ccod"& vbCrLf &_
									"and f.pers_ncorr=g.pers_ncorr"& vbCrLf &_
									"and c.mote_ccod='"&mote_ccod&"'"& vbCrLf &_
									"group by  c.mote_ccod,mote_tdesc,d.seot_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre,g.pers_ncorr,a.dcur_ncorr"& vbCrLf &_
									"order by mote_tdesc,nombre"
				'response.Write("<pre>"&consulta_sec&"</pre>")
					f_relatores.Consultar consulta_sec
					
					conta=0
				%>
				
				<%while f_relatores.Siguiente%>
				
				<%conta=conta+1
				

				seccion=f_relatores.ObtenerValor("secc_ccod")
				'response.Write("<pre>"&rut_alumn&"</pre>")
pers_ncorr_alums=conexion.ConsultaUno("select pers_ncorr from personas where pers_nrut="&rut_alumn&"")
'response.Write("<pre>"&pers_ncorr_alums&"</pre>")
				'response.Write("<br>pers_ncorr_alumno= "&pers_ncorr_alumno)
					evaluada=conexion.ConsultaUno("select count(*) from ENCU_RELATOR_OTEC where pers_ncorr_relator="&f_relatores.ObtenerValor("pers_ncorr")&" and pers_ncorr_alumno="&pers_ncorr_alums&" and seot_ncorr="&f_relatores.ObtenerValor("seot_ncorr")&"")
					'response.Write("<br>"&evaluada)
				
				
				if evaluada="0" then
				btn2="<a href="&""&"javascript:ir("&f_relatores.ObtenerValor("dcur_ncorr")&","&f_relatores.ObtenerValor("pers_ncorr")&","&f_relatores.ObtenerValor("seot_ncorr")&");"&""&">"& vbCrLf &_
				"<img src="&""&"Images/evaluar3.png"&""&" border="&""&"0"&""&" width="&""&"65"&""&" height="&""&"65"&""&" alt="&""&"VOLVER AL HOME"&""&">"
				else
				btn2="<img src="&""&"Images/listo4.png"&""&" border="&""&"0"&""&" width="&""&"80"&""&" height="&""&"70"&""&" alt="&""&"VOLVER AL HOME"&""&">"
				end if	
				%>
				
				 <%if conta=1 then%>
				 <tr align="center">
				 <%end if%>
				 <%if conta=2 then%>
				 
				 <%end if%>
					 <td>
					 <table align="center" width="100%">
						<tr>
							<td width="10%" valign="top">Relator</td>
							<td width="45%" valign="top"><%=f_relatores.ObtenerValor("nombre")%></td>
							<td width="45%" align="left"><%=btn2%></td>
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
				<%wend%>
				</table>
				<table width="100%">
			   <tr>
			   <td width="36%" align="rigth" valign="top" class="Estilo31"></td>
					
				
					<td width="10%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:vovler();">
												
						<img src="Images/vovler1.png" border="0" width="65" height="65" alt="¿Cómo funciona?">					</td>
					
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
