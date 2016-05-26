<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION				:
'FECHA CREACIÓN				:
'CREADO POR 				:
'ENTRADA					:NA
'SALIDA						:NA
'MODULO QUE ES UTILIZADO	:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:06/02/2013
'ACTUALIZADO POR		:Luis Herrera G.
'MOTIVO					:Corregir código, eliminar sentencia *=
'LINEA					:71, 72
'********************************************************************

Response.AddHeader "Content-Disposition", "attachment;filename=detalle_deposito.xls"
Response.ContentType = "application/vnd.ms-excel"

'-----------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'------------------------------------------------------------------------------------
set f_envio = new CFormulario
f_envio.Carga_Parametros "Depositos.xml", "f_datos"
f_envio.Inicializar conexion
consulta = " SELECT  a.envi_mefectivo,a.envi_ncorr, a.eenv_ccod, b.eenv_tdesc, a.envi_fenvio,"& vbCrLf &_
			" a.tdep_ccod, d.tdep_tdesc , a.inen_ccod, c.inen_tdesc, e.ccte_tdesc,c.banc_ccod   "& vbCrLf &_
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
f_detalle_envio.Carga_Parametros "Depositos.xml", "f_detalle_deposito_excel"
f_detalle_envio.Inicializar conexion

 
' consulta = "select b.ding_ndocto ,c.banc_ccod, sum(cast(isnull(c.ding_mdocto,c.ding_mdetalle) as numeric)) as ding_mdocto, max(c.ding_fdocto) as ding_fdocto, max(g.banc_tdesc) as banc_tdesc,"& vbCrLf &_
'			" max(cast(f.pers_nrut as varchar)) + '-' + max(f.pers_xdv) as rut_apoderado, "& vbCrLf &_
'			" max(cast(f.pers_tnombre as varchar)) + ' ' + max(f.pers_tape_paterno) as nombre_apoderado "& vbCrLf &_
'			"    from envios a,detalle_envios b,detalle_ingresos c,ingresos d,estados_detalle_ingresos c1,"& vbCrLf &_
'			"        personas f,bancos g"& vbCrLf &_
'			"    where a.envi_ncorr = b.envi_ncorr"& vbCrLf &_
'			"    and b.ting_ccod = c.ting_ccod  "& vbCrLf &_
'			"    and b.ingr_ncorr = c.ingr_ncorr"& vbCrLf &_
'			"    and c.ingr_ncorr = d.ingr_ncorr  "& vbCrLf &_
'			"    and b.edin_ccod = c1.edin_ccod"& vbCrLf &_
'			"    and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr"& vbCrLf &_
'			"    and c.banc_ccod *= g.banc_ccod"& vbCrLf &_
'			"    and c.DING_NCORRELATIVO = 1"& vbCrLf &_
'			"    and a.envi_ncorr=" & folio_envio& vbCrLf &_
'		"  Group by b.ding_ndocto,c.banc_ccod,c.DING_tcuenta_corriente  "& vbCrLf &_
'		" Order by c.banc_ccod, b.ding_ndocto asc "
consulta = "select b.ding_ndocto , "& vbCrLf &_
		"	c.banc_ccod, "& vbCrLf &_
		"	sum(cast(isnull(c.ding_mdocto,c.ding_mdetalle) as numeric)) as ding_mdocto, "& vbCrLf &_
		"	max(c.ding_fdocto) as ding_fdocto, "& vbCrLf &_
		"	max(g.banc_tdesc) as banc_tdesc, "& vbCrLf &_
		"	max(cast(f.pers_nrut as varchar)) + '-' + max(f.pers_xdv) as rut_apoderado, "& vbCrLf &_
		"	max(cast(f.pers_tnombre as varchar)) + ' ' + max(f.pers_tape_paterno) as nombre_apoderado "& vbCrLf &_ 
		"from envios a "& vbCrLf &_
		"join detalle_envios b "& vbCrLf &_
		"	on a.envi_ncorr = b.envi_ncorr "& vbCrLf &_
		"join detalle_ingresos c "& vbCrLf &_
		"	on b.ting_ccod = c.ting_ccod "& vbCrLf &_ 
		"	and b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
		"join ingresos d "& vbCrLf &_
		"	on c.ingr_ncorr = d.ingr_ncorr "& vbCrLf &_
		"join estados_detalle_ingresos c1 "& vbCrLf &_
		"	on b.edin_ccod = c1.edin_ccod "& vbCrLf &_
		"left outer join personas f "& vbCrLf &_
		"	on c.PERS_NCORR_CODEUDOR = f.pers_ncorr "& vbCrLf &_
		"left outer join bancos g "& vbCrLf &_
		"	on c.banc_ccod = g.banc_ccod "& vbCrLf &_
		"where c.DING_NCORRELATIVO = 1 "& vbCrLf &_
		"	and a.envi_ncorr = " & folio_envio& vbCrLf &_ 
		"Group by b.ding_ndocto,c.banc_ccod,c.DING_tcuenta_corriente "& vbCrLf &_ 
		"Order by c.banc_ccod, b.ding_ndocto asc"
	
'	"    and b.ding_ndocto = c.ding_ndocto  "& vbCrLf &_
			  
	'response.Write("<pre>"&consulta&"</pre>")			
f_detalle_envio.Consultar consulta
cantidad=f_detalle_envio.nroFilas
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
    <td><strong>Cantidad cheques</strong></td>
    <td><%=cantidad%></td>
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

<p>&nbsp;</p>
<table width="114%" border="1">
  <tr> 
    <td width="9%"><div align="center"><strong>N&ordm; Cheque</strong></div></td>
    <td width="20%"><div align="center"><strong>Fecha Vencimiento</strong></div></td>
    <td width="16%"><div align="center"><strong>C.B.</strong></div></td>
	<td width="16%"><div align="center"><strong>Banco</strong></div></td>
    <td width="16%"><div align="center"><strong>Rut Titular</strong></div></td>
    <td width="11%"><div align="center"><strong>Titular</strong></div></td>
    <td width="19%"><div align="center"><strong>Monto</strong></div></td>
  </tr>
  <%  while f_detalle_envio.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_ndocto")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_fdocto")%></div></td>
	<td><div align="left"><%=f_detalle_envio.ObtenerValor("banc_ccod")%></div></td>
    <td><div align="left"><%=f_detalle_envio.ObtenerValor("banc_tdesc")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_apoderado")%></div></td>
    <td><%=f_detalle_envio.ObtenerValor("nombre_apoderado")%></td>
    <td><div align="right"><%=f_detalle_envio.ObtenerValor("ding_mdocto")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>