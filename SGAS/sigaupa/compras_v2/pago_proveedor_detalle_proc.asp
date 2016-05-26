<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.Write(request.ServerVariables("HTTP_REFERER"))
'response.End()

v_sogi_ncorr= request.Form("datos[0][sogi_ncorr]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_proveedor = new cFormulario
f_proveedor.carga_parametros "pago_proveedor.xml", "detalle_giro"
f_proveedor.inicializar conexion
f_proveedor.procesaForm

v_usuario=negocio.ObtenerUsuario()



if v_sogi_ncorr<>"" then

	v_dsgi_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_detalle_solicitud_giro'")
	
	f_proveedor.AgregaCampoPost "sogi_ncorr", v_sogi_ncorr
	f_proveedor.AgregaCampoPost "dsgi_ncorr", v_dsgi_ncorr
	f_proveedor.MantieneTablas false
	
end if

if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo ingresar una forma de pago asociada a la solicitud de giro.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="La nueva forma de pago fue ingresada correctamente."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>