<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "adm_salidas_asignaturas.xml", "asignaturas"
f_asignaturas.Inicializar conexion
f_asignaturas.ProcesaForm

f_asignaturas.MantieneTablas false



Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

