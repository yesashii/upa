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
<title>Postulaci&oacute;n - Datos Personales</title>
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
.style7 {
	font-size: 12px;
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
				pagina.DibujarLenguetas Array("Informaci&oacute;n general", "Datos Personales", "Ant. Acad&eacute;micos", "Ant. Familiares", "Apoderado Sostenedor"), 2
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
                            <p class="style7"><br>
                            DATOS PERSONALES </p>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><p><strong>CARRERA :</strong><br>
                                  ADMINISTRACI&Oacute;N DE EMPRESAS - MENCI&Oacute;N FINANZAS
                                </p>                                </td>
                              </tr>
                            </table>
                            <br>  
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="50%">R.U.T.<br>
                                <input name="textfield" type="text" value="11111111" size="12"> 
                                - 
                                <input name="textfield2" type="text" value="1" size="1"></td>
                                <td width="50%">C&Oacute;DIGO DEL ALUMNO<br>
                                <input type="text" name="textfield3" disabled value="11111111103"> </td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><strong>1. IDENTIFICACI&Oacute;N DEL ALUMNO </strong></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td>APELLIDO PATERNO <br>
                                <input name="textfield4" type="text" value="P&Eacute;REZ" size="30"></td>
                                <td>APELLIDO MATERNO <br>
                                <input name="textfield42" type="text" value="G&Oacute;MEZ" size="30"></td>
                                <td>NOMBRES<br>
                                <input name="textfield43" type="text" value="JUAN ERNESTO" size="30"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td>FECHA DE NACIMIENTO <br>
                                <input name="textfield5" type="text" size="12"></td>
                                <td>CIUDAD DE NACIMIENTO <br>
                                  <select name="select">
                                    <option selected>Ciudad</option>
                                    <option>ARICA</option>
                                    <option>ANTOFAGASTA</option>
                                    <option>TALCA</option>
                                    <option>LOS ANGELES</option>
                                    <option>TEMUCO</option>
                                    </select></td>
                              </tr>
                              <tr>
                                <td><br>
                                SEXO<br>
                                <input name="r1" type="radio" value="radiobutton">
                                Masculino 
                                <input name="r1" type="radio" value="radiobutton">
                                Femenino</td>
                                <td><br>
                                  ESTADO CIVIL <br>
                                  <select name="select2">
                                    <option selected>Estado Civil</option>
                                    <option>SOLTERO</option>
                                    <option>CASADO</option>
                                    <option>VIUDO</option>
                                    <option>SEPARADO</option>
                                  </select></td>
                              </tr>
                            </table>
                            <br>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><strong>2. RESIDENCIA DE ORIGEN DEL ALUMNO </strong></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="50%">REGI&Oacute;N<br>
                                  <select name="select4">
                                    <option selected>Regi&oacute;n</option>
                                    <option>I REGION</option>
                                    <option>II REGION</option>
                                    <option>III REGION</option>
                                    <option>IV REGION</option>
                                    </select> </td>
                                <td width="50%">CIUDAD O LOCALIDAD DE PROCEDENCIA<br>
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
                                <td width="37%">CALLE<br>
                                    <input name="textfield445" type="text" size="40"></td>
                                <td width="12%">N&Uacute;MERO<br>
                                    <input name="textfield523" type="text" size="10"></td>
                                <td width="39%">VILLA O SECTOR<br>
                                    <input name="textfield4423" type="text" size="40"></td>
                                <td width="12%">TEL&Eacute;FONO<br>
                                    <input name="textfield533" type="text" size="12"></td>
                              </tr>
                            </table>
                            <br>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><strong>3. DOMICILIO EN EL PERIODO ACAD&Eacute;MICO </strong></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="40%">CALLE<br>
                                    <input name="textfield443" type="text" size="40"></td>
                                <td width="16%">N&Uacute;MERO<br>
                                    <input name="textfield522" type="text" size="12"></td>
                                <td width="44%">VILLA O SECTOR<br>
                                    <input name="textfield4422" type="text" size="40"></td>
                              </tr>
                              <tr>
                                <td>CIUDAD<br>
                                  <select name="select5">
                                    <option selected>Ciudad</option>
                                    <option>ARICA</option>
                                    <option>ANTOFAGASTA</option>
                                    <option>TALCA</option>
                                    <option>LOS ANGELES</option>
                                    <option>TEMUCO</option>
                                  </select>
                                </td>
                                <td><br>
                                  TEL&Eacute;FONO<br>
                                  <input name="textfield532" type="text" size="12"></td>
                                <td><br>
                                  CORREO ELECTR&Oacute;NICO<br>
                                  <input name="textfield444" type="text" size="40"></td>
                              </tr>
                            </table>
                            <br>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><strong>4. INFORMACI&Oacute;N DE ALUMNOS EXTRANJEROS </strong></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="31%">PA&Iacute;S DE ORIGEN <br>
                                  <select name="select7">
                                    <option selected>Pa&iacute;s</option>
                                    <option>ARGENTINA</option>
                                    <option>AUSTRALIA</option>
                                    <option>BRASIL</option>
                                    <option>JAPON</option>
                                                                                                      </select>
                                                                    </td>
                                <td width="30%">CEDULA DE IDENTIDAD <br>
                                    <input name="textfield6" type="text" size="12">
-
<input name="textfield22" type="text" size="1">
</td>
                                <td width="39%">N&ordm; PASAPORTE <br>
                                    <input name="textfield44222" type="text" size="40"></td>
                              </tr>
                              <tr>
                                <td>TIPO VISA <br>
                                    <select name="select6">
                                      <option selected>Tipo de Visa</option>
                                      <option>ESTUDIO</option>
                                                                                                            </select>                                </td>
                                <td><br>
      FECHA DE EMISI&Oacute;N <br>
      <input name="textfield5322" type="text" size="12"></td>
                                <td><br> 
                                  FECHA DE VENCIMIENTO    <br>
      <input name="textfield53222" type="text" size="12">
</td>
                              </tr>
                              <tr>
                                <td><br>
                                  &iquest;DOBLE NACIONALIDAD?<br>
                                  <input name="r2" type="radio" value="radiobutton">
                                  S&iacute;
                                  <input name="r2" type="radio" value="radiobutton">
                                  No</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                            </table>
                            <br>
                            <br>
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
                      <td><div align="center"><%pagina.DibujarBoton "Anterior" , "NAVEGAR", "maq_postulacion_1.asp"%></div></td>
                      <td><div align="center">
                        <%pagina.DibujarBoton "Siguiente" , "NAVEGAR", "maq_postulacion_3.asp"%>
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
