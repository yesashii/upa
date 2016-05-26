<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "global/var_globales.asp" -->

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
'FECHA ACTUALIZACION 	:10/06/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			: 71 - 207
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Solicitud de Pago a Proveedor"

vibo_ccod = -1
caso=0

v_ordc_ndocto	= request.querystring("busqueda[0][ordc_ndocto]")
v_sogi_ncorr	= request.querystring("busqueda[0][sogi_ncorr]")
area_ccod		= request.querystring("busqueda[0][area_ccod]")
	
v_rut			= request.querystring("rut")
v_dv			= request.querystring("dv")
v_boleta		= request.querystring("v_boleta")
v_abono			= request.querystring("v_abono")
realiza_abono	= request.querystring("realiza_abono")

'88888888888888888888888888888888888888888888888888888888888888

'RESPONSE.WRITE("v_ordc_ndocto: "&v_ordc_ndocto&"<BR>")
'RESPONSE.WRITE("v_sogi_ncorr: "&v_sogi_ncorr&"<BR>")
'RESPONSE.WRITE("area_ccod: "&area_ccod&"<BR>")
'RESPONSE.WRITE("v_rut: "&v_rut&"<BR>")
'RESPONSE.WRITE("v_dv: "&v_dv&"<BR>")
'RESPONSE.WRITE("v_boleta: "&v_boleta&"<BR>")
'RESPONSE.WRITE("v_abono: "&v_abono&"<BR>")
'RESPONSE.WRITE("realiza_abono: "&realiza_abono&"<BR>")

'RESPONSE.WRITE("<BR>")
'88888888888888888888888888888888888888888888888888888888888888

if cstr(v_ordc_ndocto)="" then
	v_ordc_ndocto=request.querystring("ordc_ndocto")
end if

if cstr(v_sogi_ncorr)="" then
	v_sogi_ncorr=request.querystring("sogi_ncorr")
end if

if area_ccod ="" or EsVacio(area_ccod) then
	area_ccod		= request.querystring("area_ccod")
end if

if v_boleta="" or EsVacio(v_boleta) then
	v_boleta=2	' se establece por defecto el valor de NO uso de boleta honorarios
end if 

if cstr(v_abono)="" then
	v_abono=0
end if

if cstr(realiza_abono)="" then
	realiza_abono=0
end if

'88888888888888888888888888888888888888888888888888888888888888

'RESPONSE.WRITE("v_ordc_ndocto: "&v_ordc_ndocto&"<BR>")
'RESPONSE.WRITE("v_sogi_ncorr: "&v_sogi_ncorr&"<BR>")
'RESPONSE.WRITE("area_ccod: "&area_ccod&"<BR>")
'RESPONSE.WRITE("v_rut: "&v_rut&"<BR>")
'RESPONSE.WRITE("v_dv: "&v_dv&"<BR>")
'RESPONSE.WRITE("v_boleta: "&v_boleta&"<BR>")
'RESPONSE.WRITE("v_abono: "&v_abono&"<BR>")
'RESPONSE.WRITE("realiza_abono: "&realiza_abono&"<BR>")

'RESPONSE.WRITE("<BR>")

'88888888888888888888888888888888888888888888888888888888888888

set botonera = new CFormulario
botonera.carga_parametros "pago_proveedor.xml", "botonera"

set negocio 	= new Cnegocio
set formulario 	= new Cformulario

set conectar 	= new Cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

negocio.inicializa conectar
sede=negocio.obtenerSede
v_usuario = negocio.ObtenerUsuario()

'******************************************************
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "pago_proveedor.xml", "datos_proveedor"
 f_busqueda.Inicializar conectar
 sql_datos_solicitud= "select ''"

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICIO**INICI
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

	if v_sogi_ncorr <> "" then
	
	resul_nombre = 1

'		sql_datos_solicitud= "select isnull(vibo_ccod,0) as vibo_ccod,isnull(sogi_bboleta_honorario,1) as sogi_bboleta_honorario,sogi_ncorr,cpag_ccod,isnull(tmon_ccod,1) as tmon_ccod,area_ccod,pers_nrut,pers_xdv,ordc_ncorr,pers_tnombre,  "&_
'							 " isnull(sogi_mretencion,0) as sogi_mretencion,isnull(sogi_mhonorarios,0) as sogi_mhonorarios,isnull(sogi_mneto,0) as sogi_mneto, "&_
'							 " isnull(sogi_miva,0) as sogi_miva, isnull(sogi_mexento,0) as sogi_mexento, isnull(sogi_mgiro,0) as sogi_mgiro, "&_
'							 " protic.trunc(sogi_fecha_solicitud) as sogi_fecha_solicitud,pers_tnombre as v_nombre, sogi_tobservaciones,sogi_bboleta_honorario "&_
'							 " from ocag_solicitud_giro a, personas c "&_
'						 	 "	where a.pers_ncorr_proveedor=c.pers_ncorr and a.sogi_ncorr="&v_sogi_ncorr

		sql_datos_solicitud= "select TOP 1 isnull(a.vibo_ccod,0) as vibo_ccod, ocag_baprueba, isnull(a.sogi_bboleta_honorario,1) as sogi_bboleta_honorario, a.sogi_ncorr, a.cpag_ccod "&_
						 	 ", isnull(a.tmon_ccod,1) as tmon_ccod, a.area_ccod, c.pers_nrut, c.pers_xdv, a.ordc_ncorr "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
						 	 ", isnull(a.sogi_mretencion,0) as sogi_mretencion, isnull(a.sogi_mhonorarios,0) as sogi_mhonorarios, isnull(a.sogi_mneto,0) as sogi_mneto "&_
						 	 ", isnull(a.sogi_miva,0) as sogi_miva, isnull(a.sogi_mexento,0) as sogi_mexento, isnull(a.sogi_mgiro,0) as sogi_mgiro "&_
						 	 ", protic.trunc(a.sogi_fecha_solicitud) as sogi_fecha_solicitud "&_
						 	 ", a.sogi_tobservaciones, a.sogi_bboleta_honorario, a.audi_tusuario, asgi_tobservaciones, ocag_baprueba_rector "&_
						 	 "from ocag_solicitud_giro a "&_
							 "INNER JOIN personas c "&_
							 "ON a.pers_ncorr_proveedor = c.pers_ncorr "&_
							 "INNER JOIN ocag_autoriza_solicitud_giro d "&_
							" ON a.sogi_ncorr = d.cod_solicitud "&_
						 	 "WHERE a.sogi_ncorr ="&v_sogi_ncorr &" "&_
							 " and d.tsol_ccod = 1 ORDER BY d.audi_fmodificacion DESC"

		'response.Write("1."&sql_datos_solicitud&"<br/>")
		'response.end()

		f_busqueda.Consultar sql_datos_solicitud
		f_busqueda.Siguiente

		audi_tusuario=f_busqueda.obtenerValor("audi_tusuario")		
		area_ccod=f_busqueda.obtenerValor("area_ccod")
		v_rut=f_busqueda.obtenerValor("pers_nrut")
		v_dv=f_busqueda.obtenerValor("pers_xdv")
		ocag_baprueba = f_busqueda.obtenerValor("ocag_baprueba")
		vibo_ccod=f_busqueda.obtenerValor("vibo_ccod")
		
'		sql_detalle_pago= "select b.*, b.dsgi_mdocto as dsgi_mpesos from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b "&_
'					 "	where a.sogi_ncorr=b.sogi_ncorr "&_
'					 "	and a.sogi_ncorr="&v_sogi_ncorr

		sql_detalle_pago= "select b.dsgi_ncorr, b.sogi_ncorr, b.tmon_ccod, b.tdoc_ccod, b.dsgi_ndocto, b.dsgi_mdocto, b.audi_tusuario, b.audi_fmodificacion, b.dsgi_fpago, b.dsgi_mexento "&_
					 ", b.dsgi_mafecto, b.dsgi_mhonorarios, b.dsgi_miva, b.dsgi_mretencion "&_
					 ", b.dsgi_mdocto as dsgi_mpesos, protic.trunc(b.dogi_fecha_documento) as drga_fdocto, b.tdoc_ref_ccod, b.dsgi_ref_ndocto "&_
					 "from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b "&_
					 "where a.sogi_ncorr = b.sogi_ncorr "&_
					 "and a.sogi_ncorr ="&v_sogi_ncorr

		'response.Write "2 sql_detalle_pago "&sql_detalle_pago&"<br>"
		'response.end()

		v_boleta	=	f_busqueda.obtenerValor("sogi_bboleta_honorario")	
		
		f_busqueda.AgregaCampoCons "sogi_bboleta_honorario", cstr(v_boleta)
		
		'RESPONSE.WRITE("2. v_boleta : "&v_boleta&"<BR>")
		
	else
	
		if v_ordc_ndocto <>"" then
		
			resul_nombre = 1
' Esta consulta se ejecuta cuando se presiona el boton buscar en la interface SOLICITUD DE PAGO A PROVEEDOR 
' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

'			sql_datos_orden= " Select top 1 protic.trunc(fecha_solicitud) as sogi_fecha_solicitud,pers_nrut,pers_xdv,*, ordc_tobservacion as sogi_tobservaciones "&_
'							 " from ocag_orden_compra a, personas b where a.pers_ncorr=b.pers_ncorr and a.ordc_ndocto="&v_ordc_ndocto

			sql_datos_orden= " Select top 1 "&_
							 "  a.ordc_ncorr, a.pers_ncorr "&_
							 ", protic.trunc(a.fecha_solicitud) as sogi_fecha_solicitud "&_
							 ", a.ordc_ndocto, a.ordc_tatencion, (case when a.ordc_bboleta_honorario= 1 then (a.ordc_mhonorarios-a.ordc_mretencion) else a.ordc_mmonto end) as ordc_mmonto, a.ordc_ncotizacion "&_
							 ", a.ordc_tobservacion, a.ordc_tobservacion as sogi_tobservaciones "&_
							 ", a.ordc_tcontacto, a.ordc_fentrega "&_
							 ", a.ordc_tfono, a.ordc_bboleta_honorario, a.cpag_ccod, a.sede_ccod, a.audi_tusuario, a.audi_fmodificacion, a.ordc_mretencion, a.ordc_mhonorarios, a.ordc_mneto "&_
							 ", a.ordc_miva "&_
							 ", a.cod_pre, a.ordc_mexento, a.area_ccod, a.tmon_ccod, a.vibo_ccod, a.tsol_ccod, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_fingreso "&_
							 ", a.ocag_generador "&_
							 ", a.ordc_bestado_final, a.ocag_baprueba, a.ocag_baprueba_rector "&_
							 ", b.PERS_NCORR, b.TVIS_CCOD, b.SEXO_CCOD, b.TENS_CCOD, b.COLE_CCOD, b.ECIV_CCOD, b.PAIS_CCOD, b.PERS_BDOBLE_NACIONALIDAD, b.PERS_NRUT, b.PERS_XDV "&_
							 ", b.PERS_TAPE_PATERNO "&_
							 ", b.PERS_TAPE_MATERNO, b.PERS_FNACIMIENTO, b.CIUD_CCOD_NACIMIENTO, b.PERS_FDEFUNCION, b.PERS_TEMPRESA, b.PERS_TFONO_EMPRESA, b.PERS_TCARGO "&_
								" , LTRIM(RTRIM(b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
							 ", b.PERS_TPROFESION, b.PERS_TFONO, b.PERS_TFAX, b.PERS_TCELULAR, b.PERS_TEMAIL, b.PERS_TPASAPORTE, b.PERS_FEMISION_PAS, b.PERS_FVENCIMIENTO_PAS "&_
							 ", b.PERS_FTERMINO_VISA "&_
							 ", b.PERS_NNOTA_ENS_MEDIA, b.PERS_TCOLE_EGRESO, b.PERS_NANO_EGR_MEDIA, b.PERS_TRAZON_SOCIAL, b.PERS_TGIRO, b.PERS_TEMAIL_INTERNO, b.NEDU_CCOD "&_
							 ", b.IFAM_CCOD, b.ALAB_CCOD "&_
							 ", b.ISAP_CCOD, b.FFAA_CCOD, b.PERS_TTIPO_ENSENANZA, b.PERS_TENFERMEDADES, b.PERS_TMEDICAMENTOS_ALERGIA, b.AUDI_FMODIFICACION "&_
							 ", b.ciud_nacimiento "&_
							 ", b.regi_particular, b.ciud_particular, b.pers_bmorosidad, b.sicupadre_ccod, b.sitocup_ccod, b.tenfer_ccod, b.descrip_tenfer, b.trabaja, b.pers_temail2  "&_
							 "from ocag_orden_compra a, personas b "&_
							 "where a.pers_ncorr = b.pers_ncorr "&_
							 "and a.ordc_ndocto ="&v_ordc_ndocto

		'response.Write("3 sql_datos_orden: "&sql_datos_orden&"<br>")
		'response.end()
	
			f_busqueda.Consultar sql_datos_orden
			
			f_busqueda.Siguiente
			
			nombre_persona = f_busqueda.obtenerValor("pers_tnombre")
			
			'response.write("nombre_persona: "&nombre_persona&"<br>")
			
			bestado_final = f_busqueda.obtenerValor("ordc_bestado_final")
			v_ord_ncorr = f_busqueda.obtenerValor("ordc_ncorr")
			vibo_ccod = f_busqueda.obtenerValor("vibo_ccod")
			ocag_baprueba = f_busqueda.obtenerValor("ocag_baprueba")
			ocag_baprueba_rector = f_busqueda.obtenerValor("ocag_baprueba_rector")
			
			'response.write("bestado_final: "&bestado_final&"<br>")
			'response.write("v_ord_ncorr: "&v_ord_ncorr&"<br>")
			'response.write("vibo_ccod: "&vibo_ccod&"<br>")
			'response.write("ocag_baprueba: "&ocag_baprueba&"<br>")
			'response.write("ocag_baprueba_rector: "&ocag_baprueba_rector&"<br>")
			
			'if nombre_persona <> "" then
			if v_ord_ncorr <> "" then
			
			'SE GENERA UN PAGO PROVEEDOR DESDE UNA ORDEN DE COMPRA
				
				if	(vibo_ccod="11" and ocag_baprueba="1" and ocag_baprueba_rector="1") or (vibo_ccod="6" and ocag_baprueba="1" and ocag_baprueba_rector="2") then

					f_busqueda.AgregaCampoCons "pers_tnombre", f_busqueda.obtenerValor("pers_tnombre")
					f_busqueda.AgregaCampoCons "sogi_mgiro", f_busqueda.obtenerValor("ordc_mmonto")
					f_busqueda.AgregaCampoCons "cpag_ccod", f_busqueda.obtenerValor("cpag_ccod")
					f_busqueda.AgregaCampoCons "tmon_ccod", f_busqueda.obtenerValor("tmon_ccod")
					v_boleta	=	f_busqueda.obtenerValor("ordc_bboleta_honorario")
					
					v_muestra_detalle = 1
					
					'realiza_abono=1
					
				else
					'response.Write(3)
					response.write("<script>alert('Orden de Compra no autorizada');</script>")
					sql_datos_orden= "select ''"
					f_busqueda.Consultar sql_datos_orden
					
				end if
			else
				'response.Write(4)
				response.write("<script>alert('No se encontro Orden de Compra');</script>")
				'response.Clear()
				'sql_detalle_pago="select 0 as dsgi_mdocto,0 as dsgi_mexento,0 as dsgi_mafecto,0 as dsgi_miva,0 as dsgi_mhonorarios,0 as dsgi_mretencion "
		
			end if
			
			'RESPONSE.WRITE("2. v_boleta : "&v_boleta&"<BR>")
			
			'area_ccod	=	f_busqueda.obtenerValor("area_ccod")
		else
			  'f_busqueda.Consultar "select '' "
			  f_busqueda.Consultar "select '' ,0 sogi_mgiro"
			  f_busqueda.Siguiente
		end if
		
		'RESPONSE.WRITE("v_muestra_detalle: "&v_muestra_detalle&"<BR>")
		
		if (v_muestra_detalle = 1) then

'			sql_detalle_pago= "select b.dsgi_ncorr, b.sogi_ncorr, b.tmon_ccod, b.tdoc_ccod, b.dsgi_ndocto, b.dsgi_mdocto, b.audi_tusuario, b.audi_fmodificacion, b.dsgi_fpago, b.dsgi_mexento "&_
'					 ", b.dsgi_mafecto, b.dsgi_mhonorarios, b.dsgi_miva, b.dsgi_mretencion "&_
'					 ", b.dsgi_mdocto as dsgi_mpesos, protic.trunc(b.dogi_fecha_documento) as drga_fdocto "&_
'					 "from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b "&_
'					 "where a.sogi_ncorr = b.sogi_ncorr "&_
'					 "and a.sogi_ncorr ="&v_ord_ncorr
					 
			sql_detalle_pago="select 0 as dsgi_mdocto,0 as dsgi_mexento,0 as dsgi_mafecto,0 as dsgi_miva,0 as dsgi_mhonorarios,0 as dsgi_mretencion "

		else
			sql_detalle_pago="select 0 as dsgi_mdocto,0 as dsgi_mexento,0 as dsgi_mafecto,0 as dsgi_miva,0 as dsgi_mhonorarios,0 as dsgi_mretencion "
		end if

		'response.Write("3. "&sql_detalle_pago&"<br>")
		
		f_busqueda.AgregaCampoCons "sogi_bboleta_honorario", cstr(v_boleta)
	end if

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN**FIN
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

set f_abono = new CFormulario
f_abono.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_abono.inicializar conectar

if v_ord_ncorr="" then
	sql_f_abono= " SELECT '' AS ordc_ncorr"
else
	sql_f_abono= " SELECT ordc_ncorr FROM ocag_solicitud_giro WHERE ordc_ncorr ="&v_ord_ncorr
end if

f_abono.consultar sql_f_abono
f_abono.Siguiente

existe_f_abono = f_abono.obtenerValor("ordc_ncorr")

if existe_f_abono="" then
	existe_f_abono=0
else
	existe_f_abono=1
end if

'RESPONSE.WRITE("existe_f_abono: "&existe_f_abono&"<BR><BR>")

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

'response.Write("<pre>"&sql_datos_solicitud&"</pre>")

if v_rut<>"" then
	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas.inicializar conexion
