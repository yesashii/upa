<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:COMPRAS Y AUT. DE GIRO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:02/07/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			: 62, 288
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Validacion Contable"

v_vcon_ncorr= request.querystring("busqueda[0][vcon_ncorr]")
v_solicitud	= request.querystring("busqueda[0][solicitud]")

'RESPONSE.WRITE("1. v_vcon_ncorr:"&v_vcon_ncorr&"<BR>")
'RESPONSE.WRITE("2. v_solicitud:"&v_solicitud&"<BR>")

v_tipo		= request.querystring("busqueda[0][tsol_ccod]")
v_anos		= request.querystring("busqueda[0][anos_ccod]")

set botonera = new CFormulario
botonera.carga_parametros "validacion_contable.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

'88888888888888888888888888
set conexion = new CConexion
conexion.Inicializar "upacifico"
'88888888888888888888888888

v_usuario=negocio.ObtenerUsuario()
sql_validacion	=	"select ''"

Select Case v_tipo
   Case 1:
   	'solicitud a proveedores
		v_tipo_solicitud="PAGO A PROVEEDORES"
		if  v_solicitud<>"" then
		
'			sql_validacion	= " select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final,*, '1' as aprueba,sogi_mgiro as monto_solicitud "&_
'							  " ,sogi_tobservaciones as detalle_gasto "&_
'							  " from ocag_solicitud_giro a join personas b "&_
'							  " 	on a.pers_ncorr_proveedor=b.pers_ncorr "&_
'							  " 	and a.vibo_ccod in (2) and ocag_baprueba in (0,1)  "&_
'							  " left outer join ocag_validacion_contable d "&_
'							  "	on a.sogi_ncorr= d.cod_solicitud "&_
'							  " and d.tsol_ccod="&v_tipo&" "&_
'							  "	where a.sogi_ncorr="&v_solicitud &" "&_
'							  " and isnull(year(ocag_fingreso),2011)="&v_anos

			sql_validacion	= " select d.vcon_ncorr, isnull(d.vcon_brendicion_final,'N') as vcon_brendicion_final "&_
							  ", a.sogi_ncorr, a.ordc_ncorr, a.pers_ncorr_proveedor, a.tsol_ccod, a.cpag_ccod, a.sogi_fecha_solicitud, a.tgas_ccod, a.mes_ccod, a.anos_ccod "&_
							  ", a.cod_pre, a.vibo_ccod, a.audi_tusuario, a.audi_fmodificacion, a.sogi_frecepcion, a.sogi_tobs_rechazo, a.area_ccod, a.sogi_mretencion "&_
							  ", a.sogi_mhonorarios, a.sogi_mneto, a.sogi_miva, a.sogi_mexento, a.tmon_ccod, a.sogi_bboleta_honorario, a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto "&_
							  ", a.ocag_responsable, a.ocag_baprueba, a.sede_ccod "&_
							  ", b.PERS_NCORR, b.TVIS_CCOD, b.SEXO_CCOD, b.TENS_CCOD, b.COLE_CCOD, b.ECIV_CCOD, b.PAIS_CCOD, b.PERS_BDOBLE_NACIONALIDAD, b.PERS_NRUT, b.PERS_XDV "&_
							  ", b.PERS_TAPE_PATERNO, b.PERS_TAPE_MATERNO "&_
							  ", b.PERS_TNOMBRE + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO AS PERS_TNOMBRE "&_
							  ", b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO as v_nombre, b.PERS_FNACIMIENTO, b.CIUD_CCOD_NACIMIENTO, b.PERS_FDEFUNCION, b.PERS_TEMPRESA, b.PERS_TFONO_EMPRESA "&_
							  ", b.PERS_TCARGO, b.PERS_TPROFESION, b.PERS_TFONO, b.PERS_TFAX, b.PERS_TCELULAR, b.PERS_TEMAIL, b.PERS_TPASAPORTE, b.PERS_FEMISION_PAS, b.PERS_FVENCIMIENTO_PAS "&_
							  ", b.PERS_FTERMINO_VISA, b.PERS_NNOTA_ENS_MEDIA, b.PERS_TCOLE_EGRESO, b.PERS_NANO_EGR_MEDIA, b.PERS_TRAZON_SOCIAL, b.PERS_TGIRO, b.PERS_TEMAIL_INTERNO "&_
							  ", b.NEDU_CCOD, b.IFAM_CCOD, b.ALAB_CCOD, b.ISAP_CCOD, b.FFAA_CCOD, b.PERS_TTIPO_ENSENANZA, b.PERS_TENFERMEDADES, b.PERS_TMEDICAMENTOS_ALERGIA, b.AUDI_TUSUARIO "&_
							  ", b.AUDI_FMODIFICACION, b.ciud_nacimiento, b.regi_particular, b.ciud_particular, b.pers_bmorosidad, b.sicupadre_ccod, b.sitocup_ccod, b.tenfer_ccod "&_
							  ", b.descrip_tenfer, b.trabaja, b.pers_temail2 "&_
							  ", d.cod_solicitud, d.tsol_ccod, d.vibo_ccod, d.vcon_tdetalle_gasto, d.audi_tusuario, d.audi_fmodificacion, d.vcon_tmotivo_rechazo, d.sede_ccod "&_
							  ", '1' as aprueba, a.sogi_mgiro as monto_solicitud "&_
							  ",a.sogi_tobservaciones as detalle_gasto, c.PERS_TEMAIL AS email "&_
							  "from ocag_solicitud_giro a "&_
							  "INNER JOIN personas b "&_
							  "on a.pers_ncorr_proveedor = b.pers_ncorr and a.vibo_ccod in (2) and a.ocag_baprueba in (0,1) "&_
							  "and a.sogi_ncorr = "&v_solicitud&" and isnull(year(a.ocag_fingreso),2011) ="&v_anos&" "&_
							  "LEFT OUTER JOIN ocag_validacion_contable d "&_
							  "on a.sogi_ncorr = d.cod_solicitud  "&_
							  "and d.tsol_ccod = "&v_tipo &""&_ 
							  "INNER JOIN personas c "&_ 
							  "on a.audi_tusuario=c.pers_nrut "
'response.Write(sql_validacion)
'response.End()
		else
			sql_validacion	=	"select ''"
		end if
	
   Case 2:
   	'reembolso gastos
		v_tipo_solicitud="REEMBOLSO DE GASTOS"	
		if  v_solicitud<>"" then
		
'			sql_validacion	= " select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final,*, '1' as aprueba, rgas_mgiro as monto_solicitud, "&_
'								" (select top 1 tgas_tdesc from ocag_detalle_reembolso_gasto dr, ocag_tipo_gasto tg  "&_
'								" where dr.rgas_ncorr=a.rgas_ncorr and dr.tgas_ccod=tg.tgas_ccod) as tgas_tdesc, "&_
'								" (select top 1 tgas_cod_cuenta from ocag_detalle_reembolso_gasto dr, ocag_tipo_gasto tg  "&_
'								" where dr.rgas_ncorr=a.rgas_ncorr and dr.tgas_ccod=tg.tgas_ccod) as tgas_cod_cuenta, "&_
'								" (select top 1 tgas_nombre_cuenta from ocag_detalle_reembolso_gasto dr, ocag_tipo_gasto tg  "&_
'								" where dr.rgas_ncorr=a.rgas_ncorr and dr.tgas_ccod=tg.tgas_ccod) as tgas_nombre_cuenta "&_	
'								" ,'Sin observaciones' as detalle_gasto "&_							
'							  	" from ocag_reembolso_gastos a join personas b "&_
'							  	" 	on a.pers_ncorr_proveedor=b.pers_ncorr "&_
'								"		and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
'							  	" left outer join ocag_validacion_contable d "&_
'							  	"	on a.rgas_ncorr= d.cod_solicitud "&_
'								"   and d.tsol_ccod="&v_tipo&" "&_
'							  	"	where a.rgas_ncorr="&v_solicitud&" "&_
'								" 		and isnull(year(ocag_fingreso),2011)="&v_anos 
								
			sql_validacion	= " select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final "&_
								" , a.rgas_ncorr, a.rgas_mgiro, a.pers_ncorr_proveedor, a.rgas_fpago, a.tmon_ccod, a.mes_ccod, a.anos_ccod, a.cod_pre "&_
								" , a.vibo_ccod, a.audi_tusuario, a.audi_fmodificacion, a.rgas_frecepcion, a.rgas_tobs_rechazo, a.tsol_ccod, a.area_ccod "&_
								" , a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba, a.sede_ccod, a.cod_solicitud_origen "&_
								" , b.PERS_NCORR, b.TVIS_CCOD, b.SEXO_CCOD, b.TENS_CCOD, b.COLE_CCOD, b.ECIV_CCOD, b.PAIS_CCOD, b.PERS_BDOBLE_NACIONALIDAD, b.PERS_NRUT, b.PERS_XDV "&_
								" , b.PERS_TAPE_PATERNO, b.PERS_TAPE_MATERNO "&_
								" , b.PERS_TNOMBRE + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO AS PERS_TNOMBRE "&_
								" , b.PERS_FNACIMIENTO, b.CIUD_CCOD_NACIMIENTO, b.PERS_FDEFUNCION, b.PERS_TEMPRESA, b.PERS_TFONO_EMPRESA, b.PERS_TCARGO, b.PERS_TPROFESION, b.PERS_TFONO "&_
								" , b.PERS_TFAX, b.PERS_TCELULAR, b.PERS_TEMAIL AS email, b.PERS_TPASAPORTE, b.PERS_FEMISION_PAS, b.PERS_FVENCIMIENTO_PAS, b.PERS_FTERMINO_VISA, b.PERS_NNOTA_ENS_MEDIA "&_
								" , b.PERS_TCOLE_EGRESO, b.PERS_NANO_EGR_MEDIA, b.PERS_TRAZON_SOCIAL, b.PERS_TGIRO, b.PERS_TEMAIL_INTERNO, b.NEDU_CCOD, b.IFAM_CCOD, b.ALAB_CCOD "&_
								" , b.ISAP_CCOD, b.FFAA_CCOD, b.PERS_TTIPO_ENSENANZA, b.PERS_TENFERMEDADES, b.PERS_TMEDICAMENTOS_ALERGIA, b.AUDI_TUSUARIO, b.AUDI_FMODIFICACION "&_
								" , b.ciud_nacimiento, b.regi_particular, b.ciud_particular, b.pers_bmorosidad, b.sicupadre_ccod, b.sitocup_ccod, b.tenfer_ccod, b.descrip_tenfer "&_
								" , b.trabaja, b.pers_temail2 "&_
								" , d.vcon_ncorr, d.cod_solicitud, d.tsol_ccod, d.vibo_ccod, d.vcon_tdetalle_gasto, d.audi_tusuario, d.audi_fmodificacion, d.vcon_tmotivo_rechazo "&_
								" , d.vcon_brendicion_final, d.sede_ccod "&_
								" , '1' as aprueba, rgas_mgiro as monto_solicitud, "&_
								" (select top 1 tgas_tdesc from ocag_detalle_reembolso_gasto dr, ocag_tipo_gasto tg  "&_
								" where dr.rgas_ncorr=a.rgas_ncorr and dr.tgas_ccod=tg.tgas_ccod) as tgas_tdesc, "&_
								" (select top 1 tgas_cod_cuenta from ocag_detalle_reembolso_gasto dr, ocag_tipo_gasto tg  "&_
								" where dr.rgas_ncorr=a.rgas_ncorr and dr.tgas_ccod=tg.tgas_ccod) as tgas_cod_cuenta, "&_
								" (select top 1 tgas_nombre_cuenta from ocag_detalle_reembolso_gasto dr, ocag_tipo_gasto tg  "&_
								" where dr.rgas_ncorr=a.rgas_ncorr and dr.tgas_ccod=tg.tgas_ccod) as tgas_nombre_cuenta "&_	
								" ,'Sin observaciones' as detalle_gasto "&_							
							  	" from ocag_reembolso_gastos a join personas b "&_
							  	" 	on a.pers_ncorr_proveedor=b.pers_ncorr "&_
								"		and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
							  	" left outer join ocag_validacion_contable d "&_
							  	"	on a.rgas_ncorr= d.cod_solicitud "&_
								"   and d.tsol_ccod="&v_tipo&" "&_
							  	"	where a.rgas_ncorr="&v_solicitud&" "&_
								" 		and isnull(year(ocag_fingreso),2011)="&v_anos 
								 
		else
			sql_validacion	=	"select ''"
		end if

   Case 3:
   	'fondos a rendir
		v_tipo_solicitud="FONDO A RENDIR"	
		if  v_solicitud<>"" then
		
