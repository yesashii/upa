<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "vvista.xml", "btn_inf_vvista"

' set negocio = new cNegocio
set conectar	= new cconexion
set vale_vista	= new cformulario
set ncredito	= new cformulario
set	mtransbank	= new cformulario
set	s_insoluto	= new cformulario
set	otros_doctos= new cformulario

conectar.inicializar "desauas"
vale_vista.carga_parametros "vvista.xml", "vvista"
vale_vista.inicializar conectar

ncredito.carga_parametros "ncredito.xml", "ncredito"
ncredito.inicializar conectar

mtransbank.carga_parametros "mtransbank.xml", "mtransbank"
mtransbank.inicializar conectar

s_insoluto.carga_parametros "s_insoluto.xml", "s_insoluto"
s_insoluto.inicializar conectar

otros_doctos.carga_parametros "otros_doctos.xml", "otros_doctos"
otros_doctos.inicializar conectar


mcaj_ncorr = request.QueryString("mcaj_ncorr")

vvista_cons = "select rownum as fila, a.* from  " & _
	"	( SELECT a.ingr_ncorr, a.rut, a.inst_ccod, a.ingr_nfolio_referencia, a.ting_ccod,to_number(b.ding_mdetalle) as ding_mdetalle,b.ting_ccod as tipo " & _
" , b.ding_ndocto   " & _
	"	  FROM (SELECT d.ingr_mdocto,d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod, MAX (e.pers_nrut) || '-' || max(e.pers_xdv) AS rut,  " & _
	"	               MAX (c.inst_ccod) AS inst_ccod  " & _
	"	          FROM abonos a, detalle_compromisos b, compromisos c, ingresos d, personas e  " & _
	"	         WHERE a.tcom_ccod = b.tcom_ccod  " & _
	"	           AND a.inst_ccod = b.inst_ccod  " & _
	"	           AND a.comp_ndocto = b.comp_ndocto  " & _
	"	           AND a.dcom_ncompromiso = b.dcom_ncompromiso  " & _
	"	           AND b.tcom_ccod = c.tcom_ccod  " & _
	"	           AND b.inst_ccod = c.inst_ccod  " & _
	"	           AND b.comp_ndocto = c.comp_ndocto  " & _
	"	           AND a.ingr_ncorr = d.ingr_ncorr  " & _
	"	           and c.pers_ncorr = e.pers_ncorr  " & _
	"	           and d.eing_ccod=1  " & _
	"	           AND d.mcaj_ncorr =  '"&mcaj_ncorr&"' " & _
	"	         GROUP BY d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod,d.ingr_mdocto) a,  " & _
"		       detalle_ingresos b  " & _
"		 WHERE a.ingr_ncorr = b.ingr_ncorr  " & _
"		    AND b.ting_ccod = 17 " & _
"		 ORDER BY a.inst_ccod, ingr_ncorr, ding_fdocto ) a "

vale_vista.consultar vvista_cons


ncredito_cons = "select rownum as fila, a.* from  " & _
	"	( SELECT a.ingr_ncorr, a.rut, a.inst_ccod, a.ingr_nfolio_referencia, a.ting_ccod,to_number(b.ding_mdetalle) as ding_mdetalle,b.ting_ccod as tipo  " & _
" , b.ding_ndocto   " & _
	"	  FROM (SELECT d.ingr_mdocto,d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod, MAX (e.pers_nrut) || '-' || max(e.pers_xdv) AS rut,  " & _
	"	               MAX (c.inst_ccod) AS inst_ccod  " & _
	"	          FROM abonos a, detalle_compromisos b, compromisos c, ingresos d, personas e  " & _
	"	         WHERE a.tcom_ccod = b.tcom_ccod  " & _
	"	           AND a.inst_ccod = b.inst_ccod  " & _
	"	           AND a.comp_ndocto = b.comp_ndocto  " & _
	"	           AND a.dcom_ncompromiso = b.dcom_ncompromiso  " & _
	"	           AND b.tcom_ccod = c.tcom_ccod  " & _
	"	           AND b.inst_ccod = c.inst_ccod  " & _
	"	           AND b.comp_ndocto = c.comp_ndocto  " & _
	"	           AND a.ingr_ncorr = d.ingr_ncorr  " & _
	"	           and c.pers_ncorr = e.pers_ncorr  " & _
	"	           and d.eing_ccod=1  " & _
	"	           AND d.mcaj_ncorr =  '"&mcaj_ncorr&"' " & _
	"	         GROUP BY d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod,d.ingr_mdocto) a,  " & _
