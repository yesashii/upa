<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

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
'FECHA ACTUALIZACION 	:17/05/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:66,67,68 - 217 -244 - 562
'*******************************************************************
set pagina = new CPagina

v_solicitud	= request.querystring("solicitud")
v_tsol_ccod	= request.querystring("tsol_ccod")

'RESPONSE.WRITE("1. v_solicitud : "&v_solicitud&"<BR>")
'RESPONSE.WRITE("2. v_tsol_ccod : "&v_tsol_ccod&"<BR>")

set botonera = new CFormulario
botonera.carga_parametros "ver_solicitud_giro.xml", "botonera"

set conectar 	= new Cconexion
conectar.inicializar "upacifico"

set negocio 	= new Cnegocio
negocio.inicializa conectar

sede	=negocio.obtenerSede()
v_usuario=negocio.ObtenerUsuario()

'response.write("v_usuario: "&v_usuario&"<br>")

set conexion = new CConexion2
conexion.Inicializar "upacifico"

if v_solicitud<>"" then 

	select case (v_tsol_ccod)

		case 1:
		
			pago_boleta="select ISNULL(a.ordc_ncorr,0) as ordc_ncorr "&_
									" from ocag_solicitud_giro a "&_
									" LEFT JOIN ocag_detalle_solicitud_ag b "&_
									" ON a.sogi_ncorr=B.sogi_ncorr WHERE cast(a.sogi_ncorr as varchar)='"&v_solicitud&"'"
			
			sql_detalle="select * from ocag_detalle_solicitud_ag where cast(sogi_ncorr as varchar)='"&v_solicitud&"'"

			sql_detalle_pago= "select b.*, b.dsgi_mdocto as dsgi_mpesos, b.dogi_fecha_documento as drga_fdocto from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b "&_
							 "	where a.sogi_ncorr=b.sogi_ncorr "&_
							 "	and a.sogi_ncorr="&v_solicitud
			
'			sql_solicitud=   "select isnull(sogi_bboleta_honorario,1) as sogi_bboleta_honorario,sogi_ncorr,cpag_ccod,isnull(tmon_ccod,1) as tmon_ccod,area_ccod,pers_nrut,pers_xdv,ordc_ncorr,pers_tnombre,  "&_
'							 " isnull(sogi_mretencion,0) as sogi_mretencion,isnull(sogi_mhonorarios,0) as sogi_mhonorarios,isnull(sogi_mneto,0) as sogi_mneto, "&_
'							 " isnull(sogi_miva,0) as sogi_miva, isnull(sogi_mexento,0) as sogi_mexento, isnull(sogi_mgiro,0) as sogi_mgiro, "&_
'							 " protic.trunc(sogi_fecha_solicitud) as sogi_fecha_solicitud,pers_tnombre as v_nombre, sogi_tobservaciones,sogi_bboleta_honorario "&_
'							 " from ocag_solicitud_giro a, personas c "&_
'							 "	where a.pers_ncorr_proveedor=c.pers_ncorr and a.sogi_ncorr="&v_solicitud

			sql_solicitud=   "select isnull(a.sogi_bboleta_honorario,1) as sogi_bboleta_honorario "&_
							 ", isnull(a.tmon_ccod,1) as tmon_ccod , a.area_ccod "&_
							 ", c.pers_nrut, c.pers_xdv, a.ordc_ncorr, c.pers_tfono, c.pers_tfax "&_
							 ", isnull(a.sogi_mretencion,0) as sogi_mretencion "&_
							 ", isnull(a.sogi_mhonorarios,0) as sogi_mhonorarios  "&_
							 ", isnull(a.sogi_mneto,0) as sogi_mneto "&_
							 ", isnull(a.sogi_miva,0) as sogi_miva "&_
							 ", isnull(a.sogi_mexento,0) as sogi_mexento "&_
							 ", isnull(a.sogi_mgiro,0) as sogi_mgiro , protic.trunc(a.sogi_fecha_solicitud) as sogi_fecha_solicitud  "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
							 ", a.sogi_ncorr, a.ordc_ncorr, a.pers_ncorr_proveedor, a.tsol_ccod, a.cpag_ccod, a.tgas_ccod, a.mes_ccod, a.anos_ccod "&_
							 ", a.cod_pre, a.sogi_tobservaciones, a.vibo_ccod, a.audi_tusuario, a.audi_fmodificacion, a.sogi_frecepcion, a.sogi_tobs_rechazo, a.area_ccod "&_
							 ", a.tmon_ccod, a.sogi_bboleta_honorario, a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto "&_
							 ", a.ocag_responsable, a.ocag_baprueba, a.sede_ccod "&_
							 "from ocag_solicitud_giro a "&_
							 "INNER JOIN personas c "&_
							 "ON a.pers_ncorr_proveedor = c.pers_ncorr "&_
							 "WHERE a.sogi_ncorr = "&v_solicitud
							 
			variable_xml ="pago_proveedor"	
			detalle_xml ="detalle_producto_proveedor"	
			titulo_lengueta ="Pago proveedor"	
			pagina.Titulo ="Pago proveedor"					 
'888888888888888888888888888888888888888888888888888888888888888888888
		case 2: 

'			sql_detalle		= "select protic.trunc(drga_fdocto) as drga_fdocto, b.* from ocag_reembolso_gastos a, ocag_detalle_reembolso_gasto b "&_
'						 "	where a.rgas_ncorr=b.rgas_ncorr "&_
'						 "	and a.rgas_ncorr="&v_solicitud
						 
			sql_detalle		= "SELECT protic.trunc(drga_fdocto) as drga_fdocto "&_
							" , drga_ncorr, rgas_ncorr, tgas_ccod, tdoc_ccod, drga_ndocto "&_
							" , drga_tdescripcion, drga_fdocto, audi_tusuario, audi_fmodificacion, cod_solicitud_origen, ccos_ncorr "&_
							" , ISNULL(drga_mafecto,0)  AS drga_mafecto, ISNULL(drga_miva,0) AS drga_miva, ISNULL(drga_mexento, 0) AS drga_mexento "&_
							" , ISNULL(drga_mhonorarios,0) AS drga_mhonorarios, ISNULL(drga_mretencion,0) AS drga_mretencion, ISNULL(drga_mdocto,0) AS drga_mdocto "&_
							" , ISNULL(drga_bboleta_honorario,0) AS drga_bboleta_honorario "&_
							" FROM ocag_detalle_reembolso_gasto "&_
							" WHERE rgas_ncorr  ="&v_solicitud

'			sql_solicitud  =   " select protic.trunc(rgas_fpago) as rgas_fpago,pers_tnombre as v_nombre,* "&_
'								" from ocag_reembolso_gastos a, personas c "&_
'								" where a.pers_ncorr_proveedor=c.pers_ncorr and a.rgas_ncorr="&v_solicitud

			sql_solicitud  =   " select protic.trunc(a.rgas_fpago) as rgas_fpago "&_
								", a.rgas_ncorr, a.rgas_mgiro, a.pers_ncorr_proveedor, a.tmon_ccod, a.mes_ccod, a.anos_ccod, a.cod_pre, a.vibo_ccod, a.audi_tusuario "&_
								", a.audi_fmodificacion, a.rgas_frecepcion, a.rgas_tobs_rechazo, a.tsol_ccod, a.area_ccod, a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto "&_
								", a.ocag_responsable, a.ocag_baprueba, a.sede_ccod, a.cod_solicitud_origen "&_
								", c.PERS_NCORR, c.TVIS_CCOD, c.SEXO_CCOD, c.TENS_CCOD, c.COLE_CCOD, c.ECIV_CCOD, c.PAIS_CCOD, c.PERS_BDOBLE_NACIONALIDAD, c.PERS_NRUT, c.PERS_XDV "&_
								", c.PERS_TAPE_PATERNO, c.PERS_TAPE_MATERNO, c.PERS_FNACIMIENTO, c.CIUD_CCOD_NACIMIENTO, c.PERS_FDEFUNCION, c.PERS_TEMPRESA "&_
								", c.PERS_TFONO_EMPRESA, c.PERS_TCARGO, c.PERS_TPROFESION, c.PERS_TFONO, c.PERS_TFAX, c.PERS_TCELULAR, c.PERS_TEMAIL, c.PERS_TPASAPORTE "&_
								", c.PERS_FEMISION_PAS, c.PERS_FVENCIMIENTO_PAS, c.PERS_FTERMINO_VISA, c.PERS_NNOTA_ENS_MEDIA, c.PERS_TCOLE_EGRESO, c.PERS_NANO_EGR_MEDIA "&_
								", c.PERS_TRAZON_SOCIAL, c.PERS_TGIRO, c.PERS_TEMAIL_INTERNO, c.NEDU_CCOD, c.IFAM_CCOD, c.ALAB_CCOD, c.ISAP_CCOD, c.FFAA_CCOD, c.PERS_TTIPO_ENSENANZA "&_
								", c.PERS_TENFERMEDADES, c.PERS_TMEDICAMENTOS_ALERGIA, c.AUDI_TUSUARIO, c.AUDI_FMODIFICACION, c.ciud_nacimiento, c.regi_particular, c.ciud_particular "&_
								", c.pers_bmorosidad, c.sicupadre_ccod, c.sitocup_ccod, c.tenfer_ccod, c.descrip_tenfer, c.trabaja, c.pers_temail2 "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
								"from ocag_reembolso_gastos a "&_
								"INNER JOIN personas c  "&_
								"ON a.pers_ncorr_proveedor = c.pers_ncorr  "&_
								"and a.rgas_ncorr = "&v_solicitud

			variable_xml ="reembolso_gastos"
			detalle_xml ="detalle_reembolso_gastos"
			titulo_lengueta ="Reembolso de Gastos"	
			pagina.Titulo =	"Reembolso de Gastos"							
'888888888888888888888888888888888888888888888888888888888888888888888
		case 3: 

			sql_detalle		= "select ''"
			
'			sql_solicitud	= " select protic.trunc(fren_fpago) as fren_fpago,protic.trunc(fren_factividad) as fren_factividad, a.*, "&_
'							" c.pers_tnombre as v_nombre, c.pers_tnombre, c.pers_nrut, c.pers_xdv, d.pers_tnombre as pers_tnombre_aut, d.pers_xdv  as pers_xdv_aut   "&_
'							" from ocag_fondos_a_rendir a, personas c, personas d "&_
'							"	where a.pers_ncorr=c.pers_ncorr "&_ 
'							" 	and a.pers_nrut_aut=d.pers_nrut "&_
'							" 	and a.fren_ncorr="&v_solicitud	

			sql_solicitud	= " select protic.trunc(a.fren_fpago) as fren_fpago, protic.trunc(a.fren_factividad) as fren_factividad , a.fren_ncorr, a.pers_ncorr "&_
							" , a.fren_mmonto, a.mes_ccod, a.anos_ccod, a.fren_tdescripcion_actividad , a.cod_pre, a.audi_tusuario, a.audi_fmodificacion "&_
							" , a.vibo_ccod, a.fren_frecepcion, a.fren_tobs_rechazo, a.tsol_ccod, a.area_ccod , a.tmon_ccod, a.pers_nrut_aut, a.ocag_fingreso "&_
							" , a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba , a.sede_ccod, a.ccos_ncorr  "&_
							" , c.pers_nrut, c.pers_xdv  "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
							" , d.pers_tnombre + ' ' + d.PERS_TAPE_PATERNO as pers_tnombre_aut "&_
							" , d.pers_xdv as pers_xdv_aut , d.pers_tfono, d.pers_tfax"&_
							" from ocag_fondos_a_rendir a "&_
							" INNER JOIN personas c  "&_
							" ON a.pers_ncorr = c.pers_ncorr AND a.fren_ncorr = "&v_solicitud&" "&_
							" INNER JOIN personas d  "&_
							" ON a.pers_nrut_aut = d.pers_nrut"

			variable_xml ="fondo_rendir"
			detalle_xml ="detalle_fondo_rendir"
			titulo_lengueta ="Fondo rendir"	
			pagina.Titulo =	"Fondo rendir"									
