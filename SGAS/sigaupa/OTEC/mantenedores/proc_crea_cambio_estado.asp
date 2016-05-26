<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'tambien inserto en sis_metodos_funciones

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "estado_secciones_otec.xml", "cambio_estado"
formulario.Inicializar conexion
formulario.ProcesaForm

v_sohe_ncorr=conexion.consultauno("execute obtenersecuencia 'secciones_otec_historial_estado'")
formulario.AgregaCampoPost "sohe_ncorr" , v_sohe_ncorr

formulario.MantieneTablas true
'conexion.estadotransaccion false
response.End()

%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
