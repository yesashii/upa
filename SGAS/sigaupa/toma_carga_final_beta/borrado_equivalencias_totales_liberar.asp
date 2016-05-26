<!-- #include file="../biblioteca/_conexion.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
matr_ncorr	=	request.QueryString("matr_ncorr")
secc_ccod	=	request.QueryString("secc_ccod")
'response.Write(registros)
set conectar 	= new cconexion
conectar.inicializar "upacifico"

consulta_delete1 = " delete from equivalencias where cast(matr_ncorr as varchar)='"&matr_ncorr&"'"&_
		           " and cast(secc_ccod as varchar)='"&secc_ccod&"'"
'response.Write(consulta_delete1)		  
'response.End()
conectar.ejecutaS consulta_delete1

if conectar.ObtenerEstadoTransaccion then 
	session("mensajeError")="La equivalencia ha sido liberada correctamente, ahora puede volver a asignarla."
else
    session("mensajeError")="No se ha podido liberar la equivalencia, intentelo nuevamente."	
end if
			
				
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>