'888888888888888888888888888888888888888888888888888888888888888888888
		case 4: 
			
			sql_detalle		= "select ''"

			sql_solicitud  =	"select protic.trunc(sovi_fpago) as sovi_fpago,protic.trunc(sovi_fllegada) as sovi_fllegada,protic.trunc(sovi_fsalida) as sovi_fsalida, "&_
								" a.*,  b.pers_nrut, pers_xdv, b.pers_tfono, b.pers_tfax"&_
								" , LTRIM(RTRIM(b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
								" from ocag_solicitud_viatico a, personas b "&_
								" where a.pers_ncorr=b.pers_ncorr and sovi_ncorr="&v_solicitud

			variable_xml="solicitud_viatico"
			detalle_xml	="detalle_solicitud_viatico"
			titulo_lengueta="Solicitud viatico"	
			pagina.Titulo =	"Solicitud viatico"	
'888888888888888888888888888888888888888888888888888888888888888888888			
' DEVOLUCION ALUMNO

		case 5: 

			sql_detalle		= "select ''"
			
'			sql_solicitud  = " select protic.trunc(dalu_fpago) as dalu_fpago, "&_
'							 " a.*,  b.pers_nrut, pers_xdv, protic.obtener_nombre_completo(a.pers_ncorr,'n') as pers_tnombre "&_   
'							 " from ocag_devolucion_alumno a, personas b  "&_
'							 " where a.pers_ncorr=b.pers_ncorr and dalu_ncorr="&v_solicitud

			sql_solicitud  = " select protic.trunc(a.dalu_fpago) as dalu_fpago  "&_   
							 " , a.dalu_ncorr, a.pers_ncorr, a.dalu_mmonto_pesos, a.tdev_ccod, a.cod_pre, a.mes_ccod, a.anos_ccod, a.pers_nrut_alu, a.pers_xdv_alu  "&_   
							 " , a.pers_tnombre_alu, a.carrera_alu, a.dalu_tmotivo, a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.dalu_frecepcion, a.dalu_tobs_rechazo  "&_   
							 " , a.tsol_ccod, a.area_ccod, a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba  "&_   
							 " , a.sede_ccod, a.ccos_ccod  "&_   
							 " , b.pers_nrut, pers_xdv , b.pers_tfono, b.pers_tfax"&_
								" , LTRIM(RTRIM(b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_		
							 " from ocag_devolucion_alumno a  "&_   
							 " INNER JOIN personas b  "&_   
							 " ON a.pers_ncorr = b.pers_ncorr  "&_   
							 " and a.dalu_ncorr = "&v_solicitud

			variable_xml="devolucion_alumno"
			detalle_xml	="detalle_devolucion_alumno"
			titulo_lengueta="Devolucion Alumno"												 
			pagina.Titulo ="Devolucion Alumno"
'888888888888888888888888888888888888888888888888888888888888888888888
		case 6: 

			sql_detalle		= "select ''"
			
'			sql_solicitud  = "select protic.trunc(ffij_fpago) as ffij_fpago,a.*, c.pers_tnombre as v_nombre, c.pers_tnombre,   "&_ 
'								" c.pers_nrut, c.pers_xdv, d.pers_tnombre as pers_tnombre_aut, d.pers_xdv  as pers_xdv_aut   "&_
'								" from ocag_fondo_fijo a, personas c, personas d "&_
'								" where a.pers_ncorr=c.pers_ncorr "&_
'								" 	and a.pers_nrut_aut=d.pers_nrut "&_
'								" 	and a.ffij_ncorr="&v_solicitud

			sql_solicitud  = "select protic.trunc(a.ffij_fpago) as ffij_fpago "&_
								" , a.pers_ncorr, a.ffij_mmonto_pesos, a.ffij_fpago, a.area_ccod, a.cod_pre, a.ffij_tdetalle_presu, a.mes_ccod, a.anos_ccod "&_
								" , a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.ffij_frecepcion, a.ffij_tobs_rechazo, a.tsol_ccod, a.pers_nrut_aut, a.tmon_ccod "&_
								" , a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba, a.sede_ccod "&_
								" , c.pers_nrut, c.pers_xdv , c.pers_tfono, c.pers_tfax"&_
								" , d.pers_tnombre + ' ' + d.PERS_TAPE_PATERNO as pers_tnombre_aut, d.pers_xdv as pers_xdv_aut  "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
								" from ocag_fondo_fijo a "&_
								" INNER JOIN personas c "&_
								" ON a.pers_ncorr = c.pers_ncorr and a.ffij_ncorr = "&v_solicitud&" "&_
								" INNER JOIN personas d  "&_
								" ON a.pers_nrut_aut = d.pers_nrut "

			variable_xml="fondo_fijo"
			detalle_xml	="detalle_fondo_fijo"
			titulo_lengueta="Fondo fijo"											
			pagina.Titulo ="Fondo fijo"
'888888888888888888888888888888888888888888888888888888888888888888888

		case 7:
		
		'RENDICION DE FONDO A RENDIR
		
			sql_detalle		= "select ''"
			
			sql_solicitud	= " select protic.trunc(a.fren_fpago) as fren_fpago, protic.trunc(a.fren_factividad) as fren_factividad "&_
										", a.fren_ncorr, a.pers_ncorr, a.fren_mmonto, a.mes_ccod, a.anos_ccod, a.fren_tdescripcion_actividad, a.cod_pre "&_
										", a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.fren_frecepcion, a.fren_tobs_rechazo, a.tsol_ccod, a.area_ccod, a.tmon_ccod, a.pers_nrut_aut "&_
										", a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba, a.sede_ccod, a.ccos_ncorr "&_
										", c.PERS_NCORR, c.TVIS_CCOD, c.SEXO_CCOD, c.TENS_CCOD, c.COLE_CCOD, c.ECIV_CCOD, c.PAIS_CCOD, c.PERS_BDOBLE_NACIONALIDAD, c.PERS_NRUT, c.PERS_XDV "&_						
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
										"from ocag_fondos_a_rendir a "&_
										"INNER JOIN personas c "&_
										"ON a.pers_ncorr = c.pers_ncorr  "&_
										"and a.fren_ncorr ="&v_solicitud	
			
			variable_xml="datos_solicitud_rendir"
			detalle_xml	="detalle_rendicion"
			titulo_lengueta="Rendicion Fondo rendir"											
			pagina.Titulo ="Rendicion Fondo rendir"


'888888888888888888888888888888888888888888888888888888888888888888888
			
		case 8:
		
		'RENDICION DE FONDO FIJO
		
			sql_detalle		= "select ''"

'			sql_solicitud	= " select protic.trunc(a.ffij_fpago) as ffij_fpago "&_
'							  ", a.ffij_ncorr, a.pers_ncorr, a.ffij_mmonto_pesos, a.area_ccod, a.cod_pre, a.ffij_tdetalle_presu, a.mes_ccod, a.anos_ccod "&_
'							  ", a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.ffij_frecepcion, a.ffij_tobs_rechazo, a.tsol_ccod, a.pers_nrut_aut, a.tmon_ccod "&_
'							  ", a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba, a.sede_ccod, c.PERS_NRUT,c.PERS_XDV,area_ccod "&_
'								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
'								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
'							  ", c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO as pers_tnombre_aut "&_
'							  "from ocag_fondo_fijo a "&_
'							  "INNER JOIN personas c  "&_
'							  "ON a.pers_ncorr = c.pers_ncorr  "&_
'							  "and a.ffij_ncorr = "&v_solicitud
							  
			sql_solicitud	= " select protic.trunc(a.ffij_fpago) as ffij_fpago , a.ffij_ncorr, a.pers_ncorr, ffij_mmonto_pesos, a.area_ccod, a.cod_pre, a.ffij_tdetalle_presu "&_
								" , a.mes_ccod, a.anos_ccod , a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.ffij_frecepcion, a.ffij_tobs_rechazo, a.tsol_ccod, a.pers_nrut_aut "&_
								" , a.tmon_ccod , a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba, a.sede_ccod, c.PERS_NRUT "&_
								" ,c.PERS_XDV,area_ccod , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_
								" , c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO as pers_tnombre_aut "&_
								" from ocag_rendicion_fondo_fijo x "&_
								" INNER JOIN ocag_fondo_fijo a "&_
								" ON X.ffij_ncorr = a.ffij_ncorr "&_
								" INNER JOIN personas c ON a.pers_ncorr = c.pers_ncorr and a.ffij_ncorr = "&v_solicitud
			
			variable_xml="datos_solicitud"
			detalle_xml	="detalle_rendicion"
			titulo_lengueta="Rendicion fondo fijo"											
			pagina.Titulo ="Rendicion Fondo fijo"
			
		case 9: 

'			sql_detalle="select * from ocag_detalle_solicitud_ag where cast(sogi_ncorr as varchar)= " &v_solicitud

		 	sql_detalle="select dorc_ncorr, ordc_ncorr, tgas_ccod, dorc_tdesc, ccos_ncorr, dorc_ncantidad, tmon_ccod, dorc_nprecio_unidad "&_
						", dorc_ndescuento, dorc_nprecio_neto, audi_tusuario, audi_fmodificacion, dorc_bafecta "&_
						" from ocag_detalle_orden_compra where cast(ordc_ncorr as varchar)='"&v_solicitud&"'"
			
			sql_detalle_pago= "select b.*, b.dsgi_mdocto as dsgi_mpesos, b.dogi_fecha_documento as drga_fdocto from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b "&_
							 "	where a.sogi_ncorr=b.sogi_ncorr "&_
							 "	and a.sogi_ncorr= " &v_solicitud

'			sql_solicitud=   "select protic.trunc(ordc_fentrega) as ordc_fentrega , cast(ordc_bboleta_honorario as varchar) as ordc_bboleta_honorario "&_
'							 ", ordc_ncorr, pers_ncorr, fecha_solicitud, ordc_ndocto, ordc_tatencion, ordc_mmonto, ordc_ncotizacion, ordc_tobservacion "&_
'							 ", ordc_tcontacto , ordc_fentrega, ordc_tfono, ordc_bboleta_honorario, cpag_ccod, sede_ccod, audi_tusuario, audi_fmodificacion "&_
'							 ", ordc_mretencion, ordc_mhonorarios , ordc_mneto, ordc_miva, cod_pre, ordc_mexento, area_ccod, tmon_ccod, vibo_ccod, tsol_ccod "&_
'							 ", ocag_frecepcion_presupuesto, ocag_responsable , ocag_fingreso, ocag_generador, ordc_bestado_final, ocag_baprueba "&_
'							 "from ocag_orden_compra "&_
'							 "where cast(ordc_ncorr as varchar) = " &v_solicitud

			sql_solicitud=   "select cast(a.ordc_bboleta_honorario as varchar) as ordc_bboleta_honorario "&_
							 ", a.ordc_ncorr, a.pers_ncorr, a.fecha_solicitud, a.ordc_ndocto, a.ordc_tatencion, a.ordc_mmonto, a.ordc_ncotizacion, a.ordc_tobservacion "&_
							 ", a.ordc_tcontacto, a.ordc_fentrega, a.ordc_tfono, a.cpag_ccod, a.sede_ccod, a.audi_tusuario, a.audi_fmodificacion "&_
							 ", a.ordc_mretencion, a.ordc_mhonorarios, a.ordc_mneto, a.ordc_miva, a.cod_pre, a.ordc_mexento, a.area_ccod, a.tmon_ccod, a.vibo_ccod, a.tsol_ccod "&_
							 ", a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_fingreso, a.ocag_generador, a.ordc_bestado_final, a.ocag_baprueba "&_
							 ", b.pers_nrut, b.pers_xdv, b.pers_tfono, b.pers_tfax"&_
								" , LTRIM(RTRIM(b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
							 "from ocag_orden_compra a "&_
							 "INNER JOIN personas b "&_
							 "ON a.pers_ncorr = b.pers_ncorr where cast(a.ordc_ncorr as varchar) = " &v_solicitud

			variable_xml="orden_compra"
			detalle_xml	="detalle_orden_compra"
			titulo_lengueta="Orden de Compra"		
			pagina.Titulo ="Orden de Compra"

	End Select
										 
