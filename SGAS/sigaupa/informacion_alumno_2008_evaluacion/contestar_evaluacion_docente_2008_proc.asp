<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next


set conexion = new CConexion
conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion
'-------------------------------------------------------------------------------------------------
pers_ncorr = Session("pers_ncorr")
secc_ccod = Session("secc_ccod")
pers_ncorr_profesor	 =  Session("pers_ncorr_profesor")

'response.Write(pers_ncorr&"<br>")
'response.Write(len(pers_ncorr)&"<br>")
if len(pers_ncorr) > 0 and len(secc_ccod) > 0 and len(pers_ncorr_profesor) > 0 then
	grabado = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"'")
	'response.Write(grabado)
	if grabado = "0" then
		c_grabar = "insert into cuestionario_opinion_alumnos (pers_ncorr,secc_ccod,pers_ncorr_profesor,fecha_grabado)"&_
		           "values ("&pers_ncorr&","&secc_ccod&","&pers_ncorr_profesor&",getDate())"
	else
	    c_grabar = "update cuestionario_opinion_alumnos set fecha_grabado = getDate() where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"'"
	end if
	'response.Write("<br>"&c_grabar)
	conexion.ejecutaS(c_grabar)
else
	conexion.MensajeError "Debe seleccionar docente a evaluar"
	Response.Redirect("contestar_evaluacion_docente_2008.asp")
end if


if conexion.ObtenerEstadoTransaccion then
	Response.Redirect("contestar_evaluacion_docente_2_2008.asp")
else
	conexion.MensajeError "Se presentó un error al tratar de grabar, favor intentar nuevamente"
	Response.Redirect("contestar_evaluacion_docente_2008.asp")
end if
%>

