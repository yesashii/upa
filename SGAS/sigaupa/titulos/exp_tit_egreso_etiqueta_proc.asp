<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.end

pers_ncorr		  = request.Form("egreso[0][pers_ncorr]")
plan_ccod		  = request.Form("egreso[0][plan_ccod]")
imprimir_etiqueta = request.Form("egreso[0][imprimir_etiqueta]")


'-------------------------------------------------------------------------------------------------'
set conexion = new CConexion
conexion.Inicializar "upacifico"


c_update  = " update detalles_titulacion_carrera set imprimir_etiqueta = '"&imprimir_etiqueta&"' "&_
			" where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' "
conexion.ejecutaS c_update


if conexion.obtenerEstadoTransaccion then
		session("msjOk")="Los datos han sido grabados exitosamente"
end if
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

