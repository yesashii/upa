<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tasi_ncorr =Request.QueryString("b[0][tasi_ncorr]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")
q_anos_ccod= request.QueryString("b[0][anos_ccod]")
q_carr_ccod= request.QueryString("b[0][carr_ccod]")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Historial de Documentos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "alumnos_taller.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "alumnos_taller.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "alumnos_taller.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "alumnos_taller.xml", "cheques"
f_cheques.Inicializar conexion
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "tasi_ncorr",q_tasi_ncorr
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "anos_ccod", q_anos_ccod
f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod




if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and a.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_tasi_ncorr <> "" then
	

  	filtro2=filtro2&"and cast(b.tasi_ncorr as varchar)='" &q_tasi_ncorr&"'"
  					
end if
		
 
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and b.sede_ccod='"&q_sede_ccod&"'"
  					
end if

 if q_carr_ccod <> "" then
	

  	filtro4=filtro4&"and c.carr_ccod='" &q_carr_ccod&"'"
  					
end if
 
if q_anos_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos= "select   protic.obtener_rut(a.pers_ncorr)as rut,protic.obtener_nombre(a.pers_ncorr,'n') as nombre,tasi_tdesc as taller,fecha as 				fecha_taller,peri_tdesc as periodo_academico,sede_tdesc as sede,carr_tdesc as carrera"& vbCrLf &_
				"from alumnos_talleres_psicologia a , talleres_dictados_sicologia b,carreras c,especialidades d,ofertas_academicas e,alumnos f,periodos_academicos g,sedes h,talleres_sicologia i"& vbCrLf &_
				"where a.tdsi_ncorr=b.tdsi_ncorr"& vbCrLf &_
				"and i.tasi_ncorr=b.tasi_ncorr"& vbCrLf &_
				"and g.peri_ccod=b.peri_ccod"& vbCrLf &_
				"and g.peri_ccod = e.peri_ccod"& vbCrLf &_
				"and h.sede_ccod=b.sede_ccod"& vbCrLf &_
				"and c.carr_ccod= d.carr_ccod " & vbCrLf &_
				" " &filtro4&" "& vbCrLf &_
				"and e.ofer_ncorr=f.ofer_ncorr "& vbCrLf &_
				"and f.pers_ncorr=a.pers_ncorr "& vbCrLf &_
				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				"order by taller,nombre"
  
  


				
				
				numero_total=conexion.ConsultaUno( "select count(a.pers_ncorr)   "& vbCrLf &_
				"from alumnos_talleres_psicologia a , talleres_dictados_sicologia b,carreras c,especialidades d,ofertas_academicas e,alumnos f,periodos_academicos g,sedes h,talleres_sicologia i"& vbCrLf &_
				"where a.tdsi_ncorr=b.tdsi_ncorr"& vbCrLf &_
				"and i.tasi_ncorr=b.tasi_ncorr"& vbCrLf &_
				"and g.peri_ccod=b.peri_ccod"& vbCrLf &_
				"and g.peri_ccod = e.peri_ccod"& vbCrLf &_
				"and h.sede_ccod=b.sede_ccod"& vbCrLf &_
				"and c.carr_ccod= d.carr_ccod " & vbCrLf &_
				" " &filtro4&" "& vbCrLf &_
				"and e.ofer_ncorr=f.ofer_ncorr "& vbCrLf &_
				"and f.pers_ncorr=a.pers_ncorr "& vbCrLf &_
				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" ")
				
				

total=numero_total			
end if

 usu=negocio.obtenerUsuario
					
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_carr_ccod&"</pre>")
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
              <table width="74%"  border="0" align="center">
                <tr>
					
					<td width="18%"><strong>Rut  :</strong></td>
					
					<td width="10%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
					<td width="4%">-</td>
					<td width="5%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%>
					</div></td>
					<td width="7%"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
                  	<td width="42%"></div></td>
					<td width="14%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td
					></tr>
					</table>
					
					 <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><p><strong>Talleres</strong><strong>:</strong></p></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("tasi_ncorr")%></div>
					
                </tr>
              </table>
			   <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><strong>Sedes:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("sede_ccod")%></div>
					
                </tr>
              </table>
			    <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="20%"><strong>Carrera:</strong></td>
				  	<td width="80%"><div align="left"><%f_busqueda.DibujaCampo("carr_ccod")%></div>
					
                </tr>
              </table>
			  <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><strong>Periodos Academico:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("anos_ccod")%></div>
					
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
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
					</tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Detalles Taller"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td align="right">P&aacute;gina:
                            <%f_cheques.accesopagina%>                            </td>
                            </tr>
                        <tr>						
                          <td align="center">
                            <%f_cheques.DibujaTabla()%>                            </td>
                        </tr>
                        </table>
					     <table align="right">
					       <td >Numero Total de Alumnos: <strong><%=total%></strong></td>
					      </table>
                        <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>
                              </td>
                          </tr>
                      </table></td></tr>
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
                  <td><div align="center">
                    
					<%f_botonera.AgregaBotonParam "excel", "url", "alumnos_taller_excel.asp?pers_nrut="&q_pers_nrut&"&pers_xdv="&q_pers_xdv&"&tasi_ncorr="&q_tasi_ncorr&"&sede_ccod="&q_sede_ccod&"&anos_ccod="&q_anos_ccod&"&carr_ccod="&q_carr_ccod
				   f_botonera.DibujaBoton"excel"  %></div></td>
				   
				  
						
				   
				   	 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
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