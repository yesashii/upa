<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Rendición de Cajas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "rendicion_cajas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede
cajero.AsignarTipoCaja(1002) ' caja para el control interno
if not cajero.TieneCajaAbierta then
	conexion.MensajeError "No tiene ninguna caja abierta para rendir."
	Response.Redirect("../lanzadera/lanzadera.asp")
end if

v_mcaj_ncorr = cajero.ObtenerCajaAbierta

'---------------------------------------------------------------------------------------------------
set f_movimiento_caja = new CFormulario
f_movimiento_caja.Carga_Parametros "rendicion_cajas.xml", "movimiento_caja"
f_movimiento_caja.Inicializar conexion

'consulta = "select obtener_rut(b.pers_ncorr) as rut, obtener_nombre_completo(b.pers_ncorr) as nombre_completo, a.mcaj_ncorr, a.mcaj_ncorr as c_mcaj_ncorr, a.mcaj_finicio, sysdate as fecha_emision, a.mcaj_mrendicion " & vbCrLf &_
'           "from movimientos_cajas a, cajeros b " & vbCrLf &_
'		   "where a.sede_ccod = b.sede_ccod " & vbCrLf &_
'		   "  and a.caje_ccod = b.caje_ccod " & vbCrLf &_
'		   "  and a.mcaj_ncorr = '" & v_mcaj_ncorr & "'"
		   
consulta = "select protic.obtener_rut(b.pers_ncorr) as rut," & vbCrLf &_
			"        protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"        a.mcaj_ncorr, a.mcaj_ncorr as c_mcaj_ncorr," & vbCrLf &_
			"        a.mcaj_finicio, getdate() as fecha_emision, a.mcaj_mrendicion " & vbCrLf &_
			"from movimientos_cajas a, cajeros b " & vbCrLf &_
			"where a.sede_ccod = b.sede_ccod " & vbCrLf &_
			"  and a.caje_ccod = b.caje_ccod " & vbCrLf &_
			"  and a.mcaj_ncorr = '" & v_mcaj_ncorr & "'"

f_movimiento_caja.Consultar consulta


'-------------------------------------------------------------------------------------------
v_inst_ccod = "1"

set f_documentos_caja = new CFormulario
f_documentos_caja.Carga_Parametros "rendicion_cajas.xml", "documentos_caja"
f_documentos_caja.Inicializar conexion

'consulta = "select a.mcaj_ncorr, a.inst_ccod, a.tdoc_ccod, a.tdoc_tdesc, " & vbCrLf &_
'           "       nvl(b.mcaj_mtotal, 0) as mcaj_mtotal, nvl(b.mcaj_mneto, 0) as mcaj_mneto, " & vbCrLf &_
'		   "	   nvl(b.mcaj_mexento, 0) as mcaj_mexento, nvl(b.mcaj_miva, 0) as mcaj_miva, nvl(b.mcaj_ncantidad, 0) as mcaj_ncantidad, " & vbCrLf &_
'		   "	   b.mcaj_desde, b.mcaj_hasta " & vbCrLf &_
'		   "from (select a.mcaj_ncorr, b.inst_ccod, b.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
'		   "      from movimientos_cajas a, " & vbCrLf &_
'		   "	       (select a.inst_ccod, a.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
'		   "		    from documentos_instituciones a, tipos_documentos_mov_cajas b " & vbCrLf &_
'		   "			where a.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
'		   "			  and a.inst_ccod = '" & v_inst_ccod & "') b " & vbCrLf &_
'		   "	  where a.mcaj_ncorr = '" & v_mcaj_ncorr & "') a, detalle_mov_cajas b " & vbCrLf &_
'		   "where a.mcaj_ncorr = b.mcaj_ncorr (+) " & vbCrLf &_
'		   "  and a.inst_ccod = b.inst_ccod (+) " & vbCrLf &_
'		   "  and a.tdoc_ccod = b.tdoc_ccod (+) " & vbCrLf &_
'		   "order by a.tdoc_ccod asc"
		   
consulta = "select a.mcaj_ncorr, a.inst_ccod, a.tdoc_ccod, a.tdoc_tdesc, " & vbCrLf &_
			"      isnull(b.mcaj_mtotal, 0) as mcaj_mtotal, isnull(b.mcaj_mneto, 0) as mcaj_mneto, " & vbCrLf &_
			"	   isnull(b.mcaj_mexento, 0) as mcaj_mexento, isnull(b.mcaj_miva, 0) as mcaj_miva," & vbCrLf &_
			"      isnull(b.mcaj_ncantidad, 0) as mcaj_ncantidad, " & vbCrLf &_
			"	   b.mcaj_desde, b.mcaj_hasta " & vbCrLf &_
			"from (select a.mcaj_ncorr, b.inst_ccod, b.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
			"      from movimientos_cajas a, " & vbCrLf &_
			"	       (select a.inst_ccod, a.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
			"		    from documentos_instituciones a, tipos_documentos_mov_cajas b " & vbCrLf &_
			"			where a.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
			"			  and a.inst_ccod = '" & v_inst_ccod & "') b " & vbCrLf &_
			"	  where a.mcaj_ncorr = '" & v_mcaj_ncorr & "') a, detalle_mov_cajas b " & vbCrLf &_
			"where a.mcaj_ncorr *= b.mcaj_ncorr " & vbCrLf &_
			"  and a.inst_ccod *= b.inst_ccod " & vbCrLf &_
			"  and a.tdoc_ccod *= b.tdoc_ccod 	" & vbCrLf &_
			"order by a.tdoc_ccod asc "
'response.Write("<pre>"&consulta&"</pre>")
'response.End()

f_documentos_caja.Consultar consulta


'--------------------------------------------------------------------------------------------------
set f_suma = new CFormulario
f_suma.Carga_Parametros "rendicion_cajas.xml", "suma"
f_suma.Inicializar conexion
f_suma.Consultar "select 0 as total"
f_suma.Siguiente
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.suma {
background-color:#D8D8DE;
border:0;
text-align:center;
font-weight:bolder;
font-size:12px;
}
</style>


<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

var t_suma, t_alt_suma;
var t_rendicion;

function mcaj_mtotal_blur(p_objeto)
{
	t_suma.AsignarValor(0, "total", t_rendicion.SumarColumna("mcaj_mtotal"));
	t_alt_suma.filas[0].campos["total"].objeto.focus();
	t_alt_suma.filas[0].campos["total"].objeto.blur();
}

function InicioPagina()
{
	t_rendicion = new CTabla("detalle_mov_cajas");
	t_suma = new CTabla("suma");
	t_alt_suma = new CTabla("_suma");
	
	t_alt_suma.filas[0].campos["total"].objeto.className = 'suma';
	
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Rendición de Cajas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center">
                        <%f_movimiento_caja.DibujaRegistro%>
                    </div></td>
                  </tr>
                </table>
                <br>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Detalle de documentos"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_documentos_caja.DibujaTabla%></div></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="80%"><div align="right"><strong>TOTAL : </strong></div></td>
                          <td width="20%"><div align="center"><%f_suma.DibujaCampo("total")%>
                          </div></td>
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
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("guardar")%>
                  </div></td>
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
