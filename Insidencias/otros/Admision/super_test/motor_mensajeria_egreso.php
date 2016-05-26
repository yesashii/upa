<?php 
error_reporting(0);
$rut = $_POST['rut'];
$alumno = $_POST['alumno'];
$email_desde = $_POST['email_desde'];
$email_hasta = $_POST['email_hasta'];
$asunto = $_POST['asunto'];
$contenido = $_POST['contenido'];
$fecha = date("d/m/Y H:i:s");

/********************************************************************************/
$mensaje = '
<html>
<head>
<title>Universidad del Pac&iacute;fico</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
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
</style></head>
<body bgcolor="#FFFFFF">
<table width="600" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	    <td width="3%" align="left">&nbsp;</td>
	  	<td colspan="3" height="59" align="center"><span id="titulo"><font color="#0066FF" face="Verdana, Arial, Helvetica, sans-serif" size="5">MENSAJE EXPEDIENTE VIRTUAL DE TITULACIÓN</font></span><br><font color="#000000" size="1">'.$fecha.'</font></td>
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
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Nombre</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$alumno.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Asunto</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$asunto.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo">'.$contenido.'</p></td>
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

echo $mensaje;
//exit;
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: $email_desde' . "\r\n";
$cabeceras .= 'Bcc: marcelo_sandoval@hotmail.cl' . "\r\n";
$resultado = mail("$email_hasta","EVT: ".$asunto, $mensaje, $cabeceras);
//
if ($resultado) {
	echo 'Mensaje enviado correctamente';
} else {
	echo 'Ocurrió un problema al tratar de enviar el mensaje';
}
//
?>