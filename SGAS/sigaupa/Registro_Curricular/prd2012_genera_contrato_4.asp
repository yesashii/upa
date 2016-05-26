<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set pagina = new CPagina


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'------------------------------------------------------------------------------------------------
post_ncorr = Request.QueryString("post_ncorr")
nro_t = Request.QueryString("nro_t")
if nro_t="" then
    nro_t=1
end if	
 	select case nro_t
		case 1
		 	 visible1 ="style=""VISIBILITY: visible"""
		case 2
			 visible2 ="style=""VISIBILITY: visible"""
		case 3
			 visible3 ="style=""VISIBILITY: visible"""	 
		case 4
			 visible4 ="style=""VISIBILITY: visible"""
		case 5
			 visible5 ="style=""VISIBILITY: visible"""	
		case 6
			 visible6 ="style=""VISIBILITY: visible"""	 			  
		end select
sede = negocio.ObtenerSede
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "genera_contrato_4.xml", "btn_genera_contrato_4"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "entrega_recursos.xml", "botonera"


'--------------------------------DATOS IMPRESORA -----------------------------------------------
set f_impresora = new CFormulario
f_impresora.Carga_Parametros "genera_contrato_4.xml", "f_impresora"
f_impresora.Inicializar conexion

cc_impresora ="select impr_truta from impresoras where sede_ccod='" & sede & "'"

f_impresora.Consultar cc_impresora

'-----------------------------------DATOS CONTRATO---------------------------------------------
		set f_detalle_contrato = new CFormulario
		f_detalle_contrato.Carga_Parametros "genera_contrato_4.xml", "f_detalle_contrato"
		f_detalle_contrato.Inicializar conexion


		
		 consulta_con = "select isnull(cc.contrato,cc.cont_ncorr) nro_contrato, " & vbcrlf &_
		"		convert(varchar,cc.CONT_FCONTRATO, 103) f_contrato, "& vbcrlf &_
		"		ec.ECON_TDESC estado "& vbcrlf &_
		" from contratos cc, estados_contrato ec "& vbcrlf &_
		" where cc.post_ncorr= "& post_ncorr & " and  "& vbcrlf &_
		"		cc.econ_ccod=ec.econ_ccod and "& vbcrlf &_
		"		cc.econ_ccod<>3   "
		
		f_detalle_contrato.Consultar consulta_con
		f_detalle_contrato.siguiente
'-----------------------------------DATOS PAGARE---------------------------------------------
		set f_detalle_pagare = new CFormulario
		f_detalle_pagare.Carga_Parametros "genera_contrato_4.xml", "f_detalle_pagare"
		f_detalle_pagare.Inicializar conexion

	consulta_p=" select pag.PAGA_NCORR, com.comp_mdocumento as monto_actual, " & vbcrlf &_
			" com.comp_ncuotas as num_cuotas,com.comp_mdocumento as suma " & vbcrlf &_
			" from contratos cc, pagares pag, compromisos com " & vbcrlf &_
			" where cc.cont_ncorr = pag.cont_ncorr " & vbcrlf &_
			" and cc.cont_ncorr=com.comp_ndocto " & vbcrlf &_
			" and com.tcom_ccod=2 " & vbcrlf &_
			" and cc.POST_NCORR='"&post_ncorr&"' " & vbcrlf &_
			" and isnull(pag.opag_ccod,1) not in (2) " & vbcrlf &_
			" and cc.econ_ccod<>3 " & vbcrlf &_
			" and com.ecom_ccod <>3 " & vbcrlf 
	
'response.Write("<pre>"&consulta_p&"</pre>")	
		f_detalle_pagare.Consultar consulta_p
        f_detalle_pagare.siguiente

'-----------------------------------DATOS MULTIDEBITO---------------------------------------------
		set f_detalle_multidebito = new CFormulario
		f_detalle_multidebito.Carga_Parametros "genera_contrato_4.xml", "f_detalle_multidebito"
		f_detalle_multidebito.Inicializar conexion

		consulta_m=" select pag.PMUL_NCORR, com.comp_mdocumento as monto_actual, " & vbcrlf &_
					" com.comp_ncuotas as num_cuotas,com.comp_mdocumento as suma " & vbcrlf &_
					" from contratos cc, pagare_multidebito pag, compromisos com " & vbcrlf &_
					" where cc.cont_ncorr = pag.cont_ncorr " & vbcrlf &_
					" and cc.cont_ncorr=com.comp_ndocto " & vbcrlf &_
					" and com.tcom_ccod=2 " & vbcrlf &_
					" and cc.POST_NCORR='"&post_ncorr&"' " & vbcrlf &_
					" and isnull(pag.opag_ccod,1) not in (2) " & vbcrlf &_
					" and cc.econ_ccod<>3 " & vbcrlf &_
					" and com.ecom_ccod <>3 " & vbcrlf 
	
'response.Write("<pre>"&consulta_p&"</pre>")	
		f_detalle_multidebito.Consultar consulta_m
        f_detalle_multidebito.siguiente

