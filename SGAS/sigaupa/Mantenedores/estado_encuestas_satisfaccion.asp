<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
RUT=request.QueryString("user")
rut2=request.Form("user")

'response.Write("<br>RUT="&RUT)
'response.Write("<br>rut2="&rut2)
'
'response.End()
if RUT<>"" then
session("rut_usuario") = RUT
devuelta="si"
end if


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


if devuelta="si" then
response.Redirect("../lanzadera/lanzadera.asp")
else
usu=negocio.obtenerUsuario
response.Redirect("http://admision.upacifico.cl/encuesta_satisfaccion/www/ingresa_datos.php?user="&usu&"")
end if
'------------------------------------------------------------------------------------------------------
%>


