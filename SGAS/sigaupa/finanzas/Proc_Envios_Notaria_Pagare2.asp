<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
'----------------------------------------------------------------------
  set f1 = new CFormulario
  f1.Carga_Parametros "envios_notaria_pagare.xml", "f_nuevo"
  f1.Inicializar conexion
  'f1.Consultar "select envi_ncorr_seq.nextval as enpa_ncorr from dual"
  'f1.Siguiente
  'enpa_ncorr = f1.obtenervalor("enpa_ncorr")
  enpa_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'envios_pagares'")
  '----------------------------------------------------------------------  
  set formulario = new CFormulario
  formulario.Carga_Parametros "envios_notaria_pagare.xml", "f_nuevo"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  formulario.agregacampopost "enpa_ncorr" , enpa_ncorr
  formulario.MantieneTablas false
  'f1.ListarPost
  'f1.MantieneTablas false
  'conexion.estadotransaccion false  'roolback  
'----------------------------------------------------------------------  
  
 
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
