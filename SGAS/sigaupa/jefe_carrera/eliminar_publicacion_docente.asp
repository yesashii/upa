 <!-- #include file="../biblioteca/_conexion.asp" -->
<%

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros "publicacion_docente.xml", "eliminar_publicacion"
formulario.inicializar conectar

formulario.procesaForm 

formulario.mantienetablas false
'conectar.estadotransaccion false
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

