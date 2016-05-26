<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'for each x in request.Form
'	response.Write(x&"->"&request.Form(x)&"<br>")
'next
'response.End()
folio_envio = request.querystring("folio_envio")
set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "envios_sedes.xml", "f_letras"
formulario.Inicializar conexion
formulario.ProcesaForm

  for fila = 0 to formulario.CuentaPost - 1
    envio   = formulario.ObtenerValorPost (fila, "esed_ncorr")
	if envio <> "" then
	else
     formulario.EliminaFilaPost fila    
    end if 
  next
  formulario.MantieneTablas false
  'conexion.estadotransaccion False  'roolback    

response.Redirect(request.ServerVariables("HTTP_REFERER"))   
%>


