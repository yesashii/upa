<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

sede_ccod= negocio.obtenerSede



'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

v_cod_nc=request.QueryString("cod_nota_credito")


		
sql_actualiza_nc= "update notas_de_credito set encr_ccod=2 where ndcr_ncorr="&v_cod_nc
conexion.EjecutaS(sql_actualiza_nc)

'response.Write("<pre>"&sql_actualiza_boleta&"</pre>")
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las Notas de Credito selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas Notas de Credito.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript1.1">
	window.close();
</script>