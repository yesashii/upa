<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
	set conexion = new CConexion
	conexion.inicializar "upacifico"
			
	set negocio = new cnegocio
	negocio.inicializa conexion
	es_administrativo = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"' and srol_ncorr in (66,69,32,45,71,82,27,44,25,2,1)")

	if es_administrativo = "S" then
		retorno = negocio.obtenerPeriodoAcademico("TOMACARGA")
	else
		retorno = negocio.obtenerPeriodoAcademico("PLANIFICACION")
	end if	

	if cint(retorno) > 236 then

		Response.Redirect "http://fangorn.upacifico.cl/sigaupa/encuestas/evaluacion_2015.asp"
	else
		Response.Redirect "http://fangorn.upacifico.cl/sigaupa/ENCUESTAS/RESULTADOS_ENCUESTAS_DOCENTE_2008.ASP"
	end if
%>