<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'for each x in request.form
	'response.write("<br>"&x&"->"&request.form(x))
'next
'response.End()

tcat_ccod = request.QueryString("categorias[0][TCAT_CCOD]")

set conexion = new CConexion
conexion.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

set formulario = new CFormulario
formulario.Carga_Parametros "categoria_docentes.xml", "f1_edicion"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost
'response.end()

grabado = conexion.consultaUno("Select count(*) from tipos_categoria where cast(tcat_ccod as varchar)='"&tcat_ccod&"'")

if esVacio(grabado) or grabado ="0" then
		peri_ccod = negocio.obtenerPeriodoAcademico("PLANIFICACION")
		anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
		
		formulario.agregaCampoPost "peri_ccod",peri_ccod
		formulario.agregaCampoPost "anos_ccod",anos_ccod
end if

formulario.MantieneTablas true
'conexion.estadoTransaccion false

'response.End()
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
