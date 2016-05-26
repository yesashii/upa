<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_facturas_diarias.xls"
Response.ContentType = "application/vnd.ms-excel"
'-----------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Maneja Facturas"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion



 rut_alumno 		= request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito 	= request.querystring("busqueda[0][pers_xdv]")
 v_folio 			= request.querystring("busqueda[0][folio]")
 v_numero_factura	= request.querystring("busqueda[0][fact_nfactura]")
 v_tfac_ccod		= request.querystring("busqueda[0][tfac_ccod]")
 v_mcaj_ncorr		= request.querystring("mcaj_ncorr")
 v_q_leng		= request.querystring("q_leng")
'-----------------------------------------------------------------------
if v_q_leng=4 then
	v_tfac_ccod=1
end if
if v_q_leng=5 then
	v_tfac_ccod=2
end if

if v_mcaj_ncorr <> "" then
	nombre_cajero=conexion.consultaUno("Select protic.obtener_nombre_completo(b.pers_ncorr,'n') from movimientos_cajas a, cajeros b where a.caje_ccod=b.caje_ccod and a.mcaj_ncorr='"&v_mcaj_ncorr&"'")
else
	v_usuario=negocio.ObtenerUsuario()
	nombre_cajero=conexion.consultaUno("Select protic.obtener_nombre_completo(pers_ncorr,'n') from personas where pers_nrut='"&v_usuario&"'")
	'response.Write("<pre>"&v_usuario&"</pre>")
	set cajero = new CCajero
	cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede
	
	v_mcaj_ncorr=cajero.ObtenerCajaAbierta()
end if
'if not cajero.tienecajaabierta then
'  conexion.MensajeError "No puede obtener la planilla de Facturas sin tener una caja abierta"
'  response.Redirect("../lanzadera/lanzadera.asp") 
'end if

set errores = new CErrores


'-----------------------------------------------------------------------


 
 

'--------------------------------------------------------------------
set f_contrato = new CFormulario
f_contrato.Carga_Parametros "tabla_vacia.xml", "tabla"
f_contrato.Inicializar conexion


if v_folio <> "" then
	filtro =" and a.ingr_nfolio_referencia="&v_folio
end if

if rut_alumno<> "" then
	filtro =filtro + " and b.pers_nrut='"&rut_alumno&"'"
end if

if v_numero_factura<> "" then
	filtro =filtro + " and a.fact_nfactura='"&v_numero_factura&"'"
end if

if v_tfac_ccod <> ""  then
	filtro=filtro + " and a.tfac_ccod='"&v_tfac_ccod&"'"
	v_tipo_factura=conexion.ConsultaUno ("select tfac_tdesc from tipos_facturas where tfac_ccod="&v_tfac_ccod)
end if

if v_mcaj_ncorr <> "" and v_usuario<> "13373873" then
	filtro=filtro + " and a.mcaj_ncorr='"&v_mcaj_ncorr&"'"
end if




consulta = "select a.fact_ncorr,a.fact_nfactura, a.ingr_nfolio_referencia,c.efac_tdesc, "& vbCrLf &_
			" isnull(a.fact_mtotal,0) as total_factura, isnull(sum(cast(b.ingr_mtotal as integer)),0) as total_ingreso  "& vbCrLf &_
			" from facturas a "& vbCrLf &_
			" left outer join ingresos b "& vbCrLf &_
			"    on a.ingr_nfolio_referencia=b.ingr_nfolio_referencia"& vbCrLf &_
			"  join estados_facturas c " & vbCrLf &_
			" 	on a.efac_ccod=c.efac_ccod "& vbCrLf &_
			" where 1=1 "&filtro&" "& vbCrLf &_
			" group by a.fact_ncorr,a.fact_nfactura, a.ingr_nfolio_referencia,a.fact_mtotal,c.efac_tdesc "& vbCrLf &_
			" order by a.fact_nfactura asc"

'response.Write("<pre>"&consulta&"</pre>")		

if not Esvacio(Request.QueryString) then
 	  f_contrato.Consultar consulta
else
	 f_contrato.Consultar "select '' where 1=2"
	 f_contrato.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
end if

