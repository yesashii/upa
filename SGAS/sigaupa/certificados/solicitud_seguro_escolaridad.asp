<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
pers_nrut = request.QueryString("pers_nrut")
pers_nrut="9119940"
set conexion = new cConexion
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

nombre = conexion.consultaUno("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_nrut as varchar)='" & pers_nrut & "' ")
rut = conexion.consultaUno("select protic.format_rut('"&pers_nrut&"')")
				 
%>
<html>
<head>
<title>SOLICITUD DE SEGURO DE ESCOLARIDAD</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicio.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript1.2" src="tabla.js"></script>
<style>
@media print{ .noprint {visibility:hidden; }}
</style>
<style type="text/css">
<!--
td {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 8px;
}
h1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 16px;
}
-->
</style>
</head>
<body bgcolor="#ffffff">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="100%">&nbsp;<div align="right" class="noprint">
<button name="Button" value="Imprimir Horario" onClick="print()" >
Imprimir
</button>
</div></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0" border="1">
			<TR>
				<TD align="center"><div align="center"><font size="4"><strong>SOLICITUD DE SEGURO DE ESCOLARIDAD</strong></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
			<TR>
				<TD align="left"><div align="left"><font size="2"><strong>Contratante Contrato de Servicios Educacionales - Año 2007</strong></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0" border="1">
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="2">Apellido Paterno</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">Apellido Materno</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">Nombres</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">&nbsp;</font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
			<TR>
				<TD align="center"><div align="center"><input type="checkbox" name="desea_seguro" value="0">&nbsp;&nbsp;<strong><font size="2" style="text-decoration:underline">NO</font>&nbsp;&nbsp;<font size="2">DESEO EL SEGURO DE ESCOLARIDAD</strong></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
			<TR>
				<TD align="center"><div align="center"><font size="2">Firma Contratante ..................................................</font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
			<TR>
				<TD align="Left" width="20%"><div align="left"><font size="2"><strong>1er Sostenedor</strong></font></div></TD>
				<TD align="center" width="10%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="left"><div align="left"><font size="2">(Edad m&aacute;xima asegurable 68 años, 364 d&iacute;as)</font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0" border="1">
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="2">Apellido Paterno</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">Apellido Materno</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">Nombres</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">&nbsp;</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="2">F. Nacimiento</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">R.U.T.</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">Fonos</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="2">&nbsp;</font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
			<TR>
				<TD align="left"><div align="left"><font size="2"><strong>Datos Alumnos (s)</strong></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0" border="1">
			<TR>
				<TD align="center" width="30%"><div align="center"><font size="2">Nombre completo</font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="2">RUT</font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="2">F. Nacimiento</font></div></TD>
				<TD align="center" width="40%"><div align="center"><font size="2">Carrera</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="30%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="40%"><div align="center"><font size="2">&nbsp;</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="30%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="40%"><div align="center"><font size="2">&nbsp;</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="30%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="2">&nbsp;</font></div></TD>
				<TD align="center" width="40%"><div align="center"><font size="2">&nbsp;</font></div></TD>
			</TR>
		</table></td>
  </tr>
   <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
			<TR>
				<TD align="left"><div align="left"><font size="2"><strong>Declaración simple</strong></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0" border="1">
			<TR>
				<TD align="center" width="100%">
				    <div align="justify">
					   <font size="2">Declaro estar en buenas condiciones de salud y que no padezco ni he padecido ninguna de las siguientes enfermedades:
					                  Diabetes, cáncer o tumores de cualquier naturaleza, trastornos mentales o del sistema nervioso, enfermedades cardiovasculares
									  y/o hipertensión, broncopulmonares, genitourinarias, renales y de transmisión sexual (venereas o sida). En caso contrario detallar
									  en "Declaración de Preexistencias".<br><br>Preexistencia: Se entiende por preexistencia cualquier enfermedad o accidente conocida y/o 
									  diagnosticada  con anterioridad a la fecha de llenado de este formulario.                
					   </font>
					 </div>
			      </TD>
    		</TR>
		</table></td>
  </tr>
</table>
<br>
</body>
</html>
