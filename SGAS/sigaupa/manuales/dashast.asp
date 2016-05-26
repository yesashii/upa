<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
Server.ScriptTimeOut = 999999999
Response.Buffer=false
x = 1
while true
set pagina = new CPagina
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
cc_empresa_envio="select * from personas"
tipo_empresa_envio=conexion.consultaUno(cc_empresa_envio)
response.write(x&" - ")
'response.write("|")
x = x + 1
wend 

%>