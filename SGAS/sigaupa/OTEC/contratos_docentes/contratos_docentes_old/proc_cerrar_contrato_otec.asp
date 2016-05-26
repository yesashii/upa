<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")
next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()



set formulario = new CFormulario
formulario.Carga_Parametros "detalle_contratos_docentes_otec.xml", "contrato_creados"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1	

cdot_ncorr =formulario.ObtenerValorPost (fila,"cdot_ncorr")
'anot_ncorr = formulario.ObtenerValorPost (fila,"anot_ncorr")

'Response.Write("<br> anot_ncuotas2 :"&anot_finicio2)

if cdot_ncorr <> "" then
insert="update contratos_docentes_otec set ecdo_ccod=2 where cdot_ncorr="&cdot_ncorr&""
'Response.Write("<br> insert :"&insert)
'response.End()
conexion.ejecutas(insert)
end if
next
'formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="EL Contratos selecionado fue cerrado correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar cerrar uno o más anexos para este contrato."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>