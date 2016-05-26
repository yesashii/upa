<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
pers_nrut = Request.QueryString("b[0][pers_nrut]")
pers_xdv = Request.QueryString("b[0][pers_xdv]")

set errores = new CErrores
 
encu_ncorr = "27"

set conectar = new cconexion
conectar.inicializar "upacifico"



'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "encuesta_disenio.xml", "busqueda"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", pers_xdv
'---------------------------------------------------------------------------------------------------
'response.End()

'pers_nrut= negocio.obtenerUsuario()
'pers_nrut= "16125125"
pers_ncorr= conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")

c_habilitado = " select case count(*) when 0 then 'N' else 'S' end "&_
			   " from secciones a, periodos_academicos b, bloques_horarios c, bloques_profesores d "&_
			   " where a.peri_ccod=b.peri_ccod and a.carr_ccod in ('16','21') "&_
			   " and b.anos_ccod = datePart(year,getDate()) "&_
			   " and a.secc_ccod=c.secc_ccod and c.bloq_ccod=d.bloq_ccod and cast(d.pers_ncorr as varchar)='"&pers_ncorr&"' "
habilitado = conectar.consultaUno(c_habilitado)			   
'response.Write(habilitado)
set botonera = new CFormulario
botonera.Carga_Parametros "encuesta_disenio.xml", "botonera"

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

set datos_extras= new cformulario
datos_extras.carga_parametros "encuesta_disenio.xml","datos_adicionales_profesores"
datos_extras.inicializar conectar
Query_datos = " select isnull(b.sexo_ccod,a.sexo_ccod) as sexo_ccod,isnull(clases_disenio,'0') as clases_disenio, "&_
			  " isnull(profesion,'') as profesion,isnull(clases_disenio_grafico,'0') as clases_disenio_grafico, "&_
			  " isnull(espacios_escenograficos,0) as espacios_escenograficos,isnull(espacios_equipamiento,0) as espacios_equipamiento,isnull(espacios_efimeras,0) as espacios_efimeras, isnull(espacios_sustentable,0) as espacios_sustentable, isnull(espacios_comerciales,0) as espacios_comerciales, isnull(espacios_exposiciones,0) as espacios_exposiciones, isnull(espacios_intervenciones,0) as espacios_intervenciones, isnull(espacios_otros,'') as espacios_otros "&_
			  " from personas a, encuestas_disenio b where cast(pers_ncorr as varchar) ='"&pers_ncorr&"' and a.pers_ncorr *= b.pers_ncorr_encuestado "
datos_extras.consultar Query_datos
datos_extras.siguiente
%>

<html>
<head>
<title>ENCUESTA EVALUACIÓN PERFIL DE EGRESO DISEÑO</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
var t_busqueda;

