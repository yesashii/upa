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
		SQL="UPDATE modulos_otec set mote_boculto = case isnull(mote_boculto,0) when 0 then 1 else 0 end WHERE mote_ccod='"&request.Form(k)&"'"
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		'response.Write("<br>"&k&"->"&request.Form(k))
next

'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
