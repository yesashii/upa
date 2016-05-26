<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

v_corr_ncorr=request.Form("envio[0][corr_ncorr]")

  set formulario = new CFormulario
  formulario.Carga_Parametros "correspondencia.xml", "f_nuevo"
  formulario.Inicializar conexion
  formulario.ProcesaForm

'----------------------------------------------------------------------
	if v_corr_ncorr="" then
		v_corr_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'correspondencia'")    
		formulario.agregacampopost "corr_ncorr" , v_corr_ncorr
	end if
'----------------------------------------------------------------------   

formulario.MantieneTablas false
'response.Write("<br><b>Estado :</b>"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

