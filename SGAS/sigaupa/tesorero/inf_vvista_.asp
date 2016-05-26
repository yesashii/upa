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
function volver(boton){
 if(boton = 1){ 
  location.href='inf_cuadre.asp?mcaj_ncorr=<%=mcaj_ncorr%>' ;  
  return;
 }
}
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="836" border="0" cellpadding="0" cellspacing="0">
  <tr>
  </tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="109%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Resultados de la b&uacute;squeda</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;			<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr align="center"> 
    <td> <h2>Detalle Otros Documentos<br>
      </h2></td>
  </tr>
</table>
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
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right">&nbsp;    </td>
  </tr>
  <tr> 
    <td width="763" align="right"> Folio: <%=mcaj_ncorr %> </td>
  </tr>
</table>
<hr noshade>
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
    <td align="center"><div align="center"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">DETALLE 
        MANDATO TRANSBANK</font></strong></div></td>
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
    <td align="center"><div align="center"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">DETALLE 
        ABONO SALDO INSOLUTO</font></strong></div></td>
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
    <td align="center"><div align="center"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">DETALLE 
        ABONO OTROS DOCUMENTOS</font></strong></div></td>
  </tr>
  <tr> 
    <td><h2 align="center"> 
        <% otros_doctos.dibujaTabla %>
      </h2></td>
  </tr>
</table>
<br>


				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="78" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"></div></td>
                      <td><div align="center"></div></td>
                      <td><div align="center">
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="362" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="386" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
