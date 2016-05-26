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
set botonera = new CFormulario
botonera.Carga_Parametros "Forma_Pago.xml", "botonera"
%>


<html>
<head>
<title>Imprimir Documentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Anterior4()
{
  location.replace("Forma_Pago3.asp");
}
function Abrir()
{
 resultado = window.open("ver_cheque.asp","","toolbar=no, resizable=no,left=200,top=150,width=415,height=175");
  
}
</script>

<script language="JavaScript">
function abrir()
 { 
  location.reload("Envios_Banco_Agregar1.asp") 
 }
</script>

<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>


</head>
<body onBlur="revisaVentana()" bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">&nbsp;</td>
  </tr>
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
                    <td width="187" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                          de Alumno</font></div>
                    </td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="462" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
            <table width="100%" height="31" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="9"  align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><form name="buscador" method="post" action="">
                    <table width="94%"  border="0" align="center">
                      <tr>
                        <td width="17%"><strong>Rut Postulante </strong></td>
                        <td width="3%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong>:</strong> </font></td>
                        <td width="59%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                          <input name="rut" type="text" value="11111111" size="10" maxlength="8">
                    -
                    <input type="text" name="dv" size="1" value = "1" maxlength="1">
                    <a href="javascript:buscar_persona();"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a> </font></td>
                        <td width="21%"><div align="center">
                            <%pagina.dibujarboton "Buscar","BUSCAR-buscador",""%>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </form>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif"></td>
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
          <td height="0"><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <td width="6" background="../imagenes/fondo1.gif"><img src="../imagenes/izq2.gif" width="6" height="17"></td>
                      <td width="69" valign="middle" background="../imagenes/fondo2.gif">
                      <div align="center"><font color="#000000" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos</font></div></td>
                      <td width="6" bgcolor="#D8D8DE"><img src="../imagenes/der2.gif" width="6" height="17"></td>
                      <td width="4" background="../imagenes/izq2.gif" bgcolor="#D8D8DE"></td>
                      <td width="107" background="../imagenes/fondo2.gif" bgcolor="#D8D8DE"><div align="center"><font color="#000000">Forma
                      de Pago</font></div></td>
                      <td width="5" background="../imagenes/der2.gif" bgcolor="#D8D8DE">&nbsp;</td>
                      <td width="4" background="../imagenes/izq2.gif" bgcolor="#D8D8DE">&nbsp;</td>
                      <td width="116" background="../imagenes/fondo2.gif" bgcolor="#D8D8DE"><div align="center"><font color="#000000">Generar
                      Contrato</font></div></td>
                      <td width="6" background="../imagenes/der2.gif" bgcolor="#D8D8DE">&nbsp;</td>
                      <td width="4" background="../imagenes/izq_1.gif" bgcolor="#D8D8DE">&nbsp;</td>
                      <td width="85" background="../imagenes/fondo1.gif" bgcolor="#D8D8DE"><div align="center"><font color="#FFFFFF">Imprimir</font></div></td>
                      <td width="6" background="../imagenes/derech1.gif" bgcolor="#D8D8DE">&nbsp;</td>
                      <td width="240" bgcolor="#D8D8DE">&nbsp;</td>
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
                  <td width="9" height="100" align="left" background="../imagenes/izq.gif"></td>
                  <td bgcolor="#D8D8DE"><BR><table width="632" border="0" align="center">
                    <tr>
                      <td width="16%"><strong>Rut Postulante</strong></td>
                      <td width="3%"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> :</font></strong></td>
                      <td width="20%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">11.111.111-1</font></td>
                      <td width="9%"><strong>Nombre</strong></td>
                      <td width="3%"><strong>:</strong></td>
                      <td width="47%">Juan Gallardo</td>
                    </tr>
                    <tr>
                      <td><strong>Carrera</strong></td>
                      <td><strong>:</strong></td>
                      <td>Derecho</td>
                      <td>&nbsp;</td>
                      <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td><strong>Fecha Actual</strong></td>
                      <td><strong>:</strong></td>
                      <td>29/01/2003</td>
                      <td>&nbsp;</td>
                      <td colspan="2">&nbsp;</td>
                    </tr>
                  </table>  <BR>                  
                    <table width="632" border="0" align="center">
                      <tr>
                        <td colspan="3"><%pagina.DibujarSubtitulo("Imprimir Documentos")%>
                        </td>
                      </tr>
                      <tr>
                        <td width="94"><font size="2">Impresora</font></td>
                        <td width="19">:</td>
                        <td width="505"><select name="select">
                          <option>\\servidor\Impresora_1</option>
                          <option>\\servidor\Impresora_2</option>
                          <option>Impresora Local</option>
                        </select></td>
                      </tr>
                    </table>
                    <BR>
                    <table width="632" border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="33"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b>
                          <input name="radiobutton" type="radio" value="radiobutton" checked>
                        </b></font></td>
                        <td width="193"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Contrato</font></b></font></td>
                        <td width="115">&nbsp;</td>
                        <td width="31"><input type="radio" name="radiobutton" value="radiobutton"></td>
                        <td colspan="2"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Pagar&eacute;</font></b></font></td>
                      </tr>
                      <tr>
                        <td height="0" colspan="2"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                        <td height="0">&nbsp;</td>
                        <td height="0" colspan="2"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                        <td width="50">&nbsp;</td>
                      </tr>
                    </table>                    
                    <table width="632" border="0" align="center">
                      <tr>
                        <td width="335"><table width="278" border="0" align="left">
                          <tr>
                            <td width="83"><font size="2">Contrato</font></td>
                            <td width="17"><font size="2">:</font></td>
                            <td width="164"><font size="2">8989</font></td>
                          </tr>
                          <tr>
                            <td><font size="2">Fecha</font></td>
                            <td><font size="2">:</font></td>
                            <td><font size="2">29/01/2003</font></td>
                          </tr>
                          <tr>
                            <td><font size="2">Estado</font></td>
                            <td><font size="2">:</font></td>
                            <td><font size="2">GENERADO</font></td>
                          </tr>
                        </table></td>
                        <td width="287"><table width="272" border="0" align="center">
                          <tr>
                            <td width="46%"><font size="2">Pagar&eacute;</font></td>
                            <td width="6%"><font size="2">:</font></td>
                            <td width="29%"><font size="2">5555</font></td>
                            <td width="19%">&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Monto Anterior</font></td>
                            <td><font size="2">:</font></td>
                            <td><div align="right">1.100.000</div></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Monto del A&ntilde;o</font></td>
                            <td><font size="2">:</font></td>
                            <td><div align="right">800.000</div></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Total</font></td>
                            <td><font size="2">:</font></td>
                            <td><div align="right">1.800.000</div></td>
                            <td>&nbsp;</td>
                          </tr>
                        </table></td>
                      </tr>
                    </table>
                    <BR>
                    <table width="632" border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="229"><font color="#666677" size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Cheque</b></font></td>
                        <td width="403">&nbsp;</td>
                      </tr>
                      <tr>
                        <td height="0"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                        <td width="403" height="0">&nbsp;</td>
                      </tr>
                    </table>                    
                    <table width="632" border="0" align="center">
                      <tr>
                        <td><table width="632" border="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
                          <tr bordercolor="#FFFFFF" bgcolor="#6581AB">
                            <td width="36"><div align="center"><font color="#FFFFFF"></font></div></td>
                            <td width="58"><div align="center"><font color="#FFFFFF">Doc.</font></div>
                            </td>
                            <td width="88"><div align="center"><font color="#FFFFFF">Desc.</font></div>
                            </td>
                            <td width="68"><div align="center"><font color="#FFFFFF">Banco</font></div>
                            </td>
                            <td width="88"><div align="center"><font color="#FFFFFF">Plaza</font></div>
                            </td>
                            <td width="87"><div align="center"><font color="#FFFFFF">F.
                                  Emisi&oacute;n</font></div>
                            </td>
                            <td width="87"><div align="center"><font color="#FFFFFF">F.
                                  Vencimiento</font></div>
                            </td>
                            <td width="86"><div align="center"><font color="#FFFFFF">Monto</font></div>
                            </td>
                          </tr>
                          <tr bgcolor="#B9C6D9">
                            <td><div align="center">
                                <input name="radiobutton" type="radio" value="radiobutton">
                              </div>
                            </td>
                            <td class='click' align='center' width='58' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' onClick='Abrir();' >0001</div>
                            </td>
                            <td class='click' align='center' width='88' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' onClick='Abrir();'>CHEQUE</td>
                            <td class='click' align='center' width='68' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' onClick='Abrir();'>B.C.I.</td>
                            <td class='click' align='center' width='88' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' onClick='Abrir();'>De la Plaza</td>
                            <td class='click' align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' onClick='Abrir();'>29/01/2003</td>
                            <td class='click' align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' onClick='Abrir();'>28/02/2003</td>
                            <td class='click' align='center' width='86' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' onClick='Abrir();'>100.000</td>
                          </tr>
                          <tr bgcolor="#B9C6D9">
                            <td><div align="center">
                                <input type="radio" name="radiobutton" value="radiobutton">
                              </div>
                            </td>
                            <td align='center' width='58' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>0002</div>
                            </td>
                            <td c align='center' width='88' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>CHEQUE</div>
                            </td>
                            <td c align='center' width='68' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>B.C.I.</div>
                            </td>
                           <td  align='center' width='88' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>De la Plaza</div>
                            </td>
                            <td  align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>29/01/2003</div>
                            </td>
                            <td  width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center">30/03/2003
                                </div>
                            </div></td>
                            <td  align='center' width='86' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>100.000</div>
                            </td>
                          </tr>
                          <tr bgcolor="#B9C6D9">
                            <td><div align="center">
                                <input type="radio" name="radiobutton" value="radiobutton">
                              </div>
                            </td>
                            <td align='center' width='58' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>0003</div>
                            </td>
                            <td align='center' width='88' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>CHEQUE</div>
                            </td>
                            <td  align='center' width='68' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>B.C.I.</div>
                            </td>
                            <td  align='center' width='88' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>De la Plaza</div>
                            </td>
                            <td align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>29/01/2003</div>
                            </td>
                            <td align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>30/04/2003</div>
                            </td>
                           <td align='center' width='86' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>100.000</div>
                            </td>
                          </tr>
                          <tr bgcolor="#B9C6D9">
                            <td><div align="center">
                                <input type="radio" name="radiobutton" value="radiobutton">
                              </div>
                            </td>
                            <td  align='center' width='58' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>0004</div>
                            </td>
                            <td align='center' width='88' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>CHEQUE</div>
                            </td>
                            <td align='center' width='68' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>B.C.I.</div>
                            </td>
                            <td align='center' width='88' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>De la Plaza</div>
                            </td>
                            <td  align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>29/01/2003</div>
                            </td>
                            <td  width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center">30/05/2003
                                </div>
                            </div></td>
                            <td  align='center' width='86' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>100.000</div>
                            </td>
                          </tr>
                          <tr bgcolor="#B9C6D9">
                            <td><div align="center">
                                <input type="radio" name="radiobutton" value="radiobutton">
                              </div>
                            </td>
                            <td  align='center' width='58' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>0005</div>
                            </td>
                            <td  align='center' width='88' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>CHEQUE</div>
                            </td>
                            <td   width='68' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center">B.C.I.
                                </div>
                            </div></td>
                           <td  align='center' width='88' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>De la Plaza</div>
                            </td>
                            <td  align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>29/01/2003</div>
                            </td>
                            <td  align='center' width='87' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>30/06/2003</div>
                            </td>
                            <td align='center' width='86' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>100.000</div>
                            </td>
                          </tr>
                        </table></td>
                      </tr>
                    </table>  <BR>                  
                    <table width="632" border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="33"><font color="#666677" size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="radiobutton" value="radiobutton">
                        </font></td>
                        <td width="196"><font color="#666677" size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Letra</b></font></td>
                        <td width="403">&nbsp;</td>
                      </tr>
                      <tr>
                        <td height="0" colspan="2"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                        <td width="403" height="0">&nbsp;</td>
                      </tr>
                    </table>                    
                    <table width="635" border="0" align="center" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
                      <tr bordercolor="#FFFFFF" bgcolor="#6581AB">
                        <td width="44">&nbsp;</td>
                        <td><div align="center"><font color="#FFFFFF">Documento</font></div></td>
                        <td><div align="center"><font color="#FFFFFF">Descripci&oacute;n</font></div></td>
                        <td><div align="center"><font color="#FFFFFF">Fecha Emisi&oacute;n</font></div></td>
                        <td><div align="center"><font color="#FFFFFF">Fecha Vencimiento</font></div></td>
                        <td><div align="center"><font color="#FFFFFF">Monto</font></div></td>
                      </tr>
                      <tr bgcolor="#B9C6D9">
                        <td><div align="center"><input type="checkbox" name="checkbox3" value="checkbox"></div></td>
                        <td  align='center' width='105' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>0501</td>
                        <td  align='center' width='113' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>LETRA</td>
                        <td  align='center' width='110' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>29/01/2003</td>
                        <td  align='center' width='130' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>30/07/2003</td>
                        <td  align='center' width='107' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>100.000</td>
                      </tr>
                      <tr bgcolor="#B9C6D9">
                        <td><div align="center"><input type="checkbox" name="checkbox2" value="checkbox"></div></td>
                        <td  align='center' width='105' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>0502</td>
                        <td  align='center' width='113' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>LETRA</td>
                        <td  align='center' width='110' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>29/01/2003</td>
                        <td  align='center' width='130' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>30/08/2003</td>
                        <td  align='center' width='107' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>100.000</td>
                      </tr>
                      <tr bgcolor="#B9C6D9">
                        <td><div align="center"><input type="checkbox" name="checkbox" value="checkbox"></div></td>
                        <td  align='center' width='105' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>0503</td>
                        <td  align='center' width='113' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>LETRA</td>
                        <td  align='center' width='110' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>29/01/2003</td>
                        <td  align='center' width='130' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>30/09/2003</td>
                        <td  align='center' width='107' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>100.000</td>
                      </tr>
                    </table>                    
                    <BR>
                    </td><td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="214" bgcolor="#D8D8DE"> <div align="right">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="2%">&nbsp;</td>
                        <td width="49%"><%botonera.dibujaboton "anterior4" %>
                        </td>
                        <td width="49%"><%botonera.dibujaboton "imprimir"%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="148" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
    
    <br>
    </td>
  </tr>  
</table>
</body>
</html>
