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

v_post_ncorr=session("post_ncorr_alumno") 'conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(peri_ccod as varchar)='"&periodo&"' and epos_ccod=2")


'-------------------------------------------------------------------------------------------------
set f_grupo_familiar = new CFormulario
f_grupo_familiar.Carga_Parametros "grupo_familiar.xml", "datos_generales"
f_grupo_familiar.Inicializar conexion
f_grupo_familiar.ProcesaForm

pobe_ncorr = request.Form("pobe_ncorr")

if not EsVacio(pobe_ncorr) then
				
		f_grupo_familiar.AgregaCampoPost "pobe_ncorr", pobe_ncorr
		f_grupo_familiar.MantieneTablas false
		'response.Write("<hr>INGRESO DE LA DIRECCIONES<HR>")
		
end if

'response.End()

'conexion.estadotransaccion false
Response.Redirect("ingresos_grupo_familiar.asp")
%>


