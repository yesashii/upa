<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

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
id_ceremonia = request.Form("tesis[0][id_ceremonia]")
fecha_ceremonia = conexion.consultaUno("select protic.trunc(fecha_ceremonia) from ceremonias_titulacion where cast(id_ceremonia as varchar)='"&id_ceremonia&"'")
calificacion_tesis = request.Form("tesis[0][calificacion_tesis]")
fecha_titulacion = request.Form("tesis[0][fecha_titulacion]")
saca_ncorr = request.Form("saca_ncorr")

tsca_ccod = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
if tsca_ccod <> "4" then 
	plan_consulta = plan_ccod
else
	plan_consulta = saca_ncorr
end if

if len(tema_tesis) > 0 then
	consulta = "update DETALLES_TITULACION_CARRERA set tema_tesis='"&tema_tesis&"' WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
else
	consulta = "update DETALLES_TITULACION_CARRERA set tema_tesis='' WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
end if 
'response.Write(consulta)
if len(inicio_tesis) > 0 then
	consulta2 = "update DETALLES_TITULACION_CARRERA set inicio_tesis=convert(datetime,'"&inicio_tesis&"',103) WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
else
	consulta2 = "update DETALLES_TITULACION_CARRERA set inicio_tesis=NULL WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
end if 
'response.Write(consulta2)
if len(termino_tesis) > 0 then
	consulta3 = "update DETALLES_TITULACION_CARRERA set termino_tesis=convert(datetime,'"&termino_tesis&"',103) WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
else
	consulta3 = "update DETALLES_TITULACION_CARRERA set termino_tesis=NULL WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
end if 
'response.Write(consulta3)
if len(fecha_ceremonia) > 0 then
	consulta4 = "update DETALLES_TITULACION_CARRERA set fecha_ceremonia=convert(datetime,'"&fecha_ceremonia&"',103), id_ceremonia="&id_ceremonia&" WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
else
	consulta4 = "update DETALLES_TITULACION_CARRERA set fecha_ceremonia=NULL, id_ceremonia=NULL WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
end if 
'response.Write(consulta4)
if len(calificacion_tesis) > 0 then
	consulta5 = "update DETALLES_TITULACION_CARRERA set calificacion_tesis="&calificacion_tesis&" WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
else
	consulta5 = "update DETALLES_TITULACION_CARRERA set calificacion_tesis=NULL WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
end if 
'response.Write(consulta5)
if len(fecha_titulacion) > 0 then
	consulta6 = "update DETALLES_TITULACION_CARRERA set fecha_titulacion=convert(datetime,'"&fecha_titulacion&"',103) WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
else
	consulta6 = "update DETALLES_TITULACION_CARRERA set fecha_titulacion=NULL WHERE cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
end if 
'response.Write(conexion.obtenerEstadoTransaccion)
response.Write(consulta6)
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
conexion.ejecutaS consulta4
'response.Write(conexion.obtenerEstadoTransaccion)
if conexion.obtenerEstadoTransaccion = false then 
	mensaje_error = mensaje_error & " - Existe un error en la calificación de la tesis que impidió hacer la grabación"
end if 
conexion.ejecutaS consulta5
'response.Write(conexion.obtenerEstadoTransaccion)
if conexion.obtenerEstadoTransaccion = false then 
    mensaje_error = mensaje_error & " - Existe un error en la fecha de titulación que impidió hacer la grabación"
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
