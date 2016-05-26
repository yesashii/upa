<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<title>Facturacion</title>

<body topmargin="0" onbeforeunload="cerrar_pagina();" >
<!-- #include file	= 	"../biblioteca/_negocio.asp" -->
<!-- #include file	=	"../biblioteca/_conexion.asp" -->
<!-- #include file	=	"../biblioteca/funciones_formateo.asp" -->
<%
'*******************************************************************
'DESCRIPCION		: Pagina para facturacion de ordenes de compra 
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		: codigo de factura, tipo factura, numero de factura, origen, pers_ncorr (empr_ncorr)
'SALIDA			:formato impreso de Factura
'MODULO QUE ES UTILIZADO: PACTACIÓN OTEC
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:03/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:232 - 424
'*******************************************************************
'FECHA ACTUALIZACION 	:05/07/2013
'ACTUALIZADO POR	:Mario Riffo I.
'MOTIVO			:Proyecto mejoras Otec
'*******************************************************************

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()


q_fact_nfactura	=	request.Querystring("factura")
q_pers_ncorr	=	request.Querystring("pers_ncorr")
q_tfac_ccod		= 	request.Querystring("tipo_factura")
q_fact_ncorr 	= 	request.querystring("fact_ncorr")
q_origen 		= 	request.querystring("origen")


c_pago= "30 Dias"


set conectar	= new cconexion
conectar.inicializar	"upacifico"

'set negocio		= new cnegocio
'negocio.inicializa		conectar

v_estado		=	conectar.ConsultaUno("select efac_ccod from facturas where fact_ncorr="&q_fact_ncorr)
v_correlativo	=	conectar.ConsultaUno("select isnull(fact_ncorrelativo,0) from facturas where fact_ncorr="&q_fact_ncorr)
v_horas			=	conectar.ConsultaUno("select isnull(fact_nhoras,0) from facturas where fact_ncorr="&q_fact_ncorr)
v_orco_ncorr	=	conectar.ConsultaUno("select orco_ncorr from facturas where fact_ncorr="&q_fact_ncorr)
v_mfac_ccod		=	conectar.ConsultaUno("select mfac_ccod from facturas where fact_ncorr="&q_fact_ncorr)
v_fact_bdivide	=	conectar.ConsultaUno("select isnull(fact_bdivide,'N') from facturas where fact_ncorr="&q_fact_ncorr)
v_correlativo	=	conectar.ConsultaUno("select fact_ncorrelativo from facturas where fact_ncorr="&q_fact_ncorr)

if v_estado<> "3" and v_estado<> "4" then '(facturas distintas de nula y vacia)
'******************************************************************************************
sql_oc_osociada	="select top 1 'Orden de compra N°: '+cast(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as varchar) "& vbCrLf &_
				"	from ingresos a, abonos b, facturas c "& vbCrLf &_
				"	where fact_ncorr="&q_fact_ncorr&" "& vbCrLf &_
				"	and a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_
				"   and b.abon_mabono >0  "& vbCrLf &_
				"	and a.ingr_nfolio_referencia=c.folio_abono_factura"
v_oc_asociada=conectar.consultaUno(sql_oc_osociada)

if q_fact_ncorr=931 then
	v_oc_asociada="Orden de compra N°: 424"
end if

if q_fact_ncorr=1003 or q_fact_ncorr=1002 then
	v_oc_asociada="Orden de compra N°: 115746"
end if

if q_fact_ncorr=1012 then
	v_oc_asociada="Orden de compra N°: 30"
end if

'******************************************************************************************
sql_comp_ndocto	="select top 1 b.comp_ndocto "& vbCrLf &_
				"	from ingresos a, abonos b, facturas c "& vbCrLf &_
				"	where fact_ncorr="&q_fact_ncorr&" "& vbCrLf &_
				"	and a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_
				"   and b.abon_mabono >0  "& vbCrLf &_
				"	and a.ingr_nfolio_referencia=c.folio_abono_factura"
				
v_comp_ndocto=conectar.consultaUno(sql_comp_ndocto)



'*******************************************************************************************

