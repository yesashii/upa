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
<title>Forma de Pago</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Anterior2()
{
  location.replace("Forma_Pago.asp");
}
function Siguiente2()
{
  location.replace("Forma_Pago3.asp");
}
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
                      <td width="4" background="../imagenes/izq_1.gif" bgcolor="#D8D8DE"></td>
                      <td width="107" background="../imagenes/fondo1.gif" bgcolor="#D8D8DE"><div align="center"><font color="#FFFFFF">Forma
                      de Pago</font></div></td>
                      <td width="5" background="../imagenes/derech1.gif" bgcolor="#D8D8DE">&nbsp;</td>
                      <td width="4" background="../imagenes/izq2.gif" bgcolor="#D8D8DE">&nbsp;</td>
                      <td width="116" background="../imagenes/fondo2.gif" bgcolor="#D8D8DE"><div align="center">Generar
                      Contrato</div></td>
                      <td width="6" background="../imagenes/der2.gif" bgcolor="#D8D8DE">&nbsp;</td>
                      <td width="4" background="../imagenes/izq2.gif" bgcolor="#D8D8DE">&nbsp;</td>
                      <td width="85" background="../imagenes/fondo2.gif" bgcolor="#D8D8DE"><div align="center">Imprimir</div></td>
                      <td width="6" background="../imagenes/der2.gif" bgcolor="#D8D8DE">&nbsp;</td>
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
                  <td bgcolor="#D8D8DE">
				  <BR>			 
                    <table width="632" border="0" align="center">
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
                    </table>
                    <BR>
                    <table width="665" border="0" align="center" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
                      <tr bordercolor="#FFFFFF" bgcolor="#6581AB">
                        <td width="150"><div align="center"><font color="#FFFFFF"><strong>Valor
                                Matricula</strong></font></div>
                        </td>
                        <td width="150"><div align="center"><font color="#FFFFFF"><strong>Arancel</strong></font></div>
                        </td>
                        <td width="150"><div align="center"><font color="#FFFFFF"><strong>Subtotal</strong></font></div>
                        </td>
                        <td width="150"><div align="center"><font color="#FFFFFF"><strong>Total
                                Descuentos</strong></font></div>
                        </td>
                        <td width="150"><div align="center"><font color="#FFFFFF"><strong>Total</strong></font></div>
                        </td>
                      </tr>
                      <tr bgcolor="#B9C6D9">
                        <td><div align="center">100.000</div>
                        </td>
                        <td><div align="center">1.000.000</div>
                        </td>
                        <td><div align="center">1.100.000</div>
                        </td>
                        <td><div align="center">210.000</div>
                        </td>
                        <td><div align="center">890.000</div>
                        </td>
                      </tr>
                    </table><BR>
                      <table width="665" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="224"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Descuentos</font></b></font></td>
                          <td width="398">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="0" colspan="2"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                        </tr>
                    </table> <BR>                     
                      <table width="665" border="0" align="center" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
                        <tr bordercolor="#FFFFFF" bgcolor="#6581AB">
                          <td width="28"><div align="center"><font color="#FFFFFF">
                              <input type="checkbox" name="checkbox5" value="checkbox">
                            </font></div>
                          </td>
                          <td width="137" bgcolor="#6581AB"><div align="center"><font color="#FFFFFF"><strong>Descuento</strong></font></div>
                          </td>
                          <td width="80"><div align="center"><font color="#FFFFFF"><strong>%
                                  Desc Matricula</strong></font></div>
                          </td>
                          <td width="86"><div align="center"><font color="#FFFFFF"><strong>$
                                  Desc. Matricula</strong></font></div>
                          </td>
                          <td width="69"><div align="center"><font color="#FFFFFF"><strong>%
                                  Desc Arancel</strong></font></div>
                          </td>
                          <td width="93"><div align="center"><font color="#FFFFFF"><strong>$
                                  Desc. Arancel</strong></font></div>
                          </td>
                          <td width="109"><div align="center"><font color="#FFFFFF"><strong>Subtotal</strong></font></div>
                          </td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="28"><div align="center">
                              <input type="checkbox" name="checkbox32" value="checkbox">
                            </div>
                          </td>
                          <td width="137"><div align="center">Beca (Dep. Destacado)</div>
                          </td>
                          <td width="80"><div align="center">10</div>
                          </td>
                          <td width="86"><div align="center">10.000</div>
                          </td>
                          <td width="69"><div align="center">0</div>
                          </td>
                          <td width="93"><div align="center">0</div>
                          </td>
                          <td width="109"><div align="center">10.000</div>
                          </td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="28"><div align="center">
                              <input type="checkbox" name="checkbox42" value="checkbox">
                            </div>
                          </td>
                          <td width="137" bgcolor="#B9C6D9"><div align="center">Hijo
                              Funcionario</div>
                          </td>
                          <td width="80"><div align="center">0</div>
                          </td>
                          <td width="86"><div align="center">0</div>
                          </td>
                          <td width="69"><div align="center">20</div>
                          </td>
                          <td width="93"><div align="center">200.000</div>
                          </td>
                          <td width="109"><div align="center">200.000</div>
                          </td>
                        </tr>
                      </table>                      
                      <table width="665" border="0">
                        <tr>
                          <td width="81"><%botonera.dibujaboton "agregar"%></td>
                          <td width="241"><%botonera.dibujaboton "eliminar" %></td>
                          <td width="161">&nbsp;</td>
                          <td width="164">&nbsp;</td>
                        </tr>
                      </table><BR>                      
                      <table width="665" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="224"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Forma
                          de Pago</font></b></font></td>
                          <td width="398">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="0" colspan="2"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                        </tr>
                      </table> <BR>                     
                      <table width="665" border="0">
                        <tr>
                          <td>Matr&iacute;cula</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td width="87">Arancel</td>
                          <td width="88">&nbsp;</td>
                          <td width="80">&nbsp;</td>
                          <td width="61">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="87"><input name="checkbox2222" type="checkbox" value="checkbox">
                          CHEQUE</td>
                          <td width="65"><input name="textfield43" type="text" size="5" maxlength="2"></td>
                          <td width="88"><input type="checkbox" name="checkbox242" value="checkbox">
