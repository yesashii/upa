<!-- #include file = "../biblioteca/_conexion.asp" -->
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

set f_propiedades = new CFormulario
f_propiedades.Carga_Parametros "propiedades_grupo_familiar.xml", "grilla_propiedades"
f_propiedades.Inicializar conexion
f_propiedades.ProcesaForm
for i=0 to f_propiedades.cuentaPost - 1
	pers_ncorr=f_propiedades.obtenerValorPost(i,"pers_ncorr2")
	rol=f_propiedades.obtenerValorPost(i,"prpe_nrol")
	prpe_ncorr=f_propiedades.obtenerValorPost(i,"prpe_ncorr")
	if pers_ncorr <> "" and rol <>"" then
		consulta_delete = "Delete from propiedades_personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(prpe_ncorr as varchar)='"&prpe_ncorr&"'"
		conexion.ejecutaS(consulta_delete)
	end if
next
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

