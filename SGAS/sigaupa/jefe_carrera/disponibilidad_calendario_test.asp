<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Disponibilidad horaria escuelas"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------
periodo = negocio.obtenerPeriodoAcademico("POSTULACION")
periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar) ='"&periodo&"'")
'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "disponibilidad_calendario_test.xml", "botonera"
'-------------------------------------------------------------------------------
 carr_ccod   	 =   request.QueryString("busqueda[0][carr_ccod]")
 jorn_ccod	 	 =	request.querystring("busqueda[0][jorn_ccod]")
 sede_ccod	 	 =	request.querystring("busqueda[0][sede_ccod]")
 g	 	 		 =	request.querystring("g")

 Sede = sede_ccod
 sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
 carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar) ='"&carr_ccod&"'")
 jorn_tdesc = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar) ='"&jorn_ccod&"'")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "disponibilidad_calendario_test.xml", "busqueda"
 f_busqueda.Inicializar conexion
 peri = periodo
 
 consulta="Select '"&sede_ccod&"' as sede_ccod, '"&carr_ccod&"' as carr_ccod, '"&jorn_ccod&"' as jorn_ccod "
 f_busqueda.consultar consulta

 usuario=negocio.ObtenerUsuario()
 pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


 consulta = " select distinct a.sede_ccod, protic.initCap(e.sede_tdesc) as sede,ltrim(rtrim(c.carr_ccod)) as carr_ccod, " & vbCrLf & _
            " protic.initCap(c.carr_tdesc) as carrera, a.jorn_ccod,protic.initCap(f.jorn_tdesc) as jornada " & vbCrLf & _
			" from ofertas_academicas a, especialidades b, carreras c, aranceles d, sedes e, jornadas f " & vbCrLf & _
			" where a.espe_ccod=b.espe_ccod and b.carr_ccod=c.carr_ccod " & vbCrLf & _
			" and a.aran_ncorr=d.aran_ncorr and cast(a.peri_ccod as varchar)='"&periodo&"' and d.aran_mmatricula > 0 " & vbCrLf & _
			" and d.aran_mcolegiatura > 0 and a.post_bnuevo='S' and a.sede_ccod=e.sede_ccod  " & vbCrLf & _
			" and a.jorn_ccod=f.jorn_ccod " & vbCrLf & _
			" and a.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
			" order by sede,carrera,jornada" 
			
'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 f_busqueda.Siguiente
 
 set f_dias = new CFormulario
 f_dias.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_dias.Inicializar conexion

 sql_dias =   "select dias_ccod,dias_tdesc from dias_semana order by dias_ccod "
 f_dias.consultar sql_dias
 
 set f_horas = new CFormulario
 f_horas.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_horas.Inicializar conexion

 sql_horas =   "select htes_ccod, htes_hinicio, htes_htermino from horarios_test order by htes_ccod "
 f_horas.consultar sql_horas
 
 set f_alumnos = new CFormulario
 f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_alumnos.Inicializar conexion
 
 facu_ccod = conexion.consultaUno("select facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carr_ccod&"'")
 
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
function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="disponibilidad_calendario_test.asp";
			formulario.submit();
}
function calificar_test(rut,postulacion,oferta)
{
	var ruta = "edita_examen_postulante.asp?q_pers_nrut="+rut+"&post_ncorr="+postulacion+"&ofer_ncorr="+oferta;
	window.open(ruta,"2","width=770,height=400");
}
</script>
<% f_busqueda.generaJS %>
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
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0">
                      <tr>
                        <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="13%"> <div align="left">Sede</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td width="54%"><% f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
								<td width="31%"> <div align="center"><%botonera.dibujaboton "buscar"%></div> </td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Carrera</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Jornada</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left"></div></td>
								<td width="2%"> <div align="center"></div> </td>
								<td colspan="2"><div  align="right" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se carga el calendario...</font></div></td>
                              </tr>
                            </table></td>
                       </tr>
                    </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                    <table width="100%" border="0">
                      <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <%if g = "1" then %>
					  <tr> 
                        <td colspan="3" bgcolor="#006633" align="center"><font color="#FFFFFF">...La disponibilidad fue grabada exitosamente...</font></td>
                      </tr>
					  <%end if%>
					  <%if Request.QueryString <> "" then%>
					  <tr> 
                        <td width="9%">Sede</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=sede_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Carrera</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=carr_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Jornada</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=jorn_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Periodo</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=periodo_tdesc%></td>
                      </tr>
					  <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <tr> 
                        <td colspan="3">
						        <table width="98%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" border="2" bordercolor="#0099CC">
								<tr> 
									<td colspan="8" align="center"><font color="#990000">Las casillas marcadas serán consideradas para la asignación de horarios para Test.</font></td>
								</tr>
								<tr>
									<td align="center"><font size="3" color="#0099CC">HORA</font></td>
									<td align="center"><font size="3" color="#0099CC">LUNES</font></td>
									<td align="center"><font size="3" color="#0099CC">MARTES</font></td>
									<td align="center"><font size="3" color="#0099CC">MIERCOLES</font></td>
									<td align="center"><font size="3" color="#0099CC">JUEVES</font></td>
									<td align="center"><font size="3" color="#0099CC">VIERNES</font></td>
									<td align="center"><font size="3" color="#0099CC">SABADO</font></td>
									<td align="center"><font size="3" color="#0099CC">DOMINGO</font></td>
								</tr>
								<form name="edicion" method="post">
								<input type="hidden" name="sede_ccod" value="<%=sede_ccod%>">
								<input type="hidden" name="carr_ccod" value="<%=carr_ccod%>">
								<input type="hidden" name="jorn_ccod" value="<%=jorn_ccod%>">
								<%while f_horas.siguiente
								    hora = f_horas.obtenerValor("htes_ccod")
									inicio = f_horas.obtenerValor("htes_hinicio")
									fin = f_horas.obtenerValor("htes_htermino")%>
								    <tr>
									    <td align="center"><font color="#000000"><%=hora%></font><br><font color="#990000"><%=inicio%></font></td>
										<%while f_dias.siguiente
										    dia = f_dias.obtenerValor("dias_ccod")
											color= "#FFFFFF"
											estado = "0"
											c_estado = " select isnull(estado,1) from DISPONIBILIDAD_TEST where cast(sede_ccod as varchar)='"&sede_ccod&"' "&_
											           " and carr_ccod = '"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' "&_
													   " and cast(dias_ccod as varchar) = '"&dia&"' and cast(htes_ccod as varchar)='"&hora&"' "
											estado = conexion.consultaUno(c_estado)
											if esVacio(estado = "") then
												estado = "1"
											end if
										    
											if estado = "1" then
												color= "#FFFFFF"
												tildado = "checked"
											else
												color= "#CCCCCC"
												tildado = ""
											end if	
										
											
										 %>
												<td align="center" bgcolor="<%=color%>">
													   <input type="checkbox" name="modulo_<%=dia%>_<%=hora%>" value="1" <%=tildado%> >
												</td>
									    <%wend
										  f_dias.primero%>
									</tr>
								<%wend%>
								</form>
						        </table>
						</td>
                      </tr>
					  <tr> 
                        <td colspan="3" align="right"><font color="#990000">&nbsp;</font></td>
                      </tr>
					  <%end if%>
                    </table>
                  </div>
              </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td width="14%"><div align="center"><%botonera.dibujaBoton "siguiente"%></div></td>
						 <td width="14%">&nbsp;</td>
						 <td width="14%">&nbsp;</td>
						</tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
