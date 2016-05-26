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
'FECHA ACTUALIZACION 	:26/07/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			: 
'*******************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

prueba=request.querystring("prueba")

'RESPONSE.WRITE("prueba :"&prueba&"<BR>")

v_abono	= request.Form("datos[0][v_abono]")

if v_abono="" then
	v_abono=0
end if

cuenta_detalle=0

v_sogi_ncorr	= request.Form("datos[0][sogi_ncorr]")
v_boleta		= request.Form("v_boleta")
v_tmon_ccod		= request.Form("busqueda[0][tmon_ccod]")
v_ordc_ndocto	= request.Form("busqueda[0][ordc_ndocto]")
v_area_ccod		= request.Form("busqueda[0][area_ccod]")
v_responsable	= request.Form("busqueda[0][responsable]")
contador =request.Form("contador")
contador2 =request.Form("contador2")
contador3 =request.Form("contador3")

'response.Write("v_sogi_ncorr: "&v_sogi_ncorr&"<BR>")	
'response.Write("Boleta: "&v_boleta&"<BR>")	

'response.Write("v_abono: "&v_abono&"<BR>")	

if 	v_tmon_ccod="" then
	v_tmon_ccod=1
end if

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_proveedor = new cFormulario
f_proveedor.carga_parametros "pago_proveedor.xml", "datos_proveedor"
f_proveedor.inicializar conexion
f_proveedor.procesaForm

v_usuario=negocio.ObtenerUsuario()
fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")

'response.Write("Boleta: "&v_boleta&"<BR>")	

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA Solicitud *************
for fila = 0 to f_proveedor.CuentaPost - 1
	pers_nrut 		= f_proveedor.ObtenerValorPost (fila, "pers_nrut")
	pers_xdv 		= f_proveedor.ObtenerValorPost (fila, "pers_xdv")
	pers_tnombre 	= f_proveedor.ObtenerValorPost (fila, "v_nombre")
	
	if 	pers_nrut<>"" then
	
		v_pers_ncorr=conexion.consultaUno("Select pers_ncorr from personas where pers_nrut="&pers_nrut)
		
		'inserta datos del proveedor en caso que no exista
		if EsVacio(v_pers_ncorr) or v_pers_ncorr="" then
			v_pers_ncorr=conexion.consultauno("exec obtenersecuencia 'personas'")
			
			sql_persona	=	" insert into personas (pers_ncorr,pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,pers_tfono,pers_tfax) "&_
							" values("&v_pers_ncorr&","&pers_nrut&",'"&pers_xdv&"','"&pers_tnombre&"','','', '"&pers_tfono&"', '"&pers_tfax&"') "
								
			conexion.estadotransaccion	conexion.ejecutas(sql_persona)
		end if
	end if

'response.Write("<b>"&conexion.obtenerEstadoTransaccion&"</b>")
'response.Write("<hr>"&sql_persona&"<br/>")

next

'response.End()
'response.Write("Boleta: "&v_boleta&"<br>")	
'response.End()

	if 	v_boleta=1 then
		sogi_mhonorarios=	request.Form("sogi_mhonorarios")
		sogi_mretencion	=	request.Form("sogi_mretencion")
		sogi_mneto		=	0
		sogi_miva		=	0
		sogi_mexento	=	0	
	else
		v_boleta=2
		sogi_mneto		=	request.Form("sogi_mneto")
		sogi_miva		=	request.Form("sogi_miva")
		sogi_mexento	=	request.Form("exento")
		sogi_mhonorarios=	0
		sogi_mretencion	=	0
	end if
	
'response.End()

'** Se agregan los totalizadores segun los tipo de cobros (Afectos o Exentos)

	f_proveedor.AgregaCampoPost "sogi_mexento", sogi_mexento
	f_proveedor.AgregaCampoPost "sogi_miva", sogi_miva
	f_proveedor.AgregaCampoPost "sogi_mneto", sogi_mneto	
	f_proveedor.AgregaCampoPost "sogi_mhonorarios", sogi_mhonorarios
	f_proveedor.AgregaCampoPost "sogi_mretencion", sogi_mretencion
	
	f_proveedor.AgregaCampoPost "ocag_fingreso", fecha_actual	
	f_proveedor.AgregaCampoPost "ocag_generador", v_usuario
	f_proveedor.AgregaCampoPost "ocag_responsable", v_responsable
	f_proveedor.AgregaCampoPost "tsol_ccod", 1
	f_proveedor.AgregaCampoPost "sogi_fecha_solicitud", fecha_actual


