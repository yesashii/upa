<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=carpetas_titulo.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")

set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

consulta =  "  select cast(c.pers_nrut as varchar)+ '-' + c.pers_xdv as rut, "& vbCrLf &_
			" c.pers_tnombre + ' ' + c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno, "& vbCrLf &_
			" b.carr_tdesc as carrera,(select pers_tnombre + ' ' + pers_tape_paterno from personas p1 where p1.pers_nrut = a.enviada_por) as enviada_por, "& vbCrLf &_
			" protic.trunc(fecha_envio)as fecha_envio, "& vbCrLf &_
			" (select pers_tnombre + ' ' + pers_tape_paterno from personas p2 where p2.pers_nrut = a.recepcionada_por) as recepcionada_por, "& vbCrLf &_
			" protic.trunc(fecha_recepcion)as fecha_recepcion,observacion "& vbCrLf &_
			" from carpetas_titulo a, carreras b, personas c "& vbCrLf &_
			" where a.pers_ncorr=c.pers_ncorr and a.carr_ccod=b.carr_ccod "
			
f_listado.Consultar consulta

%>
<html>
<head>
<title>Listado De Carpetas de Títulos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="9"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Carpetas de Título</font></div>
      <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="9">&nbsp;</td>
  </tr>
  <tr> 
    <td width="10%"><strong>Fecha</strong></td>
    <td width="90%" colspan="9"><strong>:</strong> <%=fecha_01%></td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2%" bgcolor="#99FF99"><div align="center"><strong>N°</strong></div></td>
    <td width="5%" bgcolor="#99FF99"><div align="center"><strong>RUT ALUMNO</strong></div></td>
	<td width="15%" bgcolor="#99FF99"><div align="center"><strong>NOMBRE ALUMNO</strong></div></td>
	<td width="15%" bgcolor="#99FF99"><div align="center"><strong>CARRERA</strong></div></td>
	<td width="10%" bgcolor="#99FF99"><div align="center"><strong>ENVIADA POR</strong></div></td>
	<td width="5%" bgcolor="#99FF99"><div align="center"><strong>FECHA ENVIO A ESCUELA</strong></div></td>
	<td width="10%" bgcolor="#99FF99"><div align="center"><strong>RECEPCIONADA POR</strong></div></td>
	<td width="5%" bgcolor="#99FF99"><div align="center"><strong>FECHA DEVOLUCIÓN A TÍTULOS Y GRADOS</strong></div></td>
	<td width="33%" bgcolor="#99FF99"><div align="center"><strong>OBSERVACIÓN</strong></div></td>
  </tr>
  
  <%  fila = 1
    while f_listado.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("RUT")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("alumno")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("enviada_por")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("fecha_envio")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("recepcionada_por")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("fecha_recepcion")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("observacion")%></div></td>
  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>