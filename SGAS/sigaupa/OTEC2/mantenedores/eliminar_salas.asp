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
mensaje_error = ""
for each k in request.form
        sala_ccod = request.Form(k)
		esta_en_pregrado = conectar.consultaUno("select case count(*) when 0 then 'N' else 'S' end from bloques_horarios where cast(sala_ccod as varchar)='"&sala_ccod&"'")
		if esta_en_pregrado = "N" then 
		  SQL=" DELETE salas WHERE cast(sala_ccod as varchar)='"&sala_ccod&"' "
		  conectar.EjecutaS(SQL)
		  'response.Write(SQL)
		else
			sala_tdesc = conectar.consultaUno("select sala_tdesc from salas where cast(sala_ccod as varchar)='"&sala_ccod&"'")
			mensaje_error = mensaje_error & "\n - La Sala "&sala_tdesc&" en algún momento ha sido asignada a un horario de pregrado."
		end if
		
		
next

if mensaje_error <> "" then 
    'response.Write("algunas sala no han podido ser borradas por los siguientes errores: "&mensaje_error)
	conectar.MensajeError "La(s) siguiente(s) sala(s) no ha(n) podido ser borrada(s) por los siguientes errores: "&mensaje_error
end if
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
