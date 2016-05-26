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
'response.End()
v_cod_rango		=	request.Form("rbca_ncorr")
v_num_boleta	=	request.Form("ultima_boleta")
v_tbol_ccod		=	request.Form("tipo_boleta")


set formulario = new CFormulario
formulario.Carga_Parametros "boletas_venta.xml", "f_boletas"
formulario.Inicializar conexion
formulario.ProcesaForm		

	sql_existe_boleta="select count(*) from boletas where bole_nboleta="&v_num_boleta&" and tbol_ccod="&v_tbol_ccod
	v_existe=conexion.ConsultaUno(sql_existe_boleta)
	if v_existe then
		session("mensajeError")="ERROR!! El número ingresado ya existe en el sistema."
		response.Redirect(request.ServerVariables("HTTP_REFERER"))
	end if
	
	sql_actualiza_boleta= "update rangos_boletas_cajeros set rbca_nactual="&v_num_boleta&" where rbca_ncorr="&v_cod_rango
	conexion.EjecutaS(sql_actualiza_boleta)

'response.Write("<pre>"&sql_actualiza_boleta&"</pre>")
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="El número de la proxima boleta fue guardado correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar la proxima boleta.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
