<?php 
$nombre            = $_POST['nombre_alumno'];
$rut               = $_POST['rut'];
$motivo 		   = $_POST['motivo'];	
$carrera           = $_POST['nombre_carrera'];
$tipo			   = $_POST['tipo_certificado'];
$email             = $_POST['email'];
if ($tipo=="Certificado de Alumno regular")
{	
	$mail_destino      = "bvega@upacifico.cl";
}
else
{
	$mail_destino      = "hvargas@upacifico.cl";
}	
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
	color: #000000;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 8px;
	text-align:justify;
}
#pie {
	color: #e41712;
	font-size: 10px;
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
<table width="500" height="700" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC" background="http://www.upacifico.cl/mail_postulacion2009/imagenes/nuevo_logo_email_certificados.jpg" id="Tabla_01">
<tr>
<td colspan="3" width="500" height="91">&nbsp;
</td>
</tr>
<tr>
<td rowspan="4" width="30" height="609">&nbsp;
</td>
<td width="439" height="59" align="center" valign="middle">
<!-- inicio titulo -->
<span id="titulo"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif" size="5">Solicitud Certificados Online</font></span>
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
<p id="parrafo"><br><br></p>
<!--  -->
<span class="parrafo">&nbsp;</span><br/>
<span id="parrafo"><br><br><br><br><br><br>Sres. Registro Curricular:<br>El alumno '.$nombre.' (Rut: '.$rut.'),<br> perteneciente a la carrera '.$carrera.'<br>ha utilizado Pacífico Online
y a través de esta plataforma les hace la<br>siguiente solicitud:<br><br>- Certificado tipo: '.$tipo.'<br>- Motivo: '.$motivo.'<br>- Email contacto: '.$email.'
<br><br><br>Ante cualquier duda o sugerencia, favor contactarse con<br>Departamento de Informática</span>
<span class="Detalle">&nbsp;</span><br/>
<span class="Detalle">&nbsp;</b></span> 
<!--  -->
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
//echo "$mensaje";
//exit;
//
$cabeceras  = 'MIME-Version: 1.0' . "\r\n";
$cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//
$cabeceras .= 'From: Pacífico Online <administrador@upacifico.cl>' . "\r\n";
$cabeceras .= 'Bcc: mshaw@upacifico.cl' . "\r\n";
//
$resultado = mail($mail_destino,"Solicitud Certificado $rut", $mensaje, $cabeceras);
//
if ($resultado) 
{
	 $mensaje_respuesta = "...SU SOLICITUD HA SIDO REALIZADA EXITOSAMENTE...";
}
else 
{
	 $mensaje_respuesta = "...ERROR DE COMUNICACIÓN, FAVOR INTENTAR MAS TARDE...";
}

$pagina= "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>
<html>
<head>
<title>Notas parciales del alumno</title>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
<link href='../estilos/estilos.css' rel='stylesheet' type='text/css'>
<link href='../estilos/tabla.css' rel='stylesheet' type='text/css'>

<script language='JavaScript' src='../biblioteca/tabla.js'></script>
<script language='JavaScript' src='../biblioteca/funciones.js'></script>
<script language='JavaScript' src='../biblioteca/validadores.js'></script>

<script language='JavaScript'>
</script>
<style type='text/css'>
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}
#menu div.barraMenu {
text-align: left;
}
#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}
#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}
#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
</style>

</head>

<body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0' bgcolor='#84a6d3' background='imagenes/fondo.jpg'>
<center>
<table align='center' width='700'>
  <tr>
     <td width='100%'><font size='-1'>&nbsp;</font></td>
  </tr>
  <tr>
     <td width='100%' align='center'>
        <font size='5' face='Georgia, Times New Roman, Times, serif' color='#23354d'><strong>Solicitud de Certificados</strong></font>
     </td>
  </tr>
  <tr>
     <td width='100%'><font size='-1'>&nbsp;</font></td>
  </tr>
  <tr>
     <td width='100%' align='left'>
	<table width='700' cellpadding='0' cellspacing='0' border='0' bgcolor='#4b73a6'>
	<tr>
           <td>
               <font size='-1'>&nbsp;</font>
           </td>
        </tr>
	<tr valign='middle'>
	   <td width='100%' align='center'>
		<table width='98%' border='0' bgcolor='#f7faff'>
		  <form name='edicion' action='notas_alumno.asp'>
		   <tr>
	       	     <td width='100%' align='center'>
		       <table width='100%'>
			 <tr>
			    <td width='33%'>
                               <font size='3' face='Georgia, Times New Roman, Times, serif' color='#496da6'>
                                    <strong>Solicitud de Certificados</strong>
                               </font>
                            </td>
			    <td><hr></td>
			    <TD width='10%'>&nbsp;</TD>
			 </tr>
		       </table>
		     </td>
		  </tr>
		  <tr>
		     <td width='100%' align='center'>
		       <table width='100%' border='0' cellpadding='0' cellspacing='0'>
			<tr>
   			    <td height='20' colspan='2'>
                                 <font size='2' face='Courier New, Courier, mono' color='#496da6'><strong>Rut</strong></font>
                            </td>
			    <td colspan='2'>
                                <font size='2' face='Courier New, Courier, mono' color='#496da6'><strong>: </strong>".$rut."</font>
                            </td>
			</tr>
		       <tr> 
		    <td height='20' colspan='2'>
                       <font size='2' face='Courier New, Courier, mono' color='#496da6'><strong>Nombre</strong></font>
                    </td>
	      	    <td colspan='2'>
                       <font size='2' face='Courier New, Courier, mono' color='#496da6'>
                                <strong>: </strong>".$nombre."</font>
                    </td>
		 </tr>
		 <tr> 
		    <td height='20' colspan='2'>
                       <font size='2' face='Courier New, Courier, mono' color='#496da6'><strong>Carrera</strong></font>
                    </td>
		    <td colspan='2'>
                       <font size='2' face='Courier New, Courier, mono' color='#496da6'><strong>: </strong>".$carrera."</font>
                    </td>
		 </tr>
		 <tr> 
		    <td height='20' colspan='2'>
                       <font size='2' face='Courier New, Courier, mono' color='#496da6'><strong>Tipo de Certificado</strong></font>
                    </td>
		   <td colspan='2'>
                       <font size='2' face='Courier New, Courier, mono' color='#496da6'><strong>: </strong>".$tipo."</font>
                   </td>
		 </tr>
		 <tr> 
		   <td height='20' colspan='2'>
                       <font size='2' face='Courier New, Courier, mono' color='#496da6'>
                                 <strong>Motivo de extenci&oacute;n</strong>
                       </font>
                   </td>
		   <td colspan='2'>
                      <font size='2' face='Courier New, Courier, mono' color='#496da6'><strong>: </strong>".$motivo."</font></td>
		 </tr>
		 <tr><td height='20' colspan='4'>&nbsp;</td></tr>
		 <tr><td height='20' colspan='4' align='center'><font size='2' color='#c03620' ><strong>".$mensaje_respuesta."</strong></font></td></tr>
            </table>
        </td>
	</tr>
    </form>
  </table>
  </td>
 </tr>
 <tr><td><font size='-1'>&nbsp;</font></td></tr>				
</table>
</td>
</tr>
<tr>
  <td width='100%'><font size='-1'>&nbsp;</font></td>
</tr>
</table>
</center>
</body>
</html>";
echo "$pagina";
//
?>