<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "parametros.xml", "btn_inf_cheques"

' set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario
set totales = new cformulario

conectar.inicializar "desauas"
formulario.carga_parametros "parametros.xml", "cheques"
formulario.inicializar conectar
totales.carga_parametros "parametros.xml", "total_cheques"
totales.inicializar conectar

mcaj_ncorr = request.QueryString("mcaj_ncorr")

cheques_cons = "select rownum as fila, a.* from " & _
		"( SELECT a.ingr_ncorr, a.rut, a.inst_ccod, a.ingr_nfolio_referencia, a.ting_ccod " & _
		"     , case when a.inst_ccod=6 and a.ingr_fpago>=b.ding_fdocto then ding_mdetalle else 0 end as chd_ca " & _
		"     , case when a.inst_ccod=6 and a.ingr_fpago<b.ding_fdocto then ding_mdetalle else 0 end as chf_ca " & _
		"     , case when a.inst_ccod=1 and a.ingr_fpago>=b.ding_fdocto then ding_mdetalle else 0 end as chd_cft " & _
		"     , case when a.inst_ccod=1 and a.ingr_fpago<b.ding_fdocto then ding_mdetalle else 0 end as chf_cft " & _
		"     , case when a.inst_ccod=2 and a.ingr_fpago>=b.ding_fdocto then ding_mdetalle else 0 end chd_ip " & _
		"     , case when a.inst_ccod=2 and a.ingr_fpago<b.ding_fdocto then ding_mdetalle else 0 end chf_ip " & _
		"     , b.ding_fdocto " & _
		"     , b.banc_ccod, b.plaz_ccod, b.ding_tcuenta_corriente, b.ding_ndocto " &_
		"  FROM (SELECT d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod, MAX (e.pers_nrut) || '-' || max(e.pers_xdv) AS rut, " & _
		"               MAX (c.inst_ccod) AS inst_ccod " & _
		"          FROM abonos a, detalle_compromisos b, compromisos c, ingresos d, personas e " & _
		"         WHERE a.tcom_ccod = b.tcom_ccod " & _
		"           AND a.inst_ccod = b.inst_ccod " & _
		"           AND a.comp_ndocto = b.comp_ndocto " & _
		"           AND a.dcom_ncompromiso = b.dcom_ncompromiso " & _
		"           AND b.tcom_ccod = c.tcom_ccod " & _
		"           AND b.inst_ccod = c.inst_ccod " & _
		"           AND b.comp_ndocto = c.comp_ndocto " & _
		"           AND a.ingr_ncorr = d.ingr_ncorr " & _
		"           and c.pers_ncorr = e.pers_ncorr " & _
		"           and d.eing_ccod=1 " &_ 
		"           AND d.mcaj_ncorr = " & mcaj_ncorr  & _
		"         GROUP BY d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod) a, " & _
		"       detalle_ingresos b " & _
		" WHERE a.ingr_ncorr = b.ingr_ncorr " & _
		"    AND b.ting_ccod = 6" & _
		" ORDER BY a.inst_ccod, ingr_ncorr, ding_fdocto ) a "

formulario.consultar cheques_cons
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
  location.href='inf_cuadre.asp?mcaj_ncorr=<%=mcaj_ncorr%>' ;  
  return;
 }
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
    <td bgcolor="#D8D8DE"> &nbsp;
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr align="center">
            <td>
              <h2>Detalle de cheques<br>
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
            <td><h2 align="center">
                <% formulario.dibujaTabla %>
            </h2></td>
          </tr>
        </table>
        <br>
        <br>
    </td>
    <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
  </tr>
</table>
</body>
</html>
