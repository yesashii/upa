<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pers_ncorr_temporal =session("pers_ncorr_alumno")
periodo = negocio.ObtenerPeriodoAcademico("Postulacion")
v_post_ncorr=session("post_ncorr_alumno")'conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(peri_ccod as varchar)='"&periodo&"' and epos_ccod=2")


if not EsVacio(pers_ncorr_temporal) then
	tiene_postulacion = conexion.consultaUno("Select count(*) from postulacion_becas where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(peri_ccod as varchar)='"&periodo&"'")
	
	if tiene_postulacion <> "0" then 
		consulta_update= "update postulacion_becas set pobe_tipo_propietario="&request.Form("tipo_propietario")&" where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(peri_ccod as varchar)='"&periodo&"'"
	    conexion.ejecutaS(consulta_update)
	end if 
		
end if

Response.Redirect("ant_salud_familiar.asp")
%>


