<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

  set conexion = new CConexion
  conexion.Inicializar "upacifico"
'----------------------------------------------------------------------
  envi_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'envios'")  
'----------------------------------------------------------------------  
  set formulario = new CFormulario
  formulario.Carga_Parametros "Envios_Banco.xml", "f_nuevo"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  formulario.agregacampopost "envi_ncorr" , envi_ncorr
  formulario.MantieneTablas false
 
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
  opener.location.href = "depositos_multidebito.asp?busqueda[0][envi_ncorr]=<%=envi_ncorr%>";
  close(); 
</script>
