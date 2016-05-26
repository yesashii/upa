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
'FECHA ACTUALIZACION 	:20/06/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:
'*******************************************************************
'for each k in request.form
'response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

' 88888888888888888888888888888888888888888888888888
' RESCATA EL CODIGO DE MONEDA SEGUN PANTALLA
prueba=request.querystring("prueba")

'response.End()

tmon_ccod_1=request.Form("tmon_ccod")
if tmon_ccod_1 = "" then
tmon_ccod=request.Form("busqueda[0][tmon_ccod]")
else
tmon_ccod=tmon_ccod_1
end if

' 88888888888888888888888888888888888888888888888888

contador=request.Form("contador") ' CONTADOR DE FILAS DEL DETALLE DE GASTO
contador2=request.Form("contador2") ' CONTADOR DE FILAS DEL DETALLE DE  PRESUPUESTO

v_ordc_ncorr=request.Form("ordc_ncorr")
v_responsable=request.Form("busqueda[0][responsable]")

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_proveedor = new cFormulario
f_proveedor.carga_parametros "orden_compra.xml", "buscador"
f_proveedor.inicializar conexion
f_proveedor.procesaForm

v_usuario=negocio.ObtenerUsuario()
fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
'for fila = 0 to f_proveedor.CuentaPost - 1
fila = 0
	pers_nrut 				= f_proveedor.ObtenerValorPost (fila, "pers_nrut")
	pers_xdv 				= f_proveedor.ObtenerValorPost (fila, "pers_xdv")
	'pers_tnombre 		= f_proveedor.ObtenerValorPost (fila, "v_nombre")
	pers_tfono 			= f_proveedor.ObtenerValorPost (fila, "pers_tfono")
	pers_tfax 				= f_proveedor.ObtenerValorPost (fila, "pers_tfax")
	'dire_tcalle 			= f_proveedor.ObtenerValorPost (fila, "dire_tcalle")
	'dire_tnro 				= f_proveedor.ObtenerValorPost (fila, "dire_tnro")
	'ciud_ccod 			= f_proveedor.ObtenerValorPost (fila, "ciud_ccod")
	ordc_ncotizacion 	= f_proveedor.ObtenerValorPost (fila, "ordc_ncotizacion")
	ordc_tatencion 		= f_proveedor.ObtenerValorPost (fila, "ordc_tatencion")   
	cpag_ccod 			= f_proveedor.ObtenerValorPost (fila, "cpag_ccod")
	ordc_tobservacion 	= f_proveedor.ObtenerValorPost (fila, "ordc_tobservacion")
	ordc_tcontacto 		= f_proveedor.ObtenerValorPost (fila, "ordc_tcontacto")
	ordc_tfono 			= f_proveedor.ObtenerValorPost (fila, "ordc_tfono")
	ordc_fentrega 		= f_proveedor.ObtenerValorPost (fila, "ordc_fentrega")
	sede_ccod 			= f_proveedor.ObtenerValorPost (fila, "sede_ccod")
	cod_pre 				= f_proveedor.ObtenerValorPost (fila, "cod_pre")
	'cod_pre				= request.Form("presupuesto["&fila&"][cod_pre]")
	ordc_mmonto 		= f_proveedor.ObtenerValorPost (fila, "ordc_mmonto")
	ordc_bhonorario		= f_proveedor.ObtenerValorPost (fila, "ordc_bboleta_honorario")  ' AQUI RESCATO EL VALOR "BOLETA DE HONORARIOS"
	area_ccod				= f_proveedor.ObtenerValorPost (fila, "area_ccod")		

	
	' SI BOLETA DE HONORARIOS = 1 - SI
	if 	ordc_bhonorario=1 then
		v_total			=	request.Form("ordc_mhonorarios")
		ordc_mretencion	=	request.Form("ordc_mretencion")
	else
	' SI BOLETA DE HONORARIOS = 2 - NO
		ordc_bhonorario=2
		ordc_mneto		=	request.Form("ordc_mneto")
		ordc_miva		=	request.Form("ordc_miva")
		ordc_mexento	=	request.Form("exento")
	end if

	
	if Esvacio(ordc_fentrega) or ordc_fentrega="" then
		fecha_entrega= "null"
	else
		fecha_entrega= "'"&ordc_fentrega&"'"
	end if

	
	if 	pers_nrut<>"" then
		v_pers_ncorr=conexion.consultaUno("Select pers_ncorr from personas where pers_nrut="&pers_nrut)
		'inserta datos del proveedor en caso que no exista
		if EsVAcio(v_pers_ncorr) or v_pers_ncorr="" then
			v_pers_ncorr=conexion.consultauno("exec obtenersecuencia 'personas'")
			sql_persona	=	" insert into personas (pers_ncorr,pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,pers_tfono,pers_tfax) "&_
							" values("&v_pers_ncorr&","&pers_nrut&",'"&pers_xdv&"','"&pers_tnombre&"','','', '"&pers_tfono&"', '"&pers_tfax&"') "		
			'RESPONSE.WRITE("20. sql_persona : "&sql_persona&"<BR>")		
			conexion.estadotransaccion conexion.ejecutas(sql_persona)			
		end if
	end if

