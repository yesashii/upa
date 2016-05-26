<?php 
error_reporting(0);
//echo "<hr>";

//echo "<hr>";
$sede_tdesc_temp = $_POST["sede_tdesc_temp"];
$carr_tdesc_temp  = $_POST["carr_tdesc_temp"];
$asig_ccod_temp  = $_POST["asig_ccod_temp"];	
$asig_tdesc_temp = $_POST["asig_tdesc_temp"];
$secc_tdesc_temp = $_POST["secc_tdesc_temp"];
$profe_temp      = $_POST["profe_temp"];
$detalle_evaluacion_temp      = $_POST["detalle_evaluacion_temp"];
$ponderacion_evaluacion_temp      = $_POST["ponderacion_evaluacion_temp"];
							
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
	  	<td colspan="3" height="59" align="center"><span id="titulo"><font color="#0066FF" face="Verdana, Arial, Helvetica, sans-serif" size="5">RESULTADOS EVALUACION PARCIAL</font></span><br><font color="#000000" size="1">'.$fecha.'</font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo">Estimados Alumnos.<br>Mediante el presente email, hago llegar a ustedes los resultados de la evaluación parcial que se detalla a continuación:</p></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Sede</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$sede_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Carrera</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$carr_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Asignatura</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$asig_ccod_temp.'&nbsp;&nbsp;'.$asig_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Sección</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$secc_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Profesor</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$profe_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Evaluación</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2" color="#E85A08">'.$detalle_evaluacion_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="5" align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="5" align="center"><font size="2" color="blue"><strong>'.$ponderacion_evaluacion_temp.'</strong></font></td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
  	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">
			<table width="90%" align="center" cellpadding="0" cellspacing="0" border="0" bordercolor="#fee4b2">
				<tr>
					<td width="90%" align="center" bgcolor="#fee4b2"><strong>Alumno</strong></td>
					<td width="20%" align="center" bgcolor="#fee4b2"><strong>Nota</strong></td>
				</tr>';
	$contador = 0;
	$email = '';
	$nombre_oculto = '';
	$nota = '';
	$cadena_email='';
	foreach ($_POST["not"] as $clave=>$valor) 
	{
	   //echo "<br>$contador :===============>";
	   foreach ($valor as $quey=>$valiu) 
	   {
			//echo "<br>Valor <b>$quey</b>:".$valiu;
			if ($quey == "alumno_oculto" )
			{
				$nombre_oculto = $valiu;
			}
			elseif ($quey == "email")
			{
				$email = $valiu;
			}
			elseif ($quey == "cala_nnota")
			{
				$nota = $valiu;
			}
	   }
	   $contador ++;
	   if ($cadena_email != '' )
	    { $cadena_email = $cadena_email.';'.$email;}
	   else
	    { $cadena_email = $email;}
	   $mensaje = $mensaje.'<tr>
								<td width="90%" align="left" bgcolor="#ffffff">'.$nombre_oculto.'</td>
								<td width="20%" align="center" bgcolor="#ffffff">'.$nota.'</td>
							</tr>';
							
	}			
	$mensaje = $mensaje.'
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
//echo $cadena_email;
//exit;
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: sistemas@upacifico.cl' . "\r\n";
$cabeceras .= 'Bcc: mshaw@upacifico.cl' . "\r\n";
//$resultado = mail($cadena_email,"Notas Parciales ".$asig_tdesc_temp, $mensaje, $cabeceras);
$resultado = mail($cadena_email,"Ver notas parciales de ".$asig_tdesc_temp." en archivo adjunto", $mensaje, $cabeceras);
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
?><?php 
error_reporting(0);
//echo "<hr>";

//echo "<hr>";
$sede_tdesc_temp = $_POST["sede_tdesc_temp"];
$carr_tdesc_temp  = $_POST["carr_tdesc_temp"];
$asig_ccod_temp  = $_POST["asig_ccod_temp"];	
$asig_tdesc_temp = $_POST["asig_tdesc_temp"];
$secc_tdesc_temp = $_POST["secc_tdesc_temp"];
$profe_temp      = $_POST["profe_temp"];
$detalle_evaluacion_temp      = $_POST["detalle_evaluacion_temp"];
$ponderacion_evaluacion_temp      = $_POST["ponderacion_evaluacion_temp"];
							
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
	  	<td colspan="3" height="59" align="center"><span id="titulo"><font color="#0066FF" face="Verdana, Arial, Helvetica, sans-serif" size="5">RESULTADOS EVALUACION PARCIAL</font></span><br><font color="#000000" size="1">'.$fecha.'</font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo">Estimados Alumnos.<br>Mediante el presente email, hago llegar a ustedes los resultados de la evaluación parcial que se detalla a continuación:</p></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Sede</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$sede_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Carrera</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$carr_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Asignatura</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$asig_ccod_temp.'&nbsp;&nbsp;'.$asig_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Sección</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$secc_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Profesor</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$profe_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Evaluación</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2" color="#E85A08">'.$detalle_evaluacion_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="5" align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="5" align="center"><font size="2" color="blue"><strong>'.$ponderacion_evaluacion_temp.'</strong></font></td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
  	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">
			<table width="90%" align="center" cellpadding="0" cellspacing="0" border="0" bordercolor="#fee4b2">
				<tr>
					<td width="90%" align="center" bgcolor="#fee4b2"><strong>Alumno</strong></td>
					<td width="20%" align="center" bgcolor="#fee4b2"><strong>Nota</strong></td>
				</tr>';
	$contador = 0;
	$email = '';
	$nombre_oculto = '';
	$nota = '';
	$cadena_email='';
	foreach ($_POST["not"] as $clave=>$valor) 
	{
	   //echo "<br>$contador :===============>";
	   foreach ($valor as $quey=>$valiu) 
	   {
			//echo "<br>Valor <b>$quey</b>:".$valiu;
			if ($quey == "alumno_oculto" )
			{
				$nombre_oculto = $valiu;
			}
			elseif ($quey == "email")
			{
				$email = $valiu;
			}
			elseif ($quey == "cala_nnota")
			{
				$nota = $valiu;
			}
	   }
	   $contador ++;
	   if ($cadena_email != '' )
	    { $cadena_email = $cadena_email.';'.$email;}
	   else
	    { $cadena_email = $email;}
	   $mensaje = $mensaje.'<tr>
								<td width="90%" align="left" bgcolor="#ffffff">'.$nombre_oculto.'</td>
								<td width="20%" align="center" bgcolor="#ffffff">'.$nota.'</td>
							</tr>';
							
	}			
	$mensaje = $mensaje.'
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
//echo $cadena_email;
//exit;
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: sistemas@upacifico.cl' . "\r\n";
$cabeceras .= 'Bcc: mshaw@upacifico.cl' . "\r\n";
//$resultado = mail($cadena_email,"Notas Parciales ".$asig_tdesc_temp, $mensaje, $cabeceras);
$resultado = mail($cadena_email,"Ver notas parciales de ".$asig_tdesc_temp." en archivo adjunto", $mensaje, $cabeceras);
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
?><?php 
error_reporting(0);
//echo "<hr>";

