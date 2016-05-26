<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<% 
'------------------------------------------------------
pers_ncorr = Session("pers_ncorr")
secc_ccod = Session("secc_ccod")
pers_ncorr_profesor	 =  Session("pers_ncorr_profesor")

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set tabla = new CFormulario
tabla.Carga_Parametros "tabla_vacia.xml", "tabla"
tabla.Inicializar conectar

consulta = " select parte_6_1,parte_6_2,parte_6_3,parte_6_4,parte_6_5,parte_6_6,parte_6_observaciones " &_
           " from cuestionario_opinion_alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"'"
'response.Write(consulta)
tabla.Consultar consulta
tabla.siguiente

parte_6_1a = ""
parte_6_1b = ""
parte_6_1c = ""
parte_6_1d = ""
parte_6_1e = ""
parte_6_1f = ""
parte_6_1g = ""
parte_6_1  = tabla.obtenerValor("parte_6_1")
Select Case parte_6_1
Case "1"
    parte_6_1a = "checked"
Case "2"
    parte_6_1b = "checked"
Case "3"
    parte_6_1c = "checked"
Case "4"
    parte_6_1d = "checked"
Case "5"
    parte_6_1e = "checked"
Case "6"
    parte_6_1f = "checked"
Case "0"
    parte_6_1g = "checked"	
End Select

parte_6_2a = ""
parte_6_2b = ""
parte_6_2c = ""
parte_6_2d = ""
parte_6_2e = ""
parte_6_2f = ""
parte_6_2g = ""
parte_6_2  = tabla.obtenerValor("parte_6_2")
Select Case parte_6_2
Case "1"
    parte_6_2a = "checked"
Case "2"
    parte_6_2b = "checked"
Case "3"
    parte_6_2c = "checked"
Case "4"
    parte_6_2d = "checked"
Case "5"
    parte_6_2e = "checked"
Case "6"
    parte_6_2f = "checked"
Case "0"
    parte_6_2g = "checked"	
End Select

parte_6_3a = ""
parte_6_3b = ""
parte_6_3c = ""
parte_6_3d = ""
parte_6_3e = ""
parte_6_3f = ""
parte_6_3g = ""
parte_6_3  = tabla.obtenerValor("parte_6_3")
Select Case parte_6_3
Case "1"
    parte_6_3a = "checked"
Case "2"
    parte_6_3b = "checked"
Case "3"
    parte_6_3c = "checked"
Case "4"
    parte_6_3d = "checked"
Case "5"
    parte_6_3e = "checked"
Case "6"
    parte_6_3f = "checked"
Case "0"
    parte_6_3g = "checked"	
End Select

parte_6_4a = ""
parte_6_4b = ""
parte_6_4c = ""
parte_6_4d = ""
parte_6_4e = ""
parte_6_4f = ""
parte_6_4g = ""
parte_6_4  = tabla.obtenerValor("parte_6_4")
Select Case parte_6_4
Case "1"
    parte_6_4a = "checked"
Case "2"
    parte_6_4b = "checked"
Case "3"
    parte_6_4c = "checked"
Case "4"
    parte_6_4d = "checked"
Case "5"
    parte_6_4e = "checked"
Case "6"
    parte_6_4f = "checked"
Case "0"
    parte_6_4g = "checked"	
End Select

parte_6_5a = ""
parte_6_5b = ""
parte_6_5c = ""
parte_6_5d = ""
parte_6_5e = ""
parte_6_5f = ""
parte_6_5g = ""
parte_6_5  = tabla.obtenerValor("parte_6_5")
Select Case parte_6_5
Case "1"
    parte_6_5a = "checked"
Case "2"
    parte_6_5b = "checked"
Case "3"
    parte_6_5c = "checked"
Case "4"
    parte_6_5d = "checked"
Case "5"
    parte_6_5e = "checked"
Case "6"
    parte_6_5f = "checked"
