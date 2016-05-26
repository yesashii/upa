<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: MODULO CAJAS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:12/02/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:167,168,169
'********************************************************************
q_ting_ccod = Request.QueryString("ting_ccod")
q_ding_ndocto = Request.QueryString("ding_ndocto")
q_banc_ccod = Request.QueryString("banc_ccod")
q_ding_tcuenta_corriente = Request.QueryString("ding_tcuenta_corriente")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Detalle de abonos del cheque"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "pago_cheques.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "pago_cheques.xml", "encabezado_cheque"
f_encabezado.Inicializar conexion

'consulta = "select a.ting_ccod, a.ding_ndocto, a.banc_ccod, a.ding_tcuenta_corriente, " & vbCrLf &_
'           "       min(b.ingr_fpago) as fecha_emision, max(a.ding_fdocto) as ding_fdocto, " & vbCrLf &_
'		   "	   sum(c.abon_mabono) as valor_cheque " & vbCrLf &_
'		   "from detalle_ingresos a, ingresos b, abonos c, detalle_compromisos d, compromisos e " & vbCrLf &_
'		   "where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
'		   "  and a.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
'		   "  and c.tcom_ccod = d.tcom_ccod " & vbCrLf &_
'		   "  and c.inst_ccod = d.inst_ccod " & vbCrLf &_
'		   "  and c.comp_ndocto = d.comp_ndocto " & vbCrLf &_
'		   "  and c.dcom_ncompromiso = d.dcom_ncompromiso " & vbCrLf &_
'		   "  and d.tcom_ccod = e.tcom_ccod " & vbCrLf &_
'		   "  and d.inst_ccod = e.inst_ccod " & vbCrLf &_
'		   "  and d.comp_ndocto = e.comp_ndocto " & vbCrLf &_
'		   "  and b.eing_ccod <> 3 " & vbCrLf &_
'		   "  and a.ting_ccod = 3 " & vbCrLf &_
'		   "  and a.edin_ccod not in (51, 6, 12, 9, 11) " & vbCrLf &_
'		   "  and nvl(a.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
'		   "  and a.ding_ncorrelativo > 0 " & vbCrLf &_
'		   "  and a.ting_ccod = '" & q_ting_ccod & "' " & vbCrLf &_
'		   "  and a.ding_ndocto = '" & q_ding_ndocto & "' " & vbCrLf &_
'		   "  and a.banc_ccod = '" & q_banc_ccod & "' " & vbCrLf &_
'		   "  and a.ding_tcuenta_corriente = nvl('" & q_ding_tcuenta_corriente & "', ' ') " & vbCrLf &_
'		   "group by a.ting_ccod, a.ding_ndocto, a.banc_ccod, a.ding_tcuenta_corriente"
		   
consulta = "select a.ting_ccod, a.ding_ndocto, a.banc_ccod, a.ding_tcuenta_corriente, " & vbCrLf &_
			"       min(b.ingr_fpago) as fecha_emision, max(a.ding_fdocto) as ding_fdocto, " & vbCrLf &_
			"	   sum(c.abon_mabono) as valor_cheque " & vbCrLf &_
			"from detalle_ingresos a, ingresos b, abonos c, detalle_compromisos d, compromisos e " & vbCrLf &_
			"where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
			"  and a.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
			"  and c.tcom_ccod = d.tcom_ccod " & vbCrLf &_
			"  and c.inst_ccod = d.inst_ccod " & vbCrLf &_
			"  and c.comp_ndocto = d.comp_ndocto " & vbCrLf &_
			"  and c.dcom_ncompromiso = d.dcom_ncompromiso " & vbCrLf &_
			"  and d.tcom_ccod = e.tcom_ccod " & vbCrLf &_
			"  and d.inst_ccod = e.inst_ccod " & vbCrLf &_
			"  and d.comp_ndocto = e.comp_ndocto " & vbCrLf &_
			"  and b.eing_ccod <> 3 " & vbCrLf &_
			"  and a.ting_ccod = 3 " & vbCrLf &_
			"  and a.edin_ccod not in (51, 6, 12, 9, 11) " & vbCrLf &_
			"  and isnull(a.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
			"  and a.ding_ncorrelativo > 0 		" & vbCrLf &_
			"  and a.ting_ccod = '" & q_ting_ccod & "' " & vbCrLf &_
			"  and a.ding_ndocto = '" & q_ding_ndocto & "' " & vbCrLf &_
			"  and a.banc_ccod = '" & q_banc_ccod & "' " & vbCrLf &_
			"  and a.ding_tcuenta_corriente = isnull('" & q_ding_tcuenta_corriente & "', ' ') " & vbCrLf &_
			"group by a.ting_ccod, a.ding_ndocto, a.banc_ccod, a.ding_tcuenta_corriente	"