sql_oc_osociada	="select top 1 cast(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as varchar) "& vbCrLf &_
				"	from ingresos a, abonos b, facturas c "& vbCrLf &_
				"	where fact_ncorr="&q_fact_ncorr&" "& vbCrLf &_
				"	and a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_
				"   and b.abon_mabono >0  "& vbCrLf &_
				"	and a.ingr_nfolio_referencia=c.folio_abono_factura"
				
v_oc_registro =conectar.consultaUno(sql_oc_osociada)




sql_registro_sence = "select top 1 ocot_nro_registro_sence from ordenes_compras_otec a, postulacion_otec b "& vbCrLf &_ 
				   "	where cast(a.nord_compra as varchar)='"&v_oc_registro&"'  "& vbCrLf &_
				   "	and a.dgso_ncorr=b.dgso_ncorr "& vbCrLf &_
				   "	--and a.empr_ncorr  in (  "& vbCrLf &_
				   "		--select empr_ncorr from facturas where fact_ncorr="&q_fact_ncorr&")  "& vbCrLf &_
				   "	and b.pote_ncorr in (select top 1 pote_ncorr from postulantes_cargos_factura where fact_ncorr="&q_fact_ncorr&") "
				
				
'response.Write("<pre>"&sql_registro_sence&"</pre>")	
v_registro_sence=conectar.consultaUno(sql_registro_sence)
'response.End()


set f_listado_alumnos	= new cformulario
f_listado_alumnos.Carga_Parametros "consulta.xml", "consulta"

sql_alumnos =" select protic.obtener_rut(a.pers_ncorr)as rut, "& vbCrLf &_
			" protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre "& vbCrLf &_
			" from postulacion_otec a, personas b,postulantes_cargos_factura c "& vbCrLf &_
			" where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
			" and a.pote_ncorr=c.pote_ncorr "& vbCrLf &_
			" and epot_ccod not in (5) "& vbCrLf &_
			" and c.fact_ncorr="&q_fact_ncorr

f_listado_alumnos.inicializar conectar
f_listado_alumnos.consultar sql_alumnos

'******************************************************************************************

sql_dgso_ncorr =" select top 1 dgso_ncorr "& vbCrLf &_
			" from postulacion_otec a, personas b,postulantes_cargos_otec c "& vbCrLf &_
			" where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
			" and a.pote_ncorr=c.pote_ncorr "& vbCrLf &_
			" and cast(c.comp_ndocto as varchar)='"&v_comp_ndocto&"'"
'response.Write("<pre>"&sql_dgso_ncorr&"</pre>")	
	
v_dgso_ncorr=conectar.consultaUno(sql_dgso_ncorr)

set f_datos_otec	= new cformulario
f_datos_otec.Carga_Parametros "consulta.xml", "consulta"

'*********** FECHAS DE INICIO Y TERMINO EN LOS CURSOS ******************
if v_correlativo="0" then
	sql_termino=" 'INICIO:'+protic.trunc(dgso_finicio)+' TERMINO:'+protic.trunc(dgso_ftermino) as duracion_programa, "
end if

'***********************************************
'************** NUEVA FORMA DE CONSULTAR DATOS OTIC	**************
sql_datos_otec = 	"select case when dcur_nombre_sence is null or len(dcur_nombre_sence)=0 then dcur_tdesc else dcur_nombre_sence end as programa,"&_
					" anos_ccod,'INICIO:'+protic.trunc(dorc_finicio)+' TERMINO:'+protic.trunc(dorc_ffin) as duracion_programa,   "&_
					"dorc_mmonto, dorc_naccion_sence as num_sence, dorc_num_oc, dorc_nindice,dorc_nhoras as n_horas,d.dcur_nsence as cod_sence   "&_
					"from detalle_ordenes_compras_otec a, ordenes_compras_otec b, datos_generales_secciones_otec c, diplomados_cursos d  "&_
					" where a.orco_ncorr=b.orco_ncorr "&_
					" and b.dgso_ncorr=c.dgso_ncorr "&_
					" and c.dcur_ncorr=d.dcur_ncorr "&_
					" and a.orco_ncorr="&v_orco_ncorr&"  "&_
					" and a.empr_ncorr="&q_pers_ncorr&" "&_
					" and a.dorc_nindice="&v_correlativo&" "

