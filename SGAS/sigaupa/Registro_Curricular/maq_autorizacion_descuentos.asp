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
function Siguiente()
{
  location.replace("Forma_Pago2.asp");
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
                      de Alumno</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="462" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                  <BR>
                  <table width="97%"  border="0">
                    <tr>
                      <td width="17%"><strong>Rut Postulante </strong></td>
                      <td width="3%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong>:</strong>
                        </font></td>
                      <td width="59%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                        <input name="rut" type="text" value="11111111" size="10" maxlength="8">
-
<input type="text" name="dv" size="2" value = "1" maxlength="1"><a href="javascript:buscar_persona();"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a>
                      </font></td>
                      <td width="21%"><div align="center"><a href="javascript:Buscar(document.buscador);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image18','','../imagenes/botones/buscar_f2.gif',1)"><img src="../imagenes/botones/buscar.gif" name="Image18" width="88" height="16" border="0"></a></div></td>
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
                      <td width="6" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td valign="middle" nowrap background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Resultados de la b&uacute;squeda </font></div></td>
                      <td width="6" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                      <td width="100%" bgcolor="#D8D8DE">&nbsp;</td>
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
				  <BR><table width="632" border="0" align="center">
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
                    <table width="632" border="0" align="center" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
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
                    </table>
                    <BR>
                    <form name="form1" method="post" action="">
                    <table width="632" border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="224"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Descuentos</font></b></font></td>
                        <td width="398">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="0" height="0"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                        <td width="0" height="0">&nbsp;</td>
                      </tr>
                    </table>
					
                    <script language='javaScript1.2'> colores = Array(3);   colores[0] = ''; colores[1] = '#97AAC6'; colores[2] = '#C0C0C0'; </script>
                    <table width="632" border="0" align="center" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
                      <tr bordercolor="#FFFFFF" bgcolor="#6581AB">
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
                        <td width="109"><div align="center" class="tituloTabla"><strong>Estado</strong></div></td>
                      </tr>
                      <tr bgcolor="#B9C6D9">
                        <td width="137" onMouseOver="resaltar(this)" onMouseOut="desResaltar(this)" onClick="open('info_descuentos.asp', '', 'width=510,height=250')" class="click"><div align="center">Beca (Dep. Destacado)</div>
                        </td>
                        <td width="80" onMouseOver="resaltar(this)" onMouseOut="desResaltar(this)" onClick="open('info_descuentos.asp', '', 'width=510,height=250')" class="click"><div align="center">10</div>
                        </td>
                        <td width="86" onMouseOver="resaltar(this)" onMouseOut="desResaltar(this)" onClick="open('info_descuentos.asp', '', 'width=510,height=250')" class="click"><div align="center">10.000</div>
                        </td>
                        <td width="69" onMouseOver="resaltar(this)" onMouseOut="desResaltar(this)" onClick="open('info_descuentos.asp', '', 'width=510,height=250')" class="click"><div align="center">0</div>
                        </td>
                        <td width="93" onMouseOver="resaltar(this)" onMouseOut="desResaltar(this)" onClick="open('info_descuentos.asp', '', 'width=510,height=250')" class="click"><div align="center">0</div>
                        </td>
                        <td width="109" onMouseOver="resaltar(this)" onMouseOut="desResaltar(this)" onClick="open('info_descuentos.asp', '', 'width=510,height=250')" class="click"><div align="center">10.000</div>
                        </td>
                        <td width="109"><div align="center">
                          <select name="select">
                            <option selected>PENDIENTE</option>
                            <option>AUTORIZADO</option>
                          </select>
                        </div></td>
                      </tr>
                      <tr bgcolor="#B9C6D9">
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
                        <td width="109"><div align="center">
                          <select name="select2">
                            <option>PENDIENTE</option>
                            <option selected>AUTORIZADO</option>
                                                    </select>
                        </div></td>
                      </tr>
                    </table>
                    </form>
                    <BR></td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="224" bgcolor="#D8D8DE"> 
                    <div align="center">
                      <table width="90%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="32%"><div align="center">
                            <%pagina.DibujarBoton "Guardar", "", ""%>
                          </div></td>
                          <td width="27%"><div align="center">
                            <%pagina.DibujarBoton "Salir", "", ""%>
                          </div></td>
                        </tr>
                      </table>
                  </div></td>
                  <td width="138" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
