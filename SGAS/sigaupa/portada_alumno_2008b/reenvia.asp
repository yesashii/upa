<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%'response.End()
 '------------------------------------------------------------
codigo = request.QueryString("codigo")

'session("rut_apoderado")=session("rut_usuario")
session("rut_usuario")=codigo

if codigo="" then
	session("mensajeerror")= "ocurrio un error inesperado, porfavor vuela a intentarlo."
	response.Redirect("portada_alumno.asp") 		
else
	if clng(codigo)=clng(session("rut_apoderado")) then
		response.Redirect("../informacion_alumno_2008b/inicio.html")
	else
		response.Redirect("../informacion_apoderado/inicio.html")
	end if
	
end if	
%>