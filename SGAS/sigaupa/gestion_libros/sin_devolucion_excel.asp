<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=excel_sin_devolución.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("Planificacion")
fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
peri = conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1")
'----------------------------declaramos los filtros que se seleccionaron para reducir resultados

set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

consulta = " select n.sede_tdesc as sede,e.carr_tdesc as carrera,ltrim(rtrim(f.asig_ccod))+' --> '+ f.asig_tdesc as asignatura, "& vbcrlf & _
		   " d.secc_tdesc as seccion,i.sala_tdesc +' - ' + j.sede_tdesc as sala,k.hora_tdesc as modulo, "& vbcrlf & _
		   " cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut, pers_tnombre + ' '+ pers_tape_paterno + ' ' + pers_tape_materno as profesor, "& vbcrlf & _
		   " case b.libr_ncorr when null then 'Sin crear' else l.esli_tdesc end as estado, "& vbcrlf & _
		   " protic.trunc(pres_fprestamo) as fecha_prestamo, "& vbcrlf & _
		   " h.dias_ccod,h.dias_tdesc as dia,cast(datepart(hh,m.hora_hinicio) as varchar)+':'+cast(datepart(mi,m.hora_hinicio) as varchar)+'--'+cast(datepart(hh,m.hora_htermino) as varchar)+':'+cast(datepart(mi,m.hora_htermino) as varchar) as horario_clases, "& vbcrlf & _
		   " 'No se registra la devolución del libro' as observacion "& vbcrlf & _
		   " from personas a,libros_clases b, prestamos_libros c,secciones d,carreras e,asignaturas f,bloques_horarios g,  "& vbcrlf & _
		   "      dias_semana h,salas i, sedes j,horarios k,estado_libros l,horarios_sedes m,sedes n  "& vbcrlf & _
		   " where a.pers_ncorr=b.pers_ncorr  "& vbcrlf & _
		   " and b.libr_ncorr=c.libr_ncorr and c.pres_fdevolucion is null and c.pres_estado_devolucion is null  "& vbcrlf & _
		   " and b.secc_ccod=d.secc_ccod  "& vbcrlf & _
		   " and d.carr_ccod=e.carr_ccod  "& vbcrlf & _
		   " and d.asig_ccod=f.asig_ccod  "& vbcrlf & _
		   " and c.bloq_ccod=g.bloq_ccod  "& vbcrlf & _
		   " and g.dias_ccod=h.dias_ccod  "& vbcrlf & _
		   " and g.sala_ccod=i.sala_ccod  "& vbcrlf & _
		   " and i.sede_ccod=j.sede_ccod  "& vbcrlf & _
		   " and g.hora_ccod=k.hora_ccod  "& vbcrlf & _
		   " and d.sede_ccod=n.sede_ccod "& vbcrlf & _
		   " and g.hora_ccod=m.hora_ccod and d.sede_ccod=m.sede_ccod  "& vbcrlf & _
		   " and case isnull(cast(c.pres_estado_devolucion as varchar),'--') when '--' then 2 else isnull(b.libr_nestado,1) end = l.esli_ccod  "& vbcrlf & _
		   " and cast(d.peri_ccod as varchar)= case f.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end  "& vbcrlf & _
		   " order by h.dias_ccod,modulo  "
   

'response.Write("<pre>"&consulta&"</pre>")
f_listado.Consultar consulta
%>
<html>
<head>
<title>Listado prestamos sin devolución</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">LISTADO DE PRESTAMOS SIN DEVOLUCIÓN</font></div>
      <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="10%"><strong>Fecha</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td bgcolor="#FFFFCC"><div align="left"><strong>N°</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>SEDE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CARRERA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>ASIGNATURA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>SECCIÓN</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>SALA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>MÓDULO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PROFESOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>ESTADO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>FECHA PRÉSTAMO</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>DÍA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>HORARIO CLASES</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>OBSERVACIÓN</strong></div></td>
  </tr>
  
  <%  fila = 1
    while f_listado.Siguiente %>
  <tr> 
   	<td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("asignatura")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("seccion")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("sala")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("modulo")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("rut")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("profesor")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("estado")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("fecha_prestamo")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("dia")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("horario_clases")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("observacion")%></div></td>
  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>