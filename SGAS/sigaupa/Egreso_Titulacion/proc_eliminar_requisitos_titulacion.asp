<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_requisitos = new CFormulario
f_requisitos.Carga_Parametros "adm_requisitos_titulacion.xml", "requisitos_ingresados"
f_requisitos.Inicializar conexion
f_requisitos.ProcesaForm

f_requisitos.MantieneTablas false

Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
