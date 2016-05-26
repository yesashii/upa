<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"
'response.Write("depurando.....<hr>")
'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()


formulario.carga_parametros "ficha_evento_alumno.xml", "eliminar_alumno"
formulario.inicializar conectar

formulario.procesaForm

formulario.mantienetablas FALSE
'conectar.estadoTransaccion false
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>

