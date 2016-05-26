<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new cformulario
formulario.carga_parametros "ingreso_calificaciones.xml", "alumnos"
formulario.inicializar conectar
formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	pote_ncorr=formulario.obtenerValorPost(i,"pote_ncorr")
	seot_ncorr=formulario.obtenerValorPost(i,"seot_ncorr")
	nota=formulario.obtenerValorPost(i,"caot_nnota_final")
	sitf_ccod=formulario.obtenerValorPost(i,"sitf_ccod")
	asistencia=formulario.obtenerValorPost(i,"caot_nasistencia")
	es_moroso = conectar.consultaUno("select protic.es_moroso(pers_ncorr,getDate()) from postulacion_otec where cast(pote_ncorr as varchar)='"&pote_ncorr&"'")
	if not EsVacio(pote_ncorr) and not EsVacio(seot_ncorr) and es_moroso = "N" then
		if nota = "" then
			 SQL="UPDATE cargas_academicas_otec set caot_nnota_final=null,sitf_ccod='"&sitf_ccod&"',caot_nasistencia="&asistencia&",caot_fecha_evaluado=getDate() WHERE cast(pote_ncorr as varchar)='"&pote_ncorr&"' and cast(seot_ncorr as varchar)='"&seot_ncorr&"'"
		else
			 SQL="UPDATE cargas_academicas_otec set caot_nnota_final="&nota&",sitf_ccod='"&sitf_ccod&"',caot_nasistencia="&asistencia&",caot_fecha_evaluado=getDate() WHERE cast(pote_ncorr as varchar)='"&pote_ncorr&"' and cast(seot_ncorr as varchar)='"&seot_ncorr&"'" 
		end if
		'response.Write("<br>"&SQL)
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
	end if
next
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
