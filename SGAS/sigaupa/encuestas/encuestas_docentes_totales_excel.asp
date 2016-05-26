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
		   "  pe1.pers_tape_paterno + ' ' + pe1.pers_tape_materno + ', ' + pe1.pers_tnombre as alumno_encuestado, "& vbCrLf &_
		   "  pe2.pers_tape_paterno + ' ' + pe2.pers_tape_materno + ', ' + pe2.pers_tnombre as PROFESOR,observaciones, puntaje_total "& vbCrLf &_
		   "  from evaluacion_docente a, secciones b, sedes c , carreras d, jornadas e, asignaturas f,personas pe1,personas pe2, periodos_academicos pea "& vbCrLf &_
		   "  where a.peri_ccod in (select peri_Ccod from periodos_academicos where cast(anos_ccod as varchar)= '"&anos_ccod&"') "& vbCrLf &_
		   "  and a.secc_ccod=b.secc_ccod and b.sede_ccod=c.sede_ccod "& vbCrLf &_
		   "  and b.carr_ccod=d.carr_ccod and b.jorn_ccod=e.jorn_ccod "& vbCrLf &_
		   "  and b.asig_ccod=f.asig_ccod and a.pers_ncorr_encuestado = pe1.pers_ncorr "& vbCrLf &_
		   "  and a.pers_ncorr_destino = pe2.pers_ncorr and a.peri_ccod = pea.peri_ccod "& vbCrLf &_
		   "  and cast(b.sede_ccod as varchar)='"&sede_ccod&"' and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"' and b.carr_ccod = '"&carr_ccod&"' "& vbCrLf &_
		   "  order by periodo, sede,carrera, jornada, asignatura, sección, PROFESOR "

f_listado.Consultar consulta
'response.Write(consulta)
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
	<td bgcolor="#99FF99"><div align="center"><strong>ALUMNO ENCUESTADO</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PROFESOR</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>OPINIÓN ALUMNO</strong></div></td>
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
	<td><div align="left"><%=f_listado.ObtenerValor("alumno_encuestado")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("PROFESOR")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("observaciones")%></div></td>	
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