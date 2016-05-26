<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingresos, Retiros y Condonaciones"

'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Pres_Resumen.xml", "botonera"
'-----------------------------------------------------------------------
 sede = request.querystring("busqueda[0][sede_ccod]")
 carrera = request.querystring("busqueda[0][carr_ccod]")
 'fecha = request.querystring("busqueda[0][envi_fenvio]")
 'cuenta_corriente = request.querystring("busqueda[0][ccte_tdesc]")

set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Pres_Resumen.xml", "filtros"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' as sede_ccod, '' as carr_ccod"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "sede_ccod", sede
 f_busqueda.AgregaCampoCons "carr_ccod", carrera
 'f_busqueda.AgregaCampoCons "envi_fenvio", fecha
 'f_busqueda.AgregaCampoCons "ccte_tdesc", cuenta_corriente


'----------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("CLASES18")
Usuario = negocio.ObtenerUsuario()

consulta = "SELECT pers_ncorr FROM personas WHERE pers_nrut='" & Usuario & "'"
pers_ncorr = conexion.ConsultaUno(consulta)
f_busqueda.AgregaCampoParam "sede_ccod","destino", "(select a.sede_ccod, d.sede_tdesc from sis_sedes_usuarios a, sis_usuarios b, personas c, sedes d where a.pers_ncorr = b.pers_ncorr and b.pers_ncorr = c.pers_ncorr and a.sede_ccod = d.sede_ccod and a.pers_ncorr =" & pers_ncorr & ") a"
'----------------------------------------------------------------------------


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
function abrir(tipodoc)
{
   ano =  buscador.elements["busqueda[0][anos_ccod]"].value;
   sede =  buscador.elements["busqueda[0][sede_ccod]"].value;
   if (sede != "") 
	 {
	  if (ano != "")
       {
	    sede =  buscador.elements["busqueda[0][sede_ccod]"].value;
	    ano = buscador.elements["busqueda[0][anos_ccod]"].value;
        //URL = "/REPORTESNET/pres_resumen.aspx?sede_ccod=" + sede + "&ano=" + ano + "&tipodoc=" + tipodoc + "&periodo=<%=Periodo%>";      
		URL = "../reportesnet/retiros_condonaciones.aspx?filtros[0][sede_ccod]=" + sede + "&filtros[0][anos_ccod]=" + ano + "&filtros[0][formato]=" + tipodoc;
        window.open(URL,"","");
	   }
	   else
	   {
	   	  alert("Debe Seleccionar el Periodo Académico"); 
 	      buscador.elements["busqueda[0][anos_ccod]"].focus;
	   }	  
	}
   else
    {
	   alert("Debe Seleccionar la Sede"); 
	    buscador.elements["busqueda[0][sede_ccod]"].focus;	  
	}
	
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
                  <form name="buscador" id="buscador">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Filtros de la Búsqueda"%>
                      <br>
                          <table width="100%" border="0">
                            <tr> 
                              <td width="21%"><strong>Sede</strong></td>
                              <td width="5%"><div align="center"><strong>:</strong></div></td>
                              <td width="66%"><%f_busqueda.DibujaCampo "sede_ccod"%></td>
                              <td width="7%" rowspan="2">&nbsp;</td>
                            </tr>
                          <tr> 
                              <td><strong>Periodo Acad&eacute;mico</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td>
                                <%f_busqueda.DibujaCampo "anos_ccod"%>
                              </td>
                              <td width="1%">&nbsp;</td>
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
            <td width="32%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
				  <% botonera.DibujaBoton "imprimir" %>
				  </div></td>
                  <td><div align="center">
				  <% botonera.DibujaBoton "excel" %>
				  </div></td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="68%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