LETRA</td>
                          <td width="75"><input name="textfield32" type="text" size="5" maxlength="2"></td>
                          <td><input name="checkbox2222" type="checkbox" value="checkbox" checked>
  CHEQUE</td>
                          <td><input name="textfield43" type="text" value="5" size="5" maxlength="2">
                          </td>
                          <td><input name="checkbox242" type="checkbox" value="checkbox" checked>
  LETRA</td>
                          <td><input name="textfield32" type="text" value="3" size="5" maxlength="2">
                          </td>
                        </tr>
                        <tr>
                          <td><input name="checkbox2322" type="checkbox" value="checkbox" checked>
EFECTIVO</td>
                          <td><input name="textfield22" type="text" value="90.000" size="12" maxlength="10"></td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><input name="checkbox2322" type="checkbox" value="checkbox">
  EFECTIVO</td>
                          <td><input name="textfield22" type="text" size="12" maxlength="10">
                          </td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td colspan="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td colspan="2">Fecha Inicio de Pago</td>
                          <td><input name="textfield222" type="text" value="30/01/2003" size="12" maxlength="10">
                          </td>
                          <td>&nbsp;</td>
                          <td>Frecuencia</td>
                          <td><input name="textfield223" type="text" size="12" maxlength="10">
                          </td>
                          <td colspan="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td colspan="2">N&ordm; Cheque Inicial</td>
                          <td><input name="textfield2222" type="text" value="0001" size="12" maxlength="10"></td>
                          <td>&nbsp;</td>
                          <td>Banco</td>
                          <td><select name="select9">
                            <option> </option>
                            <option selected>B.C.I.</option>
                            <option>CHILE</option>
                            <option>ESTADO</option>
                          </select></td>
                          <td colspan="2">                          <div align="center">
                            <% botonera.dibujaboton "generar"%>
                          </div></td>
                        </tr>
                      </table>                      
                      <BR>
                      <BR>
                      <table width="665" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="224"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Detalle
                                  de Pagos</font></b></font></td>
                          <td width="398">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="0" colspan="2"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                        </tr>
                    </table><BR>
                      <table width="665" border="0" align="center" bgcolor="#FFFFFF">
                        <tr bgcolor="#6581AB">
                          <td width="21" bordercolor="#FFFFFF"><div align="center"><font color="#FFFFFF">N&ordm;</font></div>
                          </td>
                          <td width="63" bordercolor="#FFFFFF" bgcolor="#6581AB"><div align="center"><font color="#FFFFFF">Documento</font></div>
                          </td>
                          <td width="69" bordercolor="#FFFFFF"><div align="center"><font color="#FFFFFF">Descripci&oacute;n</font></div>
                          </td>
                          <td width="81" bordercolor="#FFFFFF"><div align="center"><font color="#FFFFFF">Banco</font></div>
                          </td>
                          <td width="125" bordercolor="#FFFFFF"><div align="center"><font color="#FFFFFF">Plaza</font></div>
                          </td>
                          <td width="77" bordercolor="#FFFFFF" bgcolor="#6581AB"><div align="center"><font color="#FFFFFF">Emisi&oacute;n</font></div>
                          </td>
                          <td width="70" bordercolor="#FFFFFF"><div align="center"><font color="#FFFFFF">Vencimiento</font></div>
                          </td>
                          <td width="57" bordercolor="#FFFFFF"><div align="center"><font color="#FFFFFF">Monto
