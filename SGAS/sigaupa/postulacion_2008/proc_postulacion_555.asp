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
'response.Write("pers"&v_pers_ncorr)	
v_pais_ccod = conexion.consultaUno("Select pais_ccod from personas_postulante where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")

f_codeudor.AgregaCampoPost "pers_ncorr", v_pers_ncorr
'response.Write("pais"&v_pais_ccod)
if v_pais_ccod<>"" then
if cint(v_pais_ccod)=1 then
	f_codeudor.AgregaCampoPost "tdir_ccod", "1"
else
	f_codeudor.AgregaCampoPost "tdir_ccod", "2"
end if
else
	f_codeudor.AgregaCampoPost "tdir_ccod", "1"
end if

f_codeudor.AgregaCampoPost "pers_tfono", f_codeudor.ObtenerValorPost(0, "dire_tfono")

f_codeudor.MantieneTablas false



f_direcciones.AgregaCampoPost "pers_ncorr", v_pers_ncorr
f_direcciones.AgregaCampoPost "tdir_ccod", "3"
f_direcciones.AgregaCampoPost "dire_tcalle", f_direcciones.ObtenerValorPost (0, "dire_tcalle_empresa")
f_direcciones.AgregaCampoPost "dire_tnro", f_direcciones.ObtenerValorPost (0, "dire_tnro_empresa")
f_direcciones.AgregaCampoPost "dire_tpoblacion", f_direcciones.ObtenerValorPost (0, "dire_tpoblacion_empresa")
f_direcciones.AgregaCampoPost "dire_tfono", f_direcciones.ObtenerValorPost (0, "dire_tfono_empresa")
f_direcciones.AgregaCampoPost "ciud_ccod", f_direcciones.ObtenerValorPost (0, "ciud_ccod_empresa")

f_direcciones.MantieneTablas false
'conexion.estadotransaccion false
'response.End()
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