'next ' FIN DEL FOR
'888888888888888888888888888888888888888888888888888888888888888888888888888
'RESPONSE.END()

'pers_nrut=request.Form("busqueda[0][pers_nrut]")

if pers_nrut <> "" then

			sql_persona	= "UPDATE [PERSONAS] "&_
   							" SET [PERS_TFONO] = '"&pers_tfono&"' "&_
      						" ,[PERS_TFAX] = '"&pers_tfax&"' "&_
 							" WHERE pers_nrut ="&pers_nrut
			conexion.estadotransaccion conexion.ejecutas(sql_persona)
end if


if v_ordc_ncorr ="" then

	' ESTAS SON LAS CONSULTAS QUE SE ESTAN EJECUTANDO
	' ESTA VARIABLE ES EL NUMERO DE ORDEN DE COMPRA
	v_ordc_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_orden_compra'")
	
	'response.write(v_ordc_ncorr&"<br>")

	if 	ordc_bhonorario=1 then	
	'RESPONSE.WRITE("1. IF - IF - BOLETA DE HONORARIOS = 1 - SI"&"<BR>")

		sql_orden_compra= 	" Insert into ocag_orden_compra (tsol_ccod,ordc_ncorr,vibo_ccod,area_ccod, tmon_ccod, ordc_mhonorarios,ordc_mretencion,cod_pre,ordc_mmonto,ordc_ndocto,pers_ncorr,fecha_solicitud,ordc_tatencion,ordc_ncotizacion,cpag_ccod, "&_
							" ordc_bboleta_honorario,ordc_tobservacion,ordc_tcontacto,ordc_tfono,ordc_fentrega,sede_ccod, audi_tusuario, audi_fmodificacion,ocag_responsable,ocag_fingreso,ocag_generador) "&_ 
							"	values(9,"&v_ordc_ncorr&","&prueba&","&area_ccod&","&tmon_ccod&","&v_total&","&ordc_mretencion&",'"&cod_pre&"',"&ordc_mmonto&","&v_ordc_ncorr&","&v_pers_ncorr&",getdate(),'"&ordc_tatencion&"','"&ordc_ncotizacion&"',"&cpag_ccod&", "&_ 
							" "&ordc_bhonorario&",'"&ordc_tobservacion&"','"&ordc_tcontacto&"','"&ordc_tfono&"',"&fecha_entrega&","&sede_ccod&", '"&v_usuario&"', getdate(), "&v_responsable&",getdate(), "&v_usuario&")"

	else
	'RESPONSE.WRITE("2. IF - ELSE - BOLETA DE HONORARIOS = 2 - NO "&"<BR>")

		sql_orden_compra= 	" Insert into ocag_orden_compra (tsol_ccod,ordc_ncorr,vibo_ccod,area_ccod, tmon_ccod, ordc_mneto,ordc_miva,cod_pre,ordc_mmonto,ordc_mexento,ordc_ndocto,pers_ncorr,fecha_solicitud,ordc_tatencion,ordc_ncotizacion,cpag_ccod, "&_
							" ordc_bboleta_honorario,ordc_tobservacion,ordc_tcontacto,ordc_tfono,ordc_fentrega,sede_ccod, audi_tusuario, audi_fmodificacion,ocag_responsable,ocag_fingreso,ocag_generador) "&_ 
							"	values(9,"&v_ordc_ncorr&","&prueba&","&area_ccod&","&tmon_ccod&","&ordc_mneto&","&ordc_miva&",'"&cod_pre&"',"&ordc_mmonto&","&ordc_mexento&","&v_ordc_ncorr&","&v_pers_ncorr&",getdate(),'"&ordc_tatencion&"','"&ordc_ncotizacion&"',"&cpag_ccod&", "&_ 
							" "&ordc_bhonorario&",'"&ordc_tobservacion&"','"&ordc_tcontacto&"','"&ordc_tfono&"',"&fecha_entrega&","&sede_ccod&", '"&v_usuario&"', getdate(),"&v_responsable&",getdate(), "&v_usuario&")"

	end if
