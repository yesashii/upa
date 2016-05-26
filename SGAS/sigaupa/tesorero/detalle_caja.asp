<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: MODULO TESORERO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:12/02/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:132,149 - 201,204,209,210,211
'********************************************************************
q_mcaj_ncorr = Request.QueryString("mcaj_ncorr")
q_leng = Request.QueryString("leng")
if EsVacio(q_leng) then
	q_leng = "1"
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Cuadratura de Cajas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "detalle_caja.xml", "botonera"

set f_botonera2 = new CFormulario
f_botonera2.Carga_Parametros "rendicion_cajas.xml", "botonera"

'---------------------------------------------------------------------------------------------------

set f_movimiento_caja = new CFormulario
f_movimiento_caja.Carga_Parametros "detalle_caja.xml", "movimiento_caja"
f_movimiento_caja.Inicializar conexion

'consulta = "select obtener_rut(b.pers_ncorr) as rut, obtener_nombre_completo(b.pers_ncorr) as nombre_completo, a.mcaj_ncorr, a.mcaj_ncorr as c_mcaj_ncorr, a.mcaj_finicio, sysdate as fecha_emision, a.mcaj_mrendicion " & vbCrLf &_
'           "from movimientos_cajas a, cajeros b " & vbCrLf &_
'		   "where a.sede_ccod = b.sede_ccod " & vbCrLf &_
'		   "  and a.caje_ccod = b.caje_ccod " & vbCrLf &_
'		   "  and a.mcaj_ncorr = '" & q_mcaj_ncorr & "'"
		   
consulta = "select protic.obtener_rut(b.pers_ncorr) as rut," & vbCrLf &_
			"    protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"    a.mcaj_ncorr, a.mcaj_ncorr as c_mcaj_ncorr, a.mcaj_finicio," & vbCrLf &_
			"    getdate() as fecha_emision, a.mcaj_mrendicion " & vbCrLf &_
			"from movimientos_cajas a, cajeros b " & vbCrLf &_
			"where a.sede_ccod = b.sede_ccod " & vbCrLf &_
			"  and a.caje_ccod = b.caje_ccod " & vbCrLf &_
			"  and cast(a.mcaj_ncorr as varchar) = '" & q_mcaj_ncorr & "'"

f_movimiento_caja.Consultar consulta


'-----------------------------------------------------------------------------------------------
v_inst_ccod = "1"
'-----------------------------------------------------------------------------------------------

if q_leng = "1" then
	set f_rendicion_sistema = new CFormulario
	f_rendicion_sistema.Carga_Parametros "detalle_caja.xml", "rendicion"
	f_rendicion_sistema.Inicializar conexion
	
	'consulta = "select b.tdoc_ccod, b.ting_ccod, b.tdoc_tdesc, nvl(c.cantidad, 0) as ndocumentos, nvl(c.total, 0) as total " & vbCrLf &_
	'		   "from documentos_instituciones a, tipos_documentos_mov_cajas b,  " & vbCrLf &_
	'		   "     (select 6 as ting_ccod, count(distinct a.ingr_nfolio_referencia) as cantidad, sum(a.ingr_mefectivo - total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')) as total " & vbCrLf &_
	'		   "	  from ingresos a, tipos_ingresos b " & vbCrLf &_
	'		   "	  where a.ting_ccod = b.ting_ccod " & vbCrLf &_
	'		   "	    and nvl(b.ting_brebaje, 'N') <> 'S' " & vbCrLf &_
	'		   "		and nvl(a.ingr_mefectivo, 0) > 0 " & vbCrLf &_
	'		   "        and a.eing_ccod <> 3 " & vbCrLf &_
	'		   "	    and mcaj_ncorr = '" & q_mcaj_ncorr & "' " & vbCrLf &_
	'		   "	  union " & vbCrLf &_
	'		   "	  select b.ting_ccod, count(*) as cantidad, sum(b.ding_mdetalle - total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')) as total " & vbCrLf &_
	'		   "	  from ingresos a, detalle_ingresos b, tipos_ingresos c " & vbCrLf &_
	'		   "	  where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
	'		   "	    and a.ting_ccod = c.ting_ccod " & vbCrLf &_
	'		   "		and nvl(c.ting_brebaje, 'N') <> 'S' " & vbCrLf &_
	'		   "        and a.eing_ccod <> 3  " & vbCrLf &_
	'		   "	    and a.mcaj_ncorr = '" & q_mcaj_ncorr & "' " & vbCrLf &_
	'		   "	  group by b.ting_ccod) c  " & vbCrLf &_
	'		   "where a.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
	'		   "  and b.ting_ccod = c.ting_ccod (+) " & vbCrLf &_
	'		   "  and a.inst_ccod = '" & v_inst_ccod & "' " & vbCrLf &_
	'		   "order by a.tdoc_ccod"
			   
			   
