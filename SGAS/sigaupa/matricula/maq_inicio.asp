<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "matricula-inicio.xml", "botonera"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------

%>
<html>
<head>
<title>Inicio</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function clave(){
  direccion = "olvido_clave.asp";
  window.open(direccion ,"ventana1","width=370,height=205,scrollbars=no, left=313, top=200");
}
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
	<br><br><br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td width="9"><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td width="7"><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td width="9"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="100" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">INGRESO</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td width="7"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td width="9"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td width="7"><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
                    <form name="edicion">
				      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="20%" height="22">&nbsp;</td>
                          <td width="20%">&nbsp;</td>
                          <td width="2%">&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="20%">&nbsp;</td>
                          <td width="20%" height="25"><strong>USUARIO (RUT)</strong></td>
                          <td width="2%">:</td>
                          <td><input name="usuario" type="text" id="TO-N" size="25" maxlength="25"></td>
                        </tr>
                        <tr>
                          <td width="20%">&nbsp;</td>
                          <td width="20%" height="25"><strong>CLAVE</strong></td>
                          <td width="2%">:</td>
                          <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><input name="clave" type="password" id="TO-N" size="25" maxlength="25"></td>
                                <td><%'f_botonera.DibujaBoton("aceptar")%>
								<%pagina.DibujarBoton "Aceptar", "NAVEGAR", "maq_postulacion_1.asp"%>
								</td>
                              </tr>
                          </table></td>
                        </tr>
                        <tr>
                          <td width="20%">&nbsp;</td>
                          <td width="20%">&nbsp;</td>
                          <td width="2%">&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="25" colspan="4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="19%">&nbsp;</td>
                                <td width="31%" height="25">&#8226;&nbsp; <strong><a href="javascript:clave();">&iquest;OLVID&Oacute; CLAVE?</a></strong></td>
                                <td width="50%">&#8226; <a href="pre_registrarse.asp"><strong>REGISTRARSE</strong></a></td>
                              </tr>
                          </table></td>
                        </tr>
                        <tr>
                          <td height="25">&nbsp;</td>
                          <td colspan="3">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="25">&nbsp;</td>
                          <td colspan="3">&nbsp;</td>
                        </tr>
                      </table>
		            </form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="100%" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
          </table></td>
      </tr>
    </table>
	<br><br><br><br><br><br><br><br><br><br><br><br>
	</td>
  </tr>  
</table>
</body>
</html>