'response.End()	
'-----------------------------------DATOS MULTIDEBITO---------------------------------------------
		set f_detalle_pagare_upa = new CFormulario
		f_detalle_pagare_upa.Carga_Parametros "genera_contrato_4.xml", "f_detalle_pagare_upa"
		f_detalle_pagare_upa.Inicializar conexion

		consulta_u=" select pag.pupa_ncorr, com.comp_mdocumento as monto_actual, " & vbcrlf &_
					" com.comp_ncuotas as num_cuotas,com.comp_mdocumento as suma " & vbcrlf &_
					" from contratos cc, pagare_upa pag, compromisos com " & vbcrlf &_
					" where cc.cont_ncorr = pag.cont_ncorr " & vbcrlf &_
					" and cc.cont_ncorr=com.comp_ndocto " & vbcrlf &_
					" and com.tcom_ccod=2 " & vbcrlf &_
					" and cc.POST_NCORR='"&post_ncorr&"' " & vbcrlf &_
					" and isnull(pag.opag_ccod,1) not in (2) " & vbcrlf &_
					" and cc.econ_ccod<>3 " & vbcrlf &_
					" and com.ecom_ccod <>3 " & vbcrlf 
	
'response.Write("<pre>"&consulta_p&"</pre>")	
		f_detalle_pagare_upa.Consultar consulta_u
        f_detalle_pagare_upa.siguiente

'-----------------------------------DATOS POSTULANTE--------------------------------------------
		
		set f_detalle_post = new CFormulario
		f_detalle_post.Carga_Parametros "genera_contrato_4.xml", "f_detalle_post"
		f_detalle_post.Inicializar conexion
		
		 consulta = "select  pp.pers_tnombre +' '+ pp.pers_tape_paterno + ' ' + pp.pers_tape_materno  as nombre_post, "& vbcrlf &_
	  " cast(pp.PERS_NRUT as varchar) +'-'+pp.PERS_XDV as rut_post, "& vbcrlf &_
	  " convert(varchar,getdate(),103 ) as fecha_hoy, "& vbcrlf &_
	  " cc.carr_tdesc as carrera "& vbcrlf &_
		"from postulantes p,personas_postulante pp,ofertas_academicas oa, "& vbcrlf &_
		"	 especialidades ee, carreras cc  "& vbcrlf &_
		"where p.pers_ncorr=pp.pers_ncorr and "& vbcrlf &_
		"	  p.post_ncorr= " & post_ncorr &" and "& vbcrlf &_
		"	  p.ofer_ncorr=oa.ofer_ncorr and "& vbcrlf &_
		"	  oa.espe_ccod=ee.espe_ccod and "& vbcrlf &_
		"	  ee.carr_ccod=cc.carr_ccod "
		
		f_detalle_post.Consultar consulta
		'response.Write(consulta)
		f_detalle_post.siguiente
		
'-----------------DETALLES CHEQUES------------------------------------
		set f_detalle_cheque_2 = new CFormulario
		f_detalle_cheque_2.Carga_Parametros "genera_contrato_4.xml", "f_detalle_cheque_2"
		f_detalle_cheque_2.Inicializar conexion


		
	
		consulta_c = " select  p.post_ncorr, dii.TING_CCOD, dii.ding_ndocto ,  " & vbcrlf & _
					"       dii.ingr_ncorr , dii.ding_ndocto nro_doc,  " & vbcrlf & _
					"        dii.ding_tcuenta_corriente, tii.ting_tdesc tipo_doc,  " & vbcrlf & _
					"        bn.BANC_TDESC banco, pl.plaz_tdesc plaza,  " & vbcrlf & _
					"        convert(varchar,cps.COMP_FDOCTO,103) f_emision, convert(varchar,dii.DING_FDOCTO,103) f_vencimiento,  " & vbcrlf & _
					"        dii.DING_MDETALLE monto  " & vbcrlf & _
					" from postulantes p, contratos cc, " & vbcrlf & _
					" compromisos cps, detalle_compromisos dc, " & vbcrlf & _
					" abonos bb,ingresos ii,detalle_ingresos dii, " & vbcrlf & _
					" tipos_ingresos tii,bancos bn,tipos_compromisos tcps, " & vbcrlf & _
					" plazas pl " & vbcrlf & _
					" where p.post_ncorr = cc.post_ncorr " & vbcrlf & _
					" and cc.cont_ncorr = cps.comp_ndocto " & vbcrlf & _
					" and cps.comp_ndocto = dc.comp_ndocto " & vbcrlf & _
					" and cps.tcom_ccod = dc.tcom_ccod " & vbcrlf & _
					" and cps.inst_ccod = dc.inst_ccod " & vbcrlf & _
					" and dc.comp_ndocto = bb.comp_ndocto " & vbcrlf & _
					" and dc.tcom_ccod = bb.tcom_ccod " & vbcrlf & _
					" and dc.dcom_ncompromiso= bb.dcom_ncompromiso " & vbcrlf & _
					" and bb.ingr_ncorr = ii.ingr_ncorr " & vbcrlf & _
					" and ii.ingr_ncorr =dii.ingr_ncorr " & vbcrlf & _
					" and ii.ting_ccod = tii.ting_ccod " & vbcrlf & _
					" and dii.banc_ccod *= bn.banc_ccod " & vbcrlf & _
					" and cps.tcom_ccod = tcps.tcom_ccod " & vbcrlf & _
					" and dii.plaz_ccod *= pl.plaz_ccod " & vbcrlf & _
					" and p.post_ncorr=" & post_ncorr &" " & vbcrlf & _
					" and cc.econ_ccod <> 3  " & vbcrlf & _
					" and cps.ecom_ccod <> 3  " & vbcrlf & _
					" and ii.eing_ccod <> 3 " & vbcrlf & _
					" and dii.ting_ccod =3 " & vbcrlf & _
					" and ii.ting_ccod =7 " 
		
		
		'response.Write(consulta_c)
		f_detalle_cheque_2.Consultar consulta_c
		'f_detalle_cheque_2.agregaParam "eliminar", "true"
