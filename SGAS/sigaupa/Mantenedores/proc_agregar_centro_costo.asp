<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_centro_costo = new CFormulario
f_centro_costo.Carga_Parametros "adm_centros_costo.xml", "agregar_centro_costo"
f_centro_costo.Inicializar conexion
f_centro_costo.ProcesaForm


f_centro_costo.MantieneTablas false
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
