<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")

'next

formulario.carga_parametros "editar_asignatura.xml", "mantiene_asignatura"
formulario.inicializar conectar

formulario.procesaForm
formulario.mantienetablas false
'response.write(request.ServerVariables("HTTP_REFERER"))
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.End()
response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))
%>