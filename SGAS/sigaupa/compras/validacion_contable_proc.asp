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
'LINEA			:
'*******************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

v_vcon_ncorr	= request.Form("datos[0][vcon_ncorr]")
v_aprueba		= request.Form("datos[0][aprueba]")
v_tsol_ccod		= request.Form("datos[0][tsol_ccod]")
v_cod_solicitud	= request.Form("datos[0][cod_solicitud]")
v_obs_contable	= request.Form("vcon_tmotivo_rechazo")

'RESPONSE.WRITE("1. v_vcon_ncorr : "&v_vcon_ncorr&"<BR>")
'RESPONSE.WRITE("2. v_aprueba : "&v_aprueba&"<BR>")
'RESPONSE.WRITE("3. v_tsol_ccod : "&v_tsol_ccod&"<BR>")
'RESPONSE.WRITE("4. v_cod_solicitud : "&v_cod_solicitud&"<BR>")
'RESPONSE.WRITE("5. v_obs_contable : "&v_obs_contable&"<BR>")
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_solicitud = new cFormulario
f_solicitud.carga_parametros "validacion_contable.xml", "datos_solicitud"
f_solicitud.inicializar conexion
f_solicitud.procesaForm

fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")

	if v_vcon_ncorr="" then ' Si la primera vez que la valida
	
		v_vcon_ncorr=conexion.consultaUno("exec obtenersecuencia 'ocag_validacion_contable'")
		
		f_solicitud.AgregaCampoFilaPost 0, "vcon_ncorr", v_vcon_ncorr
			
	else
		url_final=request.ServerVariables("HTTP_REFERER")
	
		sql_borra_costos="delete from ocag_centro_costo_validacion where vcon_ncorr="&v_vcon_ncorr
		'RESPONSE.WRITE("sql_borra_costos "&sql_borra_costos&"<BR>")
		conexion.estadotransaccion	conexion.ejecutas(sql_borra_costos)
		
		sql_borra_pagos	="delete from ocag_detalle_pago_validacion where vcon_ncorr="&v_vcon_ncorr
		'RESPONSE.WRITE("sql_borra_pagos "&sql_borra_pagos&"<BR>")
		conexion.estadotransaccion	conexion.ejecutas(sql_borra_pagos)
		
		sql_borra_tipo_dato	="delete from ocag_tipo_gasto_validacion where vcon_ncorr="&v_vcon_ncorr
		'RESPONSE.WRITE("sql_borra_tipo_dato "&sql_borra_tipo_dato&"<BR>")
		conexion.estadotransaccion	conexion.ejecutas(sql_borra_tipo_dato)	
	
	end if
	'response.Write("<br/><b> 0: "&conexion.obtenerEstadoTransaccion&"</b>")


	if v_aprueba="2" then
		' Rechaza la solicitud, Valores asgi_nestado (1= Aprobado, 3 = Rechazado, 5 = Observado)
		' Rechaza la solicitud, estado validacion contable 3 = nulo
		
		'RESPONSE.WRITE("1. asgi_nestado: "&asgi_nestado&"<BR>")
		
		if EsVacio(asgi_nestado) or asgi_nestado="" then
			asgi_nestado=3
		end if
		
		'response.write("asgi_nestado"&asgi_nestado&"<br>")
		
		if asgi_nestado = "5" then
				vibo_ccod = 10
			else
				vibo_ccod=3
			end if
		f_solicitud.AgregaCampoPost "vibo_ccod", vibo_ccod
		f_solicitud.AgregaCampoPost "asgi_nestado",  3
		'f_solicitud.AgregaCampoPost "asgi_observaciones", v_observaciones
		f_solicitud.AgregaCampoPost "asgi_observaciones", v_obs_contable
		f_solicitud.AgregaCampoPost "asgi_fautorizado", fecha_actual
		
	else
	
		if EsVacio(asgi_nestado) or asgi_nestado="" then
			asgi_nestado=1
		end if

		' Aprueba la validacion contable
		vibo_ccod=3
		f_solicitud.AgregaCampoPost "vibo_ccod", vibo_ccod
		f_solicitud.AgregaCampoPost "asgi_nestado", 1
		f_solicitud.AgregaCampoPost "asgi_fautorizado", fecha_actual
	end if
	
	'RESPONSE.WRITE("2. asgi_nestado: "&asgi_nestado&"<BR>")
	
	Select Case v_tsol_ccod
	   Case 1:
		'solicitud a proveedores
			sql_update_estado="update ocag_solicitud_giro set vibo_ccod="&vibo_ccod&" ,ocag_baprueba="&asgi_nestado&"  where sogi_ncorr="&v_cod_solicitud
	   Case 2:
		'reembolso gastos
			sql_update_estado="update ocag_reembolso_gastos set vibo_ccod="&vibo_ccod&" ,ocag_baprueba="&asgi_nestado&"  where rgas_ncorr="&v_cod_solicitud
	   Case 3:
		'fondos a rendir
			sql_update_estado="update ocag_fondos_a_rendir set vibo_ccod="&vibo_ccod&" ,ocag_baprueba="&asgi_nestado&"  where fren_ncorr="&v_cod_solicitud
	   Case 4:
		'viaticos
			sql_update_estado="update ocag_solicitud_viatico set vibo_ccod="&vibo_ccod&" ,ocag_baprueba="&asgi_nestado&"  where sovi_ncorr="&v_cod_solicitud
	   Case 5:
		'devolucion alumnos
			sql_update_estado="update ocag_devolucion_alumno set vibo_ccod="&vibo_ccod&" ,ocag_baprueba="&asgi_nestado&"  where dalu_ncorr="&v_cod_solicitud
	   Case 6:
		'fondo fijo
			sql_update_estado="update ocag_fondo_fijo set vibo_ccod="&vibo_ccod&" ,ocag_baprueba="&asgi_nestado&"  where ffij_ncorr="&v_cod_solicitud
	   Case 7:
	   		' Rndicion fondos a Rendir
			'sql_update	=	"update ocag_rendicion_fondos_a_rendir set vibo_ccod="&vibo_ccod&" where fren_ncorr="&v_cod_solicitud		
			sql_update_estado	=	"update ocag_rendicion_fondos_a_rendir set vibo_ccod="&vibo_ccod&" ,ocag_baprueba="&asgi_nestado&"  where rfre_ncorr="&v_cod_solicitud	
	   Case 8:
	       ' Rendicion Fondo Fijo	
			'sql_update	=	"update ocag_rendicion_fondo_fijo set vibo_ccod="&vibo_ccod&" where ffij_ncorr="&v_cod_solicitud
			sql_update_estado	=	"update ocag_rendicion_fondo_fijo set vibo_ccod="&vibo_ccod&" ,ocag_baprueba="&asgi_nestado&"  where rffi_ncorr="&v_cod_solicitud
	End Select
	
	'RESPONSE.WRITE("2. sql_update_estado : "&sql_update_estado&"<BR>")
	
	conexion.estadotransaccion	conexion.ejecutas(sql_update_estado)

	'v_cvso_ncorr=conexion.consultaUno("exec obtenersecuencia 'ocag_ciclo_vida_solicitud'")
	'sql_insert_ciclo=   "Insert into ocag_ciclo_vida_solicitud(cvso_ncorr, cod_solicitud,tsol_ccod,vibo_ccod,cvso_fvalida,audi_tusuario,audi_fmodificacion) "&_
	'					" Values("&v_cvso_ncorr&","&v_cod_solicitud&","&v_tsol_ccod&","&vibo_ccod&",'"&fecha_actual&"','"&v_usuario&"', getdate())"
	'response.Write(sql_insert_ciclo)
	'conexion.estadotransaccion  conexion.ejecutaS(sql_insert_ciclo)

	' 88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	' LA SIGUIENTE LINEA INSERTA REGISTRSOS EN LAS TABLAS "ocag_validacion_contable" Y "ocag_autoriza_solicitud_giro"
	f_solicitud.MantieneTablas false
	' 88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
