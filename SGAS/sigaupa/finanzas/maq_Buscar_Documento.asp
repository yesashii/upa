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
'set botonera = new CFormulario
'botonera.Carga_Parametros "Envios_Notaria.xml", "botonera"
%>


<html>
<head>
<title>Buscar Documento</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function abrir()
 { 
  //location.reload("Envios_Banco_Agregar1.asp") 
 }
</script>

<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="183" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Documentos</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="458" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%" height=""><table width="514" border="0">
                        <tr>
                          <td width="105">
                            <div align="left">N&ordm; Documento</div>
                          </td>
                          <td width="17">:</td>
                          <td width="150"><input name="textfield2" type="text" size="20" maxlength="15">
                          </td>
                          <td width="55">&nbsp;</td>
                          <td width="13">&nbsp;</td>
                          <td width="148">&nbsp;</td>
                        </tr>
                        <tr>
                          <td>Tipo</td>
                          <td>:</td>
                          <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                              <select name="select3">
                                <option>LETRA</option>
                                <option>CHEQUE</option>
                              </select>
                            </font></div>
                          </td>
                          <td>Estado</td>
                          <td>:</td>
                          <td><select name="select2">
                            <option></option>
                            <option>En Cartera (Legalizada)</option>
                            <option>En Cartera</option>
                            <option>Ingresada (Banco)</option>
                            <option>Prorrogada</option>
                            <option>Pagada</option>
                            <option>Protestada</option>
                            <option>En Notar&iacute;a</option>
                            <option>C. Prejudicial</option>
                            <option>C. Judicial</option>
                          </select></td>
                        </tr>
                        <tr>
                          <td>Rut Alumno</td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                            <input name="rut" type="text" size="10" maxlength="8">
      -
      <input type="text" name="dv" size="2" value = "" maxlength="1">
                          </font><a href="javascript:buscar_persona();"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut
                              Apoderado</font></td>
                          <td>:</td>
                          <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                              <input name="otro" type="text" size="10" maxlength="8">
        -
        <input type="text" name="dv332" size="2" value = "" maxlength="1">
                            </font><a href="javascript:buscar_persona();"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div>
                          </td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                      </table></td>
                      <td width="19%"><div align="center"><%pagina.DibujarBoton "Buscar", "BUSCAR-buscador", "" %></div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Documentos
                          Encontrados</font></div>
                    </td>
                    <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> &nbsp;
                    <form name="edicion">
                      <table width="665" border="0" cellpadding="2" cellspacing="2" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
                        <tr bordercolor="#FFFFFF" bgcolor="#6581AB">
                          <td width="68"><div align="center"><font color="#FFFFFF">N&ordm;
                                Doc. Original</font></div>
                          </td>
                          <td width="78"><div align="center"><font color="#FFFFFF">Tipo
                                Doc. Original</font></div>
                          </td>
                          <td width="85"><div align="center"><font color="#FFFFFF">N&ordm;
                                Documento</font></div>
                          </td>
                          <td width="80"><div align="center"><font color="#FFFFFF">Tipo</font></div></td>
                          <td width="69"><div align="center"><font color="#FFFFFF">Monto
                                ($)</font></div>
                          </td>
                          <td width="87"><div align="center"><font color="#FFFFFF">Fecha</font></div>
                          </td>
                          <td width="92"><div align="center"><font color="#FFFFFF">Estado</font></div>
                          </td>
                          <td width="72"><div align="center"><font color="#FFFFFF">N&ordm;
                                Repactaci&oacute;n</font></div>
                          </td>
                        </tr>
                        <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
                          <td width='68' align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>100</td>
                          <td  align='center' width='78'  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Contrato</td>
                          <td  align='center' width='85' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>2000</td>
                          <td  align='center' width='80' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>LETRA</td>
                          <td  align='center' width='69' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right">10.000</div></td>
                          <td  align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>16/10/2003</td>
                          <td  align='center' width='92' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Repactado</td>
                          <td  align='center' width='72' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>1</td>
                        </tr>
                        <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
                          <td align='center'  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>100</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Contrato</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>2001</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>LETRA</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right">10.000</div></td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>16/10/2003</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Pagado</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>1</td>
                        </tr>
                        <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
                          <td align='center'  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>100</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Contrato</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>2002</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>LETRA</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right">15.000</div></td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>16/10/2003</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Pagado</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>&nbsp;</td>
                        </tr>
                        <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
                          <td width='68' align='center'  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>1</td>
                          <td  align='center' width='78' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Repactaci&oacute;n</td>
                          <td  align='center' width='85' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>300</td>
                          <td  align='center' width='80' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>LETRA</td>
                          <td  align='center' width='69' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right">5.000</div></td>
                          <td  align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>16/11/2003</td>
                          <td  align='center' width='92' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Repactado</td>
                          <td  align='center' width='72' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>2</td>
                        </tr>
                        <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
                          <td width='68' align='center'  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>1</td>
                          <td  align='center' width='78' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Repactaci&oacute;n</td>
                          <td  align='center' width='85' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>301</td>
                          <td  align='center' width='80' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>LETRA</td>
                          <td  align='center' width='69' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right">15.000</div></td>
                          <td  align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>16/11/2003</td>
                          <td  align='center' width='92' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Banco</td>
                          <td  align='center' width='72' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>&nbsp;</td>
                        </tr>
                        <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
                          <td width='68' align='center'  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>2</td>
                          <td  align='center' width='78' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Repactaci&oacute;n</td>
                          <td  align='center' width='85' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>400</td>
                          <td  align='center' width='80' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>LETRA</td>
                          <td  align='center' width='69' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right">7.000</div></td>
                          <td  align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>16/11/2003</td>
                          <td  align='center' width='92' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>Banco</td>
                          <td  align='center' width='72' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>&nbsp;</td>
                        </tr>
                      </table>
                    </form>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="135" bgcolor="#D8D8DE"><table width="84%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="left"></div>                        
                        <div align="left">
                          <%pagina.DibujarBoton "Salir", "CERRAR", ""  'pagina.DibujarBoton "Agregar", "AGREGAR-150-200-415-178", "Envios_Banco_Nuevo.asp" %>
                          </div></td>
                    </tr>
                  </table>
                </td>
                <td width="227" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
        </td>
      </tr>
    </table>
	<p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>