'-----------------DETALLES LETRAS------------------------------------
		set f_detalle_letra = new CFormulario
		f_detalle_letra.Carga_Parametros "genera_contrato_4.xml", "f_detalle_letra"
		f_detalle_letra.Inicializar conexion

	consulta_t =" select  p.post_ncorr, dii.TING_CCOD, dii.ding_ndocto ,  " & vbcrlf & _
				"       dii.ingr_ncorr , dii.ding_ndocto nro_doc,  " & vbcrlf & _
				"        dii.ding_tcuenta_corriente, tii.ting_tdesc tipo_doc,  " & vbcrlf & _
				"        convert(varchar,cps.COMP_FDOCTO,103) f_emision, convert(varchar,dii.DING_FDOCTO,103) f_vencimiento,  " & vbcrlf & _
				"        dii.DING_MDETALLE monto  " & vbcrlf & _
				" from postulantes p, contratos cc, " & vbcrlf & _
				" compromisos cps, detalle_compromisos dc, " & vbcrlf & _
				" abonos bb,ingresos ii,detalle_ingresos dii, " & vbcrlf & _
				" tipos_ingresos tii,tipos_compromisos tcps " & vbcrlf & _
				" where p.post_ncorr = cc.post_ncorr " & vbcrlf & _
				" and cc.cont_ncorr = cps.comp_ndocto " & vbcrlf & _
				" and cps.comp_ndocto = dc.comp_ndocto " & vbcrlf & _
				" and cps.tcom_ccod = dc.tcom_ccod " & vbcrlf & _
				" and cps.inst_ccod = dc.inst_ccod " & vbcrlf & _
				" and dc.comp_ndocto = bb.comp_ndocto " & vbcrlf & _
				" and dc.tcom_ccod = bb.tcom_ccod " & vbcrlf & _
				" and dc.dcom_ncompromiso= bb.dcom_ncompromiso " & vbcrlf & _
				" and bb.ingr_ncorr = ii.ingr_ncorr " & vbcrlf & _
				" and ii.ingr_ncorr =dii.ingr_ncorr " & vbcrlf & _
				" and ii.ting_ccod = tii.ting_ccod " & vbcrlf & _
				" and cps.tcom_ccod = tcps.tcom_ccod " & vbcrlf & _
				" and p.post_ncorr=" & post_ncorr &" " & vbcrlf & _
				" and cc.econ_ccod <> 3  " & vbcrlf & _
				" and cps.ecom_ccod <> 3  " & vbcrlf & _
				" and ii.eing_ccod <> 3 " & vbcrlf & _
				" and ii.ting_ccod =7 " & vbcrlf & _
				" and cps.tcom_ccod in(1,2)  " & vbcrlf & _
				" and dii.ting_ccod =4 " & vbcrlf & _
				" and ii.ting_ccod =7 " 
		
		'response.Write(consulta_t)
		f_detalle_letra.Consultar consulta_t
	
'-------------------------------------------------------
		set f_detalle_tarjetas= new CFormulario
		f_detalle_tarjetas.Carga_Parametros "genera_contrato_4.xml", "f_detalle_tarjetas"
		f_detalle_tarjetas.Inicializar conexion

		consulta_tarjetas = " select  p.post_ncorr, dii.TING_CCOD, dii.ding_ndocto ,  " & vbcrlf & _
					" 		 substring((select ting_tdesc from tipos_ingresos where ting_ccod=dii.ting_ccod),12,7) as tipo_tarjeta, "& vbcrlf & _
					"        dii.ingr_ncorr , case isnull(dii.ding_ndocto,0) when 0 then dii.ding_tcuenta_corriente else dii.ding_ndocto end nro_doc,  " & vbcrlf & _
					"        dii.ding_tcuenta_corriente, tii.ting_tdesc tipo_doc,  " & vbcrlf & _
					"        bn.BANC_TDESC banco, pl.plaz_tdesc plaza,  " & vbcrlf & _
					"        convert(varchar,cps.COMP_FDOCTO,103) f_emision, convert(varchar,dii.DING_FDOCTO,103) f_vencimiento,  " & vbcrlf & _
					"        dii.DING_MDETALLE monto  " & vbcrlf & _
					" from postulantes p, contratos cc, " & vbcrlf & _
					" compromisos cps, detalle_compromisos dc, " & vbcrlf & _
					" abonos bb,ingresos ii,detalle_ingresos dii, " & vbcrlf & _
					" tipos_ingresos tii,bancos bn,tipos_compromisos tcps, " & vbcrlf & _
					" plazas pl " & vbcrlf & _
					" where p.post_ncorr = cc.post_ncorr " & vbcrlf & _
					" and cc.cont_ncorr = cps.comp_ndocto " & vbcrlf & _
					" and cps.comp_ndocto = dc.comp_ndocto " & vbcrlf & _
					" and cps.tcom_ccod = dc.tcom_ccod " & vbcrlf & _
					" and cps.inst_ccod = dc.inst_ccod " & vbcrlf & _
					" and dc.comp_ndocto = bb.comp_ndocto " & vbcrlf & _
					" and dc.tcom_ccod = bb.tcom_ccod " & vbcrlf & _
					" and dc.dcom_ncompromiso= bb.dcom_ncompromiso " & vbcrlf & _
					" and bb.ingr_ncorr = ii.ingr_ncorr " & vbcrlf & _
					" and ii.ingr_ncorr =dii.ingr_ncorr " & vbcrlf & _
					" and ii.ting_ccod = tii.ting_ccod " & vbcrlf & _
					" and dii.banc_ccod *= bn.banc_ccod " & vbcrlf & _
					" and cps.tcom_ccod = tcps.tcom_ccod " & vbcrlf & _
					" and dii.plaz_ccod *= pl.plaz_ccod " & vbcrlf & _
					" and p.post_ncorr=" & post_ncorr &" " & vbcrlf & _
					" and cc.econ_ccod <> 3  " & vbcrlf & _
					" and cps.ecom_ccod <> 3  " & vbcrlf & _
					" and ii.eing_ccod <> 3 " & vbcrlf & _
					" and dii.ting_ccod in (13,51) "  & vbcrlf & _
					" and ii.ting_ccod =7 "
