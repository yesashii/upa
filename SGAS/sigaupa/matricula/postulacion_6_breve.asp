<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
v_post_ncorr = Session("post_ncorr")
'response.Write("post_ncorr=" & v_post_ncorr)
if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Postulación - Envío de Postulación"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "postulacion_6.xml", "botonera"

'###############	VERIFICA QUE EXISTA UN CODEUDOR ANTES DE ENVIAR LA POSTULACION	###################
sql_existe_codeudor=" select count(*) from codeudor_postulacion where post_ncorr="&v_post_ncorr
v_existe=conexion.ConsultaUno(sql_existe_codeudor)

if v_existe=0 then
	Session("mensajeError") ="No ha ingresado un sostenedor economico para su postulacion."
	Response.Redirect("postulacion_5_breve.asp")
end if
'########################################################################################################


'---------------------------------------------------------------------------------------------------
set f_postulacion = new CFormulario
f_postulacion.Carga_Parametros "postulacion_6.xml", "postulacion"
f_postulacion.Inicializar conexion
f_postulacion.Consultar "select '' "
f_postulacion.AgregaCampoCons "post_ncorr", v_post_ncorr
f_postulacion.Siguiente

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
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
.style1 {color: #FF0000}
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#e1eae0">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
    <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%				
				pagina.DibujarLenguetas Array("Informaci&oacute;n general", "Datos Personales", "Apoderado Sostenedor", "Env&iacute;o de Postulaci&oacute;n"), 4
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo " FICHA DE POSTULACION ENVÍO DE POSTULACIÓN"%><br>
                </div>
              <form name="edicion">
                <table width="96%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                    <div align="justify">Si est&aacute; de acuerdo con la informaci&oacute;n entregada, presione el bot&oacute;n &quot;Enviar&quot;, con lo que su ficha de postulaci&oacute;n ser&aacute; cerrada, es decir, ser&aacute; enviada y no podr&aacute; hacer m&aacute;s modificaciones. Si no est&aacute; seguro de enviar su ficha, presione el bot&oacute;n &quot;Salir&quot;, con lo que podr&aacute; ingresar nuevamente a su ficha y modificar la informaci&oacute;n ingresada. <br>                      
                          <br>                      
                        </div></td></tr>
                </table>
                          <%f_postulacion.DibujaCampo("post_ncorr")%><br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%
				  f_botonera.AgregaBotonParam "anterior", "url", "postulacion_5_breve.asp"
				  f_botonera.DibujaBoton("anterior")
				  %></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("enviar")%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>
