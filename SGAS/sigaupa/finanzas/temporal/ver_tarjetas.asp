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


post_ncorr 	= Request.QueryString("post_ncorr")
ting_ccod 	= Request.QueryString("ting_ccod")
ding_ndocto = Request.QueryString("ding_ndocto")
ingr_ncorr 	= Request.QueryString("ingr_ncorr")

'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "corregir_tarjetas.xml", "botonera"

'--------------------------------DATOS CHEQUE -----------------------------------------------
set f_cheque  = new CFormulario
f_cheque.Carga_Parametros "corregir_tarjetas.xml", "f_tarjeta"
f_cheque.Inicializar conexion


consulta_tarjetas = "select a.ting_ccod, a.ting_ccod as ting_ccod_ant,a.ding_tcuenta_corriente," & vbCrLf &_
					"        a.ding_ndocto,a.ding_ndocto as ding_ndocto_ant," & vbCrLf &_
					"        convert(varchar,a.DING_FDOCTO,103) as DING_FDOCTO,  " & vbCrLf &_
					"        a.DING_MDETALLE monto,a.banc_ccod as banco" & vbCrLf &_
					"    from detalle_ingresos a,ingresos b " & vbCrLf &_
					"    where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
					"        and cast(a.ting_ccod as varchar) = '"& ting_ccod &"'" & vbCrLf &_
					"        and cast(a.ding_ndocto as varchar) = '"& ding_ndocto &"'" & vbCrLf &_
					"        and cast(a.ingr_ncorr as varchar) = '"& ingr_ncorr &"'"
'response.Write("<pre>"&consulta_tarjetas&"</pre>")
'response.End()
f_cheque.Consultar consulta_tarjetas
f_cheque.siguiente


%>


<html>
<head>
<title>Detalle de Cheque</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0';

function salir()
{
 window.close();
window.opener.parent.top.location.reload();
} 
</script>

</head>
<body  bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../Registro_Curricular/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../Registro_Curricular/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../Registro_Curricular/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../Registro_Curricular/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" >
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> <td>
  <table width="47%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                  <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                    <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Detalle
                        de Cheque</font></div>
                  </td>
                  <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                </tr>
              </table>
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
              <td width="9" height="114" align="left" background="../imagenes/izq.gif">&nbsp;</td>
              <td bgcolor="#D8D8DE">
                <form name="edicion">
                  <BR>
                    <table width="347" border="0">
                      <tr> 
					  <input type="hidden" name="envios[0][ingr_ncorr]" value="<%=ingr_ncorr%>" >
					   <% f_cheque.DibujaCampo("ding_ndocto_ant") %>
					   <% f_cheque.DibujaCampo("ting_ccod_ant") %>
					   						  
                        <td width="93"><font size="1">N&ordm; Tarjeta</font></td>
                        <td width="17">:</td>
                        <td width="223"><font size="1"> 
                          <% f_cheque.DibujaCampo("ding_ndocto") %>
						 </font></td>
                      </tr>
                      <tr> 
                        <td><font size="1">Banco</font></td>
                        <td>:</td>
                        <td><font size="1"> 
                          <% f_cheque.DibujaCampo("banco") %>
                          </font></td>
                      </tr>
                      <tr> 
                        <td>Cuenta Corriente</td>
                        <td>:</td>
                        <td><font size="1"> 
                          <% f_cheque.DibujaCampo("ding_tcuenta_corriente") %>
                          </font></td>
                      </tr>
                      <tr> 
                        <td><font size="1">Vencimiento</font></td>
                        <td>:</td>
                        <td><font size="1"> 
                          <% f_cheque.DibujaCampo("DING_FDOCTO") %>
                          </font></td>
                      </tr>
                      <tr> 
                        <td><font size="1">Monto</font></td>
                        <td>:</td>
                        <td><font size="1"> 
                          <% f_cheque.DibujaCampo("monto") %>
                          </font></td>
                      </tr>
                      <tr>
                        <td>Tipo Tarjeta</td>
                        <td>:</td>
                        <td><% f_cheque.DibujaCampo("ting_ccod") %></td>
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
              <td width="160" bgcolor="#D8D8DE">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="55%"><%botonera.dibujaboton "aceptar"%>
                    </td>
                    <td width="55%"><%botonera.dibujaboton "salir_2"  %>
                    </td>
                  </tr>
                </table>
              </td>
              <td width="61" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              <td width="186" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
            </tr>
            <tr>
              <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
            </tr>
          </table>
      </td>
    </tr>
  </table>
  </td>
</tr>
</table>
</body>
</html>