'response.Write("<pre>"&sql_datos_otec&"</pre>")
'response.End()	
f_datos_otec.inicializar conectar
f_datos_otec.consultar sql_datos_otec

'************** FORMA ANTIGUA DE CONSULTAR DATOS OTIC	**************
if f_datos_otec.Nrofilas=0 then

	sql_datos_otec =" select  case when dcur_nombre_sence is null or len(dcur_nombre_sence)=0 then dcur_tdesc else dcur_nombre_sence end as programa, "&_
					" sede_tdesc as sede,b.DCUR_NSENCE as cod_sence, b.dcur_nro_registro_sence as num_sence, "& vbCrLf &_
					" "&sql_termino&" "& vbCrLf &_
					" (select sum(maot_nhoras_programa) from mallas_otec mo where mo.dcur_ncorr=b.dcur_ncorr group by mo.dcur_ncorr) as n_horas "& vbCrLf &_
					" from datos_generales_secciones_otec a,  diplomados_cursos b, sedes c "& vbCrLf &_
					" where a.dcur_ncorr=b.dcur_ncorr "& vbCrLf &_
					" and a.sede_ccod=c.sede_ccod "& vbCrLf &_
					" and cast(a.dgso_ncorr as varchar)='"&v_dgso_ncorr&"'"
	
	f_datos_otec.inicializar conectar
	f_datos_otec.consultar sql_datos_otec				
					
end if

if f_datos_otec.Nrofilas>0 then
	f_datos_otec.siguiente
	programa	= 	f_datos_otec.obtenerValor("programa")
	duracion	= 	f_datos_otec.obtenerValor("duracion_programa")
	cod_sence	= 	f_datos_otec.obtenerValor("cod_sence") '// Codigo Sence
	num_sence	= 	f_datos_otec.obtenerValor("num_sence") '// Numero de accion Sence
	num_horas	= 	f_datos_otec.obtenerValor("n_horas")

'	if v_horas >"0" then
'		num_horas	=   v_horas
'	else
'		num_horas	= 	f_datos_otec.obtenerValor("n_horas")
'	end if
end if		

if num_sence="" or EsVacio(num_sence) then
	num_sence=v_registro_sence	
end if

'******************************************************************************************




		set f_datos_factura		= new cformulario
		f_datos_factura.Carga_Parametros "consulta.xml", "consulta"
		
		sql_consulta_factura= 	" select isnull(fact_mneto,0) as fact_mneto, isnull(fact_miva,0) as fact_miva  from facturas c "& vbCrLf &_
								"	where fact_ncorr="&q_fact_ncorr&""& vbCrLf &_
								" 	and tfac_ccod="&q_tfac_ccod

		f_datos_factura.inicializar		conectar
		f_datos_factura.consultar sql_consulta_factura
		f_datos_factura.siguienteF
		
		v_monto_neto	=	f_datos_factura.obtenerValor("fact_mneto")
		v_monto_iva		=	f_datos_factura.obtenerValor("fact_miva")
'******************************************************************************************
		set f_datos_empresa		= new cformulario
		f_datos_empresa.Carga_Parametros "consulta.xml", "consulta"
		
'		sql_consulta_empresa= 	" Select a.*, c.ciud_tdesc as comuna, c.ciud_tcomuna as ciudad from empresas a, ciudades c "& vbCrLf &_
'							  	" Where cast(empr_ncorr as varchar)= '"&q_pers_ncorr&"' "& vbCrLf &_
'								" 	and a.ciud_ccod*=c.ciud_ccod "

		sql_consulta_empresa= 	" Select a.empr_ncorr, a.empr_tnombre, a.empr_trazon_social, a.empr_nrut, a.empr_xdv, a.empr_tdireccion, a.ciud_ccod, a.empr_tfono "& vbCrLf &_
							  	" , a.empr_tfax, a.empr_tgiro, a.empr_tejecutivo, a.empr_temail_ejecutivo, a.AUDI_TUSUARIO, a.AUDI_FMODIFICACION "& vbCrLf &_
							  	" , c.ciud_tdesc as comuna, c.ciud_tcomuna as ciudad "& vbCrLf &_
							  	" from empresas a "& vbCrLf &_
							  	" LEFT OUTER JOIN ciudades c "& vbCrLf &_
							  	" ON a.ciud_ccod = c.ciud_ccod "& vbCrLf &_
							  	" Where cast(empr_ncorr as varchar) = '"&q_pers_ncorr&"' "