f_encabezado.Consultar consulta

'---------------------------------------------------------------------------------------------------
set f_detalle_abonos = new CFormulario
f_detalle_abonos.Carga_Parametros "pago_cheques.xml", "detalle_abonos_cheque"
f_detalle_abonos.Inicializar conexion

'consulta = "select b.ting_ccod, b.ingr_nfolio_referencia, b.ingr_fpago, c.abon_mabono, d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, d.dcom_mcompromiso, " & vbCrLf &_
'           "       obtener_rut(e.pers_ncorr) as rut, obtener_nombre_completo(e.pers_ncorr) as nombre, f.ting_ccod as ting_ccod_documento, f.ding_ndocto  " & vbCrLf &_
'		   "from detalle_ingresos a, ingresos b, abonos c, detalle_compromisos d, compromisos e, detalle_ingresos f " & vbCrLf &_
'		   "where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
'		   "  and a.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
'		   "  and c.tcom_ccod = d.tcom_ccod " & vbCrLf &_
'		   "  and c.inst_ccod = d.inst_ccod " & vbCrLf &_
'		   "  and c.comp_ndocto = d.comp_ndocto " & vbCrLf &_
'		   "  and c.dcom_ncompromiso = d.dcom_ncompromiso " & vbCrLf &_
'		   "  and d.tcom_ccod = e.tcom_ccod " & vbCrLf &_
'		   "  and d.inst_ccod = e.inst_ccod " & vbCrLf &_
'		   "  and d.comp_ndocto = e.comp_ndocto " & vbCrLf &_
'		   "  and documento_asociado_cuota(d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, 'ting_ccod') = f.ting_ccod (+) " & vbCrLf &_
'		   "  and documento_asociado_cuota(d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, 'ingr_ncorr') = f.ingr_ncorr (+) " & vbCrLf &_
'		   "  and documento_asociado_cuota(d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, 'ding_ndocto') = f.ding_ndocto (+) " & vbCrLf &_
'		   "  and b.eing_ccod <> 3 " & vbCrLf &_
'		   "  and a.ting_ccod = 3 " & vbCrLf &_
'		   "  and a.edin_ccod not in (51, 6, 12, 9, 11) " & vbCrLf &_
'		   "  and nvl(a.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
'		   "  and a.ding_ncorrelativo > 0 " & vbCrLf &_
'		   "  and a.ting_ccod = '" & q_ting_ccod & "' " & vbCrLf &_
'		   "  and a.ding_ndocto = '" & q_ding_ndocto & "' " & vbCrLf &_
'		   "  and a.banc_ccod = '" & q_banc_ccod & "' " & vbCrLf &_
'		   "  and a.ding_tcuenta_corriente = nvl('" & q_ding_tcuenta_corriente & "', ' ') " & vbCrLf &_
'		   "order by b.ingr_fpago asc, b.ingr_nfolio_referencia asc"
		   
