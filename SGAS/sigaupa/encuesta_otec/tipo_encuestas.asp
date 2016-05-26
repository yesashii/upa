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
dcur_ncorr=request.QueryString("dcur_ncorr")
		   

set f_programas = new CFormulario
f_programas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_programas.Inicializar conexion
'pers_ncorr=23921

consulta="select mote_tdesc,c.mote_ccod,protic.trunc(seot_finicio)as seot_finicio,protic.trunc(seot_ftermino)as seot_ftermino,e.dcur_ncorr,dcur_tdesc"& vbCrLf &_
		"from diplomados_cursos a"& vbCrLf &_
		"join mallas_otec b"& vbCrLf &_
		"on a.dcur_ncorr=b.dcur_ncorr"& vbCrLf &_
		"join modulos_otec c"& vbCrLf &_
		"on b.mote_ccod=c.mote_ccod"& vbCrLf &_
		"join secciones_otec d"& vbCrLf &_
		"on b.maot_ncorr=d.maot_ncorr"& vbCrLf &_
		"join datos_generales_secciones_otec e"& vbCrLf &_
		"on a.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
		"join postulacion_otec f"& vbCrLf &_
		"on e.dgso_ncorr=f.dgso_ncorr"& vbCrLf &_
		"join autoriza_encuesta_otec g"& vbCrLf &_
		"on e.dcur_ncorr=g.dcur_ncorr"& vbCrLf &_
		"and c.mote_ccod=g.mote_ccod"& vbCrLf &_
		"where  pers_ncorr="&pers_ncorr&""& vbCrLf &_
		"and a.dcur_ncorr="&dcur_ncorr&""& vbCrLf &_
		"and epot_ccod in (3,4)"& vbCrLf &_
		"group by mote_tdesc,c.mote_ccod,seot_finicio,seot_ftermino,e.dcur_ncorr,dcur_tdesc"& vbCrLf &_
		"order by e.dcur_ncorr"





f_programas.Consultar consulta
' wend
'response.Write("<br>"&consulta)
eva_pro_infra=conexion.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end as existe from activa_encuesta_infra_progra where dcur_ncorr="&dcur_ncorr&"")

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


