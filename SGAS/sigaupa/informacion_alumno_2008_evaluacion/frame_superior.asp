<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
v_anio_actual	= 	Year(now())
if v_mes_actual=08 and v_dia_actual < 12 then
	habilitar_encuesta = "N"
else
	habilitar_encuesta = "N"
end if

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color:red;
color: white;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#84a6d3" background="imagenes/fondo.jpg">
<center>
<table align="center" width="1000">
	<tr valign="top">
		<td align="100%">
			<table cellpadding="0" cellspacing="0" align="left" border="0">
				<tr>
					<td width="388" height="73"><img width="388" height="73" src="imagenes/banner1.jpg"></td>
					<td width="612" height="73"><img width="612" height="73" src="imagenes/banner2.jpg"></td>
				</tr>
				<tr valign="top">
					<td width="388" height="50" bgcolor="#4b73a6"><img width="388" height="49" src="imagenes/banner3.jpg"></td>
					<td width="612" height="50" bgcolor="#4b73a6">
					  <table width="100%" height="50" cellpadding="0" cellspacing="0">
					  	<tr valign="middle">
							<td align="left" width="100%">
							<div id="menu"><div class="barraMenu">
								<!--<a class="botonMenu" href="mensajes.asp" target="central">Ev. Docente</a>-->
								<%if habilitar_encuesta = "S" then%>
								<a class="botonMenu" href="seleccionar_docente.asp" target="central">Ev. Docente</a>
								<%end if%>
								<a class="botonMenu" href="cerrar_sesion.asp" target="central">Cerrar Sesión</a>
							</div></div>
							</td>
						</tr>
					  </table>
						
					</td>
				</tr>
			</table>
		
		</td>
	</tr>
</table>
</center>
</body>
</html>
