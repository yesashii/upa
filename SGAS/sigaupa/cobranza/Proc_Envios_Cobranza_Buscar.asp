<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
  set formulario = new CFormulario
  formulario.Carga_Parametros "envios_cobranza_buscar.xml", "listado_letras"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  
  'formulario.ListarPost
  
  formulario.MantieneTablas false
  'conexion.estadotransaccion false  'roolback   
  'response.End() 
response.Redirect(request.ServerVariables("HTTP_REFERER"))
  
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
//CerrarActualizar();
</script>
