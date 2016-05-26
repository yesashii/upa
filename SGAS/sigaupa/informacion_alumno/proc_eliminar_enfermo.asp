<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_enfermos = new CFormulario
f_enfermos.Carga_Parametros "ant_salud_familiar.xml", "grilla_enfermos"
f_enfermos.Inicializar conexion
f_enfermos.ProcesaForm
for i=0 to f_enfermos.cuentaPost - 1
	enfp_ncorr = f_enfermos.obtenerValorPost(i,"enfp_ncorr")
	if enfp_ncorr<>"" then
		consulta_delete = "Delete from enfermedades_persona where cast(enfp_ncorr as varchar)='"&enfp_ncorr&"'"
		
		conexion.ejecutaS(consulta_delete)
	end if
next
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

