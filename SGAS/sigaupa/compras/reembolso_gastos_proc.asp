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
'FECHA ACTUALIZACION 	:17/06/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:157
'*******************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

prueba=request.querystring("prueba")
'conexion.obtenerEstadoTransaccion false
v_rgas_ncorr= request.Form("datos[0][rgas_ncorr]")
v_area_ccod	= request.Form("busqueda[0][area_ccod]")
v_responsable	= request.Form("busqueda[0][responsable]")
contador=request.Form("contador")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()
fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")

set f_proveedor = new cFormulario
f_proveedor.carga_parametros "reembolso_gasto.xml", "datos_proveedor"
f_proveedor.inicializar conexion
f_proveedor.procesaForm

v_usuario=negocio.ObtenerUsuario()

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
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

'response.Write("<br/><b> 1: "&conexion.obtenerEstadoTransaccion&"</b>")
next


if EsVAcio(v_rgas_ncorr) or v_rgas_ncorr="" then
	v_rgas_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_reembolso_gastos'")

	f_proveedor.AgregaCampoPost "pers_ncorr_proveedor", v_pers_ncorr
	f_proveedor.AgregaCampoPost "rgas_ncorr", v_rgas_ncorr
	f_proveedor.AgregaCampoPost "area_ccod", v_area_ccod
	f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	f_proveedor.AgregaCampoPost "ocag_baprueba", "NULL"
else
	url_final=request.ServerVariables("HTTP_REFERER")
	sql_borra_presupuesto	= "delete from ocag_presupuesto_solicitud where tsol_ccod=2 and cod_solicitud="&v_rgas_ncorr
	sql_borra_detalle		= "delete from ocag_detalle_reembolso_gasto where rgas_ncorr="&v_rgas_ncorr
	
	'RESPONSE.WRITE("1. "&sql_borra_presupuesto&"<BR>")
	'RESPONSE.WRITE("2. "&sql_borra_detalle&"<BR>")
	
	conexion.estadotransaccion	conexion.ejecutas(sql_borra_presupuesto)
	conexion.estadotransaccion	conexion.ejecutas(sql_borra_detalle)
end if	
	f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	f_proveedor.AgregaCampoPost "ocag_baprueba", "NULL"
	f_proveedor.AgregaCampoPost "ocag_fingreso", fecha_actual	
	f_proveedor.AgregaCampoPost "ocag_generador", v_usuario
	f_proveedor.AgregaCampoPost "ocag_responsable", v_responsable

f_proveedor.MantieneTablas false
'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")

'************** INSERTA EL HISTORIAL DEL AUTORIZACIONES ***************
	set f_solicitud = new cFormulario
	f_solicitud.carga_parametros "vb_presupuesto.xml", "autoriza_solicitud_giro"
	f_solicitud.inicializar conexion
	f_solicitud.procesaForm
	
	f_solicitud.AgregaCampoPost "cod_solicitud",v_rgas_ncorr
	f_solicitud.AgregaCampoPost "vibo_ccod", prueba
	f_solicitud.AgregaCampoPost "ocag_baprueba", "NULL"
	f_solicitud.AgregaCampoPost "asgi_nestado", 1
	f_solicitud.AgregaCampoPost "tsol_ccod", 2
	f_solicitud.AgregaCampoPost "asgi_fautorizado", fecha_actual
	
	'LA SIGUIENTE INSTRUCCION INSERTA REGISTROS EN LA TABLA "ocag_reembolso_gastos"
	f_solicitud.MantieneTablas false


'************** INSERTA EL DETALLE DEL PRESUPUESTO ASOCIADO ***************
set detalle_presupuesto = new cFormulario
detalle_presupuesto.carga_parametros "datos_presupuesto.xml", "detalle_presupuesto"
detalle_presupuesto.inicializar conexion
detalle_presupuesto.procesaForm

