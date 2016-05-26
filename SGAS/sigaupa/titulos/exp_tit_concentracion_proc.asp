<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()
'-------------------------------------------------------------------------------------------------
saca_ncorr = request.Form("saca_ncorr")
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

tsca_ccod = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")

set f_concentracion = new CFormulario
f_concentracion.Carga_Parametros "expediente_titulacion.xml", "concentracion"
f_concentracion.Inicializar conexion
f_concentracion.ProcesaForm

promedio = conexion.consultaUno("select replace("&request.Form("concentracion[0][promedio_final]")&",',','.')")

f_concentracion.AgregaCampoFilaPost 0, "promedio_final", promedio
if tsca_ccod = "4" then
	f_concentracion.AgregaCampoFilaPost 0, "plan_ccod", saca_ncorr
end if

f_concentracion.MantieneTablas false

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
