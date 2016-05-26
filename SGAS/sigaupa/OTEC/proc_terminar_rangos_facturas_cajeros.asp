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
formulario.Carga_Parametros "numeros_facturas_cajeros.xml", "detalle_facturas_cajero"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_rncc_ncorr		= formulario.ObtenerValorPost (fila, "rfca_ncorr")
   
   if v_rncc_ncorr <> "" then
		
		formulario.AgregaCampoFilaPost fila , "erfa_ccod", "2"

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
	session("mensajeError")="Los rangos de facturas selecionados fueron finalizados correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar uno o mas rangos nots de credito.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>