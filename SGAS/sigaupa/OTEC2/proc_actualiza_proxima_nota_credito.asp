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
v_cod_rango			=	request.Form("rncc_ncorr")
v_num_nota_credito	=	request.Form("ultima_nota_credito")



set formulario = new CFormulario
formulario.Carga_Parametros "notacredito.xml", "f_notacredito"
formulario.Inicializar conexion
formulario.ProcesaForm		

	sql_existe_nc="select count(*) from notas_de_credito where ndcr_nnota_credito="&v_num_nota_credito
	v_existe=conexion.ConsultaUno(sql_existe_nc)
	if v_existe then
		session("mensajeError")="ERROR!! El número ingresado ya existe en el sistema."
		response.Redirect(request.ServerVariables("HTTP_REFERER"))
	end if
	
	sql_actualiza_nc= "update rangos_notas_credito_cajeros set rncc_nactual="&v_num_nota_credito&" where rncc_ncorr="&v_cod_rango
	conexion.EjecutaS(sql_actualiza_nc)

'response.Write("<pre>"&sql_actualiza_boleta&"</pre>")
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="El número de la proxima nota de credito fue guardado correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar la proxima nota de credito.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
