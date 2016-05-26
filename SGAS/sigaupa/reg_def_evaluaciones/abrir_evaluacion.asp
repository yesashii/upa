<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

secc_ccod =	request.Querystring("secc_ccod")


set conectar 	= new cconexion
set errores = new cErrores

conectar.inicializar "upacifico"
'conectar.EstadoTransaccion false

if not EsVacio(secc_ccod) then
		
		sentencia = "update secciones set estado_cierre_ccod= NULL where cast(secc_ccod as varchar)= '" & secc_ccod & "'"
		conectar.EstadoTransaccion conectar.EjecutaS(sentencia)
		'Response.Write("<pre>" & sentencia & "</pre>")		
		
		sentencia = "update cargas_Academicas set estado_cierre_ccod = 1  where cast(secc_ccod as varchar)= '" & secc_ccod & "'"
		conectar.EstadoTransaccion conectar.EjecutaS(sentencia)
		'Response.Write("<pre>" & sentencia & "</pre>")		
				
	end if

Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>

