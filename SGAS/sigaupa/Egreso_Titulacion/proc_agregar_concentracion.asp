<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'conexion.estadoTransaccion false
set f_concentracion = new CFormulario
f_concentracion.Carga_Parametros "detalle_egreso_titulacion.xml", "concentracion"
f_concentracion.Inicializar conexion
f_concentracion.ProcesaForm

promedio = conexion.consultaUno("select replace(cast("&request.Form("concentracion[0][promedio_final]")&" as decimal(2,1)),',','.')")

f_concentracion.AgregaCampoFilaPost 0, "promedio_final", promedio'f_practica.ObtenerValorPost(0, "sitf_ccod")

f_concentracion.MantieneTablas false

'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