else

	if 	ordc_bhonorario=1 then
	'RESPONSE.WRITE("3. ELSE - IF - BOLETA DE HONORARIOS = 1 - SI"&"<BR>")

		sql_orden_compra= 	" update ocag_orden_compra set vibo_ccod="&prueba&" ,ordc_mmonto="&ordc_mmonto&",ordc_mhonorarios="&v_total&",ordc_mretencion="&ordc_mretencion&","&_
							" area_ccod="&area_ccod&",tmon_ccod="&tmon_ccod&",cod_pre='"&cod_pre&"',ordc_ndocto="&v_ordc_ncorr&",pers_ncorr="&v_pers_ncorr&", "&_
							" ordc_tatencion='"&ordc_tatencion&"',ordc_ncotizacion='"&ordc_ncotizacion&"',cpag_ccod="&cpag_ccod&",ordc_bboleta_honorario="&ordc_bhonorario&", "&_
							" ordc_tobservacion='"&ordc_tobservacion&"',ordc_tcontacto='"&ordc_tcontacto&"',ordc_tfono='"&ordc_tfono&"',ordc_fentrega="&fecha_entrega&","&_
							" ocag_responsable="&v_responsable&",sede_ccod="&sede_ccod&",fecha_solicitud=getdate(), audi_tusuario='"&v_usuario&"', audi_fmodificacion=getdate(), "&_ 
							" ocag_fingreso='"&fecha_actual&"',ocag_generador="&v_usuario&", ocag_baprueba= NULL ,tsol_ccod=9 "&_
							" where ordc_ncorr="&v_ordc_ncorr

	else
	'RESPONSE.WRITE("4. ELSE - ELSE - BOLETA DE HONORARIOS = 2 - NO"&"<BR>")

		sql_orden_compra= 	" update ocag_orden_compra set ordc_mmonto="&ordc_mmonto&",ordc_mneto="&ordc_mneto&",ordc_miva="&ordc_miva&",ordc_mexento="&ordc_mexento&", "&_
							" vibo_ccod="&prueba&" ,area_ccod="&area_ccod&",tmon_ccod="&tmon_ccod&",cod_pre='"&cod_pre&"',ordc_ndocto="&v_ordc_ncorr&",pers_ncorr="&v_pers_ncorr&", "&_
							" ordc_tatencion='"&ordc_tatencion&"',ordc_ncotizacion='"&ordc_ncotizacion&"',cpag_ccod="&cpag_ccod&",ordc_bboleta_honorario="&ordc_bhonorario&", "&_
							" ordc_tobservacion='"&ordc_tobservacion&"',ordc_tcontacto='"&ordc_tcontacto&"',ordc_tfono='"&ordc_tfono&"',ordc_fentrega="&fecha_entrega&","&_
							" ocag_responsable="&v_responsable&",sede_ccod="&sede_ccod&",fecha_solicitud=getdate(), audi_tusuario='"&v_usuario&"', audi_fmodificacion=getdate(), "&_ 
							" ocag_fingreso='"&fecha_actual&"',ocag_generador="&v_usuario&", ocag_baprueba= NULL ,tsol_ccod=9 "&_
							" where ordc_ncorr="&v_ordc_ncorr	

	end if

	sql_borra_detalle		= "delete from ocag_detalle_orden_compra where ordc_ncorr="&v_ordc_ncorr
	
	'RESPONSE.WRITE("1 "&sql_borra_detalle&"<BR>")

' 88888888888888888888888888888888888888888888888888888888888888888888888888
'  La tabla "ocag_presupuesto_orden_compra" queda descontinuada a partir de 2013-06-04
'  Ahora utilizamos la tabla "ocag_presupuesto_solicitud".
' 88888888888888888888888888888888888888888888888888888888888888888888888888

'	sql_borra_presupuesto	= "delete from ocag_presupuesto_orden_compra where ordc_ncorr="&v_ordc_ncorr
	sql_borra_presupuesto	= "delete from ocag_presupuesto_solicitud where cod_solicitud="&v_ordc_ncorr
	
	'RESPONSE.WRITE("2 "&sql_borra_presupuesto&"<BR>")
	
	conexion.estadotransaccion conexion.ejecutas(sql_borra_detalle)
	
	conexion.estadotransaccion conexion.ejecutas(sql_borra_presupuesto)