'			sql_validacion	= " select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final,*, '1' as aprueba,fren_mmonto as monto_solicitud   "&_
'							" ,fren_tdescripcion_actividad as detalle_gasto "&_
'							"	from ocag_fondos_a_rendir a join personas b   "&_
'							"		on a.pers_ncorr=b.pers_ncorr   "&_
'							"		and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
'							"	left outer join ocag_validacion_contable d   "&_
'							"		on a.fren_ncorr= d.cod_solicitud   "&_
'							"		and d.tsol_ccod= "&v_tipo&" "&_
'							"	where a.fren_ncorr= "&v_solicitud&" "&_
'							" 		and isnull(year(ocag_fingreso),2011)="&v_anos 
							
			sql_validacion	= " select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final "&_
 							", a.fren_ncorr, a.pers_ncorr, a.fren_mmonto, a.fren_fpago, a.fren_factividad, a.mes_ccod, a.anos_ccod, a.fren_tdescripcion_actividad "&_
 							", a.cod_pre, a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.fren_frecepcion, a.fren_tobs_rechazo, a.tsol_ccod, a.area_ccod "&_
 							", a.tmon_ccod, a.pers_nrut_aut, a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable "&_
 							", a.ocag_baprueba, a.sede_ccod, a.ccos_ncorr "&_
 							", b.PERS_NCORR, b.TVIS_CCOD, b.SEXO_CCOD, b.TENS_CCOD, b.COLE_CCOD ,b.ECIV_CCOD ,b.PAIS_CCOD ,b.PERS_BDOBLE_NACIONALIDAD ,b.PERS_NRUT ,b.PERS_XDV "&_
 							", b.PERS_TAPE_PATERNO, b.PERS_TAPE_MATERNO "&_
 							", b.PERS_TNOMBRE + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO AS PERS_TNOMBRE "&_
 							", b.PERS_FNACIMIENTO, b.CIUD_CCOD_NACIMIENTO, b.PERS_FDEFUNCION, b.PERS_TEMPRESA, b.PERS_TFONO_EMPRESA, b.PERS_TCARGO, b.PERS_TPROFESION "&_
 							", b.PERS_TFONO, b.PERS_TFAX, b.PERS_TCELULAR, b.PERS_TEMAIL AS email, b.PERS_TPASAPORTE, b.PERS_FEMISION_PAS, b.PERS_FVENCIMIENTO_PAS, b.PERS_FTERMINO_VISA "&_
 							", b.PERS_NNOTA_ENS_MEDIA, b.PERS_TCOLE_EGRESO, b.PERS_NANO_EGR_MEDIA, b.PERS_TRAZON_SOCIAL, b.PERS_TGIRO, b.PERS_TEMAIL_INTERNO, b.NEDU_CCOD "&_
 							", b.IFAM_CCOD, b.ALAB_CCOD, b.ISAP_CCOD, b.FFAA_CCOD, b.PERS_TTIPO_ENSENANZA, b.PERS_TENFERMEDADES, b.PERS_TMEDICAMENTOS_ALERGIA, b.AUDI_TUSUARIO "&_
 							", b.AUDI_FMODIFICACION, b.ciud_nacimiento, b.regi_particular, b.ciud_particular, b.pers_bmorosidad, b.sicupadre_ccod, b.sitocup_ccod "&_
 							", b.tenfer_ccod, b.descrip_tenfer, b.trabaja, b.pers_temail2 "&_
 							", d.vcon_ncorr, d.cod_solicitud, d.tsol_ccod, d.vibo_ccod, d.vcon_tdetalle_gasto, d.audi_tusuario, d.audi_fmodificacion, d.vcon_tmotivo_rechazo "&_
 							", d.vcon_brendicion_final, d.sede_ccod "&_
							", '1' as aprueba,fren_mmonto as monto_solicitud   "&_
							" ,fren_tdescripcion_actividad as detalle_gasto "&_
							"	from ocag_fondos_a_rendir a join personas b   "&_
							"		on a.pers_ncorr=b.pers_ncorr   "&_
							"		and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
							"	left outer join ocag_validacion_contable d   "&_
							"		on a.fren_ncorr= d.cod_solicitud   "&_
							"		and d.tsol_ccod= "&v_tipo&" "&_
							"	where a.fren_ncorr= "&v_solicitud&" "&_
							" 		and isnull(year(ocag_fingreso),2011)="&v_anos 
							
		else
			sql_validacion	=	"select ''"
		end if

   Case 4:
   	'viaticos
		v_tipo_solicitud="SOLICITUD DE VIATICO"	
		if  v_solicitud<>"" then
		
'			sql_validacion	= "   select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final,*, '1' as aprueba,sovi_mmonto_pesos as monto_solicitud   "&_
'							" ,'Sin observaciones' as detalle_gasto "&_
'							"	from ocag_solicitud_viatico a join personas b   "&_
'							"		on a.pers_ncorr=b.pers_ncorr   "&_
'							"		and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
'							"	left outer join ocag_validacion_contable d   "&_
'							"		on a.sovi_ncorr= d.cod_solicitud   "&_
'							"		and d.tsol_ccod= "&v_tipo&" "&_
'							"	where a.sovi_ncorr= "&v_solicitud&" "&_
'							" 		and isnull(year(ocag_fingreso),2011)="&v_anos  
							
			sql_validacion	= "   select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final "&_
							", a.sovi_ncorr, a.pers_ncorr, a.sovi_fpago, a.anos_ccod, a.mes_ccod, a.cod_pre, a.area_ccod, a.sovi_tdetalle_presu, a.orvi_ccod, a.devi_ccod "&_
   							", a.sovi_fsalida, a.sovi_fllegada, a.sovi_hsalida, a.sovi_hllegada, a.sovi_mmonto_dia, a.sovi_mmonto_origen, a.sovi_mmonto_pesos, a.sovi_tmotivo "&_
   							", a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.sovi_frecepcion, a.sovi_tobs_rechazo, a.tsol_ccod, a.ocag_fingreso, a.ocag_generador "&_
   							", a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba, a.sede_ccod, a.ccos_ncorr "&_
   							", b.PERS_NCORR, b.TVIS_CCOD, b.SEXO_CCOD, b.TENS_CCOD, b.COLE_CCOD ,b.ECIV_CCOD ,b.PAIS_CCOD ,b.PERS_BDOBLE_NACIONALIDAD ,b.PERS_NRUT ,b.PERS_XDV "&_
   							", b.PERS_TAPE_PATERNO, b.PERS_TAPE_MATERNO "&_
   							", b.PERS_TNOMBRE + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO AS PERS_TNOMBRE "&_
   							", b.PERS_FNACIMIENTO, b.CIUD_CCOD_NACIMIENTO, b.PERS_FDEFUNCION, b.PERS_TEMPRESA, b.PERS_TFONO_EMPRESA, b.PERS_TCARGO, b.PERS_TPROFESION "&_
   							", b.PERS_TFONO, b.PERS_TFAX, b.PERS_TCELULAR, b.PERS_TEMAIL AS email, b.PERS_TPASAPORTE, b.PERS_FEMISION_PAS, b.PERS_FVENCIMIENTO_PAS, b.PERS_FTERMINO_VISA "&_
   							", b.PERS_NNOTA_ENS_MEDIA, b.PERS_TCOLE_EGRESO, b.PERS_NANO_EGR_MEDIA, b.PERS_TRAZON_SOCIAL, b.PERS_TGIRO, b.PERS_TEMAIL_INTERNO, b.NEDU_CCOD "&_
   							", b.IFAM_CCOD, b.ALAB_CCOD, b.ISAP_CCOD, b.FFAA_CCOD, b.PERS_TTIPO_ENSENANZA, b.PERS_TENFERMEDADES, b.PERS_TMEDICAMENTOS_ALERGIA, b.AUDI_TUSUARIO "&_
   							", b.AUDI_FMODIFICACION, b.ciud_nacimiento, b.regi_particular, b.ciud_particular, b.pers_bmorosidad, b.sicupadre_ccod, b.sitocup_ccod "&_
   							", b.tenfer_ccod, b.descrip_tenfer, b.trabaja, b.pers_temail2 "&_
   							", d.vcon_ncorr, d.cod_solicitud, d.tsol_ccod, d.vibo_ccod, d.vcon_tdetalle_gasto, d.audi_tusuario, d.audi_fmodificacion, d.vcon_tmotivo_rechazo "&_
   							", d.vcon_brendicion_final, d.sede_ccod  "&_
							", '1' as aprueba,sovi_mmonto_pesos as monto_solicitud   "&_
							" ,'Sin observaciones' as detalle_gasto "&_
							"	from ocag_solicitud_viatico a join personas b   "&_
							"		on a.pers_ncorr=b.pers_ncorr   "&_
							"		and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
							"	left outer join ocag_validacion_contable d   "&_
							"		on a.sovi_ncorr= d.cod_solicitud   "&_
							"		and d.tsol_ccod= "&v_tipo&" "&_
							"	where a.sovi_ncorr= "&v_solicitud&" "&_
							" 		and isnull(year(ocag_fingreso),2011)="&v_anos  
			
		else
			sql_validacion	=	"select ''"
		end if

   Case 5:
   	'devolucion alumnos
		v_tipo_solicitud="DEVOLUCION ALUMNO"	
		if  v_solicitud<>"" then
		
'			sql_validacion	= "   select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final,*, '1' as aprueba,dalu_mmonto_pesos as monto_solicitud   "&_
'							" ,'Sin observaciones' as detalle_gasto , ccos_ccod "&_
'							"	from ocag_devolucion_alumno a join personas b   "&_
'							"		on a.pers_ncorr=b.pers_ncorr   "&_
'							"		and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
'							"	left outer join ocag_validacion_contable d   "&_
'							"		on a.dalu_ncorr= d.cod_solicitud   "&_
'							"		and d.tsol_ccod= "&v_tipo&" "&_
'							"	where a.dalu_ncorr= "&v_solicitud&" "&_
'							" 		and isnull(year(ocag_fingreso),2011)="&v_anos   
							
			sql_validacion	= "   select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final "&_
							"   , a.dalu_ncorr, a.pers_ncorr, a.dalu_fpago, a.dalu_mmonto_pesos, a.tdev_ccod, a.cod_pre, a.mes_ccod, a.anos_ccod, a.pers_nrut_alu, a.pers_xdv_alu "&_
   							", a.pers_tnombre_alu, a.carrera_alu, a.dalu_tmotivo, a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.dalu_frecepcion, a.dalu_tobs_rechazo "&_
   							", a.tsol_ccod, a.area_ccod, a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable "&_
   							", a.ocag_baprueba, a.sede_ccod, a.ccos_ccod, a.ccos_ccod as ccos_ccod_02, x.ccos_ncorr "&_
   							", b.PERS_NCORR, b.TVIS_CCOD, b.SEXO_CCOD, b.TENS_CCOD, b.COLE_CCOD ,b.ECIV_CCOD ,b.PAIS_CCOD ,b.PERS_BDOBLE_NACIONALIDAD ,b.PERS_NRUT ,b.PERS_XDV "&_
   							", b.PERS_TAPE_PATERNO, b.PERS_TAPE_MATERNO "&_
   							", b.PERS_TNOMBRE + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO AS PERS_TNOMBRE "&_
   							", b.PERS_FNACIMIENTO, b.CIUD_CCOD_NACIMIENTO, b.PERS_FDEFUNCION, b.PERS_TEMPRESA, b.PERS_TFONO_EMPRESA, b.PERS_TCARGO, b.PERS_TPROFESION "&_
   							", b.PERS_TFONO, b.PERS_TFAX, b.PERS_TCELULAR, b.PERS_TEMAIL AS email, b.PERS_TPASAPORTE, b.PERS_FEMISION_PAS, b.PERS_FVENCIMIENTO_PAS, b.PERS_FTERMINO_VISA "&_
   							", b.PERS_NNOTA_ENS_MEDIA, b.PERS_TCOLE_EGRESO, b.PERS_NANO_EGR_MEDIA, b.PERS_TRAZON_SOCIAL, b.PERS_TGIRO, b.PERS_TEMAIL_INTERNO, b.NEDU_CCOD "&_
   							", b.IFAM_CCOD, b.ALAB_CCOD, b.ISAP_CCOD, b.FFAA_CCOD, b.PERS_TTIPO_ENSENANZA, b.PERS_TENFERMEDADES, b.PERS_TMEDICAMENTOS_ALERGIA, b.AUDI_TUSUARIO "&_
   							", b.AUDI_FMODIFICACION, b.ciud_nacimiento, b.regi_particular, b.ciud_particular, b.pers_bmorosidad, b.sicupadre_ccod, b.sitocup_ccod "&_
   							", b.tenfer_ccod, b.descrip_tenfer, b.trabaja, b.pers_temail2 "&_
   							", d.vcon_ncorr, d.cod_solicitud, d.tsol_ccod, d.vibo_ccod, d.vcon_tdetalle_gasto, d.audi_tusuario, d.audi_fmodificacion, d.vcon_tmotivo_rechazo "&_
   							", d.vcon_brendicion_final, d.sede_ccod "&_
							", '1' as aprueba,dalu_mmonto_pesos as monto_solicitud   "&_
							" ,'Sin observaciones' as detalle_gasto "&_
							" from ocag_devolucion_alumno a join personas b   "&_
							" on a.pers_ncorr=b.pers_ncorr   "&_
							" and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
							" INNER JOIN centros_costo w  "&_
							" on a.ccos_ccod = w.ccos_ccod  "&_
							" LEFT OUTER JOIN ocag_centro_costo x  "&_
							" on CCOS_TCOMPUESTO COLLATE SQL_Latin1_General_CP1_CI_AS  = x.ccos_tcodigo COLLATE SQL_Latin1_General_CP1_CI_AS "&_
							" LEFT OUTER JOIN ocag_validacion_contable d   "&_
							"		on a.dalu_ncorr= d.cod_solicitud   "&_
							"		and d.tsol_ccod= "&v_tipo&" "&_
							"	where a.dalu_ncorr= "&v_solicitud&" "&_
							" 		and isnull(year(ocag_fingreso),2011)="&v_anos   
			
		else
			sql_validacion	=	"select ''"
		end if

   Case 6:
   	'fondo fijo
		v_tipo_solicitud="NUEVO FONDO FIJO"
		if  v_solicitud<>"" then
		
