<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'-----------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


''set f_encuesta = new CFormulario
'f_encuesta.Carga_Parametros "asi_soy_yo.xml", "guardar_respuestas"
'f_encuesta.Inicializar conectar
'f_encuesta.ProcesaForm

set f_encuesta_1 = new CFormulario
f_encuesta_1.Carga_Parametros "completar_evaluacion_desarrollo.xml", "formu_encuestas"
f_encuesta_1.Inicializar conectar
f_encuesta_1.ProcesaForm
for i=0 to f_encuesta_1.cuentaPost - 1
	pers_ncorr=f_encuesta_1.obtenerValorPost(i,"pers_ncorr")
	pede_ccod=f_encuesta_1.obtenerValorPost(i,"pede_ccod")
	carr_ccod=f_encuesta_1.obtenerValorPost(i,"carr_ccod")
	if pers_ncorr <> "" and pede_ccod <> "" and carr_ccod <> "" then
		c_update = " update respuestas_encuesta_desarrollo set pede_ccod="&pede_ccod&" where cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
		conectar.ejecutaS c_update
	end if
next	
'f_encuesta_1.MantieneTablas false

Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()
if respuesta = true then
  session("mensajeerror")= "Resultados ingresados con Éxito"
else
  session("mensajeerror")= "Error al guadar los resultados"
end if
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>


