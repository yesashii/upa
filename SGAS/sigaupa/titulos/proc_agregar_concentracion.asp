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

'conexion.estadoTransaccion false
tsca_ccod = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")

set f_concentracion = new CFormulario
f_concentracion.Carga_Parametros "adm_salidas_alumnos.xml", "concentracion"
f_concentracion.Inicializar conexion
f_concentracion.ProcesaForm

'promedio = conexion.consultaUno("select replace(cast("&request.Form("concentracion[0][promedio_final]")&" as decimal(3,2)),',','.')")
promedio = conexion.consultaUno("select replace("&request.Form("concentracion[0][promedio_final]")&",',','.')")

f_concentracion.AgregaCampoFilaPost 0, "promedio_final", promedio'f_practica.ObtenerValorPost(0, "sitf_ccod")
if tsca_ccod = "4" then
	f_concentracion.AgregaCampoFilaPost 0, "plan_ccod", saca_ncorr
end if

f_concentracion.MantieneTablas false

'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
