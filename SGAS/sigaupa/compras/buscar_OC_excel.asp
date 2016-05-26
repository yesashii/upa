<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_postulantes.xls"
Response.ContentType = "application/vnd.ms-excel"

'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

v_inicio	= request.Form("busqueda[0][inicio]")
v_termino	= request.Form("busqueda[0][termino]")
pers_nrut	= request.Form("busqueda[0][pers_nrut]")
pers_xdv	= request.Form("busqueda[0][pers_xdv]")
tgas_ccod	= request.Form("busqueda[0][tgas_ccod]")


'response.Write(pers_nrut)
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "buscar_OC.xml", "datos_solicitud"
f_busqueda.Inicializar conectar


if v_inicio<>"" then
sql_filtro=" AND convert(datetime,fecha_solicitud,103) >=  convert(datetime,'"&v_inicio&"',103) "
	if v_inicio<>"" and v_termino<>"" then
	sql_filtro = "" 
		sql_filtro=" AND convert(datetime,fecha_solicitud,103) BETWEEN  isnull(convert(datetime,'"&v_inicio&"',103),convert(datetime,fecha_solicitud,103)) and isnull(convert(datetime,'"&v_termino&"',103)+1,convert(datetime,fecha_solicitud,103)) "
	end if
end if

if pers_nrut<>"" then
	sql_filtro=sql_filtro& " and pers_nrut =  "&pers_nrut
end if

if tgas_ccod<>"" then
	sql_filtro=sql_filtro& " and tg.tgas_ccod = "&tgas_ccod
end if
 

 sql_solicitudes="select distinct ordc_ndocto,ordc_mmonto,ordc_fentrega, protic.trunc(fecha_solicitud) as fecha_solicitud ,protic.obtener_nombre_completo(oc.pers_ncorr, 'n') as nombre_proveedor, " &_
"protic.obtener_rut(oc.pers_ncorr) as rut_proveedor "&_
", (select protic.obtener_nombre_completo(k.pers_ncorr, 'n') as nombre from personas k where k.pers_nrut = oc.ocag_generador)  as generador, vibo_tdesc, '('+pu.cod_pre+')-'+concepto as pruebas  " &_
"from ocag_orden_compra oc, personas p, ocag_visto_bueno vb, ocag_Detalle_orden_compra doc, ocag_tipo_gasto tg, ocag_presupuesto_solicitud pc, presupuesto_upa pu " &_
"where oc.pers_ncorr = p.pers_ncorr " &_
"and oc.vibo_ccod = vb.vibo_ccod " &_
"and oc.ordc_ndocto = doc.ordc_ncorr " &_
"and doc.tgas_ccod = tg.tgas_ccod " &_
"and oc.ordc_ncorr = cod_solicitud " &_
"and pc.cod_pre = pu.cod_pre COLLATE MODERN_SPANISH_CI_AS " &_
"" & sql_filtro & " " &_
"order by ordc_ndocto"				
 
 'response.Write("<pre>"&sql_solicitudes&"</pre>")
 'response.End()

 
 f_busqueda.Consultar sql_solicitudes

%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">
  <tr>
	<td width="26%" bgcolor="#99CC33"><div align="center"><strong> N° OC</strong></div></td>
	<td width="26%" bgcolor="#99CC33"><div align="center"><strong>Monto</strong></div></td>
    <td width="26%" bgcolor="#99CC33"><div align="center"><strong>Fecha Solicitud</strong></div></td>
	<td width="26%" bgcolor="#99CC33"><div align="center"><strong>Proveedor</strong></div></td>
    <td width="26%" bgcolor="#99CC33"><div align="center"><strong>Rut Proveedor</strong></div></td>
    <td width="23%" bgcolor="#99CC33"><div align="center"><strong>Genero OC</strong></div></td>
	<td width="23%" bgcolor="#99CC33"><div align="center"><strong>VB Estado</strong></div></td>
	<td width="23%" bgcolor="#99CC33"><div align="center"><strong>Cod. Presupuesto</strong></div></td>
  </tr>
  <%  while f_busqueda.Siguiente %>
  <tr> 
	<td valign="top"><div align="center"><%=f_busqueda.ObtenerValor("ordc_ndocto")%></div></td>
	<td valign="top"><div align="center"><%=f_busqueda.ObtenerValor("ordc_mmonto")%></div></td>
    <td valign="top"><div align="center"><%=f_busqueda.ObtenerValor("fecha_solicitud")%></div></td>
	<td valign="top"><div align="center"><%=f_busqueda.ObtenerValor("nombre_proveedor")%></div></td>
    <td valign="top"><div align="center"><%=f_busqueda.ObtenerValor("rut_proveedor")%></div></td>
	<td valign="top"><div align="center"><%=f_busqueda.ObtenerValor("generador")%></div></td>
	<td valign="top"><div align="center"><%=f_busqueda.ObtenerValor("vibo_tdesc")%></div></td>	
    <td valign="top"><div align="center"><%=f_busqueda.ObtenerValor("pruebas")%></div></td>	
  </tr>
  <%  wend %>
</table>
</html>