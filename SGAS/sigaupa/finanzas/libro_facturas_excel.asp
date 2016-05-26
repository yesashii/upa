<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Reporte_Facturas.xls"
Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
set pagina = new CPagina
'------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
Usuario = negocio.ObtenerUsuario()
'------------------------------------------------------------------------------------
 sede = request.querystring("busqueda[0][sede_ccod]")
 inicio = request.querystring("busqueda[0][inicio]")
 termino = request.querystring("busqueda[0][termino]")
 num_doc = request.querystring("busqueda[0][fact_nfactura]")
 estado_factura = request.querystring("busqueda[0][efac_ccod]")
 tipo_doc = Request.QueryString("busqueda[0][tfac_ccod]")


set f_facturas = new CFormulario
f_facturas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_facturas.Inicializar conexion

			
					
consulta = "select a.pers_ncorr_alumno,protic.obtener_rut(a.pers_ncorr_alumno) as rut_beneficiario ," & vbCrLf &_
				" protic.obtener_nombre_completo(a.pers_ncorr_alumno,'n') as nombre_beneficiario," & vbCrLf &_
				" b.tfac_tdesc as tipo_factura,fact_nfactura as num_factura,case when a.efac_ccod =3 then 0 else fact_mtotal end as total_factura," & vbCrLf &_
				" isnull(fact_mneto,0) as valor_neto, isnull(fact_miva,0) as valor_iva," & vbCrLf &_
				" protic.trunc(a.fact_ffactura) as fecha_boleta, ingr_nfolio_referencia as comprobante," & vbCrLf &_
				" mcaj_ncorr as caja, c.efac_tdesc as estado, d.sede_tdesc as sede " & vbCrLf &_
				" From facturas a, tipos_facturas b, estados_facturas c, sedes d" & vbCrLf &_
				" where a.tfac_ccod=b.tfac_ccod" & vbCrLf &_
				" and a.sede_ccod=d.sede_ccod " & vbCrLf &_
				" and a.efac_ccod=c.efac_ccod " 


					if sede <> "" then
					  consulta = consulta & vbCrLf&  " and a.sede_ccod = '" & sede & "' "
					end if

					if inicio <> "" and termino <> "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,fact_ffactura,103) between '" & inicio & "' and '" & termino & "'"
					end if 
					if inicio <> "" and termino = "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,fact_ffactura,103) >= '" & inicio & "'"
					end if 
					if inicio = "" and termino <> "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,fact_ffactura,103) <= '" & termino & "'"
					end if 
					
					if num_doc <> "" then                   
				      consulta = consulta & vbCrLf&   " and a.fact_nfactura= '" & num_doc & "' "
					end if
					if tipo_doc <> "" then                   
				      consulta = consulta & vbCrLf&   " and a.tfac_ccod= '" & tipo_doc & "' "
					end if
					if estado_letra <> "" then
  					   consulta = consulta & vbCrLf&  " and a.efac_ccod ='" & estado_factura & "' "
					 end if
					 
					 
					 consulta = consulta & vbCrLf&  " order by num_factura" 
					 
f_facturas.Consultar consulta

'response.Write("<PRE>" & consulta & "</PRE>")
'response.End()
%>
<html>
<head>
<title> Detalle Facturas</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
	<td width="11%"><div align="center"><strong>Tipo Factura</strong></div></td>
    <td width="11%"><div align="center"><strong>N&ordm; Factura</strong></div></td>
	<td width="8%"><div align="center"><strong>Monto ($)</strong></div></td>
	<td width="8%"><div align="center"><strong>Neto ($)</strong></div></td>
	<td width="8%"><div align="center"><strong>Iva ($)</strong></div></td>
    <td width="11%"><div align="center"><strong>Estado</strong></div></td>
	<td width="11%"><div align="center"><strong>F. Emisi&oacute;n</strong></div></td>
	<td width="11%"><div align="center"><strong>Rut Beneficiario</strong></div></td>
    <td width="11%"><div align="center"><strong>Nombre Beneficiario</strong></div></td>
	<td width="11%"><div align="center"><strong>Nº Comprobante</strong></div></td>
	<td width="11%"><div align="center"><strong>Nº Caja</strong></div></td>
	<td width="11%"><div align="center"><strong>Sede</strong></div></td>
	<td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>

  </tr>
  <%  while f_facturas.Siguiente %>
  <tr> 
  <td><div align="left"><%=f_facturas.ObtenerValor("tipo_factura")%></div></td>
    <td><div align="left"><%=f_facturas.ObtenerValor("num_factura")%></div></td>
    <td><div align="left"><%=f_facturas.ObtenerValor("total_factura")%></div></td>
	<td><div align="left"><%=f_facturas.ObtenerValor("total_neto")%></div></td>
	<td><div align="left"><%=f_facturas.ObtenerValor("total_iva")%></div></td>
	<td><div align="left"><%=f_facturas.ObtenerValor("estado")%></div></td>
    <td><div align="left"><%=f_facturas.ObtenerValor("fecha_factura")%></div></td>
    <td><div align="left"><%=f_facturas.ObtenerValor("rut_beneficiario")%></div></td>
    <td><div align="left"><%=f_facturas.ObtenerValor("nombre_beneficiario")%></div></td>
	<td><div align="left"><%=f_facturas.ObtenerValor("comprobante")%></div></td>
	<td><div align="left"><%=f_facturas.ObtenerValor("caja")%></div></td>
	<td><div align="left"><%=f_facturas.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_facturas.ObtenerValor("rut_alumno")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>