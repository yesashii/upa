<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

for each k in request.form
		SQL="DELETE diplomados_cursos WHERE dcur_ncorr='"&request.Form(k)&"'"
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		'response.Write("<br>"&k&"->"&request.Form(k))
next

'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
