<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form'
'	response.write(k&"="&request.Form(k)&"<br>")'
'next'
'response.End()'

set f_cc = new cformulario
f_cc.carga_parametros "areas_gastos.xml", "perfiles_areas" 
f_cc.inicializar conexion							
f_cc.ProcesaForm

for fila = 0 to f_cc.CuentaPost - 1

	pare_ccod = f_cc.ObtenerValorPost (fila, "pare_ccod")
'response.Write("<br>aaaa: "&fila)
	if pare_ccod<>"" then
	
		query="update ocag_perfiles_areas set epar_ccod=3 where pare_ccod="&pare_ccod&" "
		'response.write(query&"<br>")'
		conexion.EjecutaS(query)
	end if
next
'response.End()'
response.Redirect(Request.ServerVariables("HTTP_REFERER"))'
%>