'response.Write("<pre>"&consulta_tarjetas&"</pre>")
f_detalle_tarjetas.Consultar consulta_tarjetas
'-------------------------------------------------------
set postulante = new CPostulante
postulante.Inicializar conexion, post_ncorr		

sql_nuevo="select post_bnuevo from postulantes where post_ncorr="&post_ncorr
v_es_nuevo=conexion.consultauno(sql_nuevo)

sql_pers_ncorr	=	"select pers_ncorr from postulantes where post_ncorr="&post_ncorr
v_pers_ncorr		=	conexion.consultauno(sql_pers_ncorr)

'**************************************************************************
'*************		datos para colegio contadores			***************
sql_carrera="select c.carr_ccod as carrera from ofertas_academicas a, especialidades b, carreras c"& vbcrlf & _
					"where a.ofer_ncorr in (select ofer_ncorr from postulantes where post_ncorr="&post_ncorr&")"& vbcrlf & _
					"and a.espe_ccod=b.espe_ccod"& vbcrlf & _
					"and b.carr_ccod=c.carr_ccod "

sql_espe_cole="select a.espe_ccod as espe_cole from ofertas_academicas a, especialidades b, carreras c"& vbcrlf & _
					"where a.ofer_ncorr in (select ofer_ncorr from postulantes where post_ncorr="&post_ncorr&")"& vbcrlf & _
					"and a.espe_ccod=b.espe_ccod"& vbcrlf & _
					"and b.carr_ccod=c.carr_ccod "
'response.Write("<pre>"&sql_carrera&"</pre>")			

sql_postgrado="select count(c.carr_ccod) as carrera from ofertas_academicas a, especialidades b, carreras c "& vbcrlf & _
					" where a.ofer_ncorr in (select ofer_ncorr from postulantes where post_ncorr="&post_ncorr&") "& vbcrlf & _
					" and a.espe_ccod=b.espe_ccod "& vbcrlf & _
					" and b.carr_ccod=c.carr_ccod "& vbcrlf & _
					" and c.carr_tdesc like '%magister%' "& vbcrlf & _
					" and c.tcar_ccod=2 "

v_es_postgrado=conexion.consultauno(sql_postgrado)
v_es_carrera=conexion.consultauno(sql_carrera)
v_espe_cole=conexion.consultauno(sql_espe_cole)
'**************************************************************************


sql_ingreso_carrera="select protic.ANO_INGRESO_CARRERA("&v_pers_ncorr&","&v_es_carrera&")"
v_ano_ingreso		=	conexion.consultauno(sql_ingreso_carrera)

'response.Write("<pre><hr>"&v_ano_ingreso&"<hr></pre>")

sql_tipo_carr="select c.tcar_ccod as tipo_carrera from ofertas_academicas a, especialidades b, carreras c"& vbcrlf & _
					"where a.ofer_ncorr in (select ofer_ncorr from postulantes where post_ncorr="&post_ncorr&")"& vbcrlf & _
					"and a.espe_ccod=b.espe_ccod"& vbcrlf & _
					"and b.carr_ccod=c.carr_ccod "

tipo_carrera=conexion.consultauno(sql_tipo_carr)

sql_sede_carr="select top 1 a.sede_ccod as sede_carrera from ofertas_academicas a "& vbcrlf & _
					"where a.ofer_ncorr in (select ofer_ncorr from postulantes where post_ncorr="&post_ncorr&") "

sede_carrera=conexion.consultauno(sql_sede_carr)


'------------------------
' Segun Año Ingreso, del 2005 (INCLUYENDOLO) hacia adelante se aplica el nuevo formato de contrato
'-------------------------------------------------------------------------------------
'response.Write("ano ingreso: "&v_ano_ingreso)	
'response.Write("Carrera : "&v_es_carrera)	
'response.Write("Especialidad : "&v_espe_cole)	
	if v_ano_ingreso < "2005" then
		if v_es_carrera=890  or v_es_carrera=900 or v_es_carrera=910 then	
			v_es_nuevo="CN"
		else
			v_es_nuevo="N"
		end if	
	else		
		if v_es_carrera=890  or v_es_carrera=900 or v_es_carrera=910 then	
			v_es_nuevo="CN"
		elseif v_es_carrera=110 and sede_carrera="9" then
			v_es_nuevo="LA"
		elseif v_es_carrera=110 and sede_carrera="7" then
			v_es_nuevo="LAC"			
		else
			v_es_nuevo="S"
		end if	
		
	end if

