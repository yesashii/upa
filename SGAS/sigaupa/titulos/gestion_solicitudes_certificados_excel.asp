<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

Response.AddHeader "Content-Disposition", "attachment;filename=solicitudes_certificados.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

fecha=conexion.consultaUno("select getDate() as fecha")
'------------------------------------------------------------------------------------

set f_solicitudes = new CFormulario
f_solicitudes.Carga_Parametros "tabla_vacia.xml", "tabla"
f_solicitudes.Inicializar conexion
		   
consulta = " select a.tctg_ccod,a.sctg_ncorr,a.pers_ncorr,protic.initCap(tctg_tdesc)as tipo,d.sede_tdesc as sede ,sctg_fsolicitud as fecha_solicitud, "& vbCrLf &_ 
			" protic.trunc(sctg_fmodificacion) as actualizado, c.esctg_tdesc as estado, "& vbCrLf &_ 
			" lower(observacion) as observacion,sctg_fsolicitud, protic.initCap(carr_tdesc) as carrera,  "& vbCrLf &_ 
			" cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as alumno,  "& vbCrLf &_
			" g.pers_tape_paterno + ' ' + g.pers_tape_materno + ', ' + g.pers_tnombre as actualizador  "& vbCrLf &_ 
			" from solicitud_certificados_tyg a, tipos_certificados_tyg b,estados_solicitud_certificados_tyg c, sedes d, carreras e,personas f, personas g "& vbCrLf &_ 
			" where a.tctg_ccod=b.tctg_ccod and a.esctg_ccod=c.esctg_ccod and a.carr_ccod=e.carr_ccod COLLATE SQL_Latin1_General_CP1_CI_AS  "& vbCrLf &_ 
			" and a.sede_ccod=d.sede_ccod and a.pers_ncorr=f.pers_ncorr "& vbCrLf &_ 
			" and a.ESCTG_CCOD <> 7 and a.audi_tusuario = cast(g.pers_nrut as varchar) "& vbCrLf &_ 
			" order by sctg_fsolicitud,carrera, alumno, tipo desc " 
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_solicitudes.Consultar consulta
%>
<html>
<head>
<title>Listado solicitudes de certificados</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado Solicitudes de certificados</font></div></td>
 </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =fecha%> </td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fecha Solicitud</strong></div></td>
    <td><div align="center"><strong>Carrera</strong></div></td>
	<td><div align="center"><strong>Rut</strong></div></td>
	<td><div align="center"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>Tipo Certificado</strong></div></td>
	<td><div align="center"><strong>Sede Destino</strong></div></td>
	<td><div align="center"><strong>Estado</strong></div></td>
	<td><div align="center"><strong>Observación</strong></div></td>
	<td><div align="center"><strong>Fecha modificación</strong></div></td>
	<td><div align="center"><strong>Actualizado por</strong></div></td>
  </tr>
  <%  while f_solicitudes.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_solicitudes.ObtenerValor("fecha_solicitud")%></div></td>
    <td><div align="center"><%=f_solicitudes.ObtenerValor("carrera")%></div></td>
    <td><div align="center"><%=f_solicitudes.ObtenerValor("rut")%></div></td>
	 <td><div align="center"><%=f_solicitudes.ObtenerValor("alumno")%></div></td>
    <td><div align="left"><%=f_solicitudes.ObtenerValor("tipo")%></div></td>
    <td><div align="center"><%=f_solicitudes.ObtenerValor("sede")%></div></td>
    <td><div align="center"><%=f_solicitudes.ObtenerValor("estado")%></div></td>
    <td><div align="center"><%=f_solicitudes.ObtenerValor("observacion")%></div></td>
    <td><div align="center"><%=f_solicitudes.ObtenerValor("actualizado")%></div></td>
	<td><div align="center"><%=f_solicitudes.ObtenerValor("actualizador")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>