<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_2015.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<% 
'------------------------------------------------------


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
 
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")


if q_pers_nrut="" then
	 q_pers_nrut = negocio.obtenerUsuario
	 'q_pers_nrut="16125125"
	 'response.Write("rut: "&q_pers_nrut)
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

pers_ncorr_temporal=conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

consulta_periodo=" select max(b.peri_ccod) "&_
                 " from alumnos a, ofertas_academicas b "&_
				 " where a.ofer_ncorr = b.ofer_ncorr  and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.emat_ccod in (1,2,4,8,10,13)" &_
				 " and exists (select 1 from cargas_academicas carg where carg.matr_ncorr= a.matr_ncorr ) "
				 
q_peri_ccod = conexion.consultaUno(consulta_periodo)
'response.Write(q_peri_ccod)
'q_peri_ccod = "222"
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_Academicos where  cast(peri_ccod as varchar)='"&q_peri_ccod&"'")

if matr_ncorr = "" then
	consulta_matr=" Select top 1 b.matr_ncorr from alumnos b, ofertas_Academicas c" &_
	              " where b.ofer_ncorr=c.ofer_ncorr and emat_ccod in (1,2,4,8,10,13) "&_
				  " and exists (select 1 from cargas_academicas carg where carg.matr_ncorr = b.matr_ncorr)" & vbCrLf &_
				  " and cast(c.peri_ccod as varchar)='"&q_peri_ccod&"' and cast(b.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'"
				  	
	matr_ncorr= conexion.consultaUno(consulta_matr)	
end if

