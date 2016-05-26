<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_empresa.asp" -->
<% 
'------------------------------------------------------

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion


q_rut=negocio.obtenerUsuario
ofta_ncorr=request.QueryString("ofta_ncorr")
'  q_rut =Request("daem[0][rut]")
'  q_dv=Request("daem[0][dv]")

 '-- Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "empresa.xml", "botonera"
 
 '---------------------------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "empresa.xml", "busqueda"
 f_busqueda.Inicializar conexion

 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 

'---------------------------------------------------------------------------------------------------
set f_oferta_trabajo = new CFormulario
 f_oferta_trabajo.Carga_Parametros "empresa.xml", "muestra_oferta"
 f_oferta_trabajo.Inicializar conexion
 
 selec_antecedentes="select ofta_cargo as cargo,"& vbCrLf &_
"ofta_nvacante as vacantes,"& vbCrLf &_
"upper(caol_tdesc) as tipo_cargo,"& vbCrLf &_
"upper(arol_tdesc) as area ,"& vbCrLf &_
"ofta_desc_oferta as descripcion_oferta ,"& vbCrLf &_
"upper(jool_tdesc) as jornada,"& vbCrLf &_
"ofta_duracion_contrato as duracion_contrato,"& vbCrLf &_
"upper(ofta_salario) as salario,"& vbCrLf &_
"ofta_comentario_salario as cometario_salario,"& vbCrLf &_
"protic.trunc(ofta_fcaducidad_oferta) as fcaducidad_oferta,"& vbCrLf &_
"regi_tdesc as regi_ccod,"& vbCrLf &_
"ciud_tdesc as ciud_ccod,"& vbCrLf &_
"ofta_lugar_trabajo as lugar_trabajo,"& vbCrLf &_
"upper(case when ofta_operador_nexperiencia =1 then 'igual a' when ofta_operador_nexperiencia=2 then 'mayor que'  when ofta_operador_nexperiencia=3 then 'menor que' end +' '+cast(ofta_nexperiencia as varchar)+' años')  as anos_experiencia,"& vbCrLf &_
"ofta_nexperiencia,"& vbCrLf &_
"upper(EDOL_tdesc) as estudio_minimo,"& vbCrLf &_
"upper(EEOL_tdesc) as situacion_estudio,"& vbCrLf &_
"ofta_requisitos_minimos as requisitos_minimos,"& vbCrLf &_
"case when ofta_conoci_comp =1 then 'SI' else 'NO' end as conocimientos_computacionales"& vbCrLf &_
"from ofertas_laborales a,"& vbCrLf &_
"cargos_ofertas_laborales b,"& vbCrLf &_
"areas_ofertas_laborales c,"& vbCrLf &_
"jornadas_ofertas_laborales d,"& vbCrLf &_
"regiones e,"& vbCrLf &_
"ciudades f,"& vbCrLf &_
"educacion_ofertas_laborales g,"& vbCrLf &_
"estado_estudio_ofertas_laborales h"& vbCrLf &_
"where ofta_ncorr="&ofta_ncorr&" "& vbCrLf &_
"and a.ofta_tipo_cargo=b.caol_ccod"& vbCrLf &_
"and a.ofta_area=arol_ccod"& vbCrLf &_
"and ofta_jorn_laboral=jool_ccod"& vbCrLf &_
"and ofta_region=e.regi_ccod"& vbCrLf &_
"and ofta_ciudad=ciud_ccod"& vbCrLf &_
"and ofta_grado_educacional=EDOL_CCOD"& vbCrLf &_
"and ofta_situacion_estudio=EEOL_CCOD"

			
 f_oferta_trabajo.Consultar selec_antecedentes
 f_oferta_trabajo.Siguiente
 'response.write(selec_antecedentes)
 
 
 set f_idiomas_oferta_trabajo = new CFormulario
 f_idiomas_oferta_trabajo.Carga_Parametros "empresa.xml", "muestra_idiomas_oferta"
 f_idiomas_oferta_trabajo.Inicializar conexion
 
 selec_antecedentes="select '.-'+idio_tdesc +' ('+ nidi_tdesc+' Hab:'+case when habla=1 then  'Si'else 'No' end +', Lee:'+case when lee=1 then  'Si'else 'No' end +', Esc:'+ case when escribe=1 then  'Si'else 'No' end +')' as idioma"& vbCrLf &_
