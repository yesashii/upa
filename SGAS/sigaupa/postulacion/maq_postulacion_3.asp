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
<title>Postulaci&oacute;n - Antecedentes Acad&eacute;micos</title>
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
.style9 {	font-size: 12px;
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
				pagina.DibujarLenguetas Array("Informaci&oacute;n general", "Datos Personales", "Ant. Acad&eacute;micos", "Ant. Familiares", "Apoderado Sostenedor"), 3
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
                            <p><span class="style9"><br> 
                              ANTEDEDENTES ACAD&Eacute;MICOS</span></p>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><p>ACTIVIDADES REALIZADAS EL A&Ntilde;O :<strong>                                    <input name="textfield7" type="text" size="12">
                                </strong></p>                                </td>
                              </tr>
                            </table> 
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="33%"><input name="r8" type="radio" value="radiobutton">
                                ENSE&Ntilde;ANZA MEDIA </td>
                                <td width="33%"><input name="r8" type="radio" value="radiobutton">                                  
                                TRABAJO<br>                                </td>
                                <td width="33%"><input name="r8" type="radio" value="radiobutton">
                                ESTUDIOS SUPERIORES </td>
                              </tr>
                            </table>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="18">&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td>ESTABLECIMIENTO DONDE EGRES&Oacute; DE ENSE&Ntilde;ANZA
                                MEDIA </td>
                                <td>
A&Ntilde;O DE EGRESO</td>
                              </tr>
                              <tr>
                                <td width="75%" height="24">                                  <p>                                    
                                    <select name="select">
                                      <option selected>Regi&oacute;n</option>
                                      <option>I REGION</option>
                                      <option>II REGION</option>
                                      <option>III REGION</option>
                                      <option>IV REGION</option>
                                            </select>
                                    <select name="select2">
                                      <option selected>Ciudad</option>
                                      <option>ARICA</option>
                                      <option>ANTOFAGASTA</option>
                                      <option>TALCA</option>
                                      <option>LOS ANGELES</option>
                                      <option>TEMUCO</option>
                                    </select>
                                    <select name="select3">
                                      <option selected>Establecimiento</option>
                                      <option>ARICA</option>
                                      <option>ANTOFAGASTA</option>
                                      <option>TALCA</option>
                                      <option>LOS ANGELES</option>
                                      <option>TEMUCO</option>
                                    </select>                                
                                    <br>
                                    <strong>                                        </strong></p></td>
                                <td width="25%">
                                  <strong>
                                  <input name="textfield72" type="text" size="12">
                                  </strong> </td>
                              </tr>
                            </table>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="28%"><br>                                  
                                  <input name="r1" type="radio" value="radiobutton">
      CIENT&Iacute;FICO HUMANISTA </td>
                                <td width="20%"><br>                                  
                                  <input name="r1" type="radio" value="radiobutton">
      COMERCIAL<br>
                                </td>
                                <td width="17%"><br>                                  
                                  <input name="r1" type="radio" value="radiobutton">
      AGR&Iacute;COLA</td>
                                <td width="35%"><br>
                                  <input name="r1" type="radio" value="radiobutton">                                
                                OTRO 
                                <input type="text" name="textfield"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="50%">REGI&Oacute;N DE PROCEDENCIA<br>
                                    <select name="select8">
                                      <option selected>Regi&oacute;n</option>
                                      <option>I REGION</option>
                                      <option>II REGION</option>
                                      <option>III REGION</option>
                                      <option>IV REGION</option>
                                    </select>
                                </td>
                                <td width="50%">CIUDAD O LOCALIDAD DE PROCEDENCIA<br>
                                    <select name="select8">
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
							<br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><strong>REGIMEN DE ESTUDIOS </strong></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%" height="14"  border="0" cellpadding="0" cellspacing="0">
                              <tr>
                                <td width="26%" height="14"><input name="r2" type="radio" value="radiobutton">
Diurno</td>
                                <td width="18%"><input name="r2" type="radio" value="radiobutton">
Vespertino</td>
                                <td width="56%"><input name="r2" type="radio" value="radiobutton">
Recuperaci&oacute;n</td>
                              </tr>
                            </table>
                     
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td>&nbsp;</td>
                                <td height="17">&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td>PRUEBA RENDIDA</td>
                                <td height="12">A&Ntilde;O</td>
                                <td width="56%">PROMEDIO N.E.M.</td>
                              </tr>
                              <tr>
                                <td width="26%"><select name="select4">
                                  <option selected>Seleccione</option>
                                  <option>P.A.A</option>
                                  <option>P.S.U</option>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                </select></td>
                                <td width="18%" height="17">                                  <p>
<input name="textfield7235" type="text" size="12">

                                </td>
                                <td>
      <input name="textfield72325" type="text" size="12">                                </td>
                              </tr>
                            </table>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="16">&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td width="44%" height="12">PUNTAJE OBTENIDO EN LENGUAJE </td>
                                <td>PUNTAJE OBTENIDO EN MATEMATICAS</td>
                              </tr>
                              <tr>
                                <td height="17">                                  <input name="textfield7233222" type="text" size="12">
                                </td>
                                <td width="56%">
                                  <input name="textfield723323" type="text" size="12">
                                </td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><strong>ESTUDIOS SUPERIORES ANTERIORES (TIPO DE INSTITUCI&Oacute;N) </strong></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><input name="r3" type="radio" value="radiobutton">                                
                                CENTRO DE FORMACI&Oacute;N T&Eacute;CNICA </td>
                                <td><input name="r3" type="radio" value="radiobutton">                                  
                                UNIVERSIDAD TRADICIONAL </td>
                              </tr>
                              <tr>
                                <td><p>
<input name="r3" type="radio" value="radiobutton">
INSTITUTO PROFESIONAL                               </p>                                </td>
                                <td><input name="r3" type="radio" value="radiobutton">                                  
                                UNIVERSIDAD PRIVADA </td>
                              </tr>
                              <tr>
                                <td><input name="r3" type="radio" value="radiobutton">                                  
                                  OTRO 
                                  <input type="text" name="textfield2"></td>
                                <td>&nbsp;</td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td>NOMBRE DE LA CASA DE ESTUDIOS<br>
                                <input name="textfield3" type="text" size="40"> </td>
                                <td>&Uacute;LTIMA CARRERA ESTUDIADA<br>
                                <input name="textfield32" type="text" size="40"> </td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="28%">DESDE<br>
                                  <strong>
                                  <input name="textfield72322" type="text" size="12">
                                </strong></td>
                                <td width="30%">HASTA<br>
                                  <strong>
                                  <input name="textfield72323" type="text" size="12">
                                </strong></td>
                                <td width="42%">N&Uacute;MERO DE SEMESTRES APROBADOS <br>
                                  <strong>
                                  <input name="textfield72324" type="text" size="12">
                                </strong></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td>SE TITUL&Oacute;<br>
                                  <input name="radiobutton" type="radio" value="radiobutton">
S&iacute;
<input name="radiobutton" type="radio" value="radiobutton">
No</td>
                                <td>SI SE TITUL&Oacute;: T&Iacute;TULO OBTENIDO<br>
                                <input name="textfield33" type="text" size="60"> </td>
                              </tr>
                            </table>
                            <br>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="50%"><strong>SOLICITA RECONOCIMIENTO DE ESTUDIOS </strong></td>
                                <td width="50%"><input name="r4" type="radio" value="radiobutton">
                                S&iacute;  <input name="r4" type="radio" value="radiobutton">
                                No</td>
                              </tr>
                            </table>
                            <br>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><strong>MARQUE LAS ACTIVIDADES EN LAS QUE LE AGRADAR&Iacute;A PARTICIPAR </strong></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><input type="checkbox" name="checkbox4" value="checkbox">
                                  FOLKLORE</td>
                                <td><input type="checkbox" name="checkbox42" value="checkbox">
                                  CORO</td>
                                <td><input type="checkbox" name="checkbox43" value="checkbox"> 
                                  TEATRO</td>
                                <td><input type="checkbox" name="checkbox44" value="checkbox"> 
                                  F&Uacute;TBOL
</td>
                                <td><input type="checkbox" name="checkbox45" value="checkbox"> 
                                  TENIS
</td>
                              </tr>
                              <tr>
                                <td><input type="checkbox" name="checkbox46" value="checkbox"> 
                                  B&Aacute;SQUETBOL
</td>
                                <td><input type="checkbox" name="checkbox47" value="checkbox"> 
                                  VOLEIBOL
</td>
                                <td><input type="checkbox" name="checkbox48" value="checkbox"> 
                                  RUGBY
</td>
                                <td><input type="checkbox" name="checkbox49" value="checkbox"> 
                                  AER&Oacute;BICA
</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td><input type="checkbox" name="checkbox410" value="checkbox"> 
                                  TENIS DE MESA</td>
                                <td><input type="checkbox" name="checkbox411" value="checkbox"> 
                                  KARATE</td>
                                <td><input type="checkbox" name="checkbox412" value="checkbox"> 
                                YUDO</td>
                                <td><input type="checkbox" name="checkbox413" value="checkbox"> 
                                  MONTA&Ntilde;ISMO</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td colspan="5"><input type="checkbox" name="checkbox414" value="checkbox"> 
                                  OTROS
                                    <input name="textfield4" type="text" size="40"></td>
                              </tr>
                            </table>
                            <br>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><strong>ANTECEDENTES DE SALUD</strong></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="27%">                                NOMBRE DE LA ISAPRE<br>                                
                                </td>
                                <td width="73%"><select name="select5">
                                  <option selected>Isapre</option>
                                  <option>Banmedica</option>
                                  <option>Consalud</option>
                                  <option>Vida Tres</option>
                                  <option>Colmena</option>
                                  <option>Fonasa</option>
								   <option>Ninguna</option>
                                </select></td>
                              </tr>
                              <tr>
                                <td>NOMBRE CC.FF.AA. </td>
                                <td><select name="select6">
                                  <option selected>CC.FF.AA</option>
                                  <option>FF.AA</option>
                                  <option>No pertenezco</option>
                                </select></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="73%"><input type="checkbox" name="checkbox5" value="checkbox">
                                &iquest;Padece de alguna enfermedad que requiere ciudado personal? (Indicar)</td>
                                <td width="27%"><input type="text" name="textfield9"></td>
                              </tr>
                              <tr>
                                <td><input type="checkbox" name="checkbox6" value="checkbox">
                                &iquest;Es al&eacute;rgico a alg&uacute;n medicamento? (Indicar) </td>
                                <td><input type="text" name="textfield92"></td>
                              </tr>
                            </table>
                            <br>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><strong>ANTECEDENTES LABORALES DEL ALUMNO (S&Oacute;LO SI TRABAJA) </strong></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="20%">TRABAJA<br>
                                <input name="r7" type="radio" value="radiobutton">
                                S&iacute;
                                 <input name="r7" type="radio" value="radiobutton">
                                No</td>
                                <td width="38%">EMPRESA<br>
                                <input name="textfield42" type="text" size="40"></td>
                                <td width="42%">CARGO O ACTIVIDAD <br>
                                <input name="textfield422" type="text" size="40"></td>
                              </tr>
                            </table>
                            <br>
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="50%">REGI&Oacute;N<br>
                                    <select name="select9">
                                      <option selected>Regi&oacute;n</option>
                                      <option>I REGION</option>
                                      <option>II REGION</option>
                                      <option>III REGION</option>
                                      <option>IV REGION</option>
                                    </select>
                                </td>
                                <td width="50%">CIUDAD O LOCALIDAD<br>
                                    <select name="select9">
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
                            <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="37%">ANTIGUEDAD LABORAL<br>
                                  <select name="select7">
                                      <option selected>Seleccione</option>
                                      <option>menos de 1 año</option>
                                      <option>1 año</option>
                                      <option>2 años</option>
                                      <option>3 años</option>
                                      <option>4 años</option>
									  <option>mas de 4 años</option>
                                    </select>
                                </td>
                                <td width="12%"><br>
                                </td>
                                <td width="39%"> <br>
                                </td>
                                <td width="12%"><br>
                                </td>
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
                      <td><div align="center"><%pagina.DibujarBoton "Anterior" , "NAVEGAR", "maq_postulacion_2.asp"%></div></td>
                      <td><div align="center">
                        <%pagina.DibujarBoton "Siguiente" , "NAVEGAR", "maq_postulacion_4.asp"%>
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
