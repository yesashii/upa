<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_otec.asp"-->

<%
'response.Write("uuuu")

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores



q_pers_nrut=negocio.obtenerUsuario

pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&q_pers_nrut&")")

		   

set f_programas = new CFormulario
f_programas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_programas.Inicializar conexion
'pers_ncorr=23921
if cdbl(pers_ncorr)=153207 then
consulta="select  a.dgso_ncorr,b.dcur_ncorr,dcur_tdesc"& vbCrLf &_
"from postulacion_otec a,"& vbCrLf &_
"datos_generales_secciones_otec b,"& vbCrLf &_
"diplomados_cursos c "& vbCrLf &_
"where a.dgso_ncorr=b.dgso_ncorr "& vbCrLf &_
"and epot_ccod=4 "& vbCrLf &_
"and b.dcur_ncorr=c.dcur_ncorr"& vbCrLf &_
"and pers_ncorr="&pers_ncorr&""
else

consulta="select  a.dgso_ncorr,b.dcur_ncorr,dcur_tdesc"& vbCrLf &_
"from postulacion_otec a,"& vbCrLf &_
"datos_generales_secciones_otec b,"& vbCrLf &_
"diplomados_cursos c "& vbCrLf &_
"where a.dgso_ncorr=b.dgso_ncorr "& vbCrLf &_
"and epot_ccod=4 "& vbCrLf &_
"and b.dcur_ncorr=c.dcur_ncorr"& vbCrLf &_
"and esot_ccod=3"& vbCrLf &_
"and pers_ncorr="&pers_ncorr&""
end if



f_programas.Consultar consulta
' wend
response.Write("<br>"&consulta)


'f_encuesta.Siguiente
 'while f_secciones.siguiente
 'asig_ccod=f_asignatura.ObtenerValor("asig_ccod")  
' wend
'response.Write("<pre>"&consulta&"</pre>")

'response.End()
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