'if EsVacio(v_sogi_ncorr) or v_sogi_ncorr="" then
if (EsVacio(v_sogi_ncorr) or v_sogi_ncorr="") then

	RESPONSE.WRITE("1. uno : "&"<BR>")
	
	v_sogi_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_solicitud_giro'")
	
	f_proveedor.AgregaCampoPost "pers_ncorr_proveedor", v_pers_ncorr
	f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	if v_ordc_ndocto<>"" then
		f_proveedor.AgregaCampoPost "ordc_ncorr", v_ordc_ndocto
	end if
	'f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	f_proveedor.AgregaCampoPost "sogi_ncorr", v_sogi_ncorr
	f_proveedor.AgregaCampoPost "area_ccod", v_area_ccod
	'20140103
	f_proveedor.AgregaCampoPost "SOGI_BBOLETA_HONORARIO", v_boleta
	f_proveedor.AgregaCampoPost "sogi_fecha_solicitud", fecha_actual
	f_proveedor.AgregaCampoPost "ocag_baprueba", "NULL"
	'LA SIGUIENTE LINEA DE CODIGO GRABA LOS REGISTROS EN LA TABLA "ocag_solicitud_giro"
	'88888888888888888888888888888888888888888888888888888888888888888888888888888888888
	f_proveedor.MantieneTablas false
	
else

						RESPONSE.WRITE("2. dos : "&"<BR>")
								
						url_final=request.ServerVariables("HTTP_REFERER")
							
						f_proveedor.AgregaCampoPost "tsol_ccod", 1
						f_proveedor.AgregaCampoPost "ocag_baprueba", "NULL"

						f_proveedor.AgregaCampoPost "pers_ncorr_proveedor", v_pers_ncorr
						f_proveedor.AgregaCampoPost "vibo_ccod", prueba
						if v_ordc_ndocto<>"" then
								f_proveedor.AgregaCampoPost "ordc_ncorr", v_ordc_ndocto
						end if

						f_proveedor.AgregaCampoPost "sogi_ncorr", v_sogi_ncorr
						f_proveedor.AgregaCampoPost "area_ccod", v_area_ccod
							'20140103
						f_proveedor.AgregaCampoPost "SOGI_BBOLETA_HONORARIO", v_boleta
						f_proveedor.AgregaCampoPost "sogi_fecha_solicitud", fecha_actual
							'LA SIGUIENTE LINEA DE CODIGO GRABA LOS REGISTROS EN LA TABLA "ocag_solicitud_giro"
							'88888888888888888888888888888888888888888888888888888888888888888888888888888888888
						f_proveedor.MantieneTablas false

	'if v_abono=0 then
		sql_borra_detalle		= "delete from ocag_detalle_solicitud_ag where cod_solicitud="&v_sogi_ncorr	
	'else
	'	sql_borra_detalle		= "select MAX(ISNULL(cuenta_detalle,0))+1 AS cuenta_detalle  "&_
	'											" from ocag_detalle_solicitud_ag where cod_solicitud="&v_sogi_ncorr&" GROUP BY cuenta_detalle"
	'end if
	
	sql_borra_presupuesto	= "delete from ocag_presupuesto_solicitud where cod_solicitud="&v_sogi_ncorr&" and tsol_ccod=1 "
	sql_detalle_giro		= "delete from ocag_detalle_solicitud_giro where sogi_ncorr="&v_sogi_ncorr
	
	'RESPONSE.WRITE("1. sql_borra_detalle : "&sql_borra_detalle&"<BR>")
	'RESPONSE.WRITE("2. sql_borra_presupuesto : "&sql_borra_presupuesto&"<BR>")
	'RESPONSE.WRITE("3. sql_detalle_giro : "&sql_detalle_giro&"<BR>")
	
	'if v_abono=0 then
		conexion.estadotransaccion	conexion.ejecutas(sql_borra_detalle)
	'else
	'	cuenta_detalle=conexion.consultauno(sql_borra_detalle)		
	'end if

	conexion.estadotransaccion	conexion.ejecutas(sql_borra_presupuesto)
	conexion.estadotransaccion	conexion.ejecutas(sql_detalle_giro)

