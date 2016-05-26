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

'set negocio = new CNegocio
'negocio.Inicializa conexion

'conexion.estadoTransaccion false
'response.Write("Estado 1 "&conexion.obtenerEstadoTransaccion)
pais_ccod = request.Form("dp[0][pais_ccod]")
set f_personas = new CFormulario
f_personas.Carga_Parametros "cpp_externos.xml", "datos_personales"
f_personas.Inicializar conexion
f_personas.ProcesaForm


f_personas.MantieneTablas false
'response.Write("Estado 2 "&conexion.obtenerEstadoTransaccion)

'---------------------------------------------------------------------------------
if pais_ccod = "" or pais_ccod = "1" then
     'response.Write("ENTRE con pais = "&pais_ccod&"<br>")
	set f_direcciones = new CFormulario
	f_direcciones.Carga_Parametros "cpp_externos.xml", "direcciones"
	f_direcciones.Inicializar conexion
	f_direcciones.ProcesaForm
	'f_direcciones.ClonaFilaPost 0
	
	f_direcciones.AgregaCampoFilaPost 0, "tdir_ccod", "2"
	f_direcciones.AgregaCampoFilaPost 0, "dire_tfono", f_personas.ObtenerValorPost(0, "pers_tfono")
	f_direcciones.AgregaCampoFilaPost 0, "dire_tcelular", f_personas.ObtenerValorPost(0, "pers_tcelular")
	
	f_direcciones.MantieneTablas FALSE
end if

'response.Write("Estado 3 "&conexion.obtenerEstadoTransaccion)
'---------------------------------------------------------------------------------
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
