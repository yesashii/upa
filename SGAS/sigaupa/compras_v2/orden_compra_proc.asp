<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next



set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_proveedor = new cFormulario
f_proveedor.carga_parametros "orden_compra.xml", "buscador"
f_proveedor.inicializar conexion
f_proveedor.procesaForm

v_usuario=negocio.ObtenerUsuario()

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
for fila = 0 to f_proveedor.CuentaPost - 1
	pers_nrut 		= f_proveedor.ObtenerValorPost (fila, "pers_nrut")
	pers_xdv 		= f_proveedor.ObtenerValorPost (fila, "pers_xdv")
	pers_tnombre 	= f_proveedor.ObtenerValorPost (fila, "pers_tnombre")
	pers_tfono 		= f_proveedor.ObtenerValorPost (fila, "pers_tfono")
	pers_tfax 		= f_proveedor.ObtenerValorPost (fila, "pers_tfax")
	dire_tcalle 	= f_proveedor.ObtenerValorPost (fila, "dire_tcalle")
	dire_tnro 		= f_proveedor.ObtenerValorPost (fila, "dire_tnro")
	ciud_ccod 		= f_proveedor.ObtenerValorPost (fila, "ciud_ccod")
	
	ordc_ncotizacion 	= f_proveedor.ObtenerValorPost (fila, "ordc_ncotizacion")
	ordc_tatencion 		= f_proveedor.ObtenerValorPost (fila, "ordc_tatencion")   
	cpag_ccod 			= f_proveedor.ObtenerValorPost (fila, "cpag_ccod")
	ordc_tobservacion 	= f_proveedor.ObtenerValorPost (fila, "ordc_tobservacion")
	ordc_tcontacto 	= f_proveedor.ObtenerValorPost (fila, "ordc_tcontacto")
	ordc_tfono 		= f_proveedor.ObtenerValorPost (fila, "ordc_tfono")
	ordc_fentrega 	= f_proveedor.ObtenerValorPost (fila, "ordc_fentrega")
	sede_ccod 		= f_proveedor.ObtenerValorPost (fila, "sede_ccod")
	
'response.Write("<hr>"&pers_nrut&"<br/>")

if 	pers_nrut<>"" then
	
	v_pers_ncorr=conexion.consultaUno("Select pers_ncorr from personas where pers_nrut="&pers_nrut)
	'inserta datos del proveedor y su direccion o los actualiza
	if v_pers_ncorr <>"" then
		sql_persona	=	" Update personas set pers_tnombre='"&pers_tnombre&"', pers_tfono='"&pers_tfono&"', pers_tfax='"&pers_tfax&"' "&_
						" where pers_nrut="&pers_nrut	
				
		sql_direccion=	" Update direcciones set dire_tcalle='"&dire_tcalle&"', dire_tnro='"&dire_tnro&"', ciud_ccod='"&ciud_ccod&"' "&_
						" where pers_ncorr="&v_pers_ncorr	
	else
		v_pers_ncorr=conexion.consultauno("exec generasecuencia 'personas'")
		sql_persona	=	" insert into personas(pers_tnombre,pers_tfono,pers_tfax) values('"&pers_tnombre&"', '"&pers_tfono&"', '"&pers_tfax&"') "
		sql_direccion=	" insert into  direcciones(pers_ncorr,dire_tcalle,dire_tnro,ciud_ccod) valor("&v_pers_ncorr&",'"&dire_tcalle&"', '"&dire_tnro&"', '"&ciud_ccod&"')"
	end if

	conexion.estadotransaccion	conexion.ejecutas(sql_persona)
	conexion.estadotransaccion	conexion.ejecutas(sql_direccion)
end if

'response.Write("<b>"&conexion.obtenerEstadoTransaccion&"</b>")
'response.Write("<hr>"&sql_persona&"<br/>"&sql_direccion)
			
next

if v_ordc_ncorr ="" then

	v_ordc_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_orden_compra'")

	sql_orden_compra= "Insert into ocag_orden_compra (ordc_ncorr,ordc_ndocto,pers_ncorr,fecha_solicitud,ordc_tatencion,ordc_ncotizacion,cpag_ccod,ordc_tobservacion,ordc_tcontacto,ordc_tfono,ordc_fentrega,sede_ccod, audi_tusuario, audi_fmodificacion) "&_ 
				  "	values("&v_ordc_ncorr&","&v_ordc_ncorr&","&v_pers_ncorr&",getdate(),'"&ordc_tatencion&"','"&ordc_ncotizacion&"',"&cpag_ccod&",'"&ordc_tobservacion&"','"&ordc_tcontacto&"','"&ordc_tfono&"','"&ordc_fentrega&"',"&sede_ccod&", '"&v_usuario&"', getdate())"

'response.Write("<hr>"&sql_orden_compra&"<br/>")
	conexion.estadotransaccion	conexion.ejecutas(sql_orden_compra)
	'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")


	set detalle_orden = new cFormulario
	detalle_orden.carga_parametros "orden_compra.xml", "detalle_orc"
	detalle_orden.inicializar conexion
	detalle_orden.procesaForm
	
	for fila = 1 to detalle_orden.CuentaPost
		
		v_dorc_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_detalle_orden_compra'")
		
		tgas_ccod 		= detalle_orden.ObtenerValorPost (fila, "tgas_ccod")
		dorc_tdesc 		= detalle_orden.ObtenerValorPost (fila, "dorc_tdesc")
		ccos_ccod 		= detalle_orden.ObtenerValorPost (fila, "ccos_ccod")
		cod_pre 		= detalle_orden.ObtenerValorPost (fila, "cod_pre")
		mes_ccod 		= detalle_orden.ObtenerValorPost (fila, "mes_ccod")
		dorc_ncantidad 			= detalle_orden.ObtenerValorPost (fila, "dorc_ncantidad")
		tmon_ccod 				= detalle_orden.ObtenerValorPost (fila, "tmon_ccod")
		dorc_nprecio_unitario 	= detalle_orden.ObtenerValorPost (fila, "dorc_nprecio_unitario")
		dorc_ndescuento 		= detalle_orden.ObtenerValorPost (fila, "dorc_ndescuento")
		dorc_nprecio_neto 		= detalle_orden.ObtenerValorPost (fila, "dorc_nprecio_neto")



		sql_detalle= " Insert into ocag_detalle_orden_compra(dorc_ncorr,ordc_ncorr,tgas_ccod,dorc_tdesc,ccos_ccod,cod_pre,mes_ccod,dorc_ncantidad,tmon_ccod,dorc_nprecio_unidad,dorc_ndescuento,dorc_nprecio_neto, audi_tusuario, audi_fmodificacion) "&_  
					 " values("&v_dorc_ncorr&","&v_ordc_ncorr&","&tgas_ccod&",'"&dorc_tdesc&"',"&ccos_ccod&",'"&cod_pre&"',"&mes_ccod&",'"&dorc_ncantidad&"',"&tmon_ccod&",'"&dorc_nprecio_unitario&"','"&dorc_ndescuento&"','"&dorc_nprecio_neto&"','"&v_usuario&"', getdate())"

		'response.Write("<hr>"&sql_detalle)

	conexion.estadotransaccion	conexion.ejecutas(sql_detalle)
		
	next
	
end if

'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")
'response.End()


if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo ingresar la orden de compra seleccionada.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="La Orden de compra fue ingresada correctamente."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>