else
	sql_solicitud	= "select ''"
	sql_detalle		= "select ''"
end if

'******************************************************

'RESPONSE.WRITE("1. sql_detalle :"&sql_detalle&"<BR>")
'RESPONSE.WRITE("2. sql_detalle_pago :"&sql_detalle_pago&"<BR>")
'RESPONSE.WRITE("3. sql_solicitud :"&sql_solicitud&"<BR>")

'RESPONSE.END()

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "ver_solicitud_giro.xml", variable_xml
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar sql_solicitud
 f_busqueda.Siguiente

 area_ccod=f_busqueda.obtenerValor("area_ccod")

 'response.write("area_ccod: "&area_ccod&"<br>")
 
 if EsVacio(area_ccod) or area_ccod="" then
	area_ccod= conexion.consultaUno ("select top 1 a.area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b where rut_usuario ="&v_usuario&" and a.area_ccod=b.area_ccod order by area_tdesc ")
end if

'response.write("area_ccod: "&area_ccod&"<br>")

 '888888888888888888888888888888888888888888888888888888888888888888888
if rut<>"" then
	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	'f_personas.inicializar conexion
	f_personas.inicializar conectar

'	sql_datos_persona= " Select top 1 codaux as pers_nrut,NomAux as pers_tnombre, DirAux as dire_tcalle, DirNum as dire_tnro,CiuDes as ciudad,  "&_
'						" NomAux as v_nombre,isnull(isnull(FonAux1,Fonaux2),FonAux3) as pers_tfono, isnull(FaxAux1,FaxAux2) as pers_tfax "&_
'					   	" from softland.cwtauxi a left outer join softland.cwtciud b on CiuAux=CiuCod "&_
'					   	" where CodAux='"&rut&"'"
						
	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
					   	" ,PERS_TFONO ,PERS_TFAX "&_
					   	" FROM PERSONAS "&_
					   	" WHERE PERS_NRUT='"&rut&"'"
'response.write(sql_datos_persona)
'response.end()
						
	f_personas.consultar sql_datos_persona
	f_personas.Siguiente
	
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	'f_busqueda.AgregaCampoCons "dire_tcalle", f_personas.obtenerValor("dire_tcalle")
	'f_busqueda.AgregaCampoCons "dire_tnro", f_personas.obtenerValor("dire_tnro")
	f_busqueda.AgregaCampoCons "pers_tfono", f_personas.obtenerValor("pers_tfono")
	f_busqueda.AgregaCampoCons "pers_tfax", f_personas.obtenerValor("pers_tfax")
	f_busqueda.AgregaCampoCons "pers_nrut", f_personas.obtenerValor("pers_nrut")
	f_busqueda.AgregaCampoCons "pers_xdv", digito
	'f_busqueda.AgregaCampoCons "ciudad", f_personas.obtenerValor("ciudad")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas.obtenerValor("v_nombre")
end if
'888888888888888888888888888888888888888888888888888888888888888888888

if v_tsol_ccod = 1 then
	set f_detalle_pago = new CFormulario
	f_detalle_pago.carga_parametros "ver_solicitud_giro.xml", "detalle_pago_proveedor"
	f_detalle_pago.inicializar conectar
	f_detalle_pago.Consultar sql_detalle_pago
	
	v_suma_doctos=0
	while f_detalle_pago.Siguiente
		v_suma_doctos= Clng(v_suma_doctos) + Clng(f_detalle_pago.obtenerValor("dsgi_mdocto"))
	wend

	v_boleta	=	f_busqueda.obtenerValor("sogi_bboleta_honorario")	
	
	'RESPONSE.WRITE(" v_boleta : "&v_boleta&"<BR>")

	if Cstr(v_boleta)=Cstr(1) then
		segun_boleta	="Honorario Total (Liquido 0.9)"
		txt_variable	="10% Retencion"
		txt_neto		="Honorarios"
		valor_neto		="sogi_mhonorarios"
		valor_variable	="sogi_mretencion"
		row_span	=3
		
		'RESPONSE.WRITE(" v_solicitud : "&v_solicitud&"<BR>")
		
		if v_solicitud<>"" then

			v_variable	=f_busqueda.obtenerValor("sogi_mretencion")
			v_neto		=f_busqueda.obtenerValor("sogi_mhonorarios")
			v_total		=f_busqueda.obtenerValor("sogi_mhonorarios")
			
		'RESPONSE.WRITE("1. v_variable : "&v_variable&"<BR>")
		'RESPONSE.WRITE("2. v_neto : "&v_neto&"<BR>")
		'RESPONSE.WRITE("3. v_total : "&v_total&"<BR>")
			
			if EsVacio(v_neto) then 
				v_neto=0
			end if
			if EsVacio(v_variable) then 
				v_variable=0
			end if			

		end if
		
		v_totalizado=Clng(v_neto)-Clng(v_variable)
		
		'RESPONSE.WRITE("4. v_variable : "&v_variable&"<BR>")
		'RESPONSE.WRITE("4. v_neto : "&v_neto&"<BR>")
		'RESPONSE.WRITE("4. v_total : "&v_total&"<BR>")

	else
		segun_boleta	="Precio Neto"
		txt_variable	="19% IVA"
		txt_neto		="Neto"
		valor_neto		="sogi_mneto"
		valor_variable	="sogi_miva"
		row_span		=4
		
		'RESPONSE.WRITE(" v_solicitud : "&v_solicitud&"<BR>")
		
		if v_solicitud <> "" then
			v_neto		=f_busqueda.obtenerValor("sogi_mneto")
			v_variable	=f_busqueda.obtenerValor("sogi_miva")
			v_exento	=f_busqueda.obtenerValor("sogi_mexento")
			v_total		=f_busqueda.obtenerValor("sogi_mgiro")
			'response.write v_neto&" / "&v_variable&" / "&v_exento
			v_totalizado=Clng(v_neto)+Clng(v_variable)+Clng(v_exento)	
			'v_totalizado="100"
		end if	
	end if	
end if

' 8888888888888888888888888888888888888888888888888888888

if v_tsol_ccod = 9 then

if v_boleta	=0 then
	v_boleta=f_busqueda.obtenerValor("ordc_bboleta_honorario")
end if

'response.write("7 "&v_boleta&"<br>")
'response.end()

f_busqueda.AgregaCampoCons "ordc_bboleta_honorario", v_boleta

'response.write(v_boleta)
'response.end()

if Cstr(v_boleta)=Cstr(1) then
	segun_boleta="Honorario Total (Liquido 0.9)"
	txt_variable="10% Retencion"
	txt_neto	="Honorarios"
	valor_neto	="ordc_mhonorarios"
	valor_variable	="ordc_mretencion"
	row_span= 3
	v_variable	=f_busqueda.obtenerValor("ordc_mretencion")
	v_neto		=f_busqueda.obtenerValor("ordc_mhonorarios")
	v_total		=f_busqueda.obtenerValor("ordc_mhonorarios")


'Response.write("8 "&v_variable&"<br>")
'Response.write("9 "&v_neto&"<br>")
'Response.end()

	v_totalizado=Clng(v_neto)-Clng(v_variable)

'response.write(v_totalizado)

else
	segun_boleta="Precio Neto"
	txt_variable="19% IVA"
	txt_neto	="Neto"
	valor_neto	="ordc_mneto"
	valor_variable	="ordc_miva"
	row_span= 4
	v_neto		=f_busqueda.obtenerValor("ordc_mneto")
	v_variable	=f_busqueda.obtenerValor("ordc_miva")
	v_exento	=f_busqueda.obtenerValor("ordc_mexento")
	v_total		=f_busqueda.obtenerValor("ordc_mmonto")	
	v_totalizado=v_total

'response.write("10 "&v_neto&"<br>")
'response.write("11 "&v_variable&"<br>")
'response.write("12 "&v_exento&"<br>")
'response.write("13 "&v_total&"<br>")
'response.write("14 "&v_totalizado&"<br>")
'response.end()

end if

end if

' 8888888888888888888888888888888888888888888888888888888

'PAGO A PROVEEDORES
if v_tsol_ccod =1 then

	detalle_022= conectar.consultaUno (pago_boleta)
	'RESPONSE.WRITE("detalle_022 : "&detalle_022&"<BR>")

	set f_detalle = new CFormulario
	f_detalle.carga_parametros "ver_solicitud_giro.xml", detalle_xml
	f_detalle.inicializar conectar
	
	IF detalle_022 = "0" THEN
		f_detalle.Consultar sql_detalle
	ELSE
		sql_detalle_02="select DISTINCT dorc_ncorr, ordc_ncorr, tgas_ccod, dorc_tdesc, ccos_ncorr, dorc_ncantidad, tmon_ccod, dorc_nprecio_unidad "&_
			", dorc_ndescuento, dorc_nprecio_neto, audi_tusuario, audi_fmodificacion, dorc_bafecta "&_
			" from ocag_detalle_orden_compra where cast(ordc_ncorr as varchar)='"&detalle_022&"'"
			
		'sql_detalle_02="select a.*, B.sogi_ncorr "&_
		'						" FROM ocag_detalle_orden_compra a "&_
		'						" INNER JOIN ocag_solicitud_giro b "&_
		'						" ON a.ordc_ncorr = b.ordc_ncorr and cast(A.ordc_ncorr as varchar)='"&detalle_022&"'"
			
		'RESPONSE.WRITE("sql_detalle_02 : "&sql_detalle_02&"<BR>")
			
		f_detalle.Consultar sql_detalle_02
	END IF
	
end if

' 8888888888888888888888888888888888888888888888888888888

'REEMBOLSO DE GASTOS
'FONDO A RENDIR
'Rendicion Fondo a Rendir
'Rendicion Fondo Fijo
'ORDEN DE COMPRA

if v_tsol_ccod <> 1 and v_tsol_ccod <> 4 and v_tsol_ccod <> 5 and v_tsol_ccod <> 6 then
	set f_detalle = new CFormulario
	f_detalle.carga_parametros "ver_solicitud_giro.xml", detalle_xml
	f_detalle.inicializar conectar
	'response.write sql_detalle
	f_detalle.Consultar sql_detalle
end if

'*****************************************************************
'***************	Inicio bases para presupuesto	**************

set f_presupuesto = new CFormulario
f_presupuesto.Carga_Parametros "datos_presupuesto.xml", "detalle_presupuesto_lectura"
f_presupuesto.Inicializar conectar

'sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_solicitud&"' and tsol_ccod="&v_tsol_ccod&" "

'' 88888888888888888888888888888888888888888888888888
' ESTA CONSULTA LLENA EL CUADRO DE PRESUPUESTO
'' 88888888888888888888888888888888888888888888888888

sql_presupuesto="select psol_ncorr, tsol_ccod, cod_solicitud, cod_pre, mes_ccod, anos_ccod "&_
			    ", psol_mpresupuesto, audi_tusuario, audi_fmodificacion "&_
			    ", psol_brendicion, cod_solicitud_origen "&_
			    "from ocag_presupuesto_solicitud "&_
			    "where cast(cod_solicitud as varchar)='"&v_solicitud&"' and tsol_ccod="&v_tsol_ccod&" "

if v_tsol_ccod = 7 then
'rendicion de fondo a rendir

sql_presupuesto="select psol_ncorr, tsol_ccod, cod_solicitud, cod_pre, mes_ccod, anos_ccod "&_
			    ", psol_mpresupuesto, audi_tusuario, audi_fmodificacion "&_
			    ", psol_brendicion, cod_solicitud_origen "&_
			    "from ocag_presupuesto_solicitud "&_
			    "where cast(cod_solicitud as varchar)='"&v_solicitud&"' and tsol_ccod=3 "

end if