function ValidaBusqueda()
{
	rut = t_busqueda.ObtenerValor(0, "pers_nrut") + '-' + t_busqueda.ObtenerValor(0, "pers_xdv")
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		t_busqueda.filas[0].campos["pers_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}
function volver()
{
   location.href ="menu_alumno.asp";
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
  {//alert(cant_radios);
   //alert(contestada);
  if ((contestada-2)==((cant_radios - 4)/divisor))
  { 
	 if(confirm("Está seguro que desea grabar la Evaluación.\n\nUna vez guardada la encuesta, no podrá realizar cambio alguno en ella.")) 
     { document.edicion.method = "POST";
	   document.edicion.action = "encuesta_disenio_profesor_proc.asp";
       document.edicion.submit();
	 }  
  }
  else
   alert("Debe responder la encuesta antes de grabar,\n aún restan preguntas de selección por responder.");
  }
  else
     alert("Esta encuesta no ha sido creada completamente aún, No la puede contestar");

}
function InicioPagina()
{
	t_busqueda = new CTabla("b");
}
</script>


</head>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
		<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              
            </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><form name="buscador">
					  <br>
					  <table width="98%"  border="0" align="center">
						<tr>
						  <td width="81%"><div align="center">
							<table width="98%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td><div align="right"><strong>R.U.T. Profesor</strong></div></td>
								<td width="40"><div align="center"><strong>:</strong></div></td>
								<td><%f_busqueda.DibujaCampo("pers_nrut")%> 
								  - 
									<%f_busqueda.DibujaCampo("pers_xdv")%></td>
							  </tr>
							</table>
						  </div></td>
						  <td width="19%"><div align="center"><%botonera.DibujaBoton("buscar")%></div></td>
						</tr>
					  </table>
					</form>
					</td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>
	<%if pers_nrut <> "" and habilitado = "N" then %>
	<center>
		<table width="80%" border="1" bgcolor="#CCCCCC">
		<tr>
			<td align="center"  bgcolor="#FFFFCC"><font size="3"><strong>Lo Sentimos, esta encuesta puede ser contestada sólo por profesores que realicen clases en las escuelas de Diseño y Diseño Gráfico.</strong></font></td>
		</tr>
		</table>
	</center>
	<br>
	<%end if%>
	<%if encu_ncorr <> "" and pers_nrut <> "" and habilitado="S" then%>
	<form name="edicion">
		<% 'response.Write("Select Count(*) from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
		  contestada = conectar.consultaUno("Select Count(*) from encuestas_disenio where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"'")
		  
		%>
	<input name="p[0][encu_ncorr]" type="hidden" value="<%=encu_ncorr%>">
	<input name="p[0][pers_ncorr_encuestado]" type="hidden" value="<%=pers_ncorr%>">
	<input name="p[0][tipo]" type="hidden" value="PROFESOR">
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  
				     <div align="center">
                      <font face="Verdana, Arial, Helvetica, sans-serif"><span style="color:#42424A; font-weight: bold; font-size: 17px">ENCUESTA EVALUACIÓN PERFIL DE EGRESO DISEÑO</span></font>
                      <BR>
                      <table width="100%"  border="0" align="center">
                        <tr> 
                          <td colspan="3">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3">
							<table width="100%" border="0">
								  <tr> 
									<td width="18%" align="left"><strong>Sexo</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td align="left"><font color="#CC0000"><%datos_extras.dibujaCampo("sexo_ccod")%></font></td>
								  </tr>
								  <tr> 
									<td width="18%" align="left"><strong>Escuela en la que realiza actividad docente:</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td colspan="6" align="left"><font color="#CC0000">
									                                   <table>
																	        <tr>
																			   <td> <%datos_extras.dibujaCampo("clases_disenio")%> DISEÑO</td>
																		       <td> <%datos_extras.dibujaCampo("clases_disenio_grafico")%>DISEÑO GRÁFICO</td>
																			</tr>
																		</table>
																 </font>
									</td>
								  </tr>
  								  <tr> 
									<td width="18%" align="left"><strong>Profesión</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td align="left"><font color="#CC0000">&nbsp;<%datos_extras.dibujaCampo("profesion")%></font></td>
    							  </tr>
								  <tr> 
									<td width="18%" align="left"><strong>¿Ejerce usted su profesión en el ámbito laboral?</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td colspan="6" align="left"><font color="#CC0000">
									                                   <table>
																	        <tr>
																			   <td> <input type='RADIO' value='1' checked name='p[0][ejerce_profesion]' >SI</td>
																		       <td> <input type='RADIO' value='0'  name='p[0][ejerce_profesion]' >NO</td>
																			</tr>
																		</table>
																 </font>
									</td>
								  </tr> 
						    </table>
							</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
                          <td colspan="3"><strong>INSTRUCCIONES : </strong>Estimado Profesor (a):</td>
						</tr>
						<tr>  
						  <td colspan="3"><%=instruccion%></td>
						</tr>
						<tr>  
						  <td colspan="3" height="20"></td>
						</tr> 
						<%if cantid > "0" then
						  while escala.siguiente
								abrev = escala.obtenervalor("resp_tabrev")
								texto= escala.obtenervalor("resp_tdesc")						
						%> 
						<tr>  
						   <td width="3%"><div align="left"><strong><%=abrev%></strong></div></td>
  						   <td width="3%"><strong><center>:</center></strong></td>
						   <td width="94%"><div align="left"><strong><%=texto%></strong></div></td>
						</tr>
						<%
						wend
						end if
						%>
						
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
							contador2 = 1
						  	while criterios.siguiente
									ncorr = criterios.obtenervalor("crit_ncorr")
									'response.Write("ncorr= "&ncorr&" ")
									titulo= criterios.obtenervalor("crit_tdesc")						
							%>  
							<tr> 
                          		<td colspan="3"><strong><%=titulo%></strong></td>
						  		
						  		<%if cantid >"0" then
						  			escala.Primero
						  			while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="20"><strong><center>
						  				<%response.Write(abrev)		
										%></center></strong>
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
                          				<td width="18" align="right"><strong><%=contador%></strong></td>
										<td width="17"><%=".-"%></td>
										<td width="591"><%=pregunta%></td>
						  
						  				<%if cantid >"0" then
						  					escala.Primero
						  					while escala.siguiente%>
											 <td width="20"><center>
											   <%if contestada <> 0 then
											     'response.Write("Select preg_"&contador2&"_"&contador&" from encuestas_disenio where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"'")
												  respuesta = conectar.consultaUno("Select preg_"&contador2&"_"&contador&" from encuestas_disenio where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"'")  
												   'response.Write("enca "&respuesta)
												   if respuesta <> "" then 'and not esVacio(respuesta) then	
														if cInt(respuesta) = cInt(escala.obtenervalor("resp_ncorr")) then%>
												 			<input type="radio" name="<%="p[0][preg_"&contador2&"_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" checked>
												 		<%else%>
															<input type="radio" name="<%="p[0][preg_"&contador2&"_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" disabled>
												 		<%end if
												   end if%>
											   <%else%>
						  							<input type="radio" name="<%="p[0][preg_"&contador2&"_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>">
						  					  <%end if%>
											  </center></td>
											<%wend
									    end if%>
										<td width="2">&nbsp;</td>	
										</tr>
									<%contador=contador+1 
									wend
								end if
								Query_preguntas=""
								contador = 1
								contador2 = contador2 + 1%>
								
							<tr>
							<td colspan="5">&nbsp;</td>
							</tr>
							<%wend 
							
							end if
							%>
							<tr>
                          		<td colspan="5"><div align="center"><strong>PREGUNTAS DE DESARROLLO</strong></div></td>
                           </tr>
						   <tr>
                          		<td colspan="5"><div align="center"><strong>&nbsp;</strong></div></td>
                           </tr>
							<tr>
                          		<td colspan="5"><div align="left"><strong>¿Qué otras competencias específicas cree usted que deben ser incluidas y que no aparece en el listado anterior?</strong></div></td>
                           </tr>
						   <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                           </tr>
						   <tr>
                           <td colspan="5"><div align="center">
						                                <%respuesta = conectar.consultaUno("Select consideraciones from encuestas_disenio where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"'")%>
						                          		<textarea name="p[0][consideraciones]" cols="100" rows="4" id="TO-N"><%=respuesta%></textarea>
             							  </div>
						  </td>
                          </tr>
						  <tr>
                          		<td colspan="5"><div align="center"><strong>&nbsp;</strong></div></td>
                         </tr>
							<tr>
                          		<td colspan="5"><div align="left"><strong>Desde su punto de vista profesional y de acuerdo a los requerimientos  actuales y futuros del mercado laboral ¿Qué área de especialización considera usted debe ofrecer un programa de estudio universitario en el ámbito del Diseño de  Interiores?</strong></div></td>
                           </tr>
						   <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                           </tr>
						   <tr>
                                <td colspan="5" align="left">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="3%" align="left">a)</td>
										<td width="5%" align="center"><%datos_extras.dibujaCampo("espacios_escenograficos")%></td>
									    <td align="left">Diseño de Espacios Escenográficos.</td>
									</tr>
								</table>
								</td>
							</tr>	
						   <tr>
                                <td colspan="5" align="left">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="3%" align="left">b)</td>
										<td width="5%" align="center"><%datos_extras.dibujaCampo("espacios_equipamiento")%></td>
									    <td align="left">Diseño de Equipamiento de Interiores.</td>
									</tr>
								</table>
						   		</td>
							</tr>	
						   <tr>
                                <td colspan="5" align="left">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="3%" align="left">c)</td>
										<td width="5%" align="center"><%datos_extras.dibujaCampo("espacios_efimeras")%></td>
									    <td align="left">Instalaciones Efímeras.</td>
									</tr>
								</table>
						   		</td>
						   </tr>
						   <tr>
                                <td colspan="5" align="left">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="3%" align="left">d)</td>
										<td width="5%" align="center"><%datos_extras.dibujaCampo("espacios_sustentable")%></td>
									    <td align="left">Diseño Sustentable- Ecodiseño.</td>
									</tr>
								</table>
						   		</td>
						   </tr>
						   <tr>
						        <td colspan="5" align="left">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="3%" align="left">e)</td>
										<td width="5%" align="center"><%datos_extras.dibujaCampo("espacios_comerciales")%></td>
									    <td align="left">Espacios Comerciales y Puntos de Venta.</td>
									</tr>
								</table>
                                </td>
						   </tr>
						   <tr>
                                <td colspan="5" align="left">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="3%" align="left">f)</td>
										<td width="5%" align="center"><%datos_extras.dibujaCampo("espacios_exposiciones")%></td>
									    <td align="left">Diseño de Exposiciones y Espacios Culturales.</td>
									</tr>
								</table>
						        </td>
						   </tr>
						   <tr>
                                <td colspan="5" align="left">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="3%" align="left">g)</td>
										<td width="5%" align="center"><%datos_extras.dibujaCampo("espacios_intervenciones")%></td>
									    <td align="left">Diseño de intervenciones en el espacio público y Equipamiento Urbano</td>
									</tr>
								</table>
						        </td>
						   </tr>
						   <tr>
                                <td colspan="5" align="left">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="3%" align="left">h)</td>
										<td width="5%" align="center">Otro</td>
									    <td align="left"> ¿Cuál?<%datos_extras.dibujaCampo("espacios_otros")%></td>
									</tr>
								</table>
						   		</td>
                          </tr>
						  <tr>
                          		<td colspan="5"><div align="center"><strong>&nbsp;</strong></div></td>
                         </tr>
							<tr>
                          		<td colspan="5"><div align="left"><strong>¿Qué nuevas materias emergentes y/o conocimientos cree usted que se  deben considerar en un plan de estudio de la carrera de Diseño?</strong></div></td>
                           </tr>
						   <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                           </tr>
						   <tr>
                           <td colspan="5"><div align="center">
						                                <%respuesta = conectar.consultaUno("Select materias_complementarias from encuestas_disenio where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"'")%>
						                          		<textarea name="p[0][materias_complementarias]" cols="100" rows="4" id="TO-N"><%=respuesta%></textarea>
             							  </div>
						  </td>
                          </tr>
						  <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                         </tr>
						   <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                           </tr>
						   <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                           </tr>
						   <tr>
                                <td colspan="5"><div align="left">Muchas gracias por su colaboración.</div></td>
                           </tr>
                       </table> 
                    <BR>
                  </div>
				</td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="50%">&nbsp;</td>
                      <td width="50%"><% if contestada = 0 then
						botonera.dibujaBoton "guardar_encuesta"
						end if  %> </td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>
	  </form>
	  <%end if%>	
   </td>
  </tr>  
</table>
</body>
</html>