v_retroactivo=conexion.consultaUno("select case when convert(datetime,getdate(),103)<= convert(datetime,'09/08/2010',103) then 1 else 0 end")


if	not EsVacio(tipo_carrera)	then
	if	tipo_carrera = "2" and v_es_postgrado >0 then' para postgrado todos los postulantes se tomaran como ANTIGUOS
		if v_ano_ingreso < "2009" then
			v_es_nuevo="P"
		else
			if v_retroactivo="1" then
				v_es_nuevo="PM"
			else
				v_es_nuevo="PV2"
			end if
		end if
	end if
end if


'por_anio=2 ' solo para no comentarlo todo (obtiene formato contrato segun año ingreso)
'if por_anio=1 then
'	if v_es_nuevo="N" then
'	'	carrera=12 Contador Auditor
'		if v_es_carrera=12 then	
'			v_es_nuevo="CA"
'		else
'			v_es_nuevo="N"
'		end if	
'	else
'		v_es_nuevo="S"
'		'--------------------------------------------------------------------
'		' especifico para un rut que se va a corregir mañana ( osea el 26/05/2005)
'		 if post_ncorr=65243 or post_ncorr=51910 or post_ncorr=51893 then
'			'v_es_nuevo="CN"   ' contrato alumno nuevo, colegio contadores
'			v_es_nuevo="CA"   ' contrato alumno antiguo, colegio contadores
'		 end if
'		'--------------------------------------------------------------------

'	end if
'else ' fin para no comentar
	' lo que figura mas arriba
'end if

'	BUSCA SI EXISTE ALGUN DESCUENTO CAE PARA HABILITAR EL BOTON DEL ANEXO CAE *****
sql_cae= " select count(*) as cantidad "& vbcrlf & _
				"	from sdescuentos a, stipos_descuentos b, postulantes c "& vbcrlf & _    
				"			where a.stde_ccod = b.stde_ccod "& vbcrlf & _    
				"			  and a.post_ncorr = c.post_ncorr "& vbcrlf & _    
				"			  and a.ofer_ncorr = c.ofer_ncorr "& vbcrlf & _    
				"			  and c.post_ncorr = '"&post_ncorr&"'  "& vbcrlf & _
				"			  and a.stde_ccod in (1402,1645) "

v_existe_cae= conexion.consultaUno(sql_cae)

sql_monto_cae=  " select count(*) " & vbcrlf & _
				"	from solicitud_credito_cae where post_ncorr="&post_ncorr&" and ofer_ncorr in (select ofer_ncorr from postulantes where post_ncorr="&post_ncorr&") "

v_valor_cae	=	conexion.consultaUno(sql_monto_cae)  


if Clng(v_valor_cae)>0 then
	v_existe_cae=1
end if

'	BUSCA SI EXISTE ALGUN DESCUENTO INTERNO PARA HABILITAR EL BOTON DEL ANEXO *****
sql_anexo_descuento= "select count(*) anexo_interno "& vbcrlf & _
						" from sdescuentos a, tipos_detalle b  "& vbcrlf & _
						" where post_ncorr in ('"&post_ncorr&"') "& vbcrlf & _
						" and stde_ccod in (2354,905,924,1276,1271,1272,1273,1278,1505,1537,1725,1726,1727,1944,1945,2187,2205,2208,2210,2220,2316) "& vbcrlf & _
						" and a.stde_ccod=b.tdet_ccod "& vbcrlf & _
						" and esde_ccod=1"

v_anexo_interno= conexion.consultaUno(sql_anexo_descuento)
	
if Clng(v_anexo_interno)>0 then
	v_existe_anexo=1
end if



%>


<html>
<head>
<title>Imprimir Documentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function Anterior4()
{
  location.replace("Forma_Pago3.asp");
}



function Deshabilita(loc){

   /*tabla = new CTabla("envios");
   
   for (var i = 0; i < tabla.filas.length; i++) {
   		alert(tabla.ObtenerValor(i, "imprimir_d"));
   }*/
   
   //return false;

 nro_elemento="";

 

for (var i=0;i<document.edicion_c.elements.length;i ++) {

	if (document.edicion_c.elements[i].type == 'checkbox') {
           
		    if(document.edicion_c.elements[i]!=loc)
			{			         
					 document.edicion_c.elements[i].checked=false;
					 //alert(document.edicion_c.elements[i].checked);
					 //cambiaOculto(document.edicion_c.elements[i], '1', '0');
					 //document.edicion_c.elements[i].value=0;
					   //alert (document.edicion_c.elements);
			           //checktest(i);
			}			
			
			cambiaOculto(document.edicion_c.elements[i], '1', '0');
			
   		}
   
   }

}
function validar_cheque(){


 nro_elemento=0;

 

for (var i=0;i<document.edicion_c.elements.length;i ++) {

	if (document.edicion_c.elements[i].checked==true) {
          nro_elemento++;
			
   		}
   
   }

if (nro_elemento==0) {
   alert( "debe seleccionar uno");
}


}
function Abrir()
{
 resultado = window.open("ver_cheque.asp","","toolbar=no, resizable=no,left=200,top=150,width=415,height=175");
  
}
</script>
<script language="JavaScript">
function abrir()
 { 
  location.reload("Envios_Banco_Agregar1.asp") 
 }
</script>
<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>
<script>

