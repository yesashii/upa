<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'response.write("aki")
'response.End()
v_post_ncorr=Session("post_ncorr")
set conexion = new CConexion
conexion.Inicializar "upacifico"
'----------agregado para las dobles matriculas
set formulario = new CFormulario
formulario.Carga_Parametros "postulacion_1.xml", "carrera_postulante2"
formulario.Inicializar conexion
formulario.ProcesaForm

'v_post_ncorr = formulario.ObtenerValorPost (0, "post_ncorr")
for fila = 0 to formulario.CuentaPost - 1
	post_ncorr_aux = formulario.ObtenerValorPost (fila, "post_ncorr")
	if not EsVacio(post_ncorr_aux) then
		v_post_ncorr = post_ncorr_aux
	end if
next

if	EsVacio(v_post_ncorr) then
	Session("mensajeError") = "Error, Falta parámetro correlativo de postulación."
	Response.Redirect(Request.ServerVariables("HTTP_REFERER"))	
end if
'response.Write("post_ncorr = " & v_post_ncorr)
'response.End()
Session("post_ncorr") = v_post_ncorr
'---------------------------------------------------------
set f_postulacion = new CFormulario
f_postulacion.Carga_Parametros "postulacion_1.xml", "postulacion_antiguo"
f_postulacion.Inicializar conexion

f_postulacion.CreaFilaPost
f_postulacion.AgregaCampoPost "post_ncorr", Session("post_ncorr")
f_postulacion.AgregaCampoPost "post_bnuevo", "S"
f_postulacion.AgregaCampoPost "ofer_ncorr", ""
f_postulacion.AgregaCampoPost "post_bpaga", "N"

sql_limpia_detalle="delete from detalle_postulantes where cast(post_ncorr as varchar)='"&v_post_ncorr&"'"
conexion.estadotransaccion conexion.ejecutas(sql_limpia_detalle)

f_postulacion.MantieneTablas false

'------------------------------------------
'Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
Response.Redirect("postulacion_1.asp")
%>