'			sql_validacion	= "   select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final,*, '1' as aprueba,ffij_mmonto_pesos as monto_solicitud   "&_
'							" ,'Sin observaciones' as detalle_gasto "&_
'							"	from ocag_fondo_fijo a join personas b   "&_
'							"		on a.pers_ncorr=b.pers_ncorr   "&_
'							"		and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
'							"	left outer join ocag_validacion_contable d   "&_
'							"		on a.ffij_ncorr= d.cod_solicitud   "&_
'							"		and d.tsol_ccod= "&v_tipo&" "&_
'							"	where a.ffij_ncorr= "&v_solicitud&" "&_
'							" 		and isnull(year(ocag_fingreso),2011)="&v_anos   
							
			sql_validacion	= "   select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final "&_
   							", a.ffij_ncorr, a.pers_ncorr, a.ffij_mmonto_pesos, a.ffij_fpago, a.area_ccod, a.cod_pre, a.ffij_tdetalle_presu, a.mes_ccod, a.anos_ccod "&_
   							", a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.ffij_frecepcion, a.ffij_tobs_rechazo, a.tsol_ccod, a.pers_nrut_aut, a.tmon_ccod "&_
   							", a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba, a.sede_ccod "&_
   							", b.PERS_NCORR, b.TVIS_CCOD, b.SEXO_CCOD, b.TENS_CCOD, b.COLE_CCOD ,b.ECIV_CCOD ,b.PAIS_CCOD ,b.PERS_BDOBLE_NACIONALIDAD ,b.PERS_NRUT ,b.PERS_XDV "&_
   							", b.PERS_TAPE_PATERNO, b.PERS_TAPE_MATERNO "&_
   							", b.PERS_TNOMBRE + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO AS PERS_TNOMBRE "&_
   							", b.PERS_FNACIMIENTO, b.CIUD_CCOD_NACIMIENTO, b.PERS_FDEFUNCION, b.PERS_TEMPRESA, b.PERS_TFONO_EMPRESA, b.PERS_TCARGO, b.PERS_TPROFESION "&_
   							", b.PERS_TFONO, b.PERS_TFAX, b.PERS_TCELULAR, b.PERS_TEMAIL AS email, b.PERS_TPASAPORTE, b.PERS_FEMISION_PAS, b.PERS_FVENCIMIENTO_PAS, b.PERS_FTERMINO_VISA "&_
   							", b.PERS_NNOTA_ENS_MEDIA, b.PERS_TCOLE_EGRESO, b.PERS_NANO_EGR_MEDIA, b.PERS_TRAZON_SOCIAL, b.PERS_TGIRO, b.PERS_TEMAIL_INTERNO, b.NEDU_CCOD "&_
   							", b.IFAM_CCOD, b.ALAB_CCOD, b.ISAP_CCOD, b.FFAA_CCOD, b.PERS_TTIPO_ENSENANZA, b.PERS_TENFERMEDADES, b.PERS_TMEDICAMENTOS_ALERGIA, b.AUDI_TUSUARIO "&_
							" , b.AUDI_FMODIFICACION, b.ciud_nacimiento, b.regi_particular, b.ciud_particular, b.pers_bmorosidad, b.sicupadre_ccod, b.sitocup_ccod "&_
   							", b.tenfer_ccod, b.descrip_tenfer, b.trabaja, b.pers_temail2 "&_
   							", d.vcon_ncorr, d.cod_solicitud, d.tsol_ccod, d.vibo_ccod, d.vcon_tdetalle_gasto, d.audi_tusuario, d.audi_fmodificacion, d.vcon_tmotivo_rechazo "&_
							" , d.vcon_brendicion_final, d.sede_ccod      "&_
							" , '1' as aprueba,ffij_mmonto_pesos as monto_solicitud   "&_
							" ,'Sin observaciones' as detalle_gasto "&_
							"	from ocag_fondo_fijo a join personas b   "&_
							"		on a.pers_ncorr=b.pers_ncorr   "&_
							"		and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
							"	left outer join ocag_validacion_contable d   "&_
							"		on a.ffij_ncorr= d.cod_solicitud   "&_
							"		and d.tsol_ccod= "&v_tipo&" "&_
							"	where a.ffij_ncorr= "&v_solicitud&" "&_
							" 		and isnull(year(ocag_fingreso),2011)="&v_anos   
			
		else
			sql_validacion	=	"select ''"
		end if
		
		
   Case 7:
   	'RENDICION fondos a rendir
		v_tipo_solicitud="RENDICION FONDO A RENDIR"	
		
		if  v_solicitud<>"" then
		
'			sql_validacion	= " select vcon_ncorr,isnull(vcon_brendicion_final,'N') as vcon_brendicion_final,*, '1' as aprueba,fren_mmonto as monto_solicitud   "&_
'							" ,fren_tdescripcion_actividad as detalle_gasto "&_
'							"	from ocag_fondos_a_rendir a join personas b   "&_
'							"		on a.pers_ncorr=b.pers_ncorr   "&_
'							"		and a.vibo_ccod in (2)  and ocag_baprueba in (0,1)   "&_
'							"	left outer join ocag_validacion_contable d   "&_
'							"		on a.fren_ncorr= d.cod_solicitud   "&_
'							"		and d.tsol_ccod= "&v_tipo&" "&_
'							"	where a.fren_ncorr= "&v_solicitud&" "&_
'							" 		and isnull(year(ocag_fingreso),2011)="&v_anos 
							
			sql_validacion	= " SELECT e.vcon_ncorr, isnull(e.vcon_brendicion_final,'N') as vcon_brendicion_final, b.fren_ncorr, b.pers_ncorr, a.rfre_mmonto as fren_mmonto "&_
							", b.fren_fpago, b.fren_factividad, b.mes_ccod, b.anos_ccod, b.fren_tdescripcion_actividad , b.cod_pre, b.audi_tusuario "&_
							", b.audi_fmodificacion, b.vibo_ccod, b.fren_frecepcion, b.fren_tobs_rechazo, b.tsol_ccod, b.area_ccod , b.tmon_ccod, b.pers_nrut_aut "&_
							", b.ocag_fingreso, b.ocag_generador, b.ocag_frecepcion_presupuesto, b.ocag_responsable , b.ocag_baprueba, b.sede_ccod, b.ccos_ncorr  "&_
							", c.PERS_NCORR, c.TVIS_CCOD, c.SEXO_CCOD, c.TENS_CCOD, c.COLE_CCOD ,c.ECIV_CCOD ,c.PAIS_CCOD ,c.PERS_BDOBLE_NACIONALIDAD "&_
							", c.PERS_NRUT ,c.PERS_XDV , c.PERS_TAPE_PATERNO, c.PERS_TAPE_MATERNO , c.PERS_TNOMBRE + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO AS PERS_TNOMBRE "&_
							", c.PERS_FNACIMIENTO, c.CIUD_CCOD_NACIMIENTO, c.PERS_FDEFUNCION, c.PERS_TEMPRESA, c.PERS_TFONO_EMPRESA, c.PERS_TCARGO, c.PERS_TPROFESION "&_
							", c.PERS_TFONO, c.PERS_TFAX, c.PERS_TCELULAR, c.PERS_TEMAIL AS email, c.PERS_TPASAPORTE, c.PERS_FEMISION_PAS "&_
							", c.PERS_FVENCIMIENTO_PAS, c.PERS_FTERMINO_VISA , c.PERS_NNOTA_ENS_MEDIA, c.PERS_TCOLE_EGRESO, c.PERS_NANO_EGR_MEDIA "&_
							", c.PERS_TRAZON_SOCIAL, c.PERS_TGIRO, c.PERS_TEMAIL_INTERNO, c.NEDU_CCOD , c.IFAM_CCOD, c.ALAB_CCOD, c.ISAP_CCOD "&_
							", c.FFAA_CCOD, c.PERS_TTIPO_ENSENANZA, c.PERS_TENFERMEDADES, c.PERS_TMEDICAMENTOS_ALERGIA, c.AUDI_TUSUARIO "&_
							", c.AUDI_FMODIFICACION, c.ciud_nacimiento, c.regi_particular, c.ciud_particular, c.pers_bmorosidad, c.sicupadre_ccod "&_
							", c.sitocup_ccod , c.tenfer_ccod, c.descrip_tenfer, c.trabaja, c.pers_temail2 , e.vcon_ncorr, e.cod_solicitud "&_
							", e.tsol_ccod, e.vibo_ccod, e.vcon_tdetalle_gasto, e.audi_tusuario, e.audi_fmodificacion, e.vcon_tmotivo_rechazo "&_
							", e.vcon_brendicion_final, e.sede_ccod , '1' as aprueba, a.rfre_mmonto as monto_solicitud ,fren_tdescripcion_actividad as detalle_gasto "&_
							"FROM ocag_rendicion_fondos_a_rendir a "&_
							"INNER JOIN ocag_fondos_a_rendir b "&_
							"ON a.fren_ncorr = b.fren_ncorr and a.rfre_ncorr = "&v_solicitud&" "&_
							"AND a.vibo_ccod in (2) and a.ocag_baprueba in (0,1) "&_
							"AND isnull(year(a.ocag_fingreso),2011)="&v_anos&" "&_
							"INNER JOIN personas c "&_
							"ON b.pers_ncorr=c.pers_ncorr "&_
							"LEFT OUTER JOIN ocag_validacion_contable e "&_
							"ON a.rfre_ncorr= e.cod_solicitud and e.tsol_ccod = 7"
							
		else
			sql_validacion	=	"select ''"
		end if

   Case 8:
   	'RENDICION fondo fijo
		v_tipo_solicitud="RENDICION FONDO FIJO"
		if  v_solicitud<>"" then
							
