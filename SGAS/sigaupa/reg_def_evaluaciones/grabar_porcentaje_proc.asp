<!-- #include file="../biblioteca/_conexion.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conectar 	= new cconexion
conectar.inicializar "upacifico"
'conectar.EstadoTransaccion false

porcentaje = request.Form("secc_porce_asiste")
seccion = request.Form("secc_ccod_temporal")

		
sentencia = "update secciones set secc_porce_asiste="&porcentaje&" where cast(secc_ccod as varchar)='"&seccion&"'"
conectar.EstadoTransaccion conectar.EjecutaS(sentencia)
'response.Write(sentencia)
'response.End()

if conectar.obtenerEstadoTransaccion then	
	session("mensajeError") = "El porcentaje requisito para aprobación de la asignatura se ha guardado exitosamente"
else
	session("mensajeError") = "Ocurrio un error al tratar de guardar el porcentaje de la asignatura, intentelo nuevamente."
end if	
		
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