'consulta = "select b.tdoc_ccod, b.ting_ccod, b.tdoc_tdesc, isnull(c.cantidad, 0) as ndocumentos, cast(isnull(c.total, 0) as numeric) as total " & vbCrLf &_
'			"from documentos_instituciones a, tipos_documentos_mov_cajas b," & vbCrLf &_
'			"(select 6 as ting_ccod, count(distinct a.ingr_nfolio_referencia) as cantidad" & vbCrLf &_
'			"    ,cast(sum(a.ingr_mefectivo - protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')) as numeric) as total " & vbCrLf &_
'			" from ingresos a,tipos_ingresos b" & vbCrLf &_
'			" where a.ting_ccod = b.ting_ccod       " & vbCrLf &_
'			"    and isnull(b.ting_brebaje, 'N') <> 'S'" & vbCrLf &_
'			"    and isnull(a.ingr_mefectivo, 0) > 0 " & vbCrLf &_
'			"    and a.eing_ccod not in(3,6)" & vbCrLf &_
'			"    and mcaj_ncorr = '" & q_mcaj_ncorr & "'" & vbCrLf &_
'			"union" & vbCrLf &_
'			"select b.ting_ccod, count(*) as cantidad" & vbCrLf &_
'			"    ,cast(sum(b.ding_mdetalle - protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')) as numeric) as total " & vbCrLf &_
'			" from ingresos a,detalle_ingresos b,tipos_ingresos c" & vbCrLf &_
'			" where a.ingr_ncorr = b.ingr_ncorr    " & vbCrLf &_
'			"    and a.ting_ccod = c.ting_ccod" & vbCrLf &_
'			"    and isnull(c.ting_brebaje, 'N') <> 'S'" & vbCrLf &_
'			"    and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "'" & vbCrLf &_
'			"    and a.eing_ccod not in(3,6)" & vbCrLf &_
'			"    group by b.ting_ccod " & vbCrLf &_
'			" ) c" & vbCrLf &_
'			" where a.tdoc_ccod = b.tdoc_ccod" & vbCrLf &_
'			"    and b.ting_ccod *= c.ting_ccod" & vbCrLf &_
'			" and a.tdoc_ccod not in (25) " & vbCrLf &_
'			"    and cast(a.inst_ccod as varchar)= '" & v_inst_ccod & "'"

