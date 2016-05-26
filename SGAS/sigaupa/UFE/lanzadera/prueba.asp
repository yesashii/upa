<!-- #include file="../biblioteca/_conexion.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
response.Write("Hola")
response.Write(conexion.consultauno("select pers_ncorr from personas"))
%>
