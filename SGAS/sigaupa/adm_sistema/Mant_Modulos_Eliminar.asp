<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Modulos.xml", "f1"
formulario.Inicializar conexion
formulario.ProcesaForm

'formulario.ListarPost

formulario.MantieneTablas FALSE

'conexion.estadotransaccion false  'roolback 
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
