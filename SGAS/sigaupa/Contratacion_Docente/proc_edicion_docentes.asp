<!-- #include file="../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next


set conectar = new cconexion
set formulario = new cformulario
conectar.estadoTransaccion false
conectar.inicializar "upacifico"

formulario.carga_parametros "horas_docente.xml", "f_docentes"
formulario.inicializar conectar
formulario.procesaForm

formulario.mantienetablas false
conectar.MensajeError "Se han guardado correctamente las horas de los docentes "
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
