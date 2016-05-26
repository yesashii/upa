<?php 
error_reporting(0);
$rut = $_GET['rut'];
$email_alumno = $_GET['email_alumno'];
$nombre = $_GET['nombre'];
$carrera = $_GET['carrera'];
$email_director = $_GET['email_director'];
$fecha = date("d/m/Y H:i:s");

/********************************************************************************/
$mensaje = '
<html>
<head>
<title>Universidad del Pac&iacute;fico</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
	background-image: url(http://www.upacifico.cl/mail_postulacion2009/imagenes/background.png);
	background-repeat: repeat;
	background-color: #CCCCCC;	
}
#titulo {
	color: #FFFFFF;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 24px;
	font-weight: bold;
}
#parrafo {
	color: #000000;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 15px;
	text-align:justify;
}
#pie {
	color: #FFFFFF;
}
a {
	font-size: 10px;
	font-weight: normal;
	color: #0000FF;
}
a:hover {
	color: #FF0000;
}
.Titulo {
font-size: 12px;
font-weight: bold;
margin-left:15px;
}
.Detalle {
font-size: 10px;
font-weight: normal;
margin-left:15px;
}
-->
</style></head>
<body bgcolor="#FFFFFF">
<table width="600" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	    <td width="3%" align="left">&nbsp;</td>
	  	<td colspan="3" height="59" align="center"><span id="titulo"><font color="#0066FF" face="Verdana, Arial, Helvetica, sans-serif" size="5">INICIO PROCESO DE EGRESO</font></span><br><font color="#000000" size="1">'.$fecha.'</font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo">El departamento de títulos y grados, a través del presente email, desea informarles que a partir del día actual se ha iniciado el proceso de egreso del alumno en la Universidad. </p></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Rut</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$rut.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Nombre</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$nombre.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Carrera</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$carrera.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
</table>
</body>
</html>';

//echo $mensaje;
//exit;
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: administrador@upacifico.cl' . "\r\n";
$cabeceras .= 'Bcc: marcelo_sandoval@hotmail.cl' . "\r\n";
$resultado = mail("titulosygrados@upacifico.cl, $email_alumno , $email_director","Proceso egreso ".$nombre, $mensaje, $cabeceras);
//
if ($resultado) {
	echo 'true';
} else {
	echo 'false';
}
//
?>