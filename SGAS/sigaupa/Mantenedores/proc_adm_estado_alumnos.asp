<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_alumno = new CFormulario
f_alumno.Carga_Parametros "adm_estado_alumnos.xml", "alumno"
f_alumno.Inicializar conexion
f_alumno.ProcesaForm

f_alumno.MantieneTablas false


'conexion.estadoTransaccion false
'response.End()
if conexion.ObtenerEstadoTransaccion then
	conexion.MensajeError "El cambio de estado se ha realizado correctamente."
end if

'response.End()
'------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
