<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each x in request.Form
'	response.Write(x&"->"&request.Form(x)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set variables = new CVariables
variables.ProcesaForm

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

v_mcaj_ncorr = cajero.ObtenerCajaAbierta
v_comp_ndocto = variables.ObtenerValor("detalles_pactacion", 0, "comp_ndocto")
'response.Write("comp_ndocto "&v_comp_ndocto)
'response.End()

'-----------------------------------------------------------------------------------------------------------
set f_detalles_pactacion = new CFormulario
f_detalles_pactacion.Carga_Parametros "agregar_cargo_pactacion.xml", "detalles_pactacion"
f_detalles_pactacion.Inicializar conexion
f_detalles_pactacion.ProcesaForm
f_detalles_pactacion.MantieneTablas false

'response.End()


'conexion.estadotransaccion false

'-----------------------------------------------------------------------------------------------------------
sentencia = "execute genera_pactacion '" & v_comp_ndocto & "','" & negocio.ObtenerSede & "','" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "','" & v_mcaj_ncorr & "'"
'response.Write(sentencia)
conexion.EstadoTransaccion conexion.EjecutaS(sentencia)
'response.End()
'response.End()
'---------------------------------------------------------------------------------------------------------------------
if conexion.ObtenerEstadoTransaccion then
	str_url = "imprimir_pactacion.asp?comp_ndocto=" & v_comp_ndocto
else
	str_url = Request.ServerVariables("HTTP_REFERER")
end if
'Response.Write(str_url)
Response.Redirect(str_url)
%>


