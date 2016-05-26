<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_grupo_familiar = new CFormulario
f_grupo_familiar.Carga_Parametros "ingresos_grupo_familiar.xml", "ingreso_familiar"
f_grupo_familiar.Inicializar conexion
f_grupo_familiar.ProcesaForm

if not EsVacio(f_grupo_familiar.ObtenerValorPost(0, "pers_ncorr")) then
  f_grupo_familiar.MantieneTablas false
end if



'conexion.estadotransaccion false
'response.End()
'---------------------------------------------------------------------------------------------------------------
'Response.Redirect("postulacion_4.asp")
%>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" >
CerrarActualizar();
</script>

