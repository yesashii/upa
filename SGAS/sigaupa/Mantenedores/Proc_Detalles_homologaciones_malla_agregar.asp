<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

homo_nresolucion = request.Form("homo_nresolucion")
homo_nresolucion_nuevo = request.Form("homo[0][homo_nresolucion]")
plan_ccod_fuente = request.Form("busqueda[0][plan_ccod]")
plan_ccod_destino = request.Form("busqueda[0][plan_ccod_destino]")
carr_ccod_destino = request.Form("busqueda[0][carr_ccod_destino]")
esho_ccod = request.Form("homo[0][esho_ccod]")
centinela = 0

'response.Write("homo_nresolucion=" & homo_nresolucion & " homo_nresolucion_nuevo = " & homo_nresolucion_nuevo)
'response.End()
'response.Write("<br>plan_ccod_fuente=" & plan_ccod_fuente)
'response.Write("<br>plan_ccod_destino=" & plan_ccod_destino)
'response.End()
'homo_ccod = conexion.consultauno("exec protic.ObtenerSecuencia 'homologacion'")
if	EsVacio(carr_ccod_destino) then
	sql_update_efec = " update homologacion set esho_ccod=" & esho_ccod & vbcrlf & _
		       	  " where cast(homo_nresolucion as varchar)='" & homo_nresolucion & "'"
else
	sql_update_efec = " update homologacion set plan_ccod_fuente=" & plan_ccod_fuente & ",plan_ccod_destino=" & plan_ccod_destino & ",esho_ccod=" & esho_ccod & vbcrlf & _
		       	  " where cast(homo_nresolucion as varchar)='" & homo_nresolucion & "'"
end if
' necesario para editar el numero de resolucion / 20 de Mayo del 2005
if	not EsVacio(homo_nresolucion_nuevo) then
	if	homo_nresolucion_nuevo <> homo_nresolucion then
		verificando_nresolucion = "Select count(homo_nresolucion) from homologacion where cast(homo_nresolucion as varchar)='" & homo_nresolucion_nuevo & "'" 
		resultado_verificacion = conexion.ConsultaUno(verificando_nresolucion)
		if	resultado_verificacion = 0 then
			sql_update_nresolucion = " Update homologacion set homo_nresolucion='" & Ucase(homo_nresolucion_nuevo) & "'" & vbcrlf & _
									 " where cast(homo_nresolucion as varchar)='" & homo_nresolucion & "'"
			conexion.EstadoTransaccion conexion.EjecutaS(sql_update_nresolucion)
			centinela = 1
			url_a = "Detalle_homologaciones_malla.asp?homo_nresolucion=" & homo_nresolucion_nuevo
		end if
	end if
end if				  

conexion.EstadoTransaccion conexion.EjecutaS(sql_update_efec)

'f_origen.ListarPost
'f_destino.ListarPost
'response.End()

transaccion = conexion.obtenerEstadoTransaccion
'response.End()
if 	transaccion=TRUE then
	session("mensajeError") = "Datos guardados con éxito."
	if 	centinela = 1 then
		url = url_a
	else
		url = Request.ServerVariables("HTTP_REFERER")
	end if
else
	session("mensajeError") = "Error, los datos no fueron guardados.\nFavor intentarlo nuevamente."
	url = Request.ServerVariables("HTTP_REFERER")
end if
'conexion.estadotransaccion false  'roolback 
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
'response.Redirect("Detalle_homologaciones_malla.asp?homo_nresolucion=11121A")
response.Redirect(url)
%>