
<?php 
error_reporting(0);
$nom_post=$_GET['nom_post'];
$rut_post=$_GET['rut_post'];
$pote_ncorr=$_GET['pote_ncorr'];
$programa=$_GET['programa'];
$f_pago=$_GET['fpot_tdesc'];
$mail = $_GET['mail'];
/********************************************************************************/
//$mail='jduran@upacifico.cl';
$mensaje ='
<html>
<head>
<title>Universidad del Pac&iacute;fico</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
	background-repeat: repeat;
	background-color: #ffffff;	
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
<table width="750" height="700" border="0" align="center" cellpadding="0" cellspacing="0"   id="Tabla_01">

<tr>
<td width="439" height="410" align="center" valign="top">
<!-- contenido -->
<!-- -->
<table width="100%" border="0" cellspacing="0" cellpadding="5">

<tr>
<td align="left">
<!--  -->
<span id="parrafo">Estimado(a) : <strong>Don Guillermo:</strong> &nbsp; &nbsp; </td>
</tr>
</table>
<!-- -->
<p id="parrafo">El Sr(a) '.$nom_post.' ha postulado al programa <strong>'.$programa.'</strong> con la forma de pago <strong>'.$f_pago.'</strong>.</p>

<br>
<p id="aviso" align="left">No responda a este correo, este mensaje ha sido generado automaticamente.</p>
</td>
</tr>
</table>
</body>
</html>';
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From:sistemas@upacifico.cl'. "\r\n";
$cabeceras .= 'Bcc: jduran@upacifico.cl' . "\r\n";
$resultado = mail($mail,"Postulacion a Programa", $mensaje, $cabeceras);
//
if ($resultado) {
	echo 'true';
} else {
	echo 'false';
}


//
?>