<html>
<head>
<%
rut_usuario=session("rut_usuario")
if rut_usuario="" then
	paginaTerminoSesion = "../portada/portada.asp"
	response.Redirect paginaTerminoSesion
	response.flush
end if

res = request.QueryString("resolucion")

'Select Case (res)  
'	case 1152
	'columna ="198,230,*,198"
'    columna ="0,230,*,0"
'	case 1024
	'columna ="135,230,*,135"
'    columna ="0,230,*,0"
'	case 800
	'columna ="20,230,*,20"
'    columna ="0,230,*,0"
'	case 1280
	'columna = "260,230,*,260"
'    columna = "0,230,*,0"

'end select  

Select Case (res)  
	case 1152
             columna = "*,148,876,*"
	case 1024
             columna = "*,148,876,*"
	case 800
             columna = "*,148,876,*"
	case 1280
             columna = "*,148,876,*"
	case else
		     columna = "*,148,876,*"		 
end select  



%>

<title>SAGAF</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>

 <frameset rows="*,0" cols="<%=columna%>" framespacing="0" frameborder="NO" border="0" bordercolor="#999999" noresize>
    <frame src="relleno.asp" name="leftFrame" scrolling="no" border="0"  noresize >
    <frame src="modulos.asp" name="leftFrame" scrolling="no" border="0"  noresize >
    <frameset rows="0,*" frameborder="NO" border="0" framespacing="0"> 
           <frame src="detalle.asp"  scrolling="no" name="mainFrame" frameborder="no" noresize>
           <frame src="contenido.asp" name="contenido" scrolling="yes" noresize>
    </frameset>
    <frame src="relleno.asp" name="leftFrame" scrolling="no" border="0"  noresize >
  </frameset>
<noframes><body >

</body></noframes>
</html>