'response.Write("<pre>"&sql_consulta_factura&"</pre>")
'response.End()


		f_datos_empresa.inicializar		conectar
		f_datos_empresa.consultar sql_consulta_empresa
		f_datos_empresa.siguienteF

		rut				=	f_datos_empresa.obtenerValor("empr_nrut")
		dv				=	f_datos_empresa.obtenerValor("empr_xdv")
		giro			=	f_datos_empresa.obtenerValor("empr_tgiro")
		razon_social	=	f_datos_empresa.obtenerValor("empr_trazon_social")
		direccion1		=	f_datos_empresa.obtenerValor("empr_tdireccion")
		ciud_ccod		=	f_datos_empresa.obtenerValor("ciud_ccod")
		telefono		=	f_datos_empresa.obtenerValor("empr_tfono")
		nro				=	f_datos_empresa.obtenerValor("dire_tnro")
		comuna			=	f_datos_empresa.obtenerValor("comuna")
		ciudad			=	f_datos_empresa.obtenerValor("ciudad")
'_____________________________________________________________________________

dia		=	conectar.consultauno("select day(getdate())")
mes		=	conectar.consultauno("select mes_tdesc from meses where mes_ccod=month(getdate())")
agno	=	conectar.consultauno("select year(getdate())")

'if v_correlativo="1" then
'	dia		=	conectar.consultauno("select day('31/12/2011') as dia from datos_generales_secciones_otec a where cast(a.dgso_ncorr as varchar)='"&v_dgso_ncorr&"'")
'	mes		=	conectar.consultauno("select mes_tdesc as mes from datos_generales_secciones_otec a, meses b where cast(a.dgso_ncorr as varchar)='"&v_dgso_ncorr&"' and month('31/12/2010')=b.mes_ccod")
'	agno	=	conectar.consultauno("select year('31/12/2011') as dia from datos_generales_secciones_otec a where cast(a.dgso_ncorr as varchar)='"&v_dgso_ncorr&"'")
'end if
'
'if v_correlativo="2" then
'	'dia		=	conectar.consultauno("select day(dgso_ftermino) as dia from datos_generales_secciones_otec a where cast(a.dgso_ncorr as varchar)='"&v_dgso_ncorr&"'")
'	dia		=	conectar.consultauno("select day('03/01/2012') as dia from datos_generales_secciones_otec a where cast(a.dgso_ncorr as varchar)='"&v_dgso_ncorr&"'")
'	'mes		=	conectar.consultauno("select mes_tdesc as mes from datos_generales_secciones_otec a, meses b where cast(a.dgso_ncorr as varchar)='"&v_dgso_ncorr&"' and month(a.dgso_ftermino)=b.mes_ccod")
'	mes		=	"ENERO"
'	agno	=	conectar.consultauno("select year(dgso_ftermino) as dia from datos_generales_secciones_otec a where cast(a.dgso_ncorr as varchar)='"&v_dgso_ncorr&"'")
'end if


if q_fact_ncorr>=877 and q_fact_ncorr<=885 then
	dia		=	"25"
	mes		=	"MAYO"
	agno	=	"2012"
end if

if q_fact_ncorr=1003 or q_fact_ncorr=1002 then
	dia		=	"31"
	mes		=	"MAYO"
	agno	=	"2012"
end if

if q_fact_ncorr=1130 or q_fact_ncorr=1128 then
	dia		=	"28"
	mes		=	"SEPTIEMBRE"
	agno	=	"2012"