consulta = "select b.tdoc_ccod, b.ting_ccod, b.tdoc_tdesc, isnull(c.cantidad, 0) as ndocumentos, cast(isnull(c.total, 0) as numeric) as total " & vbCrLf &_
			"from documentos_instituciones a INNER JOIN tipos_documentos_mov_cajas b " & vbCrLf &_
			" ON a.tdoc_ccod = b.tdoc_ccod and a.tdoc_ccod not in (25) and cast(a.inst_ccod as varchar)= '" & v_inst_ccod & "' " & vbCrLf &_
			" LEFT OUTER JOIN" & vbCrLf &_
			"(select 6 as ting_ccod, count(distinct a.ingr_nfolio_referencia) as cantidad" & vbCrLf &_
			"    ,cast(sum(a.ingr_mefectivo - protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')) as numeric) as total " & vbCrLf &_
			" from ingresos a INNER JOIN tipos_ingresos b " & vbCrLf &_
			"	ON a.ting_ccod = b.ting_ccod " & vbCrLf &_
			"    WHERE isnull(b.ting_brebaje, 'N') <> 'S' " & vbCrLf &_
			"    and isnull(a.ingr_mefectivo, 0) > 0 " & vbCrLf &_
			"    and a.eing_ccod not in(3,6)" & vbCrLf &_
			"    and mcaj_ncorr = '" & q_mcaj_ncorr & "'" & vbCrLf &_
			"union" & vbCrLf &_
			"select b.ting_ccod, count(*) as cantidad" & vbCrLf &_
			"    ,cast(sum(b.ding_mdetalle - protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')) as numeric) as total " & vbCrLf &_
			" from ingresos a INNER JOIN detalle_ingresos b " & vbCrLf &_
			"	ON a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
			"	INNER JOIN tipos_ingresos c " & vbCrLf &_
			"    ON a.ting_ccod = c.ting_ccod and isnull(c.ting_brebaje, 'N') <> 'S' " & vbCrLf &_
			"    WHERE cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "'" & vbCrLf &_
			"    and a.eing_ccod not in(3,6)" & vbCrLf &_
			"    group by b.ting_ccod " & vbCrLf &_
			" ) c" & vbCrLf &_
			" ON b.ting_ccod = c.ting_ccod " 

	'response.Write("<pre>"&consulta&"</pre>")		
	f_rendicion_sistema.Consultar consulta
	f_rendicion_sistema.AgregaCampoCons "mcaj_ncorr", q_mcaj_ncorr
	
	'------------------------------------------------------------------
	set f_rendicion_cajero = new CFormulario
	f_rendicion_cajero.Carga_Parametros "detalle_caja.xml", "rendicion"
	f_rendicion_cajero.Inicializar conexion
	
	'consulta = "select a.mcaj_ncorr, a.inst_ccod, a.tdoc_ccod, a.tdoc_tdesc, " & vbCrLf &_
	'		   "       nvl(b.mcaj_mtotal, 0) as total, nvl(b.mcaj_mneto, 0) as mcaj_mneto, " & vbCrLf &_
	'		   "	   nvl(b.mcaj_mexento, 0) as mcaj_mexento, nvl(b.mcaj_miva, 0) as mcaj_miva, to_number(nvl(b.mcaj_ncantidad, 0)) as ndocumentos, " & vbCrLf &_
	'		   "	   b.mcaj_desde, b.mcaj_hasta " & vbCrLf &_
	'		   "from (select a.mcaj_ncorr, b.inst_ccod, b.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
	'		   "      from movimientos_cajas a, " & vbCrLf &_
	'		   "	       (select a.inst_ccod, a.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
	'		   "		    from documentos_instituciones a, tipos_documentos_mov_cajas b " & vbCrLf &_
	'		   "			where a.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
	'		   "			  and a.inst_ccod = '" & v_inst_ccod & "') b " & vbCrLf &_
	'		   "	  where a.mcaj_ncorr = '" & q_mcaj_ncorr & "') a, detalle_mov_cajas b " & vbCrLf &_
	'		   "where a.mcaj_ncorr = b.mcaj_ncorr (+) " & vbCrLf &_
	'		   "  and a.inst_ccod = b.inst_ccod (+) " & vbCrLf &_
	'		   "  and a.tdoc_ccod = b.tdoc_ccod (+) " & vbCrLf &_
	'		   "order by a.tdoc_ccod asc"
			   
'consulta = "select a.mcaj_ncorr, a.inst_ccod, a.tdoc_ccod, a.tdoc_tdesc, " & vbCrLf &_
'			"       cast(isnull(b.mcaj_mtotal, 0) as numeric) as total, isnull(b.mcaj_mneto, 0) as mcaj_mneto, " & vbCrLf &_
'			"	   isnull(b.mcaj_mexento, 0) as mcaj_mexento, isnull(b.mcaj_miva, 0) as mcaj_miva," & vbCrLf &_
'			"       cast((isnull(b.mcaj_ncantidad, 0)) as numeric) as ndocumentos, " & vbCrLf &_
'			"	   b.mcaj_desde, b.mcaj_hasta" & vbCrLf &_
'			"from" & vbCrLf &_
'			"(select a.mcaj_ncorr, b.inst_ccod, b.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
'			"      from movimientos_cajas a," & vbCrLf &_
'			"(select a.inst_ccod, a.tdoc_ccod, b.tdoc_tdesc" & vbCrLf &_
'			" from documentos_instituciones a, tipos_documentos_mov_cajas b" & vbCrLf &_
'			" where a.tdoc_ccod = b.tdoc_ccod" & vbCrLf &_
'			"    and cast(a.inst_ccod as varchar)= '" & v_inst_ccod & "') b " & vbCrLf &_
'			"where cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "') a, detalle_mov_cajas b " & vbCrLf &_
'			"where a.mcaj_ncorr *= b.mcaj_ncorr" & vbCrLf &_
'			"  and a.inst_ccod *= b.inst_ccod" & vbCrLf &_
'			"  and a.tdoc_ccod *= b.tdoc_ccod" & vbCrLf &_
'			"order by a.tdoc_ccod asc"

