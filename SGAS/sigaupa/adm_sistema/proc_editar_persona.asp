<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Function ObtenerPersNCorr(p_pers_nrut)
	Dim v_pers_ncorr
	
	v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where pers_nrut = '" & p_pers_nrut & "'")
	
	if EsVacio(v_pers_ncorr) then
		v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas_postulante where pers_nrut = '" & p_pers_nrut & "'")
	end if
	
	if EsVacio(v_pers_ncorr) then
		v_pers_ncorr = conexion.ConsultaUno("exec ObtenerSecuencia 'personas'")
	end if
	
	ObtenerPersNCorr = v_pers_ncorr	
End Function


'------------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"


'conexion.EstadoTransaccion false

set f_datos_persona = new CFormulario
f_datos_persona.Carga_Parametros "adm_personas.xml", "datos_persona"
f_datos_persona.Inicializar conexion
f_datos_persona.ProcesaForm

'v_pers_ncorr = ObtenerPersNCorr(f_datos_codeudor.ObtenerValorPost(0, "pers_nrut"))
f_datos_persona.AgregaCampoPost "tdir_ccod", "1"
'f_datos_codeudor.AgregaCampoPost "pers_ncorr", v_pers_ncorr

f_datos_persona.MantieneTablas false
'response.End()




'------------------------------------------------------------------------------------------------------------------------
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>