Docto.</font></div></td>
                          <td width="64" bordercolor="#FFFFFF"><div align="center"><font color="#FFFFFF">Monto
                                Abono</font></div>
                          </td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="21" bgcolor="#B9C6D9"><div align="center">1</div>
                          </td>
                          <td width="63">
                            <div align="center">
                              <input name="textfield511" type="text" value="0781" size="8">
                            </div>
                          </td>
                          <td width="69"><div align="center">EFECTIVO
                            </div>
                          </td>
                          <td width="81">
                            <div align="center">
                              <select name="select28" disabled>
                                <option> </option>
                                <option>B.C.I.</option>
                                <option>CHILE</option>
                                <option>ESTADO</option>
                              </select>
                            </div>
                          </td>
                          <td width="125">
                            <div align="center">
                              <select name="select" disabled>
                                <option>  </option>
								<option>De la Plaza</option>
                                <option>Fuera de la Plaza</option>
                              </select>
</div>
                          </td>
                          <td width="77">
                            <div align="center">29/01/2003                            </div>
                          </td>
                          <td width="70">
                            <div align="center">30/01/2003                            </div>
                          </td>
                          <td width="57"><div align="right">90.000
                          </div></td>
                          <td width="64"><div align="right">90.000
                            </div></td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="21"><div align="center">2</div>
                          </td>
                          <td width="63">
                            <div align="center">
                              <input name="textfield528" type="text" value="0001" size="8">
                            </div>
                          </td>
                          <td width="69"><div align="center">CHEQUE
                            </div>
                          </td>
                          <td width="81">
                            <div align="center">
                              <select name="select28">
                                <option> </option>
                                <option selected>B.C.I.</option>
                                <option>CHILE</option>
                                <option>ESTADO</option>
                              </select>
                            </div>
                          </td>
                          <td width="125">
                            <div align="center">
                              <select name="select28">
                              <option>De la Plaza
                              <option>Fuera de la Plaza
                              </select>
                            </div>
                          </td>
                          <td width="77">
                            <div align="center">29/01/2003 </div>
                          </td>
                          <td width="70">
                            <div align="center">28/02/2003                            </div>
                          </td>
                          <td width="57"><div align="right">100.000
                          </div></td>
                          <td width="64"><div align="right">100.000
                            </div></td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="21"><div align="center">3</div>
                          </td>
                          <td width="63">
                            <div align="center">
                              <input name="textfield532" type="text" value="0002" size="8">
                            </div>
                          </td>
                          <td width="69"><div align="center">CHEQUE
                            </div>
                          </td>
                          <td width="81">
                            <div align="center">
                              <select name="select28">
                                <option> </option>
                                <option selected>B.C.I.</option>
                                <option>CHILE</option>
                                <option>ESTADO</option>
                              </select>
                            </div>
                          </td>
                          <td width="125">
                            <div align="center">
                              <select name="select2">
                                <option>De la Plaza
                                <option>Fuera de la Plaza
                              </select>