'	f_personas.inicializar conectar
	
	'sql_datos_persona= " Select top 1 codaux as pers_nrut,NomAux as pers_tnombre, NomAux as v_nombre "&_
	'				   	" from softland.cwtauxi a "&_
	'				   	" where CodAux='"&v_rut&"'"
						
	sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
											" from softland.cwtauxi where cast(CodAux as varchar)='"&v_rut&"'"

'	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
'					   	" FROM PERSONAS "&_
'					   	" WHERE PERS_NRUT='"&v_rut&"'"
		
	f_personas.consultar sql_datos_persona
	f_personas.Siguiente
	
	f_busqueda.AgregaCampoCons "pers_nrut", v_rut
	f_busqueda.AgregaCampoCons "pers_xdv", v_dv
	f_busqueda.AgregaCampoCons "area_ccod", area_ccod
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas.obtenerValor("v_nombre")
	
	nombre = f_personas.obtenerValor("v_nombre")
	v_pers_tnombre = f_personas.obtenerValor("pers_tnombre")
	
	if nombre <> "" then
		resul_nombre = 1
	else 
		resul_nombre = 0	
	end if
	
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'88 INICIO
	
	if v_pers_tnombre="" then
	
	set f_personas2 = new CFormulario
	f_personas2.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas2.inicializar conectar

	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
					   	"FROM PERSONAS "&_
					   	"WHERE PERS_NRUT='"&rut&"'"
	
	f_personas2.consultar sql_datos_persona
	f_personas2.Siguiente
						
	v_pers_tnombre = f_personas2.obtenerValor("pers_tnombre")
						
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas2.obtenerValor("pers_tnombre")
	
	end if
	'88 FIN
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

end if


 
if f_busqueda.nroFilas >=1 then
	v_ordc_ndocto=f_busqueda.obtenerValor("ordc_ncorr")
	v_area_ccod=f_busqueda.obtenerValor("area_ccod")
	
    'RESPONSE.WRITE("1 VARIABLE "&v_ordc_ndocto&"<BR>")
	
end if

'RESPONSE.WRITE("1 VARIABLE "&v_ordc_ndocto&"<BR>")

' Buscador de la orden de compra
 set f_buscador = new CFormulario
 f_buscador.Carga_Parametros "pago_proveedor.xml", "buscador"
 f_buscador.Inicializar conectar
 f_buscador.Consultar " select '' "
 f_buscador.Siguiente
 f_buscador.AgregaCampoCons "ordc_ndocto", v_ordc_ndocto
 f_buscador.AgregaCampoCons "area_ccod", v_area_ccod

'' 88888888888888888888888888888888888888888888888888888888888
' 2013-06-28
set f_detalle_pago_1 = new CFormulario
f_detalle_pago_1.carga_parametros "pago_proveedor.xml", "detalle_giro_1"
f_detalle_pago_1.inicializar conectar

f_detalle_pago_1.Consultar sql_detalle_pago

'' 88888888888888888888888888888888888888888888888888888888888

set f_detalle_pago = new CFormulario
f_detalle_pago.carga_parametros "pago_proveedor.xml", "detalle_giro"
f_detalle_pago.inicializar conectar

f_detalle_pago.Consultar sql_detalle_pago
detalle_pago=f_detalle_pago.nrofilas

v_suma_doctos=0
while f_detalle_pago.Siguiente
	v_suma_doctos= Clng(v_suma_doctos) + Clng(f_detalle_pago.obtenerValor("dsgi_mdocto"))
wend


 set f_detalle = new CFormulario
 	f_detalle.Carga_Parametros "pago_proveedor.xml", "detalle_producto"
 	f_detalle.Inicializar conectar

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'INICIO **  INICIO **  INICIO **  INICIO **  INICIO **  INICIO **  INICIO **  INICIO **  INICIO **  INICIO **  INICIO **  IN

 	if v_ordc_ndocto<>"" then
	
	'PAGO DE PROVEEDOR DESDE UNA ORDEN DE COMPRA
	
		 if v_sogi_ncorr<>"" then
		 
			'RESPONSE.WRITE("ENTRO: 1 v_sogi_ncorr: "&v_sogi_ncorr&"<BR><BR>")
						
			sql_detalle=" SELECT sogi_ncorr, ordc_ncorr, cod_solicitud, tgas_ccod, dorc_tdesc, ccos_ncorr "&_
						" , dorc_ncantidad, tmon_ccod "&_
						" , MAX(dorc_nprecio_unidad) AS dorc_nprecio_unidad "&_
						" , dorc_ndescuento "&_
						" , MAX(dorc_nprecio_neto) AS dorc_nprecio_neto "&_
						" , dorc_bafecta, dorc_abono "&_
						" , SUM(ISNULL(dorc_monto_abono, 0)) AS dorc_monto_abono "&_
						" , (MAX(dorc_nprecio_neto) - SUM(ISNULL(dorc_monto_abono, 0))) AS saldo "&_
						" , (MAX(dorc_nprecio_neto) - SUM(ISNULL(dorc_monto_abono, 0))) AS v_saldo "&_
						" FROM ocag_detalle_solicitud_ag  "&_
						" where cast(sogi_ncorr as varchar)='"&v_sogi_ncorr&"' "&_		
						" GROUP BY sogi_ncorr, ordc_ncorr, cod_solicitud, tgas_ccod, dorc_tdesc, ccos_ncorr "&_
						" , dorc_ncantidad, tmon_ccod "&_
						" , dorc_ndescuento "&_
						" , dorc_bafecta, dorc_abono "

			'sql_gasto=" select ISNULL(dorc_abono,0) AS v_abono "&_
			'				" , SUM(ISNULL(dorc_monto_abono,0)) AS MONTO_ABONADO "&_
			'				" , MAX(ISNULL(dorc_nprecio_neto,0)) - SUM(ISNULL(dorc_monto_abono,0)) AS SALDO_DEUDA "&_
			'				" FROM ocag_detalle_solicitud_ag "&_
			'				" WHERE sogi_ncorr='"&v_sogi_ncorr&"' "&_
			'				" GROUP BY dorc_abono, dorc_nprecio_neto"
							
			sql_gasto=" select ISNULL(dorc_abono,0) AS v_abono  "&_
						" , SUM(ISNULL(dorc_monto_abono,0)) AS MONTO_ABONADO  "&_
						" , SUM(ISNULL(dorc_nprecio_neto,0)) - SUM(ISNULL(dorc_monto_abono,0)) AS SALDO_DEUDA  "&_
						" FROM ocag_detalle_solicitud_ag  "&_
						" WHERE cast(sogi_ncorr as varchar)='"&v_sogi_ncorr&"' "&_		
						" GROUP BY dorc_abono "
							
			caso=1
			'OTRO ABONO
			realiza_abono=1
				
		else
		
			'RESPONSE.WRITE("ENTRO: 2 v_sogi_ncorr: "&v_sogi_ncorr&"<BR><BR>")
			
			if existe_f_abono=0 then
			
			' NUEVO DESDE UNA OC ++ PRIMER ABONO
			
'				sql_detalle="select "&_
'							"   dorc_nprecio_neto-protic.ocag_total_pago_proveedor(ordc_ncorr,tgas_ccod,ccos_ncorr,dorc_tdesc,'','T') as saldo "&_
'							" , dorc_nprecio_neto-protic.ocag_total_pago_proveedor(ordc_ncorr,tgas_ccod,ccos_ncorr,dorc_tdesc,'','T') as v_saldo "&_
'							" , dorc_ncorr, ordc_ncorr, tgas_ccod, dorc_tdesc, ccos_ncorr, dorc_ncantidad, tmon_ccod, dorc_nprecio_unidad, dorc_ndescuento, dorc_nprecio_neto "&_
'							" , audi_tusuario, audi_fmodificacion, dorc_bafecta "&_
'							" from ocag_detalle_orden_compra "&_
'							" where cast(ordc_ncorr as varchar)='"&v_ordc_ndocto&"'"

				sql_detalle="select "&_
							"   dorc_nprecio_neto-protic.ocag_total_pago_proveedor(ordc_ncorr,tgas_ccod,ccos_ncorr,dorc_tdesc,'','T') as saldo "&_
							" , dorc_nprecio_neto-protic.ocag_total_pago_proveedor(ordc_ncorr,tgas_ccod,ccos_ncorr,dorc_tdesc,'','T') as v_saldo "&_
							" , dorc_ncorr, ordc_ncorr, tgas_ccod, dorc_tdesc, ccos_ncorr, dorc_ncantidad, tmon_ccod, dorc_nprecio_unidad, dorc_ndescuento, dorc_nprecio_neto "&_
							" , audi_tusuario, audi_fmodificacion, dorc_bafecta "&_
							" from ocag_detalle_orden_compra "&_
							" where cast(ordc_ncorr as varchar)='"&v_ordc_ndocto&"'"

'				sql_gasto=" SELECT ISNULL(B.dorc_abono,0) AS v_abono, SUM(ISNULL(B.dorc_monto_abono,0)) AS MONTO_ABONADO  "&_
'							" , SUM((ISNULL(A.dorc_nprecio_neto,0) - ISNULL(B.dorc_monto_abono,0))) AS SALDO_DEUDA "&_
'							" FROM ocag_detalle_orden_compra A  "&_
'							" LEFT OUTER JOIN ocag_detalle_solicitud_ag B "&_
'							" ON A.ordc_ncorr=B.ordc_ncorr WHERE cast(A.ordc_ncorr as varchar)='"&v_ordc_ndocto&"' "&_
'							" group by B.dorc_abono "			
							
				sql_gasto=" SELECT MAX(X.v_abono) AS v_abono, SUM(X.MONTO_ABONADO) AS MONTO_ABONADO, SUM(X.SALDO_DEUDA) AS SALDO_DEUDA "&_
							" FROM ( "&_
							" SELECT ISNULL(B.dorc_abono,0) AS v_abono  "&_
							" , SUM(ISNULL(B.dorc_monto_abono,0)) AS MONTO_ABONADO  "&_
							" , CASE WHEN A.dorc_bafecta=1  "&_
							" THEN SUM(ISNULL(A.dorc_nprecio_neto,0) + CAST(ROUND((ISNULL(A.dorc_nprecio_neto,0) * 0.19), 0) AS NUMERIC) - ISNULL(B.dorc_monto_abono,0)) "&_
							" ELSE SUM(ISNULL(A.dorc_nprecio_neto,0) - ISNULL(B.dorc_monto_abono,0))  "&_
							" END AS SALDO_DEUDA   "&_
							" FROM ocag_detalle_orden_compra A  "&_
							" LEFT OUTER JOIN ocag_detalle_solicitud_ag B  "&_
							" ON A.ordc_ncorr=B.ordc_ncorr  "&_
							" WHERE cast(A.ordc_ncorr as varchar)='"&v_ordc_ndocto&"' group by A.dorc_bafecta, B.dorc_abono  "&_
							" ) AS X"	

			else
	
			' NUEVO DESDE UNA OC ++ PRIMER SEGUNDO O MAS
			
			sql_detalle=" SELECT  "&_
  						" MAX(sogi_ncorr) AS sogi_ncorr "&_
						" , ordc_ncorr "&_
						" , MAX(cod_solicitud) AS cod_solicitud "&_
						" , tgas_ccod, dorc_tdesc, ccos_ncorr , dorc_ncantidad, tmon_ccod  "&_
						" , MAX(dorc_nprecio_unidad) AS dorc_nprecio_unidad , dorc_ndescuento  "&_
						" , MAX(dorc_nprecio_neto) AS dorc_nprecio_neto , dorc_bafecta, dorc_abono  "&_
						" , SUM(ISNULL(dorc_monto_abono, 0)) AS dorc_monto_abono  "&_
						" , (MAX(dorc_nprecio_neto) - SUM(ISNULL(dorc_monto_abono, 0))) AS saldo  "&_
						" , (MAX(dorc_nprecio_neto) - SUM(ISNULL(dorc_monto_abono, 0))) AS v_saldo  "&_
						" FROM ocag_detalle_solicitud_ag where cast(ordc_ncorr as varchar)='"&v_ordc_ndocto&"' "&_		
						" GROUP BY ordc_ncorr, tgas_ccod, dorc_tdesc, ccos_ncorr , dorc_ncantidad, tmon_ccod  "&_
						" , dorc_ndescuento ,dorc_nprecio_neto,  dorc_bafecta, dorc_abono "

'			sql_detalle=" SELECT  "&_
'    						" MAX(X.sogi_ncorr) AS sogi_ncorr   "&_
'  						" , X.ordc_ncorr     "&_
'  						" , MAX(X.cod_solicitud) AS cod_solicitud     "&_
'  						" , X.tgas_ccod, X.dorc_tdesc, X.ccos_ncorr, X.dorc_ncantidad, X.tmon_ccod  "&_
'  						" , MAX(X.dorc_nprecio_unidad) AS dorc_nprecio_unidad   "&_
'  						" , X.dorc_ndescuento "&_
'  						" , MAX(X.dorc_nprecio_neto) AS dorc_nprecio_neto  "&_
'  						" , X.dorc_bafecta, X.dorc_abono  "&_
'  						" , SUM(ISNULL(X.dorc_monto_abono, 0)) AS dorc_monto_abono  "&_
'  						" , MAX(X.dorc_nprecio_neto_02) - SUM(X.dorc_monto_abono_02) saldo  "&_
'  						" , MAX(X.dorc_nprecio_neto_02) - SUM(X.dorc_monto_abono_02) v_saldo  "&_
'  						" FROM ( "&_
'  						" SELECT  "&_
'  						"   A.sogi_ncorr, A.ordc_ncorr, A.cod_solicitud, A.tgas_ccod, A.dorc_tdesc "&_
'  						" , A.ccos_ncorr, A.dorc_ncantidad, A.tmon_ccod, A.dorc_nprecio_unidad, A.dorc_ndescuento  "&_
'  						" , A.dorc_nprecio_neto, A.dorc_bafecta, A.dorc_abono  "&_
'  						" , ISNULL(A.dorc_monto_abono, 0) AS dorc_monto_abono  "&_
'  						" , CASE WHEN A.dorc_bafecta = 1 "&_
'  						"   THEN SUM( CAST(ROUND((ISNULL(A.dorc_monto_abono,0) * 0.19), 0) AS NUMERIC) + ISNULL(A.dorc_monto_abono,0) ) "&_
'  						"   ELSE SUM( ISNULL(A.dorc_monto_abono,0) ) "&_
'  						"   END AS dorc_monto_abono_02 "&_
'  						" , CASE WHEN A.dorc_bafecta = 1 "&_
'  						"   THEN SUM( CAST(ROUND((ISNULL(A.dorc_nprecio_neto,0) * 0.19), 0) AS NUMERIC) + ISNULL(A.dorc_nprecio_neto,0) ) "&_
'  						"   ELSE SUM( ISNULL(A.dorc_nprecio_neto,0) ) "&_
'  						"   END AS dorc_nprecio_neto_02 "&_
'  						" FROM ocag_detalle_solicitud_ag A  "&_
'  						" WHERE CAST(ordc_ncorr as varchar) ='"&v_ordc_ndocto&"' "&_	
'  						" GROUP BY A.sogi_ncorr, A.ordc_ncorr, A.cod_solicitud, A.tgas_ccod, A.dorc_tdesc, A.ccos_ncorr  "&_
'  						" , A.dorc_ncantidad, A.tmon_ccod, A.dorc_nprecio_unidad, A.dorc_ndescuento, A.dorc_nprecio_neto  "&_
'  						" , A.dorc_bafecta, A.dorc_abono, A.dorc_monto_abono "&_
'  						" ) AS X "&_
'  						" GROUP BY X.ordc_ncorr, X.tgas_ccod, X.dorc_tdesc, X.ccos_ncorr, X.dorc_ncantidad  "&_
'  						" , X.tmon_ccod, X.dorc_ndescuento, X.dorc_bafecta, X.dorc_abono  "
						
'			sql_gasto=" SELECT B.v_abono "&_
'						" , SUM(B.dorc_monto_abono) AS MONTO_ABONADO "&_
'						" , SUM(B.dorc_nprecio_neto) - SUM(B.dorc_monto_abono) AS SALDO_DEUDA "&_
'						" FROM ( "&_
'						" SELECT ISNULL(A.dorc_abono,0) AS v_abono  "&_
'						" , SUM(ISNULL(A.dorc_monto_abono,0)) AS dorc_monto_abono "&_
'						" , MAX(ISNULL(A.dorc_nprecio_neto,0)) AS dorc_nprecio_neto "&_
'						" FROM ocag_detalle_solicitud_ag A "&_
'						" WHERE cast(ordc_ncorr as varchar)='"&v_ordc_ndocto&"' "&_		
'						" GROUP BY A.dorc_abono, A.dorc_nprecio_neto "&_
'						" ) AS B  "&_
'						" GROUP BY B.v_abono "
						
			sql_gasto=" SELECT  "&_
						"   X.ordc_ncorr "&_
						" , X.dorc_abono AS v_abono "&_
						" , SUM(X.dorc_monto_abono) AS MONTO_ABONADO "&_
						" , MAX(X.dorc_nprecio_neto) - SUM(X.dorc_monto_abono) AS SALDO_DEUDA "&_
						" from ( "&_
						" SELECT  "&_
						"   A.sogi_ncorr "&_
						" , A.ordc_ncorr "&_
						" , A.dorc_abono "&_
						" , A.dorc_bafecta "&_
						" , CASE WHEN dorc_bafecta = 1 "&_
						"   THEN SUM( CAST(ROUND((ISNULL(A.dorc_monto_abono,0) * 0.19), 0) AS NUMERIC) + ISNULL(A.dorc_monto_abono,0) ) "&_
						"   ELSE SUM( ISNULL(A.dorc_monto_abono,0) ) "&_
						"   END AS dorc_monto_abono "&_
						" , CASE WHEN dorc_bafecta = 1 "&_
						"   THEN SUM( CAST(ROUND((ISNULL(A.dorc_nprecio_neto,0) * 0.19), 0) AS NUMERIC) + ISNULL(A.dorc_nprecio_neto,0) ) "&_
						"   ELSE SUM( ISNULL(A.dorc_nprecio_neto,0) ) "&_
						"   END AS dorc_nprecio_neto "&_
						" FROM ocag_detalle_solicitud_ag A  "&_
						" WHERE CAST(ordc_ncorr as varchar) ='"&v_ordc_ndocto&"' "&_		
						" GROUP BY A.sogi_ncorr, A.ordc_ncorr, A.dorc_abono, A.dorc_bafecta "&_
						" ) AS X "&_
						" GROUP BY X.ordc_ncorr, X.dorc_abono "
							
			end if
							
			caso=2
			' NUEVO DESDE UNA OC
			realiza_abono=1
			
		end if 			
		
	else
			
		if v_sogi_ncorr<>"" then
		
			'RESPONSE.WRITE("ENTRO: 3 v_sogi_ncorr: "&v_sogi_ncorr&"<BR><BR>")

			sql_detalle="select dsag_ncorr, sogi_ncorr, ordc_ncorr, cod_solicitud, tgas_ccod, dorc_tdesc, ccos_ncorr, dorc_ncantidad, tmon_ccod "&_
							" , dorc_nprecio_unidad, dorc_ndescuento, dorc_nprecio_neto, audi_tusuario, audi_fmodificacion, dorc_bafecta "&_
 							" from ocag_detalle_solicitud_ag where cast(sogi_ncorr as varchar) ='"&v_sogi_ncorr&"'"
							
			sql_gasto=" SELECT 0 AS v_abono, 0 AS MONTO_ABONADO, 0 AS SALDO_DEUDA "

			caso=3
			
		else
		
			'RESPONSE.WRITE("ENTRO: 4 v_sogi_ncorr: "&v_sogi_ncorr&"<BR><BR>")
			
			sql_detalle="select 1 as dorc_bafecta,0 as dorc_nprecio_neto,0 as dorc_nprecio_unidad, 0 as dorc_ndescuento,0 as saldo "
			
			sql_gasto=" SELECT 0 AS v_abono, 0 AS MONTO_ABONADO, 0 AS SALDO_DEUDA "

			caso=4
			' NUEVO SIN OC

		end if
		
	end if

