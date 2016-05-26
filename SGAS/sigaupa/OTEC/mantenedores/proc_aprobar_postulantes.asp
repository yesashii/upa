<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
on error resume next
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()


	formulario.carga_parametros "postulacion_otec.xml", "aprobar_postulacion"
	formulario.inicializar conectar
	formulario.procesaForm
	

	formulario.mantienetablas false
	if conectar.obtenerEstadoTransaccion then 
		conectar.MensajeError "Postulaciones aprobadas correctamente"
	end if

'response.End()
'response.write(request.ServerVariables("HTTP_REFERER"))
 response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.End()
'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))

%>