end if

'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")

'RESPONSE.END()

'************** INSERTA EL HISTORIAL DEL AUTORIZACIONES ***************
	set f_solicitud = new cFormulario
	f_solicitud.carga_parametros "vb_presupuesto.xml", "autoriza_solicitud_giro"
	f_solicitud.inicializar conexion
	f_solicitud.procesaForm
	
	f_solicitud.AgregaCampoPost "cod_solicitud",v_sogi_ncorr
	f_solicitud.AgregaCampoPost "vibo_ccod", prueba
	f_solicitud.AgregaCampoPost "ocag_barpueba", "NULL"
	f_solicitud.AgregaCampoPost "asgi_nestado", 1
	f_solicitud.AgregaCampoPost "tsol_ccod", 1
	f_solicitud.AgregaCampoPost "asgi_fautorizado", fecha_actual

	'LA SIGUIENTE LINEA DE CODIGO GRABA LOS REGISTROS EN LA TABLA "ocag_autoriza_solicitud_giro"
	'88888888888888888888888888888888888888888888888888888888888888888888888888888888888	
	f_solicitud.MantieneTablas false
	
'************** INSERTA EL DETALLE DE DOCUMENTOS PAGADOS ***************
set detalle_giro = new cFormulario
detalle_giro.carga_parametros "pago_proveedor.xml", "detalle_giro"
detalle_giro.inicializar conexion
detalle_giro.procesaForm