consulta = "select a.mcaj_ncorr, a.inst_ccod, a.tdoc_ccod, a.tdoc_tdesc, " & vbCrLf &_
			"       cast(isnull(b.mcaj_mtotal, 0) as numeric) as total, isnull(b.mcaj_mneto, 0) as mcaj_mneto, " & vbCrLf &_
			"	   isnull(b.mcaj_mexento, 0) as mcaj_mexento, isnull(b.mcaj_miva, 0) as mcaj_miva," & vbCrLf &_
			"       cast((isnull(b.mcaj_ncantidad, 0)) as numeric) as ndocumentos, " & vbCrLf &_
			"	   b.mcaj_desde, b.mcaj_hasta" & vbCrLf &_
			"from " & vbCrLf &_
			"(select a.mcaj_ncorr, b.inst_ccod, b.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
			"	from movimientos_cajas a INNER JOIN " & vbCrLf &_
			"		(select a.inst_ccod, a.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
			"		from documentos_instituciones a " & vbCrLf &_
			"		INNER JOIN tipos_documentos_mov_cajas b " & vbCrLf &_
			"		ON a.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
			"		WHERE cast(a.inst_ccod as varchar)= '" & v_inst_ccod & "') b " & vbCrLf &_
			"	ON cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "') a " & vbCrLf &_
			"LEFT OUTER JOIN detalle_mov_cajas b " & vbCrLf &_
			"ON a.mcaj_ncorr = b.mcaj_ncorr " & vbCrLf &_
			"and a.inst_ccod = b.inst_ccod " & vbCrLf &_
			"and a.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
			"order by a.tdoc_ccod asc"
			
	'response.Write("<pre>" & consulta & "</pre>")
	f_rendicion_cajero.Consultar consulta
	f_rendicion_cajero.AgregaParam "editar", "FALSE"	
	
	f_rendicion_cajero.AgregaCampoParam "ndocumentos", "permiso", "OCULTO"
	f_rendicion_cajero.AgregaCampoParam "tdoc_tdesc", "ancho", "80%"
	
	
	'-------------------------------------------------------------------------------------------------
	set f_anulaciones_ingresos = new CFormulario
	f_anulaciones_ingresos.Carga_Parametros "detalle_caja.xml", "rendicion_JC"
	f_anulaciones_ingresos.Inicializar conexion
	
	consulta = "select d.ting_tdesc as tdoc_tdesc, a.ting_ccod, count(a.ingr_nfolio_referencia) as ndocumentos, cast(isnull(sum(a.ingr_mtotal),0) as numeric) as total " & vbCrLf &_
	           "from ingresos a, notascreditos_documentos b, ingresos c, tipos_ingresos d " & vbCrLf &_
			   "where a.ingr_ncorr = b.ingr_ncorr_notacredito " & vbCrLf &_
			   "  and b.ingr_ncorr_documento = c.ingr_ncorr " & vbCrLf &_
			   "  and a.ting_ccod = d.ting_ccod " & vbCrLf &_
			   "  and a.eing_ccod <> 3  " & vbCrLf &_
			   "  and a.ting_ccod = '30' " & vbCrLf &_
			   "  and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
			   "group by d.ting_tdesc, a.ting_ccod"
	
'consulta = "select d.ting_tdesc as tdoc_tdesc, a.ting_ccod," & vbCrLf &_
'			"    count(a.ingr_nfolio_referencia) as ndocumentos,cast(sum(a.ingr_mtotal) as numeric) as total" & vbCrLf &_
'			" from ingresos a,notascreditos_documentos b,ingresos c,tipos_ingresos d" & vbCrLf &_
'			" where a.ingr_ncorr = b.ingr_ncorr_notacredito" & vbCrLf &_
'			"    and b.ingr_ncorr_documento = c.ingr_ncorr" & vbCrLf &_
'			"    and a.ting_ccod = d.ting_ccod" & vbCrLf &_
'			"    and a.eing_ccod <> 3" & vbCrLf &_
'			"    and a.ting_ccod = '30' " & vbCrLf &_
'			"    and a.mcaj_ncorr = '" & q_mcaj_ncorr & "'" & vbCrLf &_
'			"    group by d.ting_tdesc, a.ting_ccod, a.ingr_mtotal"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()			

	f_anulaciones_ingresos.Consultar consulta
	f_anulaciones_ingresos.AgregaCampoCons "mcaj_ncorr", q_mcaj_ncorr

