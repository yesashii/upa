<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar
seot_ncorr = request.Form("b[0][seot_ncorr]")
dgso_ncorr = request.Form("m[0][dgso_ncorr]")

if seot_ncorr ="" then
	SQL = "UPDATE datos_generales_secciones_otec set seot_ncorr_comun=NULL where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'"
else
	SQL = "UPDATE datos_generales_secciones_otec set seot_ncorr_comun="&seot_ncorr&" where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'"
end if

conectar.EstadoTransaccion conectar.EjecutaS(SQL)


'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
