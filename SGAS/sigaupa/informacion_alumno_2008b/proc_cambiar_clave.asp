<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion

v_msg_auditoria= " - cambio clave alumno"
'---------------------------------------------------------------------
v_fecha=conexion.ConsultaUno("select protic.trunc(getdate())")

set formulario = new CFormulario
formulario.Carga_Parametros "cambiar_clave.xml", "f_datos_alumno"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.AgregaCampoPost "susu_fmodificacion", v_fecha
'formulario.ListarPost
nueva = formulario.obtenerValorPost (0, "nueva")
formulario.agregaCampoPost "susu_tclave" , nueva
formulario.agregaCampoPost "usua_tclave" , nueva
formulario.MantieneTablas false


'conexion.estadotransaccion false  'roolback  
'response.End()

if conexion.ObtenerEstadoTransaccion = true then
	conexion.MensajeError "Su Clave fue cambiada con éxito..."
else
	conexion.MensajeError "Ocurrio un error al intentar cambiar su clave, Vuelva a intentarlo..."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
