 <!-- #include file="../biblioteca/_conexion.asp" -->
<%

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros "otras_actividades.xml", "eliminar_otras_actividades"
formulario.inicializar conectar

formulario.procesaForm 

formulario.mantienetablas false
'response.End()
'conectar.estadotransaccion false
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