'RESPONSE.WRITE("sql_detalle: "&sql_detalle&"<BR><BR>")
'RESPONSE.WRITE("sql_gasto: "&sql_gasto&"<BR><BR>")

'FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN ** FIN
'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

	
	f_detalle.agregaCampoParam "ccos_ncorr","filtro", "pers_nrut="&v_usuario
	f_detalle.agregaCampoParam "tgas_ccod","destino", " ( Select b.tgas_ccod,ltrim(rtrim(tgas_tdesc )) as tgas_tdesc "&_
				"	from ocag_perfiles_areas_usuarios a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c "&_
				"	where a.pers_nrut="&v_usuario&" "&_
				"	and a.pare_ccod=b.pare_ccod "&_
				"	and b.tgas_ccod=c.tgas_ccod  ) as tabla "
	f_detalle.consultar sql_detalle
	filas_detalle= f_detalle.nrofilas

'8888888888888888888888888888888888888888888888888888888888888

	'RESPONSE.WRITE("caso: "&caso&"<BR><BR>")

	set f_saldo = new CFormulario
	f_saldo.Carga_Parametros "pago_proveedor.xml", "datos_proveedor"
	f_saldo.inicializar conectar

	f_saldo.consultar SQL_GASTO
	f_saldo.Siguiente
	
	IF (caso=1) OR (caso=2 AND existe_f_abono=1) OR (caso=3) then
	'RESPONSE.WRITE("entro 1: "&"<BR><BR>")
		v_abono = Clng(f_saldo.obtenerValor("v_abono"))
	end if
	
	v_monto_abonado = Clng(f_saldo.obtenerValor("MONTO_ABONADO"))
	v_monto_deuda = Clng(f_saldo.obtenerValor("SALDO_DEUDA"))

	'RESPONSE.WRITE("v_monto_abonado: "&v_monto_abonado&"<BR><BR>")
	'RESPONSE.WRITE("v_monto_deuda: "&v_monto_deuda&"<BR><BR>")
	
	IF v_monto_deuda=0 AND caso=2 THEN
		session("mensaje_error")="Ya se abono Totalmente la Orden de compra N°: "&v_ordc_ndocto&" "
		response.Redirect("autorizacion_giros.asp")
	END IF

'8888888888888888888888888888888888888888888888888888888888888
	
'*****************************************************************
'***************	Inicio bases para presupuesto	**************
set f_presupuesto = new CFormulario
f_presupuesto.Carga_Parametros "pago_proveedor.xml", "detalle_presupuesto"
f_presupuesto.Inicializar conectar

'RESPONSE.WRITE("1. v_ordc_ndocto: "&v_ordc_ndocto&"<BR>")
'RESPONSE.WRITE("2. v_sogi_ncorr: "&v_sogi_ncorr&"<BR>")
'RESPONSE.WRITE("3. v_boleta: "&v_boleta&"<BR>")

'888 ** INICIO ** 88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
IF v_ordc_ndocto<>"" THEN

' GENERAR PAGO DE PROVEEDORES UNA O.C

'	sql_presupuesto="select porc_mpresupuesto as psol_mpresupuesto,* from ocag_presupuesto_orden_compra where cast(ordc_ncorr as varchar)='"&v_ordc_ndocto&"'"
	
	IF CINT(v_boleta)= 1 THEN
	' BOLETA DE HONORARIOS = SI
	
	'Response.write("1. sql_presupuesto: ")

	sql_presupuesto="select psol_mpresupuesto, "&_
									"psol_ncorr AS porc_ncorr, cod_solicitud AS ordc_ncorr, s.cod_pre,(select distinct '('+p.cod_pre+') ' + 'Area('+cast(cast(p.cod_area as numeric) as varchar)+')-' + concepto as valor from presupuesto_upa.protic.presupuesto_upa_2011 p where p.cod_pre collate SQL_Latin1_General_CP1_CI_AS= s.cod_pre) as valor, " &_
					 "mes_ccod, anos_ccod, audi_tusuario, audi_fmodificacion " &_
								" from ocag_presupuesto_solicitud s where cast(cod_solicitud as varchar)='"&v_ordc_ndocto&"' and tsol_ccod=9"
	
	ELSE
	' BOLETA DE HONORARIOS = NO
	
	'Response.write("2. sql_presupuesto: ")
	
	sql_presupuesto="select psol_mpresupuesto as psol_mpresupuesto, "&_
									"psol_ncorr AS porc_ncorr, cod_solicitud AS ordc_ncorr, s.cod_pre,(select distinct '('+p.cod_pre+') ' + 'Area('+cast(cast(p.cod_area as numeric) as varchar)+')-' + concepto as valor from presupuesto_upa.protic.presupuesto_upa_2011 p where p.cod_pre collate SQL_Latin1_General_CP1_CI_AS= s.cod_pre) as valor, " &_
					 "mes_ccod, anos_ccod, audi_tusuario, audi_fmodificacion " &_
								" from ocag_presupuesto_solicitud s where cast(cod_solicitud as varchar)='"&v_ordc_ndocto&"' and tsol_ccod=9"
								
	END IF
	
	f_busqueda.AgregaCampoParam "pers_nrut", "script", "Readonly"
	f_busqueda.AgregaCampoParam "pers_xdv", "script", "Readonly"
	f_busqueda.AgregaCampoParam "cpag_ccod", "deshabilitado", "false"
	f_busqueda.AgregaCampoParam "sogi_bboleta_honorario", "deshabilitado", "true"
ELSE

' GENERAR PAGO DE PROVEEDORES DESDE CERO

	if v_sogi_ncorr<>"" then
		
		'sql_presupuesto="select isnull(psol_mpresupuesto,0) as  psol_mpresupuesto,* from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_sogi_ncorr&"' and tsol_ccod=1"
		
		'Response.write("3. sql_presupuesto: ")
		
		sql_presupuesto="select isnull(psol_mpresupuesto,0) as psol_mpresupuesto "&_
								", psol_ncorr, tsol_ccod, cod_solicitud, cod_pre, mes_ccod, anos_ccod, psol_mpresupuesto, audi_tusuario "&_
								", audi_fmodificacion, psol_brendicion, cod_solicitud_origen "&_
								"from ocag_presupuesto_solicitud "&_
								"where cast(cod_solicitud as varchar)='"&v_sogi_ncorr&"' and tsol_ccod=1"
		
	else
		sql_presupuesto="select 0 as psol_mpresupuesto, '' "
	end if	
	
END IF
'888 ** FIN ** 88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

'Response.write("2. sql_presupuesto: "&sql_presupuesto&"<br>")

f_presupuesto.consultar sql_presupuesto
filas_presu= f_presupuesto.nrofilas

if EsVacio(v_ordc_ndocto) or v_ordc_ndocto="" then ' setea los años por defecto en el año actual en caso de no venir con OC
	'f_presupuesto.AgregaCampoCons "anos_ccod", 2011
	f_presupuesto.AgregaCampoParam "psol_mpresupuesto", "deshabilitado", "false"
	'f_presupuesto.AgregaCampoParam "anos_ccod", "deshabilitado", "false"
	'f_presupuesto.AgregaCampoParam "mes_ccod", "deshabilitado", "false"
	f_presupuesto.AgregaCampoParam "cod_pre", "deshabilitado", "false"

	f_detalle.AgregaCampoParam "tgas_ccod", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_tdesc", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_tdesc", "script", ""
	f_detalle.AgregaCampoParam "ccos_ncorr", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_ncantidad", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_bafecta", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_nprecio_unidad", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_ndescuento", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_nprecio_neto", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_nprecio_neto", "script", "CalculaTotal(this)"
end if

'if filas_presu>=1 and v_sogi_ncorr>=1 then
if filas_presu>=1 then
	v_suma_presupuesto=0
	while f_presupuesto.Siguiente
		v_suma_presupuesto= Clng(v_suma_presupuesto) + Clng(f_presupuesto.obtenerValor("psol_mpresupuesto"))
	wend
end if

set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "orden_compra.xml", "codigo_presupuesto"
f_cod_pre.inicializar conectar
f_cod_pre.consultar "select '' "

if EsVacio(area_ccod) or area_ccod="" then
	area_ccod		= request.querystring("area_ccod")
end if

'sql_codigo_pre="(select distinct cod_pre, 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto +' ('+cod_pre+')' as valor "&_
'			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
'			    "	where cod_anio=2011 "&_
'				"	and cod_area in (   select distinct area_ccod "&_ 
'				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
'				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
'				" ) as tabla "

if audi_tusuario <> "" then
v_usuario=audi_tusuario
end if

sql_codigo_pre="(select distinct cod_pre, '('+cod_pre+') ' + 'Area('+cast(cast(cod_area as numeric) as varchar)+')-' + concepto as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "

'RESPONSE.WRITE("2. sql_codigo_pre : "&sql_codigo_pre&"<BR>")
				
f_cod_pre.agregaCampoParam "cod_pre","destino", sql_codigo_pre
f_cod_pre.consultar sql_codigo_pre
f_cod_pre.Siguiente

set f_meses = new CFormulario
f_meses.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_meses.inicializar conectar

sql_meses= "Select * from meses"

f_meses.consultar sql_meses


set f_anos = new CFormulario
f_anos.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_anos.inicializar conectar

'sql_anos= "select anos_ccod, case when anos_ccod=year(getdate()) then 1 else 0 end as orden "&_
'			" from anos where anos_ccod between year(getdate())-1 and year(getdate())+1 "&_
'			" order by orden desc "
			
sql_anos= "SELECT mes_ccod, mes_tdesc "&_
				" , CASE WHEN mes_ccod = 1 AND MONTH(GETDATE()) = 12 THEN YEAR(DATEADD(YEAR,1,GETDATE())) "&_
				" WHEN mes_ccod = 12 AND MONTH(GETDATE()) = 1 THEN YEAR(DATEADD(YEAR,-1,GETDATE())) "&_
				" ELSE YEAR(GETDATE()) END anos_ccod "&_
				" , case when "&_
				" CASE WHEN mes_ccod = 1 AND MONTH(GETDATE()) = 12 THEN YEAR(DATEADD(YEAR,1,GETDATE())) "&_
				" WHEN mes_ccod = 12 AND MONTH(GETDATE()) = 1 THEN YEAR(DATEADD(YEAR,-1,GETDATE())) "&_
				" ELSE YEAR(GETDATE()) END=year(getdate()) then 1 else 0 end as orden "&_
				" FROM meses WHERE mes_ccod = MONTH(DATEADD(month,1,GETDATE())) OR mes_ccod = MONTH(GETDATE()) OR mes_ccod = MONTH(DATEADD(month,-1,GETDATE())) "
				
'sql_anos= "SELECT mes_ccod, mes_tdesc "&_
'					" , CASE WHEN mes_ccod = 1 AND MONTH('09/01/2013') = 12 THEN YEAR(DATEADD(YEAR,1,'09/01/2013')) "&_
'					" WHEN mes_ccod = 12 AND MONTH('09/01/2013') = 1 THEN YEAR(DATEADD(YEAR,-1,'09/01/2013')) "&_
'					" ELSE YEAR('09/01/2013') END anos_ccod "&_
'					" , case when "&_
'					" CASE WHEN mes_ccod = 1 AND MONTH('09/01/2013') = 12 THEN YEAR(DATEADD(YEAR,1,'09/01/2013' )) "&_
'					" WHEN mes_ccod = 12 AND MONTH('09/01/2013') = 1 THEN YEAR(DATEADD(YEAR,-1,'09/01/2013')) "&_
'					" ELSE YEAR('09/01/2013') END=year('09/01/2013') then 1 else 0 end as orden "&_
'					" FROM meses "&_
'					" WHERE mes_ccod = MONTH(DATEADD(MONTH,1,'09/01/2013')) "&_
'					" OR mes_ccod = MONTH('09/01/2013') "&_
'					" OR mes_ccod = MONTH(DATEADD(MONTH,-1,'09/01/2013'))"
			
f_anos.consultar sql_anos

'##################################################################


'*****************************************************************
'***************	Inicio bases para detalle	******************

set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.inicializar conectar

sql_tipo_gasto= "Select b.tgas_ccod,ltrim(rtrim(tgas_tdesc )) as tgas_tdesc "&_
				"	from ocag_perfiles_areas_usuarios a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c "&_
				"	where a.pers_nrut="&v_usuario&" "&_
				"	and a.pare_ccod=b.pare_ccod "&_
				"	and b.tgas_ccod=c.tgas_ccod "&_
				"   and b.tgas_ccod not in (1,2,45,158) ORDER BY ltrim(rtrim(tgas_tdesc )) "

f_tipo_gasto.consultar sql_tipo_gasto


set f_centro_costo = new CFormulario
f_centro_costo.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_centro_costo.inicializar conectar
sql_centro_costo=" select a.ccos_ncorr,a.ccos_tcodigo as ccos_tcompuesto,ccos_tdesc "&_ 
					" from ocag_centro_costo a, ocag_permisos_centro_costo b "&_ 
					" where a.ccos_tcodigo=b.ccos_tcodigo "&_ 
					" and pers_nrut="&v_usuario
f_centro_costo.consultar sql_centro_costo


'##################################################################

'*****************************************************************
'***************	Inicio bases para Tipos documentos de Giro	**************

set f_monedas = new CFormulario
f_monedas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_monedas.inicializar conectar
sql_monedas= "Select * from ocag_tipo_moneda"
f_monedas.consultar sql_monedas

set f_tipo_docto = new CFormulario
f_tipo_docto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_docto.inicializar conectar

	if cstr(v_boleta) = 1 then

	sql_tipo_docto= "Select * from ocag_tipo_documento where tdoc_ccod in (1,11)"

	resultado = ("onBlur=\'Alerta_mensaje();\'")
	disabled1 = ("disabled=\'\'")
	disabled2 = ""
	else

	sql_tipo_docto= "Select * from ocag_tipo_documento where tdoc_ccod not in(1,11) order by tdoc_tdesc"

	resultado = ("onBlur=\'referencia();\'")
	disabled1 = ""
	disabled2 = ("disabled=\'\'")
	end if
	
	'RESPONSE.WRITE("2 sql_tipo_docto "&sql_tipo_docto&"<BR>")

f_tipo_docto.consultar sql_tipo_docto

'##################################################################

'*****************************************************************
'***************	Inicio bases para Responsables	**************
set f_responsable = new CFormulario
	f_responsable.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_responsable.inicializar conectar
	sql_responsable= "Select pers_nrut_responsable as pers_nrut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre,a.PERS_TEMAIL as email "&_
					  "	from ocag_responsable_area a, personas b "&_
					  "	where a.pers_nrut_responsable=b.pers_nrut "&_
					  "	and cast(a.pers_nrut as varchar)='"&v_usuario&"'"
	f_responsable.consultar sql_responsable

'##################################################################	

if Cstr(v_boleta)=Cstr(1) then

' BOLETA DE HONORARIOS SI *

	segun_boleta	="Honorario Total (Liquido 0.9)"
	txt_variable	="10% Retencion"
	txt_neto		="Honorarios"
	valor_neto		="sogi_mhonorarios"
	valor_variable	="sogi_mretencion"
	row_span	=3

	if v_sogi_ncorr<>"" then

		v_variable	=f_busqueda.obtenerValor("sogi_mretencion")
		v_neto		=f_busqueda.obtenerValor("sogi_mhonorarios")
		v_total		=f_busqueda.obtenerValor("sogi_mhonorarios")
		
		if EsVacio(v_neto) then 
			v_neto=0
		end if
		
		if EsVacio(v_variable) then 
			v_variable=0
		end if
		
	else

		'v_variable	=f_busqueda.obtenerValor("ordc_mretencion")
		'v_neto		=f_busqueda.obtenerValor("ordc_mhonorarios")
		'v_total		=f_busqueda.obtenerValor("ordc_mhonorarios")
		
		if EsVacio(v_neto) then 
			v_neto=0
		end if
		
		if EsVacio(v_variable) then 
			v_variable=0
		end if		
		
	end if
	
	v_totalizado=Clng(v_neto)-Clng(v_variable)

else

