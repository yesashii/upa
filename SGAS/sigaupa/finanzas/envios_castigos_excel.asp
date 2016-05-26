<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:GESTIÓN DE DOCUMENTOS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:12/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:85 - 93
'********************************************************************
Response.AddHeader "Content-Disposition", "attachment;filename=documentos_castigados.xls"
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
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'------------------------------------------------------------------------------------
set f_envio = new CFormulario
f_envio.Carga_Parametros "Envios_Notaria.xml", "f_envios"
f_envio.Inicializar conexion

consulta = "SELECT envios.eenv_ccod, envios.envi_ncorr, envios.envi_fenvio, envios.inen_ccod, "& vbCrLf &_
         "instituciones_envio.inen_tdesc,cuentas_corrientes.ccte_tdesc   "& vbCrLf &_
         "FROM envios, instituciones_envio, cuentas_corrientes "& vbCrLf &_
         "WHERE envios.inen_ccod = instituciones_envio.inen_ccod "& vbCrLf &_
		 "AND envios.ccte_ccod = cuentas_corrientes.ccte_ccod "& vbCrLf &_
         "AND envios.envi_ncorr = " & folio_envio 
		 
 f_envio.Consultar consulta
 f_envio.siguiente

 '------------------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "Envios_Notaria.xml", "excel"
f_detalle_envio.Inicializar conexion

		  
'consulta = "SELECT a.envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ," & vbCrLf &_
'			"    b.ding_ndocto,  protic.total_recepcionar_cuota (ab.tcom_ccod ,ab.inst_ccod,ab.comp_ndocto,ab.dcom_ncompromiso) as ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago,  " & vbCrLf &_
'			"    convert(varchar,c.ding_fdocto,103)  as ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  " & vbCrLf &_
'			"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado," & vbCrLf &_
'			"     c.ding_ndocto as numero_documento, "& vbCrLf &_
'			"    protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado " & vbCrLf &_
'			"FROM envios a, detalle_envios b, detalle_ingresos c, estados_detalle_ingresos c1,  " & vbCrLf &_
'			"ingresos d, personas e, personas f, abonos ab   " & vbCrLf &_
'			"WHERE a.envi_ncorr = b.envi_ncorr  " & vbCrLf &_
'			"and b.ting_ccod = c.ting_ccod  " & vbCrLf &_
'			"and b.ding_ndocto = c.ding_ndocto  " & vbCrLf &_
'			"and b.ingr_ncorr = c.ingr_ncorr  " & vbCrLf &_
'			"and c.ingr_ncorr = d.ingr_ncorr  " & vbCrLf &_
'			"and b.edin_ccod = c1.edin_ccod  " & vbCrLf &_
'			"and d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
'			"and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr  " & vbCrLf &_
'			"and a.envi_ncorr='" & folio_envio & "' " & vbCrLf &_
'			" and c.ting_ccod=4 "& vbCrLf &_
'			" and ab.ingr_ncorr=d.ingr_ncorr "& vbCrLf &_
'			"ORDER BY  nombre_apoderado, b.ding_ndocto"

consulta = "SELECT a.envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ," & vbCrLf &_
			"    b.ding_ndocto,  protic.total_recepcionar_cuota (ab.tcom_ccod ,ab.inst_ccod,ab.comp_ndocto,ab.dcom_ncompromiso) as ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago,  " & vbCrLf &_
			"    convert(varchar,c.ding_fdocto,103)  as ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  " & vbCrLf &_
			"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado," & vbCrLf &_
			"     c.ding_ndocto as numero_documento, "& vbCrLf &_
			"    protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado " & vbCrLf &_
			"FROM envios a INNER JOIN detalle_envios b " & vbCrLf &_
			"ON a.envi_ncorr = b.envi_ncorr and a.envi_ncorr='" & folio_envio & "' " & vbCrLf &_
			"INNER JOIN detalle_ingresos c " & vbCrLf &_
			"ON b.ting_ccod = c.ting_ccod and b.ding_ndocto = c.ding_ndocto and b.ingr_ncorr = c.ingr_ncorr and c.DING_NCORRELATIVO = 1 and c.ting_ccod in (3,4,14,38) " & vbCrLf &_
			"INNER JOIN ingresos d " & vbCrLf &_
			"ON c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
			"INNER JOIN estados_detalle_ingresos c1 " & vbCrLf &_
			"ON b.edin_ccod = c1.edin_ccod " & vbCrLf &_
			"INNER JOIN personas e " & vbCrLf &_
			"ON d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
			"LEFT OUTER JOIN personas f " & vbCrLf &_
			"ON c.PERS_NCORR_CODEUDOR = f.pers_ncorr " & vbCrLf &_
			"INNER JOIN abonos ab " & vbCrLf &_
			"ON ab.ingr_ncorr=d.ingr_ncorr "& vbCrLf &_
			"ORDER BY  nombre_apoderado, b.ding_ndocto"
			  
'response.Write("<pre>"&consulta&"</pre>")
f_detalle_envio.Consultar consulta

%>
<html>
<head>
<title> Detalle Documentos a Castigar</title>
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
    <td><strong>:</strong> <% =f_envio.DibujaCampo("envi_ncorr") %> </td>
    <td><div align="left"><font size="2"> </font></div></td>
    <td><strong>Fecha</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("envi_fenvio") %> </td>
  </tr>
  <tr> 
    <td><strong>Banco</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("inen_tdesc") %> </td>
    <td>&nbsp;</td>
    <td><strong>Cta. Cte</strong></td>
    <td><% f_envio.DibujaCampo("ccte_tdesc") %></td>
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
    
	<td width="20%"><div align="center"><strong>N&ordm; Documento </strong></div></td>
	<td width="20%"><div align="center"><strong>Banco</strong></div></td>
    <td width="20%"><div align="center"><strong>Estado</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="16%"><div align="center"><strong>Rut Apoderado</strong></div></td>
    <td width="11%"><div align="center"><strong>Apoderado</strong></div></td>
    <td width="14%"><div align="center"><strong>Fecha Emisi&oacute;n</strong></div></td>
    <td width="14%"><div align="center"><strong>Fecha Vencimiento</strong> </div></td>
    <td width="19%"><div align="center"><strong>Monto </strong></div></td>
  </tr>
  <%  while f_detalle_envio.Siguiente %>
  <tr> 
  
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("numero_documento")%></div></td>
	<td><div align="center"><%=f_detalle_envio.ObtenerValor("banco")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("edin_tdesc")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_apoderado")%></div></td>
    <td><%=f_detalle_envio.ObtenerValor("nombre_apoderado")%></td>
    <td><div align="center">&nbsp;<%=f_detalle_envio.ObtenerValor("ingr_fpago")%></div></td>
    <td><div align="center">&nbsp;<%=f_detalle_envio.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="right"><%=f_detalle_envio.ObtenerValor("ding_mdocto")%></div></td>
  </tr>
    <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>