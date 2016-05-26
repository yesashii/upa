<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

set formulario = new CFormulario
formulario.Carga_Parametros "detalle_contratos_docentes_otec.xml", "detalle_anexos_contratos"
formulario.Inicializar conexion
formulario.ProcesaForm	

for fila = 0 to formulario.CuentaPost - 1	

cdot_ncorr =formulario.ObtenerValorPost (fila,"cdot_ncorr")
anot_ncorr = formulario.ObtenerValorPost (fila,"anot_ncorr")
anot_finicio = formulario.ObtenerValorPost (fila,"anot_FINICIO")
anot_ffin = formulario.ObtenerValorPost (fila,"anot_FFIN")
anot_ncuotas = formulario.ObtenerValorPost (fila,"anot_ncuotas")
'Response.Write("<br> anot_ncuotas2 :"&anot_finicio2)

if cdot_ncorr <> "" then
insert="update anexos_otec set anot_finicio='"&anot_finicio&"',anot_ffin='"&anot_ffin&"',anot_ncuotas="&anot_ncuotas&" where cdot_ncorr="&cdot_ncorr&" and anot_ncorr="&anot_ncorr&""

conexion.ejecutas(insert) 
end if
next
'insert="update anexos_otec set anot_fincicio='"&anot_fincion&"',anot_ffin='"&anot_ffin&"',anot_ncuotas='"&anot_ncuotas&"' where cdot_ncorr="&cdot_ncorr&" and anot_ncorr="&anot_ncorr&"" 
'Response.Write("<br> insert :"&insert)

'formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los Anexos selecionados fueron actualizados correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar uno o mas anexos para este contrato.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>