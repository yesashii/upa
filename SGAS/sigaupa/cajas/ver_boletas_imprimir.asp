<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Listado_boletas_diarias.xls"
Response.ContentType = "application/vnd.ms-excel"
'-----------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Maneja Boletas"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion



 rut_alumno 		= request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito 	= request.querystring("busqueda[0][pers_xdv]")
 v_folio 			= request.querystring("busqueda[0][folio]")
 v_numero_boleta	= request.querystring("busqueda[0][bole_nboleta]")
 v_tbol_ccod		= request.querystring("busqueda[0][tbol_ccod]")
 v_mcaj_ncorr		= request.querystring("mcaj_ncorr")
 v_q_leng		= request.querystring("q_leng")
'-----------------------------------------------------------------------
if v_q_leng=4 then
	v_tbol_ccod=1
end if
if v_q_leng=5 then
	v_tbol_ccod=2
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
'  conexion.MensajeError "No puede obtener la planilla de boletas sin tener una caja abierta"
'  response.Redirect("../lanzadera/lanzadera.asp") 
'end if

set errores = new CErrores


set botonera = new CFormulario
botonera.Carga_Parametros "boletas_venta.xml", "botonera"
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

if v_numero_boleta<> "" then
	filtro =filtro + " and a.bole_nboleta='"&v_numero_boleta&"'"
end if

if v_tbol_ccod <> ""  then
	filtro=filtro + " and a.tbol_ccod='"&v_tbol_ccod&"'"
	v_tipo_boleta=conexion.ConsultaUno ("select tbol_tdesc from tipos_boletas where tbol_ccod="&v_tbol_ccod)
end if

if v_mcaj_ncorr <> "" and v_usuario<> "13373873" then
	filtro=filtro + " and a.mcaj_ncorr='"&v_mcaj_ncorr&"'"
end if




consulta = "select a.bole_ncorr,a.bole_nboleta, a.ingr_nfolio_referencia,c.ebol_tdesc, "& vbCrLf &_
			" isnull(a.bole_mtotal,0) as total_boleta, isnull(sum(cast(b.ingr_mtotal as integer)),0) as total_ingreso  "& vbCrLf &_
			" from boletas a "& vbCrLf &_
			" left outer join ingresos b "& vbCrLf &_
			"    on a.ingr_nfolio_referencia=b.ingr_nfolio_referencia"& vbCrLf &_
			"  join estados_boletas c " & vbCrLf &_
			" 	on a.ebol_ccod=c.ebol_ccod "& vbCrLf &_
			" where 1=1 "&filtro&" "& vbCrLf &_
			" group by a.bole_ncorr,a.bole_nboleta, a.ingr_nfolio_referencia,a.bole_mtotal,c.ebol_tdesc "& vbCrLf &_
			" order by a.bole_nboleta asc"

'response.Write("<pre>"&consulta&"</pre>")		

if not Esvacio(Request.QueryString) then
 	  f_contrato.Consultar consulta
else
	 f_contrato.Consultar "select '' where 1=2"
	 f_contrato.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
end if

'response.End()
v_monto_boleta=0
v_monto_ingreso=0
%>


<html>
<head>
<title> Listado boletas</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
<tr>
<th colspan="2">Fecha: <%=now()%></th>
<th colspan="3"> Tipo Boleta: <%=v_tipo_boleta%></th>
<th colspan="2">Caja: <%=v_mcaj_ncorr%></th>

</tr>
  <tr> 
    <td width="11%"><div align="center"><strong>N°</strong></div></td>
    <td width="11%"><div align="center"><strong>N° Boleta</strong></div></td>
    <td width="11%"><div align="center"><strong>Monto Boleta</strong></div></td>
    <td width="14%"><div align="center"><strong>N° Comp. Ingreso</strong></div></td>
    <td width="8%"><div align="center"><strong>Monto Comp. Ing.</strong></div></td>
    <td width="11%"><div align="center"><strong>Detalles</strong></div></td>
	<td width="11%"><div align="center"><strong>Estado</strong></div></td>
  </tr>
  <%  while f_contrato.Siguiente
  	cont=cont+1
  	v_bole_ncorr=f_contrato.ObtenerValor("bole_ncorr")
	
	v_detalle=""
		
		if v_bole_ncorr <> "" then
		set f_detalles = new CFormulario
		f_detalles.Carga_Parametros "tabla_vacia.xml", "tabla"
		f_detalles.Inicializar conexion
		consulta_detalles="Select LOWER(tdet_tdesc) as detalle from detalle_boletas a, tipos_detalle b where a.tdet_ccod=b.tdet_ccod and a.bole_ncorr="&v_bole_ncorr
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
    <td><div align="left"><%=f_contrato.ObtenerValor("bole_nboleta")%></div></td>
    <td><div align="left"><%=f_contrato.ObtenerValor("total_boleta")%></div></td>
    <td><div align="left"><%=f_contrato.ObtenerValor("ingr_nfolio_referencia")%></div></td>
    <td><div align="left"><%=f_contrato.ObtenerValor("total_ingreso")%></div></td>
	<td><div align="left"><%=v_detalle%></div></td>
	<td><div align="left"><%=f_contrato.ObtenerValor("ebol_tdesc")%></div></td>
  </tr>
  <% 
  	if f_contrato.ObtenerValor("ebol_tdesc") <> "NULA" then
		  v_monto_boleta	=	clng(v_monto_boleta) + clng(f_contrato.ObtenerValor("total_boleta"))
		  v_monto_ingreso	=	clng(v_monto_ingreso) + clng(f_contrato.ObtenerValor("total_ingreso"))
	end if
   wend %>
  <tr>
  <td></td>
  <td></td>
  <td><%=v_monto_boleta%></td>
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