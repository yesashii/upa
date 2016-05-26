<!-- #include file = "../biblioteca/_conexion.asp" -->
<%session("rut_usuario") ="15964262"%>

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

ciex_ccod =Request.QueryString("ciex_ccod")
pais_ccod =Request.QueryString("pais_ccod")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Convenios Internacionales"

set errores= new CErrores
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "convenios_rrii.xml", "botonera"
'---------------------------------------------------------------------------------------------------


set f_ciudad = new CFormulario
f_ciudad.Carga_Parametros "convenios_rrii.xml", "editar_extranjera"
f_ciudad.Inicializar conexion

if ciex_ccod<>"" then
sql_descuentos="select ciex_ccod,ciex_tdesc from ciudades_extranjeras where ciex_ccod="&ciex_ccod&" order by ciex_tdesc"
else
sql_descuentos="select ciex_ccod,ciex_tdesc from ciudades_extranjeras where 1=2"
end if				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_ciudad.Consultar sql_descuentos
f_ciudad.siguiente



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


</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td>
				 <form name="ciudad">
				 <input type="hidden" name="b[0][ciex_ccod]" value="<%=ciex_ccod%>">
				  <input type="hidden" name="b[0][pais_ccod]" value="<%=pais_ccod%>">
				   <table align="center" width="100%">
						<tr valign="center">
							<td align="center">
								<font size="+1"><strong>Ciudad</strong></font>
							</td>
						</tr>
						<tr valign="center">
							<td align="center">
								<%f_ciudad.DibujaCampo("ciex_tdesc")%>
							</td>
						</tr>
					</table>
					<table>
						<tr valign="bottom">
							
							<td>
								<%	botonera.AgregaBotonParam "volver", "url", "agrega_ciudad_convenio.asp?b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&""
									botonera.DibujaBoton("volver")%>
							</td><td>
								<%botonera.DibujaBoton("editar_ciudad")%>
							</td>
						</tr>
					</table>
                 </form>
			</td>
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
	<br>
	
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>