//echo "<hr>";
$sede_tdesc_temp = $_POST["sede_tdesc_temp"];
$carr_tdesc_temp  = $_POST["carr_tdesc_temp"];
$asig_ccod_temp  = $_POST["asig_ccod_temp"];	
$asig_tdesc_temp = $_POST["asig_tdesc_temp"];
$secc_tdesc_temp = $_POST["secc_tdesc_temp"];
$profe_temp      = $_POST["profe_temp"];
$detalle_evaluacion_temp      = $_POST["detalle_evaluacion_temp"];
$ponderacion_evaluacion_temp      = $_POST["ponderacion_evaluacion_temp"];
							
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
	  	<td colspan="3" height="59" align="center"><span id="titulo"><font color="#0066FF" face="Verdana, Arial, Helvetica, sans-serif" size="5">RESULTADOS EVALUACION PARCIAL</font></span><br><font color="#000000" size="1">'.$fecha.'</font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo">Estimados Alumnos.<br>Mediante el presente email, hago llegar a ustedes los resultados de la evaluación parcial que se detalla a continuación:</p></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Sede</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$sede_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Carrera</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$carr_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Asignatura</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$asig_ccod_temp.'&nbsp;&nbsp;'.$asig_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Sección</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$secc_tdesc_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Profesor</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2">'.$profe_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="3%" align="left">&nbsp;</td>
		<td width="10%" align="left"><font size="2"><strong>Evaluación</strong></font></td>
		<td width="3%" align="center"><font size="2"><strong>:</strong></font></td>
		<td align="left"><font size="2" color="#E85A08">'.$detalle_evaluacion_temp.'</font></td>
		<td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="5" align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="5" align="center"><font size="2" color="blue"><strong>'.$ponderacion_evaluacion_temp.'</strong></font></td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
  	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">
			<table width="90%" align="center" cellpadding="0" cellspacing="0" border="0" bordercolor="#fee4b2">
				<tr>
					<td width="90%" align="center" bgcolor="#fee4b2"><strong>Alumno</strong></td>
					<td width="20%" align="center" bgcolor="#fee4b2"><strong>Nota</strong></td>
				</tr>';
	$contador = 0;
	$email = '';
	$nombre_oculto = '';
	$nota = '';
	$cadena_email='';
	foreach ($_POST["not"] as $clave=>$valor) 
	{
	   //echo "<br>$contador :===============>";
	   foreach ($valor as $quey=>$valiu) 
	   {
			//echo "<br>Valor <b>$quey</b>:".$valiu;
			if ($quey == "alumno_oculto" )
			{
				$nombre_oculto = $valiu;
			}
			elseif ($quey == "email")
			{
				$email = $valiu;
			}
			elseif ($quey == "cala_nnota")
			{
				$nota = $valiu;
			}
	   }
	   $contador ++;
	   if ($cadena_email != '' )
	    { $cadena_email = $cadena_email.';'.$email;}
	   else
	    { $cadena_email = $email;}
	   $mensaje = $mensaje.'<tr>
								<td width="90%" align="left" bgcolor="#ffffff">'.$nombre_oculto.'</td>
								<td width="20%" align="center" bgcolor="#ffffff">'.$nota.'</td>
							</tr>';
							
	}			
	$mensaje = $mensaje.'
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
//echo $cadena_email;
//exit;
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: sistemas@upacifico.cl' . "\r\n";
$cabeceras .= 'Bcc: mshaw@upacifico.cl' . "\r\n";
//$resultado = mail($cadena_email,"Notas Parciales ".$asig_tdesc_temp, $mensaje, $cabeceras);
$resultado = mail($cadena_email,"Ver notas parciales de ".$asig_tdesc_temp." en archivo adjunto", $mensaje, $cabeceras);
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