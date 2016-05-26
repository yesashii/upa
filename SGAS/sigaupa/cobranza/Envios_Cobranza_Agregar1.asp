<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
'set botonera = new CFormulario
'botonera.Carga_Parametros "Envios_Notaria.xml", "botonera"
%>


<html>
<head>
<title>Detalle Envio a Cobranza</title>
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
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><%pagina.dibujarLenguetas array (array("Detalle de Documentos","Envios_Cobranza_Agregar1.asp")),1 %>
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
                  <td bgcolor="#D8D8DE">
				    &nbsp;
                    <table width="100%" border="0">
                      <tr>
                        <td>N&ordm; Folio</td>
                        <td>:</td>
                        <td width="15%"><font size="2">2000</font></td>
                        <td width="7%">Tipo</td>
                        <td width="3%">:</td>
                        <td width="20%"><font size="2">Prejudicial</font></td>
                        <td width="8%">Fecha</td>
                        <td width="2%">:</td>
                        <td><font size="2">12/01/2003</font></td>
                      </tr>
                      <tr>
                        <td width="22%">Empresa de Cobranza</td>
                        <td width="3%">:</td>
                        <td colspan="2"><font size="2">Empresa 2</font></td>
                        <td colspan="2">&nbsp;</td>
                        <td colspan="2">&nbsp;</td>
                        <td width="20%">&nbsp;</td>
                      </tr>
                    </table>
                    <form name="edicion">
				    <table width="665" border="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
				      <tr bordercolor="#FFFFFF" bgcolor="#6581AB">
				        <td width="21"><div align="center"><font color="#FFFFFF"></font></div></td>
				        <td width="64" bgcolor="#6581AB"><div align="center"><font color="#FFFFFF">N&ordm; Documento</font></div></td>
				        <td width="63"><div align="center"><font color="#FFFFFF">Tipo Documento</font></div>
			            </td>
				        <td width="77"><div align="center"><font color="#FFFFFF">Estado</font></div></td>
				        <td width="83"><div align="center"><font color="#FFFFFF">RUT Alumno</font></div></td>
				        <td width="77"><div align="center"><font color="#FFFFFF">RUT Apoderado</font></div></td>
				        <td width="120"><div align="center"><font color="#FFFFFF">Nombre Apoderado</font></div></td>
				        <td width="71"><div align="center"><font color="#FFFFFF">Fecha Emisi&oacute;n</font></div></td>
				        <td width="51"><div align="center"><font color="#FFFFFF">Monto</font></div></td>
			          </tr>
				      <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
				        <td>
				          <input type="checkbox" name="checkbox" value="checkbox">
				        </td>
				        <td><div align="center">9050</div></td>
				        <td><div align="center">LETRA</div>
			            </td>
				        <td><div align="center">C.Prejudicial</div></td>
				        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>11111111-1</div></td>
				        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>05123987-5</div></td>
				        <td><a href="Envios_Notaria_Agregar.asp"></a>Juan Gallardo Barra</td>
				        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>10/01/2003</div></td>
				        <td bgcolor="#B9C6D9"><div align="right"><a href="Envios_Notaria_Agregar.asp"></a>75.000</div></td>
			          </tr>
				      <tr bgcolor="#B9C6D9">
                        <td>
                          <input type="checkbox" name="checkbox" value="checkbox">
                        </td>
                        <td><div align="center">9051</div>
                        </td>
                        <td><div align="center">LETRA</div>
                        </td>
                        <td><div align="center">C.Prejudicial</div></td>
                        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>11111111-1</div>
                        </td>
                        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>05123987-5</div>
                        </td>
                        <td><a href="Envios_Notaria_Agregar.asp"></a>Juan Gallardo
                          Barra</td>
                        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>10/01/2003</div>
                        </td>
                        <td bgcolor="#B9C6D9"><div align="right"><a href="Envios_Notaria_Agregar.asp"></a>90.000</div>
                        </td>
			          </tr>
				      <tr bgcolor="#B9C6D9">
                        <td>
                          <input type="checkbox" name="checkbox" value="checkbox">
                        </td>
                        <td><div align="center">9052</div>
                        </td>
                        <td><div align="center">LETRA</div>
                        </td>
                        <td><div align="center">C.Prejudicial</div></td>
                        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>11111111-1</div>
                        </td>
                        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>05123987-5</div>
                        </td>
                        <td><a href="Envios_Notaria_Agregar.asp"></a>Juan Gallardo
                          Barra</td>
                        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>10/01/2003</div>
                        </td>
                        <td bgcolor="#B9C6D9"><div align="right"><a href="Envios_Notaria_Agregar.asp"></a>90.000</div>
                        </td>
			          </tr>
				      <tr bgcolor="#B9C6D9">
                        <td>
                          <input type="checkbox" name="checkbox" value="checkbox">
                        </td>
                        <td><div align="center">1522</div>
                        </td>
                        <td><div align="center">CHEQUE</div>
                        </td>
                        <td><div align="center">C.Prejudicial</div></td>
                        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>12569784-9</div>
                        </td>
                        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>09456132-0</div>
                        </td>
                        <td><a href="Envios_Notaria_Agregar.asp"></a>Leonel Vidal
                          Jara</td>
                        <td><div align="center"><a href="Envios_Notaria_Agregar.asp"></a>10/01/2003</div>
                        </td>
                        <td bgcolor="#B9C6D9"><div align="right"><a href="Envios_Notaria_Agregar.asp"></a>150.000</div>
                        </td>
			          </tr>
				      <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
				        <td><input type="checkbox" name="checkbox3" value="checkbox"></td>
				        <td><div align="center">1258</div></td>
				        <td><div align="center">CHEQUE</div>
			            </td>
				        <td><div align="center">C.Prejudicial</div></td>
				        <td><div align="center">22256987-3</div></td>
				        <td><div align="center">05147852-9</div></td>
				        <td>Graciela L&oacute;pez Frei</td>
				        <td><div align="center">10/01/2003</div></td>
				        <td bgcolor="#B9C6D9"><div align="right">480.000</div></td>
			          </tr>
				      <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
				        <td><input type="checkbox" name="checkbox32" value="checkbox"></td>
				        <td><div align="center">5263</div></td>
				        <td><div align="center">CHEQUE</div>
			            </td>
				        <td><div align="center">C.Prejudicial</div></td>
				        <td><div align="center">10236547-2</div></td>
				        <td><div align="center">03254789-k</div></td>
				        <td>Esteban Zu&ntilde;iga </td>
				        <td><div align="center">10/01/2003</div></td>
				        <td bgcolor="#B9C6D9"><div align="right">50.000</div></td>
			          </tr>
				      <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
				        <td><input type="checkbox" name="checkbox4" value="checkbox"></td>
				        <td><div align="center">1112</div></td>
				        <td><div align="center">CHEQUE</div>
			            </td>
				        <td><div align="center">C.Prejudicial</div></td>
				        <td><div align="center">12598746-k</div></td>
				        <td><div align="center">11236596-6</div></td>
				        <td>Ivan C&aacute;rdenas </td>
				        <td><div align="center">10/01/2003</div></td>
				        <td bgcolor="#B9C6D9"><div align="right">90.000</div></td>
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
                  <td width="352" bgcolor="#D8D8DE"><table width="97%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="28%">
					    <div align="left">
				          <% pagina.DibujarBoton "Anterior", "NAVEGAR", "Envios_Cobranza.asp"%>
					      </div></td>
                      <td width="22%"><%pagina.DibujarBoton "Agregar", "AGREGAR-80-100-750-520", "Envios_Cobranza_Buscar.asp" %>
                      </td>
                      <td width="30%"><div align="left">
                          <%pagina.DibujarBoton "No Enviar", "ELIMINAR", "" %>
                      </div></td>
                      <td width="20%"><%pagina.DibujarBoton "Generar Excel", "", "" %>
</td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="39" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="286" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
