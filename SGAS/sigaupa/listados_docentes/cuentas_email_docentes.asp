<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

pagina.Titulo = "Cuentas Email docentes"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set errores = new CErrores

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
anos_ccod   =   request.QueryString("a[0][anos_ccod]")
sede_ccod   =   request.QueryString("a[0][sede_ccod]")
carr_ccod   =   request.QueryString("a[0][carr_ccod]")
jorn_ccod   =   request.QueryString("a[0][jorn_ccod]")

'response.Write("estado "&estado_prestamo)
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "cuentas_email_docentes.xml", "botonera"
'--------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "cuentas_email_docentes.xml", "listado_docentes"
formulario.Inicializar conexion 
'-------------------------------------------Seleccionar asignatura para equivalencia de una lista sin escribir su código-----
'-----------------------------------------------------------msandoval 19-02-2005---------------------------------------------
	set f_filtros = new cFormulario
	f_filtros.carga_parametros "cuentas_email_docentes.xml", "buscador"
	f_filtros.inicializar conexion
	consulta="Select '"&anos_ccod&"' as anos_ccod,'"&carr_ccod&"' as carr_ccod, '"&sede_ccod&"' as sede_ccod, '"&jorn_ccod&"' as jorn_ccod"
	f_filtros.consultar consulta
	consulta = " select distinct pea.anos_ccod,b.carr_ccod,b.carr_tdesc,c.sede_ccod,c.sede_tdesc,d.jorn_ccod,d.jorn_tdesc " & vbCrLf & _
			   " from secciones a,carreras b,sedes c, jornadas d,asignaturas e,periodos_academicos pea  " & vbCrLf & _
			   " where a.carr_ccod=b.carr_ccod  " & vbCrLf & _
			   " and a.sede_ccod = c.sede_ccod  " & vbCrLf & _
			   " and a.asig_ccod = e.asig_ccod  " & vbCrLf & _
			   " and a.jorn_ccod = d.jorn_ccod  " & vbCrLf & _
			   " and a.peri_ccod=pea.peri_ccod and pea.anos_ccod >= 2007 " & vbCrLf & _
			   " and exists (select 1 from bloques_horarios aa, bloques_profesores bb " & vbCrLf & _
			   "             where aa.secc_ccod=a.secc_ccod and aa.bloq_ccod=bb.bloq_ccod and bb.tpro_ccod=1) " & vbCrLf & _
			   " order by anos_ccod,sede_tdesc,carr_tdesc,jorn_tdesc " 
	
	f_filtros.inicializaListaDependiente "filtros", consulta
	f_filtros.siguiente
	'-----------------------------------------------------------------------------------------------------------------

consulta = " select distinct pea.anos_ccod,i.facu_tdesc as facultad,f.sede_tdesc as sede, "& vbcrlf & _
		   " g.carr_tdesc as carrera, j.jorn_tdesc as jornada,   "& vbcrlf & _
		   " cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' + d.pers_tape_materno as docente, "& vbcrlf & _
		   " --e.susu_tlogin as login, e.susu_tclave as clave, "& vbcrlf & _
		   " (select lower(email_upa) from sd_cuentas_email_totales tt where tt.pers_ncorr=e.pers_ncorr) as email_upa, "& vbcrlf & _
		   " lower(d.pers_temail) as email_personal "& vbcrlf & _
		   " from secciones a, bloques_horarios b, bloques_profesores c, personas d,sis_usuarios e, "& vbcrlf & _
		   "      sedes f, carreras g, areas_academicas h, facultades i, jornadas j, periodos_academicos pea "& vbcrlf & _
		   " where a.secc_ccod=b.secc_ccod and b.bloq_ccod=c.bloq_ccod "& vbcrlf & _
		   " and c.tpro_ccod=1 and c.pers_ncorr=d.pers_ncorr "& vbcrlf & _
		   " and a.sede_ccod=f.sede_ccod and a.carr_ccod=g.carr_ccod and g.area_ccod=h.area_ccod and h.facu_ccod=i.facu_ccod "& vbcrlf & _
		   " and a.jorn_ccod=j.jorn_ccod and c.tpro_ccod=1 "& vbcrlf & _
		   " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' and a.carr_ccod ='"&carr_ccod&"' and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"' and a.jorn_ccod=j.jorn_ccod "& vbcrlf & _
		   " and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"' and d.pers_ncorr=e.pers_ncorr "& vbcrlf & _
		   " order by facultad, sede, carrera, jornada  "
		   
'response.Write("<pre>"&consulta&"</pre>")
		   
formulario.Consultar consulta

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">

</script>
<% f_filtros.generaJS %>
   
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
                                      <td width="15%">Año</td>
                                      <td width="1%">:</td>
                                      <td width="88%"><%f_filtros.dibujaCampoLista "filtros", "anos_ccod"%></td>
                                    </tr>
                                    <tr> 
                                      <td width="15%">Sede</td>
                                      <td width="1%">:</td>
                                      <td width="88%"><%f_filtros.dibujaCampoLista "filtros", "sede_ccod"%></td>
                                    </tr>
									<tr> 
                                      <td width="15%">Carrera</td>
                                      <td width="1%">:</td>
                                      <td width="88%"><%f_filtros.dibujaCampoLista "filtros", "carr_ccod"%></td>
                                    </tr>
									<tr> 
                                      <td width="15%">Jornada</td>
                                      <td width="1%">:</td>
                                      <td width="88%"><%f_filtros.dibujaCampoLista "filtros", "jorn_ccod"%></td>
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
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
                  <td bgcolor="#D8D8DE" width="670">&nbsp; 

					 <div align="center">&nbsp;  
						<BR>
						<%pagina.DibujarTituloPagina%>
						<br><br>
					  </div>
					  <table  width="100%" border="0">
						<tr> 
						  <td colspan="6"><div align="right">P&aacute;ginas: &nbsp;<%formulario.AccesoPagina%></div></td>
						</tr>
						<form name="edicion">
						<tr> 
						  <td colspan="6"><div align="center"><% formulario.DibujaTabla %></div></td>
						</tr>
						</form>
						<tr> 
						  <td colspan="6">&nbsp;</td>
						</tr>
						</table> 
				 </td>
				 <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="95" nowrap bgcolor="#D8D8DE">
				  <table width="249%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="33%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
					  <td width="34%"> <div align="center">  
					                   <% if carr_ccod <> "" then
					                       botonera.agregabotonparam "excel_carrera", "url", "cuentas_email_docentes_excel_carrera.asp?sede_ccod="&sede_ccod&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&anos_ccod="&anos_ccod
										   botonera.dibujaboton "excel_carrera"
										  end if 
										%>
					 </div>
                     </td>
				   <td width="33%"> 
				     <div align="center">  
					 <%if anos_ccod <> "" then 
					   botonera.agregabotonparam "excel_total", "url", "cuentas_email_docentes_excel_total.asp?anos_ccod="&anos_ccod
					   botonera.dibujaboton "excel_total"
					   end if
					 %>
					 </div>
                   </td>
				   
                  </tr>
                  </table></td>
                  <td width="345" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
   </td>
  </tr>  
</table>
</body>
</html>
