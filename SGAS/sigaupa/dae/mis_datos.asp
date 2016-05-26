<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tdet_ccod =Request.QueryString("b[0][tdet_ccod]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")
q_peri_ccod= request.QueryString("b[0][peri_ccod]")

set pagina = new CPagina
pagina.Titulo = "Becas"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set f_botonera = new CFormulario
f_botonera.carga_parametros "mis_datos.xml", "botonera"


set botonera = new CFormulario
botonera.carga_parametros "mis_datos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "mis_datos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_mis_datos = new CFormulario
f_mis_datos.Carga_Parametros "mis_datos.xml", "mis_datos"
f_mis_datos.Inicializar conexion

f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod

 
 if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
   filtro1=filtro1&"and pers_nrut="&q_pers_nrut&""
 
                    
end if
 
 if q_sede_ccod <> "" then
	

  	filtro2=filtro2&"and c.sede_ccod="&q_sede_ccod&""
  					
end if
 

 
 
 
if q_peri_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos="select a.pers_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,"&q_peri_ccod&"as peri_ccod,"& vbCrLf &_
				"upper(pers_tape_paterno)+' '+upper(pers_tape_materno)+' '+upper(pers_tnombre)as nombre"& vbCrLf &_
				"from personas a, "& vbCrLf &_
				"alumnos b,"& vbCrLf &_
				"ofertas_academicas c,"& vbCrLf &_
				"especialidades d,"& vbCrLf &_
				"mis_datos g"& vbCrLf &_
				"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=c.ofer_ncorr"& vbCrLf &_
				"and c.espe_ccod=d.espe_ccod"& vbCrLf &_
				"and a.pers_ncorr=g.pers_ncorr"& vbCrLf &_
				"and peri_ccod="&q_peri_ccod&""& vbCrLf &_
				"and post_bnuevo='S'"& vbCrLf &_
				""&filtro1&""& vbCrLf &_
				""&filtro2&""& vbCrLf &_
				"and emat_ccod=1"& vbCrLf &_
				"order by nombre"
				
			
			
sql_total="select count(distinct a.pers_ncorr)"& vbCrLf &_
				"from personas a, "& vbCrLf &_
				"alumnos b,"& vbCrLf &_
				"ofertas_academicas c,"& vbCrLf &_
				"especialidades d,"& vbCrLf &_
				"mis_datos g"& vbCrLf &_
				"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=c.ofer_ncorr"& vbCrLf &_
				"and c.espe_ccod=d.espe_ccod"& vbCrLf &_
				"and a.pers_ncorr=g.pers_ncorr"& vbCrLf &_
				"and post_bnuevo='S'"& vbCrLf &_
				"and peri_ccod="&q_peri_ccod&""& vbCrLf &_
				""&filtro1&""& vbCrLf &_
				""&filtro2&""& vbCrLf &_
				"and emat_ccod=1"
total=conexion.ConsultaUno(sql_total)				
					
end if
'response.Write("<pre>"&sql_descuentos&"</pre>")
f_mis_datos.Consultar sql_descuentos
'f_mis_datos.Siguiente				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()




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
					
				  	<td width="15%"><strong>Sedes:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("sede_ccod")%></div>                </tr>
              </table>
			  <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><strong>Periodos Academico:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("peri_ccod")%></div>                </tr>
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
                    </table>					</tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Resultado Mis datos"%>
					
                      <table width="98%"  border="0" align="center">
					   <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_mis_datos.accesopagina%>                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
						       <%f_mis_datos.DibujaTabla()%>							   </td>
                        </tr>
                      </table>
					   <table align="right">
					   <td >Numero Total de Alumnos: <strong><%=total%></strong></td>
					    </table>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>                            </td>
                        </tr>
                      </table></td>
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
                  <td><div align="center">
                    
					<%f_botonera.AgregaBotonParam "excel", "url", "mis_datos_excel.asp?pers_nrut="&q_pers_nrut&"&pers_xdv="&q_pers_xdv&"&sede_ccod="&q_sede_ccod&"&peri_ccod="&q_peri_ccod
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
	<br>	</td>
  </tr>  
</table>
</body>
</html>