"from idiomas_ofertas_laborales a,"& vbCrLf &_
"idioma b,"& vbCrLf &_
"niveles_idioma c"& vbCrLf &_
"where a.idio_ccod=b.idio_ccod"& vbCrLf &_
"and a.nive_ccod=c.nidi_ccod"& vbCrLf &_
"and ofta_ncorr="&ofta_ncorr&" "& vbCrLf &_
"order by idioma"

			
 f_idiomas_oferta_trabajo.Consultar selec_antecedentes
 '
'-----------------------------------------------------------------------------------------------
 set f_carreras_oferta_trabajo = new CFormulario
 f_carreras_oferta_trabajo.Carga_Parametros "empresa.xml", "muestra_carreras_oferta"
 f_carreras_oferta_trabajo.Inicializar conexion
 
 selec_antecedentes="select '.-'+carr_tdesc as carr_tdesc from carreras_ofertas_laborales a, carreras b where a.carr_ccod=b.carr_ccod and ofta_ncorr="&ofta_ncorr&""

			
 f_carreras_oferta_trabajo.Consultar selec_antecedentes

'-----------------------------------------------------------------------------------------------
 set f_programas_oferta_trabajo = new CFormulario
 f_programas_oferta_trabajo.Carga_Parametros "empresa.xml", "muestra_programas_oferta"
 f_programas_oferta_trabajo.Inicializar conexion
 
 selec_antecedentes="select '.-'+soft_tdesc as programas from software_ofertas_laborales a, software b where a.soft_ccod=b.soft_ncorr and ofta_ncorr="&ofta_ncorr&""

			
 f_programas_oferta_trabajo.Consultar selec_antecedentes

anos_exp=f_oferta_trabajo.ObtenerValor("ofta_nexperiencia")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">


