<!-- #include file = "../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion

rut_alumno=negocio.ObtenerUsuario()
alumno_encuestado=conexion.Consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar) ='"&rut_alumno&"'")
contesto=conexion.Consultauno("select case count(*) when 0 then 'N' else 'S' end from mini_encuesta where cast(pers_ncorr_encuestado as varchar)='"&alumno_encuestado&"'")
if contesto="N" then
alumnos_elegido=request.Form("alumn")
inser="insert into mini_encuesta (pers_ncorr_elegido,pers_ncorr_encuestado,audi_fmodifiacion) values ("&alumnos_elegido&","&alumno_encuestado&",getdate())"
conexion.ejecutaS(inser)

	if conexion.ObtenerEstadoTransaccion = true then
		conexion.MensajeError "tu votacion ha sido registrada exitosamente"
	else
		conexion.MensajeError "Ocurrio un error al guardar"
	end if
else
conexion.MensajeError "Ya Respondiste la encuesta"
end if
response.Redirect("encu.asp")
%>