'-----------------------------------------------
'-------	ANULACION DE CONTRATOS -------------
	set f_anulaciones_contratos = new CFormulario
	f_anulaciones_contratos.Carga_Parametros "detalle_caja.xml", "contratos_nulos"
	f_anulaciones_contratos.Inicializar conexion
	
	sql_contratos_nulos="select 'CONTRATOS ANULADOS' as tdoc_tdesc,a.econ_ccod,sum(e.ingr_mtotal) as total_nulo from " & vbCrLf &_
						" contratos a  " & vbCrLf &_
						" join compromisos b " & vbCrLf &_
						"     on a.cont_ncorr=b.comp_ndocto " & vbCrLf &_
						" join detalle_compromisos c " & vbCrLf &_
						"     on b.comp_ndocto    = c.comp_ndocto " & vbCrLf &_
						"     and b.tcom_ccod     = c.tcom_ccod " & vbCrLf &_
						"     and b.inst_ccod     = c.inst_ccod " & vbCrLf &_
						" join abonos d " & vbCrLf &_
						"     on  c.comp_ndocto       = d.comp_ndocto " & vbCrLf &_
						"     and c.tcom_ccod         = d.tcom_ccod " & vbCrLf &_
						"     and c.inst_ccod         = d.inst_ccod " & vbCrLf &_
						"     and c.dcom_ncompromiso  = d.dcom_ncompromiso " & vbCrLf &_
						" join ingresos e " & vbCrLf &_
						"     on d.ingr_ncorr=e.ingr_ncorr " & vbCrLf &_
						" where e.mcaj_ncorr="&q_mcaj_ncorr&"  " & vbCrLf &_
						" and e.ting_ccod=7 " & vbCrLf &_
						" and a.econ_ccod=3 " & vbCrLf &_
						" group by a.econ_ccod "
	
	f_anulaciones_contratos.Consultar sql_contratos_nulos
	v_cantidad= f_anulaciones_contratos.nroFilas
	'response.Write(v_cantidad)

	if v_cantidad=0 then
		f_anulaciones_contratos.AgregaCampoCons "total_nulo", v_cantidad
	end if
	f_anulaciones_contratos.AgregaCampoCons "num_contratos", v_cantidad


'------------------------------------------------
'-------		PROTESTOS LETRAS 	-------------
	set f_protestos_letras= new CFormulario
	f_protestos_letras.Carga_Parametros "detalle_caja.xml", "protestos_letras"
	f_protestos_letras.Inicializar conexion
	
	'sql_contratos_nulos="select 'PROTESTOS DE LETRAS' as tdoc_tdesc,a.cont_ncorr,sum(e.ingr_mtotal) as total_nulo from " & vbCrLf &_
						
	'sql_contratos_nulos="SELECT ''"
	
	sql_protestos_letras= 	" Select 'GASTOS PROTESTOS' as tdoc_tdesc,a.mcaj_ncorr," & vbCrLf &_
							"		cast(sum(b.ding_mdetalle - protic.total_rebajado_ingreso(a.ingr_ncorr, '"&q_mcaj_ncorr&"')) as numeric) as total_protesto," & vbCrLf &_
							"		count(a.ingr_ncorr) as num_protestos " & vbCrLf &_
							"			From ingresos a,detalle_ingresos b " & vbCrLf &_
							"			Where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
							"				and a.eing_ccod not in (3,6) " & vbCrLf &_
							"				and cast(a.mcaj_ncorr as varchar)= '"&q_mcaj_ncorr&"' " & vbCrLf &_
							"				and cast(b.ting_ccod as varchar) = 87 " & vbCrLf &_
							"				Group by a.mcaj_ncorr " 
	
	f_protestos_letras.Consultar sql_protestos_letras
	v_cantidad_protestos= f_protestos_letras.nroFilas
	if v_cantidad_protestos=0 then
		f_protestos_letras.Consultar "select ''"
		f_protestos_letras.AgregaCampoCons "num_protestos", 0
		f_protestos_letras.AgregaCampoCons "total_protesto", 0
	end if
	'f_protestos_letras.AgregaCampoCons "num_protestos", v_cantidad_protestos




