<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_descuentos = new CFormulario
f_descuentos.Carga_Parametros "Informe_Beneficios.xml", "descuentos"
f_descuentos.Inicializar conexion
f_descuentos.ProcesaForm
f_descuentos.MantieneTablas false

'------------------------------------------------------------------------------------------------------------
'conexion.estadotransaccion false  'roolback 
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
