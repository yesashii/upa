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
<title>Revisar Cr&eacute;ditos y Beneficios</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
//function abrir()
// { location.reload("Envios_Banco_Agregar1.asp")  }
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
                    <td width="210" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Alumno</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
				  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="524" border="0">
                        <tr>
                          <td>Rut Alumno</td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                            <input name="rut" type="text" value="11111111" size="10" maxlength="8">
      -
      <input type="text" name="dv" size="2" value = "1" maxlength="1">
                          </font><a href="javascript:buscar_persona();"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut
                              Apoderado</font></td>
                          <td>:</td>
                          <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                              <input name="rut332" type="text" size="10" maxlength="8">
        -
        <input type="text" name="dv332" size="2" value = "" maxlength="1">
                            </font><a href="javascript:buscar_persona();"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div>
                          </td>
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Detalle
                          Cr&eacute;dito Alumno</font></div>
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
                <td width="9" align="left" background="../imagenes/izq.gif"></td>
                <td bgcolor="#D8D8DE">
                  <form name="edicion"><BR>
                  <table width="100%" border="0">
                    <tr>
                      <td>Rut Alumno</td>
                      <td>:</td>
                      <td>11111111-1</td>
                      <td>Nombre Alumno</td>
                      <td>:</td>
                      <td>Juan Gallardo Fern&aacute;ndez</td>
                    </tr>
                    <tr>
                      <td width="16%">Rut Apoderado</td>
                      <td width="3%">:</td>
                      <td width="23%">05123987-5</td>
                      <td width="20%">Nombre Apoderado</td>
                      <td width="2%">:</td>
                      <td width="36%">Juan Gallardo Barra</td>
                    </tr>
                  </table><BR>
                  <table width="665" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="224"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Cr&eacute;ditos</font></b></font></td>
                      <td width="398">&nbsp;</td>
                    </tr>
                    <tr>
                      <td height="0" colspan="2"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                    </tr>
                  </table>
                  <BR>
				  <table width="665" border="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
                        <tr bordercolor="#FFFFFF" bgcolor="#6581AB">
                          <td width="77"><div align="center"><font color="#FFFFFF">Monto
                                Total ($)</font></div>
                          </td>
                          <td width="87"><div align="center"><font color="#FFFFFF">N&ordm;
                                Pagar&eacute;</font></div>
                          </td>
                          <td width="76"><div align="center"><font color="#FFFFFF">Tipo</font></div></td>
                          <td width="82"><div align="center"><font color="#FFFFFF">Fecha</font></div>
                          </td>
                          <td width="85"><div align="center"><font color="#FFFFFF">Cr&eacute;dito
                          en UF</font></div></td>
                          <td width="79"><div align="center"><font color="#FFFFFF">Valor
                                UF</font></div>
                          </td>
                          <td width="76"><div align="center"><font color="#FFFFFF">Cr&eacute;dito
                                en $</font></div>
                          </td>
                          <td width="69"><div align="center"><font color="#FFFFFF">%
                                Cr&eacute;dito</font></div>
                          </td>
                        </tr>
                        <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
                          <td align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right">500.000</div></td>
                          <td align='center'  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >1025</td>
                          <td align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >CREDITO</td>
                          <td align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >30/01/2002</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >25</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >17.000</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >425.000</td>
                          <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >85</td>
                        </tr>
                        <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
                          <td width='77' align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right">1.000.000</div></td>
                          <td align='center' width='87'  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >7563</td>
                          <td align='center' width='76' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >CREDITO</td>
                          <td align='center' width='82' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >30/01/2003</td>
                          <td  align='center' width='85' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >50</td>
                          <td  align='center' width='79' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >16.000</td>
                          <td  align='center' width='76' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >800.000</td>
                          <td  align='center' width='69' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >80</td>
                        </tr>
                    </table>
                  </form>
                    <table width="665" border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="224"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Beneficios</font></b></font></td>
                        <td width="398">&nbsp;</td>
                      </tr>
                      <tr>
                        <td height="0" colspan="2"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                      </tr>
                    </table> <BR>                   
                    <table width="665" border="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
                      <tr bordercolor="#FFFFFF" bgcolor="#6581AB">
                        <td width="75"><div align="center"><font color="#FFFFFF">Monto
                              Total ($)</font></div>
                        </td>
                        <td width="89"><div align="center"><font color="#FFFFFF">N&ordm; Pagar&eacute;</font></div>
                        </td>
                        <td width="76"><div align="center"><font color="#FFFFFF">Tipo</font></div>
                        </td>
                        <td width="82"><div align="center"><font color="#FFFFFF">Fecha</font></div>
                        </td>
                        <td width="85"><div align="center"><font color="#FFFFFF">Monto
                              en UF</font></div>
                        </td>
                        <td width="79"><div align="center"><font color="#FFFFFF">Valor
                              UF</font></div>
                        </td>
                        <td width="76"><div align="center"><font color="#FFFFFF">Monto en
                              $ </font></div>
                        </td>
                        <td width="69"><div align="center"><font color="#FFFFFF">%
                              Beneficio</font></div>
                        </td>
                      </tr>
                      <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
                        <td align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right">500.000</div>
                        </td>
                        <td align='center'  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >1025</td>
                        <td align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >BECA</td>
                        <td align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >30/01/2002</td>
                        <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >3</td>
                        <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >17.000</td>
                        <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >51.000</td>
                        <td  align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >10.2</td>
                      </tr>
                      <tr bordercolor="#FFFFFF" bgcolor="#B9C6D9">
                        <td width='75' align='center' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right">1.000.000</div>
                        </td>
                        <td align='center' width='89'  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >7563</td>
                        <td align='center' width='76' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >DESCUENTO</td>
                        <td align='center' width='82' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >30/01/2003</td>
                        <td  align='center' width='85' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >1</td>
                        <td  align='center' width='79' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >16.000</td>
                        <td  align='center' width='76' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >16.000</td>
                        <td  align='center' width='69' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >1.6</td>
                      </tr>
                    </table>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="118" bgcolor="#D8D8DE"><table width="89%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td>
                        <div align="left">
                          <%  pagina.dibujarboton "Volver","NAVEGAR","../lanzadera/lanzadera.asp" %>
                          </div></td>
                    </tr>
                  </table>
                </td>
                <td width="244" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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