'consulta = "select b.ting_ccod, b.ingr_nfolio_referencia, b.ingr_fpago, c.abon_mabono,e.pers_ncorr," & vbCrLf &_
'			"        d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, d.dcom_mcompromiso, " & vbCrLf &_
'			"        protic.obtener_rut(e.pers_ncorr) as rut, protic.obtener_nombre_completo(e.pers_ncorr,'n') as nombre," & vbCrLf &_
'			"        f.ting_ccod as ting_ccod_documento, f.ding_ndocto" & vbCrLf &_
'			"  from detalle_ingresos a,ingresos b,abonos c,detalle_compromisos d,compromisos e, detalle_ingresos f " & vbCrLf &_
'			"  where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
'			"    and b.ingr_ncorr = c.ingr_ncorr" & vbCrLf &_
'			"    and c.tcom_ccod = d.tcom_ccod" & vbCrLf &_
'			"    and c.inst_ccod = d.inst_ccod" & vbCrLf &_
'			"    and c.comp_ndocto = d.comp_ndocto" & vbCrLf &_
'			"    and c.dcom_ncompromiso = d.dcom_ncompromiso" & vbCrLf &_
'			"    and d.tcom_ccod = e.tcom_ccod" & vbCrLf &_
'			"    and d.inst_ccod = e.inst_ccod" & vbCrLf &_
'			"    and d.comp_ndocto = e.comp_ndocto" & vbCrLf &_
'			"    and protic.documento_asociado_cuota(d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, 'ting_ccod') *= f.ting_ccod " & vbCrLf &_
'			"    and protic.documento_asociado_cuota(d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, 'ingr_ncorr') *= f.ingr_ncorr" & vbCrLf &_
'			"    and protic.documento_asociado_cuota(d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, 'ding_ndocto') *= f.ding_ndocto" & vbCrLf &_
'			"    and b.eing_ccod <> 3 " & vbCrLf &_
'			"    and a.ting_ccod = 3 " & vbCrLf &_
'			"    and a.edin_ccod not in (51, 6, 12, 9, 11) " & vbCrLf &_
'			"    and isnull(a.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
'			"    and a.ding_ncorrelativo > 0 " & vbCrLf &_
'			"    and a.ting_ccod = '" & q_ting_ccod & "' " & vbCrLf &_
'			"    and a.ding_ndocto = '" & q_ding_ndocto & "' " & vbCrLf &_
'			"    and a.banc_ccod = '" & q_banc_ccod & "' " & vbCrLf &_
'			"    and a.ding_tcuenta_corriente = isnull('" & q_ding_tcuenta_corriente & "', ' ') " & vbCrLf &_			
'			"    order by b.ingr_fpago asc, b.ingr_nfolio_referencia asc"

consulta = "select b.ting_ccod, b.ingr_nfolio_referencia, b.ingr_fpago, c.abon_mabono,e.pers_ncorr," & vbCrLf &_
			"        d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, d.dcom_mcompromiso, " & vbCrLf &_
			"        protic.obtener_rut(e.pers_ncorr) as rut, protic.obtener_nombre_completo(e.pers_ncorr,'n') as nombre," & vbCrLf &_
			"        f.ting_ccod as ting_ccod_documento, f.ding_ndocto" & vbCrLf &_
			"  from detalle_ingresos a INNER JOIN ingresos b " & vbCrLf &_
			"	ON a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
			"	INNER JOIN abonos c " & vbCrLf &_
			"    ON b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
			"    INNER JOIN detalle_compromisos d " & vbCrLf &_
			"    ON c.tcom_ccod = d.tcom_ccod and c.inst_ccod = d.inst_ccod and c.comp_ndocto = d.comp_ndocto and c.dcom_ncompromiso = d.dcom_ncompromiso " & vbCrLf &_
			"    INNER JOIN compromisos e " & vbCrLf &_
			"    ON d.tcom_ccod = e.tcom_ccod and d.inst_ccod = e.inst_ccod and d.comp_ndocto = e.comp_ndocto " & vbCrLf &_
			"    LEFT OUTER JOIN detalle_ingresos f " & vbCrLf &_
			"    ON protic.documento_asociado_cuota(d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, 'ting_ccod') = f.ting_ccod " & vbCrLf &_
			"    and protic.documento_asociado_cuota(d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, 'ingr_ncorr') = f.ingr_ncorr " & vbCrLf &_
			"    and protic.documento_asociado_cuota(d.tcom_ccod, d.inst_ccod, d.comp_ndocto, d.dcom_ncompromiso, 'ding_ndocto') = f.ding_ndocto " & vbCrLf &_
			"    WHERE b.eing_ccod <> 3 " & vbCrLf &_
			"    and a.ting_ccod = 3 " & vbCrLf &_
			"    and a.edin_ccod not in (51, 6, 12, 9, 11) " & vbCrLf &_
			"    and isnull(a.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
			"    and a.ding_ncorrelativo > 0 " & vbCrLf &_
			"    and a.ting_ccod = '" & q_ting_ccod & "' " & vbCrLf &_
			"    and a.ding_ndocto = '" & q_ding_ndocto & "' " & vbCrLf &_
			"    and a.banc_ccod = '" & q_banc_ccod & "' " & vbCrLf &_
			"    and a.ding_tcuenta_corriente = isnull('" & q_ding_tcuenta_corriente & "', ' ') " & vbCrLf &_			
			"    order by b.ingr_fpago asc, b.ingr_nfolio_referencia asc"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_detalle_abonos.Consultar consulta
'Response.Write("<pre>" & consulta & "</pre>")

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
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetas Array("Cheque"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br><%f_encabezado.DibujaRegistro%>
              </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Pagos del cheque"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_detalle_abonos.DibujaTabla%></div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
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