carrera = conexion.consultaUno("Select carr_ccod from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "seleccionar_docente.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "seleccionar_docente.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.siguiente

f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "seleccionar_docente.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           " e.carr_tdesc as carrera, protic.ano_ingreso_carrera(b.pers_ncorr, d.carr_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d,carreras e" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod and d.carr_ccod = e.carr_ccod" & vbCrLf &_
		   "  and cast(d.carr_ccod as varchar)='"&carrera&"'" & vbCrLf &_
		   "  and emat_ccod in (1,2,4,8,10,13) " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
'response.Write(consulta)
'response.End()
f_encabezado.Consultar consulta
f_encabezado.Siguiente
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

'---------------------------------------------------------------------------------------------------
set f_ramos = new CFormulario
f_ramos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_ramos.Inicializar conexion
'response.Write(carrera)			
consulta2 = "  select distinct e.asig_ccod,f.asig_tdesc,protic.initcap(i.pers_tnombre + ' ' + i.pers_tape_paterno) as docente,e.secc_ccod,i.pers_ncorr, " & vbCrLf &_
			"  case c.plec_ccod when 1 then '1er Sem' when 2 then '2do Sem' when 3 then '3er Tri' end as semestre " & vbCrLf &_
			"  from alumnos a, ofertas_academicas b,periodos_academicos c,cargas_academicas d, " & vbCrLf &_
			"       secciones e,asignaturas f,bloques_horarios g, bloques_profesores h,personas i " & vbCrLf &_
			"  where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"' " & vbCrLf &_
			"  and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
			"  and b.peri_ccod = c.peri_ccod and c.PERI_CCOD="&q_peri_ccod&" and cast(c.anos_ccod as varchar)='"&anos_ccod&"' and c.plec_ccod in (1,2,3) " & vbCrLf &_
			"  and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod " & vbCrLf &_
			"  and e.asig_ccod=f.asig_ccod and e.secc_ccod=g.secc_ccod  " & vbCrLf &_
			"  and g.bloq_ccod=h.bloq_ccod and h.tpro_ccod=1 " & vbCrLf &_
			"  and h.pers_ncorr=i.pers_ncorr " & vbCrLf &_
			"  and not exists (select 1 from convalidaciones conv where conv.matr_ncorr=a.matr_ncorr and conv.asig_ccod=e.asig_ccod) " & vbCrLf &_
			"and e.ASIG_CCOD not in (select ASIG_CCOD from asignaturas_no_encuestadas_2015)" & vbCrLf &_
			"  order by semestre"
			
'response.Write("<pre>"&consulta2&"</pre>")
	
f_ramos.Consultar consulta2

nro_profes = f_ramos.nroFilas
'response.Write("nro_filas: "&nro_profes)
'response.End()
cont = 0
for i=1 to nro_profes
	f_ramos.siguiente
	realizo_encuesta = conexion.consultaUno("select distinct secc_ccod from evaluacion_docente_alumnos_2015 where secc_ccod="&f_ramos.Obtenervalor("secc_ccod")&" and pers_ncorr="&pers_ncorr_temporal&" and pers_ncorr_profesor="&f_ramos.Obtenervalor("pers_ncorr")&"")
	
	'response.Write("select distinct secc_ccod from evaluacion_docente_alumnos_2015 where secc_ccod="&f_ramos.Obtenervalor("secc_ccod")&" and pers_ncorr="&pers_ncorr_temporal&" and pers_ncorr_profesor="&f_ramos.Obtenervalor("pers_ncorr")&"")
	'response.End()
	'response.Write("realizo:"&realizo_encuesta)
	
	if realizo_encuesta <> "" then
		cont = cont+1
	end if
'	response.Write("<br>"&realizo_ecuesta&"<br>")
next
if cont = nro_profes then
	Response.Redirect("encuesta_2015_fin.asp?origen=1")
end if

'while f_ramos.siguiente
'	secc_ccod = f_ramos.obtenerValor("secc_ccod")
'	pers_ncorr_profesor = f_ramos.obtenerValor("pers_ncorr")
'	asig_ccod = f_ramos.obtenerValor("asig_ccod")
'	asig_tdesc = f_ramos.obtenerValor("asig_tdesc")
'	periodo = f_ramos.obtenerValor("semestre")
'	docente = f_ramos.obtenerValor("docente")
'	encuestado = f_ramos.obtenerValor("encuestado")
'	antigua = conexion.consultaUno("select count(*) from evaluacion_docente where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr_temporal&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
'wend
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Evaluaci&oacute;n docente</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
var t_parametros;

function Inicio()
{
	t_parametros = new CTabla("p")
}

function dibujar(formulario){
	document.getElementById("texto_alerta").style.visibility="visible";
	formulario.submit();
}

function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nComo una forma de modernizar y entregar mayor flexibilidad al instrumento de evaluación docente, se ha generado esta función para que los alumnos evaluen directamente a los profesores que les impartieron clases durante el presente año, esta evaluación es pre-requisito para la toma de carga de periodos siguientes. El proceso a seguir es el siguiente:\n\n" +
	       	  "- En la página siguiente se mostrarán las secciones con sus profesores a evaluar.\n"+
			  "- Debe evaluar cada una de las preguntas presentadas en la primera columna, con una escala de valores de 0 a 4, según se muestra en la tabla de Escalas."+
			  "- Al cerrar la encuesta, ésta guardará los datos enviados. Se deben evaluar todas las preguntas."+
			  "\n\n\n Recuerde evaluar todas sus asignaturas ya que el no hacerlo puede presentar problemas cuando intente tomar carga académica";
		   
	alert(mensaje);
} 
function validar_ingreso()
{
  var plec = '<%=plec_ccod_enc%>';
  /*if (plec == '2')
    { 
	  alert("El proceso de evaluación docente 2do Semestre se abrirá a mediados del semestre.");
	}
  else
    {*/ 
  document.edicion.submit();
	//}
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
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Asignaturas anuales y docentes a Evaluar</strong></font></td>
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
										   <td width="22%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Datos Generales </strong></font></td>
										   <td width="68%"><hr></td>
										    <TD width="10%">
										   		<%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"> 
												</a>
											</TD>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr> 
										<td height="20" width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut</strong></font></td>
										<td width="32%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("rut")%></font></td>
										<td width="14%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre</strong></font></td>
										<td width="44%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("nombre")%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong>
										                            <%f_encabezado.DibujaCampo("carrera")%>
																  	</font>
										</td>
									  </tr>
									  <tr> 
										<td height="20" width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Duraci&oacute;n</strong></font></td>
										<td width="32%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("duas_tdesc")%></font></td>
										<td width="14%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Año Ingreso</strong></font></td>
										<td width="44%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("ano_ingreso_plan")%></font></td>
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
						<form name="edicion" action="responder_encuesta_2015.asp" method="post">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="42%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Encuesta de opinion Estudiantil</strong></font></td>
										   <td width="58%"><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="95%" border="0" cellpadding="0" cellspacing="0">
									  <tr>
								      <td colspan="2"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Presentaci&oacute;n</strong></font></td></tr>
                                        <tr>
									    <td colspan="2"><p><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6">Esta encuesta se enmarca dentro del proceso de evaluación institucional de la </font><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6">calidad de la docencia, conformado por la autoevaluación del docente, la evaluación del director o jefe de carrera y la encuesta de opinión estudiantil. Esta información servirá para mejorar la calidad de la docencia en la Universidad del Pacífico.
									      </font></p>
									      <p><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6">Tu participación es anónima y no hay respuestas correctas o incorrectas.
								          Agradecemos tu tiempo y colaboración.</font></p></td>
                                      </tr>
                                       <tr>
								      <td colspan="2"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Instrucciones:</strong></font></td></tr>
                                        <tr>
									    <td colspan="2"><p><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6">Para responder, deberás escribir el nombre de la asignatura y del docente en cada columna, bajo ese nombre escribe el número de la escala que consideres que refleja mejor tu opinión frente a cada afirmación. La escala se encuentra disponible en cada página.
</font></p>
									      <p><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6">En el caso de una misma asignatura impartida por dos o más profesores, agrega a los docentes y nombre de la asignatura en las últimas columnas.
									        </font></p>
									      <p><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6">Al final de la encuesta encontrarás un apartado para escribir sugerencias de mejora. Es importante tu opinión para aportar a la mejora del proceso de enseñanza y aprendizaje.
									        </font></p>
									      <p><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6">Se solicita objetividad para responder y escribir con letra clara, utilizando un lenguaje formal. </font></p>
									     </td>
                                      </tr>
					                  <tr>
						                  <td align="left">&nbsp;</td>
						                  <td colspan="-1" align="center">&nbsp;</td>
					                  </tr>
					                  <tr>
							              <td align="left"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Escala:</strong></font></td>
							              <td width="82%" colspan="-1" align="center">&nbsp;</td>
						              </tr>
								      <tr>
								        <td colspan="2" align="center">
                                        <table  cellpadding="1" cellspacing="0" border="1" bordercolor="#496da6">
                                        <tr>
                                          <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">4</font></td>
                                          <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">TOTALMENTE DE ACUERDO</font></td>
                                        </tr>
                                        <tr>
                                          <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">3</font></td>
                                          <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">DE ACUERDO</font></td>
                                        </tr>
                                        <tr>
                                          <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">2</font></td>
                                          <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">EN DESACUERDO</font></td>
                                        </tr>
                                        <tr>
                                          <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">1</font></td>
                                          <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">TOTALMENTE EN DESACUERDO</font></td>
                                        </tr>
                                        <tr>
                                        <td>
                                        <font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">0</font>
                                        </td>
                                        <td>
                                        <font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">NO OBSERVADO</font>
                                        </td>
                                        </tr>
                                        </table>
                                        </td>
							          </tr>
								      <tr>
								        <td colspan="2" align="center">&nbsp;</td>
							          </tr>
								      <tr><td colspan="2" align="center">
									          <table width="85%" height="60" cellpadding="0" cellspacing="0" border="1" bordercolor="#496da6">
											    <tr>
													<td align="center">
														<strong><font color="#e41712">ATENCIÓN: </font><font color="#496da6">No olvides completar tu evaluación docente, recuerda que es requisito necesario para poder tomar asignaturas en semestres posteriores.</font></strong>
													</td>
												</tr>
											  </table>
										  </td>
									  </tr>
									  <tr><td colspan="2">
									  			<script language='javaScript1.2'> colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; </script>
												
									      </td>
									  </tr>
									  <tr><td colspan="2">&nbsp;</td></tr>
									  <tr> 
										<td  colspan="2" align="center">
											<table width="40%" cellpadding="0" cellspacing="0">
												<tr>
												    <td width="50%" align="right">
													<%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:_Navegar(this, 'cerrar_sesion.asp', 'FALSE');"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
															<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
														</a>
													</td>
													<td width="50%" align="left">
													<%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:validar_ingreso();"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SIGUIENTE2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SIGUIENTE1.png';return true ">
															<img src="imagenes/SIGUIENTE1.png" border="0" width="70" height="70" alt="IR A PAGINA 2"> 
														</a>
														</a>
													</td>
												</tr>
											</table>
										</td>
									  </tr>
								  </table>
                  
								</td>
							</tr>
						  <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>"> 
						  <input name="b[0][pers_xdv]" type="hidden" value="<%=q_pers_xdv%>">
						  <input name="b[0][peri_ccod]" type="hidden" value="<%=q_peri_ccod%>">
                    <input name="b[0][pers_ncorr_temp]" type="hidden" value="<%=pers_ncorr_temporal%>">
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