for fila = 0 to contador3 'detalle_giro.CuentaPost-1

	tdoc_ccod = detalle_giro.ObtenerValorPost (fila, "tdoc_ccod")
	dsgi_ndocto		= detalle_giro.ObtenerValorPost (fila, "dsgi_ndocto")
	dsgi_mdocto		= detalle_giro.ObtenerValorPost (fila, "dsgi_mdocto")

	
	if tdoc_ccod <> "" then
		v_dsgi_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_detalle_solicitud_giro'")		
		
		if 	v_boleta=1 then
			dsgi_mexento	= 0
			dsgi_mafecto	= 0
			dsgi_miva		= 0
			'dsgi_mhonorarios= detalle_giro.ObtenerValorPost (fila, "dsgi_mhonorarios")
			'dsgi_mretencion	= detalle_giro.ObtenerValorPost (fila, "dsgi_mretencion")
		else
			dsgi_mexento	= detalle_giro.ObtenerValorPost (fila, "dsgi_mexento")
			dsgi_mafecto	= detalle_giro.ObtenerValorPost (fila, "dsgi_mafecto")
			dsgi_miva		= detalle_giro.ObtenerValorPost (fila, "dsgi_miva")
			'dsgi_mhonorarios= 0
			'dsgi_mretencion	= 0
		end if	
	
		dsgi_mhonorarios= detalle_giro.ObtenerValorPost (fila, "dsgi_mhonorarios")
		dsgi_mretencion	= detalle_giro.ObtenerValorPost (fila, "dsgi_mretencion")
		drga_fdocto = detalle_giro.ObtenerValorPost (fila, "drga_fdocto")
		
		IF dsgi_mhonorarios = "" THEN dsgi_mhonorarios="NULL" END IF
		IF dsgi_mretencion = "" THEN dsgi_mretencion="NULL" END IF
		
		if tdoc_ccod = 7 OR tdoc_ccod = 12 then
			tdoc_ref_ccod = detalle_giro.ObtenerValorPost (fila, "tdoc_ref_ccod")
			dsgi_ref_ndocto	= detalle_giro.ObtenerValorPost (fila, "dsgi_ref_ndocto")
		else
			tdoc_ref_ccod = "NULL"
			dsgi_ref_ndocto	= "NULL"
		end if 
		
		if tdoc_ccod<>"" and  dsgi_ndocto<>"" and dsgi_mdocto<>"" then
		
			'sql_detalle_giro= " Insert into ocag_detalle_solicitud_giro (sogi_ncorr,dsgi_ncorr,tmon_ccod,tdoc_ccod,dsgi_ndocto,dsgi_mdocto,dsgi_mexento,dsgi_mafecto,dsgi_miva,dsgi_mhonorarios,dsgi_mretencion,audi_tusuario, audi_fmodificacion) "&_  
			'			 " values("&v_sogi_ncorr&","&v_dsgi_ncorr&","&v_tmon_ccod&","&tdoc_ccod&","&dsgi_ndocto&","&dsgi_mdocto&","&dsgi_mexento&","&dsgi_mafecto&","&dsgi_miva&","&dsgi_mhonorarios&","&dsgi_mretencion&",'"&v_usuario&"', getdate())"

			
			sql_detalle_giro= " Insert into ocag_detalle_solicitud_giro (sogi_ncorr,dsgi_ncorr,tmon_ccod,tdoc_ccod,dsgi_ndocto,dsgi_mdocto,dsgi_mexento,dsgi_mafecto,dsgi_miva,dsgi_mhonorarios,dsgi_mretencion,audi_tusuario, audi_fmodificacion, dogi_fecha_documento,tdoc_ref_ccod,dsgi_ref_ndocto) "&_  
						 " values("&v_sogi_ncorr&","&v_dsgi_ncorr&","&v_tmon_ccod&","&tdoc_ccod&", "&dsgi_ndocto&","&dsgi_mdocto&","&dsgi_mexento&","&dsgi_mafecto&","&dsgi_miva&","&dsgi_mhonorarios&","&dsgi_mretencion&",'"&v_usuario&"', getdate(),'"&drga_fdocto&"',"&tdoc_ref_ccod&","&dsgi_ref_ndocto&")"
						 
			'response.write tdoc_ccod & " | " & tdoc_ref_ccod & " | "& dsgi_ref_ndocto & " <br> " & sql_detalle_giro & "<br>"
			
			'sql_detalle_giro= " Insert into ocag_detalle_solicitud_giro (sogi_ncorr,dsgi_ncorr,tmon_ccod,tdoc_ccod,dsgi_ndocto,dsgi_mdocto,dsgi_mexento,dsgi_mafecto,dsgi_miva,dsgi_mhonorarios,dsgi_mretencion,audi_tusuario, audi_fmodificacion, dogi_fecha_documento) "&_  
			'			 " values ("&v_sogi_ncorr&","&v_dsgi_ncorr&","&v_tmon_ccod&","&tdoc_ccod&","&dsgi_ndocto&","&dsgi_mdocto&","&dsgi_mexento&","&dsgi_mafecto&","&dsgi_miva&","&dsgi_mhonorarios&","&dsgi_mretencion&",'"&v_usuario&"', getdate(),'"&drga_fdocto&"')"
						 
			'RESPONSE.WRITE("4. sql_detalle_giro : "&sql_detalle_giro&"<BR>")
			
			conexion.estadotransaccion	conexion.ejecutas(sql_detalle_giro)
			
		end if
	
	end if
next

'******************************************************************************
'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")

'************** INSERTA EL DETALLE DEL PRESUPUESTO ASOCIADO ***************
set detalle_presupuesto = new cFormulario
detalle_presupuesto.carga_parametros "pago_proveedor.xml", "detalle_presupuesto"
detalle_presupuesto.inicializar conexion
detalle_presupuesto.procesaForm

