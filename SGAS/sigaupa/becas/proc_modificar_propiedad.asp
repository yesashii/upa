<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_grupo_familiar = new CFormulario
f_grupo_familiar.Carga_Parametros "propiedades_grupo_familiar.xml", "grilla_propiedades"
f_grupo_familiar.Inicializar conexion
f_grupo_familiar.ProcesaForm

if not EsVacio(f_grupo_familiar.ObtenerValorPost(0, "pers_ncorr")) and not EsVacio(f_grupo_familiar.ObtenerValorPost(0, "prpe_ncorr")) then
  f_grupo_familiar.MantieneTablas false
end if

'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

