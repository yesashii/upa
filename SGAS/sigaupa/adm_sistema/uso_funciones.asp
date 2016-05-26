<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_sfun_ccod =Request.QueryString("b[0][sfun_ccod]")
q_fecha_ini= request.QueryString("b[0][fecha_inicio]")
q_fecha_fin= request.QueryString("b[0][fecha_fin]")
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
botonera.carga_parametros "uso_funciones.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "uso_funciones.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "uso_funciones.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "uso_funciones.xml", "cheques"
f_cheques.Inicializar conexion
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "sfun_ccod",q_sfun_ccod
f_busqueda.AgregaCampoCons "fecha_inicio", q_fecha_ini
f_busqueda.AgregaCampoCons "fecha_fin",q_fecha_fin


'response.Write("<pre>q_sfun_ccod="&q_sfun_ccod&"</pre>")



if q_pers_nrut <> "" and q_pers_xdv <> "" then
	
	
  filtro1=filtro1&"and lf.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_sfun_ccod <> "" then
	

  	filtro2=filtro2&"and lf.sfun_ccod='" &q_sfun_ccod&"'"
  					
end if
		
 
 if q_fecha_ini <> ""  and q_fecha_fin <> "" then
	

  	filtro3=filtro3&"and convert(datetime,fecha_log,103)  between convert(datetime,'" &q_fecha_ini&"',103) and  convert(datetime,'" &q_fecha_fin&"',103)"
  					
end if
'if q_fecha_ini = ""  or q_fecha_fin = "" or   q_sfun_ccod = "" or q_pers_nrut = "" or q_pers_xdv = "" then
'
'sql_descuentos= "select pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,smod_tdesc,sfun_tdesc,convert(datetime,fecha_log,103)as fecha_log "& vbCrLf &_ 
'  				"from log_funciones lf,sis_modulos sm,sis_funciones_modulos sf,personas p"& vbCrLf &_
'  				"where lf.smod_ccod=sm.smod_ccod"& vbCrLf &_
'  				"and lf.sfun_ccod=sf.sfun_ccod"& vbCrLf &_
'  				"and lf.pers_ncorr=p.pers_ncorr"& vbCrLf &_
'				" " &filtro2&" "& vbCrLf &_
'				" " &filtro1&" "& vbCrLf &_
'				" " &filtro3&" "& vbCrLf &_
'  				"order by fecha_log desc"
'end if				
				
if q_fecha_ini = ""  and q_fecha_fin = "" and   q_sfun_ccod = "" and q_pers_nrut = "" and q_pers_xdv = "" then
sql_descuentos="select ''"
else
sql_descuentos= "select pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,smod_tdesc,sfun_tdesc,convert(datetime,fecha_log,103)as fecha_log "& vbCrLf &_ 
  				"from log_funciones lf,sis_modulos sm,sis_funciones_modulos sf,personas p"& vbCrLf &_
  				"where lf.smod_ccod=sm.smod_ccod"& vbCrLf &_
  				"and lf.sfun_ccod=sf.sfun_ccod"& vbCrLf &_
  				"and lf.pers_ncorr=p.pers_ncorr"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
  				"order by fecha_log desc"
end if
					
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&q_pers_xdv&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()
'sql_descuentos="select ''"
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
					
					<td width="7%"><strong>Rut  :</strong></td>
					<td width="18%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
					<td width="2%">-</td>
					<td width="6%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%>
					</div></td>
					<td width="5%"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
                  	<td width="34%"></div></td>
					<td width="28%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td
					></tr>
					</table>
					<table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="16%"><strong>Fecha inicio:</strong></td>
				  	<td width="17%"><div align="left"><%f_busqueda.DibujaCampo("fecha_inicio")%></div>
					<td width="3%"></td>
					<td width="13%"><strong>Fecha fin:</strong></td>					
					<td width="21%"><div align="left"><%f_busqueda.DibujaCampo("fecha_fin")%></div>
					<td width="30%"><strong>dd/mm/aaaa</strong></td>
                </tr>
              </table>
					 <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="11%"><strong>Funcion:</strong></td>
				  	<td width="89%"><div align="left"><%f_busqueda.DibujaCampo("sfun_ccod")%></div>
					
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
                    <td><%pagina.DibujarSubtitulo "Datos Descuentos"%>
					
                      <table width="98%"  border="0" align="center">
					   <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_cheques.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
						       <%f_cheques.DibujaTabla()%>
							   </td>
						  
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>
                            </td>
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
                    
					<%f_botonera.AgregaBotonParam "excel", "url", "uso_funciones_excel.asp?pers_nrut="&q_pers_nrut&"&pers_xdv="&q_pers_xdv&"&sfun_ccod="&q_sfun_ccod&"&fecha_ini="&q_fecha_ini&"&fecha_fin="&q_fecha_fin
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