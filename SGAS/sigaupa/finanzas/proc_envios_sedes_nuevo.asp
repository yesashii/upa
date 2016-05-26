<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
'----------------------------------------------------------------------
  set f1 = new CFormulario
  f1.Carga_Parametros "Envios_Notaria.xml", "f_nuevo"
  f1.Inicializar conexion

  esed_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'envios_sedes'")  
'----------------------------------------------------------------------  
  set formulario = new CFormulario
  formulario.Carga_Parametros "envios_sedes.xml", "f_nuevo"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  formulario.agregacampopost "esed_ncorr" , esed_ncorr
  formulario.MantieneTablas false
 
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
  opener.location.href = "envios_sedes.asp?busqueda[0][esed_ncorr]=<%=esed_ncorr%>";
  close(); 
</script>
