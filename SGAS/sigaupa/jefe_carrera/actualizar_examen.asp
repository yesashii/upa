<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
for each k in request.Form()
	response.Write(k&" = "&request.Form(k)&"<br>")
next
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros "examen_adm.xml", "edicion_examen"
formulario.inicializar conectar
formulario.procesaForm

'formulario.listar

formulario.mantienetablas true
conectar.EstadoTransaccion false

'response.write(request.ServerVariables("HTTP_REFERER"))
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>