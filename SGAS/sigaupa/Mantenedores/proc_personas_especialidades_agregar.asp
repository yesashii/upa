<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "m_personas_especialidades.xml", "f_sedes_usuario"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost
conexion.EstadoTransaccion formulario.MantieneTablas(false)
'response.End()
'conexion.EstadoTransaccion false' esta linea se debe comentar ROLLBACK ( O J O )
transaccion = conexion.obtenerEstadoTransaccion
if 	transaccion=TRUE then
	session("mensajeError") = "Permisos para la especialidad creados con éxito."
else
	session("mensajeError") = "Error, Permisos para especialidad no fueron creados.\nFavor intentarlo nuevamente."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>