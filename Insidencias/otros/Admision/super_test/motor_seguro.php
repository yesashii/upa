<?php
error_reporting(0);

$seguridad = $_GET['v'];

$clave = $cod_sede1 + $cod_agente_sede1 + $cod_sede2 + $cod_agente_sede2 + $cod_sede3 + $cod_agente_sede3 + $cod_sede4 + $cod_agente_sede4;

$nombre = $_GET['nombre_p'];
$rut = $_GET['rut_p'];
$mail = $_GET['email_p'];

$cod_sede1 = $_GET['cod_sede1'];
$cod_agente_sede1 = $_GET['cod_agente_sede1'];

$cod_sede2 = $_GET['cod_sede2'];
$cod_agente_sede2 = $_GET['cod_agente_sede2'];

$cod_sede3 = $_GET['cod_sede3'];
$cod_agente_sede3 = $_GET['cod_agente_sede3'];

$cod_sede4 = $_GET['cod_sede4'];
$cod_agente_sede4 = $_GET['cod_agente_sede4'];

/********************************************************************************/
if ($cod_sede1 == 1 and $cod_agente_sede1 == 1) {
	$nombre_agente1 = "María Jose Vargas";
	$descripcion_agente1 = "Carreras Sede Las Condes";
	$correo1 = "mjvargas@upacifico.cl";
	$telefono1 = "+56 (2) 8625250";
}
if ($cod_sede1 == 1 and $cod_agente_sede1 == 2) {
	$nombre_agente1 = "María Magdalena Cuevas";
	$descripcion_agente1 = "Carreras Sede Las Condes";
	$correo1 = "mcuevas@upacifico.cl";
	$telefono1 = "+56 (2) 3665250";
}
if ($cod_sede1 == 1 and $cod_agente_sede1 == 3) {
	$nombre_agente1 = "Juan Pablo Montt";
	$descripcion_agente1 = "Carreras Sede Las Condes";
	$correo1 = "jmontt@upacifico.cl";
	$telefono1 = "+56 (2) 3665251";
}
if ($cod_sede1 == 1 and $cod_agente_sede1 == 4) {
	$nombre_agente1 = "Jorge Espinoza";
	$descripcion_agente1 = "Carreras Sede Las Condes";
	$correo1 = "jespinoza@upacifico.cl";
	$telefono1 = "+56 (2) 3665279";
}
if ($cod_sede1 == 2 and $cod_agente_sede1 == 1) {
	$nombre_agente1 = "María Jose Vargas";
	$descripcion_agente1 = "Carreras Campus Lyon";
	$correo1 = "mjvargas@upacifico.cl";
	$telefono1 = "+56 (2) 8625250";
}
if ($cod_sede1 == 4 and $cod_agente_sede1 == 1) {
	$nombre_agente1 = "María Francisca Allendes";
	$descripcion_agente1 = "Carreras Sede Melipilla";
	$correo1 = "fallendes@upacifico.cl";
	$telefono1 = "+56 (2) 3524900";
}
if ($cod_sede1 == 8 and $cod_agente_sede1 == 1) {
	$nombre_agente1 = "María Jose Vargas";
	$descripcion_agente1 = "Carreras Campus Baquedano";
	$correo1 = "mjvargas@upacifico.cl";
	$telefono1 = "+56 (2) 8625250";
}
if ($cod_sede1 == 8 and $cod_agente_sede1 == 2) {
	$nombre_agente1 = "Claudia Brito Reyes";
	$descripcion_agente1 = "Carreras Campus Baquedano";
	$correo1 = "cbrito@upacifico.cl";
	$telefono1 = "+56 (2) 3526930";
}
/********************************************************************************/
if ($cod_sede2 == 1 and $cod_agente_sede2 == 1) {
	$nombre_agente2 = "María Jose Vargas";
	$descripcion_agente2 = "Carreras Sede Las Condes";
	$correo2 = "mjvargas@upacifico.cl";
	$telefono2 = "+56 (2) 8625250";
}
if ($cod_sede2 == 1 and $cod_agente_sede2 == 2) {
	$nombre_agente2 = "María Magdalena Cuevas";
	$descripcion_agente2 = "Carreras Sede Las Condes";
	$correo2 = "mcuevas@upacifico.cl";
	$telefono2 = "+56 (2) 3665250";
}
if ($cod_sede2 == 1 and $cod_agente_sede2 == 3) {
	$nombre_agente2 = "Juan Pablo Montt";
	$descripcion_agente2 = "Carreras Sede Las Condes";
	$correo2 = "jmontt@upacifico.cl";
	$telefono2 = "+56 (2) 3665251";
}
if ($cod_sede2 == 1 and $cod_agente_sede2 == 4) {
	$nombre_agente2 = "Jorge Espinoza";
	$descripcion_agente2 = "Carreras Sede Las Condes";
	$correo2 = "jespinoza@upacifico.cl";
	$telefono2 = "+56 (2) 3665279";
}
if ($cod_sede2 == 2 and $cod_agente_sede2 == 1) {
	$nombre_agente2 = "María Jose Vargas";
	$descripcion_agente2 = "Carreras Campus Lyon";
	$correo2 = "mjvargas@upacifico.cl";
	$telefono2 = "+56 (2) 8625250";
}
if ($cod_sede2 == 4 and $cod_agente_sede2 == 1) {
	$nombre_agente2 = "María Francisca Allendes";
	$descripcion_agente2 = "Carreras Sede Melipilla";
	$correo2 = "fallendes@upacifico.cl";
	$telefono2 = "+56 (2) 3524900";
}
if ($cod_sede2 == 8 and $cod_agente_sede2 == 1) {
	$nombre_agente2 = "María Jose Vargas";
	$descripcion_agente2 = "Carreras Campus Baquedano";
	$correo2 = "mjvargas@upacifico.cl";
	$telefono2 = "+56 (2) 8625250";
}
if ($cod_sede2 == 8 and $cod_agente_sede2 == 2) {
	$nombre_agente2 = "Claudia Brito Reyes";
	$descripcion_agente2 = "Carreras Campus Baquedano";
	$correo2 = "cbrito@upacifico.cl";
	$telefono2 = "+56 (2) 3526930";
}
/********************************************************************************/
if ($cod_sede3 == 1 and $cod_agente_sede3 == 1) {
	$nombre_agente3 = "María Jose Vargas";
	$descripcion_agente3 = "Carreras Sede Las Condes";
	$correo3 = "mjvargas@upacifico.cl";
	$telefono3 = "+56 (2) 8625250";
}
if ($cod_sede3 == 1 and $cod_agente_sede3 == 2) {
	$nombre_agente3 = "María Magdalena Cuevas";
	$descripcion_agente3 = "Carreras Sede Las Condes";
	$correo3 = "mcuevas@upacifico.cl";
	$telefono3 = "+56 (2) 3665250";
}
if ($cod_sede3 == 1 and $cod_agente_sede3 == 3) {
	$nombre_agente3 = "Juan Pablo Montt";
	$descripcion_agente3 = "Carreras Sede Las Condes";
	$correo3 = "jmontt@upacifico.cl";
	$telefono3 = "+56 (2) 3665251";
}
if ($cod_sede3 == 1 and $cod_agente_sede3 == 4) {
	$nombre_agente3 = "Jorge Espinoza";
	$descripcion_agente3 = "Carreras Sede Las Condes";
	$correo3 = "jespinoza@upacifico.cl";
	$telefono3 = "+56 (2) 3665279";
}
if ($cod_sede3 == 2 and $cod_agente_sede3 == 1) {
	$nombre_agente3 = "María Jose Vargas";
	$descripcion_agente3 = "Carreras Campus Lyon";
	$correo3 = "mjvargas@upacifico.cl";
	$telefono3 = "+56 (2) 8625250";
}
if ($cod_sede3 == 4 and $cod_agente_sede3 == 1) {
	$nombre_agente3 = "María Francisca Allendes";
	$descripcion_agente3 = "Carreras Sede Melipilla";
	$correo3 = "fallendes@upacifico.cl";
	$telefono3 = "+56 (2) 3524900";
}
if ($cod_sede3 == 8 and $cod_agente_sede3 == 1) {
	$nombre_agente3 = "María Jose Vargas";
	$descripcion_agente3 = "Carreras Campus Baquedano";
	$correo3 = "mjvargas@upacifico.cl";
	$telefono3 = "+56 (2) 8625250";
}
if ($cod_sede3 == 8 and $cod_agente_sede3 == 2) {
	$nombre_agente3 = "Claudia Brito Reyes";
	$descripcion_agente3 = "Carreras Campus Baquedano";
	$correo3 = "cbrito@upacifico.cl";
	$telefono3 = "+56 (2) 3526930";
}
/********************************************************************************/
if ($cod_sede4 == 1 and $cod_agente_sede4 == 1) {
	$nombre_agente4 = "María Jose Vargas";
	$descripcion_agente4 = "Carreras Sede Las Condes";
	$correo4 = "mjvargas@upacifico.cl";
	$telefono4 = "+56 (2) 8625250";
}
if ($cod_sede4 == 1 and $cod_agente_sede4 == 2) {
	$nombre_agente4 = "María Magdalena Cuevas";
	$descripcion_agente4 = "Carreras Sede Las Condes";
	$correo4 = "mcuevas@upacifico.cl";
	$telefono4 = "+56 (2) 3665250";
}
if ($cod_sede4 == 1 and $cod_agente_sede4 == 3) {
	$nombre_agente4 = "Juan Pablo Montt";
	$descripcion_agente4 = "Carreras Sede Las Condes";
	$correo4 = "jmontt@upacifico.cl";
	$telefono4 = "+56 (2) 3665251";
}
if ($cod_sede4 == 1 and $cod_agente_sede4 == 4) {
	$nombre_agente4 = "Jorge Espinoza";
	$descripcion_agente4 = "Carreras Sede Las Condes";
	$correo4 = "jespinoza@upacifico.cl";
	$telefono4 = "+56 (2) 3665279";
}
if ($cod_sede4 == 2 and $cod_agente_sede4 == 1) {
	$nombre_agente4 = "María Jose Vargas";
	$descripcion_agente4 = "Carreras Campus Lyon";
	$correo4 = "mjvargas@upacifico.cl";
	$telefono4 = "+56 (2) 8625250";
}
if ($cod_sede4 == 4 and $cod_agente_sede4 == 1) {
	$nombre_agente4 = "María Francisca Allendes";
	$descripcion_agente4 = "Carreras Sede Melipilla";
	$correo4 = "fallendes@upacifico.cl";
	$telefono4 = "+56 (2) 3524900";
}
if ($cod_sede4 == 8 and $cod_agente_sede4 == 1) {
	$nombre_agente4 = "María Jose Vargas";
	$descripcion_agente4 = "Carreras Campus Baquedano";
	$correo4 = "mjvargas@upacifico.cl";
	$telefono4 = "+56 (2) 8625250";
}
if ($cod_sede4 == 8 and $cod_agente_sede4 == 2) {
	$nombre_agente4 = "Claudia Brito Reyes";
	$descripcion_agente4 = "Carreras Campus Baquedano";
	$correo4 = "cbrito@upacifico.cl";
	$telefono4 = "+56 (2) 3526930";
}
$mensaje = '
<html>
<head>
<title>Universidad del Pacífico</title>
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
	font-size: 16px;
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
<body topmargin="0" bgcolor="#CCCCCC">
<table width="500" height="700" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC" background="http://www.upacifico.cl/mail_postulacion2009/imagenes/mail_todo.gif" id="Tabla_01">
<tr>
<td colspan="3" width="500" height="91">&nbsp;
</td>
</tr>
<tr>
<td rowspan="4" width="30" height="609">&nbsp;
</td>
<td width="439" height="59" align="center" valign="middle">
<!-- inicio titulo -->
<span id="titulo"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif" size="5">Comprobante de Postulación</font></span>
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
<p id="parrafo">'.$nombre.', tu postulaci&oacute;n On-Line ya fue realizada, pronto ser&aacute;s contactado(a) por:</p>
<!-- -->
<table width="100%" border="0" cellspacing="0" cellpadding="5">
  <tr>
    <td>