end if

	'RESPONSE.WRITE("3 "&sql_orden_compra&"<BR>")

	conexion.estadotransaccion conexion.ejecutas(sql_orden_compra)
	
'************** INSERTA EL HISTORIAL DEL AUTORIZACIONES ***************
	set f_solicitud = new cFormulario
	f_solicitud.carga_parametros "orden_compra.xml", "autoriza_solicitud_giro"
	f_solicitud.inicializar conexion
	f_solicitud.procesaForm
	
	f_solicitud.AgregaCampoPost "cod_solicitud",v_ordc_ncorr
	f_solicitud.AgregaCampoPost "vibo_ccod", prueba
	f_solicitud.AgregaCampoPost "asgi_nestado", 1
	f_solicitud.AgregaCampoPost "tsol_ccod", 9
	f_solicitud.AgregaCampoPost "asgi_fautorizado", fecha_actual
	
	f_solicitud.MantieneTablas false	
	
'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")

'************** INSERTA EL DETALLE DE LA ORDEN DE COMPRA ***************

	set detalle_orden = new cFormulario
	detalle_orden.carga_parametros "orden_compra.xml", "detalle_orc"
	detalle_orden.inicializar conexion
	detalle_orden.procesaForm
	
	'response.write(fila&"<br>")
	'dos=detalle_orden.CuentaPost-1
	'response.write(dos&"<br>")
	
	
	for fila = 0 to contador'detalle_orden.CuentaPost-1		
		
			'response.write(v_dorc_ncorr&"<br>")
			
			tgas_ccod 		= detalle_orden.ObtenerValorPost (fila, "tgas_ccod")
			dorc_tdesc 		= detalle_orden.ObtenerValorPost (fila, "dorc_tdesc")
			ccos_ncorr 		= detalle_orden.ObtenerValorPost (fila, "ccos_ncorr")
			dorc_ncantidad 			= detalle_orden.ObtenerValorPost (fila, "dorc_ncantidad")
			dorc_nprecio_unitario 	= detalle_orden.ObtenerValorPost (fila, "dorc_nprecio_unidad")
			dorc_ndescuento 		= detalle_orden.ObtenerValorPost (fila, "dorc_ndescuento")
			dorc_nprecio_neto 		= detalle_orden.ObtenerValorPost (fila, "dorc_nprecio_neto")
			dorc_bafecta 			= detalle_orden.ObtenerValorPost (fila, "dorc_bafecta")
			
			'RESPONSE.WRITE(" 6. dorc_bafecta : "&dorc_bafecta&"<BR>")
			
			'if dorc_bafecta = "" then
			
			dorc_bafecta = request.Form("_detalle["&fila&"][dorc_bafecta]")
				if	dorc_bafecta="" or EsVacio(dorc_bafecta) then
					dorc_bafecta=2
				end if
			'RESPONSE.WRITE(" 7. dorc_bafecta : "&dorc_bafecta&"<BR>")
			'response.End()
			'end if
			
			'if	dorc_bafecta="" then
			'	dorc_bafecta=2
			'end if	
	
		if tgas_ccod<> ""then
			v_dorc_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_detalle_orden_compra'")
	
	'		sql_detalle= " Insert into ocag_detalle_orden_compra (dorc_ncorr,ordc_ncorr,tgas_ccod,dorc_tdesc,ccos_ncorr,dorc_ncantidad,tmon_ccod,dorc_nprecio_unidad,dorc_ndescuento,dorc_nprecio_neto, audi_tusuario, audi_fmodificacion,dorc_bafecta) "&_  
	'					 " values("&v_dorc_ncorr&","&v_ordc_ncorr&","&tgas_ccod&",'"&dorc_tdesc&"',"&ccos_ncorr&",'"&dorc_ncantidad&"',"&v_tmon_ccod&",'"&dorc_nprecio_unitario&"','"&dorc_ndescuento&"','"&dorc_nprecio_neto&"','"&v_usuario&"', getdate(),"&dorc_bafecta&")"
	
			sql_detalle= " Insert into ocag_detalle_orden_compra (dorc_ncorr,ordc_ncorr,tgas_ccod,dorc_tdesc,ccos_ncorr,dorc_ncantidad,tmon_ccod,dorc_nprecio_unidad,dorc_ndescuento,dorc_nprecio_neto, audi_tusuario, audi_fmodificacion,dorc_bafecta) "&_  
						 " values("&v_dorc_ncorr&","&v_ordc_ncorr&","&tgas_ccod&",'"&dorc_tdesc&"',"&ccos_ncorr&",'"&dorc_ncantidad&"',"&tmon_ccod&",'"&dorc_nprecio_unitario&"','"&dorc_ndescuento&"','"&dorc_nprecio_neto&"','"&v_usuario&"', getdate(),"&dorc_bafecta&")"
			
			'RESPONSE.WRITE("5 "&sql_detalle&"<BR>")
	
			conexion.estadotransaccion conexion.ejecutas(sql_detalle)
		end if	
	next

