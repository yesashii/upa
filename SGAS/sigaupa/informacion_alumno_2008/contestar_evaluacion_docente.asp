<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
encu_ncorr = "15"
pers_ncorr = request.querystring("pers_ncorr")
secc_ccod = request.querystring("secc_ccod")
pers_ncorr_profesor = request.querystring("pers_ncorr_docente")

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar
 
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conectar.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

if pers_ncorr = "" then
	pers_ncorr= conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

peri_ccod_encuesta =  conectar.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
duas_ccod_encuesta =  conectar.consultaUno("select duas_ccod from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(secc_ccod as varchar)='"&secc_ccod&"'")
'response.Write(peri_ccod_encuesta & " duas_ccod "&duas_ccod_encuesta)
if cint(peri_ccod_encuesta) > 202  then
	encu_ncorr = "23"
end if 


cantidad_encuestas="1"

if cantidad_encuestas = "0" then
encu_ncorr=""
end if

set botonera = new CFormulario
botonera.Carga_Parametros "contestar_encuesta_otec.xml", "botonera"
cantidad_encuestas=cInt(cantidad_encuestas)
if cantidad_encuestas = "0" then
	mensaje="Aún no existen encuestas disponibles para ser contestadas por Usted."
else
    if cantidad_encuestas = "1" then
		 encu_ncorr="15"
		 if cint(peri_ccod_encuesta) > 202 then
			encu_ncorr = "23"
		 end if 
	 end if
end if

nombre_encuesta = conectar.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
instruccion = conectar.consultaUno("Select encu_tinstruccion from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")


set escala= new cformulario
escala.carga_parametros "tabla_vacia.xml","tabla"
escala.inicializar conectar
Query_escala = "select  resp_ncorr,resp_tabrev,protic.initcap(resp_tdesc) as resp_tdesc from respuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by resp_norden"
escala.consultar Query_escala
cantid = escala.nroFilas

set criterios= new cformulario
criterios.carga_parametros "tabla_vacia.xml","tabla"
criterios.inicializar conectar
Query_criterios = "select  crit_ncorr,crit_tdesc from criterios where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by crit_norden"
criterios.consultar Query_criterios
cantid_criterios = criterios.nroFilas

