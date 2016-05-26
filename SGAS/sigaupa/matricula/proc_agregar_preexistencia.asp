<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'------------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_esse_ccod = conexion.ConsultaUno("exec ObtenerSecuencia 'enfermedades_solicitud_seguro'")
'conexion.EstadoTransaccion false

set f_datos = new CFormulario
f_datos.Carga_Parametros "m_seguros_escolaridad.xml", "ingreso_preexistencias"
f_datos.Inicializar conexion
f_datos.ProcesaForm

'v_pers_ncorr = ObtenerPersNCorr(f_datos_codeudor.ObtenerValorPost(0, "pers_nrut"))
f_datos.AgregaCampoPost "esse_ccod", v_esse_ccod
'f_datos_codeudor.AgregaCampoPost "pers_ncorr", v_pers_ncorr

f_datos.MantieneTablas false

'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))
'------------------------------------------------------------------------------------------------------------------------
%>


