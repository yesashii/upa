<?php 
error_reporting(0);
$nombre = $_GET['nombre_p'];
$mail = $_GET['email_p'];
$cod_carrera = $_GET['carrera'];
$usuario = $_GET['usuario'];
$clave = $_GET['clave'];
$cod_sede1 = $_GET['cod_sede'];
$cod_agente_sede1 = $_GET['cod_agente_sede'];
/********************************************************************************/
switch ($cod_carrera) {
    case 14:
        $carrera = "Direcci�n y Producci�n de Eventos";
        break;
    case 16:
        $carrera = "Dise�o de Interiores y Exteriores";
        break;
    case 21:
        $carrera = "Dise�o Gr�fico";
        break;
    case 23:
        $carrera = "Dise�o de Vestuario y Textiles";
        break;
    case 32:
        $carrera = "Fotograf�a";
        break;	
    case 41:
        $carrera = "Periodismo";
        break;					
    case 43:
        $carrera = "Psicolog�a (Visi�n Humanista Transpersonal)";
        break;
    case 45:
        $carrera = "Publicidad";
        break;
    case 47:
        $carrera = "Relaciones P�blicas";
        break;		
    case 49:
        $carrera = "Trabajo Social";
        break;		
    case 51:
        $carrera = "Ingenier�a Comercial";
        break;	
    case 800:
        $carrera = "Comunicaci�n Digital y Multimedia";
        break;	
    case 830:
        $carrera = "Agronom�a";
        break;	
    case 840:
        $carrera = "Enfermer�a";
        break;			
    case 850:
        $carrera = "Medicina Veterinaria";
        break;	
    case 860:
        $carrera = "Pedagog�a en Educaci�n F�sica";
        break;	
    case 870:
        $carrera = "Pedagog�a en Educaci�n Parvularia";
        break;	
    case 880:
        $carrera = "Pedagog�a en Educaci�n General B�sica";
        break;	
    case 940:
        $carrera = "Pedagog�a en Educaci�n Media en Lenguaje y Comunicaci�n";
        break;
    case 950:
        $carrera = "Pedagog�a en Educaci�n Media en Historia y Ciencias Sociales";
        break;
    case 970:
        $carrera = "M�sica y Tecnolog�a en Sonido";
        break;	
    case 99:
        $carrera = "Contador P�blico y Auditor";
        break;																									
	default:
        $carrera = "";
        break;			
}
/********************************************************************************/
if ($cod_sede1 == 1 and $cod_agente_sede1 == 1) {
	$nombre_agente1 = "Mar�a Jose Vargas";
	$descripcion_agente1 = "Carreras Sede Las Condes";
	$correo1 = "mjvargas@upacifico.cl";
	$telefono1 = "+56 (2) 8625250";
}
if ($cod_sede1 == 1 and $cod_agente_sede1 == 2) {
	$nombre_agente1 = "Lucila Persico";
	$descripcion_agente1 = "Carreras Sede Las Condes";
	$correo1 = "lpersico@upacifico.cl";
	$telefono1 = "+56 (2) 8625252";
}
if ($cod_sede1 == 1 and $cod_agente_sede1 == 3) {
	$nombre_agente1 = "Magdalena Cuevas";
	$descripcion_agente1 = "Carreras Sede Las Condes";
	$correo1 = "mcuevas@upacifico.cl";
	$telefono1 = "+56 (2) 8625391";
}
if ($cod_sede1 == 1 and $cod_agente_sede1 == 4) {
	$nombre_agente1 = "Juan Pablo Montt";
	$descripcion_agente1 = "Carreras Sede Las Condes";
	$correo1 = "jmontt@upacifico.cl";
	$telefono1 = "+56 (2) 8625251";
}
if ($cod_sede1 == 1 and $cod_agente_sede1 == 5) {
	$nombre_agente1 = "Jorge Espinoza";
	$descripcion_agente1 = "Carreras Sede Las Condes";
	$correo1 = "jespinoza@upacifico.cl";
	$telefono1 = "+56 (2) 8625279";
}
if ($cod_sede1 == 2 and $cod_agente_sede1 == 1) {
	$nombre_agente1 = "Mar�a Teresa Aranda";
	$descripcion_agente1 = "Carreras Campus Lyon";
	$correo1 = "infolyon@upacifico.cl";
	$telefono1 = "+56 (2) 3306400";
}
if ($cod_sede1 == 4 and $cod_agente_sede1 == 1) {
	$nombre_agente1 = "Mar�a Francisca Allendes";
	$descripcion_agente1 = "Carreras Sede Melipilla";
	$correo1 = "fallendes@upacifico.cl";
	$telefono1 = "+56 (2) 3524900";
}
if ($cod_sede1 == 8 and $cod_agente_sede1 == 1) {
	$nombre_agente1 = "Mar�a Cristina Torres";
	$descripcion_agente1 = "Carreras Campus Baquedano";
	$correo1 = "admision.baquedano@upacifico.cl";
	$telefono1 = "+56 (2) 3526900";
}

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
<span id="titulo"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif" size="5">BIENVENIDO(A)</font></span>
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
<p id="parrafo">'.$nombre.', felicitaciones quedaste aceptado(a) en la carrera de <strong>'.$carrera.',</strong> el siguente paso es completar los datos solicitados en la ficha de matricula.</p>
<!-- -->
<table width="100%" border="0" cellspacing="0" cellpadding="5">
  <tr>
    <td align="center"><a href="http://www.upacifico.cl/super_test/ficha_matricula.php" target="_blank">COMPLETAR LA FICHA DE MATRICULA AQU�</a></td>
</tr>
<tr>
<td align="center">
<!-- Aqu� va el tercer agente de postulaci�n -->
<span id="parrafo">usuario: <strong>'.$usuario.'</strong> &nbsp; &nbsp; clave: <strong>'.$clave.'</strong></span></td>
</tr>
</table>
<!-- -->
<p id="parrafo">Una vez completada esta ficha, puedes acercarte a cualquiera de nuestras sedes o campus y concretar t� matr�cula.</p>
<!-- -->
<p id="parrafo">Para informaci�n sobre horarios de atenci�n, ubicaci�n de sedes y campus o cualquier consulta contactar a:</p>
<!--  -->
<span class="Titulo">'.$nombre_agente1.'</span><br/>
<span class="Detalle"><a href="mailto:'.$correo1.'?cc=admision@upacifico.cl&subject=Consulta de Admisi�n 2010&body=Hola mi consulta es la siguiente:%0D%0A %0D%0A">'.$correo1.'</a></span><br/>
<span class="Detalle">'.$telefono1.'</span> 
<!--  -->
<p id="pie">Universidad del Pac�fico - siempre innovando</p>
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
$cabeceras .= 'From: Admisi�n 2010 Universidad del Pac�fico <admision@upacifico.cl>' . "\r\n";
$cabeceras .= 'Bcc: pgarbarino@upacifico.cl, idelajara@upacifico.cl' . "\r\n";
$resultado = mail($mail,"Bienvenido a la Carrera de ".$carrera, $mensaje, $cabeceras);
//
if ($resultado) {
	echo 'true';
} else {
	echo 'false';
}
//
?>