<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'Response.AddHeader "Content-Disposition", "attachment;filename=listado_de_profesores_breve.xls"
'Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
'peri_ccod=request.QueryString("peri_ccod")
'tcar_ccod=request.QueryString("tcar_ccod")
'tido_ccod=request.QueryString("tido_ccod")
'jorn_ccod=request.QueryString("jorn_ccod")
'------------------------------------------------------------------------------------


'--------------------------------listado general de docentes (datos reales)--------------------------------



'peri_ccod="&peri_ccod&"
'tcar_ccod=1
'tido_ccod=1
'tcar_tdesc=conexion.ConsultaUno("select tcar_tdesc from tipos_carrera where tcar_ccod="&tcar_ccod&"")
'tido_tdesc=conexion.ConsultaUno("select tido_tdesc from tipos_docente where tido_ccod="&tido_ccod&"")
'ano=conexion.ConsultaUno("select anos_ccod from periodos_academicos where peri_ccod="&peri_ccod&"")


'peri_ccod=negocio.obtenerPeriodoAcademico("PLANIFICACION")
peri_ccod=210
'response.Write(peri_ccod)
'response.End()

 set f_docentes = new CFormulario
 f_docentes.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes.Inicializar conexion
 'response.End()
profesores= "select   pers_ncorr,pers_nrut,pers_xdv,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,"& vbcrlf & _

"(select  cudo_titulo from curriculum_docente cc where cc.pers_ncorr=aa.pers_ncorr and tiex_ccod=3)as porfesion,"& vbcrlf & _
" (select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))grado_obtenido,"& vbcrlf & _
"(select  protic.obtener_grado_docente_completados(aa.pers_ncorr,'D'))as titulo_grado_obtenido,"& vbcrlf & _
"(select protic.obtener_carrera_docente(aa.pers_ncorr,"&peri_ccod&"))as carreras_en_las_que_hace_clase"& vbcrlf & _
         
"from  personas aa"& vbcrlf & _
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbcrlf & _
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbcrlf & _
"where a.pers_ncorr=b.pers_ncorr "& vbcrlf & _
"and b.bloq_ccod=c.bloq_ccod"& vbcrlf & _
"and c.secc_ccod=d.secc_ccod"& vbcrlf & _
"and a.tpro_ccod='1'"& vbcrlf & _
"and d.peri_ccod="&peri_ccod&""& vbcrlf & _
"and d.carr_ccod=e.carr_ccod"& vbcrlf & _
"and tcar_ccod=1"& vbcrlf & _
"and a.pers_ncorr=f.pers_ncorr"& vbcrlf & _
"and tido_ccod=1"& vbcrlf & _
"and f.anos_ccod=(select anos_ccod from periodos_academicos sss where sss.peri_ccod=d.peri_ccod))"& vbcrlf & _
"or aa.pers_ncorr in (select distinct a.pers_ncorr"& vbcrlf & _
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbcrlf & _
"where a.pers_ncorr=b.pers_ncorr "& vbcrlf & _
"and b.bloq_ccod=c.bloq_ccod"& vbcrlf & _
"and c.secc_ccod=d.secc_ccod"& vbcrlf & _
"and a.tpro_ccod='1'"& vbcrlf & _
"and d.peri_ccod="&peri_ccod&""& vbcrlf & _
"and d.carr_ccod=e.carr_ccod"& vbcrlf & _
"and tcar_ccod=1"& vbcrlf & _
"and a.pers_ncorr=f.pers_ncorr"& vbcrlf & _
"and f.anos_ccod=(select anos_ccod from periodos_academicos sss where sss.peri_ccod=d.peri_ccod)"& vbcrlf & _
"and tido_ccod=3)"& vbcrlf & _
"order by nombre"
'response.Write("<pre>"&profesores&"</pre>")
'response.end()
f_docentes.Consultar profesores
'f_docentes.siguiente
'response.end()




%>

<html>
<head>
<title>Lstado de Docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
<style type="text/css">
<!--
.estilo1 {
font-family: Arial, Helvetica, sans-serif;
font-size: 12px;
color: #003366;
}
.estilo2 {
color: #990000;
font-weight: bold;
}
.estilo3 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #ffffff; }

.estilo4 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #000000; }
-->
</style>

</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
 <tr> 
    <td colspan="2"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Docentes </font></div>
	  <div align="right"></div></td>
  </tr>
 
</table>

<table width="100%" border="1">
    
	<tr borderColor="#999999" bgColor="#c4d7ff">
		<td width="19%"><FONT color="#333333">
	  <div align="center"><strong>Nombre</strong></div></font></td>
		<td width="4%"><FONT color="#333333">
	  <div align="center"><strong>Profesión</strong></div></font></td>
		<td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Grado Académico</strong></div></font></td>
<td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Nombre Grado Academico</strong></div></font></td>
	  <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Carreras en las que imparte Clase</strong></div></font></td>
	  
	</tr>
	<%while f_docentes.siguiente %>
	<tr bgcolor="#FFFFFF">
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("nombre")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("porfesion")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("grado_obtenido")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("titulo_grado_obtenido")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("carreras_en_las_que_hace_clase")%></td>
		
		
	</tr>
	<%wend%>
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>