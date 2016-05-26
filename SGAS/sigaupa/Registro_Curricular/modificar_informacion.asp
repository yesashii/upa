<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

Session("post_ncorr") = Request.QueryString("post_ncorr")

set postulante = new CPostulante
postulante.Inicializar conexion, Request.QueryString("post_ncorr")

Session("pers_ncorr") = postulante.ObtenerPersNCorr
Session("ses_modificar_informacion") = "S"
Response.Redirect("../matricula/postulacion_5.asp")
%>