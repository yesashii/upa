<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set conexion = new CConexion
conexion.Inicializar "upacifico"


set f_requisitos = new CFormulario
f_requisitos.Carga_Parametros "adm_requisitos_titulacion.xml", "requisitos_persona"
f_requisitos.Inicializar conexion
f_requisitos.ProcesaForm


for i_ = 0 to f_requisitos.CuentaPost - 1
	v_repl_ncorr = f_requisitos.ObtenerValorPost(i_, "repl_ncorr")
	v_reti_ncorr = conexion.consultaUno("execute obtenerSecuencia 'requisitos_titulacion'") 
	if EsVacio(v_repl_ncorr) then
		f_requisitos.EliminaFilaPost i_
	end if
	f_requisitos.agregaCampoFilaPost i_,"reti_ncorr",v_reti_ncorr
next


f_requisitos.MantieneTablas false
'response.End()
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>

<script language="javascript">
CerrarActualizar();
</script>
