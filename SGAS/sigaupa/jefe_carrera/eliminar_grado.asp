 <!-- #include file="../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros "grado_academico.xml", "eliminar_grados"
formulario.inicializar conectar

formulario.procesaForm 

formulario.mantienetablas false
'conectar.estadotransaccion false
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

