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

consulta = " select parte_5_1,parte_5_2,parte_5_3,parte_5_4,parte_5_5,parte_5_observaciones " &_
           " from cuestionario_opinion_alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"'"

tabla.Consultar consulta
tabla.siguiente

parte_5_1a = ""
parte_5_1b = ""
parte_5_1c = ""
parte_5_1d = ""
parte_5_1e = ""
parte_5_1f = ""
parte_5_1g = ""
parte_5_1  = tabla.obtenerValor("parte_5_1")
Select Case parte_5_1
Case "1"
    parte_5_1a = "checked"
Case "2"
    parte_5_1b = "checked"
Case "3"
    parte_5_1c = "checked"
Case "4"
    parte_5_1d = "checked"
Case "5"
    parte_5_1e = "checked"
Case "6"
    parte_5_1f = "checked"
Case "0"
    parte_5_1g = "checked"	
End Select

parte_5_2a = ""
parte_5_2b = ""
parte_5_2c = ""
parte_5_2d = ""
parte_5_2e = ""
parte_5_2f = ""
parte_5_2g = ""
parte_5_2  = tabla.obtenerValor("parte_5_2")
Select Case parte_5_2
Case "1"
    parte_5_2a = "checked"
Case "2"
    parte_5_2b = "checked"
Case "3"
    parte_5_2c = "checked"
Case "4"
    parte_5_2d = "checked"
Case "5"
    parte_5_2e = "checked"
Case "6"
    parte_5_2f = "checked"
Case "0"
    parte_5_2g = "checked"	
End Select

parte_5_3a = ""
parte_5_3b = ""
parte_5_3c = ""
parte_5_3d = ""
parte_5_3e = ""
parte_5_3f = ""
parte_5_3g = ""
parte_5_3  = tabla.obtenerValor("parte_5_3")
Select Case parte_5_3
Case "1"
    parte_5_3a = "checked"
Case "2"
    parte_5_3b = "checked"
Case "3"
    parte_5_3c = "checked"
Case "4"
    parte_5_3d = "checked"
Case "5"
    parte_5_3e = "checked"
Case "6"
    parte_5_3f = "checked"
Case "0"
    parte_5_3g = "checked"	
End Select

parte_5_4a = ""
parte_5_4b = ""
parte_5_4c = ""
parte_5_4d = ""
parte_5_4e = ""
parte_5_4f = ""
parte_5_4g = ""
parte_5_4  = tabla.obtenerValor("parte_5_4")
Select Case parte_5_4
Case "1"
    parte_5_4a = "checked"
Case "2"
    parte_5_4b = "checked"
Case "3"
    parte_5_4c = "checked"
Case "4"
    parte_5_4d = "checked"
Case "5"
    parte_5_4e = "checked"
Case "6"
    parte_5_4f = "checked"
Case "0"
    parte_5_4g = "checked"	
End Select

parte_5_5a = ""
parte_5_5b = ""
parte_5_5c = ""
parte_5_5d = ""
parte_5_5e = ""
parte_5_5f = ""
parte_5_5g = ""
parte_5_5  = tabla.obtenerValor("parte_5_5")
Select Case parte_5_5
Case "1"
    parte_5_5a = "checked"
Case "2"
    parte_5_5b = "checked"
Case "3"
    parte_5_5c = "checked"
Case "4"
    parte_5_5d = "checked"
Case "5"
    parte_5_5e = "checked"
Case "6"
    parte_5_5f = "checked"
Case "0"
    parte_5_5g = "checked"	
End Select