'			sql_validacion	= " select isnull(e.vcon_brendicion_final,'N') as vcon_brendicion_final "&_
'							" , c.ffij_ncorr, c.pers_ncorr, c.ffij_mmonto_pesos "&_
'							" , c.ffij_fpago, c.area_ccod, c.cod_pre, c.ffij_tdetalle_presu, c.mes_ccod, c.anos_ccod , c.audi_tusuario, c.audi_fmodificacion "&_
'							" , c.vibo_ccod, c.ffij_frecepcion, c.ffij_tobs_rechazo, c.tsol_ccod, c.pers_nrut_aut, c.tmon_ccod , c.ocag_fingreso, c.ocag_generador "&_
'							" , c.ocag_frecepcion_presupuesto, c.ocag_responsable, c.ocag_baprueba, c.sede_ccod "&_
'							" , d.PERS_NCORR, d.TVIS_CCOD, d.SEXO_CCOD, d.TENS_CCOD "&_
'							" , d.COLE_CCOD ,d.ECIV_CCOD ,d.PAIS_CCOD ,d.PERS_BDOBLE_NACIONALIDAD ,d.PERS_NRUT ,d.PERS_XDV , d.PERS_TAPE_PATERNO, d.PERS_TAPE_MATERNO "&_
'							" , d.PERS_TNOMBRE + ' ' + d.PERS_TAPE_PATERNO + ' ' + d.PERS_TAPE_MATERNO AS PERS_TNOMBRE , d.PERS_FNACIMIENTO, d.CIUD_CCOD_NACIMIENTO "&_
'							" , d.PERS_FDEFUNCION, d.PERS_TEMPRESA, d.PERS_TFONO_EMPRESA, d.PERS_TCARGO, d.PERS_TPROFESION , d.PERS_TFONO, d.PERS_TFAX, d.PERS_TCELULAR "&_
'							" , d.PERS_TEMAIL AS email, d.PERS_TPASAPORTE, d.PERS_FEMISION_PAS, d.PERS_FVENCIMIENTO_PAS, d.PERS_FTERMINO_VISA , d.PERS_NNOTA_ENS_MEDIA "&_
'							" , d.PERS_TCOLE_EGRESO, d.PERS_NANO_EGR_MEDIA, d.PERS_TRAZON_SOCIAL, d.PERS_TGIRO, d.PERS_TEMAIL_INTERNO, d.NEDU_CCOD "&_
'							" , d.IFAM_CCOD, d.ALAB_CCOD, d.ISAP_CCOD, d.FFAA_CCOD, d.PERS_TTIPO_ENSENANZA, d.PERS_TENFERMEDADES, d.PERS_TMEDICAMENTOS_ALERGIA "&_
'							" , d.AUDI_TUSUARIO , d.AUDI_FMODIFICACION, d.ciud_nacimiento, d.regi_particular, d.ciud_particular "&_
'							" , d.pers_bmorosidad, d.sicupadre_ccod, d.sitocup_ccod , d.tenfer_ccod, d.descrip_tenfer, d.trabaja, d.pers_temail2 "&_
'							" , e.vcon_ncorr "&_
'							" , e.cod_solicitud, e.tsol_ccod, e.vibo_ccod, e.vcon_tdetalle_gasto, e.audi_tusuario, e.audi_fmodificacion, e.vcon_tmotivo_rechazo "&_
'							" , e.sede_ccod , '1' as aprueba,ffij_mmonto_pesos as monto_solicitud ,'Sin observaciones' as detalle_gasto "&_
'							" from ocag_rendicion_fondo_fijo a "&_
'							" INNER JOIN ocag_detalle_rendicion_fondo_fijo B "&_
'							" ON a.ffij_ncorr = B.ffij_ncorr "&_
'							" and a.rffi_ncorr = "&v_solicitud&" "&_ 
'							" and a.vibo_ccod in (2) and a.ocag_baprueba in (0,1) "&_
'							" and isnull(year(a.ocag_fingreso),2013)="&v_anos&" "&_
'							" inner join ocag_fondo_fijo c "&_
'							" ON A.ffij_ncorr = C.ffij_ncorr "&_
'							" INNER JOIN personas d  "&_
'							" on c.pers_ncorr=d.pers_ncorr "&_
'							" LEFT OUTER JOIN ocag_validacion_contable e "&_
'							" ON b.rffi_ncorr= e.cod_solicitud and e.tsol_ccod ="&v_tipo
							
			sql_validacion	= " select isnull(e.vcon_brendicion_final,'N') as vcon_brendicion_final "&_
							" , B.ffij_ncorr, B.pers_ncorr "&_
							" , A.rffi_mmonto ffij_mmonto_pesos "&_
							" , B.ffij_fpago, B.area_ccod "&_
							" , B.cod_pre, B.ffij_tdetalle_presu, B.mes_ccod, B.anos_ccod , B.audi_tusuario, B.audi_fmodificacion , B.vibo_ccod, B.ffij_frecepcion "&_
							" , B.ffij_tobs_rechazo, B.tsol_ccod, B.pers_nrut_aut, B.tmon_ccod , B.ocag_fingreso, B.ocag_generador , B.ocag_frecepcion_presupuesto "&_
							" , B.ocag_responsable, B.ocag_baprueba, B.sede_ccod "&_
							" , d.PERS_NCORR, d.TVIS_CCOD, d.SEXO_CCOD, d.TENS_CCOD , d.COLE_CCOD ,d.ECIV_CCOD "&_
							" , d.PAIS_CCOD ,d.PERS_BDOBLE_NACIONALIDAD ,d.PERS_NRUT ,d.PERS_XDV , d.PERS_TAPE_PATERNO, d.PERS_TAPE_MATERNO "&_
							" , d.PERS_TNOMBRE + ' ' + d.PERS_TAPE_PATERNO + ' ' + d.PERS_TAPE_MATERNO AS PERS_TNOMBRE , d.PERS_FNACIMIENTO, d.CIUD_CCOD_NACIMIENTO "&_
							" , d.PERS_FDEFUNCION, d.PERS_TEMPRESA, d.PERS_TFONO_EMPRESA, d.PERS_TCARGO, d.PERS_TPROFESION , d.PERS_TFONO, d.PERS_TFAX, d.PERS_TCELULAR "&_
							" , d.PERS_TEMAIL AS email, d.PERS_TPASAPORTE, d.PERS_FEMISION_PAS, d.PERS_FVENCIMIENTO_PAS, d.PERS_FTERMINO_VISA , d.PERS_NNOTA_ENS_MEDIA "&_
							" , d.PERS_TCOLE_EGRESO, d.PERS_NANO_EGR_MEDIA, d.PERS_TRAZON_SOCIAL, d.PERS_TGIRO, d.PERS_TEMAIL_INTERNO, d.NEDU_CCOD , d.IFAM_CCOD, d.ALAB_CCOD "&_
							" , d.ISAP_CCOD, d.FFAA_CCOD, d.PERS_TTIPO_ENSENANZA, d.PERS_TENFERMEDADES, d.PERS_TMEDICAMENTOS_ALERGIA , d.AUDI_TUSUARIO , d.AUDI_FMODIFICACION "&_
							" , d.ciud_nacimiento, d.regi_particular, d.ciud_particular , d.pers_bmorosidad, d.sicupadre_ccod, d.sitocup_ccod , d.tenfer_ccod, d.descrip_tenfer "&_
							" , d.trabaja, d.pers_temail2 , e.vcon_ncorr , e.cod_solicitud, e.tsol_ccod, e.vibo_ccod, e.vcon_tdetalle_gasto, e.audi_tusuario, e.audi_fmodificacion "&_
							" , e.vcon_tmotivo_rechazo , e.sede_ccod , '1' as aprueba , A.rffi_mmonto as monto_solicitud ,'Sin observaciones' as detalle_gasto "&_
							" from ocag_rendicion_fondo_fijo A "&_
							" INNER JOIN ocag_fondo_fijo B "&_
							" ON A.ffij_ncorr = B.ffij_ncorr AND a.rffi_ncorr = "&v_solicitud&" and a.vibo_ccod in (2) and a.ocag_baprueba in (0,1) and isnull(year(a.ocag_fingreso),2013)="&v_anos&" "&_
							" INNER JOIN personas d "&_
							" on B.pers_ncorr=d.pers_ncorr "&_
							" LEFT OUTER JOIN ocag_validacion_contable e "&_
							" ON A.rffi_ncorr= e.cod_solicitud and e.tsol_ccod ="&v_tipo
			
		else
			sql_validacion	=	"select ''"
		end if
		
'rffi_ncorr' 
	Case else:
		sql_validacion	=	"select ''"			
End Select

'response.Write("1. :"&sql_validacion&"<br>")
'response.End()

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "validacion_contable.xml", "datos_solicitud"
f_busqueda.Inicializar conectar
f_busqueda.Consultar sql_validacion
f_busqueda.Siguiente

if f_busqueda.nrofilas >=1 and v_vcon_ncorr="" then

	v_vcon_ncorr=f_busqueda.ObtenerValor("vcon_ncorr")
	v_fecha_presupuesto=f_busqueda.ObtenerValor("ocag_frecepcion_presupuesto")
	v_monto=f_busqueda.ObtenerValor("monto_solicitud")
	v_BOLETA=f_busqueda.ObtenerValor("sogi_bboleta_honorario")

end if

if EsVacio(v_monto) or v_monto="" then
	v_monto=0
end if

'##################################################################
'########### DESGLOSE DE VALIDACION CONTABLE	###################
 
 'DETALLE TIPO DE GASTOS (Cuentas Contables)
set f_detalle_tg = new CFormulario
f_detalle_tg.Carga_Parametros "validacion_contable.xml", "detalle_tipo_gasto"
f_detalle_tg.Inicializar conectar

if v_vcon_ncorr<> "" then

'	sql_detalle_tipo_gasto="select * from ocag_tipo_gasto_validacion where vcon_ncorr="&v_vcon_ncorr
	
	sql_detalle_tipo_gasto="SELECT vcon_ncorr, tgva_ncorr, tgas_ccod, tgva_tcuenta_contable, tgva_mmonto, audi_tusuario, audi_fmodificacion "&_
													"FROM ocag_tipo_gasto_validacion where vcon_ncorr="&v_vcon_ncorr
	
	pago_boleta="select ISNULL(a.ordc_ncorr,0) as ordc_ncorr "&_
									" from ocag_solicitud_giro a "&_
									" LEFT JOIN ocag_detalle_solicitud_ag b "&_
									" ON a.sogi_ncorr=B.sogi_ncorr WHERE cast(a.sogi_ncorr as varchar)='"&v_solicitud&"'"
	
else

	'Select Case v_tipo 
	Select Case CInt(v_tipo)   
		Case 1:
		' PAGO DE PROVEEDORES
		
			pago_boleta="select ISNULL(a.ordc_ncorr,0) as ordc_ncorr "&_
									" from ocag_solicitud_giro a "&_
									" LEFT JOIN ocag_detalle_solicitud_ag b "&_
									" ON a.sogi_ncorr=B.sogi_ncorr WHERE cast(a.sogi_ncorr as varchar)='"&v_solicitud&"'"

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888									
		IF CInt(v_BOLETA)  =1 THEN
		
			'sql_detalle_tipo_gasto="select a.tgas_ccod, a.dorc_nprecio_neto as tgva_mmonto, b.tgas_cod_cuenta as tgva_tcuenta_contable "&_
			'						" from ocag_detalle_solicitud_ag a "&_
			'						" INNER JOIN ocag_tipo_gasto b "&_
			'						" ON sogi_ncorr = "&v_solicitud&"   "&_
			'						" and a.tgas_ccod=b.tgas_ccod  "		
									
			'sql_detalle_tipo_gasto="select a.tgas_ccod, a.dorc_nprecio_neto - CAST((a.dorc_nprecio_neto*0.1) AS INT) as tgva_mmonto, b.tgas_cod_cuenta as tgva_tcuenta_contable "&_
			'						" from ocag_detalle_solicitud_ag a "&_
			'						" INNER JOIN ocag_tipo_gasto b "&_
			'						" ON sogi_ncorr = "&v_solicitud&"   "&_
			'						" and a.tgas_ccod=b.tgas_ccod  "		
			
			'88888888888888888888888888888
			'DETALLE CUENTAS CONTABLES
			'88888888888888888888888888888
			sql_detalle_tipo_gasto="select a.tgas_ccod "&_
									" , CASE WHEN a.dorc_bafecta=1 THEN MAX(a.dorc_nprecio_neto) "&_
  									" ELSE MAX(a.dorc_nprecio_neto)- CAST((MAX(a.dorc_nprecio_neto)*0.1) AS INT) END tgva_mmonto "&_
									" , b.tgas_cod_cuenta as tgva_tcuenta_contable "&_
									" from ocag_detalle_solicitud_ag a "&_
									" INNER JOIN ocag_tipo_gasto b "&_
									" ON sogi_ncorr = "&v_solicitud&"   "&_
									" and a.tgas_ccod=b.tgas_ccod  "&_	
									" GROUP BY a.tgas_ccod, a.dorc_bafecta, b.tgas_cod_cuenta "
									
		ELSE
			sql_detalle_tipo_gasto="select a.tgas_ccod, case when dorc_bafecta=1 then cast((dorc_nprecio_neto)*1.19 as numeric)  else dorc_nprecio_neto end as tgva_mmonto,tgas_cod_cuenta as tgva_tcuenta_contable  "&_
									" from ocag_detalle_solicitud_ag a, ocag_tipo_gasto b    "&_
									" where sogi_ncorr = "&v_solicitud&"   "&_
									" and a.tgas_ccod=b.tgas_ccod "
	
		END IF
'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
		
		Case 2:
		' REEMBOLSO DE GASTOS
									
'			sql_detalle_tipo_gasto=" select a.tgas_ccod, (a.drga_mdocto + a.drga_mretencion) as tgva_mmonto,tgas_cod_cuenta as tgva_tcuenta_contable "&_
'									" from ocag_detalle_reembolso_gasto a, ocag_tipo_gasto b "&_  
'									" where rgas_ncorr = "&v_solicitud&"  "&_
'									" and a.tgas_ccod=b.tgas_ccod "
									
			sql_detalle_tipo_gasto="  select a.tgas_ccod , case when a.drga_bboleta_honorario=1 then a.drga_mhonorarios else a.drga_mdocto end as tgva_mmonto "&_ 
									" , tgas_cod_cuenta as tgva_tcuenta_contable  "&_ 
									" from ocag_detalle_reembolso_gasto a, ocag_tipo_gasto b   "&_ 
									" where rgas_ncorr = "&v_solicitud&"  "&_ 
									" and a.tgas_ccod=b.tgas_ccod  "

		Case 5:
		' DEVOLUCION ALUMNO

