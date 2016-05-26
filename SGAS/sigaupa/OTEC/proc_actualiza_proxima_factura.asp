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

v_cod_rango		=	request.Form("rfca_ncorr")
v_num_factura	=	request.Form("ultima_factura")
v_tfac_ccod		=	request.Form("tipo_factura")


set formulario = new CFormulario
formulario.Carga_Parametros "factura.xml", "f_facturas"
formulario.Inicializar conexion
formulario.ProcesaForm		

	sql_existe_factura="select count(*) from facturas where fact_nfactura="&v_num_factura&" and tfac_ccod="&v_tfac_ccod
	v_existe=conexion.ConsultaUno(sql_existe_factura)
	'response.Write(sql_existe_factura)
	
	if v_existe then
		session("mensajeError")="ERROR!! El número ingresado ya existe en el sistema."
		response.Redirect(request.ServerVariables("HTTP_REFERER"))
	end if
'response.End()	
	sql_actualiza_factura= "update rangos_facturas_cajeros set rfca_nactual="&v_num_factura&" where rfca_ncorr="&v_cod_rango
	conexion.EjecutaS(sql_actualiza_factura)

'response.Write("<pre>"&sql_actualiza_factura&"</pre>")
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="El número de la proxima factura fue guardado correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar la proxima factura.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