for fila = 0 to contador'detalle_presupuesto.CuentaPost-1

	cod_pre 		= detalle_presupuesto.ObtenerValorPost (fila, "cod_pre")
	'anos_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "anos_ccod")
	'mes_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "mes_ccod")
	mes_ccod =  request.Form("busqueda["&fila&"][mes_ccod]")  
	anos_ccod = request.Form("busqueda["&fila&"][anos_ccod]")   
	
	
	psol_mpresupuesto 		= detalle_presupuesto.ObtenerValorPost (fila, "psol_mpresupuesto")

	if cod_pre <> "" then
	v_psol_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_presupuesto_solicitud'")	

	sql_detalle_presupuesto= " Insert into ocag_presupuesto_solicitud (psol_ncorr,tsol_ccod,cod_solicitud,cod_pre,anos_ccod,psol_mpresupuesto,mes_ccod, audi_tusuario, audi_fmodificacion) "&_  
				 " values("&v_psol_ncorr&",2,"&v_rgas_ncorr&",'"&cod_pre&"',"&anos_ccod&","&psol_mpresupuesto&","&mes_ccod&",'"&v_usuario&"', getdate())"
	
	'RESPONSE.WRITE("3. "&sql_detalle_presupuesto&"<BR>")
	
	conexion.estadotransaccion	conexion.ejecutas(sql_detalle_presupuesto)
	end if
next
'******************************************************************************
'response.Write("<br><b> 3: "&conexion.obtenerEstadoTransaccion&"</b><br>")


set f_detalle = new cFormulario
f_detalle.carga_parametros "reembolso_gasto.xml", "detalle_reembolso"
f_detalle.inicializar conexion
f_detalle.procesaForm



for fila = 0 to f_detalle.CuentaPost - 1

	v_drga_fdocto		= f_detalle.ObtenerValorPost (fila, "drga_fdocto")
	v_drga_ndocto 		= f_detalle.ObtenerValorPost (fila, "drga_ndocto")
	v_tgas_ccod 		= f_detalle.ObtenerValorPost (fila, "tgas_ccod")
	v_tdoc_ccod 		= f_detalle.ObtenerValorPost (fila, "tdoc_ccod")
	'v_drga_mdocto 		= f_detalle.ObtenerValorPost (fila, "drga_mdocto")
	'v_drga_mretencion	= f_detalle.ObtenerValorPost (fila, "drga_mretencion")
	v_drga_tdescripcion	= f_detalle.ObtenerValorPost (fila, "drga_tdescripcion")
	v_ccos_ncorr	= f_detalle.ObtenerValorPost (fila, "ccos_ncorr")

	v_drga_mafecto 			= f_detalle.ObtenerValorPost (fila, "drga_mafecto")
	v_drga_miva				= f_detalle.ObtenerValorPost (fila, "drga_miva")
	v_drga_mexento 		= f_detalle.ObtenerValorPost (fila, "drga_mexento")
	v_drga_mhonorarios	= f_detalle.ObtenerValorPost (fila, "drga_mhonorarios")
	v_drga_mretencion 	= f_detalle.ObtenerValorPost (fila, "drga_mretencion")
	v_drga_mdocto			= f_detalle.ObtenerValorPost (fila, "drga_mdocto")
	v_drga_bboleta_honorario	= f_detalle.ObtenerValorPost (fila, "drga_bboleta_honorario")
	
	'if v_drga_mretencion="" or EsVacio(v_drga_mretencion) then
	'	v_drga_mretencion=0
	'end if

	if v_drga_fdocto<>"" and v_drga_ndocto <>"" and v_drga_mdocto <>"" and v_drga_bboleta_honorario<>"" then
		
		v_drga_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_detalle_reembolso_gasto'")	
		
'		sql_detalle_reembolso= " Insert into ocag_detalle_reembolso_gasto (drga_ncorr,rgas_ncorr,tgas_ccod,tdoc_ccod,drga_ndocto,drga_mdocto,drga_mretencion,drga_tdescripcion,drga_fdocto,audi_tusuario,audi_fmodificacion) "&_  
'					 " values("&v_drga_ncorr&","&v_rgas_ncorr&","&v_tgas_ccod&","&v_tdoc_ccod&","&v_drga_ndocto&","&v_drga_mdocto&","&v_drga_mretencion&",'"&v_drga_tdescripcion&"','"&v_drga_fdocto&"','"&v_usuario&"', getdate())"

