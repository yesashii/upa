<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
v_hora_sys	=	Hour(now())
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
'if v_mes_actual = 12 and v_dia_actual = 9 and v_hora_sys >= 6 and v_hora_sys < 9 then
'	response.Redirect("portada_alumno_mantencion.asp")
'end if

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
 c_encuesta = " select case when convert(datetime,protic.trunc(getDate()),103) >= convert(datetime,'07/04/2014',103) and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,'23/08/2014',103) "&_
              " then 'S' else 'N' end "
 pasa_fecha = conexion.consultaUno(c_encuesta)
 if pasa_fecha = "N" then 
 	activar_ocultos = false
 else
 	activar_ocultos = true
 end if	
 

 pasa_fecha2 = conexion.consultaUno("select case when convert(datetime,protic.trunc(getDate()),103) >= convert(datetime,'14/07/2014',103) and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,'27/07/2014',103) then 'S' else 'N' end")
 if pasa_fecha2 = "N" then 
 	activar_ocultos2 = false
 else
 	 activar_ocultos2 = true
	 'dejamos un código para que grabe automáticamente los promedios al abrir las notas
	 grabo_promedio  = conexion.consultaUno("select count(*) from PROMEDIOS_ALUMNOS_CARRERA where peri_ccod=234")
	 if grabo_promedio = "0" then
		c_graba_promedio = "insert into PROMEDIOS_ALUMNOS_CARRERA "& vbCrLf &_
						   "select distinct a.pers_ncorr,c.carr_ccod,b.peri_ccod, "& vbCrLf &_
						   "(select cast(avg(carg_nnota_final) as decimal(2,1))  "& vbCrLf &_
						   " from cargas_academicas tt, secciones t2, asignaturas t3  "& vbCrLf &_
						   " where tt.matr_ncorr=a.matr_ncorr and isnull(tt.carg_nnota_final,0.0) >= 1.0 "& vbCrLf &_
						   " and tt.secc_ccod=t2.secc_ccod and t2.asig_ccod=t3.asig_ccod and t3.duas_ccod <> 3) as promedio,'automatico' as audi_tusuario, getDate() as audi_fmodificacion "& vbCrLf &_
						   " from alumnos a, ofertas_academicas b, especialidades c "& vbCrLf &_
						   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
						   " and b.peri_ccod=234 and a.alum_nmatricula <> 7777 "& vbCrLf &_
						   " and a.emat_ccod not in (9,6,11) "& vbCrLf &_
						   " and exists (select 1 from cargas_academicas tt, secciones t2, asignaturas t3  "& vbCrLf &_
						   " 			 where tt.matr_ncorr=a.matr_ncorr and isnull(tt.carg_nnota_final,0.0) >= 1.0 "& vbCrLf &_
						   " 			 and tt.secc_ccod=t2.secc_ccod and t2.asig_ccod=t3.asig_ccod and t3.duas_ccod <> 3) "& vbCrLf &_
						   " order by PROMEDIO DESC "
	   conexion.ejecutaS c_graba_promedio
	 end if
 end if
 
 c_mensaje = " select case when getDate() >= '20/06/2013 23:30:00' and getDate() <= '21/06/2013 22:00:00' "&_
              " then 'S' else 'N' end "
 pasa_fecha3 = conexion.consultaUno(c_mensaje)
 if pasa_fecha3 = "N" then 
 	activar_ocultos3 = false
 else
 	activar_ocultos3 = true
 end if	
 

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
									  <tr><td height="20" colspan="4" align="center">&nbsp;
                                       <%if activar_ocultos3 then 'para evaluación docente%>
                                       		<table width="75%" cellpadding="0" cellspacing="0" bgcolor="#FF9933">
                                            <tr>
                                                <td>
                                                    Estimado(a) Alumno(a):<br>
                                                    El servicio de Pacífico Virtual (Moodle) se encontraran en mantenimiento<br>
                                                    Entre 20-06-2013 23:30 hrs. hasta 21-06-2013 22:00 hrs.
                                                    
                                                    Atte.
                                                    Dirección de Tecnologías de la Información
                                                </td>
                                            </tr>
                                            </table>
                                       <%end if%>
                                      </td></tr>
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
                                      Docente 2014-01</strong></font></td>
														<td colspan="3">&nbsp;</td>
													</tr>
													<tr>
														<td align="center" colspan="4" background="../imagenes/degradado.jpg">
														<table width="100%" cellpadding="0" cellspacing="0">
															<tr>
																<td width="25%" align="center"><img width="85" height="59" src="../imagenes/megafonos.png"></td>
																
                                          <td width="75%" align="left">
										            <font color="#0033FF" size="2">Período encuesta docente 2014-01:<br>
                                                       <li><strong>Las Condes  : 28-04-2014 --> <font color="#FF0000">14-08-2014</font>.</strong></li>
													   <li><strong>Melipilla   : 28-04-2014 --> <font color="#FF0000">14-08-2014</font>.</strong></li>
													   <li><strong>La Araucana : 09-06-2014 --> <font color="#FF0000">23-08-2014</font>.</strong></li>
                                                    </font>
													</td>
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
														<td align="center" width="25%" background="../imagenes/degradado.jpg"><font size="2" color="#006600"><strong>Toma de Carga "2014-02"</strong></font></td>
														<td colspan="3"><font size="2" color="#006600"><strong>Sedes y Campus</strong></font></td>
													</tr>
													<tr>
														<td align="center" colspan="4" background="../imagenes/degradado.jpg">
														<table width="100%" cellpadding="0" cellspacing="0">
															<tr>
																<td width="25%" align="center"><img width="85" height="59" src="../imagenes/megafonos.png"></td>
																<td width="75%" align="left"><font color="#006600" size="2">Estimado(a) alumno(a):<br> Ya se encuentra disponible el acceso a toma de carga online, no olvides consultar el calendario de esta actividad para tu escuela (<a href="../doc/calendario_toma_de_carga_2014_02.pdf" target="_blank">AQUI</a>).<br>Todas las Sedes: 14-07-2014 --> 27-07-2014.-</strong></li><br>
														                                                    </font></td>
															</tr>
														</table>
														</td>
													</tr>
													<tr>
														<td align="center" colspan="4"  background="../imagenes/degradado.jpg"><input type="button" name="toma_carga" value="Toma de Carga" onClick="_Guardar(this, document.forms['valida'], 'proc_portada_alumno_toma_carga.asp','', '', '', 'FALSE');"></td>
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
