<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

'response.Write(request.ServerVariables("HTTP_REFERER"))
'response.End()


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_detalle = new cFormulario
f_detalle.carga_parametros "pago_proveedor.xml", "detalle_giro"
f_detalle.inicializar conexion
f_detalle.procesaForm

v_usuario=negocio.ObtenerUsuario()
'response.Write(f_detalle.CuentaPost)
for fila = 0 to f_detalle.CuentaPost - 1
'response.Write("saasd<br>")
	v_dsgi_ncorr = f_detalle.ObtenerValorPost (fila, "dsgi_ncorr")

	if v_dsgi_ncorr<>"" then
	
		sql_elimina="delete from ocag_detalle_solicitud_giro where dsgi_ncorr="&v_dsgi_ncorr
		response.Write("<br>"&sql_elimina)
		conexion.estadotransaccion	conexion.ejecutas(sql_elimina)
		
	end if
next

response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")
conexion.estadotransaccion false
response.End()

if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo eliminar la forma de pago asociada a la solicitud de giro.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="La forma de pago fue eliminada correctamente."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>