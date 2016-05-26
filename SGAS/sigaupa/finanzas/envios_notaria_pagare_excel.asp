<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_envios_pagare.xls"
Response.ContentType = "application/vnd.ms-excel"

'------------------------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
empresa_envio = request.QueryString("empresa_envio")
fecha = request.QueryString("fecha")

for each k in request.QueryString()
 response.Write(k&" = "&request.QueryString(k)&"<br>")
next

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

SQL = "SELECT INEN_TDESC FROM INSTITUCIONES_ENVIO WHERE INEN_CCOD="&empresa_envio

nombre = conexion.consultauno(sql)

response.write nombre


 '------------------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "edicion_envios_pagare.xml", "excel"
f_detalle_envio.Inicializar conexion

consulta = "SELECT e.ENVI_NCORR,"& vbCrLf &_
			"	di.DING_NDOCTO,"& vbCrLf &_
			"	di.DING_NDOCTO AS DING_NDOCTO2,"& vbCrLf &_
			"	edi.EDIN_TDESC,"& vbCrLf &_
			"	protic.obtener_rut(p.PERS_NCORR) as rut_alumno,"& vbCrLf &_
			"	protic.obtener_rut(di.pers_ncorr_codeudor) as rut_apoderado,"& vbCrLf &_
			"	protic.obtener_nombre_completo(di.pers_ncorr_codeudor,'n') AS nombre_apoderado,"& vbCrLf &_
			"	e.ENVI_FENVIO,"& vbCrLf &_
			"	di.DING_MDOCTO,"& vbCrLf &_
			" 	di.DING_FDOCTO"& vbCrLf &_
			"	FROM DETALLE_INGRESOS di"& vbCrLf &_
			"	INNER JOIN INGRESOS i"& vbCrLf &_
			"		ON i.INGR_NCORR = di.INGR_NCORR"& vbCrLf &_
			"	INNER JOIN DETALLE_ENVIOS de"& vbCrLf &_
			"		ON de.DING_NDOCTO = di.DING_NDOCTO AND de.INGR_NCORR=di.INGR_NCORR"& vbCrLf &_
			"	INNER JOIN ENVIOS e"& vbCrLf &_
			"		ON de.ENVI_NCORR=e.ENVI_NCORR"& vbCrLf &_
			"	INNER JOIN ESTADOS_ENVIO ee"& vbCrLf &_
			"		ON ee.EENV_CCOD = e.EENV_CCOD"& vbCrLf &_
			"	INNER JOIN PERSONAS p"& vbCrLf &_
			"		ON p.PERS_NCORR = i.PERS_NCORR"& vbCrLf &_
			"	INNER JOIN ESTADOS_DETALLE_INGRESOS edi"& vbCrLf &_
			"		ON edi.EDIN_CCOD=de.EDIN_CCOD"& vbCrLf &_
			"	WHERE e.ENVI_NCORR=" & folio_envio
response.write consulta
f_detalle_envio.Consultar consulta

%>
<html>
<head>
<title>Detalle Envio a Cobranza</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td width="10%">&nbsp;</td>
    <td width="34%">&nbsp;</td>
  </tr>
  <tr> 
    <td><strong>N&ordm; Folio</strong></td>
    <td><strong>:</strong> <%=folio_envio%></td>
    <td><div align="left"><font size="2"> </font></div></td>
    <td><strong>Fecha</strong></td>
    <td><strong>:</strong> <%=fecha%> </td>
  </tr>
  <tr> 
    <td><strong>Empresa</strong></td>
    <td><strong>:</strong> <%=nombre%> </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%">&nbsp;</td>
    <td width="26%">&nbsp;</td>
    <td width="14%"><div align="left"><font size="2"> </font></div></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<table width="114%" border="1">
  <%  while f_detalle_envio.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_detalle_envio.dibujatabla%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>