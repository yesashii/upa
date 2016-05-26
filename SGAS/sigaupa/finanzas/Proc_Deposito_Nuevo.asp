<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
'----------------------------------------------------------------------
  set f1 = new CFormulario
  f1.Carga_Parametros "Depositos.xml", "f_nuevo"
  f1.Inicializar conexion
  'f1.Consultar "exec obtenersecuencia 'envios'"
  'f1.Siguiente
  envi_ncorr = conexion.ConsultaUno("exec obtenersecuencia 'envios'")
'----------------------------------------------------------------------  
  set formulario = new CFormulario
  formulario.Carga_Parametros "Depositos.xml", "f_nuevo"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  'formulario.listarpost
  formulario.agregacampopost "envi_ncorr" , envi_ncorr
  'formulario.agregacampopost "envi_fenvio" , Date()
  formulario.agregacampopost "envi_tipo" , 1
  formulario.MantieneTablas false
 
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
//CerrarActualizar();
opener.location.href = "depositos.asp?busqueda[0][envi_ncorr]=<%=envi_ncorr%>";
  close(); 
</script>
