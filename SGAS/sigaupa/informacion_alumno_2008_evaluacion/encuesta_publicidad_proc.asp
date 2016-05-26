<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'-----------------------------------------------------
set conectar = new cconexion
conectar.inicializar "upacifico"

pers_ncorr = request.Form("p[0][pers_ncorr_encuestado]")
peri_ccod = request.Form("p[0][peri_ccod]")

existe = conectar.consultaUno("select count(*) from epub_evaluacion_ramos_publicidad where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&peri_ccod&"'")


set formulario = new cformulario
formulario.carga_parametros "contestar_evaluacion_publicidad.xml", "guardar_evaluacion_publicidad"
formulario.inicializar conectar
formulario.procesaForm
if existe = "0" then
	erpu_ncorr = conectar.ConsultaUno("execute obtenerSecuencia 'epub_evaluacion_ramos_publicidad' ") 
else
	erpu_ncorr = conectar.consultaUno("select erpu_ncorr from epub_evaluacion_ramos_publicidad where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&peri_ccod&"'")
end if
formulario.AgregaCampoPost "erpu_ncorr", erpu_ncorr
formulario.AgregaCampoPost "fecha_grabado", Date
formulario.MantieneTablas false


response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>


