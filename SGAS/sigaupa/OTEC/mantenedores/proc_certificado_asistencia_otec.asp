<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()
'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()
'---------------------------------------------------------------->Captura de variables de la busqueda
set formulario = new CFormulario
formulario.Carga_Parametros "certificado_asistencia_otec.xml", "multigrilla"
formulario.Inicializar conexion
formulario.ProcesaForm		

formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los Anexos selecionados fueron actualizados correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar uno o mas anexos para este contrato.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
