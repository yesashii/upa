<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "m_personas_especialidades.xml", "f1"
formulario.Inicializar conexion
formulario.ProcesaForm

'formulario.ListarPost

conexion.EstadoTransaccion formulario.MantieneTablas(false)
'conexion.EstadoTransaccion false' esta linea se debe comentar ROLLBACK ( O J O )

'response.End()
'conexion.EstadoTransaccion f_destino.MantieneTablas(false)
transaccion = conexion.obtenerEstadoTransaccion
if 	transaccion=TRUE then
	session("mensajeError") = "Permisos para la especialidad eliminados con éxito."
else
	session("mensajeError") = "Error, Permisos para especialidad no fueron eliminados.\nFavor intentarlo nuevamente."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
