<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=opiniones_alumnos.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pers_ncorr = request.QueryString("pers_ncorr")
secc_ccod = request.QueryString("secc_ccod")

fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")

set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

consulta = "  select distinct pers_ncorr,parte_2_observaciones,parte_3_observaciones,parte_4_observaciones,parte_5_observaciones "& vbCrLf &_
           "  from cuestionario_opinion_alumnos "& vbCrLf &_
           "  where cast(secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
           "  and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr&"' and isnull(estado_cuestionario,0)=2 "
'response.Write(consulta)
sede = conexion.consultaUno("Select sede_tdesc from secciones a, sedes b where a.sede_ccod=b.sede_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
carrera = conexion.consultaUno("Select carr_tdesc from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
jornada = conexion.consultaUno("Select jorn_tdesc from secciones a, jornadas b where a.jorn_ccod=b.jorn_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
asignatura = conexion.consultaUno("Select b.asig_ccod  + ' -- ' + asig_tdesc from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
seccion = conexion.consultaUno("Select secc_tdesc from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
docente = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas a where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'")
'total_x_profesor = conexion.consultaUno("select cast(avg(puntaje_total) as decimal(9,8)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr&"' and isnull(estado_cuestionario,0) = 2 ")
'nivel_profesor = ""
'total_x_profesor = cdbl(total_x_profesor)
'if total_x_profesor <= cdbl(3.54) then 
'	nivel_profesor = "INSUFICIENTE"
'elseif total_x_profesor >= cdbl(5.35)  then
'	nivel_profesor = "BUENO"
'else
'	nivel_profesor = "SATISFACTORIO"
'end if


f_listado.Consultar consulta

%>
<html>
<head>
<title>Listado Observaciones Alumnos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="5"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Opinión de los alumnos hacia el curso</font></div>
      <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="5">&nbsp;</td>
  </tr>
  <tr> 
    <td width="10%"><strong>Fecha</strong></td>
    <td width="90%" colspan="4"><strong>:</strong> <%=fecha_01%></td>
  </tr>
   <tr> 
    <td width="10%"><strong>Sede</strong></td>
    <td width="90%" colspan="4"><strong>:</strong> <%=sede%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Carrera</strong></td>
    <td width="90%" colspan="4"><strong>:</strong> <%=carrera%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Jornada</strong></td>
    <td width="90%" colspan="4"><strong>:</strong> <%=jornada%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Asignatura</strong></td>
    <td width="90%" colspan="4"><strong>:</strong> <%=asignatura%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Sección</strong></td>
    <td width="90%" colspan="4"><strong>:</strong> <%=seccion%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Profesor</strong></td>
    <td width="90%" colspan="4"><strong>:</strong> <%=docente%></td>
  </tr>  
  <!--<tr> 
    <td width="10%"><strong>Puntaje</strong></td>
    <td width="90%" colspan="4"><strong>:</strong> <%=total_x_profesor%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Nivel</strong></td>
    <td width="90%" colspan="4"><strong>:</strong> <%=nivel_profesor%></td>
  </tr>-->

</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2%" bgcolor="#99FF99"><div align="center"><strong>N°</strong></div></td>
    <td bgcolor="#99FF99"><div align="center"><strong>Comentario Dimensión 1</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>Comentario Dimensión 2</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>Comentario Dimensión 3</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>Comentario Dimensión 4</strong></div></td>
  </tr>
  
  <%  fila = 1
    while f_listado.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("parte_2_observaciones")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("parte_3_observaciones")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("parte_4_observaciones")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("parte_5_observaciones")%></div></td>
  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>