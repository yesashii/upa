<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores
'set negocio = new CNegocio
'negocio.Inicializa conexion
'------------------------------------------------------
ip_usuario=Request.ServerVariables("REMOTE_ADDR")


'------------------------------------------------------  
 set botonera = new Cformulario
 botonera.carga_parametros "portada_empresa.xml", "btn_portada"
'------------------------------------------------------

'---------------------------------------------------------------------
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "portada_empresa.xml", "f_datos"
 f_datos.Inicializar conexion
 f_datos.Consultar "select ''"
 f_datos.Siguiente
 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript"> 
<!-- 
function EncuadraVentana(){
	if(parent.location != self.location)parent.location = self.location;
}
//--> 
function clave() {
  direccion = "olvido_clave.asp";
  window.open(direccion ,"ventana1","width=370,height=205,scrollbars=no, left=313, top=200");
}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#84a6d3" onLoad="EncuadraVentana();">
<table align="center" height="100%">
<tr><td valign="middle">
<table width="601" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
      <td width="601" colspan="2" align="center">
	    <table width="585" cellpadding="0" cellspacing="0">
			<tr valign="top">
				<td width="552" height="136" bgcolor="#4b73a6" align="right"><img width="552" height="136" src="imagenes/frame_portada_1_1.jpg"></td>
				<td width="33" height="135" bgcolor="#84a6d3" align="left"><img width="33" height="135" src="../informacion_alumno_2008/imagenes/frame_portada_2.jpg"></td>
			</tr>
			<tr valign="top">
				<td width="552" bgcolor="#4b73a6" align="right">
					<table width="98%" align="center" border="0" bgcolor="#f7faff">
						<form name="valida" action="" method="post">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="32%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Resgistro Empresas </strong></font></td>
										   <td width="68%"><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr> 
										<td width="46%" height="10">&nbsp;</td>
										<td width="54%" height="10" align="center"><div align="left"><% botonera.dibujaboton "registrarse"%></div></td>
										
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
                                  
								  </table>
                  
								</td>
							</tr>
						  
					  </form>
				  </table>
				</td>
				<td width="33" bgcolor="#84a6d3" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td bgcolor="#4b73a6"></td>
				<td width="33" bgcolor="#84a6d3" align="left">&nbsp;</td>
			</tr>
		</table>  
	  </td>
  </tr>
  <tr><td colspan="2">&nbsp;</td></tr>
  
  <tr> 
    <td colspan="2"><img src="pixel_negro.gif" width="100%" height="2"></td>
  </tr>
  
</table>
</td></tr></table>
<p>&nbsp;</p>
</body>
</html>
