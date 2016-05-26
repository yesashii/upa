<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "recaudacion de Cajas"

Response.AddHeader "Content-Disposition", "attachment;filename=recaudacion_diaria_cajas.xls"
Response.ContentType = "application/vnd.ms-excel"

v_fecha_inicio 		= request.querystring("busqueda[0][mcaj_finicio]")
v_cajero 			= request.querystring("busqueda[0][caje_ccod]")
v_sede 				= request.querystring("busqueda[0][sede_ccod]")
v_tipo_caja			= request.querystring("busqueda[0][tcaj_ccod]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_num_caja			= request.querystring("busqueda[0][mcaj_ncorr]")
  
 


set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "recaudacion_diaria_cajas.xml", "busqueda_cajas"
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente


formulario.carga_parametros "tabla_vacia.xml", "tabla"
formulario.inicializar conectar
negocio.inicializa conectar
sede=negocio.obtenerSede


if v_fecha_inicio <> "" and esvacio(v_fecha_termino) then
	sql_adicional= sql_adicional + "and  protic.trunc(a.mcaj_finicio)='"&v_fecha_inicio&"' "& vbCrLf
end if
if EsVacio(v_fecha_inicio) and v_fecha_termino<>"" then
	sql_adicional= sql_adicional + " and convert(datetime,a.mcaj_finicio,103) <=  convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf
end if

if v_fecha_inicio <> "" and v_fecha_termino <> "" then
	sql_adicional= sql_adicional + " and convert(datetime,a.mcaj_finicio,103) BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103)"& vbCrLf 
end if

if v_estado_caja <> "" then
	sql_adicional= sql_adicional + " and a.eren_ccod ="&v_estado_caja& vbCrLf 
end if

if v_sede <> "" then
	sql_adicional= sql_adicional + " and a.sede_ccod ="&v_sede& vbCrLf 
end if

if v_tipo_caja <> "" then
	sql_adicional= sql_adicional + " and a.tcaj_ccod ="&v_tipo_caja& vbCrLf 
end if

if v_num_caja <> "" then
	sql_adicional= sql_adicional + " and a.mcaj_ncorr ="&v_num_caja& vbCrLf 
end if

if v_cajero <> "" then
	sql_adicional= sql_adicional + " and a.caje_ccod  in (select caje_ccod from cajeros where pers_ncorr ="&v_cajero&")"& vbCrLf 
end if		

		
'response.Write("Sql Adicional :<pre>"&sql_adicional&"</pre>")
if request.QueryString <> "" then
	cajas_abiertas_cons = "select d.mes_tdesc as mes,a.mcaj_ncorr as caja,protic.trunc(a.mcaj_finicio) as fecha,b.sede_tdesc as sede, "& vbCrLf &_
						"	protic.obtener_nombre_completo(c.pers_ncorr,'n') as nombre, "& vbCrLf &_
						"	(select max(ingr_ncorrelativo_caja) from ingresos where mcaj_ncorr=a.mcaj_ncorr) as comprobantes, "& vbCrLf &_
						"	cast((select sum(ingr_mtotal) from ingresos where mcaj_ncorr=a.mcaj_ncorr and ingr_ncorrelativo_caja is not null) as numeric) as monto "& vbCrLf &_
						"	,e.tcaj_tdesc as tipo_caja "& vbCrLf &_
						"	from movimientos_cajas a, sedes b, cajeros c, meses d , tipos_caja e "& vbCrLf &_
						"	where a.sede_ccod=b.sede_ccod "& vbCrLf &_
						"	and a.caje_ccod=c.caje_ccod "& vbCrLf &_
						"	and a.sede_ccod=c.sede_ccod "& vbCrLf &_
						"	and d.mes_ccod=datepart(month,mcaj_finicio) "& vbCrLf &_
						"	and a.tcaj_ccod=e.tcaj_ccod "& vbCrLf &_
						"	and a.mcaj_ncorr in ( "& vbCrLf &_
						"	select distinct mcaj_ncorr from ingresos where ingr_ncorrelativo_caja is not null "& vbCrLf &_
						"	and convert(datetime,ingr_fpago,103) "& vbCrLf &_ 
						"	BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf &_
						"	) "& vbCrLf &_
						"	and convert(datetime,a.mcaj_finicio,103) "& vbCrLf &_
						"	BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf &_
						"	and c.pers_ncorr not in (27720) "& vbCrLf &_
						"	"&sql_adicional&" order by a.mcaj_finicio "
else
	cajas_abiertas_cons="select '' where 1=2 " 
end if				 


formulario.consultar cajas_abiertas_cons

%>


<html>
<head>
<title> Recaudacion diaria de Cajas </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
    <td width="11%"><div align="center"><strong>Cajero</strong></div></td>
    <td width="14%"><div align="center"><strong>Tipo</strong></div></td>
	<td width="11%"><div align="center"><strong>Mes</strong></div></td>
    <td width="8%"><div align="center"><strong>Apertura</strong></div></td>
    <td width="11%"><div align="center"><strong>N&ordm; Caja</strong></div></td>
    <td width="11%"><div align="center"><strong>Sede</strong></div></td>
	<td width="11%"><div align="center"><strong>Comprobantes</strong></div></td>
	<td width="11%"><div align="center"><strong>Monto</strong></div></td>
  </tr>
  <%  while formulario.Siguiente %>
  <tr> 
    <td><div align="left"><%=formulario.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=formulario.dibujaCampo("mes")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("tipo_caja")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("fecha")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("caja")%></div></td>
    <td><div align="left"><%=formulario.dibujaCampo("sede")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("comprobantes")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("monto")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>