set f_detalle_costos = new cFormulario
f_detalle_costos.carga_parametros "validacion_contable.xml", "detalle_costos"
f_detalle_costos.inicializar conexion
f_detalle_costos.procesaForm
for fila = 0 to f_detalle_costos.CuentaPost-1

	v_ccos_ncorr 		= f_detalle_costos.ObtenerValorPost (fila, "ccos_ncorr")
	v_ccos_mmonto 		= f_detalle_costos.ObtenerValorPost (fila, "ccva_mmonto")
	
	if 	v_ccos_ncorr<>"" then
		
		v_ccva_ncorr=conexion.consultaUno("exec obtenersecuencia 'ocag_centro_costo_validacion'")
		if v_ccva_ncorr <>"" then
			sql_centro_costo	=	" Insert ocag_centro_costo_validacion (ccva_ncorr,vcon_ncorr,ccos_ncorr,ccva_mmonto, audi_tusuario, audi_fmodificacion) "&_
									" values ("&v_ccva_ncorr&","&v_vcon_ncorr&",'"&v_ccos_ncorr&"','"&v_ccos_mmonto&"','"&v_usuario&"',getdate())"	
									
			'RESPONSE.WRITE("4. sql_centro_costo : "&sql_centro_costo&"<BR>")
			
			conexion.estadotransaccion	conexion.ejecutas(sql_centro_costo)
		end if
	end if
	