' BOLETA DE HONORARIOS NO *

	segun_boleta	="Precio Neto"
	txt_variable	="19% IVA"
	txt_neto		="Neto"
	valor_neto		="sogi_mneto"
	valor_variable	="sogi_miva"
	row_span		=4
	
	if v_sogi_ncorr<>"" then
		v_neto		=f_busqueda.obtenerValor("sogi_mneto")
		v_variable	=f_busqueda.obtenerValor("sogi_miva")
		v_exento	=f_busqueda.obtenerValor("sogi_mexento")
		v_total		=f_busqueda.obtenerValor("sogi_mgiro")
		
		v_totalizado=Clng(v_neto)+Clng(v_variable)+Clng(v_exento)	

		if EsVacio(v_neto) then 
			v_neto=0
		end if
		
		if EsVacio(v_variable) then 
			v_variable=0
		end if		

		if EsVacio(v_exento) then 
			v_exento=0
		end if
		
		if EsVacio(v_total) then 
			v_total=0
		end if
		
	else
		'v_neto		=f_busqueda.obtenerValor("ordc_mneto")
		'v_variable	=f_busqueda.obtenerValor("ordc_miva")
		'v_exento	=f_busqueda.obtenerValor("ordc_mexento")
		'v_total		=f_busqueda.obtenerValor("ordc_mmonto")
		
		if EsVacio(v_neto) then 
			v_neto=0
		end if
		
		if EsVacio(v_variable) then 
			v_variable=0
		end if		

		if EsVacio(v_exento) then 
			v_exento=0
		end if
		
		if EsVacio(v_total) then 
			v_total=0
		end if

		v_totalizado=v_total		
		
	end if	
	
end if

v_rut = f_busqueda.obtenerValor("pers_nrut")

if v_rut <> "" then
prueba = "(Select o.cpag_ccod,cpag_tdesc from ocag_condiciones_de_pago o " &_
"where o.cpag_ccod in (select c.cpag_ccod from ocag_condiciones_proveedores c where pers_nrut ='"&v_rut&"' and cpag_estado = 1))a"

'response.Write(prueba)

f_busqueda.AgregaCampoParam "cpag_ccod", "destino", prueba

'f_busqueda.dibujaCampo("cpag_ccod")
end if


'1. 88888888888888888888888888888888 ** MUESTRA EL SALDO DISPONIBLE ** 88888888888888888888888888888888 
set f_control_presupuesto = new CFormulario
f_control_presupuesto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_control_presupuesto.inicializar conectar

sql_control_presupuesto= 	" select isnull(pr.cajcod,pa.cajcod) as cod_pre,pa.mes_ccod as mes_presu,isnull(ejecutado,0) as ejecutado,isnull(presupuestado,0) as presupuestado, isnull(presupuestado,0)-isnull(ejecutado,0) as saldo   "&_
							" from "&_
							" (select sum(valor) as presupuestado,cod_pre as cajcod, mes as mes_ccod    "&_
							"     from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013      "&_
							"     where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013 where cod_area= '"&area_ccod&"' )   "&_
							"     group by cod_pre,mes    "&_
							" ) as pa  "&_
							" left outer join "&_
							" (select  isnull(sum(cast(psol_mpresupuesto as numeric)),0) as ejecutado, cod_pre as cajcod, mes_ccod    "&_
							"  from ocag_presupuesto_solicitud  "&_
							" where anos_ccod=2013 "&_
							" and tsol_ccod=1 "&_
							" and cod_pre in (select distinct cod_pre COLLATE SQL_Latin1_General_CP1_CI_AI from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013 where cod_area= '"&area_ccod&"' ) "&_
							" group by cod_pre, mes_ccod "&_
							" ) as  pr   "&_
							" on pa.cajcod=pr.cajcod COLLATE SQL_Latin1_General_CP1_CI_AI "&_
							" and pa.mes_ccod= pr.mes_ccod "&_
							" order by cod_pre, mes_presu "

f_control_presupuesto.consultar sql_control_presupuesto

'response.Write("1. sql_control_presupuesto : "&sql_control_presupuesto&"<br>")

'1. 88888888888888888888888888888888 ** MUESTRA EL SALDO DISPONIBLE ** 88888888888888888888888888888888 


 '##################################################################
' JAIME PAINEMAL 20130909
 
 'DETALLE TIPO DE GASTOS (Cuentas Contables)
set f_mes_anio = new CFormulario
f_mes_anio.Carga_Parametros "pago_proveedor.xml", "busqueda"
f_mes_anio.Inicializar conectar

sql_mes_anio = " SELECT mes_ccod, mes_tdesc "&_ 
						" , CASE "&_ 
						" WHEN mes_ccod = 1 AND MONTH(GETDATE()) = 12 THEN YEAR(DATEADD(YEAR,1,GETDATE())) "&_ 
						" WHEN mes_ccod = 12 AND MONTH(GETDATE()) = 1 THEN YEAR(DATEADD(YEAR,-1,GETDATE())) "&_ 
						" ELSE YEAR(GETDATE()) "&_ 
						" END anos_ccod "&_ 
						" FROM meses "&_ 
						" WHERE mes_ccod = MONTH(DATEADD(month,1,GETDATE())) "&_ 
						" OR mes_ccod = MONTH(GETDATE()) "&_ 
						" OR mes_ccod = MONTH(DATEADD(month,-1,GETDATE()))" 
						
'sql_mes_anio= "SELECT mes_ccod, mes_tdesc "&_
'					" , CASE WHEN mes_ccod = 1 AND MONTH('09/01/2013') = 12 THEN YEAR(DATEADD(YEAR,1,'09/01/2013')) "&_
'					" WHEN mes_ccod = 12 AND MONTH('09/01/2013') = 1 THEN YEAR(DATEADD(YEAR,-1,'09/01/2013')) "&_
'					" ELSE YEAR('09/01/2013') END anos_ccod "&_
'					" , case when "&_
'					" CASE WHEN mes_ccod = 1 AND MONTH('09/01/2013') = 12 THEN YEAR(DATEADD(YEAR,1,'09/01/2013' )) "&_
'					" WHEN mes_ccod = 12 AND MONTH('09/01/2013') = 1 THEN YEAR(DATEADD(YEAR,-1,'09/01/2013')) "&_
'					" ELSE YEAR('09/01/2013') END=year('09/01/2013') then 1 else 0 end as orden "&_
'					" FROM meses "&_
'					" WHERE mes_ccod = MONTH(DATEADD(MONTH,1,'09/01/2013')) "&_
'					" OR mes_ccod = MONTH('09/01/2013') "&_
'					" OR mes_ccod = MONTH(DATEADD(MONTH,-1,'09/01/2013'))"
						
'RESPONSE.WRITE("2. sql_mes_anio "&sql_mes_anio&"<BR>")

f_mes_anio.Consultar sql_mes_anio					

 '##################################################################
 '88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
 'CONSULTA PARA EL ARREGLO

conectar.Ejecuta sql_mes_anio

set rec_carreras = conectar.ObtenerRS

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

Usuario = negocio.ObtenerUsuario()
nombre_solicitante = conectar.ConsultaUno("select protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where cast(pers_nrut as varchar) = '" & Usuario & "'")
tipo_soli = "Pago a Proveedores"
n_soli=v_sogi_ncorr

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

%>


