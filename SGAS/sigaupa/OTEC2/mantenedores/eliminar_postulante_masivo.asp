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
        matriculado = conectar.consultaUno("select count(*) from postulacion_otec WHERE pote_ncorr='"&request.Form(k)&"' and epot_ccod=4")
		if matriculado = "0" then 
			SQL="DELETE postulacion_otec WHERE pote_ncorr='"&request.Form(k)&"'"
			conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		end if	
next

'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
