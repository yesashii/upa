<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Resultados Encuesta Diseño"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
tipo = request.querystring("busqueda[0][tipo]")
'--------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "resultados_encuestas_disenio.xml", "busqueda_encuesta"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 consulta_tipos = " (select tipo, tipo + ' (' + cast(count(*) as varchar) + ' encuestados)' as descripcion"&_
  				  "	from encuestas_disenio"&_
  				  " group by tipo) a"
 
 f_busqueda.AgregaCampoParam "tipo", "destino", consulta_tipos
 f_busqueda.AgregaCampoCons "tipo", tipo

'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "resultados_encuestas_disenio.xml", "botonera"
'--------------------------------------------------------------------------
encu_ncorr = 27
nombre_encuesta = conexion.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
instruccion = conexion.consultaUno("Select encu_tinstruccion from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
pagina.Titulo = nombre_encuesta 

set escala= new cformulario
escala.carga_parametros "tabla_vacia.xml","tabla"
escala.inicializar conexion
Query_escala = "select  resp_ncorr,resp_tabrev,protic.initcap(resp_tdesc) as resp_tdesc,resp_nnota from respuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by resp_norden"
escala.consultar Query_escala
cantid = escala.nroFilas

set criterios= new cformulario
criterios.carga_parametros "tabla_vacia.xml","tabla"
criterios.inicializar conexion
Query_criterios = "select  crit_ncorr,crit_tdesc from criterios where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by crit_norden"
criterios.consultar Query_criterios
cantid_criterios = criterios.nroFilas

encuestados = conexion.consultaUno("select count(*) from encuestas_disenio where cast(tipo as varchar)='"&tipo&"'")

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function resumen()
{
   location.href ="puntaje_profesor.asp?pers_ncorr="+'<%=codigo%>';
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
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
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="115">Tipo de encuestado</td>
                                      <td width="10">:</td>
                                      <td width="389"><%f_busqueda.DibujaCampo("tipo") %></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
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
	<%if tipo <> "" then%>
	<form name="edicion">
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
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="121" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Resultado Encuesta</font></div></td>
                      <td width="536" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
					<br>
                  </div>
                  <br>	
				  <!------------------------------comienzo encuesta-------------->
				  <table width="100%"  border="0" align="center">
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					<%if tipo <> "" then %>
					<tr>
						<td colspan="3">Resultado encuestas realizadas por <font color="#0033FF"><strong><%=tipo%> (S,ES)</strong></font></td>
					</tr>
					<tr>
						<td colspan="3">Cantidad Evaluados <font color="#0033FF"><strong><%=encuestados%></strong></font></td>
					</tr>
					<%end if%>
					<%if cantid > "0" then
						 escala.primero
						 while escala.siguiente
							abrev = escala.obtenervalor("resp_tabrev")
							texto= escala.obtenervalor("resp_tdesc")
							puntos= escala.obtenervalor("resp_nnota")						
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
					<%if cantid_criterios >"0" then
						contador=1
						contador2 = 1
						acumulado_total = 0
						criterios.Primero
						while criterios.siguiente
							ncorr = criterios.obtenervalor("crit_ncorr")
							titulo= criterios.obtenervalor("crit_tdesc")						
							%>  
						<tr> 
							<td colspan="3"><font color="#CC0000"><strong><%=titulo%></strong></font></td>
							<%if cantid >"0" then
								  escala.Primero
								  while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="20"><strong><center><font color="#CC0000">
											<%response.Write(abrev)%></font></center></strong>
										</td>
										<td width="20">&nbsp;</td>
									<%wend%>
							<%end if%>
							<td width="2">&nbsp;</td>	
						</tr>
						<%
						   set preguntas= new cformulario
						   preguntas.carga_parametros "tabla_vacia.xml","tabla"
						   preguntas.inicializar conexion
						   Query_preguntas = "select  preg_ncorr,preg_ccod,protic.initCap(preg_tdesc) as preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
						   preguntas.consultar Query_preguntas
						   cantid_preguntas = preguntas.nroFilas
						   if cantid_preguntas >"0" then
								while preguntas.siguiente
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
												acumulado = 0
												while escala.siguiente%>
													 <td width="20">
													 <center>
													 <%respuesta = conexion.consultaUno("Select count(*) from encuestas_disenio where cast(tipo as varchar)='"&tipo&"' and cast(preg_"&contador2&"_"&contador&" as varchar)='"&escala.obtenervalor("resp_ncorr")&"'")  	%>
													 <%if respuesta > "0" then 
															response.Write("<strong>"&respuesta&"</strong>")
															puntaje = escala.obtenervalor("resp_nnota")
															acumulado = (cint(puntaje) * cint(respuesta))
													   else
															response.Write(respuesta)
													   end if%>
													   </center>
													   </td>
													   <td width="20">&nbsp;</td>
												  <%wend%>
												<%end if%>
										<td width="2">&nbsp;</td>	
									</tr>
									<%contador=contador+1 
									acumulado_total = acumulado_total + acumulado
									wend
								end if
								Query_preguntas=""
								contador = 1
								contador2 = contador2 + 1%>
						  <%wend 
						end if
						%>
						<tr>
							<td colspan="13">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="13"><hr></td>
						</tr>
				  </table>  
				  <!------------------------------fin columna-------------------->			  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                       <td width="64%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
					   <td width="36%">
                        <% if tipo <> "" then 
						   		botonera.agregaBotonParam "excel","url","resultados_encuestas_disenio_excel.asp?tipo="&tipo
								botonera.dibujaboton "excel"
						   end if%>
                      </td>
					</tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
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
