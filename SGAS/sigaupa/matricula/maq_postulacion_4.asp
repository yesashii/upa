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
<title>Postulaci&oacute;n - Antecedentes Familiares</title>
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
.style6 {font-size: 10px; color: #333333; }
.style7 {font-size: 10px; color: #FFFFFF; }
.style8 {color: #333333}
.style10 {	font-size: 12px;
	font-weight: bold;
}
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
                <td><%				
				pagina.DibujarLenguetas Array("Informaci&oacute;n general", "Datos Personales", "Ant. Acad&eacute;micos", "Ant. Familiares", "Apoderado Sostenedor"), 4
				%></td>
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
				      <table width="95%" border="1" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td valign="top"><div align="center">
                            <p><span class="style10"><br> 
                            ANTECEDENTES FAMILIARES </span></p>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><p><strong>PADRE</strong></p>                                </td>
                              </tr>
                            </table> 
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="33%">R.U.T.<br>
                                    <input name="textfield5" type="text" size="12">
      -
      <input name="textfield22" type="text" size="1"></td>
                                <td width="67%">FECHA DE NACIMIENTO <br>
                                    <input name="textfield52" type="text" size="12"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td>APELLIDO PATERNO <br>
                                    <input name="textfield43" type="text" size="30"></td>
                                <td>APELLIDO MATERNO <br>
                                    <input name="textfield423" type="text" size="30"></td>
                                <td>NOMBRES<br>
                                    <input name="textfield43" type="text" size="30"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="33%">REGI&Oacute;N<br>
                                    <select name="select4">
                                      <option selected>Regi&oacute;n</option>
                                      <option>I REGION</option>
                                      <option>II REGION</option>
                                      <option>III REGION</option>
                                      <option>IV REGION</option>
                                    </select>
                                </td>
                                <td width="67%">CIUDAD O LOCALIDAD DE PROCEDENCIA<br>
                                    <select name="select3">
                                      <option selected>Ciudad</option>
                                      <option>ARICA</option>
                                      <option>ANTOFAGASTA</option>
                                      <option>TALCA</option>
                                      <option>LOS ANGELES</option>
                                      <option>TEMUCO</option>
                                  </select></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="38%">CALLE<br>
                                    <input name="textfield4452" type="text" size="40"></td>
                                <td width="11%">N&Uacute;MERO<br>
                                    <input name="textfield5232" type="text" size="8"></td>
                                <td width="39%">VILLA O SECTOR<br>
                                    <input name="textfield44232" type="text" size="40"></td>
                                <td width="12%">TEL&Eacute;FONO<br>
                                    <input name="textfield5332" type="text" size="12"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td colspan="4">ESCOLARIDAD
                                (&Uacute;LTIMO A&Ntilde;O CURSADO) </td>
                              </tr>
                              <tr>
                                <td><input name="r1" type="radio" value="radiobutton">
                                B&Aacute;SICA</td>
                                <td><input name="r1" type="radio" value="radiobutton">
                                MEDIA</td>
                                <td><input name="r1" type="radio" value="radiobutton">
                                UNIVERSITARIA</td>
                                <td><input name="r1" type="radio" value="radiobutton">
                                  OTRO
  <input type="text" name="textfield6"></td>
                              </tr>
                            </table>
                            <br>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td>PROFESI&Oacute;N U OFICIO <br>
                                <input name="textfield44532" type="text" size="30"></td>
                                <td>EMPRESA<br>
                                <input name="textfield445322" type="text" size="30"></td>
                                <td>CARGO O ACTIVIDAD <br>
                                <input name="textfield445323" type="text" size="30"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="50%">REGI&Oacute;N<br>
                                    <select name="select">
                                      <option selected>Regi&oacute;n</option>
                                      <option>I REGION</option>
                                      <option>II REGION</option>
                                      <option>III REGION</option>
                                      <option>IV REGION</option>
                                    </select>
                                </td>
                                <td width="50%">CIUDAD O LOCALIDAD<br>
                                    <select name="select">
                                      <option selected>Ciudad</option>
                                      <option>ARICA</option>
                                      <option>ANTOFAGASTA</option>
                                      <option>TALCA</option>
                                      <option>LOS ANGELES</option>
                                      <option>TEMUCO</option>
                                  </select></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="37%">CALLE<br>
                                    <input name="textfield4453" type="text" size="40"></td>
                                <td width="12%">N&Uacute;MERO<br>
                                    <input name="textfield5233" type="text" size="10"></td>
                                <td width="39%">VILLA O SECTOR<br>
                                    <input name="textfield44233" type="text" size="40"></td>
                                <td width="12%">TEL&Eacute;FONO<br>
                                    <input name="textfield5333" type="text" size="12"></td>
                              </tr>
                            </table>
                            <br>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><p><strong>MADRE</strong></p></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="33%">R.U.T.<br>
                                    <input name="textfield53" type="text" size="12">
      -
      <input name="textfield222" type="text" size="1"></td>
                                <td width="67%">FECHA DE NACIMIENTO <br>
                                    <input name="textfield522" type="text" size="12"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td>APELLIDO PATERNO <br>
                                    <input name="textfield432" type="text" size="30"></td>
                                <td>APELLIDO MATERNO <br>
                                    <input name="textfield4232" type="text" size="30"></td>
                                <td>NOMBRES<br>
                                    <input name="textfield432" type="text" size="30"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="33%">REGI&Oacute;N<br>
                                    <select name="select2">
                                      <option selected>Regi&oacute;n</option>
                                      <option>I REGION</option>
                                      <option>II REGION</option>
                                      <option>III REGION</option>
                                      <option>IV REGION</option>
                                    </select>
                                </td>
                                <td width="67%">CIUDAD O LOCALIDAD DE PROCEDENCIA<br>
                                    <select name="select2">
                                      <option selected>Ciudad</option>
                                      <option>ARICA</option>
                                      <option>ANTOFAGASTA</option>
                                      <option>TALCA</option>
                                      <option>LOS ANGELES</option>
                                      <option>TEMUCO</option>
                                  </select></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="38%">CALLE<br>
                                    <input name="textfield44522" type="text" size="40"></td>
                                <td width="11%">N&Uacute;MERO<br>
                                    <input name="textfield52322" type="text" size="8"></td>
                                <td width="39%">VILLA O SECTOR<br>
                                    <input name="textfield442322" type="text" size="40"></td>
                                <td width="12%">TEL&Eacute;FONO<br>
                                    <input name="textfield53322" type="text" size="12"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td colspan="4">ESCOLARIDAD (&Uacute;LTIMO A&Ntilde;O CURSADO) </td>
                              </tr>
                              <tr>
                                <td><input name="r2" type="radio" value="radiobutton">      
                                B&Aacute;SICA</td>
                                <td><input name="r2" type="radio" value="radiobutton">      
                                MEDIA</td>
                                <td><input name="r2" type="radio" value="radiobutton">      
                                UNIVERSITARIA</td>
                                <td><input name="r2" type="radio" value="radiobutton">      
                                  OTRO
          <input type="text" name="textfield62"></td></tr>
                            </table>
                            <br>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td>PROFESI&Oacute;N U OFICIO <br>
                                    <input name="textfield445324" type="text" size="30"></td>
                                <td>EMPRESA<br>
                                    <input name="textfield4453222" type="text" size="30"></td>
                                <td>CARGO O ACTIVIDAD <br>
                                    <input name="textfield4453232" type="text" size="30"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="50%">REGI&Oacute;N<br>
                                    <select name="select2">
                                      <option selected>Regi&oacute;n</option>
                                      <option>I REGION</option>
                                      <option>II REGION</option>
                                      <option>III REGION</option>
                                      <option>IV REGION</option>
                                    </select>
                                </td>
                                <td width="50%">CIUDAD O LOCALIDAD<br>
                                    <select name="select2">
                                      <option selected>Ciudad</option>
                                      <option>ARICA</option>
                                      <option>ANTOFAGASTA</option>
                                      <option>TALCA</option>
                                      <option>LOS ANGELES</option>
                                      <option>TEMUCO</option>
                                  </select></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="37%">CALLE<br>
                                    <input name="textfield44533" type="text" size="40"></td>
                                <td width="12%">N&Uacute;MERO<br>
                                    <input name="textfield52332" type="text" size="10"></td>
                                <td width="39%">VILLA O SECTOR<br>
                                    <input name="textfield442332" type="text" size="40"></td>
                                <td width="12%">TEL&Eacute;FONO<br>
                                    <input name="textfield53332" type="text" size="12"></td>
                              </tr>
                            </table>
                            <p>&nbsp;</p>
                            </div></td>
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
                      <td><div align="center"><%pagina.DibujarBoton "Anterior" , "NAVEGAR", "maq_postulacion_3.asp"%></div></td>
                      <td><div align="center">
                        <%pagina.DibujarBoton "Siguiente" , "NAVEGAR", "maq_postulacion_5.asp"%>
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
s
</body>
</html>
