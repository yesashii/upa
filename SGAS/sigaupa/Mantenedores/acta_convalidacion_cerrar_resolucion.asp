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
sentencia = "UPDATE resoluciones SET eres_ccod = 1,audi_tusuario='"&negocio.obtenerUsuario&"',audi_fmodificacion=getDate() WHERE reso_ncorr = " & Request.QueryString("reso_ncorr")
conexion.EjecutaS sentencia

Response.Redirect("acta_convalidacion.asp?reso_ncorr=" & Request.QueryString("reso_ncorr"))
%>
