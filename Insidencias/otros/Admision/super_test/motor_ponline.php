<?php 
error_reporting(0);
$nombre = $_GET['nombre_p'];
$mail = $_GET['email_p'];
$usuario = $_GET['usuario'];
$clave = $_GET['clave'];
/********************************************************************************/
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
	color: #093189;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 15px;
	text-align:justify;
}
#pie {
	color: #e41712;
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
font-size: 12px;
color: #2f7d89;
font-weight: normal;
margin-left:20px;
}
-->
</style></head>
<body topmargin="0" bgcolor="#CCCCCC">
<table width="500" height="700" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC" background="http://www.upacifico.cl/mail_postulacion2009/imagenes/fondo_ponline.jpg" id="Tabla_01">
<tr>
<td colspan="3" width="500" height="91">&nbsp;
</td>
</tr>
<tr>
<td rowspan="4" width="30" height="609">&nbsp;
</td>
<td width="439" height="59" align="center" valign="middle">
<!-- inicio titulo -->
<span id="titulo"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif" size="5">Administraci&oacute;n de Acceso<br>Sistemas Inform&aacute;ticos</font></span>
<!-- fin titulo -->
</td>
<td rowspan="4" width="31" height="609">&nbsp;
</td>
</tr>
<tr>
<td width="439" height="40">&nbsp;
</td>
</tr>
<tr>
<td width="439" height="410" align="center" valign="top">
<!-- contenido -->
<br/>
<p id="parrafo">Estimado '.$nombre.':<br>Los siguientes datos corresponden a tu perfil de acceso a los sistemas inform&aacute;ticos de la Universidad, con ellos podr&aacute;s ingresar a Pac&iacute;fico Online, Aula Virtual y a tu cuenta de correo electr&oacute;nico.</p>
<!-- -->
<table width="100%" border="0" cellspacing="0" cellpadding="5">
    <tr>
        <td align="center">&nbsp;</td>
    </tr>
	<tr>
		<td align="center">&nbsp;</td>
	</tr>
</table>
<!-- -->
<!-- -->
<p id="parrafo"><br><br><br></p>
<!--  -->
<span class="Titulo">&nbsp;</span><br/>
<span class="Titulo">&nbsp;</span><br/>
<span class="Titulo">Datos de Acceso</span><br/>
<span class="Detalle">Login: <b>'.$usuario.'</b></span><br/>
<span class="Detalle">Clave: <b>'.$clave.'</b></span> 
<!--  -->
<p id="pie"><br><br>Universidad del Pacífico - siempre innovando</p>
</td>
</tr>
<tr>
<td width="439" height="100">&nbsp;
</td>
</tr>
</table>
</body>
</html>';
//echo "$mensaje";
//exit;
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: Departamento de Informática <administrador@upacifico.cl>' . "\r\n";
$cabeceras .= 'Bcc: mshaw@upacifico.cl' . "\r\n";
//
$resultado = mail($mail,"Administración de accesos", $mensaje, $cabeceras);
//
if ($resultado) {
	echo 'true';
} else {
	echo 'false';
}
//
?>