<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion
'-------------------------------------------------------------------------------------------------
pers_ncorr = Session("pers_ncorr")
secc_ccod = Session("secc_ccod")
pers_ncorr_profesor	 =  Session("pers_ncorr_profesor")
parte_2_1 = request.Form("parte_2_1")
parte_2_2 = request.Form("parte_2_2")
parte_2_3 = request.Form("parte_2_3")
parte_2_4 = request.Form("parte_2_4")
parte_2_5 = request.Form("parte_2_5")
parte_2_6 = request.Form("parte_2_6")
parte_2_7 = request.Form("parte_2_7")
parte_2_8 = request.Form("parte_2_8")
parte_2_9 = request.Form("parte_2_9")
parte_2_observaciones = request.Form("parte_2_observaciones")

'response.Write(pers_ncorr&"<br>")
'response.Write(len(pers_ncorr)&"<br>")
if len(parte_2_1) > 0 and len(parte_2_2) > 0 and len(parte_2_3) > 0 and len(parte_2_4) > 0 and len(parte_2_5) > 0 and len(parte_2_6) > 0 and len(parte_2_7) > 0 and len(parte_2_8) > 0 and len(parte_2_9) > 0 then
    c_grabar = " update cuestionario_opinion_alumnos set fecha_grabado = getDate(),parte_2_1="&parte_2_1&",parte_2_2="&parte_2_2&",parte_2_3="&parte_2_3&","&_
	           " parte_2_4="&parte_2_4&",parte_2_5="&parte_2_5&",parte_2_6="&parte_2_6&",parte_2_7="&parte_2_7&",parte_2_8="&parte_2_8&",parte_2_9="&parte_2_9&","&_
			   " parte_2_observaciones='"&parte_2_observaciones&"' where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"'"
	conexion.ejecutaS(c_grabar)
else
	conexion.MensajeError "Debe completar todas las preguntas consultadas"
	Response.Redirect("contestar_evaluacion_docente_2_2008.asp")
end if


if conexion.ObtenerEstadoTransaccion then
	Response.Redirect("contestar_evaluacion_docente_3_2008.asp")
else
	conexion.MensajeError "Debe completar todas las preguntas consultadas"
	Response.Redirect("contestar_evaluacion_docente_2_2008.asp")
end if
%>