Case "0"
    parte_6_5g = "checked"	
End Select

parte_6_6a = ""
parte_6_6b = ""
parte_6_6c = ""
parte_6_6d = ""
parte_6_6e = ""
parte_6_6f = ""
parte_6_6g = ""
parte_6_6  = tabla.obtenerValor("parte_6_6")
Select Case parte_6_6
Case "1"
    parte_6_6a = "checked"
Case "2"
    parte_6_6b = "checked"
Case "3"
    parte_6_6c = "checked"
Case "4"
    parte_6_6d = "checked"
Case "5"
    parte_6_6e = "checked"
Case "6"
    parte_6_6f = "checked"
Case "0"
    parte_6_6g = "checked"	
End Select

parte_6_observaciones  = tabla.obtenerValor("parte_6_observaciones")


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=nombre_encuesta%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function volver()
{
   location.href ="seleccionar_docente.asp";
}
function direccionar(valor)
{var cadena;
 var secc_ccod='<%=secc_ccod%>';
 var pers_ncorr_profesor='<%=pers_ncorr_profesor%>';
 location.href="contestar_encuesta2.asp?encu_ncorr="+valor+"&secc_ccod="+secc_ccod+"&pers_ncorr_docente="+pers_ncorr_profesor;
}
function validar_ingreso()
{
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor = 7;
  //alert("divisor= "+divisor);
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
    elemento=document.edicion.elements[i];
  	if (elemento.type=="radio")
  		{
		  cant_radios++;
		  if(elemento.checked)
		     {contestada++;}
  		}
  }
  if (contestada==(cant_radios/divisor))
   {
		if (confirm("Est� seguro que desea cerrar la evaluaci�n de este docente?,\nsi continua no podr� realizar nuevos cambios en ella"))
			{document.edicion.submit();}
	}
  else
   { 
   		alert("Debe responder todas las preguntas antes de grabar,\n a�n faltan preguntas por contestar.");
	}
}
</script>
<style type="text/css">
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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Cuestionario de Opini�n de alumnos</strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Antecedentes educacionales-->
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
						<form name="edicion" action="contestar_evaluacion_docente_6_2008_proc.asp" method="post">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="95%"><hr style="color:#4b73a6;"></td>
										   <td width="5%" align="center"><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#990000"><strong>Paso 6/6</strong></font></div></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="98%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<div align="justify">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													<strong>5� Dimensi�n Compromiso con la Asignatura:</strong> En esta dimensi�n se busca que el estudiante se pronuncie respecto de su grado de 
													        responsabilidad para con la asignatura.</strong>
												</font>
											</div>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="center">
											<table width="100%" align="center" cellpadding="0" cellspacing="0" border="1" bordercolor="#4b73a6">
											<tr>
												<td width="50%">&nbsp;</td>
												<td width="10%">&nbsp;</td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">1</font></td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">2</font></td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">3</font></td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">4</font></td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">5</font></td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">6</font></td>
												<td width="10%">&nbsp;</td>
												<td width="6%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">No se aplica</font></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		1. Mi nivel de asistencia a clases, en relaci�n al n�mero de sesiones realizadas efectivamente, fue�
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy bajo</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_1" value="1" <%=parte_6_1a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_1" value="2" <%=parte_6_1b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_1" value="3" <%=parte_6_1c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_1" value="4" <%=parte_6_1d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_1" value="5" <%=parte_6_1e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_1" value="6" <%=parte_6_1f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy alto</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_6_1" value="0" <%=parte_6_1g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		2. �Cumpl� con los requerimientos acad�micos del curso, tales como leer los documentos propuestos, realizar los talleres, trabajos grupales, entre otros? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">S�lo cumpl� con una m�nima parte</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_2" value="1" <%=parte_6_2a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_2" value="2" <%=parte_6_2b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_2" value="3" <%=parte_6_2c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_2" value="4" <%=parte_6_2d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_2" value="5" <%=parte_6_2e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_2" value="6" <%=parte_6_2f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Cumpl� con la mayor parte de los requerimientos</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_6_2" value="0" <%=parte_6_2g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		3. �En qu� grado particip� en el desarrollo de las clases, por ejemplo, emitiendo opiniones, haciendo preguntas, 
																		aportando ejemplos, materiales adicionales, entre otros? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Particip� muy poco</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_3" value="1" <%=parte_6_3a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_3" value="2" <%=parte_6_3b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_3" value="3" <%=parte_6_3c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_3" value="4" <%=parte_6_3d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_3" value="5" <%=parte_6_3e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_3" value="6" <%=parte_6_3f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Particip� activamente</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_6_3" value="0" <%=parte_6_3g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		4. �Utilic� las instancias de participaci�n en la asignatura que otorg� el profesor, por ejemplo: preguntas en clases,  ayudant�as, etc.? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">No las utilic�</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_4" value="1" <%=parte_6_4a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_4" value="2" <%=parte_6_4b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_4" value="3" <%=parte_6_4c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_4" value="4" <%=parte_6_4d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_4" value="5" <%=parte_6_4e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_4" value="6" <%=parte_6_4f%>></td>
												<td width="10%"align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Siempre las utilic�</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_6_4" value="0" <%=parte_6_4g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    
                                  <div align="justify"> 5. Regularmente llego 
                                    a la hora de inicio y termino de la clase. 
                                  </div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Fui muy poco puntual</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_5" value="1" <%=parte_6_5a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_5" value="2" <%=parte_6_5b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_5" value="3" <%=parte_6_5c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_5" value="4" <%=parte_6_5d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_5" value="5" <%=parte_6_5e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_5" value="6" <%=parte_6_5f%>></td>
												<td width="10%"align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Fui muy puntual</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_6_5" value="0" <%=parte_6_5g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		6. �Qu� cantidad de tiempo (horas) fuera del horario de clases le dedique a esta asignatura?
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy poco</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_6" value="1" <%=parte_6_6a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_6" value="2" <%=parte_6_6b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_6" value="3" <%=parte_6_6c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_6" value="4" <%=parte_6_6d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_6" value="5" <%=parte_6_6e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_6_6" value="6" <%=parte_6_6f%>></td>
												<td width="10%"align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muchas</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_6_6" value="0" <%=parte_6_6g%>></td>
											</tr>
																				
											</table>
											
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<div align="justify">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													Comentarios, sugerencias u observaciones al docente en esta dimensi�n: 
												</font>
											</div>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="center"><textarea name="parte_6_observaciones" cols="100" rows="6" id="TO-S"><%=parte_6_observaciones%></textarea></td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="center">
											<table width="40%" cellpadding="0" cellspacing="0">
												<tr>
												<td width="34%" align="center">
														<%POS_IMAGEN = 0%>
														<a href="javascript:_Navegar(this, 'contestar_evaluacion_docente_5_2008.asp', 'FALSE');"
															onmouseover="window.status='bot�n pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ANTERIOR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ANTERIOR1.png';return true ">
															<img src="imagenes/ANTERIOR1.png" border="0" width="70" height="70" alt="VOLVER A PAGINA ANTERIOR"> 
														</a>
													</td>
												    <td width="32%" align="center">
														<%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:_Navegar(this, 'seleccionar_docente_2008.asp', 'FALSE');"
															onmouseover="window.status='bot�n pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
															<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
														</a>
													</td>
													<td width="34%" align="center">
													    <%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:validar_ingreso()"
															onmouseover="window.status='bot�n pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/CERRAR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/CERRAR1.png';return true ">
															<img src="imagenes/CERRAR1.png" border="0" width="70" height="70" alt="CERRAR ENCUESTA"> 
														</a></td>
												</tr>
											</table>
										</td>
									</tr>
									</table>
								</td>
							</tr>
						 </form>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>
</center>
</body>
</html>

