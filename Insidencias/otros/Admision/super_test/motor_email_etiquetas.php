<?php 
error_reporting(0);
//echo "<hr>";

//echo "<hr>";
$nro_alumnos     = $_POST["total_carrera"];
$sede            = $_GET["sede"];
$destino         = $_GET["destino"];
$email_destino = "vmendoza@upacifico.cl";
$frase = " sus áreas ";
if ($destino == "F")
{
	$email_destino = $email_destino.',hpaz@upacifico.cl';
    $frase = " Finanzas ";
}
if ($destino == "A")
{
	$email_destino = $email_destino.',rallodi@upacifico.cl';
    $frase = " Audiovisual ";
}
if ($destino == "B")
{
   if (sede == "1")
   {
		$email_destino = $email_destino.',lcastillo@upacifico.cl,lbustos@upacifico.cl';	
   }	
   if (sede == "8")
   {
		$email_destino = $email_destino.',rsalinas@upacifico.cl,mfranke@upacifico.cl';	
   }
   if (sede == "4")
   {
		$email_destino = $email_destino.',tguerrero@upacifico.cl,mmiranda@upacifico.cl';	
   }
   $frase = " Biblioteca ";		
   
}

if ($destino == "")
{
	$email_destino = "vmendoza@upacifico.cl,rallodi@upacifico.cl,hpaz@upacifico.cl";
    if (sede == "1")
	   {
			$email_destino = $email_destino.',lcastillo@upacifico.cl,lbustos@upacifico.cl';	
	   }	
    if (sede == "8")
	   {
			$email_destino = $email_destino.',rsalinas@upacifico.cl,mfranke@upacifico.cl';	
	   }
    if (sede == "4")
	   {
			$email_destino = $email_destino.',tguerrero@upacifico.cl,mmiranda@upacifico.cl';	
	   }	
}

//echo $nro_alumnos;
							
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
	  	<td colspan="3" height="59" align="center"><span id="titulo"><font color="#0066FF" face="Times New Roman, Times, serif" size="4">SOLICITUD V°B° ALUMNOS</font></span><br><font color="#000000" size="1">'.$fecha.'</font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo"><font face="Times New Roman, Times, serif">Estimados<br><br><br>Agradeceré informar al Depto. de Títulos y Grados situación en '.$frase.', de los siguientes alumnos que se encuentran en proceso de egreso y titulación, estos son:</p></font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
  	  <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="5">
			<table width="90%" align="center" cellpadding="0" cellspacing="0" border="1" bordercolor="#fee4b2">';
	$contador = 0;
	for ($i=0; $i <= $nro_alumnos; $i++)
	{ 
	  $color  = "#FFFFFF";
	  if ($i==0)
	  {
	     $color  = "#fee4b2";	
	  }
	  $mensaje = $mensaje.'<tr>';
	  $mensaje = $mensaje.'		<td align="left" bgcolor="'.$color.'"><font face="Times New Roman, Times, serif">'.$_POST['dato_'.$i.'_sede'].'</font></td>';
	  $mensaje = $mensaje.'		<td align="left" bgcolor="'.$color.'"><font face="Times New Roman, Times, serif">'.$_POST['dato_'.$i.'_carrera'].'</font></td>';
	  $mensaje = $mensaje.'		<td align="left" bgcolor="'.$color.'"><font face="Times New Roman, Times, serif">'.$_POST['dato_'.$i.'_rut'].'</font></td>';
	  $mensaje = $mensaje.'		<td align="left" bgcolor="'.$color.'"><font face="Times New Roman, Times, serif">'.$_POST['dato_'.$i.'_nombre'].'</font></td>';
	  $mensaje = $mensaje.'</tr>';
	  $contador ++;
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
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo"><font face="Times New Roman, Times, serif">Para lo anterior, se solicita remitir a la brevedad los certificados con V°B° correspondientes, en caso contrario, indicarnos quienes se encuentran con su situación pendiente.</p></font></td>
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
		<td colspan="3"><p id="parrafo"><font face="Times New Roman, Times, serif">Saluda atte. a Ud.</p></font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
      <tr>
	  	<td colspan="5">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo"><font face="Times New Roman, Times, serif">Depto. Títulos y Grados</p></font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
	  <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo"><font face="Times New Roman, Times, serif">Universidad del Pacífico</p></font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
      <tr valign="middle">
	  	<td width="3%" align="left">&nbsp;</td>	
		<td colspan="3"><p id="parrafo"><font face="Times New Roman, Times, serif">------------------------------------------</p></font></td>
	    <td width="3%" align="left">&nbsp;</td>
	  </tr>
</table>
</body>
</html>';

echo $mensaje;
//echo $cadena_email;
exit;
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: titulosygrados@upacifico.cl' . "\r\n";
$cabeceras .= 'Bcc: msandoval@upacifico.cl' . "\r\n";
//$resultado = mail($email_destino,"Confirmación estado alumnos", $mensaje, $cabeceras);
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