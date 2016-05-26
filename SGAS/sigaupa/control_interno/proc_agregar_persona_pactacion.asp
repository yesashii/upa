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
	response.Write("<br>pers_ncorr: "&v_pers_ncorr&"<br>")
	ObtenerPersNCorr = v_pers_ncorr	
End Function


Function ObtenerPostNCorr(p_pers_ncorr)
	Dim v_post_ncorr
	
	v_post_ncorr = conexion.ConsultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar) = '" & p_pers_ncorr & "' and cast(peri_ccod as varchar)= '" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "'")
	
	if EsVacio(v_post_ncorr) then
		v_post_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'postulantes'")
	end if
	response.Write("<br> post_ncorr"&v_post_ncorr)
	ObtenerPostNCorr = v_post_ncorr
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

rut_alumno=request.Form("alumno[1][pers_nrut]")
if rut_alumno ="" then
rut_alumno=f_alumno.ObtenerValorPost(0, "pers_nrut")
end if 
'response.Write("<BR>ruedddddddddddddddd"&rut_alumno&"<br>")
f_alumno.AgregaCampoPost "tdir_ccod", "1"

'f_alumno.AgregaCampoPost "pers_ncorr", ObtenerPersNCorr(f_alumno.ObtenerValorPost(0, "pers_nrut"))
'cambio por error en f_alumno.ObtenerValorPost cambiada el 14-10-2004
f_alumno.AgregaCampoPost "pers_ncorr", ObtenerPersNCorr(rut_alumno)
'*********************

f_alumno.MantieneTablas false
'f_alumno.MantieneTablas true
'response.End()
'conexion.EjecutaP("traspasa_persona_pp('" & f_alumno.ObtenerValorPost(0, "pers_nrut") & "', '" & negocio.ObtenerUsuario & "')")


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

'response.Write("<BR>"&rut_codeudor&"<br>")

'cambio por error en f_alumno.ObtenerValorPost cambiada el 14-10-2004
'f_codeudor.AgregaCampoPost "pers_nrut", f_rut.ObtenerValorPost(0, "pers_nrut")
'f_codeudor.AgregaCampoPost "pers_xdv", f_rut.ObtenerValorPost(0, "pers_xdv")
f_codeudor.AgregaCampoPost "pers_nrut", rut_codeudor
f_codeudor.AgregaCampoPost "pers_xdv", xdv_codeudor


f_codeudor.AgregaCampoPost "tdir_ccod", "1"


'cambio por error en f_codeudor.ObtenerValorPost cambiada el 14-10-2004
'v_pers_ncorr_codeudor = ObtenerPersNCorr(f_codeudor.ObtenerValorPost(0, "pers_nrut"))
v_pers_ncorr_codeudor = ObtenerPersNCorr(rut_codeudor)

f_codeudor.AgregaCampoPost "pers_ncorr", v_pers_ncorr_codeudor

'f_codeudor.MantieneTablas true
f_codeudor.MantieneTablas false
'response.End()
'conexion.EjecutaP("traspasa_persona_pp('" & f_codeudor.ObtenerValorPost(0, "pers_nrut") & "', '" & negocio.ObtenerUsuario & "')")

'conexion.estadotransaccion false
'------------------------------------------------------------------------------------------------------------------------


'v_post_ncorr = ObtenerPostNCorr(f_alumno.ObtenerValorPost(0, "pers_ncorr"))
'v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")


'set f_postulacion = new CFormulario
'f_postulacion.Carga_Parametros "agregar_persona_pactacion.xml", "postulacion"
'f_postulacion.Inicializar conexion
'f_postulacion.CreaFilaPost
'f_postulacion.AgregaCampoPost "post_ncorr", v_post_ncorr
'f_postulacion.AgregaCampoPost "peri_ccod", v_peri_ccod
'f_postulacion.AgregaCampoPost "pers_ncorr", f_alumno.ObtenerValorPost(0, "pers_ncorr")
'f_postulacion.MantieneTablas true


'set f_codeudor_postulacion = new CFormulario
'f_codeudor_postulacion.Carga_Parametros "agregar_persona_pactacion.xml", "codeudor_postulacion"
'f_codeudor_postulacion.Inicializar conexion

'f_codeudor_postulacion.CreaFilaPost
'f_codeudor_postulacion.AgregaCampoPost "post_ncorr", v_post_ncorr
'f_codeudor_postulacion.AgregaCampoPost "pers_ncorr", f_codeudor.ObtenerValorPost(0, "pers_ncorr")

'f_codeudor_postulacion.MantieneTablas true

'f_codeudor_postulacion.ListarPost


'---------------------------------------------------------------------------------------------------

if conexion.ObtenerEstadoTransaccion then
	'url = "agregar_cargo_pactacion.asp?pers_nrut=" & f_alumno.ObtenerValorPost(0, "pers_nrut") & "&pers_ncorr_codeudor=" & v_pers_ncorr_codeudor
	 url = "agregar_cargo_pactacion.asp?pers_nrut=" & rut_alumno & "&pers_ncorr_codeudor=" & v_pers_ncorr_codeudor
else
	url = Request.ServerVariables("HTTP_REFERER")
end if


Response.Redirect(url)
%>