</div>
                          </td>
                          <td width="77">
                            <div align="center">29/01/2003 </div>
                          </td>
                          <td width="70">
                            <div align="center">30/03/2003 </div>
                          </td>
                          <td width="57"><div align="right">100.000
                          </div></td>
                          <td width="64"><div align="right">100.000
                          </div></td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="21"><div align="center">4</div>
                          </td>
                          <td width="63">
                            <div align="center">
                              <input name="textfield542" type="text" value="0003" size="8">
                            </div>
                          </td>
                          <td width="69"><div align="center">CHEQUE
                            </div>
                          </td>
                          <td width="81">
                            <div align="center">
                              <select name="select28">
                                <option> </option>
                                <option selected>B.C.I.</option>
                                <option>CHILE</option>
                                <option>ESTADO</option>
                              </select>
                            </div>
                          </td>
                          <td width="125">
                            <div align="center">
                              <select name="select3">
                                <option>De la Plaza
                                <option>Fuera de la Plaza
                              </select>
</div>
                          </td>
                          <td width="77">
                            <div align="center">29/01/2003 </div>
                          </td>
                          <td width="70">
                            <div align="center">30/04/2003 </div>
                          </td>
                          <td width="57"><div align="right">100.000
                          </div></td>
                          <td width="64"><div align="right">100.000
                          </div></td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="21"><div align="center">5</div>
                          </td>
                          <td width="63">
                            <div align="center">
                              <input name="textfield552" type="text" value="0004" size="8">
                            </div>
                          </td>
                          <td width="69"><div align="center">CHEQUE
                            </div>
                          </td>
                          <td width="81">
                            <div align="center">
                              <select name="select28">
                                <option> </option>
                                <option selected>B.C.I.</option>
                                <option>CHILE</option>
                                <option>ESTADO</option>
                              </select>
                            </div>
                          </td>
                          <td width="125">
                            <div align="center">
                              <select name="select4">
                                <option>De la Plaza
                                <option>Fuera de la Plaza
                              </select>
</div>
                          </td>
                          <td width="77">
                            <div align="center">29/01/2003 </div>
                          </td>
                          <td width="70"><div align="center">30/05/2003
                            </div>
                          </td>
                          <td width="57"><div align="right">100.000
                          </div></td>
                          <td width="64"><div align="right">100.000
                          </div></td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="21"><div align="center">6</div>
                          </td>
                          <td width="63">
                            <div align="center">
                              <input name="textfield562" type="text" value="0005" size="8">
                            </div>
                          </td>
                          <td width="69"><div align="center">CHEQUE
                            </div>
                          </td>
                          <td width="81">
                            <div align="center">
                              <select name="select28">
                                <option> </option>
                                <option selected>B.C.I.</option>
                                <option>CHILE</option>
                                <option>ESTADO</option>
                              </select>
                            </div>
                          </td>
                          <td width="125">
                            <div align="center">
                              <select name="select5">
                                <option>De la Plaza
                                <option>Fuera de la Plaza
                              </select>
