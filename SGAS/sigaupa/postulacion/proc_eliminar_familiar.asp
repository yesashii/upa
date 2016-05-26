 <!-- #include file="../biblioteca/_conexion.asp" -->
<%
for each x in request.Form
'	response.Write("<br>"&x&"->"&request.Form(x))
next
'response.End()
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros "postulacion_4.xml", "eliminar_familiares"
formulario.inicializar conectar

formulario.procesaForm 




formulario.mantienetablas false
'conectar.estadotransaccion false
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

