<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

'response.End()

'-------------------------------------------------------------------------------------------------'
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

tema_tesis = request.Form("tesis[0][tema_tesis]")
inicio_tesis = request.Form("tesis[0][inicio_tesis]") 
pers_ncorr = request.Form("tesis[0][pers_ncorr]")
termino_tesis = request.Form("tesis[0][termino_tesis]") 
plan_ccod = request.Form("tesis[0][plan_ccod]")
saca_ncorr = request.Form("saca_ncorr")


if len(tema_tesis) > 0 then
	consulta = "update DETALLES_TITULACION_CARRERA set tema_tesis='"&tema_tesis&"' WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"'"
else
	consulta = "update DETALLES_TITULACION_CARRERA set tema_tesis='' WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"'"
end if 
'response.Write(consulta)
if len(inicio_tesis) > 0 then
	consulta2 = "update DETALLES_TITULACION_CARRERA set inicio_tesis=convert(datetime,'"&inicio_tesis&"',103) WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"'"
else
	consulta2 = "update DETALLES_TITULACION_CARRERA set inicio_tesis=NULL WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"'"
end if 
'response.Write(consulta2)
if len(termino_tesis) > 0 then
	consulta3 = "update DETALLES_TITULACION_CARRERA set termino_tesis=convert(datetime,'"&termino_tesis&"',103) WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"'"
else
	consulta3 = "update DETALLES_TITULACION_CARRERA set termino_tesis=NULL WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"'"
end if 

mensaje_error= ""
conexion.ejecutaS consulta
'response.Write(conexion.obtenerEstadoTransaccion)
if conexion.obtenerEstadoTransaccion = false then 
	mensaje_error = mensaje_error & " - Existe un error en el tema de la tesis que impidió hacer la grabación"
end if 
conexion.ejecutaS consulta2
'response.Write(conexion.obtenerEstadoTransaccion)
if conexion.obtenerEstadoTransaccion = false then 
	mensaje_error = mensaje_error & " - Existe un error en la fecha de inicio de la tesis que impidió hacer la grabación"
end if 
conexion.ejecutaS consulta3
'response.Write(conexion.obtenerEstadoTransaccion)
if conexion.obtenerEstadoTransaccion = false then 
	mensaje_error = mensaje_error & " - Existe un error en la fecha de término de la tesis que impidió hacer la grabación"
end if 

if mensaje_error <> "" then
	session("msjError") = "Se presentaron los siguientes problemas:\n"&mensaje_error
else
	session("msjOk")="Los datos han sido grabados exitosamente"
end if
'response.Write(mensaje_error)
'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