if v_tsol_ccod = 8 then
'rendicion de fondo fijo
sql_presupuesto="select psol_ncorr, tsol_ccod, cod_solicitud, cod_pre, mes_ccod, anos_ccod "&_
			    ", psol_mpresupuesto, audi_tusuario, audi_fmodificacion "&_
			    ", psol_brendicion, cod_solicitud_origen "&_
			    "from ocag_presupuesto_solicitud "&_
			    "where cast(cod_solicitud as varchar)='"&v_solicitud&"' and tsol_ccod=6 "
				
end if


'Response.write("4. "&sql_presupuesto&"<br>")
'Response.end()

f_presupuesto.consultar sql_presupuesto



v_suma_presupuesto=0
if f_presupuesto.nrofilas>=1 and v_solicitud>=1 then
	while f_presupuesto.Siguiente
		v_suma_presupuesto= Clng(v_suma_presupuesto) + Clng(f_presupuesto.obtenerValor("psol_mpresupuesto"))
	wend
end if

ind=0
f_presupuesto.primero
	while f_presupuesto.Siguiente 

		'8888888888888888888888888888888888888888888888
		if ind = 0 then
			v_cod_pre1="'"&f_presupuesto.ObtenerValor("cod_pre")&"'"
		else
			v_cod_pre1=",'"&f_presupuesto.ObtenerValor("cod_pre")&"'"
		end if
		'8888888888888888888888888888888888888888888888

		v_cod_pre2 = v_cod_pre2 & v_cod_pre1
		ind=ind+1
		
	wend 

if v_cod_pre2= ""then
	v_cod_pre2="'a'"
end if

'Response.write("A. "&v_cod_pre2&"<br>")
'response.end()

set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_cod_pre.inicializar conexion
'f_cod_pre.consultar "select '' "

'888888888888888888888888888888888888888888888888888888888888888888888
'  ** aqui construye el codigo de presupuesto**
'888888888888888888888888888888888888888888888888888888888888888888888

'sql_codigo_pre="(select distinct cod_pre, 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto +' ('+cod_pre+')' as valor "&_
'			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
'			    "	where cod_anio=2011 "&_
'				"	and cod_area in (   select distinct area_ccod "&_ 
'				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
'				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
'				" ) as tabla "

sql_codigo_pre="(select distinct cod_pre, '('+cod_pre+')' + ' Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"  and cod_pre in ("&v_cod_pre2&")  "&_
				" ) as tabla "

conexion.estadotransaccion	conexion.ejecutas(sql_codigo_pre)

'Response.write("5. "&sql_codigo_pre&"<br>")
'Response.end()

f_cod_pre.consultar sql_codigo_pre


set f_meses = new CFormulario
f_meses.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_meses.inicializar conectar
sql_meses= "Select * from meses"
f_meses.consultar sql_meses

set f_anos = new CFormulario
f_anos.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_anos.inicializar conectar

sql_anos= "select anos_ccod, case when anos_ccod=year(getdate()) then 1 else 0 end as orden "&_
			" from anos where anos_ccod between year(getdate())-1 and year(getdate())+1 "&_
			" order by orden desc "

'Response.write("6. "&sql_anos&"<br>")

f_anos.consultar sql_anos
'*****************************************************************
'***************	Fin bases para presupuesto	******************


set f_responsable = new CFormulario
	f_responsable.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_responsable.inicializar conectar
	
	sql_responsable= "Select pers_nrut_responsable as pers_nrut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre "&_
					  "	from ocag_responsable_area a, personas b "&_
					  "	where a.pers_nrut_responsable=b.pers_nrut "&_
					  "	and cast(a.pers_nrut as varchar)='"&v_usuario&"'"

	f_responsable.consultar sql_responsable
	
' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888	

if v_tsol_ccod = 7 then
'Rendicion Fondo a Rendir

set f_detalle = new CFormulario
f_detalle.Carga_Parametros "ver_solicitud_giro.xml", "detalle_rendicion_rendir"
f_detalle.Inicializar conectar

'sql_detalle_pago= "select drfr_trut as pers_nrut,isnull(drfr_mretencion,0) as drfr_mretencion,protic.trunc(drfr_fdocto) as drfr_fdocto,* from ocag_detalle_rendicion_fondo_rendir where fren_ncorr ="&v_solicitud

sql_detalle_pago= "select drfr_trut as pers_nrut, drfr_ncorr, rfre_ncorr, drfr_trut, tgas_ccod  "&_
							" , tdoc_ccod, drfr_ndocto, drfr_tdesc, protic.trunc(drfr_fdocto) as drfr_fdocto, audi_tusuario  "&_
							" , audi_fmodificacion, fren_ncorr, ISNULL(drfr_mafecto,0) AS drfr_mafecto, ISNULL(drfr_miva,0) AS drfr_miva, ISNULL(drfr_mexento,0) AS drfr_mexento  "&_
							" , ISNULL(drfr_mhonorarios,0) AS drfr_mhonorarios, ISNULL(drfr_mretencion,0) AS drfr_mretencion, ISNULL(drfr_mdocto,0) AS drfr_mdocto, ISNULL(drfr_bboleta_honorario,0) AS drfr_bboleta_honorario  "&_
							" from ocag_detalle_rendicion_fondo_rendir where fren_ncorr ="&v_solicitud

'response.write("1. sql_detalle_pago : "&sql_detalle_pago&"<br>")

f_detalle.Consultar sql_detalle_pago

set f_devolucion = new CFormulario
f_devolucion.Carga_Parametros "ver_solicitud_giro.xml", "devolucion_rendicion"
f_devolucion.Inicializar conectar

	sql_devolucion="select protic.trunc(dren_fcomprobante) as dren_fcomprobante, * from ocag_devolucion_rendicion_fondos where fren_ncorr="&v_solicitud

f_devolucion.Consultar sql_devolucion
f_devolucion.siguiente

set f_presupuesto_devol = new CFormulario
f_presupuesto_devol.Carga_Parametros "ver_solicitud_giro.xml", "detalle_presupuesto"
f_presupuesto_devol.Inicializar conectar

	sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud_origen as varchar)='"&v_solicitud&"' and tsol_ccod=2 and isnull(psol_brendicion,'S') ='S'"

f_presupuesto_devol.consultar sql_presupuesto
end if	
	
' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

if v_tsol_ccod = 8 then
'Rendicion Fondo Fijo

area_ccod=f_busqueda.obtenerValor("area_ccod")
area_tdesc=conectar.consultaUno("select area_tdesc from presupuesto_upa.protic.area_presupuestal where area_ccod="&area_ccod)

set f_detalle = new CFormulario
f_detalle.Carga_Parametros "ver_solicitud_giro.xml", "detalle_rendicion"
f_detalle.Inicializar conectar

'sql_detalle_pago= "select protic.trunc(rffi_fdocto) as rffi_fdocto  "&_
'									" , rffi_ncorr, tdoc_ccod, rffi_ndocto, pers_nrut, pers_xdv, tgas_ccod, rffi_tdesc, rffi_mretencion, rffi_mmonto, ffij_ncorr, audi_tusuario, audi_fmodificacion "&_
'									" , ocag_fingreso, ocag_generador, ocag_responsable, vibo_ccod, ocag_baprueba, tsol_ccod, ocag_frecepcion_presupuesto, sede_ccod   "&_
'									" from ocag_rendicion_fondo_fijo  "&_
'									" where ffij_ncorr = "&v_solicitud
									
sql_detalle_pago= "select protic.trunc(drff_fdocto) as rffi_fdocto ,rffi_ncorr, tdoc_ccod, drff_ndocto as rffi_ndocto, pers_nrut, pers_xdv, tgas_ccod, drff_tdesc as rffi_tdesc  "&_
									", drff_mretencion, cast(drff_mdocto as numeric) as rffi_mmonto, ffij_ncorr, audi_tusuario, audi_fmodificacion   "&_
									"from ocag_detalle_rendicion_fondo_fijo where ffij_ncorr ="&v_solicitud
									
'response.write("7. sql_detalle_pago : "&sql_detalle_pago&"<br>")

f_detalle.Consultar sql_detalle_pago
end if
										
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
v_pers_tnombre = f_busqueda.obtenerValor("pers_tnombre")
v_rut=f_busqueda.obtenerValor("pers_nrut")
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'88 INICIO
	
	if v_pers_tnombre="" then
	
	set f_personas2 = new CFormulario
	f_personas2.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas2.inicializar conexion

	sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
											" from softland.cwtauxi where cast(CodAux as varchar)='"&v_rut&"'"
	
	f_personas2.consultar sql_datos_persona
	f_personas2.Siguiente
						
	v_pers_tnombre = f_personas2.obtenerValor("pers_tnombre")
						
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas2.obtenerValor("pers_tnombre")
	
	end if
	'88 FIN
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

%>


<html>
<head>
<title>Solicitud de Giro</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function AgregarDetalle(formu){
	document.datos.action="pago_proveedor_detalle_proc.asp";
	document.datos.method="post";
	document.datos.submit();
}

function EliminaDetalle(){
	document.detalle_doctos.action="pago_proveedor_detalle_elimina_proc.asp";
	document.detalle_doctos.method="post";
	document.detalle_doctos.submit();
}

function Enviar(){
	//validar campos vacios
	return true;
}

function Cerrar(){
	window.close();
}

function Deshabilita(){
	document.forms.detalle_pago_proveedor.elements["_detalle[0][dorc_bafecta]"].disabled=true;
}
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');Deshabilita();MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">

<!-- AQUI COMIENZA LA TABLA MAYOR 1 -->

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
                <td background="../imagenes/top_r1_c2.gif"><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif"><%=titulo_lengueta%></font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td background="../imagenes/top_r3_c2.gif"><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif"  height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>

<!-- AQUI COMIENZA LA TABLA MAYOR  2-->

              <table border="0" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left"  background="../imagenes/izq.gif">&nbsp;</td>
                  <td valign="top" bgcolor="#D8D8DE">
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    
					 </div>
					  
<!-- AQUI COMIENZA LA TABLA CONTENEDORA DE SUB-TABLAS -->

                    <table border="0" width="100%" align="center" cellpadding="0" cellspacing="0">
					<tr> 
                    <td>
					
					<hr> <!-- LINEA -->
					<BR>

							<% 
							
							select case (v_tsol_ccod)
							
							CASE 1:

							%>


<!-- INICIO SUB TABLA 1-->

									 <table width="100%" border="1" height="100%">
										  <tr> 
											<td width="11%">Rut proveedor </td>
											<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
											<td> Fecha docto </td>
											<td width="48%"><%f_busqueda.dibujaCampo("sogi_fecha_solicitud")%></td>
										  </tr>
										  <tr> 
											<td> Nombre proveedor </td>
											<td><%
											f_busqueda.dibujaCampo("pers_tnombre")
											%>&nbsp;<%
											'f_busqueda.dibujaCampo("v_nombre")
											%></td>
											<td>Tipo Moneda</td>
											<td><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
										  </tr>
										  <tr>
											<td>Monto girar </td>
											<td><%f_busqueda.dibujaCampo("sogi_mgiro")%></td>
											<td rowspan="2">Detalle de gasto</td>
											<td rowspan="2"><%=f_busqueda.ObtenerValor("sogi_tobservaciones")%></td> 
										  </tr>					  
										  <tr>
											<td>Cond. Pago </td>
											<td><%f_busqueda.dibujaCampo("cpag_ccod")%></td>
										  </tr>
									</table>

<!-- FIN SUB TABLA 1-->
									<HR><B>Detalle Presupuesto</B><BR>

