<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'tambien inserto en sis_metodos_funciones

set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "modulo_postulantes.xml", "edita_datos_comentario"
formulario.Inicializar conexion
formulario.ProcesaForm

v_come_ncorr=conexion.consultauno("execute obtenersecuencia 'COMENTARIOS_OTEC'")
formulario.AgregaCampoPost "comp_ncorr" , v_come_ncorr

formulario.MantieneTablas false
'conexion.estadotransaccion false
'response.End()

%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
