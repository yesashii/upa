<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

pers_ncorr = request.Form("pers_ncorr")
carr_ccod = request.Form("carr_ccod")

matr_ncorr = conexion.consultaUno("select matr_ncorr from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr = b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.emat_ccod in (8) and c.carr_ccod='"&carr_ccod&"' and a.alum_nmatricula=7777 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and not exists (select 1 from cargas_academicas tt where tt.matr_ncorr = a.matr_ncorr)")
if not esVacio(matr_ncorr) then
	post_ncorr = conexion.consultaUno("select post_ncorr from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
	c_delete_alumnos = "Delete from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'"
	c_delete_detalle_postulantes = "Delete from detalle_postulantes where cast(post_ncorr as varchar)='"&post_ncorr&"'"
	c_delete_codeudor_postulacion = "Delete from codeudor_postulacion where cast(post_ncorr as varchar)='"&post_ncorr&"'"
	c_delete_grupo_familiar = "Delete from grupo_familiar where cast(post_ncorr as varchar)='"&post_ncorr&"'"
	c_delete_postulantes = " Delete from postulantes where cast(post_ncorr as varchar)='"&post_ncorr&"'"
	
	v_estado_transaccion = conexion.ejecutaS(c_delete_alumnos)
	v_estado_transaccion = conexion.ejecutaS(c_delete_detalle_postulantes)
	v_estado_transaccion = conexion.ejecutaS(c_delete_codeudor_postulacion)
	v_estado_transaccion = conexion.ejecutaS(c_delete_grupo_familiar)
	v_estado_transaccion = conexion.ejecutaS(c_delete_postulantes)
end if

if v_estado_transaccion  then
	session("mensaje_error")="Ocurrió un error al tratar de eliminar la matrícula"
else	
	session("mensaje_error")="La matrícula de ajuste fue eliminada correctamente."
end if
	
'----------------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
