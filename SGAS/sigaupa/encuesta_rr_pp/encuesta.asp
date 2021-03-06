<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_rr_pp.asp"-->


<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Fin"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_rr_pp.xml", "botonera"
q_pers_nrut=negocio.obtenerUsuario
alumno = conexion.consultaUno("Select nombres+' '+apellidos from titulados_egresados_rrpp where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'response.End()
Session.Abandon()
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Bienvenido a la Universidad del Pac&iacute;fico</title>
<style type="text/css">
<!--
.Estilo25 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
}
body {
	background-color: #dae4fa;
}
.Estilo26 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10pt;
}
.Estilo27 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16pt;
	font-weight: bold;
	color: #FF7F00;
}
.Estilo100 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12pt;
	font-weight: bold;
	color: #FF7F00;
}
.Estilo31 {
	font-size: 10pt;
	font-family: Arial, Helvetica, sans-serif;
}
.Estilo34 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }
.Estilo35 {
	font-weight: bold;
	font-size: 36px;
	font-style: italic;
	color: #FF7F00;
}
.Estilo36 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; }
.Estilo37 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; font-weight: bold; }
.Estilo42 {font-size: 10pt; color: #000000; font-family: Arial, Helvetica, sans-serif;}
.Estilo43 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #333333; }
.Estilo45 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; }
.Estilo46 {
	color: #FF6600;
	font-weight: bold;
}
-->
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function cerrarVentana(){
//la referencia de la ventana es el objeto window del popup. Lo utilizo para acceder al m�todo close
window.close()
} 

</script>
</head>

<body>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<p>&nbsp;</p>
<p>&nbsp;</p>
<form name="edicion">

<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="25" height="24" background="../evalua/images/borde_superior.jpg"><img width="25" height="24" src="../evalua/images/superior_izquierda.jpg"></td>
	<td width="646" height="24" background="../evalua/images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="../evalua/images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="../evalua/images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" aling="left" width="646">
		<table width="646" border="0" align="left" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
			<td align="left">
			<center>
			  <p class="Estilo27">�Gracias! <br />
			    <%=alumno%></p>
			</center>
				<p class="Estilo31">  </p>
               <center>
			     <table width="300" border="0" cellpadding="0" cellspacing="0">
				  <tr>
					
					<td width="34%" valign="top" class="Estilo31" align="center"><%f_botonera.dibujaBoton "salir"%></td>
				  </tr>
			     </table> 
			</center>
	  </td>
	  </tr>
  </table>
</td>
	<td width="29" background="../evalua/images/lado_derecha.gif"></td>
</tr>
<tr>
	<td width="25" height="27" background="../evalua/images/borde_inferior.jpg"><img width="25" height="27" src="../evalua/images/inferior_izquierda.jpg"></td>
	<td width="646" height="27" background="../evalua/images/borde_inferior.jpg">&nbsp;</td>
	<td width="29" height="27"><img width="29" height="27" src="../evalua/images/inferior_derecha.jpg"></td>
</tr>
</table>
</form>
<p align="center"><strong>&nbsp;<span class="Estilo45">&iexcl;Muchas gracias por  tu colaboraci&oacute;n! </span></strong><br />
<p align="center" class="Estilo31">&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
</tr>
</table>
</body>

</html>