'			sql_detalle_tipo_gasto=" select b.tgas_ccod, dalu_mmonto_pesos as tgva_mmonto,b.tgas_cod_cuenta as tgva_tcuenta_contable "&_
'									"  from ocag_devolucion_alumno a, ocag_tipo_devolucion b, ocag_tipo_gasto c  "&_
'									"  where dalu_ncorr =  "&v_solicitud&"  "&_
'									"  and a.tdev_ccod=b.tdev_ccod   "&_
'									"  and b.tgas_ccod=c.tgas_ccod  "
									
			sql_detalle_tipo_gasto=" select c.tgas_ccod "&_
									" , a.dalu_mmonto_pesos as tgva_mmonto "&_
									" , b.tgas_cod_cuenta as tgva_tcuenta_contable "&_
									" from ocag_devolucion_alumno a "&_
									" INNER JOIN ocag_tipo_devolucion b "&_
									" ON a.tdev_ccod = b.tdev_ccod AND a.dalu_ncorr = "&v_solicitud&"  "&_
									" INNER JOIN ocag_tipo_gasto c "&_
									" on b.tgas_cod_cuenta=c.tgas_cod_cuenta and b.tdev_tdesc = c.tgas_tdesc "

		Case else:
		' FONDO A RENDIR
		' SOLICITUD DE VIATICO
		' NUEVO FONDO FIJO
		' RENDICION DE FONDO A RENDIR
		' RENDICION DE FONDO FIJO
		' ORDENES DE COMPRA
		
			sql_detalle_tipo_gasto="select cast("&v_monto&" as numeric) as  tgva_mmonto "
	end select   


end if

'RESPONSE.WRITE("3. sql_detalle_tipo_gasto : "&sql_detalle_tipo_gasto&"<BR>")
'RESPONSE.WRITE("3. v_tipo : "&v_tipo&"<BR>")
'RESPONSE.WRITE("pago_boleta : "&pago_boleta&"<BR>")
	
'888888888888888888888888888888888888888888888888888888888888888888888888

'IF v_tipo = 1 THEN
IF CInt(v_tipo)=1 THEN

	detalle_022= conectar.consultaUno (pago_boleta)
	
	IF detalle_022 = "0" THEN
		f_detalle_tg.Consultar sql_detalle_tipo_gasto
	ELSE
	
'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888									
		IF CInt(v_BOLETA)  = 1 THEN

		'sql_detalle_02="select DISTINCT a.tgas_ccod "&_
		'			" , a.dorc_nprecio_neto as tgva_mmonto "&_
		'			" , d.tgas_cod_cuenta as tgva_tcuenta_contable "&_
		'			" from ocag_detalle_orden_compra a "&_
		'			" INNER JOIN ocag_solicitud_giro b "&_
		'			" on a.ordc_ncorr = b.ordc_ncorr AND cast(a.ordc_ncorr as varchar)= '" &detalle_022& "' AND b.sogi_ncorr='"&v_solicitud&"' "&_
		'			" INNER JOIN ocag_tipo_gasto d "&_
		'			" ON a.tgas_ccod=d.tgas_ccod  "

			'88888888888888888888888888888
			'DETALLE CUENTAS CONTABLES
			'88888888888888888888888888888
			
		sql_detalle_02=" select DISTINCT a.tgas_ccod, CASE WHEN b.sogi_bboleta_honorario = 1  "&_
					" THEN a.dorc_nprecio_neto - CAST(ROUND((a.dorc_nprecio_neto*0.1),0) AS INT) "&_
					" ELSE a.dorc_nprecio_neto END as tgva_mmonto  "&_
					" , d.tgas_cod_cuenta as tgva_tcuenta_contable "&_
					" from ocag_detalle_orden_compra a "&_
					" INNER JOIN ocag_solicitud_giro b "&_
					" on a.ordc_ncorr = b.ordc_ncorr AND cast(a.ordc_ncorr as varchar)= '" &detalle_022& "' AND b.sogi_ncorr='"&v_solicitud&"' "&_
					" INNER JOIN ocag_tipo_gasto d "&_
					" ON a.tgas_ccod=d.tgas_ccod  "

		ELSE
		
			'88888888888888888888888888888
			'DETALLE CUENTAS CONTABLES
			'88888888888888888888888888888
			
		sql_detalle_02="select DISTINCT a.tgas_ccod "&_
					" , case when a.dorc_bafecta=1 then cast((a.dorc_nprecio_neto)*1.19 as numeric) else a.dorc_nprecio_neto end as tgva_mmonto "&_
					" , d.tgas_cod_cuenta as tgva_tcuenta_contable "&_
					" from ocag_detalle_orden_compra a "&_
					" INNER JOIN ocag_solicitud_giro b "&_
					" on a.ordc_ncorr = b.ordc_ncorr AND cast(a.ordc_ncorr as varchar)= '" &detalle_022& "' AND b.sogi_ncorr='"&v_solicitud&"' "&_
					" INNER JOIN ocag_tipo_gasto d "&_
					" ON a.tgas_ccod=d.tgas_ccod  "
		END IF
'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

		'RESPONSE.WRITE("sql_detalle_02 CUARTO: "&sql_detalle_02&"<BR>")

		f_detalle_tg.Consultar sql_detalle_02
	END IF
	
ELSE
'888888888888888888888888888888888888888888888888888888888888888888888888

f_detalle_tg.Consultar sql_detalle_tipo_gasto

END IF
'888888888888888888888888888888888888888888888888888888888888888888888888

	Select Case v_tipo
		Case 3: 'FONDOR A RENDIR
			f_detalle_tg.AgregaCampoParam "tgas_ccod", "filtro", "tgas_ccod in (1)"
			filtro_tipo="where tgas_ccod in (1)"
			if v_vcon_ncorr="" or EsVacio(v_vcon_ncorr) then
				f_detalle_tg.agregaCampoCons "tgva_tcuenta_contable", "1-10-060-10-000002"
			end if
			v_bloquea=true
		Case 4: 'VIATICOS
			f_detalle_tg.AgregaCampoParam "tgas_ccod", "filtro", "tgas_ccod in (45)"
			filtro_tipo="where tgas_ccod in (45)"
			if v_vcon_ncorr="" or EsVacio(v_vcon_ncorr) then
				f_detalle_tg.agregaCampoCons "tgva_tcuenta_contable", "1-10-010-20-000003"
			end if
			v_bloquea=true
		
		Case 5:	'DEVOLUCION
			f_detalle_tg.AgregaCampoParam "tgas_ccod", "filtro", "tgas_ccod in (158)"
			filtro_tipo="where tgas_ccod in (158)"
			if v_vcon_ncorr="" or EsVacio(v_vcon_ncorr) then
				'f_detalle_tg.agregaCampoCons "tgva_tcuenta_contable", "5-30-020-10-002022"'
				f_detalle_tg.agregaCampoCons "tgva_tcuenta_contable", "2-10-070-15-000001"
			end if
			v_bloquea=true
			
		Case 6: 'FONDO FIJO
			f_detalle_tg.AgregaCampoParam "tgas_ccod", "filtro", "tgas_ccod in (2)"
			filtro_tipo="where tgas_ccod in (2)"
			if v_vcon_ncorr="" or EsVacio(v_vcon_ncorr) then
				'f_detalle_tg.agregaCampoCons "tgva_tcuenta_contable", "2-10-070-15-000001"
				f_detalle_tg.agregaCampoCons "tgva_tcuenta_contable", "1-10-010-20-000003"
			end if
			v_bloquea=true
		Case else:
		
		'response.write("ENTRO AQUI")
		
			f_detalle_tg.AgregaCampoParam "tgas_ccod", "filtro", "tgas_ccod not in (1,2,45,158)"
			filtro_tipo="where tgas_ccod not in (1,2,45,158)"
			v_bloquea=false				
	end select
	

'##################################################################
'########### DESGLOSE DE VALIDACION CONTABLE	###################
' JAIME PAINEMAL 20130702
 
 'DETALLE TIPO DE GASTOS (Cuentas Contables)
set f_detalle_tg_0 = new CFormulario
f_detalle_tg_0.Carga_Parametros "validacion_contable.xml", "busqueda"
f_detalle_tg_0.Inicializar conectar

'f_detalle_tg_0.Consultar "select ''"

sql_detalle_tipo_0 = " select DISTINCT tgas_ccod, tgas_tdesc, tgas_ccod AS tgas_ccod_02, tgas_cod_cuenta from ocag_tipo_gasto "&filtro_tipo

'RESPONSE.WRITE("sql_detalle_tipo_0: "&sql_detalle_tipo_0&"<BR>")

f_detalle_tg_0.Consultar sql_detalle_tipo_0
									
'f_detalle_tg_0.InicializaListaDependiente "busqueda", sql_detalle_tipo_0

 '##################################################################


' DETALLE CENTRO DE COSTOS
 set f_detalle_cc = new CFormulario
 f_detalle_cc.Carga_Parametros "validacion_contable.xml", "detalle_costos"
 f_detalle_cc.Inicializar conectar

 if v_vcon_ncorr<> "" then
	 sql_centro_costo="select * from ocag_centro_costo_validacion where vcon_ncorr="&v_vcon_ncorr
 else
 	if v_tipo=1 then
	
		'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888									
		IF CInt(v_BOLETA)  = 1 THEN
			
			'sql_centro_costo="select ccos_ncorr, dorc_nprecio_neto as ccva_mmonto from ocag_detalle_solicitud_ag where cod_solicitud ="&v_solicitud	
			
			'sql_centro_costo="select ccos_ncorr, dorc_nprecio_neto - CAST((dorc_nprecio_neto*0.1) AS INT) as ccva_mmonto from ocag_detalle_solicitud_ag where cod_solicitud ="&v_solicitud	
			
			sql_centro_costo=" select ccos_ncorr, CASE WHEN dorc_bafecta= 1  "&_
									" THEN MAX(dorc_nprecio_neto) - CAST(ROUND((MAX(dorc_nprecio_neto)*0.1),0) AS INT) "&_
									" ELSE MAX(dorc_nprecio_neto) END as ccva_mmonto  "&_
									" from ocag_detalle_solicitud_ag  "&_
									" where cod_solicitud ="&v_solicitud&" "&_
									" GROUP BY ccos_ncorr, dorc_bafecta, dorc_nprecio_neto "
			
		ELSE
			sql_centro_costo="select ccos_ncorr,case when dorc_bafecta=1 then cast((dorc_nprecio_neto)*1.19 as numeric)  else dorc_nprecio_neto end as ccva_mmonto from ocag_detalle_solicitud_ag where cod_solicitud="&v_solicitud
		END IF
		'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

	else
		sql_centro_costo="select cast("&v_monto&" as numeric) as ccva_mmonto "
	end if
	 
 end if
 
 'response.Write("3 ACA. sql_centro_costo : "&sql_centro_costo&"<br>")

'888888888888888888888888888888888888888888888

IF v_tipo = 1 THEN

	IF detalle_022 = "0" THEN
		f_detalle_cc.Consultar sql_centro_costo
	ELSE
	
		IF CInt(v_BOLETA)  = 1 THEN
		
		'DETALLE DISTRIBUCION CENTROS DE COSTOS
		
		sql_detalle_02=" SELECT ccos_ncorr, CASE WHEN dorc_bafecta= 1  "&_
						" THEN dorc_nprecio_neto - CAST( ROUND(( (dorc_nprecio_neto)*0.1),0) AS INT)  "&_
						" ELSE dorc_nprecio_neto  END as ccva_mmonto  "&_
						" from ocag_detalle_orden_compra  "&_
						" where cast(ordc_ncorr as varchar)= '"&detalle_022&"'"

		ELSE
		sql_detalle_02="select ccos_ncorr "&_
						" ,case when dorc_bafecta=1 then cast((dorc_nprecio_neto)*1.19 as numeric) else dorc_nprecio_neto end as ccva_mmonto "&_
						" from ocag_detalle_orden_compra  "&_
						" where cast(ordc_ncorr as varchar)= '"&detalle_022&"'"
		END IF
						
		'RESPONSE.WRITE("3. sql_detalle_02 TRES : "&sql_detalle_02&"<BR>")
			
		f_detalle_cc.Consultar sql_detalle_02
	END IF

ELSE
'888888888888888888888888888888888888888888888
 
 f_detalle_cc.Consultar sql_centro_costo
 
END IF
'888888888888888888888888888888888888888888888

 ' DETALLE DE PAGOS Y FECHAS
 set f_detalle = new CFormulario
 f_detalle.Carga_Parametros "validacion_contable.xml", "detalle_pago"
 f_detalle.Inicializar conectar
 