<!-- INICIO SUB TABLA 2-->

												<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
													<tr bgcolor='#C4D7FF' bordercolor='#999999'>
														<th width="50%">Cod. Presupuesto</th>
														<th width="12%">Mes</th>
														<th width="12%">Año</th>
														<th width="16%">Valor</th>
													</tr>
													<% ind=0
													f_presupuesto.primero
													while f_presupuesto.Siguiente 
													v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")

														f_cod_pre.primero
														while f_cod_pre.Siguiente 
																				if v_cod_pre=f_cod_pre.ObtenerValor("cod_pre") then
																				valor_final = f_cod_pre.ObtenerValor("valor")
																				end if
														wend
													%>
													<tr align="left">
													<td><%=valor_final%></td>
													<td><%f_presupuesto.DibujaCampo("mes_ccod")%> </td>
													<td><%f_presupuesto.DibujaCampo("anos_ccod")%> </td>
													<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
												  </tr>	
												<%
												ind=ind+1
												wend 
												%>
												</table>							  

<!-- FIN SUB TABLA 2-->

									<TABLE><TR><TD><BR></TD></TR></TABLE><B>Detalle Documentos</B>

<!-- INICIO SUB TABLA 3 -->

											<table width="100%" align="center" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_doctos>
												<tr bgcolor='#C4D7FF' bordercolor='#999999'>
												  <th>Tipo Docto </th>
												  <th>N&deg; Docto </th>
												  <th>Fecha Docto</th>
												  <th>Exento </th>
												  <th>Neto </th>
												  <th>Iva </th>
												  <th>Honorarios </th>
												  <th>Retencion </th>
												  <th>Total  </th>
												</tr>
												<%
													indice=0
													v_documentos=0
													f_detalle_pago.primero
													while f_detalle_pago.Siguiente 
												%>
												<tr align="left">
												  <td><%f_detalle_pago.dibujacampo("tdoc_ccod")%></td>
												  <td><%f_detalle_pago.dibujacampo("dsgi_ndocto")%></td>
												  <td><%f_detalle_pago.DibujaCampo("drga_fdocto")%></td>
												  <td><%f_detalle_pago.dibujacampo("dsgi_mexento")%></td>
												  <td><%f_detalle_pago.dibujacampo("dsgi_mafecto")%></td>
												  <td><%f_detalle_pago.dibujacampo("dsgi_miva")%></td>
												  <td><%f_detalle_pago.dibujacampo("dsgi_mhonorarios")%></td>
												  <td><%f_detalle_pago.dibujacampo("dsgi_mretencion")%></td>
												  <td><%f_detalle_pago.dibujacampo("dsgi_mdocto")%></td>
												</tr>
												<%
													indice=indice+1
													wend
												%>

												<tr>
												<td colspan="7" align="right"><strong>Total documentos = </strong></td>
												<td>&nbsp;<b><%=v_suma_doctos%></b></td>
												</tr>				

											</table>

<!-- FIN SUB TABLA 3 -->
										
										<TABLE><TR><TD><BR></TD></TR></TABLE><B>Detalle Gasto</B>

<!-- INICIO SUB TABLA 4 -->
												
												<table width="100%" align="center" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_busqueda_detalle>
													<tr bgcolor='#C4D7FF' bordercolor='#999999'>
														<th wdth="40%">Tipo Gasto</th>
														<th wdth="10%">Descripcion</th>
														<th wdth="10%">C. Costo</th>
														<th wdth="10%">Cantidad</th>

														<th wdth="10%">Precio Unitario</th>
														<th wdth="10%">Descuento($)</th>
														<th wdth="10%"><%=segun_boleta%></th>
													</tr>
														<%
																ind_d=0
																'v_totalizado=0
																f_detalle.primero
																while f_detalle.Siguiente 
																'f_detalle.agregacampocons "tgas_ccod",f_detalle.obtenervalor("tgas_ccod")
																%>
																<tr align="left">

																	<td wdth="40%"><%
																	f_detalle.agregacampoparam "tgas_ccod","permiso","LECTURA"
																	f_detalle.DibujaCampo("tgas_ccod")
																	%></td>
																	<td wdth="10%"><%
																	f_detalle.agregacampoparam "dorc_tdesc","permiso","LECTURA"
																	f_detalle.DibujaCampo("dorc_tdesc")
																	%></td>
																	<td wdth="10%"><%
																	f_detalle.agregacampoparam "ccos_ncorr","permiso","LECTURA"
																	f_detalle.DibujaCampo("ccos_ncorr")
																	%> </td>
																	<td wdth="10%"><%
																	f_detalle.agregacampoparam "dorc_ncantidad","permiso","LECTURA"
																	f_detalle.DibujaCampo("dorc_ncantidad")
																	%> </td>

																	<td wdth="10%"><%
																	f_detalle.agregacampoparam "dorc_nprecio_unidad","permiso","LECTURA"
																	f_detalle.DibujaCampo("dorc_nprecio_unidad")
																	%></td>
																	<td wdth="10%"><%
																	f_detalle.agregacampoparam "dorc_ndescuento","permiso","LECTURA"
																	f_detalle.DibujaCampo("dorc_ndescuento")%> </td>
																	<td wdth="10%"><%
																	f_detalle.agregacampoparam "dorc_nprecio_neto","permiso","LECTURA"
																	f_detalle.DibujaCampo("dorc_nprecio_neto")
																	%> </td>
																</tr>	
																<%
																ind_d=ind_d+1
																wend
														%>
												</table>

<!-- FIN SUB TABLA 4-->
											<TABLE><TR><TD><BR></TD></TR></TABLE>
<!-- INICIO SUB TABLA 5-->

											<table border="1" width="100%" >
											  <tr>
												<td width="80%" rowspan="<%=row_span%>">&nbsp;</td>
												<th width="10%"><%=txt_neto%></th>
												<td width="10%"><%=v_neto%></td>
											  </tr>
											  <tr>
												<th><%=txt_variable%></th>
												<td><%=v_variable%></td>
											  </tr>
											  <% if Cstr(v_boleta)="2" then %>
											  <tr>
												<th>Exento</th>
												<td><%=v_exento%></td>
											  </tr>
											  <%end if%>
											  <tr>
												<th>Total</th>
												<td><%=v_totalizado%></td>
											  </tr>
											</table>

<!-- FIN SUB TABLA 5-->
								
								<HR><BR>
								 <strong>V°B° Responsable:</strong>
											 <%
												f_responsable.primero
												while f_responsable.Siguiente
													f_responsable.DibujaCampo("nombre")
												wend
											%>
								
								<TABLE><TR><TD><BR></TD></TR></TABLE>

									
								<% 
'888888888888888888888888888888888888888888888888888888888888888888888
								case 2: %>


<!-- INICIO TABLA 1 -->

									<table width="100%" border="1">
									  <tr> 
										<td width="11%">Rut funcionario </td>
										<td width="37%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
										<td width="14%">Tipo moneda </td>
										<td><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
									  </tr>
									  <tr> 
										<td>Nombre Funcionario </td>
											<td><%
											f_busqueda.dibujaCampo("pers_tnombre")
											%>&nbsp;<%
											'f_busqueda.dibujaCampo("v_nombre")
											%></td>
										<td>Fecha Pago</td>
										<td width="38%"><%f_busqueda.dibujaCampo("rgas_fpago")%></td>
									  </tr>
									  <tr> 
										<td>Monto girar </td>
										<td> <%f_busqueda.dibujaCampo("rgas_mgiro")%></td>
										<td>Total Presupuesto </td>
										<td><%=v_suma_presupuesto%></td>
									  </tr>
									</table>

<!-- FIN TABLA 1 -->

									<HR><B>Detalle Presupuesto</B><BR>			

<!-- INICIO TABLA 2 -->

											<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
												<tr bgcolor='#C4D7FF' bordercolor='#999999'>
													<th width="63%">Cod. Presupuesto</th>
													<th width="15%">Mes</th>
													<th width="10%">Año</th>
													<th width="12%">Valor</th>
												</tr>
														<% ind=0
									f_presupuesto.primero
									while f_presupuesto.Siguiente 
									v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
									%>
									<tr align="left">
										<td>
												<%
												f_cod_pre.primero
												while f_cod_pre.Siguiente 
													if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
														response.Write(f_cod_pre.ObtenerValor("valor"))
													end if
												wend
												%>
									  </td>
															<td><%f_presupuesto.DibujaCampo("mes_ccod")%> </td>
															<td><%f_presupuesto.DibujaCampo("anos_ccod")%> </td>
															<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
											  </tr>	
														<%
														ind=ind+1
														wend %>
											</table>	

<!-- FIN TABLA 2 -->

										<TABLE><TR><TD><BR></TD></TR></TABLE><B>Detalle Gasto</B>

<!-- INICIO TABLA 3 -->

											<table width="100%"  class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'>
											  <tr bgcolor='#C4D7FF' bordercolor='#999999'>
													<th width="7%">Fecha Docto</th>
													<th width="7%">N&deg; Docto</th>
													<th width="7%">Tipo Docto</th>
													<th width="7%">Tipo Gasto</th>
													<!--<th width="10%">Desc Gasto</th>-->
													<th width="7%">C. Costo</th>
													<th width="7%">Neto</th>
													<th width="7%">Iva</th>
													<th width="7%">Exento</th>
													<th width="7%">Honor</th>
													<th width="7%">Reten</th>
													<th width="7%">Líquido</th>
											  </tr>
											  <%
											  ind=0
											  v_total=0
											  v_retencion=0
											  v_bruto=0
											  	if f_detalle.nrofilas >=1 then
													while f_detalle.Siguiente %>
														<tr>
															<td><%f_detalle.DibujaCampo("drga_fdocto")%></td>
															<td><%f_detalle.DibujaCampo("drga_ndocto")%> </td>
															<td><%f_detalle.DibujaCampo("tdoc_ccod")%> </td>
															<td><%f_detalle.DibujaCampo("tgas_ccod")%></td>
															<!--<td>
															<%'f_detalle.DibujaCampo("drga_tdescripcion")
															%> </td>-->
															
															<td wdth="7%">
																<%
																f_detalle.agregacampoparam "ccos_ncorr","permiso","LECTURA"
																f_detalle.DibujaCampo("ccos_ncorr")
																%>
															</td>

															<td><%f_detalle.DibujaCampo("drga_mafecto")%> </td>	
															<td><%f_detalle.DibujaCampo("drga_miva")%> </td>																				
															<td><%f_detalle.DibujaCampo("drga_mexento")%> </td>	
															<td><%f_detalle.DibujaCampo("drga_mhonorarios")%> </td>		
															<td><%f_detalle.DibujaCampo("drga_mretencion")%> </td>	
															<td><%f_detalle.DibujaCampo("drga_mdocto")%> </td>		
															
														</tr>
													<%
														v_bruto		=Clng(v_bruto) + Clng(f_detalle.ObtenerValor("drga_mdocto"))
														v_retencion	=Clng(v_retencion) + Clng(f_detalle.ObtenerValor("drga_mretencion"))
														ind=ind+1
													wend
													v_total=v_bruto+v_retencion
												end if
												indice=ind
												cont=0 %>
												<tr>
												<td colspan="10" align="right"><strong>Total a Girar</strong></td>
												<td>&nbsp;<b><%=formatcurrency(v_total,0)%></b></td>
												</tr>																																									
											</table>								  
											
<!-- FIN TABLA 3 -->

								<TABLE><TR><TD><BR></TD></TR></TABLE>
												<strong>V°B° Responsable:</strong>
												  <%
													f_responsable.primero
													while f_responsable.Siguiente
													f_responsable.DibujaCampo("nombre")
													wend%>

								<TABLE><TR><TD><BR></TD></TR></TABLE>


								<% 
'888888888888888888888888888888888888888888888888888888888888888888888
								case 3: %>


