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

v_dgso_ncorr = request.Form("m[0][dgso_ncorr]")
'response.Write(v_dcur_ncorr)
'response.End()
	formulario.carga_parametros "secciones_otec.xml", "mantiene_datos_generales"
	formulario.inicializar conectar
	formulario.procesaForm
	
	if v_dgso_ncorr = "" then
	    'response.Write("ENTRE IGUAL A La FUNA")
		dgso_ncorr = conectar.consultaUno("exec obtenerSecuencia 'datos_generales_secciones_otec'")
		formulario.agregaCampoPost "dgso_ncorr",dgso_ncorr
	end if

	formulario.mantienetablas false
	if conectar.obtenerEstadoTransaccion then 
		conectar.MensajeError "Datos generales guardados correctamente"
	end if

'response.End()
'response.write(request.ServerVariables("HTTP_REFERER"))
 response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.End()
'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))

%>
