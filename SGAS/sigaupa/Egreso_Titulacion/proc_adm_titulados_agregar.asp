<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

q_plan_ccod = Request.QueryString("plan_ccod")
q_peri_ccod = Request.QueryString("peri_ccod")
q_pers_nrut = Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
'------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_titulado = new CFormulario
f_titulado.Carga_Parametros "adm_titulados.xml", "agregar_titulado"
f_titulado.Inicializar conexion
f_titulado.ProcesaForm

v_pers_ncorr = f_titulado.ObtenerValorPost(0, "pers_ncorr")
if esVacio(v_pers_ncorr) then
 rut = request.Form("dp[0][pers_nrut]")
 v_pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&rut&"'")
end if

'response.Write("pers_ncorr " & v_pers_ncorr)
if EsVacio(v_pers_ncorr) then
	v_pers_ncorr = conexion.consultaUno("execute obtenerSecuencia 'personas'")
end if

f_titulado.AgregaCampoPost "pers_ncorr", v_pers_ncorr
f_titulado.AgregaCampoPost "tdir_ccod", "1"
f_titulado.MantieneTablas false


'----------------------------------------------------------------------------------------------------
set f_colegio_egreso = new CFormulario
f_colegio_egreso.Carga_Parametros "adm_titulados.xml", "colegio_egreso"
f_colegio_egreso.Inicializar conexion
f_colegio_egreso.ProcesaForm

v_cole_ccod = f_colegio_egreso.ObtenerValorPost(0, "cole_ccod")
if not EsVacio(v_cole_ccod) then
	f_colegio_egreso.AgregaCampoFilaPost 0, "pers_tcole_egreso", ""
end if

f_colegio_egreso.AgregaCampoPost "pers_ncorr", v_pers_ncorr
f_colegio_egreso.MantieneTablas false


'------------------------------------------------------------------------------------------------------
url = "adm_titulados_agregar_2.asp?peri_ccod=" & q_peri_ccod & "&plan_ccod=" & q_plan_ccod & "&pers_nrut=" & q_pers_nrut & "&pers_xdv=" & q_pers_xdv
'response.Write(url)
'response.End()
Response.Redirect(url)
%>