var currentSlide = 1;
//var numSlides = 12; // change to your total number of pics
var numSlides_tabla = 5; // change to your total number of pics
//var captions = new Array(10); //change to total number of pics
var IE4 = (document.all && !document.getElementById) ? true : false; //identifies IE 4
var NS4 = (document.layers) ? true : false; //identifies Navigator 4
var N6 = (document.getElementById && !document.all) ? true : false; //identifies Navigator 6 and IE 5 and up


function switchSlides_tabla(nro_tabla)
{
     // newSlide= "image_mapa"+newSlide;
       //alert (nro_mapa);
	   if (nro_tabla==""){
	       nro_tabla == 1;}
		   
       newSlide= "image_tabla"+nro_tabla;
       //alert ( newSlide)
    if (NS4 == true) {
            for (var i=1; i< numSlides_tabla; i++){
                var oldSlide="image_tabla"+i;
              
                if (newSlide == oldSlide)
		       document.layers[newSlide].visibility="show";
                else 
		       document.layers[oldSlide].visibility="hide";
              
            }
	
	}
	else if (IE4 == true) {
            for (var i=1; i< numSlides_tabla; i++){
                var oldSlide="image_tabla"+i;
               
                if (newSlide == oldSlide)
		       document.all[newSlide].style.visibility="visible";
                else 
	             document.all[oldSlide].style.visibility="hidden";
                
            }
        }
	else {
                for (var i=1; i< numSlides_tabla; i++){
                 var oldSlide="image_tabla"+i;
               
                  if (newSlide == oldSlide)
		     document.getElementById(newSlide).style.visibility="visible";
                  else 
	             document.getElementById(oldSlide).style.visibility="hidden";
                  
                }
	
             }
}




function imprimir() {
  var rut;
  var direccion;
  post_ncorr=<%=post_ncorr%>
  direccion="impr_recursos.asp?post_ncorr="+post_ncorr;
  window.open(direccion ,"ventana1","width=520,height=540,scrollbars=yes, left=313, top=200");
  //alert("Enviando a imprimir");
}