parte_5_observaciones  = tabla.obtenerValor("parte_5_observaciones")

 
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
   		document.edicion.submit();
	}
  else
   { 
   		alert("Debe responder todas las preguntas antes de grabar,\n aún faltan preguntas por contestar.");
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
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Cuestionario de Opinión de alumnos</strong></font></td>
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
						<form name="edicion" action="contestar_evaluacion_docente_5_2008_proc.asp" method="post">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="95%"><hr style="color:#4b73a6;"></td>
										   <td width="5%" align="center"><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#990000"><strong>Paso 5/6</strong></font></div></td>
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
													<strong>4° Dimensión Responsabilidad Formal:</strong> Dimensión relacionada con el cumplimiento de aspectos 
													administrativos básicos del quehacer docente para optimizar los procesos de enseñanza y aprendizaje. Se incluyen aquí 
													la puntualidad, asistencia, entrega de trabajos en un plazo prudente u otros.</strong>
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
																		1. El/la docente ¿asistió a realizar sus clases? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Con muy poca frecuencia</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_1" value="1" <%=parte_5_1a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_1" value="2" <%=parte_5_1b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_1" value="3" <%=parte_5_1c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_1" value="4" <%=parte_5_1d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_1" value="5" <%=parte_5_1e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_1" value="6" <%=parte_5_1f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Siempre</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_5_1" value="0" <%=parte_5_1g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		2. Si el/la docente no realizó alguna clase ¿se preocupó de que los estudiantes fuéramos comunicados con anterioridad? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Con muy poca frecuencia</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_2" value="1" <%=parte_5_2a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_2" value="2" <%=parte_5_2b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_2" value="3" <%=parte_5_2c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_2" value="4" <%=parte_5_2d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_2" value="5" <%=parte_5_2e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_2" value="6" <%=parte_5_2f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Siempre</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_5_2" value="0" <%=parte_5_2g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		3. El/la docente ¿fue puntual al comenzar y al finalizar las sesiones de clases?
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy pocas veces fue puntual</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_3" value="1" <%=parte_5_3a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_3" value="2" <%=parte_5_3b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_3" value="3" <%=parte_5_3c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_3" value="4" <%=parte_5_3d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_3" value="5" <%=parte_5_3e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_3" value="6" <%=parte_5_3f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">La mayoría de las veces fue puntual</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_5_3" value="0" <%=parte_5_3g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		4. El/la docente ¿nos comunicó oportunamente fechas importantes como horarios de inicio y término de clases, y salas o 
																		espacios físicos a utilizar?
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">No comunicó la información</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_4" value="1" <%=parte_5_4a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_4" value="2" <%=parte_5_4b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_4" value="3" <%=parte_5_4c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_4" value="4" <%=parte_5_4d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_4" value="5" <%=parte_5_4e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_4" value="6" <%=parte_5_4f%>></td>
												<td width="10%"align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Comunicó toda o la mayoría de la información</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_5_4" value="0" <%=parte_5_4g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		5. El/la docente ¿cumple con los plazos acordados para la entrega de trabajos y pruebas?
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Frecuentemente no cumple los plazos</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_5" value="1" <%=parte_5_5a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_5" value="2" <%=parte_5_5b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_5" value="3" <%=parte_5_5c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_5" value="4" <%=parte_5_5d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_5" value="5" <%=parte_5_5e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_5_5" value="6" <%=parte_5_5f%>></td>
												<td width="10%"align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Cumple los plazos</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_5_5" value="0" <%=parte_5_5g%>></td>
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
													Comentarios, sugerencias u observaciones al docente en esta dimensión: 
												</font>
											</div>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="center"><textarea name="parte_5_observaciones" cols="100" rows="6" id="TO-N"><%=parte_5_observaciones%></textarea></td>
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
														<a href="javascript:_Navegar(this, 'contestar_evaluacion_docente_4_2008.asp', 'FALSE');"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ANTERIOR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ANTERIOR1.png';return true ">
															<img src="imagenes/ANTERIOR1.png" border="0" width="70" height="70" alt="VOLVER A PAGINA ANTERIOR"> 
														</a>
													</td>
												    <td width="32%" align="center">
														<%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:_Navegar(this, 'seleccionar_docente_2008.asp', 'FALSE');"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
															<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
														</a>
													</td>
													<td width="34%" align="center">
														<%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:validar_ingreso();"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SIGUIENTE2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SIGUIENTE1.png';return true ">
															<img src="imagenes/SIGUIENTE1.png" border="0" width="70" height="70" alt="IR A PAGINA SIGUIENTE"> 
														</a>
													</td>
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