<html>
<head>
<title>Solicitud de Giro</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<style>
.Mimetismo { background-color:#ADADAD;border: 1px #ADADAD solid; font-size:10px; font-style:oblique; font:bold;}
</style>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>


<script language="JavaScript">


function Enviar(){
	//validar campos vacios
	formulario = document.datos;
	v_valor			= formulario.elements["datos[0][sogi_mgiro]"].value; // SOLICITUD DE GIRO
	v_presupuesto	= formulario.total_presupuesto.value;	// PRESUPUESTO
	v_detalle		= formulario.total_detalle.value;		// DETALLE GASTO
	v_total_doctos	= formulario.total_doctos.value;		// TOTAL DOCTOS

	//8888888888888888888888888888888888888888888888888888888888888888888888888888888
	v_abono_total=0;
	v_dsgi_mhonorarios_total=0;	
	v_contador=0;
	v_contador3=0;
	v_abono=0;
	v_abono			= formulario.elements["in_a_check_02"].value;
	//8888888888888888888888888888888888888888888888888888888888888888888888888888888
	
	<% if Cstr(v_boleta)=1 then %>
	
	//Boleta de Honorarios ** INICIO
	//88888888888888888888888888888888888888888888888888888888888888888888888888888888
		v_honorario	= formulario.sogi_mhonorarios.value;	// DETALLE GASTO
		v_retencion	=	eval(Math.round(v_honorario*1.10)-v_honorario);	
		valor_bruto	=	parseInt(v_valor)+parseInt(v_retencion);

		if (v_abono==1) {
		
				v_contador			= formulario.elements["CONTADOR_G"].value;
				v_contador3			= formulario.elements["contador3"].value;
				
				for (x=0;x<v_contador;x++){
				v_abono			= formulario.elements["detalle["+x+"][dorc_monto_abono]"].value;
				v_abono_total=v_abono_total+ parseInt(v_abono);
				}
				
				for (x=0;x<=v_contador3;x++){
				v_dsgi_mhonorarios			= formulario.elements["datos_giro["+x+"][dsgi_mhonorarios]"].value;
				v_dsgi_mhonorarios_total=v_dsgi_mhonorarios_total+ parseInt(v_dsgi_mhonorarios);
				}
				
				if (v_abono_total==v_dsgi_mhonorarios_total) {
							//return true;
				}else{
							alert("El total de Honorarios tiene que ser igual al total de Abonos");
							return false;
				}
				
				if (v_valor==v_detalle) {
							//return true;
				}else{
							alert("El 'Monto girar (Líquido)' tiene que ser igual al 'Líquido' de Abonos");
							return false;
				}
	
		}else
		{
				<!-- ESTA ES LA VALIDACION DE MONTOS EN EL FORMULARIO -->
				if ( (v_valor!=v_total_doctos) || (v_honorario!=v_presupuesto) || (valor_bruto!=v_honorario) ) { 
					//alert("aca 1");
					alert("El monto de la Solicitud de Giro ingresado debe tener las validaciones sobre los totales : \nA) Total documentos igual al monto a girar. \nB) Total de presupuesto igual al detalle gasto \nC) Total a girar y total de documentos debe ser un 10% menor a presupuesto y detalle gasto");
					return false;
				  }
		}
	//Boleta de Honorarios ** FIN
	//88888888888888888888888888888888888888888888888888888888888888888888888888888888
	
	<%else%>
	
	//Ventas Afectas  y Exentas ** INICIO
	//88888888888888888888888888888888888888888888888888888888888888888888888888888888
	
		if (v_abono==1) {
		
				v_contador			= formulario.elements["CONTADOR_G"].value;
				v_contador3			= formulario.elements["contador3"].value;
				
				for (x=0;x<v_contador;x++){
				v_abono			= formulario.elements["detalle["+x+"][dorc_monto_abono]"].value;
				v_abono_total=v_abono_total+ parseInt(v_abono);
				}

				for (x=0;x<=v_contador3;x++){

				v_dsgi_mafecto			= formulario.elements["datos_giro["+x+"][dsgi_mafecto]"].value;
				v_dsgi_mafecto_total=v_dsgi_mafecto_total+ parseInt(v_dsgi_mafecto);
				}

				//alert(v_valor);
				//alert(v_abono_total);
				//alert(v_dsgi_mafecto_total);
				
				//if (v_abono_total==v_dsgi_mafecto_total) {
				if (v_valor==v_detalle) {
							//return true;
				}else{
							alert("El 'Monto girar (Líquido)' tiene que ser igual al 'Líquido' de Abonos");
							return false;
				}
				
		}else{
						<%if v_ordc_ndocto<>"" then %>
						
							if((v_valor!=v_detalle)||(v_valor!=v_total_doctos))
							{
								alert("El monto de la Solicitud de Giro ingresado debe coincidir con el total de: \nA) Total detalle de documentos \nB) Total detalle de gasto \n !No contempla validacion de presupuesto por ser a partir de una O.C.¡");
								return false;
							}
							
						<%else%>
						
							if((v_valor!=v_presupuesto)||(v_valor!=v_detalle)||(v_valor!=v_total_doctos))
							{	
								alert("El monto de la Solicitud de Giro ingresado debe coincidir con el total de: \nA) Total detalle de documentos \nB) Total detalle presupuesto asignado  y \nC) Total detalle de gasto");
								return false;
							}
						
						<%end if%>
	//Ventas Afectas  y Exentas ** FIN
		}
	//88888888888888888888888888888888888888888888888888888888888888888888888888888888
	
	<%end if%>

	//alert("aca 2");

	var select = document.getElementsByTagName("select");
    var select_actuales = select.length -1; //numero de select ya añadidos
		
	var formulario = document.forms["datos"];
	for (var i = 0; i < select_actuales; i++) 
	{
			if(formulario.elements["detalle["+i+"][tgas_ccod]"])
			{
				formulario.elements["datos[0][cpag_ccod]"].disabled=false;
				formulario.elements["datos[0][sogi_bboleta_honorario]"][0].disabled=false;
				formulario.elements["datos[0][sogi_bboleta_honorario]"][1].disabled=false;			
				formulario.elements["detalle["+i+"][tgas_ccod]"].disabled=false;
				formulario.elements["detalle["+i+"][ccos_ncorr]"].disabled=false;
				formulario.elements["detalle["+i+"][dorc_tdesc]"].disabled=false;
				formulario.elements["detalle["+i+"][dorc_ncantidad]"].disabled=false;
				formulario.elements["detalle["+i+"][dorc_ndescuento]"].disabled=false;
				formulario.elements["detalle["+i+"][dorc_nprecio_unidad]"].disabled=false;
				//formulario.elements["detalle["+i+"][dorc_bafecta]"].disabled=false;
			}
			
			if(formulario.elements["presupuesto["+i+"][cod_pre]"])
			{
				formulario.elements["presupuesto["+i+"][cod_pre]"].disabled=false;
	//			formulario.elements["presupuesto["+i+"][mes_ccod]"].disabled=false;
	//			formulario.elements["presupuesto["+i+"][anos_ccod]"].disabled=false;
				formulario.elements["busqueda["+i+"][mes_ccod]"].disabled=false;
				formulario.elements["busqueda["+i+"][anos_ccod]"].disabled=false;
				formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"].disabled=false;
			}
	}
	return true;
}


function GuardarEnviar(){
	//validar campos vacios
	formulario = document.datos;
	v_valor			= formulario.elements["datos[0][sogi_mgiro]"].value; // SOLICITUD DE GIRO
	//alert(v_valor);
	v_presupuesto	= formulario.total_presupuesto.value;	// PRESUPUESTO
	//alert(v_valor);
	v_detalle		= formulario.total_detalle.value;		// DETALLE GASTO
	//alert(v_valor);
	v_total_doctos	= formulario.total_doctos.value;		// TOTAL DOCTOS
	//alert(v_valor);
	
	//8888888888888888888888888888888888888888888888888888888888888888888888888888888
	v_abono_total=0;
	v_dsgi_mhonorarios_total=0;	
	v_dsgi_mafecto_total=0;
	v_contador=0;
	v_contador3=0;
	v_abono=0;
	v_abono			= formulario.elements["in_a_check_02"].value;
	//alert(v_abono);
	//8888888888888888888888888888888888888888888888888888888888888888888888888888888
	
	<% if Cstr(v_boleta)=1 then %>
	
	//Boleta de Honorarios ** INICIO
	//88888888888888888888888888888888888888888888888888888888888888888888888888888888
		v_honorario	= formulario.sogi_mhonorarios.value;	// DETALLE GASTO
		v_retencion	=	eval(Math.round(v_honorario*1.10)-v_honorario);	
		valor_bruto	=	parseInt(v_valor)+parseInt(v_retencion);
		
		if (v_abono==1) {
		
				v_contador			= formulario.elements["CONTADOR_G"].value;
				v_contador3			= formulario.elements["contador3"].value;
				
				for (x=0;x<v_contador;x++){
				v_abono			= formulario.elements["detalle["+x+"][dorc_monto_abono]"].value;
				v_abono_total=v_abono_total+ parseInt(v_abono);
				}

				for (x=0;x<=v_contador3;x++){
				v_dsgi_mhonorarios			= formulario.elements["datos_giro["+x+"][dsgi_mhonorarios]"].value;
				v_dsgi_mhonorarios_total=v_dsgi_mhonorarios_total+ parseInt(v_dsgi_mhonorarios);
				}
				
				if (v_abono_total==v_dsgi_mhonorarios_total) {
							//return true;
				}else{
							alert("El total de Honorarios tiene que ser igual al total de Abonos");
							return false;
				}
				
				if (v_valor==v_detalle) {
							//return true;
				}else{
							alert("El 'Monto girar (Líquido)' tiene que ser igual al 'Líquido' de Abonos");
							return false;
				}
	
		}else
		{
				<!-- ESTA ES LA VALIDACION DE MONTOS EN EL FORMULARIO -->
				if ( (v_valor!=v_total_doctos) || (v_honorario!=v_presupuesto) || (valor_bruto!=v_honorario) ) { 
					alert("El monto de la Solicitud de Giro ingresado debe tener las validaciones sobre los totales : \nA) Total documentos igual al monto a girar. \nB) Total de presupuesto igual al detalle gasto \nC) Total a girar y total de documentos debe ser un 10% menor a presupuesto y detalle gasto");
					return false;
				  }else {
						email();  
						return true;
				  }

		}
	//Boleta de Honorarios ** FIN
	//88888888888888888888888888888888888888888888888888888888888888888888888888888888

	<%else%>	
	
	//Ventas Afectas  y Exentas **  INICIO
	//88888888888888888888888888888888888888888888888888888888888888888888888888888888
	
		if (v_abono==1) {
		
				v_contador			= formulario.elements["CONTADOR_G"].value;
				v_contador3			= formulario.elements["contador3"].value;
				
				for (x=0;x<v_contador;x++){
				v_abono			= formulario.elements["detalle["+x+"][dorc_monto_abono]"].value;
				v_abono_total=v_abono_total+ parseInt(v_abono);
				}

				for (x=0;x<=v_contador3;x++){

				v_dsgi_mafecto			= formulario.elements["datos_giro["+x+"][dsgi_mafecto]"].value;
				v_dsgi_mafecto_total=v_dsgi_mafecto_total+ parseInt(v_dsgi_mafecto);
				}

//				alert(v_valor);
//				alert(v_abono_total);
//				alert(v_dsgi_mafecto_total);

				if (v_valor==v_detalle) {
							//return true;
				}else{
							alert("El 'Monto girar (Líquido)' tiene que ser igual al 'Líquido' de Abonos");
							return false;
				}
				
		}else{
					<%if v_ordc_ndocto<>"" then %>
					
						if((v_valor!=v_detalle)||(v_valor!=v_total_doctos))
						{	
							alert("El monto de la Solicitud de Giro ingresado debe coincidir con el total de: \nA) Total detalle de documentos \nB) Total detalle de gasto \n !No contempla validacion de presupuesto por ser a partir de una O.C.¡");
							return false;
						}else 
						{
							email();  
							return true;
						}
					  
					<%else%>
					
						if((v_valor!=v_presupuesto)||(v_valor!=v_detalle)||(v_valor!=v_total_doctos))
						{
							alert("El monto de la Solicitud de Giro ingresado debe coincidir con el total de: \nA) Total detalle de documentos \nB) Total detalle presupuesto asignado  y \nC) Total detalle de gasto");
							return false;
						}else 
						{
							email();  
							return true;
						}
				
					<%end if%>
	//Ventas Afectas  y Exentas **  FIN
		}
	//88888888888888888888888888888888888888888888888888888888888888888888888888888888
	
	<%end if%>

	//alert("aca 2");

	var select = document.getElementsByTagName("select");
    var select_actuales = select.length -1; //numero de select ya añadidos
	
	//alert(select_actuales);
	
	var formulario = document.forms["datos"];
	
	for (var i = 0; i < select_actuales; i++) 
	{
	
			//alert("CTM 1");
				
			if(formulario.elements["detalle["+i+"][tgas_ccod]"])
			{
				formulario.elements["datos[0][cpag_ccod]"].disabled=false;
				formulario.elements["datos[0][sogi_bboleta_honorario]"][0].disabled=false;
				formulario.elements["datos[0][sogi_bboleta_honorario]"][1].disabled=false;			
				formulario.elements["detalle["+i+"][tgas_ccod]"].disabled=false;
				formulario.elements["detalle["+i+"][ccos_ncorr]"].disabled=false;
				formulario.elements["detalle["+i+"][dorc_tdesc]"].disabled=false;
				formulario.elements["detalle["+i+"][dorc_ncantidad]"].disabled=false;
				formulario.elements["detalle["+i+"][dorc_ndescuento]"].disabled=false;
				formulario.elements["detalle["+i+"][dorc_nprecio_unidad]"].disabled=false;
				//formulario.elements["detalle["+i+"][dorc_bafecta]"].disabled=false;
				
			//alert("CTM 2");
			}
			
			if(formulario.elements["presupuesto["+i+"][cod_pre]"])
			{

			
				formulario.elements["presupuesto["+i+"][cod_pre]"].disabled=false;
	//			formulario.elements["presupuesto["+i+"][mes_ccod]"].disabled=false;
	//			formulario.elements["presupuesto["+i+"][anos_ccod]"].disabled=false;
				formulario.elements["busqueda["+i+"][mes_ccod]"].disabled=false;
				formulario.elements["busqueda["+i+"][anos_ccod]"].disabled=false;
				formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"].disabled=false;
			//alert("CTM 3");
			}
	}
	return true;
}


/* 3. 88888888888888888888888888888888 ** MUESTRA EL SALDO DISPONIBLE ** 88888888888888888888888888888888 */
/*################################################################################*/
/* Genera un arreglo con el monto del presupuesto para cada codigo presupuestario */
arr_presupuesto = new Array();
<%
i=0

f_control_presupuesto.primero
while f_control_presupuesto.Siguiente 

%>
arr_presupuesto[<%=i%>] = new Array();
arr_presupuesto[<%=i%>]["cod_pre"] = '<%=Cstr(f_control_presupuesto.ObtenerValor("cod_pre"))%>';
arr_presupuesto[<%=i%>]["mes_presu"] = '<%=Cstr(f_control_presupuesto.ObtenerValor("mes_presu"))%>';
arr_presupuesto[<%=i%>]["presupuestado"] = '<%=Cstr(f_control_presupuesto.ObtenerValor("presupuestado"))%>';
arr_presupuesto[<%=i%>]["ejecutado"] = '<%=Cstr(f_control_presupuesto.ObtenerValor("ejecutado"))%>';
arr_presupuesto[<%=i%>]["saldo"] = '<%=Cstr(f_control_presupuesto.ObtenerValor("saldo"))%>';
<%
i=i+1
wend%>


//### Actualiza el presupuesto cada vez que cambia de codigo en el select de los codigos presupuestarios
function RevisaPresupuesto(cod_pre, nombre) {
ind	= extrae_indice(nombre);
mes_presu	=	document.datos.elements["busqueda["+ind+"][mes_ccod]"].value;
// recorriendo el arreglo
	for (x=0;x<arr_presupuesto.length;x++){
		
		if((arr_presupuesto[x]["cod_pre"]==cod_pre)&&(arr_presupuesto[x]["mes_presu"]==mes_presu)){
			document.datos.elements["busqueda["+ind+"][saldo]"].value = arr_presupuesto[x]["saldo"];
			document.datos.elements["presupuesto["+ind+"][psol_mpresupuesto]"].value=0;
		}
	}
}

//### Actualiza el presupuesto cada vez que cambia de codigo en el select de los codigos presupuestarios 
function RevisaPresupuestoMes(mes_presu, nombre) {
ind	= extrae_indice(nombre);
cod_pre	=	document.datos.elements["presupuesto["+ind+"][cod_pre]"].value;
// recorriendo el arreglo
	for (x=0;x<arr_presupuesto.length;x++){
		
		if((arr_presupuesto[x]["cod_pre"]==cod_pre)&&(arr_presupuesto[x]["mes_presu"]==mes_presu)){
			document.datos.elements["busqueda["+ind+"][saldo]"].value = arr_presupuesto[x]["saldo"];
			document.datos.elements["presupuesto["+ind+"][psol_mpresupuesto]"].value=0;
		}
	}
}

//### Obtiene el saldo de un presupuesto segun su codigo presupuestario y el mes del año ##
function ObtienePresupuesto(cod_pre, mes_presu) {
var saldo;
// recorriendo el arreglo
	for (x=0;x<arr_presupuesto.length;x++){
		
		if((arr_presupuesto[x]["cod_pre"]==cod_pre)&&(arr_presupuesto[x]["mes_presu"]==mes_presu)){
			saldo = arr_presupuesto[x]["saldo"];
		}
	}
	return saldo;
}

//### Carga el presupuesto disponible por cada codigo+area al momento de cargar la pagina 
function RecorrePresupuesto(){
//alert("ahora ctm");
   form = document.datos;
   nombre_campo='cod_pre';
   variable='presupuesto';
   expr = variable + '\\[[0-9]+\\]\\['+nombre_campo+'\\]';
   exp_reg = new RegExp(expr, 'g') ;
   nro = form.elements.length;
   num =0;
   // busca todos los select cargados en la fila presupuesto
   for( i = 0; i < nro; i++ ) {
	  comp = form.elements[i];
	  str  = form.elements[i].name;

		if(m=str.match(exp_reg)!= null){
	   		ind=extrae_indice(str);
			mes_presu	=	document.datos.elements["busqueda["+ind+"][mes_ccod]"].value;
			v_cod_pre	=	comp.options[form.elements["presupuesto["+ind+"][cod_pre]"].selectedIndex].value;
			document.datos.elements["busqueda["+ind+"][saldo]"].value=ObtienePresupuesto(v_cod_pre, mes_presu);
   		}
	     num += 1;
	  }
}

//### Valida que tenga presupuesto disponible para el codigo presupuestario seleccionado, no necesita validar el mes
function TienePresupuesto(indice){
	var formulario = document.forms["datos"];

	v_valor	    =	formulario.elements["presupuesto["+indice+"][psol_mpresupuesto]"].value;
	v_saldo	    =	formulario.elements["busqueda["+indice+"][saldo]"].value;
	v_cod_pre	=	formulario.elements["presupuesto["+indice+"][cod_pre]"].options[formulario.elements["presupuesto["+indice+"][cod_pre]"].selectedIndex].text;

	if (parseInt(v_valor)>parseInt(v_saldo)){
		alert("El saldo de presupuesto para el codigo "+v_cod_pre+" es inferior al monto que intenta adjudicar");
		formulario.elements["presupuesto["+indice+"][psol_mpresupuesto]"].value=0;
		return false;
	}

}

/*################################################################################*/
/*----------------- FIN ARREGLO PRESUPUESTO --------------------*/
/* 3. 88888888888888888888888888888888 ** MUESTRA EL SALDO DISPONIBLE ** 88888888888888888888888888888888 */

arr_mes_anio = new Array();

<%
rec_carreras.MoveFirst
i = 0
while not rec_carreras.Eof
%>
arr_mes_anio[<%=i%>] = new Array();
arr_mes_anio[<%=i%>]["mes_ccod"] = '<%=rec_carreras("mes_ccod")%>';
arr_mes_anio[<%=i%>]["anos_ccod"] = '<%=rec_carreras("anos_ccod")%>';
<%	
	rec_carreras.MoveNext
	i = i + 1
wend
%>

function Cargar_codigos(formulario, mes_ccod, num)
{

		formulario.elements["busqueda["+num+"][anos_ccod]"].length = 0;

		for (i = 0; i < arr_mes_anio.length; i++)
		{ 
			if (arr_mes_anio[i]["mes_ccod"] == mes_ccod)
			 {
				op = arr_mes_anio[i]["anos_ccod"];
				formulario.elements["busqueda["+num+"][anos_ccod]"].value=op;
			   
			 }
		}
}


function Alerta_mensaje() {
	alert("Nota: En celda 'Honorarios' \ningrese el valor bruto de \nacuerdo al ejemplo: 111.111\n		11.111\n	                 100.000");
}

function crearAjax()
{
    var xmlhttp=false;
    try
    { // para navegadores que no sean Micro$oft
        xmlhttp=new ActiveXObject("Msxml2.XMLHTTP");
    }
    catch(e)
    {
        try
        { // para iexplore.exe XD
            xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch(E) { xmlhttp=false; }
    }
    if (!xmlhttp && typeof XMLHttpRequest!='undefined') { xmlhttp=new XMLHttpRequest(); }
    return xmlhttp;
}

var miArray = new Array()
function valida_numero(valor,num)
{

//alert(valor);
//alert(num);

pers_nrut		=	datos.elements["datos[0][pers_nrut]"].value;
tdoc_ccod		=	datos.elements["datos_giro["+num+"][tdoc_ccod]"].value;

//alert(pers_nrut);
//alert(tdoc_ccod);

//88888888888888888888888888888888888888888888888888888888888
	
	var ajax=crearAjax();
	
    ajax.open("POST", "datos_factura.asp", true);
    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    ajax.send("rut="+pers_nrut+"&valor="+valor);

    ajax.onreadystatechange=function()
    {
        if (ajax.readyState==4)
        {
            var respuesta=ajax.responseXML;
            hhh=respuesta.getElementsByTagName("nombre")[0].childNodes[0].data;
			if (hhh!=0)
			{
			alert("Anteriormente el número de documento \nya fue ingresado por el mismo Proveedor")
			datos.elements["datos_giro["+num+"][dsgi_ndocto]"].value="";
			}
		}
	}

//88888888888888888888888888888888888888888888888888888888888

	if ( tdoc_ccod!=0 )
	{
		miArray[num]=valor
	}
	else
	{
		miArray[num]=""
	}
	
	if ( tdoc_ccod!=0 )
	{
		for (i=0;i<num;i++)
		{
			caso1=miArray[i]
				if ( (caso1==valor) && (caso1!="") )
				{
					alert("No puede ingresar el mismo número de documento")
					datos.elements["datos_giro["+num+"][dsgi_ndocto]"].value="";
				}
		} 
	}
}

function valida_numero2(valor,num)
{

pers_nrut		=	datos.elements["datos[0][pers_nrut]"].value;
tdoc_ccod		=	datos.elements["datos_giro["+num+"][tdoc_ccod]"].value;

	var ajax=crearAjax();
	
    ajax.open("POST", "datos_factura.asp", true);
    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    ajax.send("rut="+pers_nrut+"&valor="+valor);

    ajax.onreadystatechange=function()
    {
        if (ajax.readyState==4)
        {
            var respuesta=ajax.responseXML;
            hhh=respuesta.getElementsByTagName("nombre")[0].childNodes[0].data;
			estado2=false;
			if (hhh==0)
			{
				estado2=true;
			}
		}
	}

	if ( tdoc_ccod!=0 )
	{
		miArray[num]=valor
	}
	else
	{
		miArray[num]=""
	}
	
	if ( tdoc_ccod!=0 )
	{
		estado = false;
		for (i=0;i<num;i++)
		{
			caso1=miArray[i]

				if ( (caso1==valor) && (caso1!="") )
				{
					estado=true;
				}
				
		} 
		
	}
	if(!estado & !estado2){
		alert("Debe ingresar el mismo número de documento que una factura existente")
		datos.elements["datos_giro["+num+"][dsgi_ref_ndocto]"].value="";
	}

}


function ImprimirPagoProveedor(){
	url="imprimir_pp.asp?sogi_ncorr=<%=v_sogi_ncorr%>";
	window.open(url,'ImpresionPP', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');	
}


function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 v_area		=	datos.elements["busqueda[0][area_ccod]"].value;
 if(document.datos.elements["datos[0][sogi_bboleta_honorario]"][0].checked){
	 v_boleta	=	1;
 }else{
	 v_boleta	=	2;
 }
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.datos.elements["datos[0][pers_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   
   IgStringVerificador = '32765432';

   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
	datos.elements["datos[0][pers_xdv]"].value=IgDigitoVerificador;
	//alert(rut+IgDigitoVerificador);
	//_Buscar(this, document.forms['datos'],'', 'r()', 'TRUE');
			document.datos.action= "pago_proveedor.asp?v_boleta="+v_boleta+"&area_ccod="+v_area+"&rut="+texto_rut+"&dv="+IgDigitoVerificador;
			document.datos.method = "post";
			document.datos.submit();
}


function AgregarDetalle(formu){

	formulario = document.datos;
	v_dsgi_ndocto	= formulario.elements["datos[0][dsgi_ndocto]"].value;
	v_dsgi_mdocto	= formulario.elements["datos[0][dsgi_mdocto]"].value;		
	if((v_dsgi_ndocto)&&(v_dsgi_mdocto)){
		document.datos.action="pago_proveedor_detalle_proc.asp";
		document.datos.method="post";
		document.datos.submit();
	}else{
		alert("Debe ingresar un numero y monto de documento valido para agregar un nuevo pago");
	}
}

function EliminaDetalle(){
	document.detalle_doctos.action="pago_proveedor_detalle_elimina_proc.asp";
	document.detalle_doctos.method="post";
	document.detalle_doctos.submit();
}

function Mensaje()
{
	<% 
		if session("mensaje_error")<>"" then
	%>
		alert("<%=session("mensaje_error")%>");
	<%
		session("mensaje_error")=""
		end if
	%>
}

/*****************************************************************************/
/*// PRIMERA TABLA DINAMICA //*/
<%if cint(filas_detalle) >1 then%>
var contador=<%=filas_detalle%>;
<%else%>
var contador=0;
<%end if%>

function validaFila(id, nro,boton)
{
	if (document.datos.elements["detalle["+nro+"][dorc_tdesc]"].value == ''){
	  alert('Debe ingresar una descripcion valida');
	  return false;
	}
	if(document.datos.elements["detalle["+nro+"][dorc_nprecio_unidad]"].value != ''){
		addRow(id, nro, boton );habilitaUltimoBoton();
	}else{
		alert('Debe completar las filas del detalle para ingresar a la orden de compra');
	}
}

function addRow(id, nro, boton ){

contador++;
$("#tb_busqueda_detalle").append("<tr><td><INPUT TYPE=\"checkbox\" class=\"remove\" name=\"detalle["+ contador +"][check]\" value=\""+ contador +"\"  ></td>"+
"<td><select name= \"detalle["+ contador +"][tgas_ccod]\">"+
"	<%f_tipo_gasto.primero%> "+
" <%while f_tipo_gasto.Siguiente %>"+
"<option value=\"<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>\" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_tdesc]\" size=\"10\" ></td>"+
"<td><select name= \"detalle["+ contador +"][ccos_ncorr]\">"+
"<%f_centro_costo.primero%>"+
"	<%while f_centro_costo.Siguiente %>"+
"<option value=\"<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>\" ><%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_ncantidad]\" value=\"0\" size=\"4\" onblur=\"CalculaTotal(this)\" maxlength=\"5\"></td>"+
"<td><INPUT TYPE=\"checkbox\" name=\"_detalle["+ contador +"][dorc_bafecta]\" value=\"1\" size=\"10\" checked=\"checked\" onClick=\"ChequeaValor(this);\" maxlength=\"10\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_nprecio_unidad]\" value=\"0\" size=\"10\" onblur=\"CalculaTotal(this)\" maxlength=\"10\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_ndescuento]\" value=\"0\" size=\"10\" onblur=\"CalculaTotal(this)\" maxlength=\"10\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_nprecio_neto]\" size=\"10\" maxlength=\"10\"></td>"+
<%
if v_abono=1 then
%>
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_abono]\" size=\"10\" maxlength=\"10\"></td>"+
<%
end if
%>
"<td><INPUT class=boton TYPE=\"button\" id=\"agregarlinea\" name=\"agregarlinea\" value=\"+\" onclick=\"validaFila('tb_busqueda_detalle',"+contador+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea\" value=\"-\" onclick=\"eliminaFilas()\"></td></tr>");

//desabilitarUltimoBoton();
document.datos.elements["contador"].value = contador;
}

function eliminaFilas()
{

var Count = 0
$('.remove').each(function(){
   var checkbox = $(this);
   if(checkbox.is(':checked')==true){
	Count++;
   }
});

	if(Count==0){
		alert("Debe seleccionar una fila para eliminar");
	}else{
	deleterow(Count)		
	}

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
		//alert("ha"+cantidadBoton)
	 }
 }
	botones[cantidadBoton].disabled=false;

	if(cantidadBoton>=40){
		botones[cantidadBoton].disabled=true;
	}	
}



function deleterow(Count) {

	if (Count >=1){
	$('#tb_busqueda_detalle').delegate('input:button', 'click', function () {
    $(this).closest('tr').remove();
		habilitaUltimoBoton();
		//desabilitarUltimoBoton();
		//contador--;	
	});
	}		
	
}
//******* FIN PRIMERA TABLA DINAMICA *******//
/*****************************************************************************/



/*****************************************************************************/
//******* SEGUNDA TABLA DINAMICA   *********//


