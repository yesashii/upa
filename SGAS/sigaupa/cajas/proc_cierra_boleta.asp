<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

sede_ccod= negocio.obtenerSede

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

v_cod_boleta=request.QueryString("cod_boleta")
v_num_caja=request.QueryString("num_caja")


set formulario = new CFormulario
formulario.Carga_Parametros "boletas_venta.xml", "f_boletas"
formulario.Inicializar conexion
formulario.ProcesaForm		

			
		
		sql_actualiza_boleta= "update boletas set ebol_ccod=2 where bole_ncorr="&v_cod_boleta
		conexion.EjecutaS(sql_actualiza_boleta)

'response.Write("<pre>"&sql_actualiza_boleta&"</pre>")
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las Boletas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas boletas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript1.1">
	window.close();
</script>