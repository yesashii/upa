<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_solicitud = new CFormulario
f_solicitud.Carga_Parametros "solicitud_credito_cae.xml", "solicitud_credito_cae"
f_solicitud.Inicializar conexion
f_solicitud.ProcesaForm



f_solicitud.MantieneTablas false
'response.End()

'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.EstadoTransaccion false
'response.End()

'---------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>