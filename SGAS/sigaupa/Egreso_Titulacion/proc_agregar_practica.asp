<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'conexion.estadoTransaccion false
set f_practica = new CFormulario
f_practica.Carga_Parametros "detalle_egreso_titulacion.xml", "datos_egreso"
f_practica.Inicializar conexion
f_practica.ProcesaForm

f_practica.AgregaCampoFilaPost 0, "concepto_practica", f_practica.ObtenerValorPost(0, "sitf_ccod")

f_practica.MantieneTablas false

'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