'------------------------------------------------
'---------------	BOLETAS		-----------------
set f_boletas= new CFormulario
f_boletas.Carga_Parametros "detalle_caja.xml", "boletas"
f_boletas.Inicializar conexion

	sql_boletas =	" Select 'BOLETAS' as tdoc_tdesc,a.mcaj_ncorr ," & vbCrLf &_
					" sum (a.bole_mtotal) as total_boletas, count(*) as cantidad " & vbCrLf &_
					" From boletas a " & vbCrLf &_
					" where cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
					" and ebol_ccod not in (3) "& vbCrLf &_
					"	group by a.mcaj_ncorr   " 

f_boletas.Consultar sql_boletas
	v_cantidad_boletas= f_boletas.nroFilas
	if v_cantidad_boletas=0 then
		f_boletas.Consultar "select ''"
		f_boletas.AgregaCampoCons "cantidad", 0
		f_boletas.AgregaCampoCons "total_boletas", 0
	end if

'-------------------------------------------------------------------------------
end if

if q_leng = "2" then
	set f_ingresos = new CFormulario
	f_ingresos.Carga_Parametros "detalle_caja.xml", "ingresos"
	f_ingresos.Inicializar conexion
	
			   
consulta = "select a.ingr_ncorrelativo_caja,a.ting_ccod,  a.ingr_nfolio_referencia," & vbCrLf &_
            "    protic.trunc(a.ingr_fpago) as ingr_fpago," & vbCrLf &_
			"    isnull(sum(a.ingr_mefectivo),0) as ingr_mefectivo," & vbCrLf &_
			"    sum(a.ingr_mdocto) as ingr_mdocto, sum(a.ingr_mtotal) as ingr_mtotal, b.ting_tdesc," & vbCrLf &_
			"    protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"    sum(case " & vbCrLf &_
			"            when isnull(a.ingr_mefectivo, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')" & vbCrLf &_
			"            else 0" & vbCrLf &_
			"        end) as anulado_efectivo," & vbCrLf &_
			"    sum(case " & vbCrLf &_
			"            when isnull(a.ingr_mdocto, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')" & vbCrLf &_
			"            else 0" & vbCrLf &_
			"        end) as anulado_documentos," & vbCrLf &_
			"    sum(protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')) as total_anulado," & vbCrLf &_
			"    sum(isnull(a.ingr_mefectivo,0) - " & vbCrLf &_
			"                case " & vbCrLf &_
			"                    when isnull(a.ingr_mefectivo, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')" & vbCrLf &_
			"                    else 0" & vbCrLf &_
			"                end) as saldo_efectivo," & vbCrLf &_
			"    sum(a.ingr_mdocto - " & vbCrLf &_
			"                case " & vbCrLf &_
			"                    when isnull(a.ingr_mdocto, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "') " & vbCrLf &_
			"                    else 0" & vbCrLf &_
			"                end) as saldo_documentos," & vbCrLf &_
			"    sum(cast(a.ingr_mtotal as numeric) - protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')) as saldo_total" & vbCrLf &_
			"    from ingresos a,tipos_ingresos b" & vbCrLf &_
			"    where a.ting_ccod = b.ting_ccod" & vbCrLf &_
			"        and a.eing_ccod not in (3,7)" & vbCrLf &_
			"        and isnull(b.ting_brebaje, 'N') <> 'S'" & vbCrLf &_
			"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "'" & vbCrLf &_
			"        --and a.eing_ccod not in (3,6)   "& vbCrLf &_
			"group by a.ingr_ncorrelativo_caja,a.ting_ccod, a.ingr_nfolio_referencia, protic.trunc(a.ingr_fpago), a.pers_ncorr, b.ting_tdesc" & vbCrLf &_
			"order by ingr_nfolio_referencia asc, nombre_completo asc"
	
'************************************************************
'*********** CONSULTA CON CAJAS NULAS PARA MOSTRAR LAS ANULACIONES,
'*********** INDEPENDIENTE DE QUE CAJA LAS HA ANULADO.
consulta = "select a.ingr_ncorrelativo_caja,a.ting_ccod,  a.ingr_nfolio_referencia," & vbCrLf &_
            "    protic.trunc(a.ingr_fpago) as ingr_fpago," & vbCrLf &_
			"    cast(isnull(sum(a.ingr_mefectivo),0) as numeric) as ingr_mefectivo," & vbCrLf &_
			"    cast(sum(a.ingr_mdocto) as numeric) as ingr_mdocto, cast(sum(a.ingr_mtotal) as numeric) as ingr_mtotal, b.ting_tdesc," & vbCrLf &_
			"    protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"    sum(case " & vbCrLf &_
			"            when isnull(a.ingr_mefectivo, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,1) " & vbCrLf &_
			"            else 0" & vbCrLf &_
			"        end) as anulado_efectivo," & vbCrLf &_
			"    sum(case " & vbCrLf &_
			"            when isnull(a.ingr_mdocto, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,4) " & vbCrLf &_
			"            else 0" & vbCrLf &_
			"        end) as anulado_documentos," & vbCrLf &_
			"    sum(protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,null) ) as total_anulado," & vbCrLf &_
			"    sum(isnull(a.ingr_mefectivo,0) - " & vbCrLf &_
			"                case " & vbCrLf &_
			"                    when isnull(a.ingr_mefectivo, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,1) " & vbCrLf &_
			"                    else 0" & vbCrLf &_
			"                end) as saldo_efectivo," & vbCrLf &_
			"    sum(a.ingr_mdocto - " & vbCrLf &_
			"                case " & vbCrLf &_
			"                    when isnull(a.ingr_mdocto, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,4)  " & vbCrLf &_
			"                    else 0" & vbCrLf &_
			"                end) as saldo_documentos," & vbCrLf &_
			"    sum(cast(a.ingr_mtotal as numeric) - (protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,null)) ) as saldo_total" & vbCrLf &_
			"    from ingresos a,tipos_ingresos b" & vbCrLf &_
			"    where a.ting_ccod = b.ting_ccod" & vbCrLf &_
			"        and a.eing_ccod not in (3,7)" & vbCrLf &_
			"        and isnull(b.ting_brebaje, 'N') <> 'S'" & vbCrLf &_
			"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "'" & vbCrLf &_
			"group by a.ingr_ncorrelativo_caja,a.ting_ccod, a.ingr_nfolio_referencia, protic.trunc(a.ingr_fpago), a.pers_ncorr, b.ting_tdesc" & vbCrLf &_
			"order by a.ingr_ncorrelativo_caja,ingr_nfolio_referencia asc, nombre_completo asc"

	'response.Write("<pre>"&consulta&"</pre>")				
			
	f_ingresos.Consultar consulta  
	
	f_botonera.AgregaBotonUrlParam "exportar_excel_ingresos", "mcaj_ncorr", q_mcaj_ncorr
end if
'------------------------------------------------------------------------------------------
url_leng_1 = "detalle_caja.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=1"
url_leng_2 = "detalle_caja.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=2"
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<style>
@media print{ .noprint {visibility:hidden; }}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Imprimir()
{
	window.print();
}

function imprimir_docto(){
	window.open("../cajas/imprimir_docto_pagados.asp?mcaj_ncorr=<%=q_mcaj_ncorr%>","<%=q_mcaj_ncorr%>");
}
function imprimir_letras(){
	window.open("../cajas/imprimir_letras_pagados.asp?mcaj_ncorr=<%=q_mcaj_ncorr%>","<%=q_mcaj_ncorr%>");
}
function imprimir_cheques(){
	window.open("../cajas/imprimir_cheques_pagados.asp?mcaj_ncorr=<%=q_mcaj_ncorr%>","<%=q_mcaj_ncorr%>");
}
function imprimir_pagares(){
	window.open("../cajas/imprimir_pagare_pagados.asp?mcaj_ncorr=<%=q_mcaj_ncorr%>","<%=q_mcaj_ncorr%>");
}
function imprimir_tarjetas(){
	window.open("../cajas/imprimir_tarjetas_pagados.asp?mcaj_ncorr=<%=q_mcaj_ncorr%>","<%=q_mcaj_ncorr%>");
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Cuadratura de Cajas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
			  <br>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_movimiento_caja.DibujaRegistro%></div></td>
                </tr>
              </table>
</div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                      <br>                                            
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                      <tr>
                        <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                        <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                        <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                      </tr>
                      <tr>
                        <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td><%pagina.DibujarLenguetasFClaro Array(Array("Caja", url_leng_1), Array("Ingresos", url_leng_2)), CInt(q_leng) %></td>
                            </tr>
                            <tr>
                              <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                            </tr>
                            <tr>
                              <td><div align="left"><br>
							  
							        <%
									select case q_leng
										case "1"
									%>
							        <%pagina.DibujarSubtitulo("Estado de Caja")%>
                                      </div>                                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                          <td><div align="center"><%f_rendicion_sistema.DibujaTabla%></div></td>
                                        </tr>
									  </table>
									   <br> 
									  <%pagina.DibujarSubtitulo("Protestos Letras")%>
										<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
                                          <td><div align="center">
                                            <%f_protestos_letras.DibujaTabla%>
                                          </div></td>
                                        </tr>
                                      </table>
									   <br> 
									  <%pagina.DibujarSubtitulo("Boletas")%>
										<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
                                          <td><div align="center">
                                            <%f_boletas.DibujaTabla%>
                                          </div></td>
                                        </tr>
                                      </table>    									                                        
                                      <br>
                                      <%pagina.DibujarSubtitulo("Anulaciones de ingresos")%>
                                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                          <td><div align="center">
                                            <%f_anulaciones_ingresos.DibujaTabla%>
                                          </div></td>
                                        </tr>
										</table>
										<%pagina.DibujarSubtitulo("Anulaciones de Contratos")%>
										<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
                                          <td><div align="center">
                                            <%f_anulaciones_contratos.DibujaTabla%>
                                          </div></td>
                                        </tr>
                                      </table>                                      
                                      <br>                                      <br>
									  <%pagina.DibujarSubtitulo("Rendición Cajero")%>
									  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
										  <td><div align="center">
											  <%f_rendicion_cajero.DibujaTabla%>
										  </div></td>
										</tr>
									  </table>
						              <br>
						  <%
						  case "2" : titulo = "Ingresos"								
						  %>
						  <%pagina.DibujarSubtitulo("Ingresos")%>
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr>
                              <td><div align="center">
							  <%f_ingresos.DibujaTabla%>
							  </div></td>
                            </tr>
                          </table>
						  <br>
						  <%end select%>
</td>
                            </tr>
                        </table></td>
                        <td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="9" height="28"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
                        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="38%" height="20"><div align="center">
                                  <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td><div align="center"></div></td>
                                      <td><div align="center"></div></td>
                                      <td><div align="center"></div></td>
                                    </tr>
                                  </table>
                              </div></td>
                              <td width="62%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                            </tr>
                            <tr>
                              <td height="8" background="../imagenes/marco_claro/13.gif"></td>
                            </tr>
                        </table></td>
                        <td width="7" height="28"><img src="../imagenes/marco_claro/16.gif" width="7" height="28"></td>
                      </tr>
                    </table></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
	  <tr>
		  <td width="7" background="../imagenes/izq.gif">&nbsp;</td>
		  <td>
			  <table width="100%">
				  <tr>
				  	<td>&nbsp;</td>
					<td><%f_botonera2.DibujaBoton("imprimir_letras")%></td>
					<td><%f_botonera2.DibujaBoton("imprimir_cheques")%></td>
					<td><%f_botonera2.DibujaBoton("imprimir_pagares")%></td>
				  </tr>
			  </table>
		  </td>
		  <td width="7" background="../imagenes/der.gif">&nbsp;</td>
	  </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="11%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>				  
				  <%if q_leng="2" then%>
				  <td><div align="center"><%f_botonera.DibujaBoton("exportar_excel_ingresos")%></div></td>
				  <%end if%>
				   <td><div align="center"></div></td>
				   <td><div align="center">
				     <%f_botonera2.DibujaBoton("imprimir_docto")%>
				   </div></td>
				   <td><div align="center"></div></td>
				   <td><div align="center"></div></td>
				   <td><div align="center"><%f_botonera2.DibujaBoton("imprimir_tarjetas")%></div></td>				   
				   <td><div align="center"><%f_botonera.DibujaBoton("cerrar")%></div></td>                  
                </tr>
              </table>
            </div></td>
            <td width="89%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