end if

'if q_fact_nfactura="6134" then
'v_registro_sence="3788444"
'end if
'------------------------------------- FUNCION DE IMPRESION --------------------------------------
	  function Ac1(texto,ancho,alineado)
		largo =Len(Trim(texto))
		if isNull(largo) then
			largo=0
		end if
		if largo > ancho then largo=ancho
		if ucase(alineado) = "D" then 
		   Ac1=space(ancho-cint(largo))&Left(texto,largo)
		else
		   Ac1=Left(texto,largo)&space(ancho-largo)
		end if   
	  end function

'------------------------------------ FIN FUNCION DE IMPRESION -------------------------------------				
'	   archivo = archivo &space(80)&Ac1("",40,"I")
	   archivo = archivo & chr(13) & chr(10)
   	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10) 
	   archivo = archivo & chr(13) & chr(10) 
	   archivo = archivo & chr(13) & chr(10) 
	   archivo = archivo & chr(13) & chr(10) 
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(2)&Ac1(dia,2,"I")&space(7)&Ac1(mes,15,"I")& space(11)&Ac1(agno,4,"I")& chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(2)&Ac1(sin_acentos(razon_social),60,"I") &space(1) &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(2) & Ac1(sin_acentos(direccion1)&" "&nro,38,"I") & space(9) & Ac1(comuna,20,"I")& space(9) & Ac1(telefono,7,"I") &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(2) & Ac1(ciudad,41,"I")  & space(35)  & Ac1(rut&"-"&dv,11,"I")& chr(13) & chr(10)   
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(7) & Ac1(sin_acentos(giro),50,"I")& space(21)  & Ac1(sin_acentos(c_pago),10,"I")  &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)


