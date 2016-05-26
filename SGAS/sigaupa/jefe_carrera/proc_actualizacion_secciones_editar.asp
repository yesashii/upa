<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_seccion = new CFormulario
f_seccion.Carga_Parametros "actualizacion_secciones.xml", "editar_seccion"
f_seccion.Inicializar conexion
f_seccion.ProcesaForm

f_seccion.MantieneTablas false
'response.End()
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>