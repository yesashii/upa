<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_asig_homo = new CFormulario
f_asig_homo.Carga_Parametros "m_homologaciones_malla.xml", "f_asig_resolucion"
f_asig_homo.Inicializar conexion
f_asig_homo.ProcesaForm

'f_asig_homo.ListarPost
contador = 0
for fila = 0 to f_asig_homo.CuentaPost - 1
   asig_ccod = f_asig_homo.ObtenerValorPost (fila, "asig_ccod")
   if 	asig_ccod <> "" then
	   	homo_ccod = f_asig_homo.ObtenerValorPost (fila, "homo_ccod")
		if	homo_ccod <> "" then
			'response.Write("<br>asig_ccod "& asig_ccod & " homo_ccod " & homo_ccod)
			contador = 0
			sql_delete_efec = "Delete from homologacion_fuente where homo_ccod=" & homo_ccod & " and asig_ccod='" & asig_ccod & "'"
			conexion.EstadoTransaccion conexion.EjecutaS(sql_delete_efec)
			verificar_fuente = "Select count(*) as contador from homologacion_fuente where homo_ccod=" & homo_ccod
			contador = conexion.ConsultaUno(verificar_fuente)
			'response.Write("<br>contador"&contador)
			if	contador = 0 then
				sql_delete_destino = "Delete from homologacion_destino where homo_ccod=" & homo_ccod
				conexion.EstadoTransaccion conexion.EjecutaS(sql_delete_destino)
				sql_delete_homo = "Delete from homologacion where homo_ccod=" & homo_ccod
				conexion.EstadoTransaccion conexion.EjecutaS(sql_delete_homo)
			end if
		end if
	end if
next   


'conexion.estadotransaccion false  'roolback 
'response.End()
transaccion = conexion.obtenerEstadoTransaccion
if transaccion then
	session("mensajeError") = "Homologación eliminada con éxito."
else
	session("mensajeError") = "Error, Homologación no fue eliminada.\nFavor intentarlo nuevamente."
end if
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>