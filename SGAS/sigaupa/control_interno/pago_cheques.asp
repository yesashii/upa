<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_ding_ndocto = Request.QueryString("b[0][ding_ndocto]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Pago de cheques"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

if not cajero.TieneCajaAbierta then
	conexion.MensajeError "No puede recibir pagos si no tiene una caja abierta."
	Response.Redirect("../lanzadera/lanzadera.asp")
end if


'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "pago_cheques.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "pago_cheques.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "ding_ndocto", q_ding_ndocto

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "pago_cheques.xml", "cheques"
f_cheques.Inicializar conexion

'consulta = "select a.ting_ccod as c_ting_ccod, a.ding_ndocto as c_ding_ndocto, a.banc_ccod as c_banc_ccod, a.ding_tcuenta_corriente as c_ding_tcuenta_corriente, a.ting_ccod, a.ding_ndocto, a.banc_ccod, a.ding_tcuenta_corriente, a.ding_mdocto, a.edin_ccod, a.ding_bpacta_cuota, " & vbCrLf &_
'           "       sum(c.abon_mabono) as total " & vbCrLf &_
'		   "from detalle_ingresos a, ingresos b, abonos c, detalle_compromisos d " & vbCrLf &_
'		   "where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
'		   "  and a.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
'		   "  and c.tcom_ccod = d.tcom_ccod " & vbCrLf &_
'		   "  and c.inst_ccod = d.inst_ccod " & vbCrLf &_
'		   "  and c.comp_ndocto = d.comp_ndocto " & vbCrLf &_
'		   "  and c.dcom_ncompromiso = d.dcom_ncompromiso " & vbCrLf &_
'		   "  and b.eing_ccod <> 3 " & vbCrLf &_
'		   "  and a.ting_ccod = 3 " & vbCrLf &_
'		   "  and a.edin_ccod not in (51, 6, 12, 9, 11) " & vbCrLf &_
'		   "  and nvl(a.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
'		   "  and a.ding_ncorrelativo > 0 " & vbCrLf &_
'		   "  and a.ding_ndocto = '" & q_ding_ndocto & "' " & vbCrLf &_
'		   "group by a.ting_ccod, a.ding_ndocto, a.banc_ccod, a.ding_tcuenta_corriente, a.ding_mdocto, a.edin_ccod, a.ding_bpacta_cuota " & vbCrLf &_
'		   "having a.ding_mdocto = sum(c.abon_mabono) " & vbCrLf &_
'		   "order by a.ding_ndocto asc"
		   
consulta = "select a.ting_ccod as c_ting_ccod, a.ding_ndocto as c_ding_ndocto," & vbCrLf &_
			"        a.banc_ccod as c_banc_ccod, a.ding_tcuenta_corriente as c_ding_tcuenta_corriente," & vbCrLf &_
			"        a.ting_ccod, a.ding_ndocto, a.banc_ccod, a.ding_tcuenta_corriente," & vbCrLf &_
			"        a.ding_mdocto, a.edin_ccod, a.ding_bpacta_cuota, " & vbCrLf &_
			"        sum(c.abon_mabono) as total" & vbCrLf &_
			"from detalle_ingresos a,ingresos b,abonos c,detalle_compromisos d" & vbCrLf &_
			"where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
			"    and a.ingr_ncorr = c.ingr_ncorr" & vbCrLf &_
			"    and c.tcom_ccod = d.tcom_ccod" & vbCrLf &_
			"    and c.inst_ccod = d.inst_ccod" & vbCrLf &_
			"    and c.comp_ndocto = d.comp_ndocto" & vbCrLf &_
			"    and c.dcom_ncompromiso = d.dcom_ncompromiso" & vbCrLf &_
			"    and b.eing_ccod <> 3 " & vbCrLf &_
			"    and a.ting_ccod = 3" & vbCrLf &_
			"    and isnull(a.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
			"    and a.edin_ccod not in (51, 6, 12, 9, 11) " & vbCrLf &_
			"    and a.ding_ncorrelativo > 0 " & vbCrLf &_
			"    and cast(a.ding_ndocto as varchar) = '" & q_ding_ndocto & "' " & vbCrLf &_
			"    group by a.ting_ccod, a.ding_ndocto, a.banc_ccod, a.ding_tcuenta_corriente, a.ding_mdocto, a.edin_ccod, a.ding_bpacta_cuota " & vbCrLf &_
			"    having a.ding_mdocto = sum(c.abon_mabono) " & vbCrLf &_
			"    order by a.ding_ndocto asc"		   
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_cheques.Consultar consulta

if f_cheques.NroFilas = 0 then
	f_botonera.AgregaBotonParam "ok", "deshabilitado", "TRUE"
end if
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center"><%f_busqueda.DibujaRegistro%></div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
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
                    <td><%pagina.DibujarSubtitulo "Cheques"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_cheques.DibujaTabla%></div></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p>- Para ver el detalle de pagos del cheque haga clic sobre &eacute;l.<br>
                            <br>
                            - Para transformar el valor del cheque en un cargo que pueda ser recepcionado en caja, selecci&oacute;nelo y presione el bot&oacute;n &quot;Guardar&quot;. Una vez hecho esto, aparecer&aacute; un cargo en la cuenta corriente del alumno(s) por el valor correspondiente. <br>
                            </p>
                            </td>
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
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("ok")%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
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
	</td>
  </tr>  
</table>
</body>
</html>
