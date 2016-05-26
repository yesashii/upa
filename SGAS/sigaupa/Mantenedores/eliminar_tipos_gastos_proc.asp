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
f_cc.carga_parametros "areas_gastos.xml", "tipos_gastos" 
f_cc.inicializar conexion							
f_cc.ProcesaForm

for fila = 0 to f_cc.CuentaPost - 1

	tgas_ccod = f_cc.ObtenerValorPost (fila, "tgas_ccod")
'response.Write("<br>aaaa: "&fila & ": "&tgas_ccod)
	if tgas_ccod<>"" then
	
		query="update ocag_tipo_gasto set etga_ccod=3 where tgas_ccod="&tgas_ccod&" "
'		response.write(query&"<br>")'
		conexion.EjecutaS(query)
	end if
next
if conexion.obtenerEstadoTransaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo eliminar el tipo de gasto asociado al perfil.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="El tipo de dato seleccionado fue eliminado exitosamente del perfil asociado."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))'
%>
