<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conexion = new CConexion
conexion.Inicializar "upacifico"


set f_mensajes = new CFormulario
f_mensajes.Carga_Parametros "mensajes.xml", "mensajes"
f_mensajes.Inicializar conexion
f_mensajes.ProcesaForm



for i_ = 0 to f_mensajes.CuentaPost - 1
	mepe_ncorr = f_mensajes.ObtenerValorPost(i_,"mepe_ncorr")
	if mepe_ncorr<> "" then
		c_update = "update mensajes_entre_personas set estado='Eliminado' where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'"
		conexion.ejecutaS c_update
	end if

next
'response.End()

'----------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