'		sql_detalle_reembolso= " Insert into ocag_detalle_reembolso_gasto (drga_ncorr,rgas_ncorr,tgas_ccod,tdoc_ccod,drga_ndocto,drga_mdocto,drga_mretencion,drga_tdescripcion,drga_fdocto,audi_tusuario,audi_fmodificacion, ccos_ncorr) "&_  
'					 " values("&v_drga_ncorr&","&v_rgas_ncorr&","&v_tgas_ccod&","&v_tdoc_ccod&","&v_drga_ndocto&","&v_drga_mdocto&","&v_drga_mretencion&",'"&v_drga_tdescripcion&"','"&v_drga_fdocto&"','"&v_usuario&"', getdate(),"&v_ccos_ncorr&")"

		if cstr(v_drga_bboleta_honorario)=cstr(1) then
		'BOLETA
		
		sql_detalle_reembolso= "Insert into ocag_detalle_reembolso_gasto "&_ 
									" ( drga_ncorr, rgas_ncorr, tgas_ccod, tdoc_ccod, drga_ndocto "&_ 
									" , drga_tdescripcion, drga_fdocto, audi_tusuario, audi_fmodificacion, ccos_ncorr "&_ 
									" , drga_mhonorarios, drga_mretencion, drga_mdocto, drga_bboleta_honorario) "&_ 
									" values "&_ 
									" ( "&v_drga_ncorr&", "&v_rgas_ncorr&", "&v_tgas_ccod&", "&v_tdoc_ccod&", "&v_drga_ndocto&" "&_ 
									" , '"&v_drga_tdescripcion&"', '"&v_drga_fdocto&"', '"&v_usuario&"', getdate(), "&v_ccos_ncorr&" "&_ 
									" , "&v_drga_mhonorarios&", "&v_drga_mretencion&", "&v_drga_mdocto&", "&v_drga_bboleta_honorario&")"
	
		end if
		'FACTURA

		if cstr(v_drga_bboleta_honorario)=cstr(2) then

		sql_detalle_reembolso= "Insert into ocag_detalle_reembolso_gasto "&_ 
									" ( drga_ncorr, rgas_ncorr, tgas_ccod, tdoc_ccod, drga_ndocto "&_ 
									" , drga_tdescripcion, drga_fdocto, audi_tusuario, audi_fmodificacion, ccos_ncorr "&_ 
									" , drga_mafecto, drga_miva, drga_mexento, drga_mdocto, drga_bboleta_honorario) "&_ 
									" values "&_ 
									" ( "&v_drga_ncorr&", "&v_rgas_ncorr&", "&v_tgas_ccod&", "&v_tdoc_ccod&", "&v_drga_ndocto&" "&_ 
									" , '"&v_drga_tdescripcion&"', '"&v_drga_fdocto&"', '"&v_usuario&"', getdate(), "&v_ccos_ncorr&" "&_ 
									" , "&v_drga_mafecto&", "&v_drga_miva&", "&v_drga_mexento&", "&v_drga_mdocto&", "&v_drga_bboleta_honorario&")"

		end if

		'RESPONSE.WRITE("4. sql_detalle_reembolso: "&sql_detalle_reembolso&"<BR>")
		
		'response.end()
		
		conexion.estadotransaccion	conexion.ejecutas(sql_detalle_reembolso)
	
	end if
	
next

'response.Write("<br><b> Final: "&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.End()

if conexion.obtenerEstadoTransaccion=false  then
	session("mensaje_error")="No se pudo ingresar la solicitud reembolso de gastos.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="La solicitud de reembolso N°: "&v_rgas_ncorr&" de gastos fue ingresada correctamente."
end if
url_final="autorizacion_giros.asp"
'response.write url_final
'response.end()


'if url_final ="" then
	'url_final="solicitud_viaticos.asp?busqueda[0][sovi_ncorr]="&v_sovi_ncorr
'	url_final="autorizacion_giros.asp"
'end if

'response.write url_final
'response.end()

response.Redirect(url_final)

%>