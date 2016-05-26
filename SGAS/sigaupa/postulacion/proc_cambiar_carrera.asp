<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'response.write("aki")
'response.End()
v_post_ncorr=Session("post_ncorr")
set conexion = new CConexion
conexion.Inicializar "upacifico"

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
