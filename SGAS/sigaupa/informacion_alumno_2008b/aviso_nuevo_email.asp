<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 
 
 set negocio = new CNegocio
 negocio.Inicializa conexion
 usuario = negocio.obtenerUsuario
 email_alumno = conexion.consultaUno("select top 1 lower(email_nuevo) from cuentas_email_upa where rut like '"&usuario&"%'")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Salvate! respalda tu correo de la U.</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
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
background-color: #637D4D;
color: white;
}
</style>
<script language="JavaScript">
function cerrar ()
{
	window.close;

}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<table align="center" width="350" cellpadding="0" cellspacing="0">
	<tr><td width="100%">&nbsp;</td></tr>
	<tr valign="top">
		<td width="100%" height="529" align="center" background="../imagenes/fondo_aviso_mail.png">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr valign="top">
					<td width="3%">&nbsp;</td>
					<td width="94%"><div align="center"><font color="#333333" size="2"><strong>Queremos ofrecerte un mejor servicio de correo electrónico.<br>Para ello, necesitamos que antes del 03 de Diciembre respaldes toda la información que encuentras pertinente desde tu correo alumnosupacifico.cl o docentesupacifico.cl.<br>Tu nueva cuenta (<font color="#0066CC"><%=email_alumno%></font>) estará disponible a partir del día Jueves 26 de Noviembre en el Pacifico Online.<br>El acceso a tu nuevo email es: <font color="#0066CC">http://alumnos.upacifico.cl</font>.</strong></font></div></td>
					<td width="3%">&nbsp;</td>
				</tr>
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr><td colspan="3" align="center"><font color="#333333" size="3"><strong>..Sálvate antes que sea Demasiado tarde..</strong></font></td></tr>
			</table>
		</td>
	</tr>
	
</table>
</body>
</html>