</script>
</head>
<body onBlur="revisaVentana()" bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>
  <tr>
    <td valign="top" bgcolor="#EAEAEA"> <br>
      <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="0"> <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr> 
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td> 
                  <%pagina.dibujarLenguetas array (array("Formas de Pago","genera_contrato_2.asp?post_ncorr="& post_ncorr),array("Generar Contrato","genera_contrato_3.asp?post_ncorr="& post_ncorr),array("Imprimir","genera_contrato_4.asp?post_ncorr="& post_ncorr)),3 %>
                </td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" height="100" align="left" background="../imagenes/izq.gif"></td>
                  
                <td align="center" valign="top" bgcolor="#D8D8DE"><BR>
                  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"><%postulante.DibujaDatos%></div></td>
                    </tr>
                  </table>
                  <BR>                  
                    <table width="632" border="0" align="center">
                      <tr>
                        <td colspan="3"><%pagina.DibujarSubtitulo("Imprimir Documentos")%>
                        </td>
                      </tr>
                      <tr>
                        <td width="94"><font size="2">Impresora</font></td>
                        <td width="19">:</td>
                        <td width="505"><select name="select">
                          <option>\\servidor\Impresora_1</option>
                          <option>\\servidor\Impresora_2</option>
                          <option>Impresora Local</option>
                        </select>
                      </td>
                      </tr>
                    </table>
                    
                  <br>
                  <table width="632"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                    <tr> 
                      <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                      <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                      <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                    </tr>
                    <tr> 
                      <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                      <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td> 
                              <%pagina.DibujarLenguetasFClaro Array(array("Contratos","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=1"), array("Pagaré","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=2"), array("Cheque","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=3"), array("Letra","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=4"),array("Tarjetas","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=5"),array("Multidebito","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=6"),array("Pagare Upa","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=7")), nro_t %>
                            </td>
                          </tr>
                          <tr> 
                            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                          </tr>
                          <tr> 
                            <td> <%if (nro_t=1) then %>
                              <table width="273" border="0">
                                <tr> 
                                  <td width="46%"><font size="2">Contrato</font></td>
                                  <td width="6%"><font size="2">:</font></td>
                                  <td width="29%"><font size="1"> 
                                    <% f_detalle_contrato.DibujaCampo("nro_contrato") %>
                                    </font></td>
                                  <td width="19%" rowspan="3"><%
								  if v_existe_cae>=1 then
								  	botonera.agregabotonparam "imprimir_anexo_cae", "url", "imprimir_anexo_cae.asp?post_ncorr="&post_ncorr  
									botonera.dibujaboton "imprimir_anexo_cae" 
								  end if
								  %></td>
                                </tr>
                                <tr> 
                                  <td><font size="2">Fecha</font></td>
                                  <td><font size="2">:</font></td>
                                  <td><font size="1"> 
                                    <% f_detalle_contrato.DibujaCampo("f_contrato") %>
                                    </font></td>
                                </tr>
                                <tr> 
                                  <td><font size="2">Estado</font></td>
                                  <td><font size="2">:</font></td>
                                  <td><font size="1"> 
                                      <% f_detalle_contrato.DibujaCampo("estado") %>
                                      </font></td>
                                </tr>
                              </table>
                              <%end if %> <%if (nro_t=2) then %>
						
						<table width="273" border="0">
                                          <tr>
                            <td width="46%"><font size="2">Pagar&eacute;</font></td>
                            <td width="6%"><font size="2">:</font></td>
                                    <td width="29%"><font size="1">
                                      <% f_detalle_pagare.DibujaCampo("PAGA_NCORR") %>
                                      </font></td>
                            <td width="19%">&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Cantidad Cuotas</font></td>
                                  <td><font size="2">:</font></td>
                            <td><font size="1">
										<%v_num_cuotas=f_detalle_pagare.ObtenerValor("num_cuotas")
										if  isnull(v_num_cuotas) or v_num_cuotas="" then v_num_cuotas=0 end if %>
                                        <%=v_num_cuotas%>
                                        </font></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Monto del A&ntilde;o</font></td>
                                  <td><font size="2">:$</font></td>
                            <td><div align="right"><font size="1"> 
										<%v_f_monto_actual=f_detalle_pagare.ObtenerValor("monto_actual")
										if isnull(v_f_monto_actual) or v_f_monto_actual="" then v_f_monto_actual=0 end if
										 %>
                                        <%=FORMATNUMBER(v_f_monto_actual,0, 0, -1, -1) %>
                                        </font></div></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Total</font></td>
                                  <td><font size="2">:$</font></td>
                            <td><div align="right"><font size="1">
										<%v_f_suma=f_detalle_pagare.ObtenerValor("suma")
										if v_f_suma="" then v_f_suma=0 end if
										 %>
                                        <%= FORMATNUMBER(v_f_suma,0, 0, -1, -1) %>
                                        </font></div></td>
                            <td>&nbsp;</td>
                          </tr>
                        </table>
                               <%end if %>
						 <%if (nro_t=3) then %>
						<table width="90%" border="0">
                                    <tr> 
                                      <td width="99">&nbsp;</td>
                                      <td width="444"><div align="right">P&aacute;ginas: 
                                          &nbsp; 
                                          <%f_detalle_cheque_2.AccesoPagina%>
                                        </div></td>
                                      <td width="20"> <div align="right"> </div></td>
                                    </tr>
                              </table>
						        <form name="edicion_c" id="edicion_c">
                                  <table width="600" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center"> 
                                        <% f_detalle_cheque_2.DibujaTabla%>
                                      </td>
                                    </tr>
                                  </table>
                                </form>
						<%end if %><%if (nro_t=4) then %>
						 <table width="90%" border="0">
                                    <tr> 
                                      <td width="116">&nbsp;</td>
                                      <td width="511"><div align="right">P&aacute;ginas: 
                                          &nbsp; 
                                          <%f_detalle_letra.AccesoPagina%>
                                        </div></td>
                                      <td width="24"> <div align="right"> </div></td>
                                    </tr>
                              </table>
						       
                                <form name="edicion_l" id="edicion_l" >
                                  <table width="600" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center"> 
                                        <% f_detalle_letra.DibujaTabla%>
                                      </td>
                                    </tr>
                                  </table>
                                </form>  
						<%end if %>
						<%if (nro_t=5) then %>
						 <table width="90%" border="0">
                                    <tr> 
                                      <td width="116">&nbsp;</td>
                                      <td width="511"><div align="right">P&aacute;ginas: 
                                          &nbsp; 
                                          <%f_detalle_tarjetas.AccesoPagina%>
                                        </div></td>
                                      <td width="24"> <div align="right"> </div></td>
                                    </tr>
                              </table>
						       
                                <form name="edicion_l" id="edicion_tarjetas" >
                                  <table width="600" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center"> 
                                        <% f_detalle_tarjetas.DibujaTabla%>
                                      </td>
                                    </tr>
                                  </table>
                                </form>  
						<%end if 
						if (nro_t=6) then %>
						
						<table width="273" border="0">
                                          <tr>
                            <td width="46%"><font size="2">Multidebito</font></td>
                            <td width="6%"><font size="2">:</font></td>
                                    <td width="29%"><font size="1">
                                      <% f_detalle_multidebito.DibujaCampo("PMUL_NCORR") %>
                                      </font></td>
                            <td width="19%">&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Cantidad Cuotas</font></td>
                                  <td><font size="2">:</font></td>
                            <td><font size="1">
										<%v_num_cuotas=f_detalle_multidebito.ObtenerValor("num_cuotas")
										if  isnull(v_num_cuotas) or v_num_cuotas="" then v_num_cuotas=0 end if %>
                                        <%=v_num_cuotas%>
                                        </font></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Monto del A&ntilde;o</font></td>
                                  <td><font size="2">:$</font></td>
                            <td><div align="right"><font size="1"> 
										<%v_f_monto_actual=f_detalle_multidebito.ObtenerValor("monto_actual")
										if isnull(v_f_monto_actual) or v_f_monto_actual="" then v_f_monto_actual=0 end if
										 %>
                                        <%=FORMATNUMBER(v_f_monto_actual,0, 0, -1, -1) %>
                                        </font></div></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Total</font></td>
                                  <td><font size="2">:$</font></td>
                            <td><div align="right"><font size="1">
										<%v_f_suma=f_detalle_multidebito.ObtenerValor("suma")
										if v_f_suma="" then v_f_suma=0 end if
										 %>
                                        <%= FORMATNUMBER(v_f_suma,0, 0, -1, -1) %>
                                        </font></div></td>
                            <td>&nbsp;</td>
                          </tr>
                        </table>
                               <%end if 
							if (nro_t=7) then %>
						
						<table width="273" border="0">
                                          <tr>
                            <td width="46%"><font size="2">Pagare Upa</font></td>
                            <td width="6%"><font size="2">:</font></td>
                                    <td width="29%"><font size="1">
                                      <% f_detalle_pagare_upa.DibujaCampo("pupa_ncorr") %>
                                      </font></td>
                            <td width="19%">&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Cantidad Cuotas</font></td>
                                  <td><font size="2">:</font></td>
                            <td><font size="1">
										<%v_num_cuotas=f_detalle_pagare_upa.ObtenerValor("num_cuotas")
										if  isnull(v_num_cuotas) or v_num_cuotas="" then v_num_cuotas=0 end if %>
                                        <%=v_num_cuotas%>
                                        </font></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Monto del A&ntilde;o</font></td>
                                  <td><font size="2">:$</font></td>
                            <td><div align="right"><font size="1"> 
										<%v_f_monto_actual=f_detalle_pagare_upa.ObtenerValor("monto_actual")
										if isnull(v_f_monto_actual) or v_f_monto_actual="" then v_f_monto_actual=0 end if
										 %>
                                        <%=FORMATNUMBER(v_f_monto_actual,0, 0, -1, -1) %>
                                        </font></div></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Total</font></td>
                                  <td><font size="2">:$</font></td>
                            <td><div align="right"><font size="1">
										<%v_f_suma=f_detalle_pagare_upa.ObtenerValor("suma")
										if v_f_suma="" then v_f_suma=0 end if
										 %>
                                        <%= FORMATNUMBER(v_f_suma,0, 0, -1, -1) %>
                                        </font></div></td>
                            <td>&nbsp;</td>
                          </tr>
                        </table>
                               <%end if %>							   
						
						</td>
                          </tr>
                        </table></td>
                      <td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td width="9" height="28"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
                      <td height="28">
					  <table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td width="47%" height="20"><div align="center"> 
                                <table width="94%"  border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="49%"><div align="center"> 
                                        <%if (nro_t=1) then 
											'v_es_nuevo="CN"
											'v_es_nuevo="CA"
											botonera.agregabotonparam "imprimir_contrato", "url", "../REPORTESNET/imprimir_contrato.aspx?post_ncorr="&post_ncorr&"&post_nuevo="&v_es_nuevo  
										     botonera.dibujaboton "imprimir_contrato"
										end if
										
										if (nro_t=2) then 
										 		botonera.agregabotonparam "imprimir_pagare", "url","../REPORTESNET/imprimir_pagare.aspx?post_ncorr=" & post_ncorr  
										     	botonera.dibujaboton "imprimir_pagare" 
										end if 
										
										if (nro_t=3) then 
									         'botonera.agregabotonparam "imprimir_c", "url", "http://edoras/intranet/"'"imprimir_cheque_1.asp"
										     
										    ' botonera.dibujaboton "imprimir_c" 
                                        end if 
										
										if (nro_t=4) then 
										   'botonera.agregabotonparam "imprimir_l", "url", "http://172.16.11.130/reportes/imprimir_letra/imprimir_letra.aspx"
										   botonera.agregabotonparam "imprimir_l", "url", "../REPORTESNET/imprimir_letra.aspx"
										   botonera.dibujaboton "imprimir_l" 
										end if 
										
										if (nro_t=6) then 
										 		botonera.agregabotonparam "imprimir_pagare", "url","../REPORTESNET/imprimir_pagare.aspx?tipo_pagare=M&post_ncorr=" & post_ncorr  
										     	botonera.dibujaboton "imprimir_pagare" 
										end if 
										
										if (nro_t=7) then 
										 		botonera.agregabotonparam "imprimir_pagare", "url","../REPORTESNET/imprimir_pagare.aspx?tipo_pagare=U&post_ncorr=" & post_ncorr  
										     	botonera.dibujaboton "imprimir_pagare" 
										end if 
										%>

                                      </div></td>
                                    <td width="21%"><%
									if (nro_t=1) then 
											 botonera.agregabotonparam "imprimir_alumno", "url", "../REPORTESNET/ficha_alumno.aspx?post_ncorr=" &  post_ncorr  
										     botonera.dibujaboton "imprimir_alumno" 
									%>
									</td>
									<td width="30%">
										<% 
										 	f_botonera.agregabotonparam "imprimir", "texto", "Recursos" 
											f_botonera.dibujaboton "imprimir"
									%></td>
									<td width="30%">
										<% 
										if v_existe_anexo>=1 then
											f_botonera.agregabotonparam "imprimir", "texto", "Recursos" 
											f_botonera.dibujaboton "imprimir"
										end if
									end if 
									%></td>
									
                                  </tr>
                                </table>
                              </div></td>
                            <td width="53%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          </tr>
                          <tr> 
                            <td height="8" background="../imagenes/marco_claro/13.gif"></td>
                          </tr>
                        </table></td>
                      <td width="7" height="28"><img src="../imagenes/marco_claro/16.gif" width="7" height="28"></td>
                    </tr>
                  </table> <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="214" bgcolor="#D8D8DE"> <div align="right">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="2%">&nbsp;</td>
                        <td width="49%" align="center">
                       <%    botonera.agregabotonparam "anterior", "url", "genera_contrato_3.asp?post_ncorr=" & post_ncorr
                             botonera.dibujaboton "anterior" %>
                        </td>
                        <td width="49%" align="center">&nbsp; </td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="148" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
    
    <br>
    </td>
  </tr>  
</table>
</body>
</html>
