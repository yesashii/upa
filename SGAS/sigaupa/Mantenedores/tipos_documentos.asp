<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%


set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina
pagina.Titulo = "Tipos de Documentos"

set botonera = new CFormulario
botonera.carga_parametros "areas_gastos.xml", "botonera"

 rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
 set f_cc = new CFormulario
f_cc.Carga_Parametros "areas_gastos.xml", "tipos_documentos"
f_cc.Inicializar conexion


sql_descuentos= "select tdoc_ccod as v_tdoc_ccod,tdoc_ccod as tipo_doc, * from ocag_tipo_documento where isnull(etdo_ccod,1) not in (3) "

f_cc.Consultar sql_descuentos
'f_cc.siguiente'



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
function ingresa_cc()
{
	window.open("agregar_tipos_documentos.asp?tdoc_ccod=<%=tdoc_ccod%>","","left=90,top=100,width=755,height=300");
}
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">

<table width="750" height="300" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	 
	<br>
	<form name="edicion">
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
				<br>
				<table align="center">
					<tr>
						<td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_cc.AccesoPagina%>
                                  </div>
						</td>
					</tr>
					<tr>
						<td>
							<% botonera.AgregaBotonParam "agregar_cc", "texto", "Agregar Perfil"
								f_cc.DibujaTabla()%>
						</td>
					</tr>
				</table>
				&nbsp;
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
                    
					<%
						botonera.agregabotonparam "agregar_cc" , "texto" , "Agregar Documento"	
						botonera.DibujaBoton"agregar_cc" %></div></td>
						
					<td><div align="center"><%botonera.DibujaBoton"salir" %></div></td>
					<td><div align="center"><%botonera.DibujaBoton "anular_doc"%></div></td>
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
	</form>
	<br>
	<br>
	
	<br>
	<br>
	</td>
  </tr>  
</table> 
</body>
</html>