<!-- INICIO TABLA 1 -->

									<table width="100%" border="1">
									  <tr> 
										<td width="11%">Rut funcionario </td>
										<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
										<td width="14%">Fecha actividad</td>
										<td><%f_busqueda.dibujaCampo("fren_factividad")%></td>
									  </tr>
									  <tr> 
										<td> Nombre funcionario </td>
										<td><%
										f_busqueda.dibujaCampo("pers_tnombre")
										%>&nbsp;<%
										'f_busqueda.dibujaCampo("v_nombre")
										%></td>
										<td>Fecha Pago </td>
										<td width="48%"><%f_busqueda.dibujaCampo("fren_fpago")%></td>
									  </tr>
									  <tr> 
										<td>Monto girar </td>
										<td><%f_busqueda.dibujaCampo("fren_mmonto")%></td>
										<td>Total Presupuesto </td>
										<td><%=v_suma_presupuesto%></td>
									  </tr>
									  <tr> 
										<td>Tipo Moneda </td>
										<td><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
										<td>Descripcion actividad </td>
										<td width="48%"><%=f_busqueda.ObtenerValor("fren_tdescripcion_actividad")%></td>
									  </tr>
									  <tr> 
										<td>C. Costo</td>
										<td> 
										<%=f_busqueda.dibujaCampo("ccos_ncorr")%>
										</td>
										<td> </td>
										<td> </td>
									  </tr>
					  </TABLE>

<!-- FIN TABLA 1 -->

									<HR><B>Detalle presupuesto</B><BR>					

<!-- INICIO TABLA 2 -->

												<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
													<tr bgcolor='#C4D7FF' bordercolor='#999999'>
													
														<th width="63%">Cod. Presupuesto</th>
														<th width="15%">Mes</th>
														<th width="10%">Año</th>
														<th width="12%">Valor</th>
													
													</tr>
												<% ind=0
												f_presupuesto.primero
												while f_presupuesto.Siguiente 
												v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")

													f_cod_pre.primero
													while f_cod_pre.Siguiente 
																			if v_cod_pre=f_cod_pre.ObtenerValor("cod_pre") then
																			valor_final = f_cod_pre.ObtenerValor("valor")
																			end if
													wend
												%>
												<tr align="left">
													<td><%=valor_final%></td>
														<td><%f_presupuesto.DibujaCampo("mes_ccod")%> </td>
														<td><%f_presupuesto.DibujaCampo("anos_ccod")%> </td>
														<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
												  </tr>	
													<%
													ind=ind+1
													wend 
													%>
												</table>

<!-- FIN TABLA 2 -->

									<TABLE><TR><TD><BR></TD></TR></TABLE>

<!-- INICIO TABLA 3-->

								<table width="100%" border="0">

									<tr>
										<td>
										<table border ="1" align="center" width="100%">
											<tr valign="top">
												<td><br>Yo: <b><%=f_busqueda.obtenerValor("pers_tnombre_aut")%></b>
												<br><br>
												   Rut:<b><%=f_busqueda.obtenerValor("pers_nrut_aut")%>-<%=f_busqueda.obtenerValor("pers_xdv_aut")%></b>
												<br>
												<p>Autorizo que, en caso de NO rendir 30 dias despues de la fecha de la actividad (evento),
												la Universidad del Pacifico descuente el monto autorizado, de mi remuneracion mensual o
												de mi indemnizacion por años de servicios que tenga derecho, desahucio y/u otros emolumentos legales.</p>
												<br>
												<br>
												<center><p>____________________</p></center>
												<center><p>Firma trabajador</p></center>								
												</td>
											</tr>
										  </table>
										</td>
									</tr>
									<tr>
										<td>
										<br>
										  <strong>V°B° Responsable:</strong>
										  <%
											f_responsable.primero
											while f_responsable.Siguiente
										 		f_responsable.DibujaCampo("nombre")
										  wend
										  %>
										  <br/>&nbsp;
										</td>
									</tr>
								</table>

<!-- FIN TABLA 3 -->
								
								<%case 4: 
'88888888888888888888888888888888888888888888888888888
' SOLICITUD DE VIATICO
								%>
								
							<table width="100%" border="1">
							  <tr> 
								<td width="11%">Rut funcionario </td>
								<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
								<td width="14%">Mes </td>
								<td><%f_busqueda.dibujaCampo("mes_ccod")%></td>
							  </tr>
							  <tr> 
								<td> Nombre funcionario </td>
								<td><%
								f_busqueda.dibujaCampo("pers_tnombre")
								%>&nbsp;<%
								'f_busqueda.dibujaCampo("v_nombre")
								%></td>
								<td>A&ntilde;o</td>
								<td width="48%"><%f_busqueda.dibujaCampo("anos_ccod")%></td>
							  </tr>
							 <tr> 
								<td>Fecha. Pago </td>
								<td><%f_busqueda.dibujaCampo("sovi_fpago")%> dd/mm/aaaa</td>
								<td>Total Presupuesto </td>
								<td><%=v_suma_presupuesto%></td>
							 </tr>
							 <tr>
							   <td colspan="4">
										<h6>Detalle presupuesto</h6>					
									<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
										<tr bgcolor='#C4D7FF' bordercolor='#999999'>
											<th width="63%">Cod. Presupuesto</th>
											<th width="15%">Mes</th>
											<th width="10%">Año</th>
											<th width="12%">Valor</th>
										</tr>
													<% ind=0
													f_presupuesto.primero
													while f_presupuesto.Siguiente 
													v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")

														f_cod_pre.primero
														while f_cod_pre.Siguiente 
																				if v_cod_pre=f_cod_pre.ObtenerValor("cod_pre") then
																				valor_final = f_cod_pre.ObtenerValor("valor")
																				end if
														wend
													%>
													<tr align="left">
													<td><%=valor_final%></td>

										<td><%f_presupuesto.DibujaCampo("mes_ccod")%> </td>
										<td><%f_presupuesto.DibujaCampo("anos_ccod")%> </td>
										<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
									  </tr>	
									<%
									ind=ind+1
									wend 
									%>
									</table>
							   </td>
						  </tr>	
                      <tr> 
                        <td><em><strong>Origen </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("orvi_ccod")%></td>
                        <td><em><strong>Destino </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("devi_ccod")%></td>
                      </tr>
                      <tr> 
                        <td><em><strong>Fecha Salida </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_fsalida")%></td>
                        <td><em><strong>Fecha llegada </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_fllegada")%></td>
                      </tr>

                      <tr> 
                        <td><em><strong>Hora salida </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_hsalida")%>
                          (hh:mm)</td>
                        <td><em><strong>Hora llegada </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_hllegada")%>
                          (hh:mm)  </td>
                      </tr>					  					  
					  
                      <tr>
                        <td><em><strong>Monto día </em></strong></td>
                        <td><%f_busqueda.dibujaCampo("sovi_mmonto_dia")%></td> 
						
						<!-- INICIO CENTRO DE COSTO -->
						
						<TD><em><strong>C. Costo</em></strong></TD>
						<TD><%f_busqueda.dibujaCampo("ccos_ncorr")%></TD>
						
						<!-- FIN CENTRO DE COSTO -->
						
                      </tr>

                      <tr>
                        <td><em><strong>Monto girar Origen </em></strong></td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("sovi_mmonto_origen")%></td>
                      </tr>
                      <tr>
                        <td><em><strong>Monto a girar Pesos </em></strong></td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("sovi_mmonto_pesos")%></td>
                      </tr>
                      <tr>
                        <td><em><strong>Motivo de viatico </em></strong></td>
                        <td colspan="3"><%=f_busqueda.ObtenerValor("sovi_tmotivo")%></td>
                      </tr>					  
                    </table>
								<br/>
								<table width="100%" border="0">
									<tr>
										<td>
										  <strong>V°B° Responsable:</strong>
										  <%
											f_responsable.primero
											while f_responsable.Siguiente
												f_responsable.DibujaCampo("nombre")
											wend%>
											<br/>&nbsp;
										</td>
									</tr>
					  </table>
								
								<%case 5: 
'88888888888888888888888888888888888888888888888888888
' DEVOLUCION ALUMNO

								%>

									<table width="100%" border="1">
									  <tr> 
										<td>Rut a girar </td>
										<td colspan="3"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
									  </tr>
									  <tr> 
										<td> Nombre a girar </td>
										<td colspan="3"><%
										f_busqueda.dibujaCampo("pers_tnombre")
										%> <%
										'f_busqueda.dibujaCampo("v_nombre")
										%></td>
									  </tr>
									  
									<TR>
										<TD COLSPAN="4"><BR>
										</TD>
									</TR>
									  
									  <tr> 
										<td><em><strong>Rut Alumno  </strong></em></td>
										<td colspan="3"><%f_busqueda.dibujaCampo("pers_nrut_alu")%>-<%f_busqueda.dibujaCampo("pers_xdv_alu")%></td>
									  </tr>
									  <tr> 
										<td><em><strong>Nombre Alumno</strong></em></td>
										<td colspan="3"><%f_busqueda.dibujaCampo("pers_tnombre_alu")%></td>
									  </tr>
									  <tr> 
										<td><em><strong>Carrera</strong></em></td>
										<td><%f_busqueda.dibujaCampo("carrera_alu")%></td>
										<TD><em><strong>C. Costo</em></strong></TD>
										<TD><%f_busqueda.dibujaCampo("ccos_ccod")%></TD>
									  </tr>
									  
									<TR>
										<TD COLSPAN="4"><BR>
										</TD>
									</TR>

									  <tr> 
										<td>A&ntilde;o</td>
										<td><%f_busqueda.dibujaCampo("anos_ccod")%></td>
										<td>Monto a girar</td>
										<td><%f_busqueda.dibujaCampo("dalu_mmonto_pesos")%></td>
									  </tr>

									 <tr> 
										<td>Tipo devolucion</td>
										<td colspan="3"><%f_busqueda.dibujaCampo("tdev_ccod")%></td>
									 </tr>
									  
										<!-- Info. Presupuestaria no debe ser obligatorio (quitar) -->
										<!--
									<tr>
									  <td colspan="4">
									  
										<h6>Detalle presupuesto</h6>					
													<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
														<tr bgcolor='#C4D7FF' bordercolor='#999999'>
															<th width="50%">Cod. Presupuesto</th>
															<th width="12%">Mes</th>
															<th width="12%">Año</th>
															<th width="16%">Valor</th>
														</tr>
													<% 
													'ind=0
													'f_presupuesto.primero
													'while f_presupuesto.Siguiente 
													'v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
													%>
													<tr align="left">
														<td>
															<select name="presupuesto[<%=ind%>][cod_pre]" >
																<%
																'f_cod_pre.primero
																'while f_cod_pre.Siguiente 
																'	if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
																'		checkeado="selected"
																'	else
																'		checkeado=""
																'	end if
																%>
																<option value="<%
																'=f_cod_pre.ObtenerValor("cod_pre")
																%>"  
																<%
																'=checkeado
																%> >
																<%
																'=f_cod_pre.ObtenerValor("valor")
																%>
																</option>
																<%
																'wend
																%>
															</select>										</td>
														<td>
														<%
														'f_presupuesto.DibujaCampo("mes_ccod")
														%> </td>
														<td>
														<%
														'f_presupuesto.DibujaCampo("anos_ccod")
														%> </td>
														<td>
														<%
														'f_presupuesto.DibujaCampo("psol_mpresupuesto")
														%> </td>
													  </tr>	
													<%
													'ind=ind+1
													'wend 
													%>
													</table>
									  </td>
									  </tr>
									  -->
									  


									  <tr>
										<td>Motivo de devolución </td>
										<td colspan="3"><%=f_busqueda.ObtenerValor("dalu_tmotivo")%></td>
									  </tr>					  
									</table>
									<br/>
									<table width="100%" border="0">
										<tr>
											<td>
											  <strong>V°B° Responsable:</strong>
											  <%
												f_responsable.primero
												while f_responsable.Siguiente
												  f_responsable.DibujaCampo("nombre")
												wend%>
												<br/>&nbsp;
											</td>
										</tr>
					  </table>								
								
								<%case 6: 
