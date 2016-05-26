 <!-- #include file="../biblioteca/_conexion.asp" -->
<%
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"
conectar.estadotransaccion true
formulario.carga_parametros "agrega_asignaturas.xml", "eliminar_asignaturas_minor"
formulario.inicializar conectar

formulario.procesaForm 
'response.End()
formulario.mantienetablas false
'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