'	consulta_i= " Select isnull(cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as docto, "& vbCrLf &_
'					" dd.tdet_ccod, dc.tcom_ccod as codigo, dc.COMP_NDOCTO nro_documento, "& vbCrLf &_
'					"    convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento, "& vbCrLf &_
'					" 'Curso' as concepto, --+(Select top 1 a1.tdet_tdesc from tipos_detalle a1 where a1.tdet_ccod=dd.tdet_ccod) as concepto, "& vbCrLf &_
'					" --cast(SUM(ab.ABON_MABONO) as numeric) total,cast(SUM(ab.ABON_MABONO) as numeric) abono, "& vbCrLf &_
'					" (select fact_mtotal from facturas where cast(fact_ncorr as varchar)='"&q_fact_ncorr&"') as total,(select fact_mtotal from facturas where cast(fact_ncorr as varchar)='"&q_fact_ncorr&"') as abono,"& vbCrLf &_
'					"    upper(ti.ting_tdesc) as ting_tdesc "& vbCrLf &_
'					"    from ingresos ii,abonos ab,compromisos cp,detalle_compromisos dc,tipos_compromisos tc, "& vbCrLf &_
'					"        detalles dd,tipos_detalle td,tipos_ingresos ti "& vbCrLf &_
'					"    where ii.ingr_ncorr = ab.ingr_ncorr "& vbCrLf &_
'					"        and ii.ingr_nfolio_referencia in (select folio_abono_factura from facturas where fact_nfactura="&q_fact_nfactura&" and tfac_ccod="&q_tfac_ccod&") "& vbCrLf &_
'					"        and ii.ting_ccod = '12' "& vbCrLf &_
'					"        and ab.tcom_ccod = dc.tcom_ccod "& vbCrLf &_
'					"        and ab.inst_ccod = dc.inst_ccod "& vbCrLf &_
'					"        and ab.comp_ndocto = dc.comp_ndocto  "& vbCrLf &_
'					"        and ab.dcom_ncompromiso = dc.dcom_ncompromiso "& vbCrLf &_
'					"        and dc.tcom_ccod = tc.tcom_ccod "& vbCrLf &_
'					"        and dc.tcom_ccod = dd.tcom_ccod "& vbCrLf &_
'					"        and dc.inst_ccod = dd.inst_ccod "& vbCrLf &_
'					"        and dc.comp_ndocto = dd.comp_ndocto "& vbCrLf &_
'					"        and dd.tdet_ccod = td.tdet_ccod "& vbCrLf &_
'					"        and dc.comp_ndocto=cp.comp_ndocto "& vbCrLf &_
'					"        and dc.tcom_ccod=cp.tcom_ccod "& vbCrLf &_
'					"		 and dc.comp_ndocto="&v_comp_ndocto&" "& vbCrLf &_
'					"        and case isnull(dd.tdet_ccod,0) when 0 then dc.tcom_ccod else td.tcom_ccod end = dc.tcom_ccod "& vbCrLf &_
'					"        and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') *= ti.ting_ccod "& vbCrLf &_
'					" GROUP BY dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO,dc.DCOM_FCOMPROMISO,tc.tcom_tdesc, ti.ting_tdesc,dc.tcom_ccod, dc.inst_ccod, dc.dcom_ncompromiso, td.tdet_tdesc "

	consulta_i= " Select isnull(cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as docto, "& vbCrLf &_
					" dd.tdet_ccod, dc.tcom_ccod as codigo, dc.COMP_NDOCTO nro_documento, "& vbCrLf &_
					"    convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento, "& vbCrLf &_
					" 'Curso' as concepto, --+(Select top 1 a1.tdet_tdesc from tipos_detalle a1 where a1.tdet_ccod=dd.tdet_ccod) as concepto, "& vbCrLf &_
					" --cast(SUM(ab.ABON_MABONO) as numeric) total,cast(SUM(ab.ABON_MABONO) as numeric) abono, "& vbCrLf &_
					" (select fact_mtotal from facturas where cast(fact_ncorr as varchar)='"&q_fact_ncorr&"') as total,(select fact_mtotal from facturas where cast(fact_ncorr as varchar)='"&q_fact_ncorr&"') as abono,"& vbCrLf &_
					"    upper(ti.ting_tdesc) as ting_tdesc "& vbCrLf &_
					"    from ingresos ii "& vbCrLf &_
					" INNER JOIN abonos ab "& vbCrLf &_
					" ON ii.ingr_ncorr = ab.ingr_ncorr "& vbCrLf &_
					" and ii.ingr_nfolio_referencia in (select folio_abono_factura from facturas where fact_nfactura="&q_fact_nfactura&" and tfac_ccod="&q_tfac_ccod&") and ii.ting_ccod = '12' "& vbCrLf &_
					" INNER JOIN detalle_compromisos dc "& vbCrLf &_ 
					" ON ab.tcom_ccod = dc.tcom_ccod and ab.inst_ccod = dc.inst_ccod and ab.comp_ndocto = dc.comp_ndocto and ab.dcom_ncompromiso = dc.dcom_ncompromiso and dc.comp_ndocto = "&v_comp_ndocto&" "& vbCrLf &_
					" INNER JOIN tipos_compromisos tc "& vbCrLf &_ 
					" ON dc.tcom_ccod = tc.tcom_ccod "& vbCrLf &_
					" INNER JOIN detalles dd "& vbCrLf &_
					" ON dc.tcom_ccod = dd.tcom_ccod and dc.inst_ccod = dd.inst_ccod and dc.comp_ndocto = dd.comp_ndocto "& vbCrLf &_
					" INNER JOIN tipos_detalle td "& vbCrLf &_
					" ON dd.tdet_ccod = td.tdet_ccod "& vbCrLf &_
					" INNER JOIN compromisos cp "& vbCrLf &_
					" ON dc.comp_ndocto = cp.comp_ndocto and dc.tcom_ccod = cp.tcom_ccod and case isnull(dd.tdet_ccod,0) when 0 then dc.tcom_ccod else td.tcom_ccod end = dc.tcom_ccod "& vbCrLf &_
					" LEFT OUTER JOIN tipos_ingresos ti "& vbCrLf &_
					" ON protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') = ti.ting_ccod  "& vbCrLf &_
					" GROUP BY dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO,dc.DCOM_FCOMPROMISO,tc.tcom_tdesc, ti.ting_tdesc,dc.tcom_ccod, dc.inst_ccod, dc.dcom_ncompromiso, td.tdet_tdesc "


