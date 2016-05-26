<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->



<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Fin"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'response.End()
Session.Abandon()
response.Redirect("portada_empresa.asp")
%>