<!-- Aquí va el primer agente de postulación -->    
<span class="Detalle">'.$descripcion_agente1.'</span><br/>
<span class="Titulo">'.$nombre_agente1.'</span><br/>
<span class="Detalle"><a href="mailto:'.$correo1.'?cc=admision@upacifico.cl&subject=Consulta de Admisión 2010&body=Hola mi consulta es la siguiente:%0D%0A %0D%0A">'.$correo1.'</a></span><br/>
<span class="Detalle">'.$telefono1.'</span>    
    </td>
    <td>
<!-- Aquí va el segundo agente de postulación -->
<span class="Detalle">'.$descripcion_agente2.'</span><br/>
<span class="Titulo">'.$nombre_agente2.'</span><br/>
<span class="Detalle"><a href="mailto:'.$correo2.'?cc=admision@upacifico.cl&subject=Consulta de Admisión 2010&body=Hola mi consulta es la siguiente:%0D%0A %0D%0A">'.$correo2.'</a></span><br/>
<span class="Detalle">'.$telefono2.'</span>    
    </td>
  </tr>
  <tr>
    <td>
<!-- Aquí va el tercer agente de postulación -->
<span class="Detalle">'.$descripcion_agente3.'</span><br/>
<span class="Titulo">'.$nombre_agente3.'</span><br/>
<span class="Detalle"><a href="mailto:'.$correo3.'?cc=admision@upacifico.cl&subject=Consulta de Admisión 2010&body=Hola mi consulta es la siguiente:%0D%0A %0D%0A">'.$correo3.'</a></span><br/>
<span class="Detalle">'.$telefono3.'</span>    
    </td>
    <td>
