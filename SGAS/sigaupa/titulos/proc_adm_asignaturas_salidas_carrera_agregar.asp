<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_asignaturas_malla = new CFormulario
f_asignaturas_malla.Carga_Parametros "adm_asignaturas_salidas_carrera.xml", "asignaturas_malla"
f_asignaturas_malla.Inicializar conexion
f_asignaturas_malla.ProcesaForm

f_asignaturas_malla.MantieneTablas false
'response.End()

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
