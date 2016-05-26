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

consulta = " select parte_3_1,parte_3_2,parte_3_3,parte_3_4,parte_3_observaciones " &_
           " from cuestionario_opinion_alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"'"

tabla.Consultar consulta
tabla.siguiente

parte_3_1a = ""
parte_3_1b = ""
parte_3_1c = ""
parte_3_1d = ""
parte_3_1e = ""
parte_3_1f = ""
parte_3_1g = ""
parte_3_1  = tabla.obtenerValor("parte_3_1")
Select Case parte_3_1
Case "1"
    parte_3_1a = "checked"
Case "2"
    parte_3_1b = "checked"
Case "3"
    parte_3_1c = "checked"
Case "4"
    parte_3_1d = "checked"
Case "5"
    parte_3_1e = "checked"
Case "6"
    parte_3_1f = "checked"
Case "0"
    parte_3_1g = "checked"	
End Select

parte_3_2a = ""
parte_3_2b = ""
parte_3_2c = ""
parte_3_2d = ""
parte_3_2e = ""
parte_3_2f = ""
parte_3_2g = ""
parte_3_2  = tabla.obtenerValor("parte_3_2")
Select Case parte_3_2
Case "1"
    parte_3_2a = "checked"
Case "2"
    parte_3_2b = "checked"
Case "3"
    parte_3_2c = "checked"
Case "4"
    parte_3_2d = "checked"
Case "5"
    parte_3_2e = "checked"
Case "6"
    parte_3_2f = "checked"
Case "0"
    parte_3_2g = "checked"	
End Select

parte_3_3a = ""
parte_3_3b = ""
parte_3_3c = ""
parte_3_3d = ""
parte_3_3e = ""
parte_3_3f = ""
parte_3_3g = ""
parte_3_3  = tabla.obtenerValor("parte_3_3")
Select Case parte_3_3
Case "1"
    parte_3_3a = "checked"
Case "2"
    parte_3_3b = "checked"
Case "3"
    parte_3_3c = "checked"
Case "4"
    parte_3_3d = "checked"
Case "5"
    parte_3_3e = "checked"
Case "6"
    parte_3_3f = "checked"
Case "0"
    parte_3_3g = "checked"	
End Select

parte_3_4a = ""
parte_3_4b = ""
parte_3_4c = ""
parte_3_4d = ""
parte_3_4e = ""
parte_3_4f = ""
parte_3_4g = ""
parte_3_4  = tabla.obtenerValor("parte_3_4")
Select Case parte_3_4
Case "1"
    parte_3_4a = "checked"
Case "2"
    parte_3_4b = "checked"
Case "3"
    parte_3_4c = "checked"
Case "4"
    parte_3_4d = "checked"
Case "5"
    parte_3_4e = "checked"
Case "6"
    parte_3_4f = "checked"
Case "0"
    parte_3_4g = "checked"	
End Select

parte_3_observaciones  = tabla.obtenerValor("parte_3_observaciones")
 
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
						<form name="edicion" action="contestar_evaluacion_docente_3_2008_proc.asp" method="post">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="95%"><hr style="color:#4b73a6;"></td>
										   <td width="5%" align="center"><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#990000"><strong>Paso 3/6</strong></font></div></td>
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
													<strong>2º Dimensión Evaluación para el aprendizaje:</strong> En esta dimensión se considera el proceso
													 que el/la docente desarrolla para que sus estudiantes evidencien sus aprendizajes y la forma en que 
													 utiliza esa información, tanto para mejorar el aprendizaje y la enseñanza, como para otorgar 
													 calificaciones.</strong>
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
																		1. El/la docente ¿comunicó claramente los criterios de evaluación y calificación con los que seremos evaluados? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">No comunicó o lo hizo de forma muy vaga</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_1" value="1" <%=parte_3_1a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_1" value="2" <%=parte_3_1b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_1" value="3" <%=parte_3_1c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_1" value="4" <%=parte_3_1d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_1" value="5" <%=parte_3_1e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_1" value="6" <%=parte_3_1f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Comunicó con total claridad</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_3_1" value="0" <%=parte_3_1g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		2. Los procedimientos de evaluación utilizados por el/la docente ¿fueron coherentes con los contenidos tratados 
																		   y las actividades  desarrolladas durante el curso? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Poco coherentes</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_2" value="1" <%=parte_3_2a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_2" value="2" <%=parte_3_2b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_2" value="3" <%=parte_3_2c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_2" value="4" <%=parte_3_2d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_2" value="5" <%=parte_3_2e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_2" value="6" <%=parte_3_2f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy coherentes</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_3_2" value="0" <%=parte_3_2g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		3. Las instrucciones e indicaciones de los instrumentos de evaluación  aplicados por el/la docente ¿han sido claras y precisas para su desarrollo?
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Poco claras e imprecisas</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_3" value="1" <%=parte_3_3a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_3" value="2" <%=parte_3_3b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_3" value="3" <%=parte_3_3c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_3" value="4" <%=parte_3_3d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_3" value="5" <%=parte_3_3e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_3" value="6" <%=parte_3_3f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy claras y precisas</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_3_3" value="0" <%=parte_3_3g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		4. El análisis y comentarios de los resultados de las evaluaciones ¿fueron entregados en un tiempo oportuno, me ayudaron a ver mis 
																		   errores y así mejorar mis aprendizajes?
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Se otorgó fuera de tiempo y/o fue poco valioso</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_4" value="1" <%=parte_3_4a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_4" value="2" <%=parte_3_4b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_4" value="3" <%=parte_3_4c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_4" value="4" <%=parte_3_4d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_4" value="5" <%=parte_3_4e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_3_4" value="6" <%=parte_3_4f%>></td>
												<td width="10%"align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Fue oportuno y valioso</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_3_4" value="0" <%=parte_3_4g%>></td>
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
										<td width="100%" align="center"><textarea name="parte_3_observaciones" cols="100" rows="6" id="TO-S"><%=parte_3_observaciones%></textarea></td>
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
														<a href="javascript:_Navegar(this, 'contestar_evaluacion_docente_2_2008.asp', 'FALSE');"
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

