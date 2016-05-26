<?php 
error_reporting(0);
//echo "<hr>";

//echo "<hr>";
$persona_origen = $_POST["persona_origen"];
$persona_destino  = $_POST["persona_destino"];
$email_destino  = $_POST["email_destino"];	
$asunto = $_POST["asunto"];
$contenido = $_POST["contenido"];
$carrera = $_POST["carrera"];
				
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
<table width="700" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	    <td width="3%" align="left">&nbsp;</td>
	  	<td colspan="3" height="59" align="center"><span id="titulo"><font color="#0066FF" face="Verdana, Arial, Helvetica, sans-serif" size="5">MENSAJE ESCUELA</font></span><br><font color="#000000" size="1">'.$fecha.'</font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo">Estimado Alumno/Profesor.<br>En nombre de la escuela de '.$carrera.' les hago llegar el siguiente comunicado:</p></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>De</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$persona_origen.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Para</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$persona_destino.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Asunto</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$asunto.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td colspan="3" align="left"><div align="justify"><font size="2" color="#CC6600">'.$contenido.'</font></div></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
  	  <tr>
	  	<td colspan="5" align="right"><font size="-1">Una copia del mensaje se ha enviado a tu bandeja de pacífico online</font></td>
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
	  <tr>
	  	<td colspan="5" align="right"><font size="1">NSC.:'.$cod.'</font></td>
	  </tr>
</table>
</body>
</html>';

//echo $mensaje;
//echo $cadena_email;
//exit;
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: sistemas@upacifico.cl' . "\r\n";
$cabeceras .= 'Bcc: msandoval@upacifico.cl' . "\r\n";
//$resultado = mail($cadena_email,"Notas Parciales ".$asig_tdesc_temp, $mensaje, $cabeceras);
$resultado = mail($email_destino,"Mensaje de ".$carrera." en archivo adjunto", $mensaje, $cabeceras);
//
if ($resultado) 
{
    $final = '<CENTER>
				<table width="70%" height="50">
					<tr>
						<td width="100%" bgcolor="#66CC66" align="center"><strong><font face="Times New Roman, Times, serif" size="+3" color="#FFFFFF">Email enviado satisfactoriamente con el siguiente contenido</font></strong></td>
					</tr>
					<tr><td><hr color="#0033FF"></td></tr>
				</table>
			</CENTER>'.$mensaje;	
	echo $final;
} 
else 
{
	$final = '<CENTER>
				<table width="70%" height="50">
					<tr>
						<td width="100%" bgcolor="#FF0000" align="center"><strong><font face="Times New Roman, Times, serif" size="+3" color="#FFFFFF">Se ha presentado un error en el env&iacute;o, vuelva a intentarlo</font></strong></td>
					</tr>
				</table>
			</CENTER>';
	echo $final;
}
//
?>