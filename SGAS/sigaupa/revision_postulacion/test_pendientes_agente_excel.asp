<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_test_pendientes.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo=negocio.obtenerPeriodoAcademico("Postulacion")
pers_ncorr_agente = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")
rut_agente = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")
peri_tdesc = conexion.consultaUno("select protic.initCap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
nombre_agente = conexion.consultaUno("select protic.initcap(Pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")

set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion

consulta = " select sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, "& vbcrlf & _
 		   " cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, protic.initCap(c.pers_tape_paterno + ' ' + c.pers_tape_materno + ' ' + c.pers_tnombre) as postulante,protic.trunc(d.fecha_entrevista) as fecha_entrevista, "& vbcrlf & _
		   " l.htes_hinicio as hora_entrevista, f.eepo_tdesc as estado_entrevista, "& vbcrlf & _
		   " c.pers_tfono as teléfono, c.pers_tcelular as celular, lower(c.pers_temail) as email, "& vbcrlf & _
		   " (select case count(*) when 0 then 'NO' else 'SI' end from alumnos tt where tt.post_ncorr=b.post_ncorr and emat_ccod=1) as matriculado "& vbcrlf & _
		   " from admi_postulantes_por_agente a, postulantes b, personas_postulante c,observaciones_postulacion d, "& vbcrlf & _
		   " detalle_postulantes e,estado_examen_postulantes f,ofertas_academicas g, sedes h, especialidades i, carreras j, "& vbcrlf & _
		   " jornadas k,horarios_test l "& vbcrlf & _  
		   " where a.pers_ncorr=b.pers_ncorr   "& vbcrlf & _
		   " and a.peri_ccod=b.peri_ccod  "& vbcrlf & _
		   " and b.pers_ncorr=c.pers_ncorr   "& vbcrlf & _
		   " and cast(b.peri_ccod as varchar)='"&periodo&"' "& vbcrlf & _
		   " and cast(a.pers_ncorr_agente as varchar)='"&pers_ncorr_agente&"' "& vbcrlf & _
		   " and b.post_ncorr=e.post_ncorr "& vbcrlf & _
		   " and b.post_ncorr=d.post_ncorr and e.ofer_ncorr=d.ofer_ncorr "& vbcrlf & _
		   " and e.ofer_ncorr=g.ofer_ncorr and g.sede_ccod=h.sede_ccod and g.espe_ccod=i.espe_ccod  "& vbcrlf & _
		   " and i.carr_ccod=j.carr_ccod and g.jorn_ccod=k.jorn_ccod "& vbcrlf & _
		   " and isnull(e.eepo_ccod,1) in (1,4,8) and isnull(e.eepo_ccod,1) = f.eepo_ccod "& vbcrlf & _
		   " and d.htes_ccod=l.htes_ccod "& vbcrlf & _
		   " and convert(datetime,protic.trunc(d.fecha_entrevista),103) < convert(datetime,protic.trunc(getDate()),103) "& vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr)   "


cantidad_encontrados = conexion.consultaUno("select count(*) from ("&consulta&")a")	   
formulario.Consultar consulta & " order by fecha_entrevista desc,postulante asc"


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado Postulantes asociados al agente</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de postulantes de la cartera del agente con test pendiente a la fecha</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Rut agente</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=rut_agente%></td>
   </tr>
   <tr> 
    <td width="16%"><strong>Nombre</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_agente%></td>
   </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=fecha%></td>
   </tr>
   <tr> 
    <td width="16%"><strong>Período</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=peri_tdesc%></td>
   </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
   <tr> 
    <td bgcolor="#66CC66"><div align="center"><strong>Nº</strong></div></td>
	<td bgcolor="#66CC66"><div align="left"><strong>Sede</strong></div></td>
    <td bgcolor="#66CC66"><div align="left"><strong>Carrera</strong></div></td>
	<td bgcolor="#66CC66"><div align="left"><strong>Jornada</strong></div></td>
	<td bgcolor="#66CC66"><div align="left"><strong>Rut</strong></div></td>
    <td bgcolor="#66CC66"><div align="Center"><strong>Nombre Postulante</strong></div></td>
	<td bgcolor="#66CC66"><div align="Center"><strong>Fecha Entrevista</strong></div></td>
	<td bgcolor="#66CC66"><div align="left"><strong>Hora Entrevista</strong></div></td>
    <td bgcolor="#66CC66"><div align="left"><strong>Estado Entrevista</strong></div></td>
	<td bgcolor="#66CC66"><div align="left"><strong>Matriculado</strong></div></td>
	<td bgcolor="#66CC66"><div align="left"><strong>Teléfono</strong></div></td>
	<td bgcolor="#66CC66"><div align="left"><strong>Celular</strong></div></td>
	<td bgcolor="#66CC66"><div align="left"><strong>Email</strong></div></td>
  </tr>
  <% fila = 1   
     while formulario.Siguiente %>

  <tr> 
    <td <%=formulario.ObtenerValor("color")%>><div align="center"><%=fila%></div></td>
    <td <%=formulario.ObtenerValor("color")%>><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
    <td <%=formulario.ObtenerValor("color")%>><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("rut")%></div></td>
    <td <%=formulario.ObtenerValor("color")%>><div align="left"><%=formulario.ObtenerValor("postulante")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("fecha_entrevista")%></div></td>
    <td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("hora_entrevista")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="left"><%=formulario.ObtenerValor("estado_entrevista")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="left"><%=formulario.ObtenerValor("matriculado")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="left"><%=formulario.ObtenerValor("teléfono")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="left"><%=formulario.ObtenerValor("celular")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="left"><%=formulario.ObtenerValor("email")%></div></td>
  </tr>
  <% fila = fila + 1  
  wend %>
</table>
</p> 

</body>
</html>