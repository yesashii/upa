<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_tipo = new CFormulario
f_tipo.Carga_Parametros "edicion_tipos_compromisos.xml", "agregar_tipos_beneficios"
f_tipo.Inicializar conexion
f_tipo.ProcesaForm

f_tipo.AgregaCampoPost "tdet_bdescuento" ,"S"

f_tipo.MantieneTablas false

'conexion.EstadoTransaccion false
'response.End()

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>