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
'FECHA ACTUALIZACION 	:10/07/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:
'*******************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

' RESCATAMOS  EL RUT DEL PROVEEDOR
'pers_nrut = request.Form("detalle[0][pers_nrut]")

' DIVIDIMOS EL RUT DEL PROVEEDOR 
'pers_nrut_02 = Split(pers_nrut, "-")

'V_RUT = pers_nrut_02(0)
'V_DV = pers_nrut_02(1)

v_ffij_ncorr	= 	request.Form("datos[0][ffij_ncorr]")
v_rffi_ncorr	= 	request.Form("rffi_ncorr")
v_responsable	= request.Form("busqueda[0][responsable]")

v_rendicion		=	request.Form("rendicion")
v_presupuesto	=	request.Form("total_presupuesto")
v_pers_nrut		=	request.Form("pers_nrut")

prueba=request.querystring("prueba")

'RESPONSE.WRITE("01 v_ffij_ncorr. "&v_ffij_ncorr&"<BR>")
'RESPONSE.WRITE("02 v_rffi_ncorr. "&v_rffi_ncorr&"<BR>")
'RESPONSE.WRITE("03 v_responsable. "&v_responsable&"<BR>")

'RESPONSE.WRITE("05 v_rendicion. "&v_rendicion&"<BR>")
'RESPONSE.WRITE("06 v_presupuesto. "&v_presupuesto&"<BR>")
'RESPONSE.WRITE("07 v_pers_nrut. "&v_pers_nrut&"<BR>")

'RESPONSE.WRITE("04 prueba. "&prueba&"<BR>")

'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_solicitud = new cFormulario
f_solicitud.carga_parametros "rendicion_fondo_fijo.xml", "datos_solicitud"
f_solicitud.inicializar conexion
f_solicitud.procesaForm

v_usuario=negocio.ObtenerUsuario()
fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
v_cantidad= f_solicitud.CuentaPost

if v_cantidad >=1 then
	sql_elimina_rendicion			="delete from ocag_rendicion_fondo_fijo where ffij_ncorr="&v_ffij_ncorr
	sql_elimina_detalle_rendicion	="delete from ocag_detalle_rendicion_fondo_fijo where ffij_ncorr="&v_ffij_ncorr

	conexion.estadotransaccion	conexion.ejecutas(sql_elimina_rendicion)
	conexion.estadotransaccion	conexion.ejecutas(sql_elimina_detalle_rendicion)
	'response.Write(sql_elimina_detalle_rendicion)
	'response.End()
end if

for fila = 0 to f_solicitud.CuentaPost - 1
	
	v_rffi_ndocto 	= f_solicitud.ObtenerValorPost (fila, "rffi_ndocto")
	
	if 	v_rffi_ncorr="" or EsVacio(v_rffi_ncorr) then
		' clave primaria, se obtiene con la secuencia
		v_rffi_ncorr=	conexion.consultauno("exec obtenersecuencia 'ocag_rendicion_fondo_fijo'")
	end if	
		f_solicitud.AgregaCampoFilaPost fila,"rffi_ncorr", v_rffi_ncorr
		' referencia a la tabla padre
		f_solicitud.AgregaCampoFilaPost fila,"ffij_ncorr", v_ffij_ncorr
		f_solicitud.AgregaCampoPost "ocag_fingreso", fecha_actual	
		f_solicitud.AgregaCampoPost "ocag_generador", v_usuario
		f_solicitud.AgregaCampoPost "ocag_responsable", v_responsable
		f_solicitud.AgregaCampoPost "vibo_ccod", prueba
		
		f_solicitud.AgregaCampoPost "tsol_ccod", 8
		f_solicitud.AgregaCampoPost "pers_nrut", v_pers_nrut
		f_solicitud.AgregaCampoPost "rffi_mmonto", v_rendicion
	
		'f_solicitud.AgregaCampoPost "pers_nrut", V_RUT
		'f_solicitud.AgregaCampoPost "pers_xdv", V_DV
next

'LA SIGUIENTE LINEA INSERTA REGISTROS EN LA TABALA "ocag_rendicion_fondo_fijo"
f_solicitud.MantieneTablas false

'response.End()



'response.Write("<hr>")
'************** INSERTA EL DETALLE DE PAGO DE LA RENDICION ***************
set f_detalle = new cFormulario
f_detalle.carga_parametros "rendicion_fondo_fijo.xml", "detalle_rendicion"
f_detalle.inicializar conexion
f_detalle.procesaForm


