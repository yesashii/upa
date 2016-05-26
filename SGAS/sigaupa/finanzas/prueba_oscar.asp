<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Prueba OScar.xls"
Response.ContentType = "application/vnd.ms-excel"

set pagina = new CPagina
pagina.Titulo = "Reporte Compromisos Pagados"

v_fecha_inicio 		= request.querystring("busqueda[0][ingr_fpago]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_tdet_ccod	 		= request.querystring("busqueda[0][tdet_ccod]")
v_pers_nrut	 		= request.querystring("busqueda[0][pers_nrut]")
v_pers_xdv	 		= request.querystring("busqueda[0][pers_xdv]")

set botonera = new CFormulario
botonera.carga_parametros "reporte_compromisos_pagados.xml", "botonera"


set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros "consulta.xml", "consulta"
formulario.inicializar conectar
negocio.inicializa conectar



if v_fecha_inicio <> "" and esvacio(v_fecha_termino) then
	sql_adicional= sql_adicional + "and  protic.trunc(g.ingr_fpago) >= convert(datetime,'"&v_fecha_inicio&"',103)  "& vbCrLf
end if
if EsVacio(v_fecha_inicio) and v_fecha_termino<>"" then
	sql_adicional= sql_adicional + " and convert(datetime,g.ingr_fpago,103) <=  convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf
end if

if v_fecha_inicio <> "" and v_fecha_termino <> "" then
	sql_adicional= sql_adicional + " and convert(datetime,g.ingr_fpago,103) BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103)"& vbCrLf 
end if

if v_pers_nrut <> "" then
	sql_adicional= sql_adicional + " and e.pers_nrut="&v_pers_nrut& vbCrLf 
end if

if v_tdet_ccod <> "" then
	if v_tdet_ccod="1231" then
		sql_adicional= sql_adicional + " and c.tdet_ccod in (1231,1260,1259) "& vbCrLf
	else 
		sql_adicional= sql_adicional + " and c.tdet_ccod ="&v_tdet_ccod& vbCrLf 
	end if
end if


'response.Write("Sql Adicional :<pre>"&sql_adicional&"</pre>")
if request.QueryString <> "" then
	sql_datos= 	" select protic.obtener_nombre_carrera((select top 1 ofer_ncorr from alumnos where pers_ncorr=b.pers_ncorr order by matr_ncorr desc),'CJ') as carrera,"& vbCrLf &_
				" d.tdet_tdesc as item,cast(sum(f.abon_mabono) as numeric) as monto,protic.trunc(max(g.ingr_fpago)) as fecha_pago, "& vbCrLf &_
			   	" b.pers_ncorr,protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno "& vbCrLf &_
			   	" ,g.ingr_nfolio_referencia as comprobante, g.mcaj_ncorr as caja, (select sede_tdesc from sedes where sede_ccod=h.sede_ccod) as sede"& vbCrLf &_
				" from compromisos a "& vbCrLf &_
				" 	join detalle_compromisos b     "& vbCrLf &_
				" 		on a.tcom_ccod = b.tcom_ccod   "& vbCrLf &_     
				" 		and a.inst_ccod = b.inst_ccod  "& vbCrLf &_      
				" 		and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_ 
				" 	 join detalles c "& vbCrLf &_
				" 		on c.tcom_ccod = b.tcom_ccod  "& vbCrLf &_      
				" 		and c.inst_ccod = b.inst_ccod "& vbCrLf &_       
				" 		and c.comp_ndocto = b.comp_ndocto "& vbCrLf &_
				" 	 join tipos_detalle d "& vbCrLf &_
				" 		on c.tdet_ccod=d.tdet_ccod "& vbCrLf &_
				" 	 join personas e "& vbCrLf &_
				" 		on b.pers_ncorr=e.pers_ncorr "& vbCrLf &_
				" 	 join abonos f "& vbCrLf &_
				" 		on b.tcom_ccod = f.tcom_ccod "& vbCrLf &_       
				" 		and b.inst_ccod = f.inst_ccod "& vbCrLf &_       
				" 		and b.comp_ndocto = f.comp_ndocto "& vbCrLf &_
				" 		and b.dcom_ncompromiso = f.dcom_ncompromiso "& vbCrLf &_
				" 	 join ingresos g "& vbCrLf &_
				" 		on f.ingr_ncorr=g.ingr_ncorr "& vbCrLf &_
				" 		and g.eing_ccod not in (3,6) --no trae los nulos "& vbCrLf &_
				" 		and g.ting_ccod in (16,34) -- trae solo los ingresados por caja "& vbCrLf &_
				" 	 join movimientos_cajas h "& vbCrLf &_
				" 		on g.mcaj_ncorr=h.mcaj_ncorr "& vbCrLf &_
				" where a.ecom_ccod = '1' "& vbCrLf &_ 
				"	"&sql_adicional&" --filtro "& vbCrLf &_ 
				" group by b.pers_ncorr,d.tdet_tdesc,g.ingr_nfolio_referencia, g.mcaj_ncorr, h.sede_ccod "& vbCrLf &_
				" order by fecha_pago asc " 
 
else
	sql_datos="select '' where 1=2 " 
end if			 

'response.Write("<pre>"&sql_datos&"</pre>")
'response.End()				 


formulario.consultar sql_datos
%>


<html>
<head>
<title>Reporte Compromisos Pagados</title>
</head>
<body>
<table width="75%" border="1">
  <tr>
	<td width="11%"><div align="center"><strong>Tipo Compromiso</strong></div></td>
	<td width="11%"><div align="center"><strong>Monto Pagado</strong></div></td> 
    <td width="11%"><div align="center"><strong>Fecha Pago</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="14%"><div align="center"><strong>Nombre Alumno</strong></div></td>
    <td width="14%"><div align="center"><strong>Carrera</strong></div></td>
    <td width="14%"><div align="center"><strong>Comprobante</strong></div></td>
    <td width="14%"><div align="center"><strong>Caja</strong></div></td>
	<td width="14%"><div align="center"><strong>Sede</strong></div></td>
  </tr>
  <%  while formulario.Siguiente %>
  <tr>
	<td><div align="left"><%=formulario.ObtenerValor("item")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("monto")%></div></td> 
    <td><div align="left"><%=formulario.ObtenerValor("fecha_pago")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("nombre_alumno")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("comprobante")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("caja")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
 </tr>
  <%  wend %>
</table>
</body>
</html>