function cargavalorenmascardo()
{
	elemento=document.oferta_trabajo.elements["ofta[0][LISTADOCARRERA]"]

	enMascara( this, "MONEDA",0);

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
body {
	background-color: #FFFFFF;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" background="imagenes/fondo.jpg">
 <form name="oferta_trabajo">
 <input type="hidden" name="ofta[0][empre_ncorr]" value="<%=empr_ncorr%>">
<input type="hidden" name="ofta[0][pers_nrut]" value="<%=pers_nrut%>">
<center>

  <table width="850"  align="center">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Courier New, Courier, mono" color="#23354d"><strong>DETALLE OFERTA </strong></font></td>
	</tr>
	<tr valign="top">
		<td width="100%"  align="left">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="97%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center" >
									<table width="100%">
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Cargo:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("cargo")%></strong></font>
										  </td>
										</tr>
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>N° de Vacantes:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("vacantes")%></strong></font>
										  </td>
										</tr>
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Tipo de cargo:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("tipo_cargo")%></strong></font>
										  </td>
										</tr>
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Área:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("area")%></strong></font>
										  </td>
										</tr>
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Descripción de la Oferta:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000">
											   		<strong>
													<%=f_oferta_trabajo.ObtenerValor("descripcion_oferta")%>
											   </strong>
										      </font>
										  </td>
										</tr>
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Disponibilidad para Trabajar/jornada laboral:</strong></font>											</td>
											<td align="left"  valign="bottom" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("jornada")%></strong></font>
										  </td>
										</tr>
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Duraci&oacute;n del Contrato:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("duracion_contrato")%></strong></font>
										  </td>
										</tr>
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Salario l&iacute;quido:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											<%salario1=f_oferta_trabajo.ObtenerValor("salario")
											  salario=FormatCurrency(cdbl(salario1), 0)%>
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%=salario%></strong></font>
										  </td>
										</tr>
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Comentarios del Salario &nbsp;(comisiones/incentivos):</strong></font>											</td>
											<td align="left"  valign="bottom" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("cometario_salario")%></strong></font>
										  </td>
										</tr>
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fecha Caducidad de la Oferta de empleo:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("fcaducidad_oferta")%></strong></font>
										  </td>
										</tr>
										
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Región:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("regi_ccod")%></strong></font>
										  </td>
										</tr>
										<tr>
										
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Ciudad:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("ciud_ccod")%></strong></font>
										  </td>
										</tr>
										<tr>
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Lugar de trabajo:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("lugar_trabajo")%></strong></font>
									      </td>
										</tr>
										<tr>
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Experiencia:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
											   <%if anos_exp="0" then%>
											   
											   SIN EXPERIENCIA
										      <% else%>
											  <%f_oferta_trabajo.dibujaCampo("anos_experiencia")%>
											  <% end if%>
											  
											  </strong></font>
									      </td>
										</tr>
										<tr>
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Grado educacional/estudios mínimos:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("estudio_minimo")%></strong></font>
									      </td>
										</tr>
										<tr>
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Situación de Estudio:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("situacion_estudio")%></strong></font>
									      </td>
										</tr>
										<tr>
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Requisitos Mínimos:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("requisitos_minimos")%></strong></font>
									      </td>
										</tr>
										<tr>
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Conocimientos en computación:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
											   <font size="2" face="Courier New, Courier, mono" color="#000000"><strong>
										      <%f_oferta_trabajo.dibujaCampo("conocimientos_computacionales")%></strong></font>
									      </td>
										</tr>
										<tr>
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Programas:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
													<table>
														<%while f_programas_oferta_trabajo.Siguiente%>
														<tr>
															<td>
											   					<font size="2" face="Courier New, Courier, mono" color="#000000">
																	<strong>
										     					 		<%=f_programas_oferta_trabajo.ObtenerValor("programas")%>
																	</strong>
																</font>
											  				</td>
											  			</tr>
														<%wend%>
											  		</table>
											  
									      </td>
										</tr>
										<tr>
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carreras:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
													<table>
														<%while f_carreras_oferta_trabajo.Siguiente%>
														<tr>
															<td>
											   					<font size="2" face="Courier New, Courier, mono" color="#000000">
																	<strong>
										     					 		<%=f_carreras_oferta_trabajo.ObtenerValor("carr_tdesc")%>
																	</strong>
																</font>
											  				</td>
											  			</tr>
														<%wend%>
											  		</table>
											  
									      </td>
										</tr>
										<tr>
											<td align="right"  valign="top" width="418">
											   <font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Idiomas:</strong></font>											</td>
											<td align="left"  valign="top" width="381">
													<table>
														<%while f_idiomas_oferta_trabajo.Siguiente%>
														<tr>
															<td>
											   					<font size="2" face="Courier New, Courier, mono" color="#000000">
																	<strong>
										     					 		<%=f_idiomas_oferta_trabajo.ObtenerValor("idioma")%>
																	</strong>
																</font>
											  				</td>
											  			</tr>
														<%wend%>
											  		</table>
											  
									      </td>
										</tr>
										<tr>
											<td colspan="2">
												
												<table width="100%">
													<tr>
													  <td width="320" height="10">&nbsp;</td>
													  <td width="189" height="10" align="center"><%POS_IMAGEN = 0%>
													  	<a href="javascript:_Navegar(this, 'ofertas.asp', 'FALSE');"
															onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
															onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
													    </a>										  
													  </td>
													  <td width="278" height="10" align="left">&nbsp;</td>
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
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		
		</td>
	</tr>
</table>
</center>
 <form>
</body>
</html>
