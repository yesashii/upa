<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.estadoTransaccion false
set formulario = new CFormulario
formulario.Carga_Parametros "cambio_clave.xml", "f1_edicion"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.MantieneTablas false
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
