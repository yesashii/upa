<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_deposito.xls"
Response.ContentType = "application/vnd.ms-excel"

'-----------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'------------------------------------------------------------------------------------
set f_envio = new CFormulario
f_envio.Carga_Parametros "Depositos.xml", "f_datos"
f_envio.Inicializar conexion
consulta = "SELECT  a.envi_ncorr, a.eenv_ccod, b.eenv_tdesc, a.envi_fenvio, a.tdep_ccod, d.tdep_tdesc , a.inen_ccod, c.inen_tdesc, e.ccte_tdesc   "&_
           "FROM envios a, "&_ 
			   "estados_envio b, "&_ 
			   "instituciones_envio c, "&_
			   "tipos_depositos d, "&_ 
			   "cuentas_corrientes e "&_ 
			"WHERE a.eenv_ccod = b.eenv_ccod "&_ 
			  "and a.inen_ccod = c.inen_ccod "&_
			  "and a.tdep_ccod = d.tdep_ccod "&_ 
			  "and a.ccte_ccod = e.ccte_ccod "&_ 
			  "and a.envi_ncorr =" & folio_envio 
 f_envio.Consultar consulta
 f_envio.siguiente

 '------------------------------------------------------------------------------------

set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "Depositos.xml", "f_detalle_deposito"
f_detalle_envio.Inicializar conexion

 consulta = "SELECT a.envi_ncorr, a.envi_ncorr as c_envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr, "&_ 
                   "b.ding_ndocto, to_number(c.ding_mdetalle) as ding_mdetalle, d.ingr_fpago, c.ding_tcuenta_corriente,  "&_
				   "c.ding_fdocto, c1.edin_tdesc,  "&_
				   "g1.pers_nrut || '-' || g1.pers_xdv as rut_apoderado,  "&_
				   "g1.pers_tnombre || ' ' || g1.pers_tape_paterno as nombre_apoderado   "&_
			"FROM envios a,  "&_
				 "detalle_envios b,  "&_
				 "detalle_ingresos c,  "&_
				 "estados_detalle_ingresos c1, "&_ 
				 "ingresos d,  "&_
				 "personas e,  "&_
				 "postulantes f,  "&_
				 "codeudor_postulacion g,  "&_
				 "personas g1  "&_
			"WHERE a.envi_ncorr = b.envi_ncorr  "&_
				  "and b.ting_ccod = c.ting_ccod  "&_
				  "and b.ding_ndocto = c.ding_ndocto  "&_
				  "and b.ingr_ncorr = c.ingr_ncorr  "&_
				  "and c.ingr_ncorr = d.ingr_ncorr  "&_
				  "and b.edin_ccod = c1.edin_ccod  "&_
				  "and d.pers_ncorr = e.pers_ncorr  "&_
				  "and e.pers_ncorr = f.pers_ncorr  "&_
				  "and f.post_ncorr = g.post_ncorr  "&_
				  "and g.pers_ncorr = g1.pers_ncorr  "&_
				  "and a.envi_ncorr =" & folio_envio
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
    <td><strong>N&ordm; Dep&oacute;sito</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("envi_ncorr") %> </td>
    <td><div align="left"><font size="2"> </font></div></td>
    <td><strong>Fecha</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("envi_fenvio") %> </td>
  </tr>
  <tr> 
    <td><strong>Banco</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("inen_tdesc") %> </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><strong>Cta. Cte</strong></td>
    <td><strong>:</strong> 
      <% =f_envio.DibujaCampo("ccte_tdesc") %>
    </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><strong>Tipo Dep&oacute;sito</strong></td>
    <td> <strong>:</strong> 
      <% =f_envio.DibujaCampo("tdep_tdesc") %>
    </td>
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

<p>&nbsp;</p><table width="114%" border="1">
  <tr> 
    <td width="9%"><div align="center"><strong>N&ordm; Cheque</strong></div></td>
    <td width="20%"><div align="center"><strong>Fecha Vencimiento</strong></div></td>
    <td width="16%"><div align="center"><strong>Cta. Cte.</strong></div></td>
    <td width="16%"><div align="center"><strong>Rut Titular</strong></div></td>
    <td width="11%"><div align="center"><strong>Titular</strong></div></td>
    <td width="19%"><div align="center"><strong>Monto</strong></div></td>
  </tr>
  <%  while f_detalle_envio.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_ndocto")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_tcuenta_corriente")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_apoderado")%></div></td>
    <td><%=f_detalle_envio.ObtenerValor("nombre_apoderado")%></td>
    <td><div align="right"><%=f_detalle_envio.ObtenerValor("ding_mdetalle")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>