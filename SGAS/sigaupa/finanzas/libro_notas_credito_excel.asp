<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Reporte_boletas.xls"
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
 num_doc = request.querystring("busqueda[0][ndcr_nnota_credito]")
 estado_factura = request.querystring("busqueda[0][encr_ccod]")


set f_facturas = new CFormulario
f_facturas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_facturas.Inicializar conexion

			
					
consulta = "select a.pers_ncorr,protic.obtener_rut(a.pers_ncorr) as rut_beneficiario ," & vbCrLf &_
			" protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_beneficiario," & vbCrLf &_
			" ndcr_nnota_credito,case when a.encr_ccod =3 then 0 else ndcr_mtotal end as total_nota_credito," & vbCrLf &_
			" protic.trunc(a.ndcr_fnota_credito) as fecha_nota_credito, ingr_nfolio_referencia as comprobante," & vbCrLf &_
			" mcaj_ncorr as caja, c.encr_tdesc as estado" & vbCrLf &_
			" From notas_de_credito a, estados_notas_credito c" & vbCrLf &_
			" where a.encr_ccod=c.encr_ccod "


					if sede <> "" then
					  consulta = consulta & vbCrLf&  " and a.sede_ccod = '" & sede & "' "
					end if

					if inicio <> "" and termino <> "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,ndcr_fnota_credito,103) between '" & inicio & "' and '" & termino & "'"
					end if 
					if inicio <> "" and termino = "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,ndcr_fnota_credito,103) >= '" & inicio & "'"
					end if 
					if inicio = "" and termino <> "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,ndcr_fnota_credito,103) <= '" & termino & "'"
					end if 
					
					if num_doc <> "" then                   
				      consulta = consulta & vbCrLf&   " and a.ndcr_nnota_credito= '" & num_doc & "' "
					end if
					if estado_letra <> "" then
  					   consulta = consulta & vbCrLf&  " and a.encr_ccod ='" & estado_letra & "' "
					 end if
					 
					 
					 consulta = consulta & vbCrLf&  " order by ndcr_nnota_credito" 
					 
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
    <td width="11%"><div align="center"><strong>N&ordm; Nota Credito</strong></div></td>
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
    <td><div align="left"><%=f_facturas.ObtenerValor("ndcr_nnota_credito")%></div></td>
    <td><div align="left"><%=f_facturas.ObtenerValor("total_nota_credito")%></div></td>
	<td><div align="left"><%=f_facturas.ObtenerValor("total_neto")%></div></td>
	<td><div align="left"><%=f_facturas.ObtenerValor("total_iva")%></div></td>
	<td><div align="left"><%=f_facturas.ObtenerValor("estado")%></div></td>
    <td><div align="left"><%=f_facturas.ObtenerValor("fecha_nota_credito")%></div></td>
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