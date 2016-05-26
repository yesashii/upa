<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_post_ncorr = Session("post_ncorr")

if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if

'-------------------------------------------------------------------------------------------------
Function ObtenerPersNCorr(p_pers_nrut, conexion)
	dim consulta, v_pers_ncorr
	consulta = "select pers_ncorr from personas_postulante where pers_nrut = '" & p_pers_nrut & "'"	
	v_pers_ncorr = conexion.ConsultaUno(consulta)	
	
	if EsVacio(v_pers_ncorr) then
		consulta = "select pers_ncorr from personas where pers_nrut = '" & p_pers_nrut & "'"	
		v_pers_ncorr = conexion.ConsultaUno(consulta)
	end if
	
	if EsVacio(v_pers_ncorr) then
		consulta = "Exec ObtenerSecuencia 'personas'"
		v_pers_ncorr = conexion.ConsultaUno(consulta)
	end if
	
	ObtenerPersNCorr = v_pers_ncorr	
End Function


set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

'-------------------------------------------------------------------------------------------------
set f_codeudor = new CFormulario
f_codeudor.Carga_Parametros "postulacion_5.xml", "codeudor"
f_codeudor.Inicializar conexion
f_codeudor.ProcesaForm


set f_direcciones = new CFormulario
f_direcciones.Carga_Parametros "postulacion_5.xml", "direcciones"
f_direcciones.Inicializar conexion
f_direcciones.ProcesaForm


'-------------------------------------------------------------------------------------------------	
v_pers_ncorr = ObtenerPersNCorr(f_codeudor.ObtenerValorPost(0, "pers_nrut"), conexion)	

f_codeudor.AgregaCampoPost "pers_ncorr", v_pers_ncorr
f_codeudor.AgregaCampoPost "tdir_ccod", "1"
f_codeudor.AgregaCampoPost "pers_tfono", f_codeudor.ObtenerValorPost(0, "dire_tfono")

f_codeudor.MantieneTablas False



f_direcciones.AgregaCampoPost "pers_ncorr", v_pers_ncorr
f_direcciones.AgregaCampoPost "tdir_ccod", "3"
f_direcciones.AgregaCampoPost "dire_tcalle", f_direcciones.ObtenerValorPost (0, "dire_tcalle_empresa")
f_direcciones.AgregaCampoPost "dire_tnro", f_direcciones.ObtenerValorPost (0, "dire_tnro_empresa")
f_direcciones.AgregaCampoPost "dire_tpoblacion", f_direcciones.ObtenerValorPost (0, "dire_tpoblacion_empresa")
f_direcciones.AgregaCampoPost "dire_tfono", f_direcciones.ObtenerValorPost (0, "dire_tfono_empresa")
f_direcciones.AgregaCampoPost "ciud_ccod", f_direcciones.ObtenerValorPost (0, "ciud_ccod_empresa")

f_direcciones.MantieneTablas False


'---------------------------------------------------------------------------------------------------------------
v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where post_ncorr = '" & v_post_ncorr & "'")

if v_epos_ccod = "2" then
	url = "post_cerrada.asp"
else
	url = "postulacion_6.asp"
end if
'---------------------------------------------------------------------------------------------------------------
Response.Redirect(url)
%>
