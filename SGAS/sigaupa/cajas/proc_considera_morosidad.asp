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

v_pers_ncorr		=	request.Form("pers_ncorr")
v_pers_bmorosidad	=	request.Form("pers_bmorosidad")

if v_pers_bmorosidad="" then
	v_pers_bmorosidad="S"
end if

	sql_considera_mosoridad= "update personas set pers_bmorosidad='"&v_pers_bmorosidad&"',audi_tusuario='"&usuario&"', audi_fmodificacion=getdate() where pers_ncorr="&v_pers_ncorr
	conexion.EstadoTransaccion conexion.EjecutaS(sql_considera_mosoridad)

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los datos fueron guardados correctamente"
else
	session("mensajeError")="Ocurrio un error al intentar actualizar la informacion.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
