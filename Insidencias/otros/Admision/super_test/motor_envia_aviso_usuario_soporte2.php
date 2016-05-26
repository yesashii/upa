<?php 
error_reporting(0);
$nom = $_GET['nom_usuario'];
$codigo_solicitud=$_GET['codigo_solicitud'];
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
<table width="500" height="700" border="0" align="center" cellpadding="0" cellspacing="0"   id="Tabla_01">
<tr>
<td width="439" height="410" align="center" valign="top">
<!-- contenido -->
<!-- -->
<table width="100%" border="0" cellspacing="0" cellpadding="5">

<tr>
<td align="left">
<!--  -->
<span id="parrafo">Estimado(a) : <strong>'.$nom.'</strong> &nbsp; &nbsp; </td>
</tr>
</table>
<!-- -->
<p id="parrafo">Su Solicitud ha sido recibida por nuestro sistema, un t&eacute;cnico se contactara con usted,su codigo de solicitud es <strong>'.$codigo_solicitud.'</strong></p>
<p id="pie" align="left">Atte. <br>
Departamento De Desarrollo y Tecnologia</p>
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
$cabeceras .= 'From: Departamento De Desarrollo y Tecnologia<sistemas@upacifico.cl>'. "\r\n";
$cabeceras .= 'Bcc: jduran@upacifico.cl' . "\r\n";
$resultado = mail($mail,"Solicitud de Soporte NO RESPONDER", $mensaje, $cabeceras);
//
header("Location: http://fangorn.upacifico.cl/sigaupa/DESARROLLO_TECNOLOGIA/solicita_soporte.asp");
//
?>