'response.End()
v_monto_factura=0
v_monto_ingreso=0
%>


<html>
<head>
<title> Listado Facturas</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
<tr>
<th colspan="2">Fecha: <%=now()%></th>
<th colspan="3"> Tipo Factura: <%=v_tipo_factura%></th>
<th colspan="2">Caja: <%=v_mcaj_ncorr%></th>

</tr>
  <tr> 
    <td width="11%"><div align="center"><strong>N°</strong></div></td>
    <td width="11%"><div align="center"><strong>N° Factura</strong></div></td>
    <td width="11%"><div align="center"><strong>Monto Factura</strong></div></td>
    <td width="14%"><div align="center"><strong>N° Comp. Ingreso</strong></div></td>
    <td width="8%"><div align="center"><strong>Monto Comp. Ing.</strong></div></td>
    <td width="11%"><div align="center"><strong>Detalles</strong></div></td>
	<td width="11%"><div align="center"><strong>Estado</strong></div></td>
  </tr>
  <%  while f_contrato.Siguiente
  	cont=cont+1
  	v_fact_ncorr=f_contrato.ObtenerValor("fact_ncorr")
	
	v_detalle=""
		
		if v_fact_ncorr <> "" then
		set f_detalles = new CFormulario
		f_detalles.Carga_Parametros "tabla_vacia.xml", "tabla"
		f_detalles.Inicializar conexion
		consulta_detalles="Select LOWER(tdet_tdesc) as detalle "& vbCrLf &_
							"	 from detalle_factura a, detalles b, tipos_detalle c "& vbCrLf &_
							"	 where a.tcom_ccod=b.tcom_ccod "& vbCrLf &_
							"	 and a.comp_ndocto=b.comp_ndocto "& vbCrLf &_
							"	 and b.tdet_ccod=c.tdet_ccod "& vbCrLf &_
							"	 and c.tben_ccod not in (1,2,3) "& vbCrLf &_
							"	 and a.fact_ncorr="&v_fact_ncorr
		'response.Write("Detalles:"&consulta_detalles)
		f_detalles.Consultar consulta_detalles
			while f_detalles.Siguiente
				if v_detalle <> "" then
					separador=" , "
				else
					separador=""
				end if
				
				v_detalle=v_detalle&""&separador&""&f_detalles.ObtenerValor("detalle")
					'response.Write("Detalles:"&v_detalle)
			wend
		end if
   %>
  <tr> 
    <td><div align="left"><%=cont%></div></td>
    <td><div align="left"><%=f_contrato.ObtenerValor("fact_nfactura")%></div></td>
    <td><div align="left"><%=f_contrato.ObtenerValor("total_factura")%></div></td>
    <td><div align="left"><%=f_contrato.ObtenerValor("ingr_nfolio_referencia")%></div></td>
    <td><div align="left"><%=f_contrato.ObtenerValor("total_ingreso")%></div></td>
	<td><div align="left"><%=v_detalle%></div></td>
	<td><div align="left"><%=f_contrato.ObtenerValor("efac_tdesc")%></div></td>
  </tr>
  <% 
  	if f_contrato.ObtenerValor("efac_tdesc") <> "NULA" then
		  v_monto_factura	=	clng(v_monto_factura) + clng(f_contrato.ObtenerValor("total_factura"))
		  v_monto_ingreso	=	clng(v_monto_ingreso) + clng(f_contrato.ObtenerValor("total_ingreso"))
	end if
   wend %>
  <tr>
  <td></td>
  <td></td>
  <td><%=v_monto_factura%></td>
  <td></td>
  <td><%=v_monto_ingreso%></td>
  <td></td>
  <td></td>
  </tr>
  <tr>
  <td colspan="7"></td>
  </tr>
  
  <tr>
	  <td></td>
	  <td></td>
	  <td></td>
	  <td colspan="2" align="center">___________________</td>
	  <td></td>
	  <td></td>
  </tr>
  <tr>
	  <td></td>
	  <td></td>
	  <td></td>
	  <td colspan="2" align="center" ><%=nombre_cajero%></td>
	  <td></td>
	  <td></td>
  </tr>
  
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>