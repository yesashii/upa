<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

for each k in request.form
		SQL="DELETE horarios_sedes WHERE hora_CCOD='"&request.Form(k)&"' and sede_ccod ='"&negocio.obtenersede&"'"
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
next


response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
