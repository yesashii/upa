<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each x in request.Form
'	response.Write(x&"->"&request.Form(x) &"<br>")
'next




set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'--------------------------------------------------------------------------
set formulario = new CFormulario
  formulario.Carga_Parametros "Act_Usuarios.xml", "f1"
  formulario.Inicializar conexion
  formulario.ProcesaForm
 
  pers_fono =formulario.obtenerValorPost(0,"cod_area")&"-"&formulario.ObtenerValorPost(0,"pers_tfono")
  pers_celular =formulario.obtenerValorPost(0,"pre_celu")&"-"&formulario.ObtenerValorPost(0,"pers_tcelular")
  'response.write(pers_celular)
  formulario.AgregaCampoPost "pers_tfono",pers_fono
  formulario.AgregaCampoPost "pers_tcelular",pers_celular
  'v_hhh=formulario.ObtenerValorPost(0,"pers_tcelular2")
  'reponse.write(v_hhh)
   'Response.end
  formulario.MantieneTablas false
  
  'response.write(conexion.obtenerEstadoTransaccion)
  'response.End()
  Rut = session("rut_usuario")
  URL = "inicio_toma_carga.asp"
  response.Redirect(URL)
 
%>