'------------------buscamos que datos vamos mostrar en el encabezado de la encuesta
carrera=conectar.consultaUno("select protic.initCap(carr_tdesc) from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
asignatura=conectar.consultaUno("select ltrim(rtrim(b.asig_ccod))+' ' + protic.initCap(b.asig_tdesc) from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'") 
seccion=conectar.consultaUno("select secc_tdesc from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
carr_ccod=conectar.consultaUno("select carr_ccod from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
periodo=conectar.consultaUno("select peri_ccod from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
ano_ingreso = conectar.consultaUno("select protic.ano_ingreso_carrera("&pers_ncorr&",'"&carr_ccod&"')")
profesor = conectar.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_profesor&"'")
nota_esperada = conectar.consultaUno("Select replace(promedio_esperado,',','.') from evaluacion_docente where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
asistencia_esperada = conectar.consultaUno("Select replace(asistencia_esperado,',','.') from evaluacion_docente where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
lo_recomendaria = conectar.consultaUno("Select lo_recomendaria from evaluacion_docente where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=nombre_encuesta%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
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


function validar()
{ var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=<%=cantid%>;
  //alert("divisor= "+divisor);
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if (elemento.type=="radio")
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
  if (divisor!=0)
  {
  if (contestada==(cant_radios/divisor))
  { 
	 if(confirm("Está seguro que desea grabar la Evaluación.\n\nUna vez guardada la encuesta, no podrá realizar cambio alguno en ella.")) 
     { document.edicion.method = "POST";
	   document.edicion.action = "evaluacion_docente_proc.asp";
       document.edicion.submit();
	 }  
  }
  else
   alert("Debe responder la encuesta antes de grabar,\n aún faltan preguntas por responder.");
  }
  else
     alert("Esta encuesta no ha sido creada completamente aún, No la puede contestar");

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
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong><%=nombre_encuesta%></strong></font></td>
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
						<form name="buscador" action="notas_alumno.asp">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="23%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Datos Asignatura</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr> 
										<td height="20" width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=carrera%></font></td>
										<td width="21%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Sección</strong></font></td>
										<td width="27%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=seccion%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Asignatura</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=asignatura%></font></td>
										<td width="21%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Año de ingreso</strong></font></td>
										<td width="27%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=ano_ingreso%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Profesor</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong>
										                            <%=profesor%>
																  	</font>
										</td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
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
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
						<form name="edicion">
						   <% 
							  contestada = conectar.consultaUno("Select Count(*) from evaluacion_docente where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
							  
							%>
							<input name="p[0][encu_ncorr]" type="hidden" value="<%=encu_ncorr%>">
							<input name="p[0][pers_ncorr_encuestado]" type="hidden" value="<%=pers_ncorr%>">
							<input name="p[0][pers_ncorr_destino]" type="hidden" value="<%=pers_ncorr_profesor%>">
							<input name="p[0][secc_ccod]" type="hidden" value="<%=secc_ccod%>">
							<input name="p[0][peri_ccod]" type="hidden" value="<%=periodo%>">
						
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Encuesta Docente</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="95%" border="0" cellpadding="0" cellspacing="0">
									  <tr>
									     <td height="20" align="left">
										 	<table width="100%"  border="0" align="center">
												<tr> 
												  <td colspan="3">&nbsp;</td>
												</tr>
										 		<tr> 
												  <td colspan="3"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>INSTRUCCIONES : </strong>Estimado Alumno (a):</font></td>
												</tr>
												<tr>  
												  <td colspan="3"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=instruccion%></font></td>
												</tr>
												<tr>  
												  <td colspan="3" height="20">&nbsp;</td>
												</tr> 
												<%if cantid > "0" then
												  while escala.siguiente
														abrev = escala.obtenervalor("resp_tabrev")
														texto= escala.obtenervalor("resp_tdesc")						
												%> 
												<tr>  
												   <td width="3%"><div align="left"><font color="#496da6"><strong><%=abrev%></strong></font></div></td>
												   <td width="3%"><font color="#496da6"><strong><center>:</center></strong></font></td>
												   <td width="94%"><div align="left"><font color="#496da6"><strong><%=texto%></strong></font></div></td>
												</tr>
												<%
												wend
												end if
												%>
												<tr>  
												  <td colspan="3" height="20"><hr></td>
												</tr>
												<tr>  
												  <td colspan="3">
														<table width="100%" border="0">
															<tr>
																<td width="55%" align="left"><font  color="#496da6"><strong>Usted espera obtener en esta asignatura un promedio de : </strong></font></td>
																<td align="left"><input type="text" name="p[0][promedio_esperado]" value="<%=nota_esperada%>" size="10" maxlength="3" id="NT-N">(ejem: 5.0)</td>
															</tr>
															<tr>
																<td width="55%" align="left"><font color="#496da6"><strong>Aproximadamente su porcentaje de asistencia es de : </strong></font></td>
																<td align="left"><input type="text" name="p[0][asistencia_esperado]" value="<%=asistencia_esperada%>" size="10" maxlength="3" id="NU-N">(%)</td>
															</tr>
															<tr>
																<td width="55%" align="left"><font color="#496da6"><strong>Usted recomendaría a este profesor : </strong></font></td>
																<td align="left">  <select name='p[0][lo_recomendaria]' id="TO-N">
																						<option value=''>Respuesta</option>
																						<%if lo_recomendaria="SI" then%>
																						    <option value='SI' selected>SI</option>
																						<%else%>
																							<option value='SI'>SI</option>
																						<%end if%> 	
																						<%if lo_recomendaria="NO" then%>
																						    <option value='NO' selected>NO</option>
																						<%else%>
																							<option value='NO'>NO</option>
																						<%end if%>
																					</select>
																</td>
															</tr>
															<tr>
																<td colspan="2" align="center">
																<table width="100%" border="1" bordercolor="#496DA6">
																	<tr>
																		 <td><font color="#000000"><strong>Para evitar problemas al momento de grabar, no olvidar que la nota esperada debe ser separada por un punto ".", y que la asistencia corresponde a un número entero SIN el símbolo "%".</strong></font>
																		 </td>
																	</tr>
																</table>
																</td>
															</tr>
														</table>
												  </td>
												</tr>
												<tr>  
												  <td colspan="3" height="20"><hr></td>
												</tr> 
											  </table>
											  <table width="100%" border="0">
											  <tr> 
												<td width="5%"> 
												</td>
												<td width="6%">&nbsp; </td>
												<td width="75%">&nbsp;</td>
												<td width="14%">&nbsp;</td>
											  </tr>
											</table>	
											<table width="100%"  border="0" align="center">
											   <%if cantid_criterios >"0" then
													contador=1
													while criterios.siguiente
															ncorr = criterios.obtenervalor("crit_ncorr")
															'response.Write("ncorr= "&ncorr&" ")
															titulo= criterios.obtenervalor("crit_tdesc")						
													%>  
													<tr> 
														<td colspan="3"><font  color="#496da6"><strong><%=titulo%></strong></font></td>
														
														<%if cantid >"0" then
															escala.Primero
															while escala.siguiente
																abrev = escala.obtenervalor("resp_tabrev")%>
																<td width="20"><font  color="#496da6"><strong><center>
																<%response.Write(abrev)		
																%></center></strong></font>
																</td>
															<%wend
														end if%>
													<td width="2">&nbsp;</td>	
													</tr>
													<%
													set preguntas= new cformulario
													preguntas.carga_parametros "tabla_vacia.xml","tabla"
													preguntas.inicializar conectar
													Query_preguntas = "select  preg_ncorr,preg_ccod,protic.initCap(preg_tdesc) as preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
													preguntas.consultar Query_preguntas
													cantid_preguntas = preguntas.nroFilas
													'response.Write("ncorr= "&ncorr&" cantidad_preguntas "&cantid_preguntas)
														if cantid_preguntas >"0" then
															while preguntas.siguiente
																'response.Write("sql= "&Query_preguntas)
																orden = preguntas.obtenervalor("preg_norden")
																pregunta= preguntas.obtenervalor("preg_tdesc")						
																ccod=preguntas.obtenervalor("preg_ccod")						
																preg_ncorr=preguntas.obtenervalor("preg_ncorr")						
																%>  
																<tr> 
																<td width="18" align="right"><font  color="#496da6"><strong><%=contador%></strong></font></td>
																<td width="17"><font  color="#496da6"><%=".-"%></font></td>
																<td width="591"><%=pregunta%></td>
												  
																<%if cantid >"0" then
																	escala.Primero
																	while escala.siguiente%>
																	 <td width="20"><center>
																	   <%if contestada <> 0 then
																		 'response.Write("Select resp_ncorr from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and preg_ncorr='"&preg_ncorr&"'")
																		  respuesta = conectar.consultaUno("Select preg_"&contador&" from evaluacion_docente where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")  
																		   'response.Write("enca "&respuesta)
																		   if respuesta <> "" and not esVacio(respuesta) then	
																				if cInt(respuesta) = cInt(escala.obtenervalor("resp_ncorr")) then%>
																					<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" checked>
																				<%else%>
																					<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" disabled>
																				<%end if
																		   end if%>
																	   <%else%>
																			<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>">
																	  <%end if%>
																	  </center></td>
																	<%wend
																end if%>
																<td width="2">&nbsp;</td>	
																</tr>
															<%contador=contador+1 
															wend
														end if
														Query_preguntas=""%>
														
													<tr>
													<td colspan="5">&nbsp;</td>
													</tr>
													<%wend 
													end if
													%>
													<tr>
														<td colspan="5"><div align="center"><font  color="#496da6"><strong>Escriba sus comentarios, observaciones y/o sugerencias:</strong></font></div></td>
												    </tr>
												    <tr>
														<td colspan="5"><div align="center">&nbsp;</div></td>
												    </tr>
												    <tr>
													   <td colspan="5"><div align="center">
																					<%respuesta = conectar.consultaUno("Select observaciones from evaluacion_docente where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")%>
																					<textarea name="p[0][observaciones]" cols="100" rows="10" id="TO-N"><%=respuesta%></textarea>
																	  </div>
													   </td>
												   </tr>
												    <tr>
														<td colspan="5"><div align="center">&nbsp;</div></td>
												    </tr>
													<tr valign="top">
														<td colspan="5" align="center">
															<table width="20%" border="0">
																<tr valign="middle"> 
																  <td width="50%" align="center">
																  		<%POS_IMAGEN = 0%>
																		<a href="javascript:volver();"
																			onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
																			onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true ">
																			<img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VOLVER A PAGINA ANTERIOR"> 
																		</a>
																  </td>
																  <td width="50%" align="center"><% if contestada = 0  then
																                                    POS_IMAGEN = POS_IMAGEN + 1%>
																		<a href="javascript:_Guardar(this, document.forms['edicion'], 'encuesta_otec_proc.asp','', 'validar();', '', 'FALSE');"
																			onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR2.png';return true "
																			onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR1.png';return true ">
																			<img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="GUARDAR EVALUACION"> 
																		</a>
																	<%end if  %> </td>
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

