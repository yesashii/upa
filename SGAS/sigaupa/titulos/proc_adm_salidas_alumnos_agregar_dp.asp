<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_titulado = new CFormulario
f_titulado.Carga_Parametros "adm_salidas_alumnos.xml", "editar_dpersonales"
f_titulado.Inicializar conexion
f_titulado.ProcesaForm

v_pers_ncorr = f_titulado.ObtenerValorPost(0, "pers_ncorr")
if esVacio(v_pers_ncorr) then
 rut = request.Form("dp[0][pers_nrut]")
 v_pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&rut&"'")
end if

f_titulado.AgregaCampoPost "pers_ncorr", v_pers_ncorr
f_titulado.AgregaCampoPost "tdir_ccod", "1"
f_titulado.MantieneTablas false

'response.End()
'----------------------------------------------------------------------------------------------------
set f_colegio_egreso = new CFormulario
f_colegio_egreso.Carga_Parametros "adm_salidas_alumnos.xml", "colegio_egreso"
f_colegio_egreso.Inicializar conexion
f_colegio_egreso.ProcesaForm

f_colegio_egreso.AgregaCampoPost "pers_ncorr", v_pers_ncorr
f_colegio_egreso.MantieneTablas false

'----------------------------------------------------------------------------------------------------
set f_requerimientos = new CFormulario
f_requerimientos.Carga_Parametros "adm_salidas_alumnos.xml", "requerimientos_titulacion"
f_requerimientos.Inicializar conexion
f_requerimientos.ProcesaForm

f_requerimientos.AgregaCampoPost "pers_ncorr", v_pers_ncorr
f_requerimientos.MantieneTablas false


response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
