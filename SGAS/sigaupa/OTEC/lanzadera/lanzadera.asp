<%
rut_usuario=session("rut_usuario")
if rut_usuario="" then
	paginaTerminoSesion = "../portada/portada.asp"
	response.Redirect paginaTerminoSesion
	response.flush
end if
%>

<html>
<head>
<script language='JScript'>
function redireccionar (){
	var width = screen.width
	url="lanzadera_up.asp?resolucion="+width 
	window.location= url;


}
</script>

<title>SAGAF</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body onLoad="redireccionar()">
</body></noframes>
</html>
