<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=encuesta_docentes_totales_excel.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

sede_ccod = request.QueryString("sede_ccod")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
anos_ccod = request.QueryString("anos_ccod")

'sede_ccod = "1"
'carr_ccod = "45"
'jorn_ccod = "1"

fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")
'peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
'anos_ccod=conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

consulta = "  select  distinct pea.peri_tdesc as periodo, sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, f.asig_ccod as cod_asignatura, "& vbCrLf &_
		   "  asig_tdesc as asignatura, secc_tdesc as sección, "& vbCrLf &_
		   "  pe1.pers_ncorr as alumno_encuestado, "& vbCrLf &_
		   "  pe2.pers_tape_paterno + ' ' + pe2.pers_tape_materno + ', ' + pe2.pers_tnombre as PROFESOR,parte_2_observaciones,parte_3_observaciones,parte_4_observaciones,parte_5_observaciones, cast(puntaje_total as decimal(5,4)) as puntaje_total "& vbCrLf &_
		   "  from cuestionario_opinion_alumnos a, secciones b, sedes c , carreras d, jornadas e, asignaturas f,personas pe1,personas pe2, periodos_academicos pea "& vbCrLf &_
		   "  where a.secc_ccod=b.secc_ccod and b.peri_ccod in (select peri_Ccod from periodos_academicos where cast(anos_ccod as varchar)= '"&anos_ccod&"') "& vbCrLf &_
		   "  and b.sede_ccod=c.sede_ccod and isnull(estado_cuestionario,0) = 2 "& vbCrLf &_
		   "  and b.carr_ccod=d.carr_ccod and b.jorn_ccod=e.jorn_ccod "& vbCrLf &_
		   "  and b.asig_ccod=f.asig_ccod and a.pers_ncorr = pe1.pers_ncorr "& vbCrLf &_
		   "  and a.pers_ncorr_profesor = pe2.pers_ncorr and b.peri_ccod = pea.peri_ccod and b.peri_ccod >= 212 "& vbCrLf &_
		   "  and cast(b.sede_ccod as varchar)='"&sede_ccod&"' and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"' and b.carr_ccod = '"&carr_ccod&"' "& vbCrLf &_
		   "  order by periodo, sede,carrera, jornada, asignatura, sección, PROFESOR "
'response.Write("<pre>"&consulta&"</pre>")

f_listado.Consultar consulta
'response.End()
%>
<html>
<head>
<title>Resultados Evaluación Docente por Alumnos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="12"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resultados Evaluación Docente por Alumnos</font></div>
      <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="12">&nbsp;</td>
  </tr>
  <tr> 
    <td width="6%"><strong>Fecha</strong></td>
    <td width="94%" colspan="11"><strong>:</strong> <%=fecha_01%></td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td bgcolor="#99FF99"><div align="center"><strong>N°</strong></div></td>
    <td bgcolor="#99FF99"><div align="center"><strong>PERIODO</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>SEDE</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>CARRERA</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>JORNADA</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>CÓD.ASIGNATURA</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>ASIGNATURA</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>SECCIÓN</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PROFESOR</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>OPINIÓN DIMENSION 1</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>OPINIÓN DIMENSION 2</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>OPINIÓN DIMENSION 3</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>OPINIÓN DIMENSION 4</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PUNTAJE TOTAL</strong></div></td>
  </tr>
  
  <%  fila = 1
    while f_listado.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("periodo")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("jornada")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("cod_asignatura")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("asignatura")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("sección")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("PROFESOR")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("parte_2_observaciones")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("parte_3_observaciones")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("parte_4_observaciones")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("parte_5_observaciones")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("puntaje_total")%></div></td>	
  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>