<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: UFE
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:22/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			: ORDER BY, ERROR XML
'LINEA			: 65,67 -  186
'*******************************************************************
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Filtrar listado de Matriculados"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo= negocio.obtenerPeriodoAcademico("POSTULACION")
sede= negocio.obtenerSede
usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
anos_ccod=conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "carreras_listado.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "carreras_listado.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"

' consulta_carreras= "(select distinct ltrim(rtrim(cast(c.carr_ccod as varchar))) as carr_ccod, carr_tdesc " & vbCrLf &_
'				    " from ofertas_Academicas a, especialidades b,carreras c, periodos_Academicos d " & vbCrLf &_
'				    " where a.espe_ccod=b.espe_ccod and carr_tdesc<>'ACTIVIDADES ACADEMICAS COMPLEMENTARIAS' and carr_tdesc<>'ACTIVIDADES DIRECCION DE DOCENCIA' and tcar_ccod=1" & vbCrLf &_
'				    " and b.espe_ccod in ( " & vbCrLf &_
'				    "                    Select b.espe_ccod " & vbCrLf &_
'				    "                    from alumnos aa, ofertas_Academicas bb, especialidades cc " & vbCrLf &_
'					"                    where aa.ofer_ncorr=bb.ofer_ncorr and bb.espe_ccod=cc.espe_ccod  and emat_ccod=1 group by b.espe_ccod) " & vbCrLf &_
'					" and b.carr_ccod=c.carr_ccod " & vbCrLf &_
'					" --and cast(d.anos_ccod as varchar) ='"&anos_ccod&"' " & vbCrLf &_
'					" and a.peri_ccod = d.peri_ccod " & vbCrLf &_
'				    " /*and cast(a.sede_ccod as varchar)='"&sede&"'*/)d "					

 consulta_carreras= "(select distinct ltrim(rtrim(cast(c.carr_ccod as varchar))) as carr_ccod, carr_tdesc " & vbCrLf &_
				    " from ofertas_Academicas a, especialidades b,carreras c, periodos_Academicos d " & vbCrLf &_
				    " where a.espe_ccod=b.espe_ccod and carr_tdesc<>'ACTIVIDADES ACADEMICAS COMPLEMENTARIAS' and carr_tdesc<>'ACTIVIDADES DIRECCION DE DOCENCIA' and tcar_ccod=1" & vbCrLf &_
				    " and b.espe_ccod in ( " & vbCrLf &_
				    "                    Select cc.espe_ccod " & vbCrLf &_
				    "                    from alumnos aa, ofertas_Academicas bb, especialidades cc " & vbCrLf &_
					"                    where aa.ofer_ncorr=bb.ofer_ncorr and bb.espe_ccod=cc.espe_ccod  and emat_ccod=1 group by cc.espe_ccod) " & vbCrLf &_
					" and b.carr_ccod=c.carr_ccod " & vbCrLf &_
					" and a.peri_ccod = d.peri_ccod " & vbCrLf &_
				    " )d "			

' response.Write(consulta_carreras)					
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.AgregaCampoParam "carr_ccod", "destino",consulta_carreras 
 f_busqueda.AgregaCampoParam "peri_ccod", "destino","(select peri_ccod,peri_tdesc from periodos_academicos where cast(anos_ccod as varchar)>'2005') a" 
 f_busqueda.AgregaCampoParam "aran_nano_ingreso", "destino","(select distinct aran_nano_ingreso from ofertas_academicas a, periodos_academicos b, aranceles c where a.peri_ccod = b.peri_ccod and cast(b.anos_ccod as varchar)='"&anos_ccod&"' and a.aran_ncorr = c.aran_ncorr and isnull(aran_nano_ingreso,0)<>0 ) a" 
 f_busqueda.AgregaCampoParam "emat_tdesc", "destino","(select emat_tdesc from estados_matriculas where emat_ccod <> 12) a" 
 f_busqueda.AgregaCampoParam "post_nano_paa", "destino","(select distinct post_nano_paa from postulantes a, periodos_Academicos b where a.peri_ccod=b.peri_ccod and cast(b.anos_ccod as varchar)='"&anos_ccod&"' and isnull(post_nano_paa,1) <> 1 ) a" 
 f_busqueda.Siguiente


'---------------------------------------------------------------------------------------------------

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
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">

