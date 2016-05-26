<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_post_ncorr = Request.QueryString("post_ncorr")
'ofer_ncorr = Request.QueryString("ofer_ncorr")
'stde_ccod = Request.QueryString("stde_ccod")

'-----------------------------------DATOS PERIODO -----------------------------------------------
sql_codeudor = " select b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' +b.pers_tape_materno as nombre_codeudor, " & vbcrlf & _
" c.DIRE_TCALLE + ' ' + c.DIRE_TNRO + '  (' + d.CIUD_TDESC + ')' AS direccion_codeudor, " & vbcrlf & _
" b.pers_tfono " & vbcrlf & _
" from codeudor_postulacion a, " & vbcrlf & _
" personas_postulante b,direcciones_publica c,ciudades d " & vbcrlf & _
" where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _
" and b.pers_ncorr = c.pers_ncorr " & vbcrlf & _
" and c.ciud_ccod = d.ciud_ccod " & vbcrlf & _
" and c.tdir_ccod= 1 " & vbcrlf & _
" and a.post_ncorr = '"&v_post_ncorr&"'"

set fc_codeudor = new CFormulario
fc_codeudor.Carga_Parametros "post_cerrada.xml", "info_codeudor"
fc_codeudor.Inicializar conexion

fc_codeudor.Consultar sql_codeudor
fc_codeudor.siguiente
NombreCodeudor = fc_codeudor.obtenervalor("nombre_codeudor")
DireccionCodeudor = fc_codeudor.obtenervalor("direccion_codeudor")
FonoCodeudor = fc_codeudor.obtenervalor("pers_tfono")

%>


<html>
<head>
<title>Informaci&oacute;n de descuentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
</script>

</head>
<body bgcolor="#555564" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	 		
	<table width="416" border="0" align="center" cellpadding="0" cellspacing="0">
        <%'pagina.DibujarEncabezado()%>
        <tr> 
          <td width="482" valign="top" bgcolor="#EAEAEA"> <table width="47%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
                 
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="400" height="8" border="0"></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td>
                        <%pagina.DibujarLenguetas Array("Información"), 1 %>
                      </td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="400" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"> <BR> <form name="edicion">
                          <table width="378" height="56"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td width="118">Nombre Apoderado</td>
                              <td width="10"><div align="center">: </div></td>
                              <td width="250"><strong><%=NombreCodeudor%> </strong></td>
                            </tr>
                            <tr> 
                              <td width="118">Direcci&oacute;n Apoderado</td>
                              <td width="10"><div align="center">:</div></td>
                              <td align="left"><strong><%=DireccionCodeudor%></strong></td>
                            </tr>
                            <tr> 
                              <td width="118">Fono Apoderado</td>
                              <td width="10"><div align="center">:</div></td>
                              <td><strong><%=FonoCodeudor%></strong></td>
                            </tr>
                          </table>
                        </form>
                        <br> </td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                      <td width="287" bgcolor="#D8D8DE"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td width="46%" align="center">
                              <%pagina.DibujarBoton "Cerrar", "CERRAR", ""%>
                            </td>
                            <td width="54%" align="center">&nbsp; </td>
                          </tr>
                        </table></td>
                      <td width="75" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                      <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                    </tr>
                    <tr> 
                      <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
      </table>
      <br>
      <br>
      
     
    </td>
  </tr>  
</table>
</body>
</html>
