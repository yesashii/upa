<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
  set formulario = new CFormulario
  formulario.Carga_Parametros "Depositos.xml", "f_cheques"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  'formulario.listarpost
  for fila = 0 to formulario.CuentaPost - 1
    envio   = formulario.ObtenerValorPost (fila, "envi_ncorr")
	if envio <> "" then
	else
     formulario.EliminaFilaPost fila    
    end if 
  next
  formulario.MantieneTablas false
  'conexion.estadotransaccion false  'roolback   
   response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