'response.Write("<pre>"&consulta_i&"</pre>")
'response.Flush()

		set tabla_i		= new cformulario
		tabla_i.inicializar		conectar
		tabla_i.carga_parametros	"consulta.xml","consulta"
		tabla_i.consultar consulta_i

		if tabla_i.nroFilas > 0 then
			for k=0 to tabla_i.nroFilas-1
				tabla_i.siguiente

				docto		= 	tabla_i.obtenerValor("docto")
				concepto	= 	sin_acentos(tabla_i.obtenerValor("concepto"))
				cuota		= 	1
				abono		=	clng(tabla_i.obtenerValor("abono"))
				total		= 	total+clng(tabla_i.obtenerValor("total"))
				intereses	=	0
				multas		=	0
				m_anticipado=	0
				
				suma=0
				if m_anticipado > 0 and multas > 0 and intereses > 0 then
					suma=3
				elseif (m_anticipado > 0 and multas > 0 )or (intereses > 0 and multas > 0 ) or (m_anticipado > 0 and intereses > 0) then
					suma=2
					elseif m_anticipado > 0 or multas > 0 or intereses > 0 then
					suma = 1
				end if
				if abono > 999 then
					archivo = archivo & space(2)&Ac1(cuota,5,"I")&space(5)&Ac1(concepto,30,"I")&space(35)& Ac1(formatcurrency(abono,0,-1,0,-1),12,"D")& chr(13) &  chr(10)
				else
					archivo = archivo & space(2)&Ac1(cuota,5,"I")&space(5)&Ac1(concepto,30,"I")&space(35)& Ac1(formatcurrency(abono,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
				end if
			next
		end if
	
		if v_oc_asociada <>"" then
			archivo = archivo &chr(13)&chr(10)&space(10)&Ac1(v_oc_asociada,30,"I")&space(15)& chr(13) &  chr(10)
		end if

		if  q_fact_ncorr="1341" then
			v_registro_sence="4356454"
		end if
		
'		if v_registro_sence <>"" then
'			archivo = archivo &space(10)&Ac1("N° Registro: "&v_registro_sence,30,"I")&space(15)& chr(13) &  chr(10)
'		end if
	
		' obtiene los datos necesarios para sence.
		if f_datos_otec.nroFilas > 0 then
			archivo = archivo & space(10)&Ac1("Nombre: "&programa,60,"I")&space(5)& chr(13) &  chr(10)
			archivo = archivo & space(10)&Ac1("Duracion: "&duracion,50,"I")&space(5)& chr(13) &  chr(10)
			archivo = archivo & space(10)&Ac1("Cod Sence: "&cod_sence,35,"I")&space(5)& chr(13) &  chr(10)
			archivo = archivo & space(10)&Ac1("Registro Accion Sence: "&num_sence,35,"I")&space(5)& chr(13) &  chr(10)
			archivo = archivo & space(10)&Ac1("N° Horas: "&num_horas,35,"I")&space(5)& chr(13) &  chr(10)
			
			if q_fact_ncorr=1085 or q_fact_ncorr=1086 or q_fact_ncorr=1087  then
				archivo = archivo & space(10)&Ac1("Lugar ejecucion: Melipilla",35,"I")&space(5)& chr(13) &  chr(10)
			end if
			


		end if

	if v_fact_bdivide="N" then ' si es N, muestra el listado de Alumnos, si es S, significa que selecciono una sola factura, por lo tanto no se muestra el listado.
		v_nro_alumnos = f_listado_alumnos.nroFilas		
		if v_nro_alumnos > 0 then
			v_monto_alumno	= Clng(total/v_nro_alumnos)
			
				archivo = archivo &chr(13)&chr(10)&space(20)&Ac1("Listado de Alumnos",30,"I")&space(1)& chr(13) &  chr(10)
				archivo = archivo & space(10)&space(5)&Ac1("RUT",10,"I")&space(2)&Ac1("NOMBRE",30,"I")&space(1)& chr(13) &  chr(10)
			
			for k=0 to f_listado_alumnos.nroFilas-1
				f_listado_alumnos.siguiente
				rut		= 	f_listado_alumnos.obtenerValor("rut")
				nombre	= 	f_listado_alumnos.obtenerValor("nombre")
				if(k-f_listado_alumnos.nroFilas=-1) and k>10 then
					v_monto_alumno=total-(v_monto_alumno*k)
				end if
				
					archivo = archivo & space(5)&space(5)&Ac1(rut,10,"I")&space(2)&Ac1(nombre,35,"I")&space(23)&chr(13)&chr(10)
				
				filas	=	filas+1
			next
			
		end if
	else
		filas=-3
	end if		
		
'		if m_anticipado > 0 then
'			archivo=archivo &space(0)& Ac1("PAGO ANTICIPADO",20,"I")&space(15)&Ac1(formatcurrency(m_anticipado,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
'		end if
'	
'		if intereses >0 then
'			archivo=archivo &space(0)& Ac1("INTERESES",20,"I")&space(15)&Ac1(formatcurrency(intereses,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
'		else
'			archivo=archivo& chr(13) &  chr(10)
'		end if
'		if multas > 0 then
'			archivo=archivo &space(0)& Ac1("MULTAS",20,"I")&space(15)&Ac1(formatcurrency(multas,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
'		else
'			archivo=archivo& chr(13) &  chr(10)
'		end if


		FOR i=1 to 17 - filas
			archivo =  archivo & chr(13) &  chr(10)
		next

	
   
	   archivo = archivo &space(10)& Ac1(Traduce_numero(total,10),79,"I") 
	   '********   NRO A PALABRAS ************************
	   
	   	for kk=1 to 3
			archivo =  archivo & chr(13) &  chr(10)
		next
		
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	  ' archivo = archivo & chr(13) & chr(10)
	  ' archivo = archivo & chr(13) & chr(10)
	   	
   	if q_tfac_ccod="1" then
	   archivo = archivo &space(20)&space(58) & Ac1(formatcurrency(v_monto_neto,0,-1,0,-1),11,"D") & chr(13) & chr(10)
   	   archivo = archivo &chr(13) & chr(10)
	   archivo = archivo &space(20)&space(58) & Ac1(formatcurrency(v_monto_iva,0,-1,0,-1),11,"D") & chr(13) & chr(10)
   	   archivo = archivo &chr(13) & chr(10)
   	   archivo = archivo &space(20)&space(58) & Ac1(formatcurrency(total,0,-1,0,-1),11,"D") & chr(13) & chr(10)
   	else
	   archivo = archivo &space(20)&space(58) & Ac1(formatcurrency(total,0,-1,0,-1),11,"D") & chr(13) & chr(10)
	end if	   
	   '********   TOTALIZAR ************************
	   archivo = archivo & chr(13) & chr(10)
	'   archivo = archivo & chr(13) 

response.Write("<pre>" & archivo & "</pre>")
response.Flush()	

'--------------------------------------------------------------------------------------				
end if
%>

<script language="javascript1.1">
window.print();
</script>
<script language="javascript1.1">

function cerrar_pagina(){
mensaje="¿Se ha impreso correctamente la Factura?";
var estado='<%=v_estado%>';
	if ((estado!='2') && (estado!='3')){
		if (confirm(mensaje)){
			//window.opener.location.href="./proc_cierra_factura.asp?cod_factura=<%=q_fact_ncorr%>&origen=<%=q_origen%>";
			window.opener.location.href="./proc_cierra_factura.asp?cod_factura=<%=q_fact_ncorr%>";
		}else{
			//url_ventana="../ver_facturas.asp?busqueda[0][fact_nfactura]=<%=q_fact_nfactura%>&busqueda[0][tfac_ccod]=<%=q_tfac_ccod%>";
			//window.open(url_ventana,"ventana_maneja","");
			window.opener.close();
		}
	}
}
</script>
</body>
</html>

