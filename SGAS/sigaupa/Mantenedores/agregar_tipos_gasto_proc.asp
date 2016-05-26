<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()
fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")


set f_solicitud = new cFormulario
f_solicitud.carga_parametros "areas_gastos.xml", "tipos_gastos"
f_solicitud.inicializar conexion
f_solicitud.procesaForm



for fila = 0 to f_solicitud.CuentaPost - 1

	v_tgas_ccod		= f_solicitud.ObtenerValorPost (fila, "tgas_ccod")
	
		if v_tgas_ccod="" or EsVacio(v_tgas_ccod) then
			f_solicitud.EliminaFilaPost fila 
		end if


next

f_solicitud.MantieneTablas false


'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.End()

	
if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo eliminar el tipo de gasto asociado al perfil.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="El tipo de dato seleccionado fue eliminado exitosamente del perfil asociado."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>