'88888888888888888888888888888888888888888888888888888
								%>
									<table width="100%" border="1">
									  <tr> 
										<td width="11%">Rut Funcionario  </td>
										<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>
										  -<%f_busqueda.dibujaCampo("pers_xdv")%></td>
										<td width="14%">Mes </td>
										<td ><%f_busqueda.dibujaCampo("mes_ccod")%></td>
									  </tr>
									  <tr> 
										<td> Nombre Funcionario </td>
										<td> <%
										f_busqueda.dibujaCampo("pers_tnombre")
										%>&nbsp;<%
										'f_busqueda.dibujaCampo("v_nombre")
										%></td>
										<td>Fecha Pago</td>
										<td width="48%"><%f_busqueda.dibujaCampo("ffij_fpago")%></td>
									  </tr>
									 <tr> 
										<td>Monto a girar Pesos </td>
									   <td><%f_busqueda.dibujaCampo("ffij_mmonto_pesos")%></td>
										<td>Detalle presupuesto</td>
										<td><%f_busqueda.dibujaCampo("ffij_tdetalle_presu")%></td>
									 </tr>
									 <tr> 
										<td> Tipo Moneda </td>
										<td><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
										<td>Total Presupuesto </td>
										<td><%=v_suma_presupuesto%></td>
									  </tr>		
									  <tr>
										   <td colspan="4">
													<h5>Detalle presupuesto</h5>					
												<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
													<tr bgcolor='#C4D7FF' bordercolor='#999999'>
														<th width="63%">Cod. Presupuesto</th>
														<th width="15%">Mes</th>
														<th width="10%">Año</th>
														<th width="12%">Valor</th>

														
														

													</tr> 
													<% ind=0
													f_presupuesto.primero
													while f_presupuesto.Siguiente 
													v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")

														f_cod_pre.primero
														while f_cod_pre.Siguiente 
																				if v_cod_pre=f_cod_pre.ObtenerValor("cod_pre") then
																				valor_final = f_cod_pre.ObtenerValor("valor")
																				end if
														wend
													%>
													<tr align="left">
													<td><%=valor_final%></td>
													<td><%f_presupuesto.DibujaCampo("mes_ccod")%> </td>
													<td><%f_presupuesto.DibujaCampo("anos_ccod")%> </td>
													<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
												  </tr>	
												<%
												ind=ind+1
												wend 
												%>
												</table>							 
										</td>
									  </tr>	
								</table>
								
								<hr> <!-- LINEA -->
								<BR>
			
								<table border ="1" align="center" width="100%">
									<tr valign="top">
										<td>
										<br>
										Yo: <b><%=f_busqueda.obtenerValor("pers_tnombre_aut")%></b>
										<br>
										<br>
										Rut:<b><%=f_busqueda.obtenerValor("pers_nrut_aut")%>-<%=f_busqueda.obtenerValor("pers_xdv_aut")%></b>
										<br>
										<br>
										Autorizo que, en caso de no devolver el Fondo asignado al segundo dia hábil desde cuando se solicita su devolución, la Universidad del Pacifico descuente el monto autorizado de mi remuneracion mensual o de mi indemnizacion por a&ntilde;os de servicios a que tenga derecho, deshaucio y/u otros emolumentos legales.
										<br>
										<br>
										La solicitud de devolución sera efectuada por el departamento de contabilidad de la Universidad del Pacifico via Correo electrónico o Pase Interno.  
										<br>
										  <br>
										  </p>
										<center><p>____________________</p></center>
										<center><p>Firma Trabajador</p></center>
										</td>
									</tr>
									<tr>
										<td>
										<br/>
										  <strong>V°B° Responsable:</strong>
										  <%
											f_responsable.primero
											while f_responsable.Siguiente
										  		f_responsable.DibujaCampo("nombre")
										  	wend%>
											<br/>&nbsp;
										</td>
									</tr>
								</table>
							<%							
							case 7:
'88888888888888888888888888888888888888888888888888888							
' RENDICION DE FONDOS A RENDIR

							%>
                           		<table width="85%" border="1" align="center">
							  <tr> 
								<td width="11%"><strong>Rut funcionario</strong> </td>
								<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
								<td width="14%"><strong>Fecha actividad</strong></td>
								<td ><%f_busqueda.dibujaCampo("fren_factividad")%></td>
							  </tr>
							  <tr> 
								<td> <strong>Nombre funcionario</strong> </td>
								<td><%
								f_busqueda.dibujaCampo("pers_tnombre")
								%>&nbsp;<%
								'f_busqueda.dibujaCampo("v_nombre")
								%></td>
								<td><strong>Total Presupuesto</strong> </td>
								<td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto_ant" value="<%=v_suma_presupuesto%>" size="12" id='total_presupuesto_ant' readonly/></td>
							  </tr>
							  <tr> 
								<td><strong>Monto Solicitado </strong> </td>
								<td><%f_busqueda.dibujaCampo("fren_mmonto")%></td>
								<td><strong>Presupuesto Adicional</strong> </td>
								<td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="
								<%
								'=v_suma_presupuesto
								%>"
								size="12" id='total_presupuesto' readonly/></td>
							  </tr>
							  <tr> 
								<td><strong>C. Costo</strong> </td>
								<td> 
									<%f_busqueda.dibujaCampo("ccos_ncorr")%>
								</td>
								<td> </td>
								<td> </td>
							  </tr>
							  <tr>
							    <td colspan="4">
								<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' >
                                  <tr bgcolor='#C4D7FF' bordercolor='#999999'>
                                    <th width="50%">Cod. Presupuesto</th>
                                    <th width="12%">Mes</th>
                                    <th width="12%">A&ntilde;o</th>
                                    <th width="16%">Valor</th>
                                  </tr>
                                  <% ind=0
											f_presupuesto.primero
											while f_presupuesto.Siguiente 
											v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
											%>
                                  <tr align="left" bgcolor="#FFFFFF">
                                    <td>
                                        <%
										f_cod_pre.primero
										while f_cod_pre.Siguiente 
											if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
												response.Write(f_cod_pre.ObtenerValor("valor"))
											end if
										wend
										%>                                    </td>
                                    <td><%f_presupuesto.DibujaCampo("mes_ccod")%></td>
                                    <td><%f_presupuesto.DibujaCampo("anos_ccod")%></td>
                                    <td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%></td>
                                  </tr>
                                  <%
										ind=ind+1
										wend 
								  %>
                                </table>
                                <br>
                                <table width="100%" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'>
								<tr>
									<td colspan=11><strong>Detalle de Gasto</strong></td>
								</tr>
                                        <tr bgcolor='#C4D7FF' bordercolor='#999999'>
                                          <th>Fecha Docto </th>
                                          <th>Tipo Docto </th>
                                          <th>N&deg;Docto</th>
                                          <th>Rut</th>
                                          <th>Tipo Gasto</th>
                                          <!--<th>Descripcion Gasto</th>-->

                                          <th>Neto</th>
                                          <th>Iva</th>
                                          <th>Exento</th>
                                          <th>Honorarios</th>
                                          <th>Retencion</th>
                                          <th>Líquido</th>
										  
                                        </tr>
                                        <%
								if f_detalle.nrofilas >=1 then
									ind=0
									v_total_rendido=0
									
									while f_detalle.Siguiente
									%>
                                        <tr>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_fdocto")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("tdoc_ccod")%>
										  <%
										  'v_tipo_doc=f_detalle.ObtenerValor("tipo_doc")
										  v_tipo_doc=f_detalle.ObtenerValor("tdoc_ccod")
										  'response.write("v_tipo_doc: "&v_tipo_doc)
										  %>
										  </td>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_ndocto")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("pers_nrut")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("tgas_ccod")%></td>
                                          <!--<td align="center"><%
										  'f_detalle.DibujaCampo("drfr_tdesc")
										  %></td>-->
							  
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_mafecto")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_miva")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_mexento")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_mhonorarios")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_mretencion")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_mdocto")%></td>
										  
                                          <%
										  if (Clng(v_tipo_doc)=Clng(1) or Clng(v_tipo_doc)=Clng(11)) then
											  v_drfr_mafecto		=Clng(v_drfr_mafecto) + Clng(0)
											  v_drfr_mhonorarios		=Clng(v_drfr_mhonorarios) + Clng(f_detalle.ObtenerValor("drfr_mhonorarios"))
										  else
											  v_drfr_mafecto		=Clng(v_drfr_mafecto) + Clng(f_detalle.ObtenerValor("drfr_mafecto"))
											  v_drfr_mhonorarios		=Clng(v_drfr_mhonorarios) + Clng(0)
										  end if
										  
										  'v_bruto		=Clng(v_bruto) + Clng(f_detalle.ObtenerValor("drfr_mdocto"))
										  'v_retencion	=Clng(v_retencion) + Clng(f_detalle.ObtenerValor("drfr_mretencion"))
										  'rendicion= v_bruto+v_retencion

										  rendicion= v_drfr_mafecto+v_drfr_mhonorarios

										  %>
										  
                                        </tr>
                                        <%'v_total_rendido=v_total_rendido+Clng(f_detalle.ObtenerValor("drfr_mdocto"))+Clng(f_detalle.ObtenerValor("drfr_mretencion"))
									ind=ind+1
									wend
								end if
								%>
                                        <tr>
                                          <th colspan="10" width="92%" align="right">Total Rendido</th>
                                          <td width="8%" align="right"><%=rendicion%></td>
                                        </tr>
                                        <tr>
                                          <th colspan="10" align="right">Monto solicitado</th>
                                          <td align="right"><%f_busqueda.dibujaCampo("fren_mmonto")%></td>
                                        </tr>
                                        <tr>
                                          <th colspan="10" align="right">Saldo</th>
                                          <%v_diferencia=Clng(f_busqueda.ObtenerValor("fren_mmonto"))-Clng(rendicion)%>
                                          <td align="right"><%=v_diferencia%></td>
                                        </tr><br><br><br>
                                        <tr>
                                          <td colspan="7"><strong>Detalle devolucion de dinero sobrante</strong><br/>
                                            <table align="center" width="100%" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'>
                                              <tr bgcolor='#C4D7FF' bordercolor='#999999'>
                                                <th >N° Comprobante</th>
                                                <th>Rut</th>
                                                <th>Fecha docto </th>
                                                <th>Descripcion devolucion</th>
                                                <th>Monto</th>
                                              </tr>
                                              <tr>
                                                <td ><%f_devolucion.DibujaCampo("dren_ncomprobante")%></td>
                                                <td><%f_devolucion.DibujaCampo("pers_nrut")%></td>
                                                <td><%f_devolucion.DibujaCampo("dren_fcomprobante")%></td>
                                                <td><%f_devolucion.DibujaCampo("dren_tglosa")%></td>
                                                <td><%f_devolucion.DibujaCampo("dren_mmonto")%></td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
					      	  </tr>			
                              
                              <tr>
									  <td colspan="4">
									  <hr>
											<h5>Detalle presupuesto para diferencia solicitada </h5>
			
											<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'>
												<tr bgcolor='#C4D7FF' bordercolor='#999999'>
													<th width="50%">Cod. Presupuesto</th>
													<th width="12%">Mes</th>
													<th width="12%">Año</th>
													<th width="16%">Valor</th>
												</tr>
											<% ind=0
											f_presupuesto_devol.primero
											while f_presupuesto_devol.Siguiente 
											v_cod_pre=f_presupuesto_devol.ObtenerValor("cod_pre")
											%>
                                  <tr align="left" bgcolor="#FFFFFF">
                                    <td>
                                        <%
										f_cod_pre.primero
										while f_cod_pre.Siguiente 
											if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
												response.Write(f_cod_pre.ObtenerValor("valor"))
											end if
										wend
										%>                                    </td>
                                    <td><%f_presupuesto_devol.DibujaCampo("mes_ccod")%></td>
                                    <td><%f_presupuesto_devol.DibujaCampo("anos_ccod")%></td>
                                    <td><%f_presupuesto_devol.DibujaCampo("psol_mpresupuesto")%></td>
                                  </tr>
                                  <%
										ind=ind+1
										wend 
								  %>
										</table>
									</td>
							  </tr>					  
					</table>                          
                            
                            
                            <%							
							case 8:
