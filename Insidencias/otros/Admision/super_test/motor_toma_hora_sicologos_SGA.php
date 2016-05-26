<?php 
error_reporting(0);
$nom_alum = $_GET['nom_alum'];
$nom_sico=$_GET['nom_sico'];
$dia_hora=$_GET['dia_hora'];
$fecha_hora=$_GET['fecha_hora'];
$bloque_hora=$_GET['bloque_hora'];
$mail = $_GET['correo_upa'];
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
#aviso {
	color: #000000;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
	text-align:justify;
}
#link {
	color: #000000;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 17px;
	text-align:justify;
}
#pie {
	color: #000000;
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
<body topmargin="0" bgcolor="#CCCCCC">
<table width="500" height="700" border="0" align="center" cellpadding="0" cellspacing="0"   id="Tabla_01">
<tr>
<td width="439" height="410" align="center" valign="top">
<!-- contenido -->
<!-- -->
<table width="100%" border="0" cellspacing="0" cellpadding="5">

<tr>
<td align="left">
<!--  -->
<span id="parrafo">Estimado(a) : <strong>'.$nom_alum.'</strong> &nbsp; &nbsp; </td>
</tr>
</table>
<!-- -->
<p id="parrafo">Tu Sicólogo(a) <strong>'.$nom_sico.'</strong> ha agendado una hora,</p>
<p id="parrafo">para el día <strong>'.$dia_hora.'</strong> <strong>'.$fecha_hora.'</strong> en el bloque de <strong>'.$bloque_hora.'</strong></p>
<p id="parrafo" align="left">Recuerda mantener tu datos de contacto actualizados, para que puedan contactarse contigo en caso de ser necesario. </p>
<p id="pie" align="left">Atte. <br>
Departamento de Sicólogia</p>
<br>
<p id="aviso" align="left">No respondas a este correo, este mensaje ha sido generado automaticamente, <br> si necesitas contactarte con tu sicólogo hazlo en el Pacífico Online o desde la página Web de la Universidad. </p>
</td>
</tr>
</table>
</body>
</html>';
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: Departamento De Sicologia<sistemas@upacifico.cl>'. "\r\n";
$cabeceras .= 'Bcc: mriffo@upacifico.cl' . "\r\n";
$resultado = mail($mail,"Han agendado un hora para ti", $mensaje, $cabeceras);
//
if ($resultado) {
	echo 'true';
} else {
	echo 'false';
}
//
?>