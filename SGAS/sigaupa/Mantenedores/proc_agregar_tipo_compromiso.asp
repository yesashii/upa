<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_tipo = new CFormulario
f_tipo.Carga_Parametros "adm_tipos_compromisos.xml", "agregar_tipo"
f_tipo.Inicializar conexion
f_tipo.ProcesaForm
f_tipo.MantieneTablas false

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>