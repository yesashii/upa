<html>
<head>
<%
rut_usuario=session("rut_usuario")
'response.write rut_usuario
'response.write("inferior")
'response.end()

if rut_usuario="" then
	paginaTerminoSesion = "../portada/portada.asp"
	response.Redirect paginaTerminoSesion
	response.flush
end if
'comentario_desarrolladores "172.16.100.128","ok",0
res = request.QueryString("resolucion")

Select Case (res)
	case 1152
	'columna ="198,230,*,198"
    columna ="300,*"
	case 1024
	'columna ="135,230,*,135"
    columna ="300,*"
	case 800
	'columna ="20,230,*,20"
    columna ="300,*"
	case 1280
	'columna = "260,230,*,260"
    columna = "300,*"
	case 1400
	'columna = "260,230,*,260"
    columna = "300,*"
	case else
	'columna = "260,230,*,260"
    columna = "300,*"
end select



%>

<title>SAGAF</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

 <frameset rows="*,0" cols="<%=columna%>" framespacing="0" frameborder="NO" border="0" bordercolor="#999999" noresize>
    <frame src="modulos.asp" name="leftFrame" scrolling="auto" border="0"  noresize >
    <frame src="detalle.asp" name="mainFrame" scrolling="yes" border="0"  noresize>
  </frameset>
<noframes><body>

</body></noframes>
</html>
