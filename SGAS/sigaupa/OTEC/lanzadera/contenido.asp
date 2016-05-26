<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 if session("url_actual") <> "" then
	response.Redirect session("url_actual")
	response.flush
  end if
%>
<html>
<head>
<title>Enruteador</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#EAEAEA">
<center>
	<table width="80%">
		<tr height="150">
			<td align="center">&nbsp;</td>
		</tr>
		<tr height="50">
			<td align="center"><font size="3" face="Courier New, Courier, mono"><strong>Presione sobre la opción superior que desea visualizar en pantalla</strong></font></td>
		</tr>
		<tr height="100">
			<td align="center">&nbsp;</td>
		</tr>
	</table>
</center>
</body>
</html>
