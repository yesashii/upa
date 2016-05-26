<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_item_gasto = new CFormulario
f_item_gasto.Carga_Parametros "adm_itemes_gasto.xml", "agregar_item_gasto"
f_item_gasto.Inicializar conexion
f_item_gasto.ProcesaForm


f_item_gasto.MantieneTablas false
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