'RESPONSE.WRITE("v_vcon_ncorr: "&v_vcon_ncorr&"<BR>")
'RESPONSE.WRITE("v_tipo: "&v_tipo&"<BR>")

 if v_vcon_ncorr<> "" then
		' SEGUNADA O MAS VALIDACIONES CONTABLES 
	 'sql_detalle_pago="select protic.trunc(dpva_fpago) as dpva_fpago,dpva_mdetalle from ocag_detalle_pago_validacion where vcon_ncorr="&v_vcon_ncorr
	 
	 sql_detalle_pago="select protic.trunc(protic.ocag_retorna_fecha_normal(ISNULL(dpva_fpago,GETDATE()),"&v_tipo&")) as dpva_fpago,dpva_mdetalle from ocag_detalle_pago_validacion where vcon_ncorr="&v_vcon_ncorr
	 
	'RESPONSE.WRITE("1 : <BR>")
 else
	 if v_tipo<>"" then
		
		'CUANDO ES LA PRIMERA VALIDACION CONTABLE
	 	sql_detalle_pago="select protic.trunc(protic.ocag_retorna_fecha_normal('"&v_fecha_presupuesto&"',"&v_tipo&")) as dpva_fpago,cast("&v_monto&" as numeric) as dpva_mdetalle "
		
		'RESPONSE.WRITE("2 : <BR>")
		 
	 else
		'PRIMERA QUERY, SE CARGA INMEDIATAMENTE ANTES DE BUSCAR.
		sql_detalle_pago="select protic.trunc(getdate()) as dpva_fpago,0 as dpva_mdetalle "
		
		'RESPONSE.WRITE("3 : <BR>")
	 end if
 end if
 
'RESPONSE.WRITE("1. sql_detalle_pago : "&sql_detalle_pago&"<BR>")
 
 f_detalle.Consultar sql_detalle_pago
'#####################################################3

'response.Write(sql_detalle_pago)

 set f_buscador = new CFormulario
 f_buscador.Carga_Parametros "validacion_contable.xml", "buscador"
 f_buscador.Inicializar conectar
 f_buscador.Consultar " select '' "
 f_buscador.Siguiente

f_buscador.agregaCampoCons "solicitud", v_solicitud
f_buscador.agregaCampoCons "tsol_ccod", v_tipo
f_buscador.agregaCampoCons "anos_ccod", v_anos

if v_vcon_ncorr="" and request.querystring()<> "" then
	msg_error="No existen registros asociados a la solicitud ingresada"
end if
'#######################################################

set f_centro_costo = new CFormulario
f_centro_costo.carga_parametros "validacion_contable.xml", "centro_costo"
f_centro_costo.inicializar conectar
	sql_centro_costo= "select '['+ccos_tcodigo+']-'+ccos_tdesc as centro_costo,* from ocag_centro_costo"
f_centro_costo.consultar sql_centro_costo
f_centro_costo.siguiente

set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "validacion_contable.xml", "centro_costo"
f_tipo_gasto.inicializar conectar
	sql_tipo_gasto= "select * from ocag_tipo_gasto "&filtro_tipo
f_tipo_gasto.consultar sql_tipo_gasto
f_tipo_gasto.siguiente		

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

consulta_carreras = "select DISTINCT tgas_ccod, tgas_tdesc, tgas_ccod AS tgas_ccod_02, tgas_cod_cuenta from ocag_tipo_gasto "&filtro_tipo

conexion.Ejecuta consulta_carreras

set rec_carreras = conexion.ObtenerRS

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>

<script language="JavaScript">

//88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

arr_carreras = new Array();

<%
rec_carreras.MoveFirst
i = 0
while not rec_carreras.Eof
%>
arr_carreras[<%=i%>] = new Array();
arr_carreras[<%=i%>]["tgas_ccod"] = '<%=rec_carreras("tgas_ccod")%>';
arr_carreras[<%=i%>]["tgas_cod_cuenta"] = '<%=rec_carreras("tgas_cod_cuenta")%>';
<%	
	rec_carreras.MoveNext
	i = i + 1
wend
%>


function Cargar_codigos_20130808(formulario, tgas_ccod)
{
		formulario.elements["busqueda[0][tgas_cod_cuenta]"].length = 0;

		for (i = 0; i < arr_carreras.length; i++)
		{ 
			if (arr_carreras[i]["tgas_ccod"] == tgas_ccod)
			 {
				op = document.createElement("OPTION");
				op.value = arr_carreras[i]["tgas_cod_cuenta"];
				op.text = arr_carreras[i]["tgas_cod_cuenta"];
				formulario.elements["busqueda[0][tgas_cod_cuenta]"].add(op)
			 }
		}
}

function Cargar_codigos(formulario, tgas_ccod, num)
{
		formulario.elements["busqueda["+num+"][tgas_cod_cuenta]"].length = 0;

		for (i = 0; i < arr_carreras.length; i++)
		{ 
			if (arr_carreras[i]["tgas_ccod"] == tgas_ccod)
			 {
				op = arr_carreras[i]["tgas_cod_cuenta"];
				formulario.elements["busqueda["+num+"][tgas_cod_cuenta]"].value=op;
			   
			 }
		}
}

//88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

function CopiaNombre(){
	var formulario = document.forms["datos"];
	formulario.pers_nrut.value=formulario.elements["datos[0][pers_nrut]"].value;
	formulario.pers_xdv.value=formulario.elements["datos[0][pers_xdv]"].value;
	formulario.funcionario.value=formulario.elements["datos[0][pers_tnombre]"].value;
}

function Enviar(){
	//validar campos vacios
	formulario = document.datos;
	v_valor			= formulario.elements["monto_solicitud"].value; // TOTAL DE LA SOLICITUD A VALIDAR
	v_total_centro_costo	= formulario.total_centro_costo.value;	
	v_total_detalle_pago	= formulario.total_detalle_pago.value;	
	v_total_tipo_gasto		= formulario.total_tipo_gasto.value;		
		
	for( y = 0; y < 2; y++ ){
		if (document.forms["datos"].elements["datos[0][aprueba]"][y].checked){
			aprueba					= document.forms["datos"].elements["datos[0][aprueba]"][y].value;
		}
	}
	if (aprueba == 2){ // Rechaza Solicitud
		//-----------Carga email de Responsable desde BD, condiciona si el correo es el correcto, si no da opción de ingreso. Rpavez 06/05/2014	
		if (document.datos.elements["email"].value.length<5) {
			email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
		}
		else{
			if (confirm("Se enviara un correo a: " + document.datos.elements["email"].value)){
				email=document.datos.elements["email"].value;
			}
			else{
				email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
			}
		}
		var re  = /^([a-zA-Z0-9_.-])+@((upacifico)+.)+(cl)+$/; 
		if (!re.test(email)) { 
			alert ("Dirección de email inválida"); 
			return false; 
		} 
		if((email != "")&&(email != null)){
			window.open("http://admision.upacifico.cl/postulacion/www/proc_rechazo_presupuesto.php?proveedor="+v_valor+"&tsol_tcodigo="+v_valor+"&monto="+v_valor+"&correo="+email);
			return true;
		}
		else{
			alert("Debe Ingresar un Correo Electronico.");
			return false;	
		}
		
//-------------------------------------	
	}else{ // Aprueba Solicitud
		if((v_valor==v_total_centro_costo)&&(v_valor==v_total_detalle_pago)&&(v_valor==v_total_tipo_gasto)){
			return true;
		}else{
			//alert("v_valor: "+v_valor+" v_total_centro_costo: "+v_total_centro_costo);
			alert("Los montos deben coincidir con el total de la solicitud autorizado");
			return false;
		}
	return false;
	}
	
	return true;
}

function VerAsientos(){
	cod_solicitud	='<%=v_solicitud%>';
	tipo_solicitud	='<%=v_tipo%>';
	tipo_boleta	='<%=v_BOLETA%>';
	url="ver_asientos.asp?cod_solicitud="+cod_solicitud+"&tsol_ccod="+tipo_solicitud+"&t_boleta="+tipo_boleta;
	window.open(url,"VerAsiento","scrollbars=yes, menubar=no, resizable=yes, width=740,height=400");
}

function SumaCentroCosto(valor){
	var formulario = document.forms["datos"];
	v_total_cc = 0;
	for (var i = 0; i <= contador; i++) {
		//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
		if (formulario.elements["centro_costo["+i+"][ccva_mmonto]"]){
			v_total_cc = parseInt(v_total_cc) + parseInt(formulario.elements["centro_costo["+i+"][ccva_mmonto]"].value);
		}
	}
	datos.elements["total_centro_costo"].value=v_total_cc;
}

function SumaDetallePago(valor){
	var formulario = document.forms["datos"];
	v_total_dp = 0;
	for (var i = 0; i <= contador2; i++) {
		if (formulario.elements["detalle_pago["+i+"][dpva_mdetalle]"]){
			v_total_dp = parseInt(v_total_dp) + parseInt(formulario.elements["detalle_pago["+i+"][dpva_mdetalle]"].value);
		}
	}
	datos.elements["total_detalle_pago"].value=v_total_dp;
}

function SumaTipoGasto(valor){
	var formulario = document.forms["datos"];
	v_total_tg = 0;
	for (var i = 0; i <= contador3; i++) {
		if (formulario.elements["tipo_gasto["+i+"][tgva_mmonto]"]){
			v_total_tg = parseInt(v_total_tg) + parseInt(formulario.elements["tipo_gasto["+i+"][tgva_mmonto]"].value);
		}
	}
	datos.elements["total_tipo_gasto"].value=v_total_tg;
}

function CambiaValor(obj){
	v_name=obj.name;
	v_valor=obj.value;
	v_indice=extrae_indice(v_name);
	if (v_valor==2){
		document.datos.elements["datos["+v_indice+"][vcon_tmotivo_rechazo]"].disabled=false;
		document.datos.elements["datos["+v_indice+"][vcon_tmotivo_rechazo]"].value="";
	}else{
		document.datos.elements["datos["+v_indice+"][vcon_tmotivo_rechazo]"].disabled=true;
	}	
}

/*****************************************************************************/
/*// PRIMERA TABLA DINAMICA //  centro_costo */
<%if cint(f_detalle_cc.nrofilas) >1 then%>
var contador=<%=f_detalle_cc.nrofilas-1%>;
<%else%>
var contador=0;
<%end if%>


function validaFila(id, nro,boton)
{
	if (document.datos.elements["centro_costo["+nro+"][ccva_mmonto]"].value != '')
	  {addRow(id, nro, boton );habilitaUltimoBoton();}
     else
      {alert('Debe completar el valor del centro de costo para continuar');}

//addRow(id, nro, boton );bloqueaFila(nro);
}

function eliminaFilas()
{
var check=document.datos.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
var tabla = document.getElementById('tb_busqueda_costos');

 for (y=0;y<check.length;y++){if (check[y].type=="checkbox"){checkbox[cantidadCheck++]=check[y];}}
	for (x=0;x<cantidadCheck;x++){
		  if (checkbox[x].checked) {deleterow(checkbox[x]);}
	 }
 if (tabla.tBodies[0].rows.length < 2)
    {addRow('tb_busqueda_costos', cantidadCheck, 0 );}

 habilitaUltimoBoton();

}

function habilitaUltimoBoton()
{
var objetos=document.datos.getElementsByTagName('input');
var cantidadBoton=0;
var botones=new Array();

 for (y=0;y<objetos.length;y++){
	 if (objetos[y].type=="button" && objetos[y].name=="agregarlinea"){
	 	cantidadBoton=cantidadBoton+1;
		botones[cantidadBoton]=objetos[y];
		botones[cantidadBoton].disabled=true;
	 }
 }
	botones[cantidadBoton].disabled=false;
	//alert("cantidad "+cantidadBoton);
	if(cantidadBoton>=10){
		botones[cantidadBoton].disabled=true;
	}
}

