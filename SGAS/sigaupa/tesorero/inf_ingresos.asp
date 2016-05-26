<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "andres.xml", "btn_inf_ingresos"

set conn = new CConexion
conn.Inicializar "desauas"

set f_boletas_ip = new CFormulario
f_boletas_ip.Carga_Parametros "andres.xml", "f_boletas"
f_boletas_ip.Inicializar conn

set f_boletas_cft = new CFormulario
f_boletas_cft.Carga_Parametros "andres.xml", "f_boletas"
f_boletas_cft.Inicializar conn

set f_boletas_ca = new CFormulario
f_boletas_ca.Carga_Parametros "capacitacion.xml", "f_boletas"
f_boletas_ca.Inicializar conn


mcaj_ncorr = request.QueryString("mcaj_ncorr")


consulta = "SELECT rownum, d.* FROM( " &_
           "SELECT a.ingr_ncorr, c.pers_nrut || '-' || c.pers_xdv AS rut_persona, " &_
		   "       a.ting_ccod, " &_
		   "       a.ingr_nfolio_referencia, " &_
		   "       nvl(decode(a.eing_ccod, 3, 0, a.ingr_mefectivo), 0) AS ingr_mefectivo, " &_
		   "       nvl(decode(a.eing_ccod, 3, 0, a.ingr_mdocto), 0) AS ingr_mdocto, " &_
		   "       nvl(decode(a.eing_ccod, 3, 0, a.ingr_mtotal), 0) AS ingr_mtotal, " &_
		   "       a.ingr_fpago, " &_
		   "       a.eing_ccod, " &_
		   "       max(b.inst_ccod) AS inst_ccod " &_
		   "FROM ingresos a, abonos b, personas c " &_
		   "WHERE a.ingr_ncorr = b.ingr_ncorr AND " &_
		   "      a.pers_ncorr = c.pers_ncorr AND " &_
		   "      a.mcaj_ncorr = " & mcaj_ncorr &_
		   "GROUP BY a.ingr_ncorr, c.pers_nrut || '-' || c.pers_xdv, a.ting_ccod, a.ingr_nfolio_referencia, a.ingr_mefectivo, a.ingr_mdocto, a.ingr_mtotal, a.ingr_fpago, a.eing_ccod " &_
		   "ORDER BY a.ingr_nfolio_referencia " &_
		   ") d " &_
		   "WHERE d.inst_ccod = 2"


f_boletas_ip.consultar consulta



consulta = "SELECT rownum, d.* FROM( " &_
           "SELECT a.ingr_ncorr, c.pers_nrut || '-' || c.pers_xdv AS rut_persona, " &_
		   "       a.ting_ccod, " &_
		   "       a.ingr_nfolio_referencia, " &_
		   "       nvl(decode(a.eing_ccod, 3, 0, a.ingr_mefectivo), 0) AS ingr_mefectivo, " &_
		   "       nvl(decode(a.eing_ccod, 3, 0, a.ingr_mdocto), 0) AS ingr_mdocto, " &_
		   "       nvl(decode(a.eing_ccod, 3, 0, a.ingr_mtotal), 0) AS ingr_mtotal, " &_
		   "       a.ingr_fpago, " &_
		   "       a.eing_ccod, " &_
		   "       max(b.inst_ccod) AS inst_ccod " &_
		   "FROM ingresos a, abonos b, personas c " &_
		   "WHERE a.ingr_ncorr = b.ingr_ncorr AND " &_
		   "      a.pers_ncorr = c.pers_ncorr AND " &_
		   "      a.mcaj_ncorr = " & mcaj_ncorr &_
		   "GROUP BY a.ingr_ncorr, c.pers_nrut || '-' || c.pers_xdv, a.ting_ccod, a.ingr_nfolio_referencia, a.ingr_mefectivo, a.ingr_mdocto, a.ingr_mtotal, a.ingr_fpago, a.eing_ccod " &_
		   "ORDER BY a.ingr_nfolio_referencia " &_
		   ") d " &_
		   "WHERE d.inst_ccod = 1"
		   
f_boletas_cft.Consultar consulta

