<?php 
error_reporting(0);
$nom_resp = $_GET['nom_resp'];
$mail = $_GET['correo_resp'];
$nom_proy = $_GET['nom_proy'];
$ensa_ncorr = $_GET['ensa_ncorr'];
/********************************************************************************/
$mail=$mail.'@upacifico.cl';
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
#msj {
	color: #000000;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
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
<!-- Aquí va el tercer agente de postulación -->
<span id="parrafo">Estimado(a) Sr(a): <strong>'.$nom_resp.'</strong> &nbsp; &nbsp; </td>
</tr>
</table>
<!-- -->
<p id="parrafo">Junto con saludar, queremos solicitarle a usted responda una encuesta, el objetivo de esta petición es conocer el grado de satisfacción luego del desarrollo de  <strong>'.$nom_proy.'</strong>, hecho por nuestro departamento.</p>
<!-- -->
<p id="parrafo">El link para responder esta encuesta es el siguiente:</p>
<!--  -->
<a href="http://admision.upacifico.cl/encuesta_satisfaccion/www/encuesta.php?ensa_ncorr='.$ensa_ncorr.'&user=1"><p id="link">Encuesta</p></a><br/>
<!--  -->
<p id="pie" align="left">Atte. <br> Departamento de Inform&aacute;tica. </p>

<p id="msj" align="left"><br>
No responda a este correo, este mensaje ha sido generado automaticamente. </p>
</td>
</tr>
</table>
</body>
</html>';
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: Departamento De Informática <informatica@upacifico.cl>'. "\r\n";
//$cabeceras .= 'Bcc: jduran@upacifico.cl' . "\r\n";
$resultado = mail($mail,"Encuesta de Satisfacción", $mensaje, $cabeceras);
//
if ($resultado) {
	echo 'true';
} else {
	echo 'false';
}
//
?>