for fila = 0 to f_detalle.CuentaPost - 1

	v_drff_fdocto		= f_detalle.ObtenerValorPost (fila, "drff_fdocto")
	v_drff_ndocto 		= f_detalle.ObtenerValorPost (fila, "drff_ndocto")
	v_tgas_ccod 		= f_detalle.ObtenerValorPost (fila, "tgas_ccod")
	v_tdoc_ccod 		= f_detalle.ObtenerValorPost (fila, "tdoc_ccod")
	v_drff_mdocto 		= f_detalle.ObtenerValorPost (fila, "drff_mdocto")
	v_drff_mretencion	= f_detalle.ObtenerValorPost (fila, "drff_mretencion")
	v_drff_tdescripcion	= f_detalle.ObtenerValorPost (fila, "drff_tdesc")
	v_pers_nrut			= f_detalle.ObtenerValorPost (fila, "pers_nrut")
	v_pers_xdv			= f_detalle.ObtenerValorPost (fila, "pers_xdv")
	
	if v_pers_nrut="" or  EsVAcio(v_pers_nrut) then
		v_pers_nrut="null"
	end if
	'if v_drff_mretencion="" or EsVacio(v_drff_mretencion) then
	'	v_drff_mretencion=0
	'end if

	if v_drff_fdocto<>"" and v_drff_ndocto <>"" and v_drff_mdocto <>"" then
		
		v_drff_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_det_rendicion_fondofijo'")	
		
		sql_detalle_reembolso= " Insert into ocag_detalle_rendicion_fondo_fijo (drff_ncorr,rffi_ncorr,pers_nrut,pers_xdv,ffij_ncorr,tgas_ccod,tdoc_ccod,drff_ndocto,drff_mdocto,drff_tdesc,drff_fdocto,audi_tusuario,audi_fmodificacion) "&_  
					 " values("&v_drff_ncorr&","&v_rffi_ncorr&","&v_pers_nrut&",'"&v_pers_xdv&"',"&v_ffij_ncorr&","&v_tgas_ccod&","&v_tdoc_ccod&","&v_drff_ndocto&","&v_drff_mdocto&",'"&v_drff_tdescripcion&"','"&v_drff_fdocto&"','"&v_usuario&"', getdate())"
		
		'RESPONSE.WRITE("17. "&sql_detalle_reembolso&"<BR>")
		
		conexion.estadotransaccion	conexion.ejecutas(sql_detalle_reembolso)
	end if
	'response.Write("<hr>")
next



'************** INSERTA EL HISTORIAL DEL AUTORIZACIONES ***************
	set f_solicitud_vb = new cFormulario
	f_solicitud_vb.carga_parametros "vb_presupuesto.xml", "autoriza_solicitud_giro"
	f_solicitud_vb.inicializar conexion
	f_solicitud_vb.procesaForm
	
	f_solicitud_vb.AgregaCampoPost "cod_solicitud",v_ffij_ncorr
	f_solicitud_vb.AgregaCampoPost "vibo_ccod", prueba
	f_solicitud_vb.AgregaCampoPost "asgi_nestado", 1
	f_solicitud_vb.AgregaCampoPost "tsol_ccod", 8
	f_solicitud_vb.AgregaCampoPost "asgi_fautorizado", fecha_actual
	
	'LA SIGUIENTE LINEA INSERTA REGISTROS EN LA TABALA "ocag_autoriza_solicitud_giro"
	f_solicitud_vb.MantieneTablas false	
'response.Write("<br/><b> 3: "&conexion.obtenerEstadoTransaccion&"</b>")

'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.End()

'if v_estado_transaccion=false  then

if conexion.ObtenerEstadoTransaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo ingresar la rendicion de fondo fijo.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	'session("mensaje_error")="La rendicion de fondo fijo N° "&v_ffij_ncorr&" fue ingresada correctamente."
	session("mensaje_error")="La rendicion de fondo fijo N° "&v_rffi_ncorr&" fue ingresada correctamente."
end if

if url_final ="" then
	'url_final="rendicion_fondo_fijo.asp?cod_solicitud="&v_ffij_ncorr
	url_final="autorizacion_giros.asp"
end if

response.Redirect(url_final)

%>