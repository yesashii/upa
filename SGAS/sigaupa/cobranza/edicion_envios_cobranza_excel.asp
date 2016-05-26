<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_envios_cobranza.xls"
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

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")


 '------------------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "edicion_envios_cobranza.xml", "excel"
f_detalle_envio.Inicializar conexion

 consulta = "SELECT  a.envi_ncorr, b.ting_ccod,d1.ting_tdesc, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ,b.ding_ndocto, c.ding_mdocto, d.ingr_fpago, "& vbCrLf &_
                " c.ding_fdocto, c1.edin_tdesc, protic.format_rut(e.pers_nrut) as rut_alumno, "& vbCrLf &_
		        " protic.format_rut(g1.pers_nrut) as rut_apoderado, "& vbCrLf &_
		        " g1.pers_tnombre + ' ' + g1.pers_tape_paterno as nombre_apoderado  "& vbCrLf &_
		   "FROM envios a, "& vbCrLf &_
				"detalle_envios b, "& vbCrLf &_
				"detalle_ingresos c, "& vbCrLf &_
				"estados_detalle_ingresos c1, "& vbCrLf &_
				"ingresos d, "& vbCrLf &_
				"tipos_ingresos d1, "& vbCrLf &_
				"personas e, "& vbCrLf &_
				"postulantes f, "& vbCrLf &_
				"codeudor_postulacion g, "& vbCrLf &_
				"personas g1 "& vbCrLf &_
				
		   "WHERE a.envi_ncorr = b.envi_ncorr "& vbCrLf &_
			  "and b.ting_ccod = c.ting_ccod "& vbCrLf &_
			  "and c.ting_ccod = d1.ting_ccod "& vbCrLf &_
			  "and b.ding_ndocto = c.ding_ndocto "& vbCrLf &_
			  "and b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
			  "and c.ingr_ncorr = d.ingr_ncorr "& vbCrLf &_
			  "and c.edin_ccod = c1.edin_ccod "& vbCrLf &_
			  "and c.repa_ncorr is null "& vbCrLf &_
		      "and c.ding_ncorrelativo = 1 "& vbCrLf &_
			  "and d.pers_ncorr = e.pers_ncorr "& vbCrLf &_
			  "and e.pers_ncorr = f.pers_ncorr "& vbCrLf &_
			  "and f.post_ncorr = g.post_ncorr "& vbCrLf &_
			  "and g.pers_ncorr = g1.pers_ncorr "& vbCrLf &_
			  "and cast(f.peri_ccod as varchar)='" & Periodo & "'"& vbCrLf &_
			  "AND cast(a.envi_ncorr as varchar)='" & folio_envio&"'"



f_detalle_envio.Consultar consulta

%>
<html>
<head>
<title> Detalle Envio a Notaria</title>
<meta http-equiv="Content-Type" content="text/html;">
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
    <td><strong>:</strong> <%=empresa_envio%> </td>
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
  <tr> 
    <td width="9%"><div align="center"><strong>N&ordm; Documento</strong></div></td>
    <td width="20%" align="center"><strong>Tipo</strong> </td>
    <td width="20%"><div align="center"><strong>Estado</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="16%"><div align="center"><strong>Rut Apoderado</strong></div></td>
    <td width="11%"><div align="center"><strong>Apoderado</strong></div></td>
    <td width="14%"><div align="center"><strong>Fecha Emisi&oacute;n</strong></div></td>
    <td width="19%"><div align="center"><strong>Monto Letra</strong></div></td>
  </tr>
  <%  while f_detalle_envio.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_ndocto")%></div></td>
    <td align="center"><%=f_detalle_envio.ObtenerValor("ting_tdesc")%></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("edin_tdesc")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_apoderado")%></div></td>
    <td align="center"><%=f_detalle_envio.ObtenerValor("nombre_apoderado")%></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ingr_fpago")%></div></td>
    <td><div align="right"><%=f_detalle_envio.ObtenerValor("ding_mdocto")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>