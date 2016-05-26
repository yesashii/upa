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
'-------------------------------------------------------------------------------------------------
set f_enfermedades = new CFormulario
f_enfermedades.Carga_Parametros "seguimiento_otec.xml", "f_insertar"
f_enfermedades.Inicializar conexion
f_enfermedades.ProcesaForm
f_enfermedades.MantieneTablas false

'response.End()
if conexion.ObtenerEstadoTransaccion then
	conexion.MensajeError "Las observaciones de la postulación del alumno se guardaron correctamente."
end if
'conexion.estadotransaccion true

'---------------------------------------------------------------------------------------------------------------
'Response.Redirect("postulacion_4.asp")
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