function validaFila2(id, nro,boton){
	if (document.datos.elements["presupuesto["+nro+"][psol_mpresupuesto]"].value >0){ 
		addRow2(id, nro, boton );habilitaUltimoBoton2(); 
	}else{
		alert('Debe ingresar todos los campos del presupuesto que usará');
		return false;
	}
}

<%if filas_presu >0 then%>
var contador2=<%=filas_presu%>-1;
<%else%>
var contador2=0;
<%end if%>

<%f_cod_pre.primero
f_cod_pre.Siguiente%>
valor_saldo=ObtienePresupuesto('<%=f_cod_pre.obtenerValor("cod_pre")%>');

function addRow2(id, nro, boton ){
	contador2++;

$("#tb_presupuesto").append("<tr><td align=\"center\"><INPUT TYPE=\"checkbox\" class=\"remove2\" align=\"center\" name=\"presupuesto["+ contador2 +"][check]\" value=\""+ contador2 +"\"  ></td>"+
"<td><select name= \"presupuesto["+ contador2 +"][cod_pre]\" onChange=\"RevisaPresupuesto(this.value,this.name);\">"+
"<%f_cod_pre.primero%> "+
"<%while f_cod_pre.Siguiente %>"+
"<option value=\"<%=f_cod_pre.ObtenerValor("cod_pre")%>\" ><%=f_cod_pre.ObtenerValor("valor")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td><select name= \"busqueda["+ contador2 +"][mes_ccod]\" onChange=\"Cargar_codigos(this.form, this.value, " +contador2+ "); RevisaPresupuestoMes(this.value,this.name)\">"+
"<%f_anos.primero%>"+
"	<%while f_anos.Siguiente %>"+
"<option value=\"<%=f_anos.ObtenerValor("mes_ccod")%>\" ><%=f_anos.ObtenerValor("mes_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td>"+ 
"<%f_anos.primero%>"+
"<%f_anos.Siguiente%>"+
"<input type=\"text\" name=\"busqueda["+ contador2 +"][anos_ccod]\" value=\"<%=f_anos.ObtenerValor("anos_ccod")%>\" >"+
"</td>"+
"<td><INPUT TYPE=\"text\" name=\"presupuesto["+ contador2 +"][psol_mpresupuesto]\" size=\"10\" onblur=\"SumaTotalPresupuesto(this);\" ></td>"+
"<td><INPUT TYPE=\"text\" class=\"Mimetismo\" name=\"busqueda["+ contador2 +"][saldo]\" size=\"10\" value="+valor_saldo+" readonly ></td>"+
"<td><INPUT class=boton TYPE=\"button\" name=\"agregarlinea2\" value=\"+\" onclick=\"validaFila2('tb_presupuesto',"+contador2+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea2\" value=\"-\" onclick=\"eliminaFilas2()\"></td></tr>");

//desabilitarUltimoBoton2();

document.datos.elements["contador2"].value = contador2;
}

function eliminaFilas2()
{
	var Count = 0
$('.remove2').each(function(){
   var checkbox = $(this);
   if(checkbox.is(':checked')==true){
	Count++;
   }
});

	if(Count==0){
		alert("Debe seleccionar una fila para eliminar");
	}else{
	deleterow2(Count)		
	}
	
	
	habilitaUltimoBoton2();
}

