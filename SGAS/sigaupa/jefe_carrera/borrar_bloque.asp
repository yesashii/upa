 <!-- #include file="../biblioteca/_conexion.asp" -->
<%

	set conectar = new cconexion
	set formulario = new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros "paulo.xml", "eliminar_bloque"
formulario.inicializar conectar

formulario.procesaForm 
formulario.mantienetablas false
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>