for fila = 0 to contador2'detalle_presupuesto.CuentaPost-1

	cod_pre 		= detalle_presupuesto.ObtenerValorPost (fila, "cod_pre")
	'anos_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "anos_ccod")
	'mes_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "mes_ccod")
	mes_ccod =  request.Form("busqueda["&fila&"][mes_ccod]")  
	anos_ccod = request.Form("busqueda["&fila&"][anos_ccod]")   

	psol_mpresupuesto 		= detalle_presupuesto.ObtenerValorPost (fila, "psol_mpresupuesto")
	
	response.write("cod_pre: "&cod_pre&"<br>")

	if cod_pre <> "" then
	
		v_psol_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_presupuesto_solicitud'")		
	
		sql_detalle_presupuesto= " Insert into ocag_presupuesto_solicitud (psol_ncorr,tsol_ccod,cod_solicitud,cod_pre,anos_ccod,psol_mpresupuesto,mes_ccod, audi_tusuario, audi_fmodificacion) "&_  
					 " values("&v_psol_ncorr&",1,"&v_sogi_ncorr&",'"&cod_pre&"',"&anos_ccod&","&psol_mpresupuesto&","&mes_ccod&",'"&v_usuario&"', getdate())"
					 
		'RESPONSE.WRITE("5. sql_detalle_presupuesto : "&sql_detalle_presupuesto&"<BR>")
		
		conexion.estadotransaccion	conexion.ejecutas(sql_detalle_presupuesto)
	end if
next

'response.End()

'******************************************************************************
'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")

