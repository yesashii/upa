<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")
next
'response.End()

set formulario = new CFormulario
formulario.Carga_Parametros "detalle_contratos_docentes_otec.xml", "contrato_creados"
formulario.Inicializar conexion
formulario.ProcesaForm		
for fila = 0 to formulario.CuentaPost - 1	

cdot_ncorr =formulario.ObtenerValorPost (fila,"cdot_ncorr")
cdot_finicio = formulario.ObtenerValorPost (fila,"cdot_FINICIO")
cdot_ffin = formulario.ObtenerValorPost (fila,"cdot_FFIN")
tcdo_ccod = formulario.ObtenerValorPost (fila,"tcdo_ccod")
'Response.Write("<br> anot_ncuotas2 :"&anot_finicio2)

'if cdate(cdot_finicio) > cdate(cdot_ffin)then

if cdot_ncorr <> "" then
insert="update contratos_docentes_otec set cdot_finicio='"&cdot_finicio&"',cdot_ffin='"&cdot_ffin&"',tcdo_ccod="&tcdo_ccod&" where cdot_ncorr="&cdot_ncorr&" "
'Response.Write("<br>"&insert)
conexion.ejecutas(insert) 
end if
'else
'session("mensajeError")="La fecha de fin no puede ser menor a la de inicio"
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))

'end if
next
'formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los Contratos selecionados fueron actualizados correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar guardar este contrato.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>