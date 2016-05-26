<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Modulos.xml", "f1_edicion"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.MantieneTablas false
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
