<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pais_ccod =Request.QueryString("b[0][pais_ccod]")


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



'------------------------------------PAISES---------------------------------------------------------------
set f_pais = new CFormulario
f_pais.Carga_Parametros "convenios_rrii.xml", "agrega_ciudad_extranjera"
f_pais.Inicializar conexion
f_pais.Consultar "select ''"
f_pais.Siguiente
f_pais.AgregaCampoCons "pais_ccod", pais_ccod






set f_ciudad = new CFormulario
f_ciudad.Carga_Parametros "convenios_rrii.xml", "muestra_ciudad"
f_ciudad.Inicializar conexion

if pais_ccod<>"" then
sql_descuentos="select ciex_ccod,ciex_tdesc,pais_ccod from ciudades_extranjeras where pais_ccod="&pais_ccod&" order by ciex_tdesc"
else
sql_descuentos="select ciex_ccod,ciex_tdesc,pais_ccod from ciudades_extranjeras where 1=2"
end if				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_ciudad.Consultar sql_descuentos




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
function envia()
{
		document.ciudad.action ='agrega_ciudad_convenio.asp';
		document.ciudad.method = "get";
		document.ciudad.submit();
}
function habilita_texto(valor)
{
	if (valor!='')
	{	
		//alert(valor)
		document.ciudad.elements["b[0][ciex_tdesc]"].disabled=false
	}
	else
	{
		//alert(valor)
		document.ciudad.elements["b[0][ciex_tdesc]"].disabled=true
	}

}
function alcargar()
{
pais_ccod='<%=pais_ccod%>'
habilita_texto(pais_ccod)
	if (pais_ccod!="")
	{
		document.ciudad.elements["b[0][pais_ccod]"].value=pais_ccod
	}
		

}


</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); alcargar();" onBlur="revisaVentana();">
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
				 	<table align="center" width="100%">
						<tr>
							<td width="5%">Pais</td>
						  <td width="34%"><%f_pais.DibujaCampo("pais_ccod")%> </td>
							<td width="7%" align="right">Ciudad</td>
						  <td width="54%"><%f_pais.DibujaCampo("ciex_tdesc")%></td>
					  </tr>
					</table>
					
					<br>
					<br>
					<table align="center" width="100%">
						   <tr>
                             <td align="center"width="25%">&nbsp;</td>
							<td align="right"width="50%">P&aacute;gina:
                                 <%f_ciudad.accesopagina%></td>
							<td align="center"width="25%">&nbsp;</td>
                            </tr>
						<tr>
							<td align="center"width="25%">&nbsp;</td>
							<td align="center"width="50%"><%f_ciudad.Dibujatabla()%></td>
							<td align="center"width="25%">&nbsp;</td>
						</tr>
					</table>
					
                 </form>
			</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				 <td><div align="center"><%botonera.DibujaBoton("salir")%></div></td>	
                  <td><div align="center">
					<%botonera.DibujaBoton("guardar_ciudad")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
	<br>
	</td>
  </tr>  
</table>
</body>
</html>