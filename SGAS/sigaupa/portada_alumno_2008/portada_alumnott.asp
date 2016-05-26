<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'########################################################################################
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
v_anio_actual	= 	Year(now())

if (v_dia_actual<=27 and v_mes_actual=07 and v_anio_actual=2008) then
	response.Redirect("http://216.72.170.68/sigaupa/portada_alumno_2008b/portada_alumno.asp")
	response.End()
else
	response.Redirect("http://216.72.170.68/sigaupa/portada_alumno_2008b/portada_alumno.asp")
	response.End()
end if
'########################################################################################

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
									  			<table width="80%" border="1" bordercolor="#496da6">
													<tr><td align="center">
																		 <table width="100%" border="0">
																		 <tr>
																		    <td align="center" width="148"><img width="80" height="80" src="../informacion_alumno_2008/imagenes/llaves.gif" border="0"></td>
																		    <td width="340" align="left">
																				<table width="100%" cellpadding="0" cellspacing="0">
																					<tr>
																						<td width="21%" align="right"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Usuario</strong></font></td>
																						<td width="79%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong></font><%f_datos.dibujaCampo "login"%></td>
																					</tr>
																					<tr>
																						<td width="21%" align="right"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Clave</strong></font></td>
																						<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_datos.dibujaCampo "clave"%></font></td>
																					</tr>
																				</table>
																			</td>
																		 </tr>
																		 <tr><td>&nbsp;</td></tr>
																		 </table>
													
													</td>
												</tr>
											 </table>
									       </td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr> 
										<td width="39%" height="10">&nbsp;</td>
										<td width="28%" height="10" align="right"><div align="left"><% botonera.dibujaboton "aceptar"%></div></td>
										<td width="29%" height="10" align="left"><div align="right"><a href="portada_alumno.asp" onClick="clave();">¿Has olvidado tu clave..?</a></div></td>
										<td width="4%" height="10">&nbsp;</td>
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
</body>
</html>
