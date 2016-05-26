<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Function ObtenerPersNCorr(p_pers_nrut)
	Dim v_pers_ncorr
	
	v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)= '" & p_pers_nrut & "'")
	
	if EsVacio(v_pers_ncorr) then
		v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)= '" & p_pers_nrut & "'")
	end if
	
	if EsVacio(v_pers_ncorr) then
		v_pers_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'personas'")
	end if
	
	ObtenerPersNCorr = v_pers_ncorr	
End Function


'------------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"


'conexion.EstadoTransaccion false

set f_datos_codeudor = new CFormulario
f_datos_codeudor.Carga_Parametros "cambiar_codeudor_repactacion.xml", "datos_codeudor"
f_datos_codeudor.Inicializar conexion
f_datos_codeudor.ProcesaForm

v_pers_ncorr = ObtenerPersNCorr(f_datos_codeudor.ObtenerValorPost(0, "pers_nrut"))
f_datos_codeudor.AgregaCampoPost "tdir_ccod", "1"
f_datos_codeudor.AgregaCampoPost "pers_ncorr", v_pers_ncorr

f_datos_codeudor.MantieneTablas false


'------------------------------------------------------------------------------------------------------------------------
set f_detalles_repactacion = new CFormulario
f_detalles_repactacion.Carga_Parametros "cambiar_codeudor_repactacion.xml", "detalles_repactacion"
f_detalles_repactacion.Inicializar conexion
f_detalles_repactacion.ProcesaForm

f_detalles_repactacion.AgregaCampoPost "pers_ncorr_codeudor", v_pers_ncorr

f_detalles_repactacion.MantieneTablas false

'------------------------------------------------------------------------------------------------------------------------
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>

