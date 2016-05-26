<?php 
error_reporting(0);
$rut = $_GET['pers_nrut'];
$dv=$_GET['pers_xdv'];
$mail = $_GET['PERS_TEMAIL'];
$clave = $_GET['obtieneclave'];
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
<body topmargin="0">
<table width="500" height="700" border="0" align="center" cellpadding="0" cellspacing="0"   id="Tabla_01">
<tr>
<td width="439" height="410" align="center" valign="top">
<!-- contenido -->
<!-- -->
<table width="100%" border="0" cellspacing="0" cellpadding="5">

<tr>
<td align="left">
<!--  -->
<span id="parrafo">Señor(a) Apoderado ,&nbsp; &nbsp; </td>
</tr>
</table>
<!-- -->
<p id="parrafo">El sistema automatizado de Universidad del Pac&iacute;fico, le envia una contrase&ntilde;a para ingresar al portal apoderado.</p>
<p id="parrafo">Primero hay que ingresar a la pagina web de universidad en la siguiente Direcci&oacute;n:</p>
<p p id="parrafo">http://fangorn.upacifico.cl/sigaupa/portada_apoderado/portada_apoderado.asp</p>
<p p id="parrafo"><strong>Ingresar los respectivos datos:</strong></p>
<p p id="parrafo">Usuario:  '.$rut.'-'.$dv.' (Su RUT)</p>
<p p id="parrafo">Clave: '.$clave.' (Contrase&ntilde;a)</p>
<p><strong></strong></p>
<br>
<p id="aviso" align="left">No respondas a este correo, este mensaje ha sido generado automaticamente. </p>
</td>
</tr>
</table>
</body>
</html>';
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: Envío de Contraseñas <sistemas@upacifico.cl>'. "\r\n";
$cabeceras .= 'Bcc: sdasilva@upacifico.cl' . "\r\n";
$resultado = mail($mail,"Envio automático de Contraseña - NO RESPONDER", $mensaje, $cabeceras);
//
if ($resultado) {
	//echo '<p>SI</p>';
} else {
	//echo '<p>NO</p>';
}

//

header ("Refresh: 1; URL=http://http://172.16.11.132/sigaupa_desa/portada_apoderado/creando_apoderado.asp");
?>