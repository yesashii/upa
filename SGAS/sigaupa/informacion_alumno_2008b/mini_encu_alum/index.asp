<%if session("rut_usuario")="" then
session("rut_usuario")="15964262"
end if%>
<!-- #include file = "../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../../biblioteca/_negocio.asp" -->
<% 


'------------------------------------------------------
set errores= new CErrores
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
 
 

'---------------------------------------------------------------------------------------------------

 

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style>
DIV#aqui { 
	position:absolute; width:850px; height:85px;
	font-size:36px; text-align:center;
	color:yellow; 
	/*background: url(../include/jquery/img/overlay.gif);*/
	padding-top:1020px;
	top:0; 
	left:200; 
	right:0;
	cursor:pointer
}
</style>
<script language="JavaScript" src="../../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../../biblioteca/validadores.js"></script>

<script language="JavaScript">
function ir()
{
location.href="encu.asp"

}
</script>
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bottommargin="0" background="images/fondo.jpg">
<center>
<table>
	<tr>
		<img src="images/1.png"/>
	</tr>
</table>
<div id="aqui" class="aqui"><img src="images/aqui.png" onClick="ir()" /></div>
</center>
</body>
</html>