'88888888888888888888888888888888888888888888888888888							
							%>
					  <table width="95%" border="1" align="center">
							  <tr> 
								<td width="38%"><strong>Rut funcionario</strong> </td>
								<td width="2%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
								<td width="13%"><strong>Area</strong></td>
								<td><%=area_tdesc%></td>
							  </tr>
							  <tr> 
								<td> <strong>Nombre funcionario</strong> </td>
								<td><%
								f_busqueda.dibujaCampo("pers_tnombre")
								%>&nbsp;<%
								'f_busqueda.dibujaCampo("v_nombre")
								%></td>
								<td><strong>Fecha Pago</strong></td>
								<td width="47%"><%f_busqueda.dibujaCampo("ffij_fpago")%></td>
							  </tr>
							  <tr> 
								<td><strong>Monto Solicitado </strong> </td>
								<td><%f_busqueda.dibujaCampo("ffij_mmonto_pesos")%></td>
								<td><strong>Total Presupuesto</strong> </td>
								<td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="<%=v_suma_presupuesto%>" size="12" id='total_presupuesto' readonly/></td>
							  </tr>
							  <tr>
							  <td colspan="4">
                              <h5>Detalle presupuesto</h5>					
									<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
										<tr bgcolor='#C4D7FF' bordercolor='#999999'>
											<th width="50%">Cod. Presupuesto</th>
											<th width="12%">Mes</th>
											<th width="12%">Año</th>
											<th width="16%">Valor</th>
										</tr>
									<% ind=0
									f_presupuesto.primero
									while f_presupuesto.Siguiente 
									v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
									%>
									<tr align="left" bgcolor="#FFFFFF">
										<td>
												<%
												f_cod_pre.primero
												while f_cod_pre.Siguiente 
													if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
														response.Write(f_cod_pre.ObtenerValor("valor"))
													end if
												wend
												%>
									  </td>
										<td><% f_presupuesto.DibujaCampo("mes_ccod")%> </td>
										<td><%f_presupuesto.DibujaCampo("anos_ccod")%> </td>
										<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
									</tr>	
									<%
									ind=ind+1
									wend 
									%>
									</table>
                                    <br><br><br><br><br><br>
                                    <table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'>
                                      <tr bgcolor='#C4D7FF' bordercolor='#999999'>
                                        <th>Fecha Docto </th>
                                        <th>Tipo Docto </th>
                                        <th>N&deg;Docto</th>
                                        <th>Tipo Gasto</th>
                                        <th>Descripcion Gasto</th>
                                        <th>Rut proveedor</th>
                                        <th>Dv proveedor</th>
                                        <th>Monto</th>
                                      </tr>
                                      <%
								if f_detalle.nrofilas >=1 then
									ind=0
									v_total_rendido=0
									while f_detalle.Siguiente %>
                                      <tr>
                                        <td align="center"><%f_detalle.DibujaCampo("rffi_fdocto")%></td>
                                        <td align="center"><%f_detalle.DibujaCampo("tdoc_ccod")%></td>
                                        <td align="center"><%f_detalle.DibujaCampo("rffi_ndocto")%></td>
                                        <td align="center"><%f_detalle.DibujaCampo("tgas_ccod")%></td>
                                        <td align="center"><%f_detalle.DibujaCampo("rffi_tdesc")%></td>
                                        <td align="center"><%f_detalle.DibujaCampo("pers_nrut")%></td>
                                        <td align="center"><%f_detalle.DibujaCampo("pers_xdv")%></td>
                                        <td align="center"><%f_detalle.DibujaCampo("rffi_mmonto")%></td>
                                      </tr>
                                      <%
									'v_total_rendido=v_total_rendido+Cint(f_detalle.ObtenerValor("rffi_mmonto"))
									v_total_rendido=v_total_rendido+cDbl(f_detalle.ObtenerValor("rffi_mmonto"))
									ind=ind+1
									wend
								end if
								%>
                                      <tr>
                                        <th colspan="7" width="92%" align="right">Total Rendido</th>
                                        <td width="8%" align="center"><%response.Write(v_total_rendido)%></td>
                                      </tr>
                                      <tr>
                                        <th colspan="7" width="92%" align="right">Total Asignado</th>
                                        <td width="8%" align="center"><%response.Write(f_busqueda.ObtenerValor("ffij_mmonto_pesos"))%></td>
                                      </tr>
                                    </table></td>
							  </tr>
                              
					  </table>
					  <%							
							case 9:
'88888888888888888888888888888888888888888888888888888							
							%>

<!-- INICIO CORTE-->

<!-- INICIO TABLA 1 -->

									 <table width="100%" border="1" height="100%">
										  <tr> 
											<td width="11%">Boleta Honorarios: </td>
											<td width="27%"><% if v_boleta = 1 then %> SI <% else %> NO <%end if%></td>
											<td>Tipo Moneda </td>
											<td width="48%"><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
										  </tr>
										  <tr> 
											<td>Rut: </td>
											<td><%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%> </td>
											<td>Atencion: </td>
											<td><%f_busqueda.dibujaCampo("ordc_tatencion")%></td>
										  </tr>
										  <tr>
											<td>Señores: </td>
											<td><%
											f_busqueda.dibujaCampo("pers_tnombre")
											%>&nbsp;<%
											'f_busqueda.dibujaCampo("v_nombre")
											%></td>
											<td>N° Cotizacion: </td>
											<td><%f_busqueda.dibujaCampo("ordc_ncotizacion")%></td> 
										  </tr>					  
										  <tr>
											<td>Direccion: </td>
											<td><%f_busqueda.dibujaCampo("dire_tcalle")%>&nbsp;<%f_busqueda.dibujaCampo("dire_tnro")%></td>
											<td>Cond. Pago:</td>
											<td><%f_busqueda.dibujaCampo("cpag_ccod")%></td>
										  </tr>
										  <tr> 
											<td>Ciudad: </td>
											<td><%f_busqueda.dibujaCampo("ciudad")%></td>
											<td>Observacion:  </td>
											<td><%f_busqueda.dibujaCampo("ordc_tobservacion")%></td>
										  </tr>										  
										  <tr> 
											<td>Telefono: </td>
											<td><%f_busqueda.dibujaCampo("pers_tfono")%></td>
											<td>Monto Orden: </td>
											<td><%f_busqueda.dibujaCampo("ordc_mmonto")%></td>
										  </tr>
										  <tr>
											<td>Fax: </td>
											<td><%f_busqueda.dibujaCampo("pers_tfax")%></td>
											<td>Total Presupuestado: </td>
											<td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="<%=v_total%>" size="12" id='total_presupuesto' readonly/></td> 
										  </tr>	
										  
									</table>

<!-- FIN TABLA 1 -->

					<hr> <!-- LINEA -->
					<BR>

<!-- INICIO TABLA 2 -->

												<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
													<tr bgcolor='#C4D7FF' bordercolor='#999999'>
														<th width="63%">Cod. Presupuesto</th>
														<th width="15%">Mes</th>
														<th width="10%">Año</th>
														<th width="12%">Valor</th>
													</tr> 
													<% ind=0
													f_presupuesto.primero
													while f_presupuesto.Siguiente 
													v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")

														f_cod_pre.primero
														while f_cod_pre.Siguiente 
																				if v_cod_pre=f_cod_pre.ObtenerValor("cod_pre") then
																				valor_final = f_cod_pre.ObtenerValor("valor")
																				end if
														wend
													%>
													<tr align="left">
													<td><%=valor_final%></td>
													<td><%f_presupuesto.DibujaCampo("mes_ccod")%> </td>
													<td><%f_presupuesto.DibujaCampo("anos_ccod")%> </td>
													<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
												  </tr>	
												<%
												ind=ind+1
												wend 
												%>
												</table>

<!-- FIN TABLA 2 -->

									<TABLE><TR><TD><BR></TD></TR></TABLE>

<!-- INICIO TABLA 3 -->
								<table width="100%" border="1">
									<tr> 
										<td width="10%">Solicitado por: </td>
									  <td width="25%"><%f_busqueda.dibujaCampo("ordc_tcontacto")%></td>
										<td width="13%">Lugar Entrega: </td>
										<td> <%f_busqueda.agregacampoparam "sede_ccod","permiso","LECTURA"
										 f_busqueda.dibujaCampo("sede_ccod")%></td>
									</tr>
									<tr> 
										<td>Telefono: </td>
										<td> <%f_busqueda.dibujaCampo("ordc_tfono")%> </td>
										<td>Fecha entrega: </td>
										<td width="30%"> <%f_busqueda.dibujaCampo("ordc_fentrega")%> 
									   </td>
									</tr>
								</table>

<!-- FIN TABLA 3-->

					<hr> <!-- LINEA -->
					<BR>

<!-- INICIO TABLA INTERNA 4 -->

								<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_busqueda_detalle>
								<tr bgcolor='#C4D7FF' bordercolor='#999999'>
									<th width="19%">Tipo Gasto</th>
									<th width="20%">Descripcion</th>
									<th width="10%">C. Costo</th>
									<th width="10%">Cantidad</th>
									<th width="6%">Afecta</th>
									<th width="10%">Precio Unitario</th>
									<th width="10%">Descuento($)</th>
									<th width="15%"><%=segun_boleta%></th>

								</tr>
									<%
										if f_detalle.nrofilas >=1 then
											ind_d=0
											while f_detalle.Siguiente 
%>
											
											<tr>
												<td>
												<%f_detalle.DibujaCampo("tgas_ccod")
												%>
												</td>
																	
												<td><%f_detalle.DibujaCampo("dorc_tdesc")
												%></td>
												<td><%
												f_detalle.agregacampoparam "ccos_ncorr","permiso","LECTURA"
												f_detalle.DibujaCampo("ccos_ncorr")
												%> </td>		
												<td><%f_detalle.DibujaCampo("dorc_ncantidad")
												%> </td>
												<td align="center"><%f_detalle.dibujaBoleano("dorc_bafecta")
												%></td>
										      	<td><%f_detalle.DibujaCampo("dorc_nprecio_unidad")
												%></td>
												<td><%f_detalle.DibujaCampo("dorc_ndescuento")
												%> </td>
												<td><%f_detalle.DibujaCampo("dorc_nprecio_neto")
												%> </td>

											</tr>	
											<%
											ind_d=ind_d+1
											wend
										end if 
									%>
								</table>

<!-- FIN TABLA INTERNA 4 -->
					
							<TABLE><TR><TD><BR></TD></TR></TABLE>

<!-- INICIO TABLA INTERNA 5 -->

						<table border="1" width="100%" >
							<tr>
								<td width="80%" rowspan="<%=row_span%>"><strong><font color="000000" size="1">La factura debe ser extendida en detalle, desglosandose por servicio o articulo con sus respectivos valores unitarios y cantidades, ademas debe incluir una copia de la orden de compra o incluir el numero de esta en la factura.</font></strong></td>
								<th width="10%"><%=txt_neto%></th>
								<td width="10%"><%=v_neto%></td>	
							</tr>
							<tr>
								<th><%=txt_variable%></th>
								<td><%=v_variable%></td>
							</tr>
							<%if Cstr(v_boleta)=2 then %>
							<tr>
								<th>Exento</th>
								<td><%=v_exento%></td>
							</tr>
							<%end if %>
							<tr>
								<th>Total</th>
								<td><%=v_totalizado%></td>
							</tr>
					  </table>
<!-- FIN TABLA INTERNA 5 -->

					  <br>
					  <strong>V°B° Responsable:</strong>
					  <%
						f_responsable.primero
						while f_responsable.Siguiente
							f_responsable.DibujaCampo("nombre") 
						wend
						%>

					<TABLE><TR><TD><BR></TD></TR></TABLE>

<!-- FIN CORTE-->

							<%
							
							End Select
							
							%>

					</td>
					</tr>
                    </table>

<!-- AQUI TERMINA LA TABLA CONTENEDORA DE SUB-TABLAS -->
					  
                      </td>	  
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
			
<!-- AQUI TERMINA LA TABLA MAYOR 2-->

			<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
					  <td><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table>
				  </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>

			<br>
		  </td>
        </tr>
      </table>	


<!-- AQUI TERMINA LA TABLA MAYOR 1 -->

</body>
</html>