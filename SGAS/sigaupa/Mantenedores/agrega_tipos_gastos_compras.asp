<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

tgas_ccod=request.querystring("tgas_ccod")
set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina
pagina.Titulo = "Tipos Gastos"

set botonera = new CFormulario
botonera.carga_parametros "areas_gastos.xml", "botonera"

 
 set f_cc = new CFormulario
f_cc.Carga_Parametros "areas_gastos.xml", "tipos_gastos_i"
f_cc.Inicializar conexion

if tgas_ccod="" then

sql_descuentos= "select''"
else
sql_descuentos= "select * from ocag_tipo_gasto where tgas_ccod="&tgas_ccod&""
end if

f_cc.Consultar sql_descuentos
f_cc.siguiente



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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">
<form name="edicion">
<input type="hidden" name="b[0][tgas_ccod]" value="<%=tgas_ccod%>" />
<table width="750" height="300" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>
	<table width="70%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				<table align="center">
					<tr>
						<td>
							<%pagina.DibujarTituloPagina%>
						</td>
					</tr>
				</table>
				<table align="left" width="90%" class='v1' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' >
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
				<th>Item</th>
				<th>Valor</th>
				</tr>
					<tr>
						<td>
							Detalle Gasto
						</td>
						<td>
							<%f_cc.DibujaCampo("tgas_tdesc")%>
						</td>
					</tr>
					<tr>
						<td>
							Codigo
						</td>
						<td>
							<%f_cc.DibujaCampo("tgas_cod_cuenta")%>
						</td>
					</tr>
					<tr>
						<td>
							Nombre Cuenta
						</td>
						<td>
							<%f_cc.DibujaCampo("tgas_nombre_cuenta")%>
						</td>
					</tr>
				</table>
				</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
    <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%botonera.DibujaBoton"guardar_gasto" %></div></td>
					
                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table> </form>
</body>
</html>