next

'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")

set f_detalle_pago = new cFormulario
f_detalle_pago.carga_parametros "validacion_contable.xml", "detalle_pago"
f_detalle_pago.inicializar conexion
f_detalle_pago.procesaForm
for fila = 0 to f_detalle_pago.CuentaPost-1
		
	v_dpva_fpago 		= f_detalle_pago.ObtenerValorPost (fila, "dpva_fpago")
	v_dpva_mdetalle 	= f_detalle_pago.ObtenerValorPost (fila, "dpva_mdetalle")

		if 	v_dpva_fpago<>"" then
			v_dpva_ncorr=conexion.consultaUno("exec obtenersecuencia 'ocag_detalle_pago_validacion'")
			if v_dpva_ncorr <>"" then
			
				sql_detalle_pago	=	" Insert ocag_detalle_pago_validacion (vcon_ncorr,dpva_ncorr,dpva_fpago,dpva_mdetalle, audi_tusuario, audi_fmodificacion) "&_
										" values ("&v_vcon_ncorr&","&v_dpva_ncorr&",'"&v_dpva_fpago&"','"&v_dpva_mdetalle&"','"&v_usuario&"',getdate())"	
										
				'RESPONSE.WRITE("5. sql_detalle_pago : "&sql_detalle_pago&"<BR>")
				
				conexion.estadotransaccion	conexion.ejecutas(sql_detalle_pago)
			end if
		end if	

next

'response.Write("<br/><b> 3: "&conexion.obtenerEstadoTransaccion&"</b>")

set f_tipo_gasto = new cFormulario
f_tipo_gasto.carga_parametros "validacion_contable.xml", "detalle_tipo_gasto"
f_tipo_gasto.inicializar conexion
f_tipo_gasto.procesaForm
for fila = 0 to f_tipo_gasto.CuentaPost-1

	v_tgas_ccod = request.Form("busqueda["&fila&"][tgas_ccod]")        
	v_tgva_mmonto 	= f_tipo_gasto.ObtenerValorPost (fila, "tgva_mmonto")
	v_tgva_tcuenta_contable = request.Form("busqueda["&fila&"][tgas_cod_cuenta]")       
	
	if 	v_tgas_ccod <> "" then
	
		v_tgva_ncorr=conexion.consultaUno("exec obtenersecuencia 'ocag_tipo_gasto_validacion'")
		
		if v_tgva_ncorr <>"" then
		
			sql_detalle_tipo_gasto	=	" Insert ocag_tipo_gasto_validacion (vcon_ncorr,tgva_ncorr,tgas_ccod,tgva_tcuenta_contable,tgva_mmonto, audi_tusuario, audi_fmodificacion) "&_
									" values ("&v_vcon_ncorr&","&v_tgva_ncorr&","&v_tgas_ccod&",'"&v_tgva_tcuenta_contable&"','"&v_tgva_mmonto&"','"&v_usuario&"',getdate())"	
									
			'RESPONSE.WRITE("6. sql_detalle_tipo_gasto : "&sql_detalle_tipo_gasto&"<BR>")
			
			conexion.estadotransaccion	conexion.ejecutas(sql_detalle_tipo_gasto)
			
		end if
	end if	
	
next

v_estado_transaccion=conexion.ObtenerEstadoTransaccion

if v_estado_transaccion=false  then
	session("mensaje_error")="No se pudo ingresar la validacion contable.\nVuelva a intentarlo."
else	
	session("mensaje_error")="La validacion contable fue ingresada correctamente."
end if

if url_final ="" then
	'url_final=request.ServerVariables("HTTP_REFERER")&"&busqueda[0][vcon_ncorr]="&v_vcon_ncorr
	url_final="VALIDACION_CONTABLE.ASP"
end if

'response.end()
response.Redirect(url_final)

%>