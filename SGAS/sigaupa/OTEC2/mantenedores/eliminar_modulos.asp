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
		SQL="DELETE modulos_otec WHERE mote_ccod='"&request.Form(k)&"'"
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		'response.Write("<br>"&k&"->"&request.Form(k))
next

'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