function irEvaluacionRelator(valor)
{
window.location=("modulos.asp?dcur_ncorr="+valor+"")

}
function irEvaluacionPrograma(valor)
{
window.location=("encuesta_programa.asp?dcur_ncorr="+valor+"")

}
function vovler()
{


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
							<p class="Estilo35"><strong>CUESTIONARIOS DE OPINIÓN</strong></p>
						</td>
					</tr>
				</table>
					
			  <hr align="left" width="100%" size="1" noshade="noshade" />
				
				<p class="Estilo31"><strong>Seleccione una Evaluaci&oacute;n para comenzar. </strong></p>
				
				<table width="100%" >
				
				<%cont=0
				while f_programas.Siguiente
				
				 								
							Sel_relatores_a_evaluar="select count(*)"& vbCrLf &_
							"from(select g. pers_ncorr"& vbCrLf &_
							"from diplomados_cursos a,"& vbCrLf &_
							"mallas_otec b,"& vbCrLf &_
							"modulos_otec c,"& vbCrLf &_
							"secciones_otec d,"& vbCrLf &_
							"bloques_horarios_otec e,"& vbCrLf &_
							"bloques_relatores_otec f,"& vbCrLf &_
							"personas g"& vbCrLf &_
							"where a.dcur_ncorr=b.dcur_ncorr "& vbCrLf &_
							"and b.mote_ccod=c.mote_ccod"& vbCrLf &_
							"and a.dcur_ncorr="&f_programas.ObtenerValor("dcur_ncorr")&""& vbCrLf &_
							"and b.maot_ncorr=d.maot_ncorr"& vbCrLf &_
							"and d.seot_ncorr=e.seot_ncorr"& vbCrLf &_
							"and e.bhot_ccod=f.bhot_ccod"& vbCrLf &_
							"and f.pers_ncorr=g.pers_ncorr"& vbCrLf &_
							"group by mote_tdesc,d.seot_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre,g.pers_ncorr,dcur_tdesc)a"
							
							sel_relatores_evaluados="select count(*)"& vbCrLf &_
							"from(select g.seot_ncorr, pers_ncorr_alumno,pers_ncorr_relator"& vbCrLf &_
							"from diplomados_cursos a,"& vbCrLf &_
							"mallas_otec b,"& vbCrLf &_
							"modulos_otec c,"& vbCrLf &_
							"secciones_otec d,"& vbCrLf &_
							"bloques_horarios_otec e,"& vbCrLf &_
							"bloques_relatores_otec f,"& vbCrLf &_
							"ENCU_RELATOR_OTEC g"& vbCrLf &_
							"where a.dcur_ncorr=b.dcur_ncorr "& vbCrLf &_
							"and b.mote_ccod=c.mote_ccod"& vbCrLf &_
							"and a.dcur_ncorr="&f_programas.ObtenerValor("dcur_ncorr")&""& vbCrLf &_
							"and b.maot_ncorr=d.maot_ncorr"& vbCrLf &_
							"and d.seot_ncorr=e.seot_ncorr"& vbCrLf &_
							"and e.bhot_ccod=f.bhot_ccod"& vbCrLf &_
							"and d.seot_ncorr=g.seot_ncorr"& vbCrLf &_
							"and g.pers_ncorr_alumno="&pers_ncorr&""& vbCrLf &_
							"group by g.seot_ncorr, pers_ncorr_alumno,pers_ncorr_relator)d"
							
						existe_evaluacion_programa=conexion.ConsultaUno("select count(*) from encu_programa_otec where  pers_ncorr_alumno="&pers_ncorr&" and dcur_ncorr="&f_programas.ObtenerValor("dcur_ncorr")&"")	
							
							relatores_a_evaluar=conexion.ConsultaUno(Sel_relatores_a_evaluar)
							relatores_evaluados=conexion.ConsultaUno(sel_relatores_evaluados)
				dgso_ncorr=f_programas.ObtenerValor("dgso_ncorr")
				cantidad_docentes_programa=conexion.ConsultaUno("select sum(seot_ncantidad_relator) from secciones_otec  where dgso_ncorr="&dgso_ncorr&" group by dgso_ncorr")
				
				'response.Write("<pre>"&Sel_relatores_a_evaluar&"</pre>")
				'response.Write("<pre>"&sel_relatores_evaluados&"</pre>")
				'response.End()
				'response.Write("<pre>"&relatores_a_evaluar&"</pre>")
				'response.Write("<pre>"&relatores_evaluados&"</pre>")
				response.Write("<pre>"&cantidad_docentes_programa&"</pre>")
			
				
				if cdbl(relatores_a_evaluar)=cdbl(relatores_evaluados) then
				btn2="<img src="&""&"Images/listo4.png"&""&" border="&""&"0"&""&" width="&""&"80"&""&" height="&""&"70"&""&" alt="&""&"VOLVER AL HOME"&""&">"
				else
				btn2="<a href="&""&"javascript:irEvaluacionRelator("&f_programas.ObtenerValor("dcur_ncorr")&");"&""&">"& vbCrLf &_
				"<img src="&""&"Images/evaluar3.png"&""&" border="&""&"0"&""&" width="&""&"65"&""&" height="&""&"65"&""&" alt="&""&"VOLVER AL HOME"&""&">"
				end if
				
				if existe_evaluacion_programa="0" then
				btn="<a href="&""&"javascript:irEvaluacionPrograma("&f_programas.ObtenerValor("dcur_ncorr")&");"&""&">"& vbCrLf &_
				"<img src="&""&"Images/evaluar3.png"&""&" border="&""&"0"&""&" width="&""&"65"&""&" height="&""&"65"&""&" alt="&""&"VOLVER AL HOME"&""&">"
				else
				btn="<img src="&""&"Images/listo4.png"&""&" border="&""&"0"&""&" width="&""&"80"&""&" height="&""&"70"&""&" alt="&""&"VOLVER AL HOME"&""&">"
				end if		
				%>
				<% if cdbl(relatores_a_evaluar)=cdbl(cantidad_docentes_programa) then
				cont=cont+1%>
					
				<tr>
			    <td colspan="2" valign="top"><strong>Programa: <%=f_programas.ObtenerValor("dcur_tdesc")%></strong></td>
				</tr>
				 <tr align="center">
				 	<td width="50%">
					 <table align="center" width="100%">
						<tr>
							<td width="35%" valign="top">Evaluar Programa </td>
							<td width="65%" align="left"><%=btn%></td>
						</tr>
					 </table>
					</td>
					<td width="50%">
					 <table align="center" width="100%">
						<tr>
							<td width="34%" valign="top">Evaluar Docentes </td>
							<td width="66%" align="left"><%=btn2%></td>
						</tr>
					 </table>
					</td>
				</tr>
				<%end if%>
				<%response.Write(cont)%>
				<%wend%>
			
				
				<%
				if cont=0 then%>
				<tr align="center">
				 	<td width="100%" colspan="2">
					 <table align="center" width="100%">
						<tr>
						<td width="20%">&nbsp;</td>
						<td width="10%" height="138"><img src="Images/falta.png""&"images/falta.png"&""&" border="&""&"0"&""&" width="114""&"80"&""&" height="110""&"70"&""&" alt="&""&"volver al home"&""&"></td>
						<td width="70%" valign="middle" style="color:#FF0033">El o los Programas a Evaluar no tienes sus docentes Habilitados </td>
						</tr>
					 </table>
					</td>
				</tr>
				<%end if%>
				</table>
				<table width="100%">
			   <tr>
			   <td width="36%" align="rigth" valign="top" class="Estilo31"></td>
					
				
					<td width="10%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:vovler();">
												
						<img src="Images/salir.png" border="0" width="65" height="65" alt="¿Cómo funciona?">					</td>
					
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
