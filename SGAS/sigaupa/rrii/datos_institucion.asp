<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tdet_ccod =Request.QueryString("b[0][tdet_ccod]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")
q_anos_ccod= request.QueryString("b[0][anos_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Becas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "becas.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "becas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "becas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "becas.xml", "cheques"
f_cheques.Inicializar conexion
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "tdet_ccod",q_tdet_ccod
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "anos_ccod", q_anos_ccod





if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and c.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_tdet_ccod <> "" then
	

  	filtro2=filtro2&"and i.tdet_ccod='" &q_tdet_ccod&"'"
  					
end if
		
 
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and k.sede_ccod='" &q_sede_ccod&"'"
  					
end if
 
if q_tdet_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos= "select  distinct pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,(select carr_tdesc from carreras ca ,ofertas_academicas"& vbCrLf &_
				" oa,especialidades es where oa.ofer_ncorr=c.ofer_ncorr and oa.espe_ccod=es.espe_ccod and es.carr_ccod=ca.carr_ccod)as carrera,(select sede_tdesc from sedes s ,OFERTAS_ACADEMICAS OA  where s.sede_ccod=OA.sede_ccod AND OA.OFER_NCORR=C.OFER_NCORR)as sede"& vbCrLf &_
  				",tdet_tdesc,i.tdet_ccod from personas a,postulantes b,alumnos c,contratos d,compromisos f,detalle_compromisos g ,detalles h,tipos_detalle i,sdescuentos j,ofertas_academicas k"& vbCrLf &_
				"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
				"and a.pers_ncorr=c.pers_ncorr"& vbCrLf &_
				"and b.post_ncorr=c.post_ncorr"& vbCrLf &_
				"and c.matr_ncorr=d.matr_ncorr"& vbCrLf &_
				"and d.cont_ncorr=f.comp_ndocto"& vbCrLf &_
				"and f.tcom_ccod=g.tcom_ccod"& vbCrLf &_
				"and f.inst_ccod=g.inst_ccod"& vbCrLf &_
				"and f.comp_ndocto=g.comp_ndocto"& vbCrLf &_
				"and g.tcom_ccod=h.tcom_ccod"& vbCrLf &_
				"and g.inst_ccod=h.inst_ccod"& vbCrLf &_
				"and g.comp_ndocto=h.comp_ndocto"& vbCrLf &_
				"and j.stde_ccod=i.tdet_ccod"& vbCrLf &_
				"and c.post_ncorr=j.post_ncorr"& vbCrLf &_
				"and c.ofer_ncorr=j.ofer_ncorr"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				"and i.tben_ccod in (2,3)"& vbCrLf &_
				"and d.peri_ccod in(select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"& vbCrLf &_
				"and c.ofer_ncorr=k.ofer_ncorr"& vbCrLf &_
				"order by carrera,nombre"
				
				numero_total=conexion.ConsultaUno("select count(tdet_ccod)from(select  distinct pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,(select carr_tdesc from carreras ca ,ofertas_academicas"& vbCrLf &_
				" oa,especialidades es where oa.ofer_ncorr=c.ofer_ncorr and oa.espe_ccod=es.espe_ccod and es.carr_ccod=ca.carr_ccod)as carrera,(select sede_tdesc from sedes s ,OFERTAS_ACADEMICAS OA  where s.sede_ccod=OA.sede_ccod AND OA.OFER_NCORR=C.OFER_NCORR)as sede,"& vbCrLf &_
  				"tdet_tdesc,i.tdet_ccod from personas a,postulantes b,alumnos c,contratos d,compromisos f,detalle_compromisos g ,detalles h,tipos_detalle i,sdescuentos j,ofertas_academicas k"& vbCrLf &_
				"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
				"and a.pers_ncorr=c.pers_ncorr"& vbCrLf &_
				"and b.post_ncorr=c.post_ncorr"& vbCrLf &_
				"and c.matr_ncorr=d.matr_ncorr"& vbCrLf &_
				"and d.cont_ncorr=f.comp_ndocto"& vbCrLf &_
				"and f.tcom_ccod=g.tcom_ccod"& vbCrLf &_
				"and f.inst_ccod=g.inst_ccod"& vbCrLf &_
				"and f.comp_ndocto=g.comp_ndocto"& vbCrLf &_
				"and g.tcom_ccod=h.tcom_ccod"& vbCrLf &_
				"and g.inst_ccod=h.inst_ccod"& vbCrLf &_
				"and g.comp_ndocto=h.comp_ndocto"& vbCrLf &_
				"and j.stde_ccod=i.tdet_ccod"& vbCrLf &_
				"and c.post_ncorr=j.post_ncorr"& vbCrLf &_
				"and c.ofer_ncorr=j.ofer_ncorr"& vbCrLf &_
				
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				"and i.tben_ccod in (2,3)"& vbCrLf &_
				"and d.peri_ccod in(select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&") and c.ofer_ncorr=k.ofer_ncorr)as bb")
				