function addRow(id, nro, boton ){
	/*
	contador= contador + 1;
	var tbody = document.getElementById(id).getElementsByTagName("TBODY")[0];
	var row = document.createElement("TR");
	row.align="center";
	
	//********Nro de detalle********************
	var td1 = document.createElement("TD");
	var aElement=document.createElement("<INPUT TYPE=\"checkbox\" name=\"check\" value=\""+ contador +"\"  >");
	td1.appendChild (aElement);
	
	//********ccos_ncorr********************
	var td2 = document.createElement("TD");
	var iElement=document.createElement("select");
	iElement.name="centro_costo["+ contador +"][ccos_ncorr]";
	i=0;
	<%	
	f_centro_costo.primero
	while f_centro_costo.Siguiente %>
	valor_select='[<%=f_centro_costo.ObtenerValor("ccos_tcodigo")%>]-<%=f_centro_costo.ObtenerValor("ccos_tdesc")%>';
	i=i+1;
		var v_option=document.createElement("Option");
		v_option.value='<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>';// Valor del option
		v_option.innerHTML=valor_select; // texto del option
		iElement.appendChild(v_option);	
	<%wend%>
	td2.appendChild (iElement)
	
	//********ccos_mmonto********************
	var td3 = document.createElement("TD");
	var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"centro_costo["+ contador +"][ccva_mmonto]\" onBlur=\"SumaCentroCosto(this);\" size=\"20\" >");
	td3.appendChild (iElement)
	
	//********Agregar********************
	var td4 		= 	document.createElement("TD");
	var iElement 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"agregarlinea\" value=\"+\" onclick=\"validaFila('tb_busqueda_costos',"+contador+",this)\">");
	var iElement2 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"quitarlinea\" value=\"-\" onclick=\"eliminaFilas()\">");
	td4.appendChild (iElement)
	td4.appendChild (iElement2)
	
	
	row.appendChild(td1);
	row.appendChild(td2);
	row.appendChild(td3);
	row.appendChild(td4);
	tbody.appendChild(row);	*/
	
	
	contador++;
$("#tb_busqueda_costos").append("<tr><td align=\"center\"><INPUT TYPE=\"checkbox\" name=\"check\" value=\""+ contador +"\"  ></td>"+
"<td align=\"center\"><select name= \"centro_costo["+ contador +"][ccos_ncorr]\">"+
"<%f_centro_costo.primero%> "+
"<%while f_centro_costo.Siguiente %>"+
"<option value=\"<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>\" >[<%=f_centro_costo.ObtenerValor("ccos_tcodigo")%>]-<%=f_centro_costo.ObtenerValor("ccos_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td align=\"center\"><INPUT TYPE=\"text\" name=\"centro_costo["+ contador +"][ccva_mmonto]\" onBlur=\"SumaCentroCosto(this);\" size=\"20\" ></td>"+
"<td align=\"center\"><INPUT class=boton TYPE=\"button\" name=\"agregarlinea\" value=\"+\" onclick=\"validaFila('tb_busqueda_costos',"+contador+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea\" value=\"-\" onclick=\"eliminaFilas()\"></td></tr>");
	
document.datos.elements["contador"].value = contador;
}

function deleterow(node) {
	var tr = node.parentNode;
	while (tr.tagName.toLowerCase() != "tr")
	tr = tr.parentNode;
	tr.parentNode.removeChild(tr);
}
//******* FIN PRIMERA TABLA DINAMICA *******//
/*****************************************************************************/



/*****************************************************************************/
/*// SEGUNDA TABLA DINAMICA //*/
<%if cint(f_detalle.nrofilas) >1 then%>
var contador2=<%=f_detalle.nrofilas-1%>;
<%else%>
var contador2=0;
<%end if%>

function validaFila2(id, nro,boton)
{
	if ((document.datos.elements["detalle_pago["+nro+"][dpva_fpago]"].value != '')||(document.datos.elements["detalle_pago["+nro+"][dpva_mdetalle]"].value != ''))
	  {addRow2(id, nro, boton );habilitaUltimoBoton2();}
     else
      {alert('Debe completar el valor de la fecha de pago y monto para continuar');}

//addRow(id, nro, boton );bloqueaFila(nro);
}

function eliminaFilas2()
{
var check=document.datos.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
var tabla2 = document.getElementById('tb_busqueda_detalle');

 for (y=0;y<check.length;y++){if (check[y].type=="checkbox"){checkbox[cantidadCheck++]=check[y];}}
	for (x=0;x<cantidadCheck;x++){
		  if (checkbox[x].checked) {deleterow2(checkbox[x]);}
	 }
 if (tabla2.tBodies[0].rows.length < 2)
    {addRow2('tb_busqueda_detalle', cantidadCheck, 0 );}

 habilitaUltimoBoton2();

}

function habilitaUltimoBoton2()
{
var objetos2=document.datos.getElementsByTagName('input');
var cantidadBoton=0;
var botones2=new Array();

 for (y=0;y<objetos2.length;y++){
	 if (objetos2[y].type=="button" && objetos2[y].name=="agregarlinea2"){
	 	cantidadBoton=cantidadBoton+1;
		botones2[cantidadBoton]=objetos2[y];
		botones2[cantidadBoton].disabled=true;
	 }
 }
	botones2[cantidadBoton].disabled=false;
	//alert("cantidad "+cantidadBoton);
	if(cantidadBoton>=10){
		botones2[cantidadBoton].disabled=true;
	}
}

function addRow2(id, nro, boton ){
	/*
	contador2= contador2 + 1;
	var tbody2 = document.getElementById(id).getElementsByTagName("TBODY")[0];
	var row2 = document.createElement("TR");
	row2.align="center";
	
	//********Nro de detalle********************
	var tdv1 = document.createElement("TD");
	var vaElement=document.createElement("<INPUT TYPE=\"checkbox\" name=\"check\" value=\""+ contador2 +"\"  >");
	tdv1.appendChild (vaElement);

	
	//********dpva_fpago********************
	var tdv2 = document.createElement("TD");
	var viElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle_pago["+ contador2 +"][dpva_fpago]\" size=\"20\" >");
	tdv2.appendChild (viElement)

	
	//********dpva_mdetalle********************
	var tdv3 = document.createElement("TD");
	var viElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle_pago["+ contador2 +"][dpva_mdetalle]\" onBlur=\"SumaDetallePago(this);\" size=\"20\" >");
	tdv3.appendChild (viElement)
	
	//********Agregar********************
	var tdv4 		= 	document.createElement("TD");
	var viElement 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"agregarlinea2\" value=\"+\" onclick=\"validaFila2('tb_busqueda_detalle',"+contador2+",this)\">");
	var viElement2 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"quitarlinea2\" value=\"-\" onclick=\"eliminaFilas2()\">");
	tdv4.appendChild (viElement)
	tdv4.appendChild (viElement2)
	
	
	row2.appendChild(tdv1);
	row2.appendChild(tdv2);
	row2.appendChild(tdv3);
	row2.appendChild(tdv4);
	tbody2.appendChild(row2);	*/
	
		contador2++;
$("#tb_busqueda_detalle").append("<tr><td align=\"center\"><INPUT TYPE=\"checkbox\" name=\"check\" value=\""+ contador2 +"\"  >"+
"<td align=\"center\"><INPUT TYPE=\"text\" name=\"detalle_pago["+ contador2 +"][dpva_fpago]\" size=\"20\" ></td>"+
"<td align=\"center\"><INPUT TYPE=\"text\" name=\"detalle_pago["+ contador2 +"][dpva_mdetalle]\" onBlur=\"SumaDetallePago(this);\" size=\"20\" ></td>"+
"<td align=\"center\"><INPUT class=boton TYPE=\"button\" name=\"agregarlinea2\" value=\"+\" onclick=\"validaFila2('tb_busqueda_detalle',"+contador2+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea2\" value=\"-\" onclick=\"eliminaFilas2()\"></td></tr>");

document.datos.elements["contador2"].value = contador2;
}

function deleterow2(node) {
	var tr2 = node.parentNode;
	while (tr2.tagName.toLowerCase() != "tr")
	tr2 = tr2.parentNode;
	tr2.parentNode.removeChild(tr2);
}
//******* FIN SEGUNDA TABLA DINAMICA *******//
/*****************************************************************************/


/*****************************************************************************/
/*// TERCERA TABLA DINAMICA //*/
<%if cint(f_detalle_tg.nrofilas) >1 then%>
var contador3=<%=f_detalle_tg.nrofilas-1%>;
<%else%>
var contador3=0;
<%end if%>

function validaFila3(id, nro,boton)
{
	if ((document.datos.elements["tipo_gasto["+nro+"][tgva_mmonto]"].value != ''))
	  {addRow3(id, nro, boton );habilitaUltimoBoton3();}
     else
      {alert('Debe completar el monto para continuar');}

//addRow(id, nro, boton );bloqueaFila(nro);
}

function eliminaFilas3()
{
var check=document.datos.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
var tabla3 = document.getElementById('tb_busqueda_tipo_gasto');

 for (y=0;y<check.length;y++){if (check[y].type=="checkbox"){checkbox[cantidadCheck++]=check[y];}}
	for (x=0;x<cantidadCheck;x++){
		  if (checkbox[x].checked) {deleterow3(checkbox[x]);}
	 }
 if (tabla3.tBodies[0].rows.length < 2)
    {addRow3('tb_busqueda_tipo_gasto', cantidadCheck, 0 );}

 habilitaUltimoBoton3();

}

function habilitaUltimoBoton3()
{
var objetos3=document.datos.getElementsByTagName('input');
var cantidadBoton=0;
var botones3=new Array();

 for (y=0;y<objetos3.length;y++){
	 if (objetos3[y].type=="button" && objetos3[y].name=="agregarlinea3"){
	 	cantidadBoton=cantidadBoton+1;
		botones3[cantidadBoton]=objetos3[y];
		botones3[cantidadBoton].disabled=true;
	 }
 }
	botones3[cantidadBoton].disabled=false;
	//alert("cantidad "+cantidadBoton);
	if(cantidadBoton>=10){
		botones3[cantidadBoton].disabled=true;
	}
}

function addRow3(id, nro, boton ){
	/*
	contador3= contador3 + 1;
	var tbody3 = document.getElementById(id).getElementsByTagName("TBODY")[0];
	var row3 = document.createElement("TR");
	row3.align="center";
	
	//********Nro de detalle********************
	var tdg1 = document.createElement("TD");
	var vaElement=document.createElement("<INPUT TYPE=\"checkbox\" name=\"check\" value=\""+ contador3 +"\"  >");
	tdg1.appendChild (vaElement);


//********ccos_ncorr********************
	var tdg2 = document.createElement("TD");
	var iElement=document.createElement("select");
	iElement.name="tipo_gasto["+ contador3 +"][tgas_ccod]";
	i=0;
	<%	
	f_tipo_gasto.primero
	while f_tipo_gasto.Siguiente %>
	i=i+1;
		var v_option=document.createElement("Option");
		v_option.value='<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>';// Valor del option
		v_option.innerHTML="<%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%>"; // texto del option
		iElement.appendChild(v_option);	
	<%wend%>
	tdg2.appendChild (iElement)
	
	//********tgva_tcuenta_contable********************
	var tdg3 = document.createElement("TD");
	var viElement=document.createElement("<INPUT TYPE=\"text\" name=\"tipo_gasto["+ contador3 +"][tgva_tcuenta_contable]\" size=\"25\" >");
	tdg3.appendChild (viElement)

	
	//********tgva_mmonto********************
	var tdg4 = document.createElement("TD");
	var viElement=document.createElement("<INPUT TYPE=\"text\" name=\"tipo_gasto["+ contador3 +"][tgva_mmonto]\" onBlur=\"SumaTipoGasto(this)\"; size=\"20\" >");
	tdg4.appendChild (viElement)
	
	//********Agregar********************
	var tdg5 		= 	document.createElement("TD");
	var viElement 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"agregarlinea3\" value=\"+\" onclick=\"validaFila3('tb_busqueda_tipo_gasto',"+contador3+",this)\">");
	var viElement2 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"quitarlinea3\" value=\"-\" onclick=\"eliminaFilas3()\">");
	tdg5.appendChild (viElement)
	tdg5.appendChild (viElement2)
	
	
	row3.appendChild(tdg1);
	row3.appendChild(tdg2);
	row3.appendChild(tdg3);
	row3.appendChild(tdg4);
	row3.appendChild(tdg5);
	tbody3.appendChild(row3);	
*/
		contador3++;
$("#tb_busqueda_tipo_gasto").append("<tr><td align=\"center\"><INPUT TYPE=\"checkbox\" name=\"check\" value=\""+ contador3 +"\"  ></td>"+
"<td align=\"center\"><select name=\"busqueda["+ contador3 +"][TGAS_CCOD]\"  onChange=\"Cargar_codigos(this.form, this.value, "+ contador3 +")\">"+
"<%f_tipo_gasto.primero%> "+
"<%while f_tipo_gasto.Siguiente %>"+
"<option value=\"<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>\" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>"+
"<%wend%>"+
"</select>"+
"</td>"+
"<td align=\"center\"><input type=\"text\" name=\"busqueda["+ contador3 +"][tgas_cod_cuenta]\" value=\"5-30-020-10-000003\">"+
"</td>"+
"<td align=\"center\"><INPUT TYPE=\"text\" name=\"tipo_gasto["+ contador3 +"][tgva_mmonto]\" onBlur=\"SumaTipoGasto(this)\"; size=\"20\" ></td>"+
"<td align=\"center\"><INPUT class=boton TYPE=\"button\" name=\"agregarlinea3\" value=\"+\" onclick=\"validaFila3('tb_busqueda_tipo_gasto',"+contador3+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea3\" value=\"-\" onclick=\"eliminaFilas3()\"></td></tr>");
	
document.datos.elements["contador3"].value = contador3;
}

