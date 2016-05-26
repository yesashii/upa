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
 botonera.carga_parametros "portada_alumno.xml", "btn_portada"
'------------------------------------------------------

'---------------------------------------------------------------------
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "portada_alumno.xml", "f_datos"
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
				<td width="552" height="136" bgcolor="#4b73a6" align="right"><img width="552" height="136" src="../informacion_alumno_2008/imagenes/frame_portada_1.jpg"></td>
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
										   <td width="44%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Administraci&oacute;n de Acceso</strong></font></td>
										   <td width="56%"><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr>
									       <td height="20" colspan="4" align="center">
									  			<table width="90%" border="0" bordercolor="#496da6">
													<tr>
													   <td align="center">
													      <div align="center">
															<p><font color="#333333" size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>En estos momentos estamos experimentando un alto flujo de usuarios en nuestros sistemas...</strong></font></p>
															<p><strong><font color="#333333" size="3" face="Verdana, Arial, Helvetica, sans-serif">Por favor inténtelo en unos minutos más. </font></strong></p>
														  </div>
													  </td>
												    </tr>
											 </table>
									       </td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
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
</body>
</html>
