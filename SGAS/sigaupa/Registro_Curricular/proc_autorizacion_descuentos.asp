<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_descuentos = new CFormulario
f_descuentos.Carga_Parametros "autorizacion_descuentos.xml", "descuentos"
f_descuentos.Inicializar conexion
f_descuentos.ProcesaForm
f_descuentos.MantieneTablas false

'------------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
