<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

dgso_ncorr = request.Form("dgso_ncorr")
usua = request.Form("usua")

set formulario = new cformulario
formulario.carga_parametros "cierre_alumnos_otec_de.xml", "f_listado_asociado"
formulario.inicializar conectar
formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	pers_ncorr		=formulario.obtenerValorPost(i,"pers_ncorr")
	pote_nnota_final=formulario.obtenerValorPost(i,"pote_nnota_final")
	pote_nasistencia=formulario.obtenerValorPost(i,"pote_nasistencia")
	pote_nest_final	=formulario.obtenerValorPost(i,"pote_nest_final")
	bloqueado     =formulario.obtenerValorPost(i,"bloqueado")
	if pers_ncorr <> "" and dgso_ncorr <> "" and pote_nnota_final <> "" and pote_nasistencia <> "" and pote_nest_final <> "" and bloqueado = "0" then
	 	consulta_actualizacion = " update postulacion_asociada_otec set pote_nnota_final = "&pote_nnota_final&", pote_nasistencia = "&pote_nasistencia&","&_
		                         " pote_nest_final = "&pote_nest_final&",audi_tfinal = '"&usua&"',audi_ffinal = getDate() "&_
		                         " where cast(pers_ncorr as varchar) = '"&pers_ncorr&"' and cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"' and epot_ccod = 4 "
		conectar.ejecutaS consulta_actualizacion
		'response.Write("<br>"&consulta_actualizacion)
	end if
next	


'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
