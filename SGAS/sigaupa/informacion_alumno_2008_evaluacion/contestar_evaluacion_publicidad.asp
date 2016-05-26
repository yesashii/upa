<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
encu_ncorr = "33"
periodo  = "228"

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

nombre_alumno = conectar.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

set botonera = new CFormulario
botonera.Carga_Parametros "contestar_encuesta_otec.xml", "botonera"

nombre_encuesta = conectar.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
instruccion = conectar.consultaUno("Select lower(encu_tinstruccion) from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")


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

c_carr_tdesc = " Select carr_tdesc from alumnos a, ofertas_academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "&_
               " and c.carr_ccod=d.carr_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod <> 9 order by b.peri_ccod desc "
carr_tdesc = conectar.consultaUno(c_carr_tdesc)

c_carr_ccod = " Select ltrim(rtrim(d.carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "&_
              " and c.carr_ccod=d.carr_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod <> 9 order by b.peri_ccod desc "
carr_ccod = conectar.consultaUno(c_carr_ccod)


c_plan_tdesc = " Select plan_tdesc from alumnos a, ofertas_academicas b, especialidades c, carreras d, planes_estudio e "&_
               " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=e.plan_ccod "&_
               " and c.carr_ccod=d.carr_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and a.emat_ccod <> 9 order by b.peri_ccod desc "
plan_tdesc = conectar.consultaUno(c_plan_tdesc)

c_plan_ccod = " Select e.plan_ccod from alumnos a, ofertas_academicas b, especialidades c, carreras d, planes_estudio e "&_
               " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=e.plan_ccod "&_
               " and c.carr_ccod=d.carr_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and a.emat_ccod <> 9 order by b.peri_ccod desc "
plan_ccod = conectar.consultaUno(c_plan_ccod)

'------------------buscamos que datos vamos mostrar en el encabezado de la encuesta
'ya_grabada = conectar.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from evaluacion_docente where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
activar_grabado = false
if carr_ccod="45" then
	activar_grabado = true