</div>
                          </td>
                          <td width="77">
                            <div align="center">29/01/2003 </div>
                          </td>
                          <td width="70"><div align="center">30/06/2003
                            </div>
                          </td>
                          <td width="57"><div align="right">100.000
                          </div></td>
                          <td width="64"><div align="right">100.000
                          </div></td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="21"><div align="center">7</div>
                          </td>
                          <td width="63">
                            <div align="center">
                              <input name="textfield572" type="text" value="0501" size="8">
                            </div>
                          </td>
                          <td width="69"><div align="center">LETRA</div>
                          </td>
                          <td width="81">
                            <div align="center">
                              <select name="select10" disabled>
                                <option> </option>
                                <option>B.C.I.</option>
                                <option>CHILE</option>
                                <option>ESTADO</option>
                              </select>
                            </div>
                          </td>
                          <td width="125">
                            <div align="center">
                              <select name="select6" disabled>
                                <option> </option>
                                <option>De la Plaza</option>
                                <option>Fuera de la Plaza</option>
                              </select>
</div>
                          </td>
                          <td width="77">
                            <div align="center">29/01/2003 </div>
                          </td>
                          <td width="70"><div align="center">30/07/2003
                            </div>
                          </td>
                          <td width="57"><div align="right">100.000
                          </div></td>
                          <td width="64"><div align="right">100.000
                          </div></td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="21"><div align="center">8</div>
                          </td>
                          <td width="63">
                            <div align="center">
                              <input name="textfield582" type="text" value="0502" size="8">
                            </div>
                          </td>
                          <td width="69"><div align="center">LETRA
                            </div>
                          </td>
                          <td width="81">
                            <div align="center">
                              <select name="select11" disabled>
                                <option> </option>
                                <option>B.C.I.</option>
                                <option>CHILE</option>
                                <option>ESTADO</option>
                              </select>
                            </div>
                          </td>
                          <td width="125">
                            <div align="center">
                              <select name="select7" disabled>
                                <option> </option>
                                <option>De la Plaza</option>
                                <option>Fuera de la Plaza</option>
                              </select>
</div>
                          </td>
                          <td width="77">
                            <div align="center">29/01/2003 </div>
                          </td>
                          <td width="70"><div align="center">30/08/2003
                            </div>
                          </td>
                          <td width="57"><div align="right">100.000
                          </div></td>
                          <td width="64"><div align="right">100.000
                          </div></td>
                        </tr>
                        <tr bgcolor="#B9C6D9">
                          <td width="21"><div align="center">9</div>
                          </td>
                          <td width="63">
                            <div align="center">
                              <input name="textfield592" type="text" value="0503" size="8">
                            </div>
                          </td>
                          <td width="69">
                            <div align="center">LETRA </div>
                          </td>
                          <td width="81">
                            <div align="center">
                              <select name="select12" disabled>
                                <option> </option>
                                <option>B.C.I.</option>
                                <option>CHILE</option>
                                <option>ESTADO</option>
                              </select>
                            </div>
                          </td>
                          <td width="125">
                            <div align="center">
                              <select name="select8" disabled>
                                <option> </option>
                                <option>De la Plaza</option>
                                <option>Fuera de la Plaza</option>
                              </select>
</div>
                          </td>
                          <td width="77"><div align="center">29/01/2003
                            </div>
                          </td>
                          <td width="70"><div align="center">30/09/2003
                            </div>
                          </td>
                          <td width="57"><div align="right">100.000
                          </div></td>
                          <td width="64"><div align="right">100.000
                          </div></td>
                        </tr>
                      </table>
                  <BR></td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="199" bgcolor="#D8D8DE"> <div align="right">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="2%">&nbsp;</td>
                        <td width="46%"><%botonera.dibujaboton "anterior2" %>
                        </td>
                        <td width="52%"><%botonera.dibujaboton "siguiente2"%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="163" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
