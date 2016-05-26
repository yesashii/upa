<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
v_hora_sys	=	Hour(now())
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
if v_mes_actual = 12 and v_dia_actual = 9 and v_hora_sys >= 6 and v_hora_sys < 9 then
	response.Redirect("portada_alumno_mantencion.asp")
end if

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores
'set negocio = new CNegocio
'negocio.Inicializa conexion
'------------------------------------------------------
ip_usuario=Request.ServerVariables("REMOTE_ADDR")
activar_ocultos=false
if ip_usuario="172.16.11.67" then
   activar_ocultos=true
end if   

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

' pasa_fecha = conexion.consultaUno("select case when convert(datetime,protic.trunc(getDate()),103) >= convert(datetime,'25/04/2011',103) and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,'22/05/2011',103) then 'S' else 'N' end")
 c_encuesta = " select case when convert(datetime,protic.trunc(getDate()),103) >= convert(datetime,'01/02/2013',103) and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,'28/03/2013',103) "&_
              " then 'S' else 'N' end "
 pasa_fecha = conexion.consultaUno(c_encuesta)
 if pasa_fecha = "N" then 
 	activar_ocultos = false
 else
 	activar_ocultos = true
 end if	
 activar_ocultos = true
 
 pasa_fecha2 = conexion.consultaUno("select case when convert(datetime,protic.trunc(getDate()),103) >= convert(datetime,'14/01/2013',103) and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,'28/02/2013',103) then 'S' else 'N' end")
 if pasa_fecha2 = "N" then 
 	activar_ocultos2 = false
 else
 	activar_ocultos2 = true
 end if
 activar_ocultos2 = false
 sexos = conexion.consultaUno("select count(*) from sexos ")
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
  direccion = "http://admision.upacifico.cl/pacifico_online/www/olvido_clave.php";
  window.open(direccion ,"ventana1","width=370,height=225,scrollbars=no, left=313, top=200");
}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#84a6d3" onLoad="EncuadraVentana();">
<table align="center" height="100%">
<tr><td valign="middle">
<table width="601" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
      <td width="601" colspan="2" align="center">
	    <table width="588" cellpadding="0" cellspacing="0">
			<tr valign="top">
				<td width="552" height="136" bgcolor="#4b73a6" align="right"><img width="552" height="136" src="../informacion_alumno_2008/imagenes/frame_portada_1.jpg"></td>
				<td width="34" height="135" bgcolor="#84a6d3" align="left"><img width="33" height="135" src="../informacion_alumno_2008/imagenes/frame_portada_2.jpg"></td>
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
																</table>
													
													</td>
												</tr>
											 </table>
									       </td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr> 
										<td width="39%" height="10"><div align="right">&nbsp;</div></td>
										<td width="28%" height="10" align="center"><div align="left"><% botonera.dibujaboton "aceptar"%></div></td>
										<td width="29%" height="10" align="left"><div align="right"><a href="portada_alumno.asp" onClick="clave();">¿Has olvidado tu clave..?</a></div></td>
										<td width="4%" height="10">&nbsp;</td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <!--<tr>
									      <td height="20" colspan="4" align="center">
										  	<table width="90%" cellpadding="0" cellspacing="0" border="2" bordercolor="#FFFFFF">
												<tr>
													<td width="100%" bgcolor="#FF9900" align="center">
														<font color="#FFFFFF" size="2">Formulario de postulación a becas 2011, ya disponibles en el Home de Pacífico Online.</font>
													</td>
												</tr>
											</table>
										  </td>
									  </tr>-->
                                      <%if activar_ocultos then 'para evaluación docente%>
									  <tr>
									      <td height="20" colspan="4" align="center">
										  		<table width="90%" cellpadding="0" cellspacing="0" border="0">
													<tr>
														
                                    <td align="center" width="25%" background="../imagenes/degradado.jpg"><font size="2" color="#990000"><strong>Encuesta 
                                      Docente 2012</strong></font></td>
														<td colspan="3">&nbsp;</td>
													</tr>
													<tr>
														<td align="center" colspan="4" background="../imagenes/degradado.jpg">
														<table width="100%" cellpadding="0" cellspacing="0">
															<tr>
																<td width="25%" align="center"><img width="85" height="59" src="../imagenes/megafonos.png"></td>
																
                                          <td width="75%" align="left"><font color="#0033FF" size="2">Segundo Período 
                                            encuesta docente 2012-02:<br>
                                            (todas las Sedes y Campus)<br>
                                            <li><strong>01-02-2013 --> <font color="#FF0000">28-03-2013</font>.</strong></li>
      
														                                                    </font></td>
															</tr>
														</table>
														</td>
													</tr>
													<tr>
														<td align="center" colspan="4"  background="../imagenes/degradado.jpg"><input type="button" name="evaluacion" value="Contestar Encuesta" onClick="_Guardar(this, document.forms['valida'], 'proc_portada_alumno_evaluacion.asp','', '', '', 'FALSE');" title="Revisar estado o contestar evaluación docente"></td>
													</tr>
													<tr>
														<td colspan="4"  background="../imagenes/degradado.jpg" align="right"><font color="#990000">* No olvidar que es requisito para toma de carga.</font></td>
													</tr>
												</table>		
									      </td>
									  </tr>
                                      <%end if%>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <%if activar_ocultos2 then%>
									  <tr>
									      <td height="20" colspan="4" align="center">
										  		<table width="90%" cellpadding="0" cellspacing="0" border="0">
													<tr>
														<td align="center" width="25%" background="../imagenes/degradado.jpg"><font size="2" color="#006600"><strong>Toma de Carga "2013-01"</strong></font></td>
														<td colspan="3">&nbsp;</td>
													</tr>
													<tr>
														<td align="center" colspan="4" background="../imagenes/degradado.jpg">
														<table width="100%" cellpadding="0" cellspacing="0">
															<tr>
																<td width="25%" align="center"><img width="85" height="59" src="../imagenes/megafonos.png"></td>
																<td width="75%" align="left"><font color="#006600" size="2">Estimado(a) alumno(a):<br> Ya se encuentra disponible el acceso a toma de carga online, no olvides consultar el calendario de esta actividad para tu escuela (<a href="../doc/calendario_toma_de_carga_2013_01.pdf" target="_blank">AQUI</a>).</strong></li><br>
														                                                    </font></td>
															</tr>
														</table>
														</td>
													</tr>
													<tr>
														<td align="center" colspan="4"  background="../imagenes/degradado.jpg"><input type="button" name="toma_carga" value="Toma de Carga La Araucana" onClick="_Guardar(this, document.forms['valida'], 'proc_portada_alumno_toma_carga.asp','', '', '', 'FALSE');"></td>
													</tr>
													<tr>
														<td colspan="4"  background="../imagenes/degradado.jpg" align="right"><font color="#990000">&nbsp;</font></td>
													</tr>
												</table>		
									      </td>
									  </tr>
									  <!--<tr>
									      <td height="20" colspan="4" align="center">
										  		<table width="90%" cellpadding="0" cellspacing="0" border="0" bgcolor="#e41712">
													<tr>
														<td align="center"><font size="2" color="#FFFFFF">Estimado alumno(a):<br> Ya se encuentra disponible el acceso a toma de carga online, no olvides consultar el calendario de esta actividad para tu escuela (<a href="../doc/Calendario_Toma_de_Carga_2do_Semestre_2010.pdf" target="_blank">AQUI</a>).</font></td>
													</tr>
													<tr>
														<td align="center"><input type="button" name="toma_carga" value="Acceso a Toma de Carga" onClick="_Guardar(this, document.forms['valida'], 'proc_portada_alumno_toma_carga.asp','', '', '', 'FALSE');"></td>
													</tr>
												</table>		
									      </td>
									  </tr>-->
									  <%end if%>
									  <!--<tr><td height="20" colspan="4" align="center">
									  	<table width="90%" cellpadding="0" cellspacing="0">
											<tr>
												<td width="100%" bgcolor="#CC0000"><font color="#FFFFFF" size="2">No te quedes sin Revalidar o Activar tu TNE!. Más información <a href="http://www.tne.cl/tde/" target="_blank">AQUÍ</a></font></td>
											</tr>
										</table>
									  </td></tr>-->
									  <tr><td height="20" colspan="4" align="center">&nbsp;</td></tr>
									  <tr valign="top">
									      <td colspan="4" align="center">
										  		<table width="291" height="81" cellpadding="0" cellspacing="0">
													<tr>
													   <td width="95" height="81">
														  <object type="application/x-shockwave-flash" data="swf/becas_creditos_beneficios.swf" width="95" height="81">
																<param name="movie" value="swf/becas_creditos_beneficios.swf" />
																<param name="quality" value="high" />
														  </object>
														</td>
														<td width="3">&nbsp;</td>
														<td width="95" height="81">
														 <object type="application/x-shockwave-flash" data="swf/titulos_y_grados.swf" width="95" height="81">
																<param name="movie" value="swf/titulos_y_grados.swf" />
																<param name="quality" value="high" />
														  </object>
														</td>
														<td width="3">&nbsp;</td>
														<td width="95" height="81">
														 <object type="application/x-shockwave-flash" data="swf/corporacion_profesionales.swf" width="95" height="81">
																<param name="movie" value="swf/corporacion_profesionales.swf" />
																<param name="quality" value="high" />
														  </object>
														</td>
													</tr>
												</table>
										  </td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
                                      

								  </table>
                  
								</td>
							</tr>
						  
						 </form>
						</table>
				</td>
				<td width="34" bgcolor="#84a6d3" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td bgcolor="#4b73a6"></td>
				<td width="34" bgcolor="#84a6d3" align="left">&nbsp;</td>
			</tr>
		</table>  
	  </td>
  </tr>
  <tr><td colspan="2"><center><p>Sistema desarrollado para Internet Explorer 6.0 y versiones superiores
<br/>Resolucion optima: 1280 x 1024 pixeles</p></center></td></tr>
  <tr><td colspan="2" onClick="">&nbsp;</td></tr>
  
  <tr> 
    <td colspan="2"><img src="pixel_negro.gif" width="100%" height="2"></td>
  </tr>
  
</table>
</td></tr></table>
</body>
</html>
