<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
  set conexion = new CConexion
  conexion.Inicializar "desauas"
'----------------------------------------------------------------------
envi_ncorr = request.querystring("envi_ncorr")
'----------------------------------------------------------------------
  set formulario = new CFormulario
  formulario.Carga_Parametros "Envios_Banco.xml", "f_editar"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  formulario.AgregaCampoPost "envi_ncorr", envi_ncorr
  'formulario.listarPost
  formulario.MantieneTablas false
  'conexion.estadotransaccion false  'roolback   
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
 CerrarActualizar();
  //opener.location.href = "Envios_Banco.asp?busqueda[0][envi_ncorr]=<%=envi_ncorr%>";
  //close(); 
</script>
