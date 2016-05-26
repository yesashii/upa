<?php 
error_reporting(0);
$nom_post = $_GET['nom_post'];
$univ=$_GET['univ'];
$ciex_tdesc=$_GET['ciex'];
$pais_tdesc=$_GET['pais_tdesc'];
$lohecho=$_GET['lohecho'];
$mail = $_GET['correo'];
$peri_tdesc= $_GET['peri'];
$carrera= $_GET['carr'];
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
<body topmargin="0" >



<table width="700" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	    <td width="3%" align="left">&nbsp;</td>
	  	<td colspan="3" height="59" align="center"><span id="titulo"><font color="#0066FF" face="Verdana, Arial, Helvetica, sans-serif" size="5">MENSAJE POSTULACION EXTRANJERO</font></span><br><font color="#000000" size="1"></font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo">La postulacion de  <strong>'.$nom_post.'</strong> </p>
		<p id="parrafo">de la universidad <strong>'.$univ.'</strong> </p>
		<p id="parrafo">en la ciudad de <strong>'.$ciex_tdesc.'</strong>  en <strong>'.$pais_tdesc.'</strong> </p>
		<p id="parrafo">a la carrera <strong>'.$carrera.'</strong> </p>
		<p id="parrafo">para el <strong>'.$peri_tdesc.'</strong> </p>
		<p id="parrafo">ha sido <strong>'.$lohecho.'</strong></p></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>   
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
  	  <tr valign="middle">
		<td width="3%" align="left">&nbsp;</td>
	  	<td colspan="3"><p id="parrafo">Saludos!</td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
  	  <tr>
	  	<td colspan="5" align="center"><font size="-1">Email informativo - Favor no contestar al remitente</font></td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
</table>
</body>
</html>
';
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: NO RESPONDER Aviso de Postulacion <sistemas@upacifico.cl>'. "\r\n";
$cabeceras .= 'Bcc: mshaw@upacifico.cl' . "\r\n";
$resultado = mail($mail,"Postulacion", $mensaje, $cabeceras);
//
if ($resultado) {
	echo 'true';
} else {
	echo 'false';
}
//
?>