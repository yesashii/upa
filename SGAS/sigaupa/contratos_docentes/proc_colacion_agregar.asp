<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'for each x in request.form
	'response.write("<br>"&x&"->"&request.form(x))
'next
'response.End()

mcol_ncorr = request.QueryString("colacion[0][mcol_ncorr]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set formulario = new CFormulario
formulario.Carga_Parametros "colacion_docentes.xml", "f1_edicion"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost
'response.end()

grabado = conexion.consultaUno("Select count(*) from monto_colacion where cast(mcol_ncorr as varchar)='"&mcol_ncorr&"'")

if esVacio(grabado) or grabado ="0" then
		peri_ccod = negocio.obtenerPeriodoAcademico("PLANIFICACION")
		anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
		
		formulario.agregaCampoPost "peri_ccod",peri_ccod
		formulario.agregaCampoPost "anos_ccod",anos_ccod
end if

formulario.MantieneTablas false
'conexion.estadoTransaccion false

'response.End()
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
