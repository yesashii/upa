<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
'----------------------------------------------------------------------
  set f1 = new CFormulario
  f1.Carga_Parametros "Envios_Notaria.xml", "f_nuevo"
  f1.Inicializar conexion
  'f1.Consultar "select envi_ncorr_seq.nextval as envi_ncorr from dual"
  'f1.Siguiente
  'envi_ncorr = f1.obtenervalor("envi_ncorr")
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
  opener.location.href = "Envios_Notaria.asp?busqueda[0][envi_ncorr]=<%=envi_ncorr%>";
  close(); 
</script>
