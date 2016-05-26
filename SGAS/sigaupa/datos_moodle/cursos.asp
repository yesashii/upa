<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Historial de Documentos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "datos_moodle.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "datos_moodle.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "datos_moodle.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------


usuario=negocio.ObtenerUsuario
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
function enviar()
{
		formulario=document.forms['buscador']
		formulario.submit();
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador" method="get" action="http://admision.upacifico.cl/datos_moodle/www/muestra.php">
			<input type="hidden" value="<%=usuario%>" name="ses_usuario">
              <br>
              <table width="74%"  border="0" align="center">
                <tr>
					
					<td width="12%"><strong>Codigo  :</strong></td>
					
					<td width="37%"><div align="left"> <input type='text'  name='id_curso' value='' size='35'  maxlength='34'  id='TO-N' >

					
					<td width="30%">&nbsp;</td>
					<td width="21%"><div align="center">
					  <div align="center"><table id="bt_buscar7055" width="92" border="0" cellspacing="0" cellpadding="0" class="click" onMouseOver="_OverBoton(this);" onMouseOut="_OutBoton(this);" onClick="enviar()">
  <tr> 
    <td width="7" height="16" rowspan="3"><img src="../imagenes/botones/boton1.gif" width="5" height="16" id="bt_buscar7055c11"></td> 
    <td width="88" height="2"><img src="../imagenes/botones/boton2.gif" width="88" height="2" id="bt_buscar7055c12"></td> 
    <td width="10" height="16" rowspan="3"><img src="../imagenes/botones/boton4.gif" width="5" height="16" id="bt_buscar7055c13"></td>
  </tr>
  <tr> 
    <td height="12" bgcolor="#EEEEF0" id="bt_buscar7055c21" nowrap> 
      <div align="center"><font id="bt_buscar7055f21" color="#333333" size="1" face="Verdana, Arial, Helvetica, sans-serif">Buscar</font></div></td>
  </tr>
  <tr> 
    <td width="88" height="2"><img src="../imagenes/botones/boton3.gif" width="88" height="2" id="bt_buscar7055c31"></td>
  </tr>
</table></div></td
					></tr>
					</table>
					
					
			  			  
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>