consulta_capacitacion = "SELECT rownum, d.* FROM( " &_
           "SELECT a.ingr_ncorr, c.pers_nrut || '-' || c.pers_xdv AS rut_persona, " &_
		   "       a.ting_ccod, " &_
		   "       a.ingr_nfolio_referencia, " &_
		   "       nvl(decode(a.eing_ccod, 3, 0, a.ingr_mefectivo), 0) AS ingr_mefectivo, " &_
		   "       nvl(decode(a.eing_ccod, 3, 0, a.ingr_mdocto), 0) AS ingr_mdocto, " &_
		   "       nvl(decode(a.eing_ccod, 3, 0, a.ingr_mtotal), 0) AS ingr_mtotal, " &_
		   "       a.ingr_fpago, " &_
		   "       a.eing_ccod, " &_
		   "       max(b.inst_ccod) AS inst_ccod " &_
		   "FROM ingresos a, abonos b, personas c " &_
		   "WHERE a.ingr_ncorr = b.ingr_ncorr AND " &_
		   "      a.pers_ncorr = c.pers_ncorr AND " &_
		   "      a.mcaj_ncorr = " & mcaj_ncorr &_
		   "GROUP BY a.ingr_ncorr, c.pers_nrut || '-' || c.pers_xdv, a.ting_ccod, a.ingr_nfolio_referencia, a.ingr_mefectivo, a.ingr_mdocto, a.ingr_mtotal, a.ingr_fpago, a.eing_ccod " &_
		   "ORDER BY a.ingr_nfolio_referencia " &_
		   ") d " &_
		   "WHERE d.inst_ccod = 6"

f_boletas_ca.Consultar consulta_capacitacion


consulta = "SELECT '<b>TOTALES</b>' AS t_total, nvl(sum(d.ingr_mefectivo), 0) AS total_mefectivo, nvl(sum(d.ingr_mdocto), 0) AS total_mdocto, nvl(sum(d.ingr_mtotal), 0) AS total_mtotal FROM( "&_
           "SELECT a.ingr_ncorr, c.pers_nrut || '-' || c.pers_xdv AS rut_persona, a.ting_ccod, a.ingr_nfolio_referencia, a.ingr_mefectivo, a.ingr_mdocto, a.ingr_mtotal, a.ingr_fpago, a.eing_ccod, " &_
		   "       max(b.inst_ccod) AS inst_ccod " &_
		   "FROM ingresos a, abonos b, personas c " &_
		   "WHERE a.ingr_ncorr = b.ingr_ncorr AND " &_
		   "      a.pers_ncorr = c.pers_ncorr AND " &_
		   "      a.mcaj_ncorr = " & mcaj_ncorr &_
		   "GROUP BY a.ingr_ncorr, c.pers_nrut || '-' || c.pers_xdv, a.ting_ccod, a.ingr_nfolio_referencia, a.ingr_mefectivo, a.ingr_mdocto, a.ingr_mtotal, a.ingr_fpago, a.eing_ccod " &_
		   ") d " &_
		   "WHERE d.eing_ccod <>3"

set f_total = new CFormulario
f_total.Carga_Parametros "andres.xml", "f_total_boletas"
f_total.Inicializar conn
f_total.Consultar consulta

%>


<html>
<head>
<title>T&iacute;tulo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function volver(boton){
 if(boton = 1){ 
  location.href='inf_cuadre.asp?mcaj_ncorr=<%=mcaj_ncorr%>';
  return;
 }
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr align="center">
    <td>
      <h2><br>
        Detalle de ingresos<br>
    </h2></td>
  </tr>
</table>
<table width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td width="62%">&nbsp;</td>
    <td width="6%"><%botonera.dibujaboton "salir"%>
    </td>
    <td width="6%"><%botonera.dibujaboton "volver"%>
    </td>
    <td width="11%"><%botonera.dibujaboton "imprimir"%>
    </td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right">&nbsp; </td>
  </tr>
  <tr>
    <td width="763" align="right"> Folio: <%=mcaj_ncorr %> </td>
  </tr>
</table>
<hr noshade>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <div align="center">
        <% f_total.dibujaTabla %>
    </div></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><strong><font size="+1">UAS</font></strong></td>
  </tr>
  <tr>
    <td>
      <div align="center">
        <% f_boletas_ip.dibujaTabla %>
    </div></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
</body>
</html>