function habilitaUltimoBoton2(){
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


function deleterow2(node){
		if (node >=1){
	$('#tb_presupuesto').delegate('input:button', 'click', function () {
    $(this).closest('tr').remove();
		habilitaUltimoBoton2();
		//desabilitarUltimoBoton2();
		//contador2--;	
	});
	}
	
}

function SumaTotalPresupuesto(valor){

	var formulario = document.forms["datos"];
	v_total_presupuesto = 0;
	v_indice=extrae_indice(valor.name);
	
	TienePresupuesto(v_indice);
	
	for (var i = 0; i <= contador2; i++) {
		if(formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"]){
		v_valor	=	formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"].value;
		//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
			if (v_valor){
				v_total_presupuesto = v_total_presupuesto + parseInt(v_valor);
			}
		}
	}
	datos.elements["total_presupuesto"].value=v_total_presupuesto;

}

//******* FIN SEGUNDA TABLA DINAMICA *******//
/*****************************************************************************/

/*****************************************************************************/
//******* TERCERA TABLA DINAMICA   *********//

function referencia(aux){
	//alert(aux.value);
	nombres = aux.name;
	valor = aux.value;
	nombre = nombres.split("]");
	estado = false;
	if(valor==7){
		estado = true;
	}
	if(estado){
		document.datos.elements[nombre[0]+"][tdoc_ref_ccod]"].disabled = false;
		document.datos.elements[nombre[0]+"][dsgi_ref_ndocto]"].disabled = false;
	}
	estado = false;
}

function validaFila3(id, nro,boton){
	
	if (document.datos.elements["datos_giro["+nro+"][dsgi_mdocto]"].value >0){ 
		addRow3(id, nro, boton );
		habilitaUltimoBoton3(); 
	}else{
		alert('Debe ingresar un monto y un numero mayor a cero Solicitud de Giro');
		return false;
	}
}
<%if detalle_pago >0 then%>
var contador3=<%=detalle_pago%>-1;
<%else%>
var contador3=0;
<%end if%>

function addRow3(id, nro, boton ){
	contador3++;
	$("#tb_doctos").append("<tr><td><INPUT TYPE=\"checkbox\" class=\"remove3\"name=\"datos_giro["+ contador3 +"][check]\" value=\""+ contador3 +"\"  ></td>"+
	"<td><select name= \"datos_giro["+ contador3 +"][tdoc_ccod]\" onBlur=\"referencia(this);\" <%=resultado%> >"+
	"	<%f_tipo_docto.primero%> "+
	" <%while f_tipo_docto.Siguiente %>"+
	"<option value=\"<%=f_tipo_docto.ObtenerValor("tdoc_ccod")%>\" ><%=f_tipo_docto.ObtenerValor("tdoc_tdesc")%></option>"+
	"<%wend%>"+
	"</select></td>"+
"<td><INPUT TYPE=\"text\" name=\"datos_giro["+ contador3 +"][dsgi_ndocto]\" size=\"12\" onblur=\"SumaTotalGiro(this);valida_numero(this.value,"+ contador3 + ");\" ></td>"+
"<td><INPUT TYPE=\"text\" name=\"datos_giro["+ contador3 +"][drga_fdocto]\" size=\"10\" ></td>"+
"<td><INPUT TYPE=\"text\" name=\"datos_giro["+ contador3 +"][dsgi_mafecto]\" size=\"12\" value=\"0\" <%=disabled1%>onblur=\"ConviertePesos(this);SumaTotalGiro(this);\" ></td>"+
"<td><INPUT TYPE=\"text\" name=\"datos_giro["+ contador3 +"][dsgi_miva]\" size=\"8\" value=\"0\" readonly <%=disabled1%> ></td>"+
"<td><INPUT TYPE=\"text\" name=\"datos_giro["+ contador3 +"][dsgi_mexento]\" size=\"12\" value=\"0\" <%=disabled1%> onblur=\"ConviertePesos(this);SumaTotalGiro(this);\" ></td>"+
"<td><INPUT TYPE=\"text\" name=\"datos_giro["+ contador3 +"][dsgi_mhonorarios]\" size=\"12\" value=\"0\" <%=disabled2%>onblur=\"ConviertePesos(this);SumaTotalGiro(this);\" ></td>"+
"<td><INPUT TYPE=\"text\" name=\"datos_giro["+ contador3 +"][dsgi_mretencion]\" size=\"8\" value=\"0\" readonly <%=disabled2%>></td>"+
"<td><INPUT TYPE=\"text\" name=\"datos_giro["+ contador3 +"][dsgi_mdocto]\" size=\"12\" readonly ></td>"+
"<td><select name= \"datos_giro["+ contador3 +"][tdoc_ref_ccod]\" <%=resultado%> disabled >"+
"	<%f_tipo_docto.primero%> "+
" <%while f_tipo_docto.Siguiente %>"+
"<option value=\" <%=f_tipo_docto.ObtenerValor("tdoc_ccod") %>\" ><%=f_tipo_docto.ObtenerValor("tdoc_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td><INPUT TYPE=\"text\" name=\"datos_giro["+ contador3 +"][dsgi_ref_ndocto]\" disabled size=\"12\"></td>"+																				

"<td><INPUT class=boton TYPE=\"button\" name=\"agregarlinea3\" value=\"+\" onclick=\"validaFila3('tb_doctos',"+contador3+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea3\" value=\"-\" onclick=\"eliminaFilas3()\"></td></tr>");

//desabilitarUltimoBoton3();

document.datos.elements["contador3"].value = contador3;
}

function eliminaFilas3()
{
	var Count = 0
$('.remove3').each(function(){
   var checkbox = $(this);
   if(checkbox.is(':checked')==true){
	Count++;
   }
});

	if(Count==0){
		alert("Debe seleccionar una fila para eliminar");
	}else{
	deleterow3(Count)		
	}	
	
	
	habilitaUltimoBoton3();
}

function habilitaUltimoBoton3(){
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


function deleterow3(node){
	
	if (node >=1){
	$('#tb_doctos').delegate('input:button', 'click', function () {
    $(this).closest('tr').remove();
		habilitaUltimoBoton3();
		//desabilitarUltimoBoton3();
		//contador3--;
	});
	}
}

function ConviertePesos(objeto){
	var formulario = document.forms["datos"];
	indice		=	extrae_indice(objeto.name);
	<%if v_boleta="1" then%>
		v_honorarios=	formulario.elements["datos_giro["+indice+"][dsgi_mhonorarios]"].value;
		v_mretencion	=	eval(Math.round(v_honorarios*1.10)-v_honorarios);
		formulario.elements["datos_giro["+indice+"][dsgi_mexento]"].value=0;
		formulario.elements["datos_giro["+indice+"][dsgi_mafecto]"].value=0;
		formulario.elements["datos_giro["+indice+"][dsgi_mretencion]"].value=v_mretencion;
		v_valor		= 	parseInt(v_honorarios)-parseInt(v_mretencion);
		formulario.elements["datos_giro["+indice+"][dsgi_mdocto]"].value=v_valor
	<%else%>
		v_exento	=	formulario.elements["datos_giro["+indice+"][dsgi_mexento]"].value;
		v_afecto	=	formulario.elements["datos_giro["+indice+"][dsgi_mafecto]"].value;
		
		formulario.elements["datos_giro["+indice+"][dsgi_mhonorarios]"].value=0;

		if(v_afecto){
			v_iva	=	eval(Math.round(v_afecto*1.19)-parseInt(v_afecto));
		}else{
			v_iva	= 0
		}
		formulario.elements["datos_giro["+indice+"][dsgi_miva]"].value=v_iva
		v_valor		= 	parseInt(v_iva)+parseInt(v_exento)+parseInt(v_afecto);
		formulario.elements["datos_giro["+indice+"][dsgi_mdocto]"].value=v_valor

	<%end if%>	
}

function SumaTotalGiro(valor){

	var formulario = document.forms["datos"];
	v_total_doctos = 0;
	for (var i = 0; i <= contador3; i++) {
		if(formulario.elements["datos_giro["+i+"][dsgi_mdocto]"]){
			v_valor	=	formulario.elements["datos_giro["+i+"][dsgi_mdocto]"].value;
			//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
			if (v_valor){
				v_total_doctos = v_total_doctos + parseInt(v_valor);
			}
		}
	}
	datos.elements["total_doctos"].value=v_total_doctos;
}

//******* FIN TERCERA TABLA DINAMICA *******//
/*****************************************************************************/


function ValidaSaldo(objeto){
	var formulario = document.forms["datos"];
	indice=extrae_indice(objeto.name);
<%if v_ordc_ndocto<>"" then%>
		v_valor	=	formulario.elements["detalle["+indice+"][dorc_nprecio_neto]"].value;
		v_saldo	=	formulario.elements["detalle["+indice+"][v_saldo]"].value;
		v_diferencia= v_saldo-v_valor;
		if (v_diferencia<0){
			alert("No puede pagar un monto superior al saldo");
			formulario.elements["detalle["+indice+"][dorc_nprecio_neto]"].focus();
			return false;
		}
<%else%>	
	if(indice!=""){
		v_cantidad	=	detalle.elements["detalle["+indice+"][dorc_ncantidad]"].value;
		v_unidad	=	detalle.elements["detalle["+indice+"][dorc_nprecio_unidad]"].value;		
		v_descuento	=	detalle.elements["detalle["+indice+"][dorc_ndescuento]"].value;	
		v_neto		=	eval(v_cantidad*(v_unidad-v_descuento));
		detalle.elements["detalle["+indice+"][dorc_nprecio_neto]"].value=v_neto;
	}
	
<%end if%>	
RecalcularTotales();
}

function CalculaTotal(objeto){
	var formulario = document.forms["datos"];
	indice=extrae_indice(objeto.name);
	if(indice!=""){
		v_cantidad	=	formulario.elements["detalle["+indice+"][dorc_ncantidad]"].value;
		v_unidad	=	formulario.elements["detalle["+indice+"][dorc_nprecio_unidad]"].value;		
		v_descuento	=	formulario.elements["detalle["+indice+"][dorc_ndescuento]"].value;	
		v_neto		=	eval(v_cantidad*(v_unidad-v_descuento));
		formulario.elements["detalle["+indice+"][dorc_nprecio_neto]"].value=v_neto;
	}
RecalcularTotales()
}

function RecalcularTotales(){
	var formulario = document.forms["datos"];
	v_total_solicitud = 0;
	v_total_iva = 0;
	v_total_neto = 0;
	v_total_exento = 0;
// Boleta de honorarios
	<% if Cstr(v_boleta)=1 then %>
		for (var i = 0; i <= contador; i++) {
			if(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"]){
				v_valor	=	formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value;
				if (v_valor){
					v_total_solicitud = v_total_solicitud + parseInt(v_valor);
				}
			}
		}
		formulario.sogi_mhonorarios.value	=	eval(v_total_solicitud);
		formulario.total_detalle.value				=	Math.round(v_total_solicitud*0.9)
		formulario.sogi_mretencion.value	=	eval(Math.round(v_total_solicitud*1.10)-v_total_solicitud);
	<%else%>
// Sin boletas de Honorarios, se considera el check para valores exentos y afectos
		for (var i = 0; i <= contador; i++) {
			if(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"]){
				v_valor	=	formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value;
				if (v_valor>0)
				{
					if (formulario.elements["_detalle["+i+"][dorc_bafecta]"].checked){ // Producto afecto, se calcula Iva
						v_total_neto=	parseInt(v_total_neto) + parseInt(v_valor);
						v_iva		=	eval(Math.round(v_valor*1.19)-parseInt(v_valor));
						v_total_iva	=	eval(v_total_iva+v_iva);
					}else{
						//v_total_iva=v_total_iva+v_iva
						v_total_exento=v_total_exento+parseInt(v_valor);
					}	
					v_total_solicitud = v_total_solicitud + parseInt(v_valor);
				}
			}
		}	
		formulario.sogi_mneto.value	=	parseInt(v_total_neto);
		formulario.sogi_miva.value	=	parseInt(v_total_iva);
		formulario.exento.value		=	parseInt(v_total_exento);
		formulario.total_detalle.value		=	parseInt(v_total_solicitud)+parseInt(v_total_iva);
	<%end if%>
}

function ChequeaValor(obj){
	
	var formulario = document.forms["datos"];
	v_name=obj.name;
	v_valor=obj.value;
	
	indice=extrae_indice(v_name);
	
	if(document.datos.elements["datos[0][sogi_bboleta_honorario]"][0].checked){
		alert("Cuando seleccione Boleta de Honorario no puede incluir productos exentos de Iva");
		formulario.elements["_detalle["+indice+"][dorc_bafecta]"].checked=true;
	}
CalculaTotal(obj);	
}

function CambiaValor(obj){
	v_name=obj.name;
	v_valor=obj.value;
	
	filtro="";
	v_area		=	document.datos.elements["busqueda[0][area_ccod]"].value;
	if (v_area!=""){
		filtro= "&area_ccod="+v_area;	
	}
<% if v_boleta<>"" then %>
	v_pers_nrut	=	document.datos.elements["datos[0][pers_nrut]"].value;
	v_pers_xdv	=	document.datos.elements["datos[0][pers_xdv]"].value;
	if (v_pers_nrut!=""){
		filtro= filtro+"&rut="+v_pers_nrut;	
	}
	if (v_pers_xdv!=""){
		filtro= filtro+"&dv="+v_pers_xdv;	
	}
<%end if%>
	document.datos.action= "pago_proveedor.asp?v_boleta="+v_valor+""+filtro;
	document.datos.method = "post";
	document.datos.submit();
}
/*****************************************************************************/

function email(){
	var f = new Date(); 
	miFecha =(f.getDate() + "/" + (f.getMonth() +1) + "/" + f.getFullYear());	
	//email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
	
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
//-------------------------------------	
	var re  = /^([a-zA-Z0-9_.-])+@((upacifico)+.)+(cl)+$/; 
	if (!re.test(email)) { 
		alert ("Dirección de email inválida"); 
		return false; 
	} 
	
	
	if((email != "")&&(email != null)){

	window.open("http://admision.upacifico.cl/postulacion/www/proc_envio_solicitud_giro.php?nombre=<%=nombre_solicitante%>&solicitud=<%=tipo_soli%>&n_soli=<%=ordc_ndocto%>&fecha="+miFecha+"&correo="+email)
	//return false;
	return true;
	}else{
		alert("Debe Ingresar un Correo Electronico.")
		return false;	
	}	
}

//8888888888888888888888888888888888888888888888888888888888888888888888888888888888888
// 03/10/2014

function Func_abonos(checked){

	//var checked	=	document.datos.elements["in_a_check"].checked;
	//var checked = document.getElementById("a_check_id").checked; 
	//alert(checked);
	var v_abono;
	
	v_ordc_ndocto	=	document.datos.elements["busqueda[0][ordc_ndocto]"].value;
	//v_area		=	document.datos.elements["busqueda[0][area_ccod]"].value;
 
	if(document.datos.elements["datos[0][sogi_bboleta_honorario]"][0].checked){
		v_boleta	=	1;
	}else{
		v_boleta	=	2;
	}
 
	texto_rut	=	document.datos.elements["datos[0][pers_nrut]"].value;
	IgDigitoVerificador	=	document.datos.elements["datos[0][pers_xdv]"].value;

  if (checked==1) {
    //document.getElementById("a_check_id_02").value = "1"; 
	//document.datos.elements["in_a_check_02"].value=1;
	v_abono=1;
	//document.datos.elements["abonado_id"].disabled=false;
	//document.datos.elements["saldo_id"].disabled=false;

	//document.datos.action= "pago_proveedor.asp?v_boleta="+v_boleta+"&v_abono="+v_abono+"&rut="+texto_rut+"&dv="+IgDigitoVerificador+"&realiza_abono=1";
	document.datos.action= "pago_proveedor.asp?v_boleta="+v_boleta+"&v_abono="+v_abono+"&realiza_abono=1&ordc_ndocto="+v_ordc_ndocto;
	document.datos.method = "post";
	document.datos.submit();

  }else{ 
    //document.getElementById("a_check_id_02").value = "0";  
	//document.datos.elements["in_a_check_02"].value=0;
	v_abono=0;
	//document.datos.elements["abonado_id"].disabled=true;
	//document.datos.elements["saldo_id"].disabled=true;
	
	//document.datos.action= "pago_proveedor.asp?v_boleta="+v_boleta+"&v_abono="+v_abono+"&rut="+texto_rut+"&dv="+IgDigitoVerificador+"&realiza_abono=1";
	document.datos.action= "pago_proveedor.asp?v_boleta="+v_boleta+"&v_abono="+v_abono+"&realiza_abono=1&ordc_ndocto="+v_ordc_ndocto;
	document.datos.method = "post";
	document.datos.submit();
	}
	
}

//8888888888888888888888888888888888888888888888888888888888888888888888888888888888888
// 10/10/2014

function valida_abono(obj){

	var formulario = document.forms["datos"];
	v_valor=obj.value;
	//alert(v_valor);
	indice		=	extrae_indice(obj.name);
	//alert(indice);
	// ** 09/10/2014
	//v_abono			= formulario.elements["detalle[0][dorc_monto_abono]"].value;
	//alert(v_abono);
	v_saldo			= formulario.elements["detalle["+indice+"][saldo]"].value;
	//alert(v_saldo);
	//v_contador			= formulario.elements["CONTADOR_G"].value;
	//alert(v_contador);
	
	if (parseInt(v_valor)>parseInt(v_saldo)) {
		alert("el monto abonado no puede ser mayor al saldo de la deuda");
		formulario.elements["detalle["+indice+"][dorc_monto_abono]"].value=""
		return false;
	}else{
		return true;
	}

}

//8888888888888888888888888888888888888888888888888888888888888888888888888888888888888
//02/12/2014


function calcula_iva_02(obj)
{

var formulario = document.forms["datos"];
var v_dorc_bafecta;
var v_dorc_ndescuento_t;
var v_dorc_nprecio_neto_t;
var v_dorc_monto_abono_t;
var v_IVA_02_t;

v_dorc_ndescuento_t=0;
v_sogi_mretencion=0;
v_dorc_nprecio_neto_t=0;
v_dorc_monto_abono_t=0;
v_IVA_02_t=0;

v_valor=obj.value;
//alert(v_valor);
num		=	extrae_indice(obj.name);
//alert(num);

v_dorc_nprecio_neto=formulario.elements["detalle["+num+"][dorc_nprecio_neto]"].value;
//alert(v_dorc_nprecio_neto);
v_saldo_01=formulario.elements["detalle["+num+"][saldo_02]"].value;
//alert(v_saldo_01);
v_dorc_bafecta=formulario.elements["detalle["+num+"][dorc_bafecta_02]"].value;
//alert(v_dorc_bafecta);

	if ( (v_dorc_bafecta==1) )
	{
		v_iva = eval(Math.round(v_valor*1.19) - Math.round(v_valor))
		
		if (v_saldo_01==v_dorc_nprecio_neto) {
			v_saldo = eval(Math.round(v_dorc_nprecio_neto) - Math.round(v_valor))
		}
		else
		{
			v_saldo = eval(Math.round(v_saldo_01) - Math.round(v_valor))
		}

	}
	else
	{
		v_iva = 0;
		//v_iva = eval(Math.round(v_valor*1.19) - Math.round(v_valor))
		
		//alert("ENTRO");
		
		if (v_saldo_01==v_dorc_nprecio_neto) {
			v_saldo = eval(Math.round(v_dorc_nprecio_neto) - Math.round(v_valor))
		}
		else
		{
			v_saldo = eval(Math.round(v_saldo_01) - Math.round(v_valor))
		}

	}

formulario.elements["detalle["+num+"][IVA_02]"].value=v_iva;
formulario.elements["detalle["+num+"][saldo]"].value=v_saldo;

cuenta_02=formulario.elements["CONTADOR_G"].value;
//alert(cuenta_02);

	for (var i = 0; i < cuenta_02; i++) {

		if (typeof formulario.elements["detalle["+i+"][dorc_monto_abono]"] == "undefined") {
					//alert("Variable no definida");
		}else{
		
		//para determinar si el campo no esta vacio
		cuenta=formulario.elements["detalle["+i+"][dorc_monto_abono]"].value.length;
		//alert(cuenta);
		
			if (cuenta!=0){
		
					v_dorc_ndescuento = 		formulario.elements["detalle["+i+"][dorc_ndescuento]"].value;
					//alert(v_dorc_ndescuento);
					v_dorc_nprecio_neto = 	formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value;
					//alert(v_dorc_nprecio_neto);
					v_dorc_monto_abono = 	formulario.elements["detalle["+i+"][dorc_monto_abono]"].value;
					//alert(v_dorc_monto_abono);
					v_IVA_02 = 						formulario.elements["detalle["+i+"][IVA_02]"].value;
					//alert(v_IVA_02);
		
			}
			
				if ( (v_dorc_bafecta==1) )
				{
			
				v_dorc_nprecio_neto_t = v_dorc_nprecio_neto_t + parseInt(v_dorc_nprecio_neto);
				v_dorc_monto_abono_t = v_dorc_monto_abono_t + parseInt(v_dorc_monto_abono);
				v_IVA_02_t = 					v_IVA_02_t + parseInt(v_IVA_02);
				v_dorc_ndescuento_t = 	v_dorc_ndescuento_t + parseInt(v_dorc_ndescuento);
								
				v_total_detalle = parseInt(v_dorc_monto_abono_t) + parseInt(v_IVA_02_t)
				//alert(v_total_detalle);
				
				formulario.elements["sogi_mneto"].value = 	v_dorc_monto_abono_t;
				formulario.elements["sogi_miva"].value = 		v_IVA_02_t;
				formulario.elements["exento"].value = 			v_dorc_ndescuento_t;
				formulario.elements["total_detalle"].value = 	v_total_detalle;	
				
				} else {
				
				v_dorc_monto_abono_t = v_dorc_monto_abono_t + parseInt(v_dorc_monto_abono);
				//alert(v_dorc_monto_abono_t);
				v_sogi_mretencion = Math.round(v_dorc_monto_abono_t*0.1);
				//alert(v_sogi_mretencion);
				
				v_total_detalle = parseInt(v_dorc_monto_abono_t) - parseInt(v_sogi_mretencion)
				//alert(v_total_detalle);
				
				formulario.elements["sogi_mhonorarios"].value = 	v_dorc_monto_abono_t;
				formulario.elements["sogi_mretencion"].value = 			v_sogi_mretencion;
				formulario.elements["total_detalle"].value = 	v_total_detalle;	
				
				}
			
		}

	}

}

</script>
</head>

<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="RecorrePresupuesto();calcular();Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">

<!-- **  INICIO TABLA PRINCIPAL 1 ** -->
<table width="750" border="0" align="center" cellpadding="0" cellspacing="1">
	<tr>
		<td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
	</tr>
		<%pagina.DibujarEncabezado()%>  
	<tr>
		<td valign="top" bgcolor="#EAEAEA">
		
		<br>
		
		<!--  Inicio margen superior -->
		<!-- INICIO TABLA GENERAL -->
		
		<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
			<tr>
										<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
										<td height="8" background="../imagenes/top_r1_c2.gif"></td>
										<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
			</tr>
			
			<tr>
				<td width="9" background="../imagenes/izq.gif">&nbsp;</td>
				<td>
				
								<!--  Fin margen superior -->
								<!-- INICIO TABLA CONTENEDORA *** -->
								
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%pagina.DibujarLenguetas Array("Pago Proveedor"), 1 %></td>
									</tr>
									<tr>
										<td height="2" background="../imagenes/top_r3_c2.gif"></td>
									</tr>				
									<tr>
										<td bgcolor="#D8D8DE">
											<br>
												<div align="center"><font size="+1"><%pagina.DibujarTituloPagina()%> </font> </div>
											<br/>
											
											<table width="100%" align="center" cellpadding="0" cellspacing="0" BORDER='0' >
											<tr> 
												<td>
																				<!-- INICIO BUSCADOR -->
																					<form name="buscador"> 
																						<center><table width="50%" border="0">
																							<tr>
																								<td align="right">Extrae datos desde Orden de Compra:</td>
																								<td><%f_buscador.dibujaCampo("ordc_ndocto")%></td>
																								<td><%botonera.DibujaBoton "buscar" %></td>
																								<%f_buscador.dibujaCampo("area_ccod")%>
																							</tr>
																						</table></center>
																					</form>
																				<!-- FIN BUSCADOR -->
												</td>
											</tr>
											<tr>
												<td>	

															<!-- INICIO FORM 1 -->

															<form name="datos" action="pago_proveedor_proc.asp" method="post" onSubmit="alert();">
															<CENTER><TABLE>
															<TR><TD>
																<%f_busqueda.dibujaCampo("sogi_ncorr")%>
																<% if vibo_ccod="10" then %>
																<p style="font-size:12px; color=#FF0000"><strong>OBSERVACI&Oacute;N.- <%=ordc_tobservacion%></strong></p>
																<% else
																	response.write "<br/></p>"
																end if %>
																<input type="hidden" name="busqueda[0][tsol_ccod]" value="1">
																<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>" />
																<input type="hidden" name="busqueda[0][ordc_ndocto]" value="<%=v_ordc_ndocto%>" />
																<input type="hidden" name="busqueda[0][sogi_bboleta_honorario]" value="<%=v_boleta%>" />
                                                                <input type="hidden" name="contador" value="0"/>
                                                                <input type="hidden" name="contador2" value="0"/>
                                                                <input type="hidden" name="contador3" value="0"/> <!-- DETALLE DE GASTOS -->
                                                                <input type="hidden" name="in_a_check_02" value="<%=v_abono%>"/>
																
																<center>
																	<div   style=" width:400px; border:1px solid blue; color: #0000FF; margin:'margin-right:-20px;'">	
																	
																		<table align="center" width="100%" class="tabactivo" BORDER = '0'>
																			<tr>
																				<td width="40%">Boleta Honorarios</td>
																				<td width="60%" ><%f_busqueda.dibujaBoleano("sogi_bboleta_honorario")%></td>
																			</tr>
																		</table>
																		
																	</div>
																</center>	
																
															</TD><TR>
															</TABLE></CENTER>

																<!-- INICIO TABLA PRINCIPAL -->
																
																<table width="100%" height="100%" border="1"bordercolor='#999999' >
																	<tr> 
																		<td width="15%">Rut proveedor</td>
																		<td width="35%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
																		<!--
																		<td> Fecha docto </td>
																		<td width="48%"><%
																		'f_busqueda.dibujaCampo("sogi_fecha_solicitud")
																		%></td>
																		-->
																		<td width="15%" rowspan="2">Detalle de gasto</td>
																		<td width="35%" rowspan="2" valign="top" align="left">
																		<%f_busqueda.dibujatextarea("sogi_tobservaciones")%>
																		</td>
																	</tr>
																	
																	<tr> 
																		<td> Nombre proveedor </td>
																		<td>
																		<%
																		f_busqueda.dibujaCampo("pers_tnombre")
																		%>&nbsp;<%
																		'f_busqueda.dibujaCampo("v_nombre")
																		%></td>
                                                                    
																	</tr>
																	
																	<tr>
																		<td>Monto girar (L&iacute;quido)</td>
																		<td><%f_busqueda.dibujaCampo("sogi_mgiro")%></td> 
																		<td>Cond. Pago </td>
																		<td><%f_busqueda.dibujaCampo("cpag_ccod")%></td>
																	</tr>					  
																	
																	<tr>
																	<!-- COMIENZO DE ABONOS -->
																		<td colspan="2">
																			<table width="100%" border="1">
																				<tr>
																					<td width="5%" >
																					Abono:
																					</td>
																					
																					<td  width="15%" >
																					<%
																					'RESPONSE.WRITE("realiza_abono: "&realiza_abono&"<BR>")
																					
																					IF (caso=1) OR (caso=2) OR (caso=3) then
																					
																					'RESPONSE.WRITE("entro 2: "&"<BR><BR>")
																					
																						f_saldo.AgregaCampoCons "v_abono", cstr(v_abono)
																					end if
																					
																					if (cstr(realiza_abono)=cstr(0)) OR (cstr(caso)=cstr(2) AND cstr(existe_f_abono)=cstr(1)) OR (cstr(realiza_abono)=cstr(1) AND cstr(caso)=cstr(1) ) then 
																					
																					f_saldo.AgregaCampoParam "v_abono", "deshabilitado", "true"

																					f_saldo.dibujaCampo("v_abono")
																					v_v_abono=f_saldo.obtenerValor("v_abono")
																					
																					%>
																					<input type="hidden" name="datos[0][v_abono]" value="<%=v_v_abono%>">
																					
																					<%
																					else 
																						f_saldo.dibujaCampo("v_abono")
																					end if
																					%>
																					
																					</td>
																					
																					<td  width="15%" >
																					Monto Anterior Abonado:
																					</td>
																					<td  width="15%">
																					<%
																					'if cstr(v_abono)=cstr(0) then 
																					f_saldo.AgregaCampoParam "monto_abonado", "deshabilitado", "true"
																					'end if
																					
																					f_saldo.dibujaCampo("monto_abonado")
																					%>
																					
																					</td>
																					<td  width="15%">
																					Monto Anterior Saldo:
																					</td>
																					<td  width="15%">
																					<%
																						
																					'if cstr(v_abono)=cstr(0) then 
																					f_saldo.AgregaCampoParam "saldo_deuda", "deshabilitado", "true"
																					'end if
																					
																					f_saldo.dibujaCampo("saldo_deuda")
																					%>
																					
																					</td>
																				</tr>
																			</table>
																		</td>
																		<!--<td></td>-->
																
																		<td>Tipo Moneda</td>
																		<td><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
																	</tr>
																	
																	<tr>
																	
																		<td colspan="4">
																			<legend><strong>Detalle Documentos</strong>
																			( Total documentos=
																			<input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_doctos" value="<%=v_suma_doctos%>" size="8" readonly/>
																			)</legend> 
																			
																				<table width="100%" align="center" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id="tb_doctos">
																					<tr bgcolor='#C4D7FF' bordercolor='#999999'>
																						<th>N&deg;</th>
																						<th>Tipo Docto </th>
																						<th>N&deg; Docto </th>
																						<th>Fecha Docto</th>
																						<th> Neto </th>
																						<th> Iva </th>
																						<th> Exento </th>
																						<th> Honorarios </th>
																						<th> Retencion </th>
																						<th> L&iacute;quido </th>
																						<th> Tipo Docto Ref</th>
																						<th> N&deg; Docto Ref  </th>
																						<th><strong>(+/-)</strong></th>
																					</tr>
																					
																						<%
																						indice=0
																						v_documentos=0
																						
																						f_detalle_pago.primero
																						f_detalle_pago_1.primero
																						
																						while f_detalle_pago.Siguiente 
																						f_detalle_pago_1.Siguiente 

																						%>
																					
																					<tr align="left">
																						<td><input type="checkbox" name="datos_giro[<%=indice%>][checkbox]" value=""></td>
                                                                                        <input type="hidden" name="v_boleta" value="<%=v_boleta%>">

																						<td>
																						<%
																						If cstr(v_boleta)=cstr(1) then

																							f_detalle_pago.dibujacampo("tdoc_ccod")

																						ELSE

																							f_detalle_pago_1.dibujacampo("tdoc_ccod")

																						End if
																						%>
																						</td>

																						<td><%f_detalle_pago.dibujacampo("dsgi_ndocto")%></td>
																						<td><%f_detalle_pago.DibujaCampo("drga_fdocto")%></td>
																										
																						<%
																						
																						 if cstr(v_boleta)=cstr(1) then
																						 
																							f_detalle_pago.AgregaCampoParam "dsgi_mafecto", "deshabilitado", "true"
																							f_detalle_pago.AgregaCampoParam "dsgi_miva", "deshabilitado", "true"
																							f_detalle_pago.AgregaCampoParam "dsgi_mexento", "deshabilitado", "true"
																						%>
																						 <td><%f_detalle_pago.dibujacampo("dsgi_mafecto")%></td>
																						 <td><%f_detalle_pago.dibujacampo("dsgi_miva")%></td>
																						 <td><%f_detalle_pago.dibujacampo("dsgi_mexento")%></td>
																						 <td><%f_detalle_pago.dibujacampo("dsgi_mhonorarios")%></td>
																						 <td><%f_detalle_pago.dibujacampo("dsgi_mretencion")%></td>
																						 <td><%f_detalle_pago.dibujacampo("dsgi_mdocto")%></td>
																						 
																						 <%
																						 else
																						 %>
																						 
																						 <td><%f_detalle_pago.dibujacampo("dsgi_mafecto")%></td>
																						<td><%f_detalle_pago.dibujacampo("dsgi_miva")%></td>
																						<td><%f_detalle_pago.dibujacampo("dsgi_mexento")%></td>
																						<%
																							f_detalle_pago.AgregaCampoParam "dsgi_mhonorarios", "deshabilitado", "true"
																							f_detalle_pago.AgregaCampoParam "dsgi_mretencion", "deshabilitado", "true"
																						%>		
																						<td><%f_detalle_pago.dibujacampo("dsgi_mhonorarios")%></td>
																						<td><%f_detalle_pago.dibujacampo("dsgi_mretencion")%></td>
																						<td><%f_detalle_pago.dibujacampo("dsgi_mdocto")%></td>
																						<%
																						end if
																						f_detalle_pago.AgregaCampoParam "tdoc_ref_ccod", "deshabilitado", "true"
																						f_detalle_pago.AgregaCampoParam "dsgi_ref_ndocto", "deshabilitado", "true"
																						%>
																						<td><%f_detalle_pago.dibujacampo("tdoc_ref_ccod")%></td>
																						<td><%f_detalle_pago.dibujacampo("dsgi_ref_ndocto")%></td>
																						<td>
																							<input alt="agregar fila" class=boton type="button" name="agregarlinea3" value="+" onClick="validaFila3('tb_doctos','<%=indice%>',this);">
																							<INPUT alt="quitar una fila existente" class="boton" TYPE="button" name="quitarlinea3" value="-" onClick="eliminaFilas3()">
																						</td>

																					</tr>
																					<%
																						indice=indice+1
																						wend
																					%>

																				</table>
																			<br>
																			<p>&nbsp;</p>							  
																		</td>
																	</tr>
																	
																	<tr>
																		<td colspan="4">
																			<legend><strong>Detalle Presupuesto</strong> (Total presupuesto=
																				<input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="<%=v_suma_presupuesto%>" size="8" readonly/>
																				)</legend> 
																				
																				<table width="100%" align="center" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id="tb_presupuesto">
																					<tr bgcolor='#C4D7FF' bordercolor='#999999'>
																						<%if v_ordc_ndocto="" or EsVacio(v_ordc_ndocto) then%>
																						<th width="5%">N°</th>
																						<%end if%>
																						<th width="40%">Cod. Presupuesto</th>
																						<th width="10%">Mes</th>
																						<th width="10%">Año</th>
																						<th width="15%">Valor</th>
																						<th width="15%">Saldo presu</th>
																						<%if v_ordc_ndocto="" or EsVacio(v_ordc_ndocto) then%>
																						<th width="5%">(+/-)</th>
																						<%end if%>
																					</tr>
																					
																					<%
																					ind=0
																					f_presupuesto.primero
																					while f_presupuesto.Siguiente 
																					v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
																					%>
																					
																					<tr align="left">
																						<%if v_ordc_ndocto="" or EsVacio(v_ordc_ndocto) then%><th><input type="checkbox" name="presupuesto[<%=ind%>][checkbox]" value=""></th><%end if%>
																						<td>
                                                                                        <%if v_ordc_ndocto="" or EsVacio(v_ordc_ndocto) then%>
																							<select name="presupuesto[<%=ind%>][cod_pre]" onChange="RevisaPresupuesto(this.value,this.name);" >
																								<%
																								f_cod_pre.primero
																								while f_cod_pre.Siguiente 
																									if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
																										checkeado="selected"
																									else
																										checkeado=""
																									end if
																								%>
																									<option value="<%=f_cod_pre.ObtenerValor("cod_pre")%>"  <%=checkeado%> ><%=f_cod_pre.ObtenerValor("valor")%></option>
																								<%wend%>
																								</select>
                                                                                            <%end if%>
                                                                                            <%if v_ordc_ndocto<>"" then%>
                                                                                            
                                                                                            <select name="presupuesto[<%=ind%>][cod_pre]" disabled="yes">
                                                                                            <option value="<%=f_presupuesto.ObtenerValor("cod_pre")%>"  checkeado="selected" ><%=f_presupuesto.ObtenerValor("valor")%></option>
                                                                                            </select>
                                                                                            <%end if%>
																						</td>
																						<td>
																						<%
																						' 1. 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
																						'f_presupuesto.DibujaCampo("mes_ccod")

																						' 8888888888888888888888888888888888888888888888888888888888888888888888
																						' JAIME PAINEMAL 20130909

																						variable_0=f_presupuesto.ObtenerValor("mes_ccod")
																						variable_1=f_presupuesto.ObtenerValor("anos_ccod")

																						if variable_1<>"" then
																							f_mes_anio.agregacampocons "anos_ccod", variable_1
																						end if

																						%> 
																					
																						<select name="busqueda[<%=ind%>][mes_ccod]" onChange="Cargar_codigos(this.form, this.value, <%=ind%>); RevisaPresupuestoMes(this.value,this.name)" <% if cstr(caso)<>cstr(4) then RESPONSE.WRITE "Disabled='disabled'" end if %> >
																							<%
																							f_mes_anio.primero
																							while f_mes_anio.Siguiente 
																								if Cstr(f_mes_anio.ObtenerValor("mes_ccod"))=Cstr(variable_0) then
																									checkeado="selected"
																								else
																									checkeado=""
																								end if
																							%>
																							<option value="<%=f_mes_anio.ObtenerValor("mes_ccod")%>"  <%=checkeado%> ><%=f_mes_anio.ObtenerValor("mes_tdesc")%></option>
																							<%wend%>
																						</select>	
											
																						</td>
																						<td>
																						<%
																						' 2. 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
																						'f_presupuesto.DibujaCampo("anos_ccod")
																						f_mes_anio.primero
																						f_mes_anio.Siguiente 
																						%> 
																						<input type="text" name="busqueda[<%=ind%>][anos_ccod]" value="<%=f_mes_anio.ObtenerValor("anos_ccod")%>" <% if cstr(caso)<>cstr(4) then RESPONSE.WRITE "Disabled='disabled'" end if %> >
																						</td>
																						<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
												<!--  888888 ** EN LA SIGUIENTE LINEA VA EL SALDO DEL PRESUPUESTO ** 88888888888888888888888888 -->	
																						<td><input type="text" class="Mimetismo" name="busqueda[<%=ind%>][saldo]" size="8" value="" readonly ></td>
																						<%
																							if v_ordc_ndocto="" or EsVacio(v_ordc_ndocto) then
																						%>
																						<td><INPUT alt="agregar fila" class=boton TYPE="button" name="agregarlinea2" value="+" onClick="validaFila2('tb_presupuesto','<%=ind%>',this);">&nbsp;<INPUT alt="quitar una fila existente" class="boton" TYPE="button" name="quitarlinea2" value="-" onClick="eliminaFilas2()">	</td>
																						<%
																							end if
																						%>
																					</tr>	
																					<%
																						ind=ind+1
																						wend 
																					%>
																				</table>
																				
																				<br>&nbsp;					  
																		</td>
																	</tr>
																	
																	<tr>
																		<td colspan="4">
																		<legend><strong>Detalle Gasto</strong></legend> 							
																			<table width="100%" align="center" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id="tb_busqueda_detalle">
																				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
																					<%
																						if v_ordc_ndocto="" or EsVacio(v_ordc_ndocto) then
																					%>
																					<th>N°</th>
																					<%
																						end if
																					%>
																					<th>Tipo Gasto</th>
																					<th>Descripcion</th>
																					<th>C. Costo</th>
																					<th>Cantidad</th>
																					<th>Afecta</th>
																					<th>Precio Unitario</th>
																					<th>Descuento($)</th>
																					<th><%=segun_boleta%></th>
																					<%

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
																						if v_abono=1 then
																					%>
																					<th>Abono</th>
																					<th>IVA</th>
																					<%
																						end if
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
																					
																						if v_ordc_ndocto="" or EsVacio(v_ordc_ndocto) then
																					%>
																					<th>(+/-)</th>
																					<%
																						end if
																					%>
																					<%
																						if v_ordc_ndocto<>"" then
																					%>
																					<th>Saldo</th>
																					<%
																						end if
																					%>
																				</tr>
																				
																				<%
																					if filas_detalle >=1 then
																					ind_d=0
																					'v_totalizado=0
																					f_detalle.primero
																					while f_detalle.Siguiente 
																					f_detalle.DibujaCampo("ordc_ncorr")
																				%>
																				
																				<tr align="left">
																					<%
																						if v_ordc_ndocto="" or EsVacio(v_ordc_ndocto) then
																					%>
																					<th><input type="checkbox" class="remove" name="detalle[<%=ind_d%>][checkbox]" value=""></th>
																					<%
																						end if
																					%>
																					<td><%f_detalle.DibujaCampo("tgas_ccod")%></td>
																					<td><%f_detalle.DibujaCampo("dorc_tdesc")%></td>
																					<td><%f_detalle.DibujaCampo("ccos_ncorr")%> </td>
																					<td><%f_detalle.DibujaCampo("dorc_ncantidad")%> </td>
																					<td><%f_detalle.dibujaBoleano("dorc_bafecta")%> </td>
																					<td><%f_detalle.DibujaCampo("dorc_nprecio_unidad")%> </td>
																					<td><%f_detalle.DibujaCampo("dorc_ndescuento")%> </td>
																					
																					<%
																					if v_abono=1 then
																						f_detalle.AgregaCampoParam "dorc_nprecio_neto", "deshabilitado", "true"
																						%>
																						<td><!--dorc_nprecio_neto-->
																						<%
																						f_detalle.DibujaCampo("dorc_nprecio_neto")
																						v_dorc_nprecio_neto=f_detalle.obtenerValor("dorc_nprecio_neto")
																						%> 
																						<INPUT TYPE="HIDDEN" NAME="detalle[<%=ind_d%>][dorc_nprecio_neto_02]" VALUE="<%=v_dorc_nprecio_neto%>">
																						</td>

																						<%
																					else
																						%>
																						<td><!--dorc_nprecio_neto 2-->
																						<%
																						f_detalle.DibujaCampo("dorc_nprecio_neto")
																						%> 
																						</td>
																					<%
																					end if
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
																						v_saldo=f_detalle.obtenervalor("saldo")
																						'RESPONSE.WRITE(v_saldo)
																						
																						if (cstr(v_saldo)=cstr(0) AND cstr(v_abono)=cstr(1)) then
																						'if v_abono= then
																						
																								f_detalle.AgregaCampoParam "dorc_monto_abono", "deshabilitado", "true"
																								
																								f_detalle.agregacampocons "dorc_monto_abono", 0
																										
																								%>
																								<td><!--dorc_monto_abono-->
																									<%
																									f_detalle.DibujaCampo("dorc_monto_abono")
																									%> 
																									<INPUT TYPE="HIDDEN" NAME="detalle[<%=ind_d%>][dorc_monto_abono_02]" VALUE="0">
																								</td>
																								<%
																						else 
																								f_detalle.AgregaCampoParam "dorc_monto_abono", "deshabilitado", "false"
																									if v_abono=1 then
																									
																										if cstr(caso)<>cstr(1)  then
																										f_detalle.agregacampocons "dorc_monto_abono", ""
																										end if
																										
																								%>
																								<td><!--dorc_monto_abono 2-->
																								<%
																								
																									IF caso<>2 THEN
																										v_dorc_monto_abono 	= f_detalle.obtenervalor("dorc_monto_abono")
																										v_iva_02 						= ( Clng(v_dorc_monto_abono)*1.19 ) - Clng(v_dorc_monto_abono)
																										v_iva_03 						= Round(v_iva_02,0)
																									END IF

																									f_detalle.DibujaCampo("dorc_monto_abono")
																									
																									v_dorc_bafecta=f_detalle.obtenervalor("dorc_bafecta") 
																									'RESPONSE.WRITE("1. v_dorc_bafecta : "&v_dorc_bafecta&"<BR>")
																								%> 
																								</td>
																								<td>
																								<INPUT TYPE="TEXT" NAME="detalle[<%=ind_d%>][IVA_02]" VALUE="<%=v_iva_03%>" id="NU-S" disabled="" size="10" maxLength="10"/>
																								<INPUT TYPE="HIDDEN" NAME="detalle[<%=ind_d%>][dorc_bafecta_02]" VALUE="<%=v_dorc_bafecta%>" id="NU-S" size="10" maxLength="10"/>
																								</rd>
																								
																								<%

																									end if

																						end if

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
																						
																						if v_ordc_ndocto="" or EsVacio(v_ordc_ndocto) then
																					%>
																					<td>
																						<INPUT alt="agregar una nueva fila" class="boton" id="agregarlinea" TYPE="button" name="agregarlinea" value="+" onClick="validaFila('tb_busqueda_detalle','<%=ind_d%>',this)">
																						<INPUT alt="quitar una fila existente" class="boton" TYPE="button" name="quitarlinea" value="-" onClick="eliminaFilas()">
																					</td>
																					<%
																						end if

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

																						if v_ordc_ndocto<>"" then
																						
																						v_saldo_02=f_detalle.obtenervalor("saldo") 
																						
																					%>
																					<td>
																					<INPUT TYPE="HIDDEN" NAME="detalle[<%=ind_d%>][saldo_02]" VALUE="<%=v_saldo_02%>" id="NU-S" size="10" maxLength="10"/>
																						<%
																						f_detalle.AgregaCampoParam "saldo", "deshabilitado", "true"
																						f_detalle.DibujaCampo("saldo")
																						%>
																						<%'f_detalle.DibujaCampo("v_saldo")
																						%>
																					</td>
																					<%
																						end if

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
																					%>		
																				</tr>	
																				<%
																					ind_d=ind_d+1
																					wend
																					end if 
																				%>
																			<INPUT TYPE="HIDDEN" NAME="CONTADOR_G" VALUE="<%=ind_d%>">
																			</table>							
																		</td>
																	</tr>
																	
																	<tr>
																		<td colspan="4">
																			<!-- INICIO TABLA -->
																				<table border="0" width="100%" >
																					<tr>
																						<td width="80%" rowspan="<%=row_span%>">&nbsp;</td>
																						<th align="left" width="10%"><%=txt_neto%></th>
																						<td align="right" width="10%"><input type="text" name="<%=valor_neto%>" value="<%=v_neto%>" size="10" id='NU-N' readonly/></td>
																					</tr>
																					<tr>
																						<th align="left"><%=txt_variable%></th>
																						<td align="right"><input type="text" name="<%=valor_variable%>" value="<%=v_variable%>" size="10" id='NU-N' readonly/></td>
																					</tr>
																					<!-- INICIO EXENTO (para el caso no me sirve) -->
																					<% 
																						if Cstr(v_boleta)=2 then 
																					%>
																					<tr>
																						<th align="left" >Exento</th>
																						<td align="right"><input type="text" name="exento" value="<%=v_exento%>" size="10" id='NU-N' readonly/></td>
																					</tr>
																					<%
																						end if
																					%>
																					<!-- FIN EXENTO -->
																					<tr>
																						<th align="left">L&iacute;quido </th>
																						<td align="right"><input type="text" name="total_detalle" value="<%=v_totalizado%>" size="10" id='NU-N' readonly/></td>
																					</tr>
																				</table>
																			<!-- FIN TABLA -->
																		</td>
																	</tr>	
																</table>
																
																<!-- FIN TABLA PRINCIPAL -->
																
																<br/>
																<p>
																</p>
																
																<fieldset>
																<legend><strong>Responsable</strong></legend> 				
																<strong>V°B° Responsable:</strong>
																
																<select name="busqueda[0][responsable]">
																<%
																f_responsable.primero
																while f_responsable.Siguiente
																%>
																<option value="<%f_responsable.DibujaCampo("pers_nrut")%>"><%f_responsable.DibujaCampo("nombre")%></option>
																<%wend%>
																</select>
                                                                <input name="email" type="hidden" value="<%f_responsable.DibujaCampo("email")%>"/>
																</fieldset>						  					
															</form>
														
														<!-- FIN FORM 1 -->
														
													</td>
												</tr>
												<tr>
													<td>
														<br>
													</td>
												</tr>
													
												<tr>
													<td>
													</td>
												</tr>
											</table>
										</TD>
									</tr>		  
								</table>
								
								<!-- FIN TABLA CONTENEDORA *** -->
								<!--  Inicio margen inferior -->

				</td>
				<td width="7" background="../imagenes/der.gif">&nbsp;</td>
			</tr>
			
			<tr>
				<td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
				<td height="28">

					<table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="18%" height="20">
							
								<!-- INICIO BOTONERA -->
								<table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<%
					  	if vibo_ccod="0" then
							botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
						end if
						
						'if vibo_ccod = "12" or vibo_ccod = "10" or vibo_ccod = "-1" then
						'RESPONSE.WRITE("vibo_ccod: "&vibo_ccod&"<BR>")
						'RESPONSE.WRITE("ocag_baprueba: "&ocag_baprueba&"<BR>")
						'RESPONSE.WRITE("ocag_baprueba_rector: "&ocag_baprueba_rector&"<BR>")
						'RESPONSE.WRITE("resul_nombre: "&resul_nombre&"<BR>")
						
						if ((vibo_ccod="11" and ocag_baprueba="1" and ocag_baprueba_rector="1") or (vibo_ccod="6" and ocag_baprueba="1" and ocag_baprueba_rector="2"))     or vibo_ccod = "12" or vibo_ccod = "10" or vibo_ccod = "-1" then
						'if ((vibo_ccod="11" and ocag_baprueba="1" and ocag_baprueba_rector="1") or (vibo_ccod="6" and ocag_baprueba="1" and ocag_baprueba_rector="2"))     or vibo_ccod = "12" or vibo_ccod = "10" or vibo_ccod = "-1" or vibo_ccod = "0" then
							
							'RESPONSE.WRITE("ACA 1: "&"<BR>")
						
							botonera.AgregaBotonParam "guardar", "deshabilitado", "false"
							botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
							botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"

						elseif vibo_ccod>="0" or resul_nombre <> "1" then
						
							'RESPONSE.WRITE("ACA 2: "&"<BR>")
							
							botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "true"
							botonera.AgregaBotonParam "guardar", "deshabilitado", "true"
						end if
						%>
					  <td width="30%"><%botonera.dibujaboton "guardar"%> </td>
                      <td><%botonera.dibujaboton "guardarenviar"%></td>
					  <td><%botonera.dibujaboton "salir"%></td>
					  <td><%botonera.dibujaboton "imprimir"%></td>
					</tr>
				  </table>
								<!-- FIN BOTONERA -->
											
							</td>
							<td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
						</tr>
						<tr>
							<td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
						</tr>
					</table>
				</td>
				<td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
			</tr>
							  
		</table>
	
		<!--  fin margen inferior -->	
		<!-- FIN TABLA GENERAL -->
	
		</td>
	</tr>  
</table>

<!-- ** FIN TABLA PRINCIPAL 1 ** -->

</body>
</html>

<script language="javascript">


var resul_nom='<%=resul_nombre%>'
if (resul_nom == "0") {
	alert("No existe el RUT en Softland.")	
}

document.datos.elements["contador"].value = contador;
document.datos.elements["contador2"].value = contador2;
document.datos.elements["contador3"].value = contador3;
</script>