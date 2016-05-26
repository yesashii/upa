<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

set f_tipos_detalle = new CFormulario
f_tipos_detalle.Carga_Parametros "edicion_tipos_compromisos.xml", "agregar_tipos_detalle"
f_tipos_detalle.Inicializar conexion
f_tipos_detalle.ProcesaForm

f_tipos_detalle.MantieneTablas false

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
