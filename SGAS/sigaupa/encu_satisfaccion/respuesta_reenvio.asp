

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


respuesta=request.QueryString("resp")

if respuesta="si" then
session("mensajeerror")= "La encuesta ha sido Reenviada" 
else
session("mensajeerror")= "Error al reenviar" 
end if
'response.End()
response.Redirect("estado_encuesta.asp")

 %>