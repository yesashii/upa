<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_requisitos_disponibles = new CFormulario
f_requisitos_disponibles.Carga_Parametros "adm_requisitos_adicionales.xml", "tipos_requisitos"
f_requisitos_disponibles.Inicializar conexion
f_requisitos_disponibles.ProcesaForm


'conexion.EstadoTransaccion false
plan_ccod=request.Form("plan_ccod")
'response.Write("plan "&plan_ccod)
for i_ = 0 to f_requisitos_disponibles.CuentaPost - 1
    repl_ncorr=conexion.consultauno("execute obtenersecuencia 'requisitos_plan'")
	f_requisitos_disponibles.agregaCampoFilaPost i_,"repl_ncorr", repl_ncorr
	f_requisitos_disponibles.agregaCampoFilaPost i_,"plan_ccod", plan_ccod
	v_treq_ccod = f_requisitos_disponibles.ObtenerValorPost(i_, "treq_ccod")
	if EsVacio(v_treq_ccod) then
		f_requisitos_disponibles.EliminaFilaPost i_
	end if	
next

f_requisitos_disponibles.MantieneTablas true
'conexion.estadoTransaccion False
'response.End()

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>