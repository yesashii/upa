<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "desauas"


set f_requisitos = new CFormulario
f_requisitos.Carga_Parametros "requisitos_titulacion.xml", "requisitos"
f_requisitos.Inicializar conexion
f_requisitos.ProcesaForm

f_requisitos.MantieneTablas false
'conexion.estadotransaccion false

'-----------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>

