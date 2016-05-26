<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Function ObtenerPersNCorr(p_pers_nrut)
	Dim v_pers_ncorr
	'response.Write("<BR>rut: "&p_pers_nrut&"<br>")
	v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & p_pers_nrut & "'")
	'response.Write("<br>1: "&v_pers_ncorr)
	if EsVacio(v_pers_ncorr) then
		v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)= '" & p_pers_nrut & "'")
	'	response.Write("<br>2: "&v_pers_ncorr)
	end if
	
	if EsVacio(v_pers_ncorr) then
		v_pers_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'personas'")
	'	response.Write("<br>3: "&v_pers_ncorr)
	end if
	'response.Write("<br>pers_ncorr: "&v_pers_ncorr&"<br>")
	'conexion.estadoTransaccion false
	'response.End()

	ObtenerPersNCorr = v_pers_ncorr	
End Function


'------------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'conexion.EstadoTransaccion false

'response.Flush()
'------------------------------------------------------------------------------------------------------------------------
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "agregar_persona_pactacion.xml", "persona"
f_alumno.Inicializar conexion
f_alumno.AgregaParam "variable", "alumno"
f_alumno.ProcesaForm

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

rut_alumno=request.Form("alumno[1][pers_nrut]")
if rut_alumno ="" then
rut_alumno=f_alumno.ObtenerValorPost(0, "pers_nrut")
end if 
'response.Write("<BR>ruedddddddddddddddd"&rut_alumno&"<br>")
'response.End()
f_alumno.AgregaCampoPost "tdir_ccod", "1"


f_alumno.AgregaCampoPost "pers_ncorr", ObtenerPersNCorr(rut_alumno)
'*********************
'response.Write("<BR>Rut: "&rut_alumno&"<br>"&conexion.ObtenerEstadoTransaccion)

f_alumno.MantieneTablas false
'response.Write("<BR>Rut: "&rut_alumno&"<br>"&conexion.ObtenerEstadoTransaccion)
'response.End()

'------------------------------------------------------------------------------------------------------------------------
set f_codeudor = new CFormulario
f_codeudor.Carga_Parametros "agregar_persona_pactacion.xml", "persona"
f_codeudor.Inicializar conexion
f_codeudor.AgregaParam "variable", "codeudor"
f_codeudor.ProcesaForm

set f_rut = new CFormulario
f_rut.Carga_Parametros "agregar_persona_pactacion.xml", "rut"
f_rut.Inicializar conexion
f_rut.ProcesaForm

rut_codeudor=request.Form("codeudor[1][pers_nrut]")
xdv_codeudor=request.Form("codeudor[1][pers_xdv]")

if rur_codeudor="" then
	rut_codeudor=f_rut.ObtenerValorPost(0, "pers_nrut")
    xdv_codeudor=f_rut.ObtenerValorPost(0, "pers_xdv")
end if



f_codeudor.AgregaCampoPost "pers_nrut", rut_codeudor
f_codeudor.AgregaCampoPost "pers_xdv", xdv_codeudor
f_codeudor.AgregaCampoPost "tdir_ccod", "1"


v_pers_ncorr_codeudor = ObtenerPersNCorr(rut_codeudor)

f_codeudor.AgregaCampoPost "pers_ncorr", v_pers_ncorr_codeudor

f_codeudor.MantieneTablas false

'---------------------------------------------------------------------------------------------------

if conexion.ObtenerEstadoTransaccion then
	url = "agregar_cargo_pactacion.asp?pers_nrut=" & rut_alumno & "&pers_ncorr_codeudor=" & v_pers_ncorr_codeudor
else
	url = Request.ServerVariables("HTTP_REFERER")
end if


Response.Redirect(url)
%>