'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")

'************** INSERTA EL DETALLE DEL PRESUPUESTO ASOCIADO ***************
		
	set detalle_presupuesto = new cFormulario
	detalle_presupuesto.carga_parametros "orden_compra.xml", "detalle_presupuesto_orc"
	detalle_presupuesto.inicializar conexion
	detalle_presupuesto.procesaForm
	
	for fila = 0 to contador2'detalle_presupuesto.CuentaPost-1
	
		cod_pre 		= detalle_presupuesto.ObtenerValorPost (fila, "cod_pre")
		'anos_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "anos_ccod")
		'mes_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "mes_ccod")
		mes_ccod =  request.Form("busqueda["&fila&"][mes_ccod]")  
		anos_ccod = request.Form("busqueda["&fila&"][anos_ccod]")   
		
		'RESPONSE.WRITE("1. mes_ccod : "&mes_ccod&"<BR>")
		'RESPONSE.WRITE("2. anos_ccod : "&anos_ccod&"<BR>")
	
		porc_mpresupuesto 		= detalle_presupuesto.ObtenerValorPost (fila, "porc_mpresupuesto")
	
		if cod_pre<>"" then
		'v_porc_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_presupuesto_orden_compra'")
		v_porc_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_presupuesto_solicitud'")
		
		'response.write(v_porc_ncorr&"<br>")

' 88888888888888888888888888888888888888888888888888888888888888888888888888
'  La tabla "ocag_presupuesto_orden_compra" queda descontinuada a partir de 2013-06-04
'  Ahora utilizamos la tabla "ocag_presupuesto_solicitud".
' 88888888888888888888888888888888888888888888888888888888888888888888888888

		'sql_detalle_presupuesto= " Insert into ocag_presupuesto_orden_compra (porc_ncorr,ordc_ncorr,cod_pre,anos_ccod,porc_mpresupuesto,mes_ccod, audi_tusuario, audi_fmodificacion) "&_  
		'			 " values("&v_porc_ncorr&","&v_ordc_ncorr&",'"&cod_pre&"',"&anos_ccod&","&porc_mpresupuesto&","&mes_ccod&",'"&v_usuario&"', getdate())"

		sql_detalle_presupuesto= " Insert into ocag_presupuesto_solicitud "&_ 
					 " (psol_ncorr, tsol_ccod, cod_solicitud, cod_pre, anos_ccod, psol_mpresupuesto, mes_ccod, audi_tusuario, audi_fmodificacion)  "&_  
					 " values("&v_porc_ncorr&",9,"&v_ordc_ncorr&",'"&cod_pre&"',"&anos_ccod&","&porc_mpresupuesto&","&mes_ccod&",'"&v_usuario&"', getdate())"

		conexion.estadotransaccion conexion.ejecutas(sql_detalle_presupuesto)
		end if
	next

		'RESPONSE.WRITE("6 "&sql_detalle_presupuesto&"<BR>")
		'RESPONSE.END()
	
'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.EstadoTransaccion false
'response.End()

' 888888888888888888888888888888888888888888888888888888
' 888888888888888888888888888888888888888888888888888888

' 888888888888888888888888888888888888888888888888888888
' 888888888888888888888888888888888888888888888888888888 

v_estado_transaccion=conexion.ObtenerEstadoTransaccion


if v_estado_transaccion=false  then
	'response.Write("<br>Todo MAL")
	'response.end()
	session("mensaje_error")="No se pudo ingresar la orden de compra seleccionada.\nVuelva a intentarlo."
else	
	'response.Write("<br>Todo bien")
	'response.end()
	session("mensaje_error")="La Orden de compra N° "&v_ordc_ncorr&" fue ingresada correctamente."
end if

'Response.Redirect("buscar_orden_compra.asp?ordc_ncorr="&v_ordc_ncorr)
'Response.Redirect(request.ServerVariables("HTTP_REFERER"))
Response.Redirect("AUTORIZACION_GIROS.ASP")

%>

