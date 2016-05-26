<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

rut = request.Form("rut")

c_eliminar = "delete from causal_eliminacion where cast(rut as varchar)='"&rut&"'"

conexion.ejecutaS c_eliminar

Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