total=numero_total			
end if


					
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_cheques.Consultar sql_descuentos


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
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  
          <tr>
            <td>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Convenio"%>
						  <table width="100%"  border="0" align="center">
							<tr>
							  <td>
							  	<table align="center" width="100%">
									<tr>
										<td width="11%">
											<strong>Institución:</strong>										</td>
										<td width="41%">
											Universidad de Salamanca										</td>
										<td width="5%">
											<strong>Pais:</strong>										</td>
										<td width="16%">
											España										</td>
										<td width="8%">
											<strong>Ciudad</strong> :										</td>
										<td width="19%">
											Salamanca										</td>
									</tr>

								</table>
								<br>
							    <table align="center" width="100%">
                                  <tr>
                                    <td width="16%" valign="top"><strong>Carreras UPA en: Convenio</strong> </td>
									 <td width="27%" valign="top"> -Ingenieria Comercial
										<br>
										-Educación Parvularia	
								    </td>
									<td width="11%" valign="top"><strong>Cupo Total:</strong> </td>
									<td width="5%" valign="top">1</td>
									<td width="16%" valign="top"><strong>Cupo Disponible:</strong></td>
									<td width="25%" valign="top">0</td>
                                  </tr>
								</table>
									<br>
							    <table align="center" width="100%">
                                  <tr>
                                    <td width="26%" valign="top"><strong>Maximo Asignaturas a cursar:</strong> </td>
									 <td width="74%" valign="top">
									 No podrán tener una carga lectiva inferior a 4,5 créditos  si se trata de cuatrimestrales, o a 9 créditos si se trata de anuales								    </td>
                                  </tr>
								</table>
								<br>
								 <table align="center" width="100%">
								 <tr>
								 	<td colspan="6">
										<strong><u>1° Semestre</u></strong>
									</td>
								 </tr>
                                  <tr>
                                   <td width="24%" valign="top"><strong>Fecha Limite Postulaci&oacute;n:</strong> </td>
                                    <td width="13%" valign="top"> 30/05/2010 </td>
									 <td width="13%" valign="top"><strong>Incio Clases: </strong> </td>
                                    <td width="16%" valign="top"> 22/09/2010 </td>
									<td width="16%" valign="top"><strong>Termino Clases: </strong></td>
									<td width="18%" valign="top"> 24/01/2011 </td>
                                  </tr>
								  <tr>
								  	<td colspan="6">
										<strong><u>2° Semestre</u></strong>
									</td>
								  </tr>
								  <tr>
								  	  <td width="24%" valign="top"><strong>Fecha Limite Postulaci&oacute;n:</strong> </td>
									  <td valign="top"> 30/09/2010 </td>
									 <td width="13%" valign="top"><strong>Incio Clases:</strong> </td>
                                     <td valign="top"> 26/01/2011 </td>
									  <td width="16%" valign="top"><strong>Termino Clases:</strong> </td>
									  <td valign="top">30/05/2011 </td>	
								  </tr>
                                </table>
								
								 <br>
								 <table align="center" width="100%">
								 	<tr>
										<td width="16%">
											<strong>Idioma Necesario:  </strong>										</td>
										<td width="23%">
										Espa&ntilde;ol</td>
										<td width="25%">
											<strong>Test de Idiomas Requeridos: </strong>										
										</td>
										<td width="35%">&nbsp;</td>
									</tr>
								 </table>
								<br>
								 <table align="center" width="100%">
								 	<tr>
										<td>
											<strong>COSTOS DE VIDA</strong>
										</td>
									</tr>
								 </table>
								  <table align="center" width="100%">
								 	<tr>
										<td>
											<strong><u>Alojamiento</u></strong>
										</td>
									</tr>
								 </table>
								  <table align="center" width="100%">
								 	<tr>
										<td width="6%">
											<strong>Monto:</strong>										
										</td>
										<td width="30%">
											200-500 Euros										
										</td>
										<td width="12%" valign="top">
											<strong>Comentarios:</strong></td>
										<td width="52%">
											Se puede encontra informacionend http://websou.usl.es/vivienda/colyresi.asp										
											</td>
									</tr>
								 </table>
								 <table align="center" width="100%">
								 	<tr>
										<td>
											<strong><u>Alimentación</u></strong>
										</td>
									</tr>
								 </table>
								  <table align="center" width="100%">
								 	<tr>
										<td width="7%">
											<strong>Monto:</strong>										</td>
										<td width="29%">
											120-150 Euros/mes										</td>
										<td width="12%" valign="top">
											<strong>Comentarios</strong>:										
										</td>
										<td width="52%" valign="top">
											bonos de 10 Comidas 32.6 E y 30	comidas 94 E									
										</td>
									</tr>
								 </table>
								  <table align="center" width="100%">
								 	<tr>
										<td>
											<strong><u>Transporte</u></strong>
										</td>
									</tr>
								 </table>
								  <table align="center" width="100%">
								 	<tr>
										<td width="7%" valign="top">
											<strong>Monto:</strong>										
										</td>
										<td width="29%" valign="top">
											25 Euros/mes										
										</td>
										<td width="12%" valign="top">
											<strong>Comentarios</strong>:										
										</td>
										<td width="52%" valign="top">
																				
										</td>
									</tr>
								 </table>
								 <br>
								 <table align="center" width="100%">
								 	<tr>
										<td>
											<strong>DATOS DE CONTACTO </strong>
										</td>
									</tr>
								 </table>
								 <table align="center" width="100%">
								 	<tr>
										<td width="8%">
											<strong>Nombre: </strong>										</td>
										<td width="38%">
											María Teresa Garrido González										</td>
								      <td width="7%">
											<strong>Cargo:</strong>										</td>
										<td width="47%">&nbsp;</td>
										
									</tr>
								 </table>
								 <table width="100%">
								 	<tr>
										<td width="5%">
											<strong>Fono:</strong>										
										</td>
										<td width="11%">									    
										</td>
										<td width="5%">
											<strong>Fax: </strong>										
										</td>
										<td width="18%">									    
										</td>
										<td width="7%">
											<strong>E-mail: </strong>										
										</td>
										<td width="54%">
											mygar@usual.es										
										</td>
									</tr>
								 </table>
							  </td>
							</tr>
						  </table>
					</td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td align="center">
				  	<table id="bt_excel7055" width="92" border="0" cellspacing="0" cellpadding="0" class="click" onMouseOver="_OverBoton(this);" onMouseOut="_OutBoton(this);" onClick="_Navegar(this, 'busca_convenio.asp', 'FALSE')">
						  <tr> 
							<td width="7" height="16" rowspan="3"><img src="../imagenes/botones/boton1.gif" width="5" height="16" id="bt_excel7055c11"></td> 
							<td width="88" height="2"><img src="../imagenes/botones/boton2.gif" width="88" height="2" id="bt_excel7055c12"></td> 
							<td width="10" height="16" rowspan="3"><img src="../imagenes/botones/boton4.gif" width="5" height="16" id="bt_excel7055c13"></td>
						  </tr>
						  <tr> 
							<td height="12" bgcolor="#EEEEF0" id="bt_excel7055c21" nowrap align="center"> 
							  <div align="ceter"><font id="bt_excel7055f21" color="#333333" size="1" face="Verdana, Arial, Helvetica, sans-serif">Volver</font></div></td>
						  </tr>
						  <tr> 
							<td width="88" height="2"><img src="../imagenes/botones/boton3.gif" width="88" height="2" id="bt_excel7055c31"></td>
						  </tr>
		            </table>
				  </td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>