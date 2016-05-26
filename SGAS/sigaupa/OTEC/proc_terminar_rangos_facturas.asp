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
formulario.Carga_Parametros "numeros_facturas_venta.xml", "detalle_facturas"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_rfac_ncorr		= formulario.ObtenerValorPost (fila, "rfac_ncorr")
   v_tfac_ccod		= formulario.ObtenerValorPost (fila, "tfac_ccod")
   v_sede_ccod		= formulario.ObtenerValorPost (fila, "c_sede_ccod")

   
   if v_rfac_ncorr <> "" then
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

'sql_chequea_activas="select count(*) from rangos_facturas_sedes where tfac_ccod="&v_tfac_ccod&" and inst_ccod="&v_inst_ccod&" and erfa_ccod=1 "

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los rangos de facturas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar uno o mas rangos facturas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>