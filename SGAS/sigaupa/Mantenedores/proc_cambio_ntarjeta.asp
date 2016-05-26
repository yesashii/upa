<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()
ding_ndocto=request.Form("test[0][ding_ndocto]")
cuenta_corriente=request.Form("test[0][CUENTA_CORRIENTE]")

'response.Write(cuenta_corriente)
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

		SQL="UPDATE DETALLE_INGRESOS SET DING_TCUENTA_CORRIENTE  = "&cuenta_corriente&" WHERE(ding_ndocto = "&ding_ndocto&") and ting_ccod = 52"
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		'response.Write("<br>"&SQL)


'response.End()
session("mensaje_error") = "Se Realizo el Cambio con Exito"
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
