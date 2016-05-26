<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

s = negocio.ObtenerFechaInicio("CLASES", "E")

'---------------------------------------------------------------------------------------------------

%>


<html>
<head>
<title>Postulaci&oacute;n - Apoderado Sostenedor</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
</script>

<style type="text/css">
<!--
.style11 {font-size: 10px; color: #FFFFFF; }
-->
</style>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="6"><img src="../imagenes/izq_1.gif" width="6" height="17"></td>
                    <td width="250" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="center" class="style11"><font face="Verdana, Arial, Helvetica, sans-serif">CONSTANCIA DE ENV&Iacute;O DE POSTULACI&Oacute;N </font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td bgcolor="#D8D8DE">&nbsp;</td>
                  </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <form name="edicion">
			          <table width="610" border="1" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                              <tr>
                                <td height="25">&nbsp;</td>
                                <td height="25">Fecha Constancia</td>
                                <td height="25">:</td>
                                <td height="25" colspan="2"><strong><font size="2"><%=day(Now())&"/"& Month(Now()) & "/" & Year(Now())%>&nbsp;</font></strong>
                                    <div align="right"></div></td>
                                <td width="108" height="25">FOLIO: <strong></strong> <font size="2">&nbsp;</font>&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="25">&nbsp;</td>
                                <td height="25">&nbsp;</td>
                                <td height="25">&nbsp;</td>
                                <td height="25" colspan="3">&nbsp;</td>
                              </tr>
                              <tr>
                                <td width="9" height="25">&nbsp;</td>
                                <td width="118" height="25">Nombre Completo</td>
                                <td width="11" height="25">:</td>
                                <td height="25" colspan="3"> <strong></strong> <strong><font size="2">JUAN ERNESTO P&Eacute;REZ G&Oacute;MEZ. </font></strong></td>
                              </tr>
                              <tr>
                                <td height="25">&nbsp;</td>
                                <td height="25">RUT&nbsp; Postulante</td>
                                <td height="25">:</td>
                                <td height="25"><strong><font size="2">11111111-1</font></strong></td>
                                <td height="25">&nbsp;</td>
                                <td height="25">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="25">&nbsp;</td>
                                <td height="25">Sede Postulaci&oacute;n</td>
                                <td height="25">:</td>
                                <td height="25"><strong><font size="2">TEMUCO</font></strong></td>
                                <td height="25">&nbsp;</td>
                                <td height="25">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="25">&nbsp;</td>
                                <td height="25">Carrera Postulaci&oacute;n</td>
                                <td height="25">:</td>
                                <td height="25"><strong><font size="2">ADMINISTRACI&Oacute;N DE EMPRESAS </font></strong></td>
                                <td height="25">&nbsp;</td>
                                <td height="25">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="25">&nbsp;</td>
                                <td height="25">Especialidad/Menci&oacute;n</td>
                                <td height="25">:</td>
                                <td height="25"><strong><font size="2">FINANZAS</font></strong></td>
                                <td height="25">&nbsp;</td>
                                <td height="25">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="25">&nbsp;</td>
                                <td height="25">Jornada Postulaci&oacute;n</td>
                                <td height="25">:</td>
                                <td height="25"><strong><font size="2">DIURNA</font></strong></td>
                                <td height="25">&nbsp;</td>
                                <td height="25">&nbsp;</td>
                              </tr>
                            </table>
                            <p><font size="2"><br>
                            </font>El presente documento acredita tu postulaci&oacute;n 
                            a Universidad del Pacifico. En ning&uacute;n caso 
                            representa una reserva de matr&iacute;cula.</p>
                            
                          <p> Para &nbsp;ello debes acercarte a cualquier sede 
                            de Universidad del Pacificor y hacer efectiva tu matr&iacute;cula 
                            2004.</p>
                            
                          <p>Si desea realizar cambios a tu postulaci&oacute;n, 
                            ya enviada a Universidad del Pacifico, debes hacerlo 
                            en cualquier Oficina de Registro Curricular.<br>
      <br>
      </p>
                                          <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="20" align="center"><div align="left">
            <p><strong>Documentaci&oacute;n que debes presentar al momento de matricularte: </strong></p>
            <p>&nbsp;</p>
          </div></td>
          </tr>
        <tr>
          <td width="71%" height="14" align="center"><div align="left">
            <ul>
              <li>Certificado de Nacimiento </li>
            </ul>
          </div></td>
          </tr>
        <tr>
          <td height="15" align="center"><div align="left">
            <ul>
              <li>Certificado de Concentraci&oacute;n de Notas de E.M. </li>
            </ul>
          </div></td>
          </tr>
        <tr>
          <td height="17" align="center"><div align="left">
            <ul>
              <li>4 fotos tama&ntilde;o carn&eacute;, con nombre y R.U.T.</li>
            </ul>
          </div></td>
          </tr>
        <tr>
          <td height="15"><ul>
              <li>Licencia de Ense&ntilde;anza Media.(Si es fotocopia debe estar
                legalizada ante notario)</li>
            </ul>
          </td>
          </tr>
        <tr>
          <td height="15"><ul>
              <li>Bolet&iacute;n N&ordm; 1 P.A.A. </li>
            </ul>
          </td>
          </tr>
        <tr>
          <td height="15"><ul>
              <li>Certificado de T&iacute;tulo </li>
            </ul>
          </td>
          </tr>
        <tr>
          <td height="16"><ul>
              <li>Certificado de Residencia o boleta de alg&uacute;n servicio tal como
                Luz, Agua, Gas o Tel&eacute;fono</li>
            </ul>
          </td>
          </tr>
        <tr>
          <td height="17"><ul>
              <li>Certificado de Antiguedad de Trabajo o Contrato de Trabajo</li>
            </ul>
          </td>
          </tr>
        <tr>
          <td height="20" align="center"><p><em><br>
                <font size="1" face="Verdana, Arial, Helvetica, sans-serif">S&oacute;lo ser&aacute;n recibidos los documentos originales o aqu&eacute;llos
              que se encuentren debidamente legalizados. </font></em></p>            </td>
          </tr>
      </table>
      <br>
                          </td>
                        </tr>
                      </table>
				    </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="171" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"><%pagina.DibujarBoton "Anterior" , "NAVEGAR", "maq_postulacion_5.asp"%></div></td>
                      <td><div align="center"> 
                          <%pagina.DibujarBoton "Salir" , "NAVEGAR", "maq_inicio.asp"%>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="185" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="310" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
