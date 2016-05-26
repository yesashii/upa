<?php 
error_reporting(0);
$rut = $_GET['rut'];
$fono = $_GET['fono'];
$celular = $_GET['celular'];
$email = $_GET['email'];
$nombre = $_GET['nombre'];
$sede = $_GET['sede'];
$carrera = $_GET['carrera'];
$cert1 = $_GET['cert1'];
$valor1 = $_GET['valor1'];
$cert2 = $_GET['cert2'];
$valor2 = $_GET['valor2'];
$cert3 = $_GET['cert3'];
$valor3 = $_GET['valor3'];
$cert4 = $_GET['cert4'];
$valor4 = $_GET['valor4'];
$cert5 = $_GET['cert5'];
$valor5 = $_GET['valor5'];
$fecha = date("d/m/Y H:i:s");
$cod = $_GET['cod'];

$pedazo_consulta1 = "";
$pedazo_consulta2 = "";
$pedazo_consulta3 = "";
$pedazo_consulta4 = "";
$pedazo_consulta5 = "";


if($cert1=="1")
{
	$pedazo_consulta1 = '<tr>
							<td width="80%" align="left" bgcolor="#FFFFFF">Certificado de Alumno Egresado</td>
							<td width="20%" align="left" bgcolor="#FFFFFF">$ '.$valor1.'</td>
						</tr>';
}

if($cert2=="1")
{
	$pedazo_consulta2 = '<tr>
							<td width="80%" align="left" bgcolor="#FFFFFF">Certificado de Título</td>
							<td width="20%" align="left" bgcolor="#FFFFFF">$ '.$valor2.'</td>
						</tr>';
}

if($cert3=="1")
{
	$pedazo_consulta3 = '<tr>
							<td width="80%" align="left" bgcolor="#FFFFFF">Certificado de Concentración de Notas</td>
							<td width="20%" align="left" bgcolor="#FFFFFF">$ '.$valor3.'</td>
						</tr>';
}

if($cert4=="1")
{
	$pedazo_consulta4 = '<tr>
							<td width="80%" align="left" bgcolor="#FFFFFF">Copia de Diploma</td>
							<td width="20%" align="left" bgcolor="#FFFFFF">$ '.$valor4.'</td>
						</tr>';
}

if($cert5=="1")
{
	$pedazo_consulta5 = '<tr>
							<td width="80%" align="left" bgcolor="#FFFFFF">Programa de cada asignatura</td>
							<td width="20%" align="left" bgcolor="#FFFFFF">$ '.$valor5.'</td>
						</tr>';
}

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
<body bgcolor="#FFFFFF">
<table width="600" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	    <td width="3%" align="left">&nbsp;</td>
	  	<td colspan="3" height="59" align="center"><span id="titulo"><font color="#0066FF" face="Verdana, Arial, Helvetica, sans-serif" size="5">SOLICITUD DE CERTIFICADOS</font></span><br><font color="#000000" size="1">'.$fecha.'</font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo">Srs. Títulos y Grados<br>Se ha recepcionado una solicitud de certificados vía online por parte del siguiente alumno(a):</p></td>
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
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Nombre</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$nombre.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Teléfono</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$fono.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Celular</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$celular.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Email</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$email.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Sede</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$sede.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Carrera</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$carrera.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5"><hr></td>
	  </tr>
	  <tr>
	  	<td colspan="5">Certificados solicitados.....</td>
	  </tr>
	  	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">
			<table width="90%" align="center" cellpadding="0" cellspacing="0" border="1" bordercolor="#FF9900">
				<tr>
					<td width="80%" align="center" bgcolor="#FF9900"><strong>Certificado</strong></td>
					<td width="20%" align="center" bgcolor="#FF9900"><strong>Costo</strong></td>
				</tr>
				'.$pedazo_consulta1.''.$pedazo_consulta2.''.$pedazo_consulta3.''.$pedazo_consulta4.''.$pedazo_consulta5.'
			</table> 
		</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5" align="right"><font size="1">NSC.:'.$cod.'</font></td>
	  </tr>
</table>
</body>
</html>';

//echo $mensaje;
//exit;
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: administrador@upacifico.cl' . "\r\n";
$cabeceras .= 'Bcc: mshaw@upacifico.cl' . "\r\n";
$resultado = mail("titulosygrados@upacifico.cl","Solicitud certificados ".$nombre, $mensaje, $cabeceras);
//
if ($resultado) {
	echo 'true';
} else {
	echo 'false';
}
//
?>