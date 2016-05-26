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

'------------------------------------PAISES---------------------------------------------------------------
set f_pais = new CFormulario
f_pais.Carga_Parametros "convenios_rrii.xml", "ubicacion_universidad"
f_pais.Inicializar conexion
f_pais.Consultar "select ''"
f_pais.Siguiente
f_pais.AgregaCampoCons "pais_ccod", pais_ccod






set f_ciudades_extranjeras = new CFormulario
f_ciudades_extranjeras.Carga_Parametros "convenios_rrii.xml", "ciudad_extranjera"
f_ciudades_extranjeras.Inicializar conexion

if pais_ccod<>"" then
sql_descuentos="select ciex_ccod,ciex_tdesc,pais_ccod from ciudades_extranjeras where pais_ccod="&pais_ccod&" order by ciex_tdesc"
else
sql_descuentos="select ''"
end if				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_ciudades_extranjeras.Consultar sql_descuentos





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
		document.ciudad_universidad.action ='universidad_convenio.asp';
		document.ciudad_universidad.method = "get";
		document.ciudad_universidad.submit();
}

function alcargar()
{
pais_ccod='<%=pais_ccod%>'
	if (pais_ccod!="")
	{
		document.ciudad_universidad.elements["b[0][pais_ccod]"].value=pais_ccod
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
            <td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				   <td width="6" ><img src="../imagenes/izq_1.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo1.gif">
					   <div align="center"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">1)  Ubicación</font></div></td>
					<td width="6"><img src="../imagenes/derech1.gif" width="6" height="17" ></td>
				  
					<td width="6" ><img src="../imagenes/izq2.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo2.gif" >
					   <div align="center"><font color="#333333" face="Verdana, Arial, Helvetica, sans-serif">2)  Datos del Convenio</font></div></td>
					<td width="6"><img src="../imagenes/der2.gif" width="6" height="17" ></td>
					
					<td width="6"><img src="../imagenes/izq2.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo2.gif">
					   <div align="center"><font color="#333333" face="Verdana, Arial, Helvetica, sans-serif">3)  Datos Contacto </font></div></td>
					<td width="6"><img src="../imagenes/der2.gif" width="6" height="17" ></td>
					
					<td width="6"><img src="../imagenes/izq2.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo2.gif">
					   <div align="center"><font color="#333333" face="Verdana, Arial, Helvetica, sans-serif">4)  Carreras en Convenio</font></div></td>
					<td width="6"><img src="../imagenes/der2.gif" width="6" height="17" ></td>
					<td width="100%" bgcolor="#D8D8DE">
				  </tr>
				</table>
			</td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				 <form name="ciudad_universidad">
				 	<table align="center" width="100%">
						<tr>
							<td width="5%">Pais</td>
						  <td width="34%"><%f_pais.DibujaCampo("pais_ccod")%> </td>
							<td width="7%" align="right">Ciudad</td>
						  <td width="54%"><select name="b[0][ciex_ccod]" id="TO-N">
								<option value="">Seleccione</option>
						   <% if pais_ccod<>"" then
						  	while f_ciudades_extranjeras.siguiente%>
						  	<option value="<%=f_ciudades_extranjeras.ObtenerValor("ciex_ccod")%>"><%=f_ciudades_extranjeras.ObtenerValor("ciex_tdesc")%></option>
						  	<%wend
						     end if%>
								</select>
							</td>
					  </tr>
					</table> 
					
					
					<table width="100%">
						<td width="11%">Universidad</td>
						  <td width="89%"><%f_pais.DibujaCampo("univ_ccod")%> </td>
					</table>
					</form>
					<br>
					<form name="universidad">
					<table align="center" width="100%">
						 <tr>
                             <td align="left"width="100%" colspan="3" ><font size="-1" color="#0000FF">Si la universidad no se encuentra en el listado ingreselo en el recuadro que esta a continuaci&oacute;n y presione <strong>Agregar Universidad</strong> para agregarla a la lista.</font></td>
                        </tr>
						<tr>
							<td align="left"width="100%" colspan="3"><input type="text" name="b[0]['univ_tdesc']" size="50" maxlength="50" id="TO-N" onBlur="this.value=this.value.toUpperCase();"></td>
						</tr>
						<tr>
							<td align="left"width="100%" colspan="3"><%botonera.DibujaBoton("agregar_universidad")%></td>
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
					<%botonera.DibujaBoton("siguiente_universidad")%></div></td>
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