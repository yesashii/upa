<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:MODULO TESORERO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:28/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:177
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Historial de Cajas"

Response.AddHeader "Content-Disposition", "attachment;filename=historial_cajas.xls"
Response.ContentType = "application/vnd.ms-excel"

v_fecha_inicio 		= request.querystring("busqueda[0][mcaj_finicio]")
v_estado_caja	 	= request.querystring("busqueda[0][eren_ccod]")
v_cajero 			= request.querystring("busqueda[0][caje_ccod]")
v_sede 				= request.querystring("busqueda[0][sede_ccod]")
v_tipo_caja			= request.querystring("busqueda[0][tcaj_ccod]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_num_caja			= request.querystring("busqueda[0][mcaj_ncorr]")
v_ingr_nfolio		= request.querystring("busqueda[0][ingr_nfolio]") 
v_fecha_traspaso	= request.querystring("busqueda[0][fecha_traspaso]")     
 


set botonera = new CFormulario
botonera.carga_parametros "historico_cajas.xml", "botonera"


set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "historico_cajas.xml", "busqueda_cajas"
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente


formulario.carga_parametros "tabla_vacia.xml", "tabla"
formulario.inicializar conectar
negocio.inicializa conectar
sede=negocio.obtenerSede

'response.Write("v_fecha_inicio :"&v_fecha_inicio)
'response.Write("v_fecha_termino :"&v_fecha_termino)

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

if v_ingr_nfolio <> "" and v_num_caja="" then
	v_caja_asociada=conectar.ConsultaUno("Select top 1 mcaj_ncorr from ingresos where ingr_nfolio_referencia="&v_ingr_nfolio)
	if v_caja_asociada <> "" then
		sql_adicional= sql_adicional + " and a.mcaj_ncorr ="&v_caja_asociada& vbCrLf 
	Else
		sql_adicional= sql_adicional + " and a.mcaj_ncorr =0"& vbCrLf 
	end if
end if

if v_cajero <> "" then
	sql_adicional= sql_adicional + " and a.caje_ccod  in (select caje_ccod from cajeros where pers_ncorr ="&v_cajero&")"& vbCrLf 
end if		

if v_fecha_traspaso <> "" then
	sql_adicional= sql_adicional + " and a.mcaj_ncorr  in (select distinct mcaj_ncorr "& vbCrLf &_
    												"	from traspasos_cajas_softland "& vbCrLf &_
    												"	where protic.trunc(audi_fmodificacion) = convert(datetime,'"&v_fecha_traspaso&"',103))"& vbCrLf 
end if		

		
'response.Write("Sql Adicional :<pre>"&sql_adicional&"</pre>")
if request.QueryString <> "" then
'	cajas_abiertas_cons = "select a.*,(select case when count(*)>0 then 'SI' else 'NO' end from ingresos where mcaj_ncorr=a.mcaj_ncorr and eing_ccod not in (3,6)) as movimientos, "& vbCrLf &_
'						" (select case when count(*)>0 then 'SI' else 'NO' end from ingresos where mcaj_ncorr=a.mcaj_ncorr and eing_ccod not in (3,6) and ting_ccod not in(8)) as no_conciliacion "& vbCrLf &_
'						" from ( " & vbCrLf &_
'						" select mcaj_ncorr,mcaj_ncorr as mcaj_ncorr_paso,mcaj_finicio,mcaj_ftermino,mcaj_mrendicion " & vbCrLf &_
'						"        , pers_tnombre + ' ' + pers_tape_paterno as nombre " & vbCrLf &_
'						"        , a.ecua_ccod, a.eren_ccod, d.tcaj_tdesc , a.sede_ccod," & vbCrLf &_
'						"(select sum(cast(isnull(b.mcaj_mtotal, 0) as numeric)) as total"& vbCrLf &_
'						"from"& vbCrLf &_
'						"(select e.mcaj_ncorr, b.inst_ccod, b.tdoc_ccod, b.tdoc_tdesc "& vbCrLf &_
'      					"from movimientos_cajas e,"& vbCrLf &_
'						"(select e.inst_ccod, e.tdoc_ccod, b.tdoc_tdesc"& vbCrLf &_
'						"from documentos_instituciones e, tipos_documentos_mov_cajas b"& vbCrLf &_
' 						"where e.tdoc_ccod = b.tdoc_ccod"& vbCrLf &_
' 						"and cast(e.inst_ccod as varchar)= '1') b "& vbCrLf &_
'						"where cast(e.mcaj_ncorr as varchar)= cast(a.mcaj_ncorr as varchar)) d, detalle_mov_cajas b" & vbCrLf &_
'						"where d.mcaj_ncorr *= b.mcaj_ncorr"& vbCrLf &_
'  						"and d.inst_ccod *= b.inst_ccod"& vbCrLf &_
' 						" and d.tdoc_ccod *= b.tdoc_ccod"& vbCrLf &_
'						"group by d.mcaj_ncorr)as total"& vbCrLf &_
'						" from movimientos_cajas a,cajeros b,personas c,tipos_caja d" & vbCrLf &_
'						" where a.caje_ccod = b.caje_ccod" & vbCrLf &_
'						"    and a.sede_ccod = b.sede_ccod" & vbCrLf &_
'						"    and b.pers_ncorr = c.pers_ncorr" & vbCrLf &_
'						"    and a.tcaj_ccod = d.tcaj_ccod" & vbCrLf &_
'						"    and a.tcaj_ccod not in (1002,1005) " & vbCrLf &_
'						"    "&sql_adicional&" " & vbCrLf &_
'						"    ) a "& vbCrLf &_
'						"  order by a.mcaj_ncorr desc "

	cajas_abiertas_cons = "select a.mcaj_ncorr, a.mcaj_ncorr_paso, a.mcaj_finicio, a.mcaj_ftermino, a.mcaj_mrendicion, a.nombre, " & vbCrLf &_
						"		a.ecua_ccod, a.eren_ccod, a.tcaj_tdesc, a.sede_ccod, a.total, " & vbCrLf &_
						"			( " & vbCrLf &_
						"			select case when count(*)>0 then 'SI' else 'NO' end " & vbCrLf &_
						"			from ingresos " & vbCrLf &_
						"			where mcaj_ncorr = a.mcaj_ncorr " & vbCrLf &_
						"			and eing_ccod not in (3,6) " & vbCrLf &_
						"			) as movimientos, " & vbCrLf &_
						"			( " & vbCrLf &_
						"			select case when count(*)>0 then 'SI' else 'NO' end " & vbCrLf &_
						"			from ingresos " & vbCrLf &_
						"			where mcaj_ncorr = a.mcaj_ncorr " & vbCrLf &_
						"			and eing_ccod not in (3,6) " & vbCrLf &_
						"			and ting_ccod not in(8) " & vbCrLf &_
						"			) as no_conciliacion " & vbCrLf &_
						"from " & vbCrLf &_
						"	( " & vbCrLf &_
						"	select mcaj_ncorr,mcaj_ncorr as mcaj_ncorr_paso,mcaj_finicio,mcaj_ftermino,mcaj_mrendicion " & vbCrLf &_
						"	, pers_tnombre + ' ' + pers_tape_paterno as nombre " & vbCrLf &_
						"	, a.ecua_ccod, a.eren_ccod, d.tcaj_tdesc , a.sede_ccod, " & vbCrLf &_
						"	( " & vbCrLf &_
						"		select sum(cast(isnull(b.mcaj_mtotal, 0) as numeric)) as total " & vbCrLf &_
						"		from " & vbCrLf &_
						"		( " & vbCrLf &_
						"			select e.mcaj_ncorr, b.inst_ccod, b.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
						"			from movimientos_cajas e " & vbCrLf &_
						"			INNER JOIN " & vbCrLf &_
						"			( " & vbCrLf &_
						"				select e.inst_ccod, e.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
						"				from documentos_instituciones e " & vbCrLf &_
						"				INNER JOIN tipos_documentos_mov_cajas b " & vbCrLf &_
						"				ON e.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
						"				and cast(e.inst_ccod as varchar) = '1' " & vbCrLf &_
						"			) b " & vbCrLf &_
						"			ON cast(e.mcaj_ncorr as varchar) = cast(a.mcaj_ncorr as varchar) " & vbCrLf &_
						"		) d " & vbCrLf &_
						"		LEFT OUTER JOIN detalle_mov_cajas b " & vbCrLf &_
						"		ON d.mcaj_ncorr = b.mcaj_ncorr " & vbCrLf &_
						"		and d.inst_ccod = b.inst_ccod " & vbCrLf &_
						"		and d.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
						"		group by d.mcaj_ncorr " & vbCrLf &_
						"	) as total " & vbCrLf &_
						"	from movimientos_cajas a " & vbCrLf &_
						"	INNER JOIN cajeros b " & vbCrLf &_
						"	ON a.caje_ccod = b.caje_ccod and a.sede_ccod = b.sede_ccod and a.tcaj_ccod not in (1002,1005) " & vbCrLf &_
						"    "&sql_adicional&" " & vbCrLf &_
						"    INNER JOIN personas c " & vbCrLf &_
						"    ON b.pers_ncorr = c.pers_ncorr " & vbCrLf &_
						"    INNER JOIN tipos_caja d " & vbCrLf &_
						"    ON a.tcaj_ccod = d.tcaj_ccod " & vbCrLf &_
						"    ) a " & vbCrLf &_
						"order by a.mcaj_ncorr desc "

else
	cajas_abiertas_cons="select '' where 1=2 " 
end if			 

'response.Write("<pre>"&cajas_abiertas_cons&"</pre>")
'response.End()				 

'"    and a.eren_ccod not in (3,4,5)" & vbCrLf &_

formulario.consultar cajas_abiertas_cons

formulario.agregaCampoParam "ecua_ccod","permiso", "lectura"
formulario.agregaCampoParam "eren_ccod","permiso", "lectura"

%>


<html>
<head>
<title> Historial de Cajas </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
    <td width="11%"><div align="center"><strong>Cajero</strong></div></td>
    <td width="11%"><div align="center"><strong>Estado</strong></div></td>
    <td width="14%"><div align="center"><strong>Tipo</strong></div></td>
    <td width="8%"><div align="center"><strong>Apertura</strong></div></td>
    <td width="11%"><div align="center"><strong>N&ordm; Caja</strong></div></td>
    <td width="11%"><div align="center"><strong>Sede</strong></div></td>
	<td width="11%"><div align="center"><strong>Movimientos</strong></div></td>
	<td width="11%"><div align="center"><strong>Mov.distintos conciliaciones</strong></div></td>
	<td width="11%"><div align="center"><strong>Total Rendido</strong></div></td>
  </tr>
  <%  while formulario.Siguiente %>
  <tr> 
   <td><div align="left"><%=formulario.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=formulario.dibujaCampo("eren_ccod")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("tcaj_tdesc")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("mcaj_finicio")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("mcaj_ncorr")%></div></td>
    <td><div align="left"><%=formulario.dibujaCampo("sede_ccod")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("movimientos")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("no_conciliacion")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("total")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>