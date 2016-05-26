<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'response.Write("Procesando....")
'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x)&"<hr>")
'next
  folio_envio = request.querystring("folio_envio")
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
  
  set formulario = new CFormulario
  formulario.Carga_Parametros "depositos_multidebito.xml", "f_letras"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  
  for fila = 0 to formulario.CuentaPost - 1
    envio   = formulario.ObtenerValorPost (fila, "envi_ncorr")
	if envio <> "" then
	else
     formulario.EliminaFilaPost fila    
    end if 
  next
  formulario.MantieneTablas false
  'conexion.estadotransaccion false  'roolback   
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))   
%>