"		       detalle_ingresos b  " & _
"		 WHERE a.ingr_ncorr = b.ingr_ncorr  " & _
"		    AND b.ting_ccod = 52 " & _
"		 ORDER BY a.inst_ccod, ingr_ncorr, ding_fdocto ) a "

ncredito.consultar ncredito_cons

mtransbank_cons = "select rownum as fila, a.* from  " & _
	"	( SELECT a.ingr_ncorr, a.rut, a.inst_ccod, a.ingr_nfolio_referencia, a.ting_ccod,to_number(b.ding_mdetalle) as ding_mdetalle,b.ting_ccod as tipo  " & _
" , b.ding_ndocto   " & _
	"	  FROM (SELECT d.ingr_mdocto,d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod, MAX (e.pers_nrut) || '-' || max(e.pers_xdv) AS rut,  " & _
	"	               MAX (c.inst_ccod) AS inst_ccod  " & _
	"	          FROM abonos a, detalle_compromisos b, compromisos c, ingresos d, personas e  " & _
	"	         WHERE a.tcom_ccod = b.tcom_ccod  " & _
	"	           AND a.inst_ccod = b.inst_ccod  " & _
	"	           AND a.comp_ndocto = b.comp_ndocto  " & _
	"	           AND a.dcom_ncompromiso = b.dcom_ncompromiso  " & _
	"	           AND b.tcom_ccod = c.tcom_ccod  " & _
	"	           AND b.inst_ccod = c.inst_ccod  " & _
	"	           AND b.comp_ndocto = c.comp_ndocto  " & _
	"	           AND a.ingr_ncorr = d.ingr_ncorr  " & _
	"	           and c.pers_ncorr = e.pers_ncorr  " & _
	"	           and d.eing_ccod=1  " & _
	"	           AND d.mcaj_ncorr =  '"&mcaj_ncorr&"' " & _
	"	         GROUP BY d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod,d.ingr_mdocto) a,  " & _
"		       detalle_ingresos b  " & _
"		 WHERE a.ingr_ncorr = b.ingr_ncorr  " & _
"		    AND b.ting_ccod = 72 " & _
"		 ORDER BY a.inst_ccod, ingr_ncorr, ding_fdocto ) a "

mtransbank.consultar mtransbank_cons

s_insoluto_cons = "select rownum as fila, a.* from  " & _
	"	( SELECT a.ingr_ncorr, a.rut, a.inst_ccod, a.ingr_nfolio_referencia, a.ting_ccod,to_number(b.ding_mdetalle) as ding_mdetalle,b.ting_ccod as tipo  " & _
" , b.ding_ndocto   " & _
	"	  FROM (SELECT d.ingr_mdocto,d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod, MAX (e.pers_nrut) || '-' || max(e.pers_xdv) AS rut,  " & _
	"	               MAX (c.inst_ccod) AS inst_ccod  " & _
	"	          FROM abonos a, detalle_compromisos b, compromisos c, ingresos d, personas e  " & _
	"	         WHERE a.tcom_ccod = b.tcom_ccod  " & _
	"	           AND a.inst_ccod = b.inst_ccod  " & _
	"	           AND a.comp_ndocto = b.comp_ndocto  " & _
	"	           AND a.dcom_ncompromiso = b.dcom_ncompromiso  " & _
	"	           AND b.tcom_ccod = c.tcom_ccod  " & _
	"	           AND b.inst_ccod = c.inst_ccod  " & _
	"	           AND b.comp_ndocto = c.comp_ndocto  " & _
	"	           AND a.ingr_ncorr = d.ingr_ncorr  " & _
	"	           and c.pers_ncorr = e.pers_ncorr  " & _
	"	           and d.eing_ccod=1  " & _
	"	           AND d.mcaj_ncorr =  '"&mcaj_ncorr&"' " & _
	"	         GROUP BY d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod,d.ingr_mdocto) a,  " & _