<!-- Aquí va el cuarto agente de postulación -->
<span class="Detalle">'.$descripcion_agente4.'</span><br/>
<span class="Titulo">'.$nombre_agente4.'</span><br/>
<span class="Detalle"><a href="mailto:'.$correo4.'?cc=admision@upacifico.cl&subject=Consulta de Admisión 2010&body=Hola mi consulta es la siguiente:%0D%0A %0D%0A">'.$correo4.'</a></span><br/>
<span class="Detalle">'.$telefono4.'</span>    
    </td>
  </tr>
</table>
<!-- -->
<p id="parrafo">Para realizar modificaciones a tu postulaci&oacute;n solo debes ingresar con tu Rut. ('.$rut.')</p>
<!-- -->
<p id="parrafo">La información que nos entregaste es de car&aacute;cter confidencial y nos permitir&aacute; mantenerte informado sobre el estado de tu postulación y de las actividades de la universidad.</p>
<!-- contenido -->
<p id="pie">Universidad del Pacífico - siempre innovando</p>
</td>
</tr>
<tr>
<td width="439" height="100">&nbsp;
</td>
</tr>
</table>
</body>
</html>';
	//
	$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
	$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
	//
	$cabeceras .= 'From: Admisión 2010 Universidad del Pacífico <admision@upacifico.cl>' . "\r\n";
	$cabeceras .= 'Bcc: pgarbarino@upacifico.cl, idelajara@upacifico.cl' . "\r\n";
	//
	if ($seguridad == $clave and $seguridad<>0) {
		$resultado = mail($mail,"Información sobre tu Postulación",$mensaje, $cabeceras);
	}
	//
	if ($resultado) {
		echo 'true';
	} else {
		echo 'false';
	}	
	//
?>