end if

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
  if (contestada > 0 )
  { 
	 if(confirm("¿Está seguro que desea grabar la Selección.?")) 
     { document.edicion.method = "POST";
	   document.edicion.action = "encuesta_publicidad_proc.asp";
       document.edicion.submit();
	 }  
  }
  else
   alert("Debe seleccionar algunas asignaturas antes de grabar.");
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
		<td width="100%" align="center"><font size="4" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>ENCUESTA DE PREFERENCIAS PARA PRE-INSCRIPCIÓN DE ASIGNATURAS</strong></font></td>
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
										   <td width="23%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Datos Alumno</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr> 
										<td height="20" width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=q_pers_nrut%>-<%=q_pers_xdv%></font></td>
										<td width="21%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td width="27%"><font size="2" face="Courier New, Courier, mono" color="#496da6">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=nombre_alumno%></font></td>
										<td width="21%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td width="27%"><font size="2" face="Courier New, Courier, mono" color="#496da6">&nbsp;</font></td>
									  </tr>
									  <tr> 
										<td height="20" width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong>
										                            <%=carr_tdesc%>
																  	</font>
										</td>
									  </tr>
									  <tr> 
										<td height="20" width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Plan</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong>
										                            <%=plan_tdesc%>
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
							  contestada = conectar.consultaUno("Select Count(*) from epub_evaluacion_ramos_publicidad where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(encu_ncorr as varchar)='"&encu_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"'")
						   %>
							<input name="p[0][encu_ncorr]" type="hidden" value="<%=encu_ncorr%>">
							<input name="p[0][pers_ncorr_encuestado]" type="hidden" value="<%=pers_ncorr%>">
							<input name="p[0][peri_ccod]" type="hidden" value="<%=periodo%>">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   
                          <td width="13%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Encuesta</strong></font></td>
										   <td width="87%"><hr></td>
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
										 		<tr valign="bottom"> 
												  
                                <td colspan="3"><font size="2" face="Courier New, Courier, mono" color="#496da6">Estimado 
                                  Alumno(a):</font> 
                                  <%if contestada = "S" then%>
                                  <font size="3" face="Courier New, Courier, mono" color="#FF0000"><strong> 
                                  ENCUESTA GRABADA CON TODAS TUS PREFERENCIAS</strong></font> 
                                  <%end if%>
                                </td>
												</tr>
												<tr>
												 
                                <td colspan="3"> <font size="2" face="Courier New, Courier, mono" color="#496da6"> 
                                  La Escuela de Publicidad en su permanente preocupación 
                                  por maximizar la gestión académica, ha elaborado 
                                  la presente encuesta con el 
                                  objetivo de visualizar con una mayor exactitud, 
                                  las preferencias de sus alumnos del plan de 
                                  estudios 2010 en términos de la toma de carga 
                                  académica para el año 2011, lo cual nos permitirá planificar una 
                                  oferta equilibrada de secciones y  
                                  un mejor horario de clases para cada uno de 
                                  sus estudiantes.<br>
								  Al mismo tiempo, este instrumento es un aporte valioso para el análisis de desempeño en la progresión académica de alumnos de 1° y 2° año que optan a asignaturas de Formación Profesional Electiva, dado que se evidencia el abandono de estas asignaturas una vez inscritas en la toma de carga.<br>
								  Les recordamos que no podrán elegir las siguientes asignaturas sin tener aprobado su prerrequisito: Publicidad II, Publicidad III, Módulo IV, Inglés II, Inglés III, Inglés IV y Metodología de la Investigación. </font> </td>
												</tr>
												<tr><td colspan="3">&nbsp;</td></tr>
												<tr>
												 <td colspan="3">
												     <font size="2" face="Courier New, Courier, mono" color="#496da6">
													   <strong>INSTRUCCIONES:</strong>
													 </font>
												  </td>
												</tr>
												<tr>
												 <td colspan="3">
												    <li>
												     <font size="2" face="Courier New, Courier, mono" color="#496da6">
													   a) Lea detenidamente las asignaturas correspondientes a cada semestre indicadas en la encuesta.
													 </font>
												    </li>
												  </td>
												</tr>
												<tr>
												 <td colspan="3">
												    <li> <font size="2" face="Courier New, Courier, mono" color="#496da6"> 
                                    b) Marque sólo 1 de las 3 celdas por asignatura 
                                    de acuerdo a su preferencia de toma de 
                                    carga para el año 2011. </font> </li>
												  </td>
												</tr>
												<tr>
												 <td colspan="3">
												    <li>
												     <font size="2" face="Courier New, Courier, mono" color="#496da6">
													   c) Recuerde que puede inscribir un mínimo de 9 créditos y un máximo de 27 créditos por semestre.
													 </font>
												    </li>
												  </td>
												</tr>
												<tr>
												 <td colspan="3">
												    <li>
												     <font size="2" face="Courier New, Courier, mono" color="#496da6">
													   d) en virtud de lo anterior, al momento de marcar su preferencia considere lo siguiente:
													 </font>
												    </li>
												  </td>
												</tr>
												<tr>
												 <td colspan="3">
												    <font size="2" face="Courier New, Courier, mono" color="#496da6">
													   &nbsp;&nbsp;&nbsp;- El primer casillero implica que <font color="#FF6600">SI</font> inscribiría la asignatura en el 1° semestre 2011.
													 </font>
												  </td>
												</tr>
												<tr>
												 <td colspan="3">
												    <font size="2" face="Courier New, Courier, mono" color="#496da6">
													   &nbsp;&nbsp;&nbsp;- El segundo casillero implica que <font color="#FF6600">TAL VEZ</font> inscribiría la asignatura en el 1° semestre 2011.
													</font>
												  </td>
												</tr>
												<tr>
												 <td colspan="3">
												    <font size="2" face="Courier New, Courier, mono" color="#496da6">
													   &nbsp;&nbsp;&nbsp;- El tercer casillero implica que <font color="#FF6600">NO</font> inscribiría la asignatura en el 1° semestre 2011.
													 </font>
												  </td>
												</tr>
												<tr>  
												  <td colspan="3" height="20">&nbsp;</td>
												</tr> 
												<tr>  
												  <td colspan="3" align="center">
												  	<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#FF6600">
													 <tr>
													    <td width="2%">&nbsp;</td>	
														<td width="96%">
															<font color="#FFFFFF">
															  <strong>IMPORTANTE:<br>ESTA ENCUESTA NO REEMPLAZA LA INSCRIPCIÓN FORMAL DE ASIGNATURAS POR PARTE DEL ALUMNO PARA EL AÑO ACADÉMICO 2011.
															  <font color="#FFFF99">SÓLO ES PARA ESTIMAR LA CANTIDAD DE SECCIONES QUE SE ABRIRÁN DE CADA ASIGNATURA.</font>
															  </strong>
															</font>
														</td>
														<td width="2%">&nbsp;</td>
													 </tr>
													</table>
												  </td>
												</tr> 
												<tr>  
												  <td colspan="3" height="20"><hr></td>
												</tr>
												<tr>  
												  <td colspan="3" height="20" bgcolor="#496da6" align="center"><strong>PLAN 2010</strong></td>
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
																<td width="50"><font  color="#496da6"><strong><center>
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
																<td width="591"><font color="#FF6600"><%=pregunta%></font></td>
												  
																<%if cantid >"0" then
																	escala.Primero
																	while escala.siguiente%>
																	 <td width="50"><center>
																	   <%if contestada <> 0 then
																		 'response.Write("Select resp_ncorr from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and preg_ncorr='"&preg_ncorr&"'")
																		  respuesta = conectar.consultaUno("Select preg_"&contador&" from epub_evaluacion_ramos_publicidad where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and cast(encu_ncorr as varchar)='"&encu_ncorr&"'")  
																		   'response.Write("enca "&respuesta)
																		   if respuesta <> "" and not esVacio(respuesta) then	
																				if cInt(respuesta) = cInt(escala.obtenervalor("resp_ncorr")) then%>
																					<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" checked>
																				<%else%>
																					<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" >
																				<%end if
																			else%>
																			    <input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" >
																		   <%end if%>
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
													<%wend%>
													<tr>
														<td colspan="5" align="left"><font  color="#496da6"><strong>¿CUÁL ES SU PREFERENCIA DE MENCIÓN(ES)?</strong></font></td>
													</tr>
													<tr>
														<td colspan="5">
															<table width="100%" align="left" cellpadding="1" cellspacing="0">
																<TR>
																	<td width="40%" align="left" height="23">Mención Planeación Comunicacional</td>
																	<%chequeado1 = conectar.consultaUno("Select case isnull(mencion_1,0) when 0 then '' else 'checked' end from epub_evaluacion_ramos_publicidad where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and cast(encu_ncorr as varchar)='"&encu_ncorr&"'")%>
																	<td align="left"><input type="checkbox" value="1" name="p[0][mencion_1]" <%=chequeado1%>></td>
																</TR>
																<TR>
																	<td width="40%" align="left" height="23">Mención Marketing de Empresas</td>
																	<%chequeado2 = conectar.consultaUno("Select case isnull(mencion_2,0) when 0 then '' else 'checked' end from epub_evaluacion_ramos_publicidad where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and cast(encu_ncorr as varchar)='"&encu_ncorr&"'")%>
																	<td align="left"><input type="checkbox" value="2" name="p[0][mencion_2]" <%=chequeado2%>></td>
																</TR>
																<TR>
																	<td width="40%" align="left" height="23">Mención Contenidos Creativos</td>
																	<%chequeado3 = conectar.consultaUno("Select case isnull(mencion_3,0) when 0 then '' else 'checked' end from epub_evaluacion_ramos_publicidad where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and cast(encu_ncorr as varchar)='"&encu_ncorr&"'")%>
																	<td align="left"><input type="checkbox" value="3" name="p[0][mencion_3]" <%=chequeado3%>></td>
																</TR>
																<TR>
																	<td width="40%" align="left" height="23">Mención Dirección de Arte</td>
																	<%chequeado4 = conectar.consultaUno("Select case isnull(mencion_4,0) when 0 then '' else 'checked' end from epub_evaluacion_ramos_publicidad where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and cast(encu_ncorr as varchar)='"&encu_ncorr&"'")%>
																	<td align="left"><input type="checkbox" value="4" name="p[0][mencion_4]" <%=chequeado4%>></td>
																</TR>
																<TR>
																	<td width="40%" align="left" height="23">Mención Planificación en Medios Digitales</td>
																	<%chequeado5 = conectar.consultaUno("Select case isnull(mencion_5,0) when 0 then '' else 'checked' end from epub_evaluacion_ramos_publicidad where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and cast(encu_ncorr as varchar)='"&encu_ncorr&"'")%>
																	<td align="left"><input type="checkbox" value="5" name="p[0][mencion_5]" <%=chequeado5%>></td>
																</TR>
																<TR>
																	<td width="4%" align="left" height="23">Aún no lo tengo decidido</td>
																	<%chequeado6 = conectar.consultaUno("Select case isnull(mencion_6,0) when 0 then '' else 'checked' end from epub_evaluacion_ramos_publicidad where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and cast(encu_ncorr as varchar)='"&encu_ncorr&"'")%>
																	<td align="left"><input type="checkbox" value="6" name="p[0][mencion_6]" <%=chequeado6%>></td>
																</TR>
															</table>
														</td>
													</tr>
													<%end if
													%>
													<tr>
														<td colspan="5"><div align="center">&nbsp;</div></td>
												    </tr>
													<tr valign="top">
														<td colspan="5" align="center">
															<table width="20%" border="0">
																<tr valign="middle"> 
																  <td width="50%" align="center">
																  		<%POS_IMAGEN = 0%>
																		<!--<a href="javascript:volver();"
																			onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
																			onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true ">
																			<img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VOLVER A PAGINA ANTERIOR"> 
																		</a>-->
																  </td>
																  <td width="50%" align="center"><% if activar_grabado  then
																                                    POS_IMAGEN = 0 'POS_IMAGEN + 1%>
																		<a href="javascript:_Guardar(this, document.forms['edicion'], 'encuesta_publicidad_proc.asp','', 'validar();', '', 'FALSE');"
																			onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR2.png';return true "
																			onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR1.png';return true ">
																			<img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="GUARDAR EVALUACION"> 
																		</a>
																								<%end if  %>
																 </td>
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

