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
'Uresponse.End()'

set f_cc = new cformulario
f_cc.carga_parametros "centro_costo_compra.xml", "centro_costos" 
f_cc.inicializar conexion							
f_cc.ProcesaForm

for fila = 0 to f_cc.CuentaPost - 1

	ccos_ncorr = f_cc.ObtenerValorPost (fila, "ccos_ncorr")
'response.Write("<br>aaaa: "&fila)
	if ccos_ncorr<>"" then
	
		query="update ocag_centro_costo set ecco_ccod=3 where ccos_ncorr="&ccos_ncorr&" "
		'response.write(query&"<br>")'
		conexion.EjecutaS(query)
	end if
next
'response.End()'
response.Redirect(Request.ServerVariables("HTTP_REFERER"))'
%>