<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Filtros Alumnos Matriculados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <BR>
                    <%pagina.DibujarTituloPagina%>
                  </div>
				  <form name="buscador">
				  <input type="hidden" name="usuario" value="<%=usuario%>"/>
                  <table width="98%" border="1">
                    <tr> 
                      <td width="100%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td width="12%"><div align="left">Carrera</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
                              </tr>
							  <tr> 
                                <td width="12%"><div align="left">Periodo</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><% f_busqueda.dibujaCampo ("peri_ccod") %></td>
                              </tr>
                            </table>
                          </div>
					  </td>
                   </tr>
                  </table> 
				   <hr>
				   <br>
				  <table width="98%" border="0">
                    <tr> 
                      <td width="100%"><div align="center">
                            <table width="100%" border="1">
                              <tr> 
                                <td  colspan="3"><div align="center"><strong>Filtros adicionales de búsqueda</strong></div></td>
                              </tr>
							  <tr> 
                                <td width="33%"><div align="center"><strong>Según año de ingreso</strong></div></td>
                                <td width="33%"><div align="center"><strong>Según Estado de Matricula</strong></div></td>
                              </tr>
							  <tr> 
                                <td width="33%" valign="top"><div align="center"><%f_busqueda.dibujaCampo ("aran_nano_ingreso") %></div></td>
                                <td width="33%">
										<table align="center" border="1">
											<tr>
												<td width="70"><font size="1">ACTIVA</font></td>
												<td width="17"><%f_busqueda.dibujaCampo ("activa") %></td>
												<td width="95"><font size="1">ANULACION ESTUDIOS</font></td>
											  <td width="17"><% f_busqueda.dibujaCampo ("anulacion_estudios") %></td>
												<td width="95"><font size="1">ABANDONO</font></td>
											  <td width="17"><% f_busqueda.dibujaCampo ("abandono") %></td>
											</tr>
											<tr>
												<td width="110"><font size="1">ANULADO</font></td>
												<td width="19"><%f_busqueda.dibujaCampo ("anulado") %></td>
												<td><font size="1">CAMBIO DE CARRERA</font></td><td><%f_busqueda.dibujaCampo ("cambio_carrera") %></td>
												<td><font size="1">CAMBIO JORNADA</font></td><td><% f_busqueda.dibujaCampo ("cambio_jornada") %></td>
												
											</tr>
											<tr>
												<td><font size="1">CAUSAL DE ELIMINACION ACADEMICA</font></td><td><%f_busqueda.dibujaCampo ("eliminacion_academica") %></td>
												<td><font size="1">EGRESADO</font></td><td><%f_busqueda.dibujaCampo ("egresado") %></td>
												<td><font size="1">ELIMINADO</font></td><td><% f_busqueda.dibujaCampo ("eliminado") %></td>
												
											</tr>
											<tr>
												<td><font size="1">POSTERGADO</font></td><td><%f_busqueda.dibujaCampo ("postergado") %></td>
												<td><font size="1">RETIRADO</font></td><td><%f_busqueda.dibujaCampo ("retirado") %></td>
												<td><font size="1">SUSPENDIDO</font></td><td><% f_busqueda.dibujaCampo ("suspendido") %></td>
												
											</tr>
											<tr>
												<td><font size="1">SUSPENSIÓN DE ESTUDIOS</font></td><td><%f_busqueda.dibujaCampo ("suspension_estudios") %></td>
												<td><font size="1">TITULADO</font></td><td ><%f_busqueda.dibujaCampo ("titulado") %></td>
												<td  colspan="3">&nbsp;</td>
											</tr>
										</table>
								</td>
                              </tr>
							  
							  <tr> 
                                <td  colspan="3"><div align="center">&nbsp;</div></td>
                              </tr>
							  
                            </table>
                          </div>
					  </td>
                   </tr>
                  </table> 
				  </form>
                  <br></td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="129" nowrap bgcolor="#D8D8DE"><table width="57%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="33%"><%botonera.agregabotonparam "excel", "url", "listado_matriculas_totales_ufe.asp"
					                    'botonera.agregabotonparam "excel", "deshabilitado","true"
								  botonera.dibujaboton "excel"%></td>
                      <td width="34%">
                        <% botonera.agregabotonparam "lanzadera", "url", "../lanzadera/lanzadera.asp"
						botonera.dibujaboton "lanzadera"%>
                      </td>
					  <td width="33%">
                        <!--<a href="javascript:_Guardar(this, document.forms['buscador'], 'listado_matriculas_totales_rev.asp','', '', '', 'FALSE');">.</a>-->
                      </td>
                    </tr>
                  </table></td>
                  <td width="281" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>
    </td>
  </tr>  
</table>
</body>
</html>
