<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Resoluciones"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'------------------------------------------------------------------------------------------------------------------
if not IsEmpty(Request.QueryString("pers_nrut")) then
	q_pers_nrut = Request.QueryString("pers_nrut")
else
	q_pers_nrut = 0
end if

q_pers_xdv = Request.QueryString("pers_xdv")

q_campo_filtro = Request.QueryString("cfiltro")

'------------------------------------------------------------------------------------------------------------------
set f_resoluciones = new CFormulario
f_resoluciones.Carga_Parametros "busqueda_resoluciones.xml", "resoluciones"
f_resoluciones.Inicializar conexion

consulta = "SELECT a.*, " &_
           "'<a href=""javascript:IrA(''%reso_ncorr%'')""> VER RESOLUCIÓN </a>' AS boton " &_           
           "FROM resoluciones a, resoluciones_personas b, personas c, tipos_resolucion d, actas_convalidacion e " &_
		   "WHERE a.reso_ncorr = b.reso_ncorr AND " &_
		   "      b.pers_ncorr = c.pers_ncorr AND " &_
		   "      a.tres_ccod = d.tres_ccod AND " &_
		   "      a.reso_ncorr = e.reso_ncorr AND " &_
		   "      d.tres_bconvalidacion = 'S' AND " &_
		   "	  cast(c.pers_nrut as varchar)= '" & q_pers_nrut & "' AND " &_
		   "      cast(c.pers_xdv as varchar)= '" & q_pers_xdv & "' " &_
		   "ORDER BY a.reso_fresolucion ASC, a.reso_ncorr ASC"

'response.Write(consulta)
f_resoluciones.Consultar consulta

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "acta_convalidacion.xml", "botonera"
'-----------------------------------------------------------------------
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
<!--
function Salir()
{
	close();
}

function IrA(reso_ncorr)
{
	vec_aux = opener.location.href.split(/\?/);
	str_url = vec_aux[0];
	str_url += "?reso_ncorr=" + reso_ncorr + "&pers_nrut=<%=q_pers_nrut%>&pers_xdv=<%=q_pers_xdv%>";
	
	opener.navigate(str_url);
	close();
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>


</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
      <br>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                        <td> <table width="97%" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td width="100%"></td>
                            </tr>
                            <tr> 
                              <td height="13" align="center"> <div align="right"> 
                                </div></td>
                            </tr>
                            <tr> 
                              <td height="13" align="center"><div align="right">P&aacute;ginas: 
                                  <%f_resoluciones.AccesoPagina%>
                                </div></td>
                            </tr>
                            <tr> 
                              <td align="center">
                                <% f_resoluciones.DibujaTabla %>
                              </td>
                            </tr>
                            <tr> 
                              <td align="center"> </td>
                            </tr>
                            <tr> 
                              <td></td>
                            </tr>
                            <tr> 
                              <td align="center">&nbsp;</td>
                            </tr>
                          </table></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="11%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "salir"%></div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="89%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
</body>
</html>
