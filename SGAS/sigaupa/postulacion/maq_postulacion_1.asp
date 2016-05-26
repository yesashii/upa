<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------

%>


<html>
<head>
<title>Postulaci&oacute;n - Informaci&oacute;n General</title>
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
                <td>
				<%				
				pagina.DibujarLenguetas Array("Información general", "Datos Personales", "Ant. Académicos", "Ant. Familiares", "Apoderado Sostenedor"), 1
				%>				
				</td><td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
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
				      <table width="95%" border="1" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td valign="top">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                              <tr>
                                <td width="7" height="30">&nbsp;</td>
                                <td colspan="3" height="30"><b><font size="2">Bienvenido Sr(a): </font></b><font size="2">Juan  P&eacute;rez G.</font> (NUEVO) </td>
                              </tr>
                              <tr>
                                <td height="15">&nbsp;</td>
                                <td height="15" colspan="3">&nbsp;</td>
                              </tr>
                              <tr>
                                <td width="7" height="30">&nbsp;</td>
                                <td height="30" colspan="2"><strong><font size="1">Seleccciona :</font></strong>
                                    <div align="right"></div></td>
                                <td> &nbsp;&nbsp; </td>
                              </tr>
                              <tr>
                                <td height="20">&nbsp;</td>
                                <td height="20" colspan="3" valign="top">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td width="20%" height="22">
                                        <div align="right">Sede Postulaci&oacute;n </div></td>
                                      <td width="2%">:</td>
                                      <td><select name="select">
                                        <option>Selecciona sede</option>
                                        <option selected>TEMUCO</option>
                                        <option>SANTIAGO</option>
                                        <option>TALCA</option>
                                      </select></td>
                                    </tr>
                                    <tr>
                                      <td height="22">
                                        <div align="right">Carrera Postulaci&oacute;n </div></td>
                                      <td width="2%">:</td>
                                      <td><select name="select2">
                                        <option>Selecciona carrera</option>
                                        <option selected>ADMINISTRACION DE EMPRESAS</option>
                                        <option>PUBLICIDAD</option>
                                        <option>SERVICIO SOCIAL</option>
                                                                                                                                                                                              </select></td>
                                    </tr>
                                    <tr>
                                      <td height="22">
                                        <div align="right">Especialidad/ Menci&oacute;n&nbsp;</div></td>
                                      <td width="2%">:</td>
                                      <td><select name="select3">
                                        <option>Selecciona especialidad / menci&oacute;n</option>
                                        <option>PERSONAL</option>
                                        <option selected>FINANZAS</option>
                                        <option>SIN MENCION</option>
                                                                                                                                                                                              </select></td>
                                    </tr>
                                    <tr>
                                      <td height="22">
                                        <div align="right">Jornada Postulaci&oacute;n </div></td>
                                      <td width="2%">:</td>
                                      <td><select name="select4">
                                        <option>Selecciona jornada</option>
                                        <option selected>DIURNA</option>
                                        <option>VESPERTINA</option>
                                                                                                                                                        </select></td>
                                    </tr>
                                </table></td>
                              </tr>
                              <tr>
                                <td height="30">&nbsp;</td>
                                <td height="30" colspan="3"><strong><font size="1"><br>
            Caracter&iacute;sticas de la Carrera que has seleccionado :</font></strong></td>
                              </tr>
                              <tr>
                                <td height="30" colspan="4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td width="27%" height="22">
                                        <div align="right">T&iacute;tulo al cual opta<font color="#666666"><strong> </strong></font></div></td>
                                      <td width="3%"><div align="center">:</div></td>
                                      <td width="70%"><strong>T&eacute;cnico de Nivel Superior Administraci&oacute;n de Empresas con Menci&oacute;n en Finanzas</strong></td>
                                    </tr>
                                    <tr>
                                      <td width="27%" height="22">
                                        <div align="right">Duraci&oacute;n<font color="#666666"><strong> </strong></font></div></td>
                                      <td><div align="center">:</div></td>
                                      <td><strong>4 semestres.</strong></td>
                                    </tr>
                                    <tr>
                                      <td width="27%" height="22">
                                        <div align="right">Requiere Ex&aacute;men Inicial</div></td>
                                      <td><div align="center">:</div></td>
                                      <td><strong>No.</strong></td>
                                    </tr>
                                    <tr>
                                      <td height="22"><div align="right">Matr&iacute;cula</div></td>
                                      <td><div align="center">:</div></td>
                                      <td><strong>$ 100.000</strong></td>
                                    </tr>
                                </table></td>
                              </tr>
                              <tr>
                                <td width="7" height="30">&nbsp;</td>
                                <td width="84" height="30">&nbsp;</td>
                                <td width="121"> <strong></strong></td>
                                <td width="407">&nbsp;</td>
                              </tr>
                          </table></td>
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
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"><%pagina.DibujarBoton "Anterior" , "NAVEGAR", "maq_inicio.asp"%></div></td>
                      <td><div align="center">
                        <%pagina.DibujarBoton "Siguiente" , "NAVEGAR", "maq_postulacion_2.asp"%>
                      </div></td>
                      <td><div align="center">
                        <%pagina.DibujarBoton "Salir" , "NAVEGAR", "maq_inicio.asp"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
