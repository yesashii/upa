<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Editar envio a Banco"
'------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------
envi_ncorr = request.querystring("envi_ncorr")
'------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Envios_Banco.xml", "botonera"
'-----------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion

  sql = "select b.tins_ccod, b.tins_tdesc, a.envi_ncorr, a.eenv_ccod, c.eenv_tdesc,a.envi_fenvio,  "& vbCrLf &_
		"	   d.plaz_tdesc, e.CCTE_TDESC, f.inen_tdesc "& vbCrLf &_
		"from envios a, tipos_instrumentos b, estados_envio c, plazas d, cuentas_corrientes e, instituciones_envio f "& vbCrLf &_
		"where a.tins_ccod = b.tins_ccod "& vbCrLf &_
		"  and a.eenv_ccod = c.eenv_ccod "& vbCrLf &_
		"  and a.plaz_ccod = d.plaz_ccod "& vbCrLf &_
		"  and a.CCTE_CCOD = e.CCTE_CCOD "& vbCrLf &_
		"  and a.inen_ccod = f.inen_ccod "& vbCrLf &_
		"  and a.envi_ncorr = '" & envi_ncorr & "'  "& vbCrLf
f_consulta.consultar sql
f_consulta.siguiente
estado = f_consulta.ObtenerValor("eenv_ccod")
'-----------------------------------------------------------------------

set f_editar = new CFormulario
f_editar.Carga_Parametros "envios_banco.xml", "f_editar"
f_editar.Inicializar conexion
sql = "select tins_ccod from envios where envi_ncorr='" & envi_ncorr & "'"
f_editar.consultar sql
f_editar.siguiente


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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="490" height="91%" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()%>
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br>
      <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                    <%pagina.DibujarTituloPagina%>
                    <br>
                  </div>
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td> <br>
						<table width="100%" border="0">
                            <tr> 
                              <td><font size="1"><strong>N&ordm; Folio</strong></font></td>
                              <td><font size="1"><strong>:</strong></font></td>
                              <td><font size="1"> 
                                <% f_consulta.DibujaCampo("envi_ncorr") %>
                                </font></td>
                              <td><font size="1"><strong>Fecha</strong></font></td>
                              <td><font size="1"><strong>:</strong></font></td>
                              <td><font size="1"> 
                                <% f_consulta.DibujaCampo("envi_fenvio") %>
                                </font></td>
                            </tr>
                            <tr> 
                              <td><font size="1"><strong>Banco</strong></font></td>
                              <td><font size="1"><strong>:</strong></font></td>
                              <td><font size="1"> 
                                <% f_consulta.DibujaCampo("inen_tdesc") %>
                                </font></td>
                              <td><font size="1"><strong>Plaza</strong></font></td>
                              <td><font size="1"><strong>:</strong></font></td>
                              <td><font size="1"> 
                                <% f_consulta.DibujaCampo("plaz_tdesc") %>
                                </font></td>
                            </tr>
                            <tr> 
                              <td><font size="1"><strong>Cta. Cte</strong></font></td>
                              <td><font size="1"><strong>:</strong></font></td>
                              <td><font size="1"> 
                                <% f_consulta.DibujaCampo("ccte_tdesc") %>
                                </font></td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="19%"><strong>Instrumento</strong></td>
                              <td width="4%"><strong>:</strong></td>
                              <td width="28%"><font size="1">
                                <% f_editar.DibujaCampo("tins_ccod") %>
                                </font></td>
                              <td width="11%"><font size="1">&nbsp;</font></td>
                              <td width="4%"><font size="1">&nbsp;</font></td>
                              <td width="34%"><font size="1">&nbsp;</font></td>
                            </tr>
                          </table>
						</td>
                      </tr>
                    </table>
                   <BR>
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="28%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="left">
                            <% if estado = "1" then
							     botonera.agregabotonParam "guardar_edicion", "deshabilitado", "FALSE"
							   else
							     botonera.agregabotonParam "guardar_edicion", "deshabilitado", "TRUE"
							   end if
							   botonera.agregabotonParam "guardar_edicion", "url", "Proc_editar_Envio_Banco.asp?envi_ncorr=" & envi_ncorr
							   botonera.dibujaboton("guardar_edicion") %>
                          </div></td>
                        <td> <div align="left">
                            <% botonera.dibujaboton("cancelar") %>
                          </div></td>
                        <td><div align="center"></div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="72%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> <br> </td>
  </tr>
</table>
</body>
</html>
