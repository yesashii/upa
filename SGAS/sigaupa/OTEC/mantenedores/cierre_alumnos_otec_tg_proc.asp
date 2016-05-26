<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

dgso_ncorr = request.Form("dgso_ncorr")
usua = request.Form("usua")

set formulario = new cformulario
formulario.carga_parametros "cierre_alumnos_otec_tg.xml", "f_listado"
formulario.inicializar conectar
formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	pers_ncorr    =formulario.obtenerValorPost(i,"pers_ncorr")
	vb_finanzas   =formulario.obtenerValorPost(i,"vb_finanzas")
	vb_biblioteca =formulario.obtenerValorPost(i,"vb_biblioteca")
	vb_audiovisual=formulario.obtenerValorPost(i,"vb_audiovisual")
	bloqueado     =formulario.obtenerValorPost(i,"bloqueado")
	if pers_ncorr  <> "" and dgso_ncorr <> "" and bloqueado = "0" then
	 	consulta_actualizacion = " update postulacion_otec set vb_finanzas = '"&vb_finanzas&"', vb_biblioteca = '"&vb_biblioteca&"',vb_audiovisual = '"&vb_audiovisual&"',audi_tvb = '"&usua&"',audi_fvb = getDate() "&_
		                         " where cast(pers_ncorr as varchar) = '"&pers_ncorr&"' and cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"' and epot_ccod = 4 "
		conectar.ejecutaS consulta_actualizacion
		'response.Write("<br>"&consulta_actualizacion)
	end if
next	


'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
