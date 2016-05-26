<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion'2
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------------------------------------------------
pers_ncorr = request.Form("pers_ncorr")
opcion = request.Form("opcion")
es_alumno = request.Form("es_alumno")
es_profesor = request.Form("es_profesor")
es_administrativo = request.Form("es_administrativo")
tipo=""

if es_alumno <> "0" then
	tipo = "Alumno"
end if
if es_profesor <> "0" then
	tipo = "Profesor"
end if
if es_administrativo <> "0" then
	tipo = "Adm."
end if

if len(pers_ncorr) > 0 and len(opcion) > 0 then
    c_insert = " insert into votacion_concurso_dg "&_
	           " values ("&pers_ncorr&","&opcion&",'"&tipo&"',getDate(),'"&negocio.obtenerUsuario&"',getDate(),2012)"
	conexion.ejecutaS(c_insert)
end if


if conexion.ObtenerEstadoTransaccion then
	Response.Redirect("index.asp")
else
	conexion.MensajeError "Ha ocurrido un error al tratar de grabar el afiche seleccionado..."
	Response.Redirect("index.asp")
end if
%>

