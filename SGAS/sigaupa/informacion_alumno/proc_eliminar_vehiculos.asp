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

set f_vehiculos = new CFormulario
f_vehiculos.Carga_Parametros "propiedades_grupo_familiar.xml", "grilla_datos_vehiculos"
f_vehiculos.Inicializar conexion
f_vehiculos.ProcesaForm
for i=0 to f_vehiculos.cuentaPost - 1
	pers_ncorr = f_vehiculos.obtenerValorPost(i,"pers_ncorr2")
	vepe_ncorr = f_vehiculos.obtenerValorPost(i,"vepe_ncorr")
	'response.Write("pers_ncorr "&pers_ncorr&" patente "&patente)
	if pers_ncorr <> "" and vepe_ncorr <>"" then
		consulta_delete = "Delete from vehiculos_personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(vepe_ncorr as varchar)='"&vepe_ncorr&"'"
		'response.Write(consulta_delete)
		conexion.ejecutaS(consulta_delete)
	end if
next
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