function deleterow3(node) {
	var tr3 = node.parentNode;
	while (tr3.tagName.toLowerCase() != "tr")
	tr3 = tr3.parentNode;
	tr3.parentNode.removeChild(tr3);
}
//******* FIN TERCERA TABLA DINAMICA *******//
/*****************************************************************************/


function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}


</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td background="../imagenes/top_r1_c2.gif"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Validacion contable</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td background="../imagenes/top_r3_c2.gif"></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
					  <form name="buscador"> 
					  	<table width="100%">
							<tr>
								<td width="17%">Numero Solicitud :</td>
								<td width="18%"><%f_buscador.dibujaCampo("solicitud")%></td>
								<td width="17%">Año :</td>
								<td width="18%"><%f_buscador.dibujaCampo("anos_ccod")%></td>
								<td width="15%">Tipo Solicitud :</td>
							  <td width="20%"><%f_buscador.dibujaCampo("tsol_ccod")%></td>
								
							  <td width="30%" rowspan="2"><%botonera.DibujaBoton "buscar" %></td>
							</tr>
						</table>
					  </form>

					  <form name="datos" method="post">
					  <input type="hidden" value="<%=v_solicitud%>" name="datos[0][cod_solicitud]" />
					  <input type="hidden" value="<%=v_tipo%>" name="datos[0][tsol_ccod]" />
					  <input type="hidden" value="3" name="datos[0][vibo_ccod]" />
					  <input type="hidden" value="<%=f_busqueda.obtenerValor("monto_solicitud")%>" name="monto_solicitud">
                      <input type="hidden" name="contador" value="0"/>
                      <input type="hidden" name="contador2" value="0"/>
                      <input type="hidden" name="contador3" value="0"/><%f_busqueda.dibujaCampo("vcon_ncorr")%>
					  <input name="email" type="hidden" value="<%f_busqueda.DibujaCampo("email")%>"/>
					  <center><font color="#FF0000" size="+1"><%=msg_error%></font></center>
					  
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
					
					<table width="100%" border="1">
                      <tr> 
                        <td width="20%"><strong>Rut</strong> </td>
                        <td width="30%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                        <td width="20%"><strong>Nombre funcionario</strong></td>
                        <td width="30%"><%f_busqueda.dibujaCampo("pers_tnombre")%></td>
                      </tr>
                      <tr>
                        <td><strong>Monto Autorizado</strong> </td>
                        <td><%f_busqueda.dibujaCampo("monto_solicitud")%></td>
                        <td> <strong>Tipo autorizacion </strong></td>
                        <td><%=v_tipo_solicitud%></td>
                      </tr>
                      <tr>
                        <td><strong>Rinde fin de año?</strong></td>
                        <td><%f_busqueda.dibujaBoleano("vcon_brendicion_final")%></td>
						<td><strong>Detalle gasto</strong></td>
                        <td><%f_busqueda.dibujaCampo("detalle_gasto")%></td>
                      </tr>
					  
                      <tr>
						<td><strong>Fecha Recepcion</strong></td>
                        <td><%f_busqueda.dibujaCampo("ocag_frecepcion_presupuesto")%></td>
                        <td><strong>Cond. Pago</strong></td>
                        <td><%
						f_busqueda.agregacampoparam "cpag_ccod","permiso","LECTURA"
						f_busqueda.dibujaCampo("cpag_ccod")
						%></td>
                      </tr>
					  
					  <tr>
                        <td colspan="4"><font color="#0033FF" size="+1" style="text-align:center"> <%if v_tipo=5 then response.write(f_busqueda.ObtenerValor("carrera_alu")) end if%>&nbsp;</font></td>
					  </tr>
                      <tr>
                        <td colspan="4" align="center" bgcolor="#999966"><strong>Detalle distribucion Centros de Costos</strong></td>
					  </tr>
					 <tr>
                        <td colspan="4" align="center" >
							<table width="100%" align="center" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id="tb_busqueda_costos">
								<tr bgcolor='#C4D7FF' bordercolor='#999999'>
									<th></th>
									<th>C. Costo</th>
									<th>Valor</th>
									<th>(+/-)</th>
								</tr>
								
						<%
						valor_1=f_busqueda.ObtenerValor("ccos_ncorr")
						
						'RESPONSE.WRITE("1. valor_1 : "&valor_1&"<BR>")
						if valor_1<>"" then
						f_detalle_cc.AgregaCampoCons "ccos_ncorr", valor_1
						end if
						%>
								<%
								if f_detalle_cc.nrofilas >=1 then
									ind=0
									v_total_centro_costo=0
									while f_detalle_cc.Siguiente %>
													
									<tr align="center">
										<th><input type="checkbox" name="centro_costo[<%=ind%>][checkbox]" value=""></th>
										<td><%f_detalle_cc.DibujaCampo("ccos_ncorr")%></td>
										<td><%f_detalle_cc.DibujaCampo("ccva_mmonto")%> </td>
										<td><INPUT alt="agregar una nueva fila" class=boton TYPE="button" name="agregarlinea" value="+" onClick="validaFila('tb_busqueda_costos','<%=ind%>',this)">&nbsp;<INPUT alt="quitar una fila existente" class=boton TYPE="button" name="quitarlinea" value="-" onClick="eliminaFilas()"></td>							
									</tr>	
									<%
									monto1=f_detalle_cc.ObtenerValor("ccva_mmonto")
									
									'RESPONSE.WRITE("monto1: "&monto1&"<BR>")
									
									if monto1 = ""  then
									monto1=0
									end if
									'v_total_centro_costo=	Clng(v_total_centro_costo)+Clng(f_detalle_cc.ObtenerValor("ccva_mmonto"))
									v_total_centro_costo=	Clng(v_total_centro_costo)+Clng(monto1)
									ind=ind+1

									wend
								 end if%>									
						 </table>
						 </td>
                      </tr>
					 <tr>
					   <td colspan="4" align="center" bgcolor="#999966"><strong>Detalle distribucion fechas y montos de pago</strong></td>
					   </tr>
					 <tr>
						   <td colspan="4" align="center">					
								   <table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id="tb_busqueda_detalle">
											<tr bgcolor='#C4D7FF' bordercolor='#999999'>
											<th></th>
											<th>Fecha Pago</th>
											<th>Monto Pago</th>
											<th>(+/-)</th>
											</tr> 
								<%
								if f_detalle.nrofilas >=1 then
									ind=0
									v_total_detalle_pago=0
									while f_detalle.Siguiente %>
									<tr align="center">
										<th><input type="checkbox" name="detalle_pago[<%=ind%>][checkbox]" value=""></th>
										<td align="center"><%f_detalle.DibujaCampo("dpva_fpago")%></td>
										<td align="center"><%f_detalle.DibujaCampo("dpva_mdetalle")%> </td>
										<td align="center"><INPUT alt="agregar una nueva fila" class=boton TYPE="button" name="agregarlinea2" value="+" onClick="validaFila2('tb_busqueda_detalle','<%=ind%>',this)">&nbsp;<INPUT alt="quitar una fila existente" class=boton TYPE="button" name="quitarlinea2" value="-" onClick="eliminaFilas2()"></td>							
									</tr>	
									<%
									v_total_detalle_pago=	Clng(v_total_detalle_pago)+Clng(f_detalle.ObtenerValor("dpva_mdetalle"))
									ind=ind+1
									wend
								 end if%>		  
								   </table>
								   </td>
					   </tr>
					   <tr>
							<td colspan="4" align="center" bgcolor="#999966"><strong>Detalle Cuentas Contables</strong></td>
					  </tr>					  
					  <tr>
						   <td colspan="4" align="center">					
						   <table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id="tb_busqueda_tipo_gasto">
								<tr bgcolor='#C4D7FF' bordercolor='#999999'>
									<th></th>
									<th>Tipo Gasto</th>
									<th>Cuenta contable</th>
									<th>Monto</th>
									<th>(+/-)</th>
								</tr>
								<%
								if f_detalle_tg.nrofilas >=1 then
									ind=0
									v_total_tipo_gasto=0

									while f_detalle_tg.Siguiente 
									
									' 8888888888888888888888888888888888888888888888888888888888888888888888
									' JAIME PAINEMAL 20130702

									variable_0=f_detalle_tg.ObtenerValor("tgas_ccod")
									'f_detalle_tg_0.agregacampocons "tgas_ccod", variable_0
									
									'response.write("variable_0: "&variable_0&"<br>")

									variable_1=f_detalle_tg.ObtenerValor("tgva_tcuenta_contable")
									
									'response.write("variable_1: "&variable_1&"<br>")
									
									if variable_1<>"" then
										f_detalle_tg_0.agregacampocons "tgas_cod_cuenta", variable_1
									end if

									'f_detalle_tg_0.GeneraJS
									'f_detalle_tg_0.siguiente
								
									 ' 8888888888888888888888888888888888888888888888888888888888888888888888
 
									%>
									<tr align="center">
										<th><input type="checkbox" name="tipo_gasto[<%=ind%>][checkbox]" value=""></th>
										<td align="center">
										<%	
										'f_detalle_tg.DibujaCampo("tgas_ccod")
										'f_detalle_tg_0.DibujaCampoLista "busqueda", "tgas_ccod"
										'f_detalle_tg_0.DibujaCampo("tgas_ccod")
										%>					
											<select name="busqueda[<%=ind%>][tgas_ccod]" onChange="Cargar_codigos(this.form, this.value, <%=ind%>)">
												<%
												f_detalle_tg_0.primero
												while f_detalle_tg_0.Siguiente 
													if Cstr(f_detalle_tg_0.ObtenerValor("tgas_ccod"))=Cstr(variable_0) then
														checkeado="selected"
													else
														checkeado=""
													end if
												%>
												<option value="<%=f_detalle_tg_0.ObtenerValor("tgas_ccod")%>"  <%=checkeado%> ><%=f_detalle_tg_0.ObtenerValor("tgas_tdesc")%></option>
												<%wend%>
											</select>	
											
										</td>
										<td align="center">
										<%
										'f_detalle_tg.DibujaCampo("tgva_tcuenta_contable")
										'f_detalle_tg_0.DibujaCampoLista "busqueda", "tgas_cod_cuenta"
										'f_detalle_tg_0.DibujaCampo("tgas_cod_cuenta")
										%> 
											<input type="text" name="busqueda[<%=ind%>][tgas_cod_cuenta]" value="<%=f_detalle_tg_0.ObtenerValor("tgas_cod_cuenta")%>" >
										</td>
										<td align="center"><%f_detalle_tg.DibujaCampo("tgva_mmonto")%></td>								
										<td align="center"><% if not v_bloquea then%>
										<INPUT alt="agregar una nueva fila" class=boton TYPE="button" name="agregarlinea3" value="+" onClick="validaFila3('tb_busqueda_tipo_gasto','<%=ind%>',this)">&nbsp;
										<INPUT alt="quitar una fila existente" class=boton TYPE="button" name="quitarlinea3" value="-" onClick="eliminaFilas3()"></td>							
										<%end if%>
									</tr>	
									<%

									tgva_mmonto=f_detalle_tg.ObtenerValor("tgva_mmonto")
									'response.write("tgva_mmonto: "&tgva_mmonto&"<br>")

									if tgva_mmonto = "" then
										tgva_mmonto = 0
									end if
									
									'v_total_tipo_gasto=	Clng(v_total_tipo_gasto)+Clng(f_detalle_tg.ObtenerValor("tgva_mmonto"))
									v_total_tipo_gasto=	Clng(v_total_tipo_gasto)+Clng(tgva_mmonto)
									ind=ind+1
									wend
								end if
								%>											
							   </table>							   
							   </td>
					   </tr>					   
					   
					   <tr>
					   <td><strong><center>Acción:</center></strong></td>
					   <td><%f_busqueda.dibujaCampo("aprueba")%></td>
					   <td colspan=2 ><%f_busqueda.dibujaCampo("vcon_tmotivo_rechazo")%> 
							 <input type="hidden" name="total_centro_costo" value="<%=v_total_centro_costo%>" size="8" readonly/>
							 <input type="hidden" name="total_tipo_gasto" value="<%=v_total_tipo_gasto%>" size="8" readonly/>
							 <input type="hidden" name="total_detalle_pago" value="<%=v_total_detalle_pago%>" size="8" readonly/>
						</td>
					   </tr>
                    </table>

                      </td>
                  </tr>
                </table>
				</form>
				
				      <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"> <%botonera.dibujaboton "salir"%> </td>
					  <td><% 
					  if v_vcon_ncorr="" then
					  	botonera.AgregaBotonParam "guardar", "deshabilitado", true
					  end if
					  botonera.dibujaboton "guardar"%></td>
					  <td width="30%"> <%
					  if v_vcon_ncorr="" then
					  	botonera.AgregaBotonParam "asientos", "deshabilitado", true
					  end if
					  botonera.dibujaboton "asientos"%> </td>
                    </tr>
                  </table>                </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="390" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
  
   </td>
  </tr>  
</table>
</body>
</html>