'************** INSERTA EL DETALLE DE LA ORDEN DE COMPRA ***************
	set detalle_orden = new cFormulario
	detalle_orden.carga_parametros "orden_compra.xml", "detalle_orc"
	detalle_orden.inicializar conexion
	detalle_orden.procesaForm
	
	for fila = 0 to contador'detalle_orden.CuentaPost-1
	
		tgas_ccod 		= detalle_orden.ObtenerValorPost (fila, "tgas_ccod")
		dorc_tdesc 		= detalle_orden.ObtenerValorPost (fila, "dorc_tdesc")
		ccos_ncorr 		= detalle_orden.ObtenerValorPost (fila, "ccos_ncorr")
		ordc_ncorr 		= detalle_orden.ObtenerValorPost (fila, "ordc_ncorr")
		dorc_ncantidad 			= detalle_orden.ObtenerValorPost (fila, "dorc_ncantidad")
		dorc_nprecio_unitario 	= detalle_orden.ObtenerValorPost (fila, "dorc_nprecio_unidad")
		dorc_ndescuento 		= detalle_orden.ObtenerValorPost (fila, "dorc_ndescuento")
		dorc_nprecio_neto 		= detalle_orden.ObtenerValorPost (fila, "dorc_nprecio_neto")
		dorc_bafecta 			= detalle_orden.ObtenerValorPost (fila, "dorc_bafecta")
		dorc_monto_abono 			= detalle_orden.ObtenerValorPost (fila, "dorc_monto_abono")
		
		IF dorc_nprecio_neto = "" THEN
			dorc_nprecio_neto 		= detalle_orden.ObtenerValorPost (fila, "dorc_nprecio_neto_02")
		END IF
		
		IF dorc_monto_abono = "" THEN
			dorc_monto_abono 			= detalle_orden.ObtenerValorPost (fila, "dorc_monto_abono_02")
		END IF
		
		'RESPONSE.WRITE("dorc_nprecio_neto: "&dorc_nprecio_neto&"<BR>")
		
		if tgas_ccod <> "" then
		
			v_dsag_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_detalle_solicitud_ag'")		
			
			if dorc_bafecta = "" then
			
			dorc_bafecta = request.Form("_detalle["&fila&"][dorc_bafecta]")
				if	dorc_bafecta="" or EsVacio(dorc_bafecta) then
					dorc_bafecta=2
				end if
			'RESPONSE.WRITE(" 7. dorc_bafecta : "&dorc_bafecta&"<BR>")
			end if
			
			if 	ordc_ncorr="" or EsVacio(ordc_ncorr) then
				ordc_ncorr="null"
			end if
	
			'sql_detalle= " Insert into ocag_detalle_solicitud_ag (dsag_ncorr,sogi_ncorr,ordc_ncorr,cod_solicitud,tgas_ccod,dorc_tdesc,ccos_ncorr,dorc_ncantidad,tmon_ccod,dorc_nprecio_unidad,dorc_ndescuento,dorc_nprecio_neto, audi_tusuario, audi_fmodificacion,dorc_bafecta) "&_  
			'			 " values("&v_dsag_ncorr&","&v_sogi_ncorr&","&ordc_ncorr&","&v_sogi_ncorr&","&tgas_ccod&",'"&dorc_tdesc&"',"&ccos_ncorr&",'"&dorc_ncantidad&"',"&v_tmon_ccod&",'"&dorc_nprecio_unitario&"','"&dorc_ndescuento&"','"&dorc_nprecio_neto&"','"&v_usuario&"', getdate(),"&dorc_bafecta&")"

			'RESPONSE.WRITE(" 6. v_abono : "&v_abono&"<BR>")
			
			if v_abono = 0 then
			
			sql_detalle= " Insert into ocag_detalle_solicitud_ag  "&_ 
						 " ( dsag_ncorr, sogi_ncorr, ordc_ncorr, cod_solicitud, tgas_ccod "&_ 
						 " , dorc_tdesc, ccos_ncorr, dorc_ncantidad, tmon_ccod, dorc_nprecio_unidad "&_ 
						 " , dorc_ndescuento, dorc_nprecio_neto, audi_tusuario, audi_fmodificacion, dorc_bafecta "&_ 
						 " , dorc_abono )    "&_ 
						 " values "&_ 
						 " ( "&v_dsag_ncorr&", "&v_sogi_ncorr&", "&ordc_ncorr&", "&v_sogi_ncorr&", "&tgas_ccod&" "&_ 
						 " , '"&dorc_tdesc&"', "&ccos_ncorr&", '"&dorc_ncantidad&"', "&v_tmon_ccod&", '"&dorc_nprecio_unitario&"' "&_ 
						 " , '"&dorc_ndescuento&"', '"&dorc_nprecio_neto&"', '"&v_usuario&"', getdate(), "&dorc_bafecta&" "&_ 
						 " , 0 ) "
						 
			else
			
			sql_detalle= " Insert into ocag_detalle_solicitud_ag  "&_ 
						 " ( dsag_ncorr, sogi_ncorr, ordc_ncorr, cod_solicitud, tgas_ccod "&_ 
						 " , dorc_tdesc, ccos_ncorr, dorc_ncantidad, tmon_ccod, dorc_nprecio_unidad "&_ 
						 " , dorc_ndescuento, dorc_nprecio_neto, audi_tusuario, audi_fmodificacion, dorc_bafecta "&_ 
						 " , dorc_abono, dorc_monto_abono, cuenta_detalle )    "&_ 
						 " values "&_ 
						 " ( "&v_dsag_ncorr&", "&v_sogi_ncorr&", "&ordc_ncorr&", "&v_sogi_ncorr&", "&tgas_ccod&" "&_ 
						 " , '"&dorc_tdesc&"', "&ccos_ncorr&", '"&dorc_ncantidad&"', "&v_tmon_ccod&", '"&dorc_nprecio_unitario&"' "&_ 
						 " , '"&dorc_ndescuento&"', '"&dorc_nprecio_neto&"', '"&v_usuario&"', getdate(), "&dorc_bafecta&" "&_ 
						 " , 1 , "&dorc_monto_abono&", "&cuenta_detalle&"  ) "
			
			end if

			'RESPONSE.WRITE(" 6. sql_detalle : "&sql_detalle&"<BR>")
			
			conexion.estadotransaccion	conexion.ejecutas(sql_detalle)
		
		end if
	next
'***************************************************************************************

'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.End()

if conexion.ObtenerEstadoTransaccion=false  then
'response.Write("<br>Todo MAL")
	url_final=request.ServerVariables("HTTP_REFERER")
	session("mensaje_error")="No se pudo ingresar la solicitud de giro.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	url_final="autorizacion_giros.asp"
	session("mensaje_error")="La Solicitud de Giro N° "&v_sogi_ncorr&" fue ingresada correctamente."
end if

if url_final ="" then
	'url_final="pago_proveedor.asp?busqueda[0][sogi_ncorr]="&v_sogi_ncorr
	url_final="autorizacion_giros.asp"
end if
response.Redirect(url_final)
%>