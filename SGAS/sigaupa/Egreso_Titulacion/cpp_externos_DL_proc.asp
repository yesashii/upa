<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion

'conexion.estadoTransaccion false
dlpr_ncorr = request.Form("dp[0][dlpr_ncorr]")

if dlpr_ncorr = ""  then
	dlpr_ncorr = conexion.consultauno("execute obtenersecuencia 'direccion_laboral_profesionales'")
end if

set f_personas = new CFormulario
f_personas.Carga_Parametros "cpp_externos.xml", "datos_laborales"
f_personas.Inicializar conexion
f_personas.ProcesaForm

f_personas.AgregaCampoFilaPost 0, "dlpr_ncorr", dlpr_ncorr

f_personas.MantieneTablas false


'---------------------------------------------------------------------------------
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
