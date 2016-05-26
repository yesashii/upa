<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

v_cod_factura=request.QueryString("cod_factura")
'v_origen	=request.QueryString("origen")



		sql_actualiza_boleta= "update facturas set efac_ccod=2 where fact_ncorr="&v_cod_factura
		conexion.EjecutaS(sql_actualiza_boleta)

'Response.Write(sql_actualiza_boleta)

'conexion.EstadoTransaccion false
'response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="La o las Facturas selecionadas fueron guardadas correctamente."
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas facturas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

