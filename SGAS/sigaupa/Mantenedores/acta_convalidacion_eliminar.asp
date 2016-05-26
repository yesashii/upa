<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Título de la página"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set t_convalidaciones = new CFormulario
t_convalidaciones.Carga_Parametros "acta_convalidacion.xml", "convalidaciones"
t_convalidaciones.Inicializar conexion
t_convalidaciones.ProcesaForm

t_convalidaciones.MantieneTablas false
'conexion.estadotransaccion false  'roolback  

'-------------------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
