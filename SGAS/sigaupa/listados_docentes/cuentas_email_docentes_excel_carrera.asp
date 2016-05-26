<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=resumen_escuelas.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

sede_ccod   =   request.QueryString("sede_ccod")
carr_ccod   =   request.QueryString("carr_ccod")
jorn_ccod   =   request.QueryString("jorn_ccod")
anos_ccod   =   request.QueryString("anos_ccod")

usuario = negocio.obtenerUsuario
es_administrativo = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=1 and cast(a.pers_nrut as varchar)='"&usuario&"'")

sede=conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
carrera=conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
jornada=conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
fecha_01=conexion.consultaUno("select getDate()")

set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

consulta = " select distinct pea.anos_ccod,i.facu_tdesc as facultad,f.sede_tdesc as sede, "& vbcrlf & _
		   " g.carr_tdesc as carrera, j.jorn_tdesc as jornada,   "& vbcrlf & _
		   " cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' + d.pers_tape_materno as docente, "& vbcrlf & _
		   " e.susu_tlogin as login, e.susu_tclave as clave, "& vbcrlf & _
		   " (select lower(email_upa) from sd_cuentas_email_totales tt where tt.pers_ncorr=e.pers_ncorr) as email_upa, "& vbcrlf & _
		   " lower(d.pers_temail) as email_personal "& vbcrlf & _
		   " from secciones a, bloques_horarios b, bloques_profesores c, personas d,sis_usuarios e, "& vbcrlf & _
		   "      sedes f, carreras g, areas_academicas h, facultades i, jornadas j, periodos_academicos pea "& vbcrlf & _
		   " where a.secc_ccod=b.secc_ccod and b.bloq_ccod=c.bloq_ccod "& vbcrlf & _
		   " and c.tpro_ccod=1 and c.pers_ncorr=d.pers_ncorr "& vbcrlf & _
		   " and a.sede_ccod=f.sede_ccod and a.carr_ccod=g.carr_ccod and g.area_ccod=h.area_ccod and h.facu_ccod=i.facu_ccod "& vbcrlf & _
		   " and a.jorn_ccod=j.jorn_ccod and c.tpro_ccod=1 "& vbcrlf & _
		   " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' and a.carr_ccod ='"&carr_ccod&"' and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"' and a.jorn_ccod=j.jorn_ccod "& vbcrlf & _
		   " and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"' and d.pers_ncorr=e.pers_ncorr "& vbcrlf & _
		   " order by facultad, sede, carrera, jornada  "
		   
f_listado.Consultar consulta
%>
<html>
<head>
<title>Listado cuentas docente escuela</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado Cuentas Docente Escuela</font></div>
      <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="10%"><strong>Año</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=anos_ccod%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Sede</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=sede%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Carrera</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=carrera%></td>
  </tr>
   <tr> 
    <td width="10%"><strong>Jornada</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=jornada%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Fecha</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td bgcolor="#FFFFCC"><div align="left"><strong>N°</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>AÑO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>FACULTAD</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>SEDE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CARRERA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>JORNADA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>RUT</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>NOMBRE DOCENTE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>EMAIL UNIVERSIDAD</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>EMAIL PARTICULAR</strong></div></td>
    <%if es_administrativo="SI" then%>
    <td bgcolor="#FFFFCC"><div align="left"><strong>USUARIO SGA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CLAVE ACCESO</strong></div></td>
    <%end if%>
  </tr>
  
  <%  fila = 1
    while f_listado.Siguiente %>
  <tr> 
   	<td><div align="left"><%=fila%></div></td>
    <td><div align="left"><%=f_listado.ObtenerValor("anos_ccod")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("facultad")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_listado.ObtenerValor("jornada")%></div></td>
    <td><div align="left"><%=f_listado.ObtenerValor("rut")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("docente")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("email_upa")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("email_personal")%></div></td>
    <%if es_administrativo="SI" then%>
    <td><div align="left"><%=f_listado.ObtenerValor("login")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("clave")%></div></td>
    <%end if%>
  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>