window.location=("programas.asp")
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
				relatores_a_evaluar_t=0
				relatores_evaluados_t=0
				while f_programas.Siguiente
				
							mote_ccod=f_programas.ObtenerValor("mote_ccod")
				 			dcur_ncorr=f_programas.ObtenerValor("dcur_ncorr")	
							seot_finicio=f_programas.ObtenerValor("seot_finicio")
							seot_ftermino=f_programas.ObtenerValor("seot_ftermino")
											
							Sel_relatores_a_evaluar="select count(*)"& vbCrLf &_
													"from (select e.pers_ncorr"& vbCrLf &_
													"from modulos_otec b"& vbCrLf &_
													",mallas_otec a"& vbCrLf &_
													",secciones_otec c"& vbCrLf &_ 
													",bloques_horarios_otec d"& vbCrLf &_
													",bloques_relatores_otec e"& vbCrLf &_
													"where a.mote_ccod=b.mote_ccod"& vbCrLf &_
													"and a.maot_ncorr=c.maot_ncorr"& vbCrLf &_
													"and c.seot_ncorr=d.seot_ncorr"& vbCrLf &_
													"and protic.trunc(seot_finicio)='"&seot_finicio&"'"& vbCrLf &_
													"and protic.trunc(seot_ftermino)='"&seot_ftermino&"'"& vbCrLf &_
													"and d.bhot_ccod=e.bhot_ccod"& vbCrLf &_
													"and a.mote_ccod='"&mote_ccod&"'"& vbCrLf &_
													"group by  e.pers_ncorr)aaa"
							
							sel_relatores_evaluados="select count(*)"& vbCrLf &_
													"from (select e.pers_ncorr"& vbCrLf &_
													"from modulos_otec b"& vbCrLf &_
													",mallas_otec a"& vbCrLf &_
													",secciones_otec c "& vbCrLf &_
													",bloques_horarios_otec d"& vbCrLf &_
													",bloques_relatores_otec e"& vbCrLf &_
													",ENCU_RELATOR_OTEC f"& vbCrLf &_
													"where a.mote_ccod=b.mote_ccod"& vbCrLf &_
													"and a.maot_ncorr=c.maot_ncorr"& vbCrLf &_
													"and c.seot_ncorr=d.seot_ncorr"& vbCrLf &_
													"and d.bhot_ccod=e.bhot_ccod"& vbCrLf &_
													"and c.seot_ncorr=f.seot_ncorr"& vbCrLf &_
													"and e.pers_ncorr=f.pers_ncorr_relator"& vbCrLf &_
													"and f.pers_ncorr_alumno="&pers_ncorr&""& vbCrLf &_
													"and a.mote_ccod='"&mote_ccod&"'"& vbCrLf &_
													"group by  e.pers_ncorr)aa"
							
							sel_cantidad_docentes_programa="select sum(seot_ncantidad_relator)"& vbCrLf &_
													"from (select c.mote_ccod,seot_ncantidad_relator" & vbCrLf &_
													"from secciones_otec a, mallas_otec b,autoriza_encuesta_otec c"& vbCrLf &_ 
													"where a.maot_ncorr=b.maot_ncorr" & vbCrLf &_
													"and b.mote_ccod=c.mote_ccod"& vbCrLf &_
													"and b.dcur_ncorr=c.dcur_ncorr"& vbCrLf &_
													"and b.dcur_ncorr="&dcur_ncorr&")aaa"
				
				cantidad_docentes_programa=conexion.ConsultaUno(sel_cantidad_docentes_programa)
													
						existe_evaluacion_programa=conexion.ConsultaUno("select count(*) from encu_programa_otec where  pers_ncorr_alumno="&pers_ncorr&" and dcur_ncorr="&dcur_ncorr&"")	
							
							relatores_a_evaluar=conexion.ConsultaUno(Sel_relatores_a_evaluar)
							relatores_evaluados=conexion.ConsultaUno(sel_relatores_evaluados)
				
					
																
				
			
				
				cont=cont+1	
				relatores_a_evaluar_t=cdbl(relatores_a_evaluar_t)+cdbl(relatores_a_evaluar)
				relatores_evaluados_t=cdbl(relatores_evaluados_t)+cdbl(relatores_evaluados)
				'response.Write("<pre>"&Sel_relatores_a_evaluar&"</pre>")
				'response.Write("<pre>"&sel_relatores_evaluados&"</pre>")
				'response.End()
				'response.Write("<pre>"&relatores_a_evaluar_t&"</pre>")
				
				'response.Write("<pre>"&relatores_evaluados_t&"</pre>")
				'response.Write("<pre>"&cantidad_docentes_programa&"</pre>")
				'response.Write("<pre>"&existe_evaluacion_programa&"</pre>")
				dcur_ncorr_anterior=dcur_ncorr
				wend
				'response.Write("<pre>"&cont&"</pre>")
				
				
				if cdbl(relatores_a_evaluar_t)=cdbl(relatores_evaluados_t) then
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

				
				
				if cdbl(cont)>0 then%>
					
				<tr>
			    <td colspan="2" valign="top"><strong>Programa: <%=f_programas.ObtenerValor("dcur_tdesc")%></strong></td>
				</tr>
				 <tr align="center">
				 <%if eva_pro_infra="S" then%>
				 	<td width="50%">
					 <table align="center" width="100%">
						<tr>
							<td width="35%" valign="top">Evaluar Programa </td>
							<td width="65%" align="left"><%=btn%></td>
						</tr>
					 </table>
					</td>
				<%end if%>
					<td width="50%">
					 <table align="center" width="100%">
						<tr>
							<td width="34%" valign="top">Evaluar Docentes </td>
							<td width="66%" align="left"><%=btn2%></td>
						</tr>
					 </table>
					</td>
				</tr>
				<%end if
				if cdbl(cont)=0 then%>
				<tr align="center">
				 	<td width="100%" colspan="2">
					 <table align="center" width="100%">
						<tr>
						<td width="20%">&nbsp;</td>
						<td width="10%" height="138"><img src="Images/falta.png""&"images/falta.png"&""&" border="&""&"0"&""&" width="114""&"80"&""&" height="110""&"70"&""&" alt="&""&"volver al home"&""&"></td>
						<td width="70%"  align="left"valign="middle" style="color:#FF0033"><font face="Times New Roman, Times, serif" size="+1" ><strong>&nbsp;&nbsp;No hay Programas para evaluar</strong> </font></td>
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
