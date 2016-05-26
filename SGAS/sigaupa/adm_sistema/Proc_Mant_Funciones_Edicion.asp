<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'tambien inserto en sis_metodos_funciones

set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Funciones.xml", "f1_edicion"
formulario.Inicializar conexion
formulario.ProcesaForm
'para poder agregar el campo en la tabla sis_metodos_funciones
formulario.agregacampopost "smet_ccod" ,"1"
formulario.MantieneTablas false
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