"		       detalle_ingresos b  " & _
"		 WHERE a.ingr_ncorr = b.ingr_ncorr  " & _
"		    AND b.ting_ccod = 73 " & _
"		 ORDER BY a.inst_ccod, ingr_ncorr, ding_fdocto ) a "

s_insoluto.consultar	s_insoluto_cons

otros_doctos_cons = "select rownum as fila, a.* from  " & _
	"	( SELECT a.ingr_ncorr, a.rut, a.inst_ccod, a.ingr_nfolio_referencia, a.ting_ccod,to_number(b.ding_mdetalle) as ding_mdetalle,b.ting_ccod as tipo  " & _
" , b.ding_ndocto   " & _
	"	  FROM (SELECT d.ingr_mdocto,d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod, MAX (e.pers_nrut) || '-' || max(e.pers_xdv) AS rut,  " & _
	"	               MAX (c.inst_ccod) AS inst_ccod  " & _
	"	          FROM abonos a, detalle_compromisos b, compromisos c, ingresos d, personas e  " & _
	"	         WHERE a.tcom_ccod = b.tcom_ccod  " & _
	"	           AND a.inst_ccod = b.inst_ccod  " & _
	"	           AND a.comp_ndocto = b.comp_ndocto  " & _
	"	           AND a.dcom_ncompromiso = b.dcom_ncompromiso  " & _
	"	           AND b.tcom_ccod = c.tcom_ccod  " & _
	"	           AND b.inst_ccod = c.inst_ccod  " & _
	"	           AND b.comp_ndocto = c.comp_ndocto  " & _
	"	           AND a.ingr_ncorr = d.ingr_ncorr  " & _
	"	           and c.pers_ncorr = e.pers_ncorr  " & _
	"	           and d.eing_ccod=1  " & _
	"	           AND d.mcaj_ncorr =  '"&mcaj_ncorr&"' " & _
	"	         GROUP BY d.ingr_ncorr, d.ingr_fpago, d.ingr_nfolio_referencia, d.ting_ccod,d.ingr_mdocto) a,  " & _
"		       detalle_ingresos b  " & _
"		 WHERE a.ingr_ncorr = b.ingr_ncorr  " & _
"		    AND b.ting_ccod in (74,76,84) " & _
"		 ORDER BY a.inst_ccod, ingr_ncorr, ding_fdocto ) a "

otros_doctos.consultar	otros_doctos_cons


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
</script>

<style type="text/css">
<!--
.style1 {
	font-size: 18px;
	font-weight: bold;
}
-->
</style>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<div align="center">
  <h2>
    <br>
    Detalle Otros Documentos<br>
  </h2>
</div>
<table width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td width="31%">&nbsp;</td>
    <td width="44%"><%botonera.dibujaboton "salir"%>
    </td>
    <td width="10%"><%botonera.dibujaboton "volver"%>
    </td>
    <td width="15%"><%botonera.dibujaboton "imprimir"%>
    </td>
  </tr>
</table>
<br>
<br>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center"><div align="center"><strong>DETALLE VALE VISTA</strong></div></td>
  </tr>
  <tr>
    <td><h2 align="center">
        <% vale_vista.dibujaTabla %>
    </h2></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td><hr noshade></td>
  </tr>
  <tr>
    <td align="center"><div align="center"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">DETALLE MANDATO TRANSBANK</font></strong></div></td>
  </tr>
  <tr>
    <td><h2 align="center">
        <% mtransbank.dibujaTabla %>
    </h2></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><hr noshade></td>
  </tr>
  <tr>
    <td align="center"><div align="center"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">DETALLE ABONO SALDO INSOLUTO</font></strong></div></td>
  </tr>
  <tr>
    <td><h2 align="center">
        <% s_insoluto.dibujaTabla %>
    </h2></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><hr noshade></td>
  </tr>
  <tr>
    <td align="center"><div align="center"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">DETALLE ABONO OTROS DOCUMENTOS</font></strong></div></td>
  </tr>
  <tr>
    <td><h2 align="center">
        <% otros_doctos.dibujaTabla %>
    </h2></td>
  </tr>
</table>
</body>
</html>
