<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

set formulario = new CFormulario
formulario.Carga_Parametros "numeros_boletas_venta.xml", "detalle_boletas"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_rbol_ncorr		= formulario.ObtenerValorPost (fila, "rbol_ncorr")
   
   if v_rbol_ncorr <> "" then
		
		formulario.AgregaCampoFilaPost fila , "erbo_ccod", "2"

   end if
next

if v_error <> "" then
	session("MensajeError")=v_error
	response.Redirect(request.ServerVariables("HTTP_REFERER"))
end if
'response.End()

formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los rangos de boletas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar uno o mas rangos boletas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>