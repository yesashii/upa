<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_tcom_ccod = Request.QueryString("tcom_ccod")
q_inst_ccod = Request.QueryString("inst_ccod")
q_comp_ndocto = Request.QueryString("comp_ndocto")
q_dcom_ncompromiso = Request.QueryString("dcom_ncompromiso")

'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Detalle de abonos"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "detalle_abonos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_cuota = new CFormulario
f_cuota.Carga_Parametros "detalle_abonos.xml", "cuota"
f_cuota.Inicializar conexion


'------------ agregado para mostrar referencia de la multa o interes ----------------------
'if q_tcom_ccod = "5"  or q_tcom_ccod = "6" then
'  numero = conexion.consultaUno("select ding_ndocto from referencias_cargos where reca_ncorr='" & q_comp_ndocto & "'")
'else
'  sql = "select c.ding_ndocto as Num_Docto    " & vbCrLf &_
'        "from abonos a, ingresos b, detalle_ingresos c  " & vbCrLf &_
'        "where a.ingr_ncorr = b.ingr_ncorr  " & vbCrLf &_
'        "  and b.ingr_ncorr = c.ingr_ncorr  " & vbCrLf &_
'	    "  and a.tcom_ccod = '" & q_tcom_ccod & "'  " & vbCrLf &_
'	    "  and a.inst_ccod = '" & q_inst_ccod & "'  " & vbCrLf &_
'		"  and a.comp_ndocto = '" & q_comp_ndocto & "'  " & vbCrLf &_
'		"  and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'"
' numero = conexion.consultaUno(sql)  
'end if


select case q_tcom_ccod
	case "5"
		numero = conexion.consultaUno("select ding_ndocto from referencias_cargos where reca_ncorr='" & q_comp_ndocto & "'")
		
	case "6"
		numero = conexion.consultaUno("select ding_ndocto from referencias_cargos where reca_ncorr='" & q_comp_ndocto & "'")
		
	case "14"
		numero = conexion.consultaUno("select ding_ndocto from compromisos_cheques where cche_ncorr='" & q_comp_ndocto & "'")
	
	case else
		numero = conexion.ConsultaUno("select protic.documento_asociado_cuota('" & q_tcom_ccod & "', '" & q_inst_ccod & "', '" & q_comp_ndocto & "', '" & q_dcom_ncompromiso & "', 'ding_ndocto')")
		'sql = "select c.ding_ndocto as Num_Docto    " & vbCrLf &_
		'		"from abonos a, ingresos b, detalle_ingresos c  " & vbCrLf &_
		'		"where a.ingr_ncorr = b.ingr_ncorr  " & vbCrLf &_
		'		"  and b.ingr_ncorr = c.ingr_ncorr  " & vbCrLf &_
		'		"  and a.tcom_ccod = '" & q_tcom_ccod & "'  " & vbCrLf &_
		'		"  and a.inst_ccod = '" & q_inst_ccod & "'  " & vbCrLf &_
		'		"  and a.comp_ndocto = '" & q_comp_ndocto & "'  " & vbCrLf &_
		'		"  and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'"
		' numero = conexion.consultaUno(sql)  
end select

'--------------------------------------------------------------------------------

consulta = "select '" & numero & "' as Num_Docto, a.comp_ndocto, a.tcom_ccod, a.dcom_ncompromiso, a.dcom_mcompromiso, a.dcom_fcompromiso, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo " & vbCrLf &_
           "from detalle_compromisos a " & vbCrLf &_
		   "where a.tcom_ccod = '" & q_tcom_ccod & "'  " & vbCrLf &_
		   "  and a.inst_ccod = '" & q_inst_ccod & "'  " & vbCrLf &_
		   "  and a.comp_ndocto = '" & q_comp_ndocto & "'  " & vbCrLf &_
		   "  and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'"
'RESPONSE.Write("<PRE>"&consulta&"</PRE>")
f_cuota.Consultar consulta

'---------------------------------------------------------------------------------------------------		   
set f_abonos = new CFormulario
f_abonos.Carga_Parametros "detalle_abonos.xml", "abonos"
f_abonos.Inicializar conexion

consulta = "select cast(case d.ting_brebaje when 'S' then -a.abon_mabono else a.abon_mabono end as numeric) as abon_mabono" & vbCrLf &_
			"        , a.abon_fabono, b.eing_ccod, b.ingr_fpago, b.ingr_mefectivo, b.ingr_mdocto, b.ting_ccod" & vbCrLf &_
			"        , b.ingr_nfolio_referencia, (select ting_ccod from detalle_ingresos where ingr_ncorr=b.ingr_ncorr) as ting_ccod_documento,"  & vbCrLf &_
			" c.ding_ndocto, c.ding_mdocto, c.ding_fdocto , c.banc_ccod " & vbCrLf &_
			"    from abonos a,ingresos b,detalle_ingresos c,tipos_ingresos d" & vbCrLf &_
			"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
			"        and b.ingr_ncorr *= c.ingr_ncorr" & vbCrLf &_
			"        and b.ting_ccod = d.ting_ccod" & vbCrLf &_
			"        and protic.estado_origen_ingreso(a.ingr_ncorr) in (1, 5)" & vbCrLf &_
			"        and isnull(c.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
			"        and a.tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
			"        and a.inst_ccod = '" & q_inst_ccod & "' " & vbCrLf &_
			"        and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
			"        and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'"
'response.Write("<pre>" & consulta & "</pre>")
f_abonos.Consultar consulta

'---------------------------------------------------------------------------------------------------		   
set f_abonos_documentados = new CFormulario
f_abonos_documentados.Carga_Parametros "detalle_abonos.xml", "abonos"
f_abonos_documentados.Inicializar conexion

consulta = "select cast(case d.ting_brebaje when 'S' then -a.abon_mabono else  a.abon_mabono end as numeric) as abon_mabono" & vbCrLf &_
			"        , a.abon_fabono, b.eing_ccod, b.ingr_fpago, b.ingr_mefectivo, b.ingr_mdocto, b.ting_ccod" & vbCrLf &_
			"        , b.ingr_nfolio_referencia, c.ting_ccod as ting_ccod_documento, c.ding_ndocto, c.ding_mdocto" & vbCrLf &_
			"        , c.ding_fdocto, c.edin_ccod, c.ting_ccod ,c.banc_ccod " & vbCrLf &_
			"    from abonos a,ingresos b,detalle_ingresos c,tipos_ingresos d" & vbCrLf &_
			"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
			"        and b.ingr_ncorr *= c.ingr_ncorr" & vbCrLf &_
			"        and b.ting_ccod = d.ting_ccod" & vbCrLf &_
			"        and protic.estado_origen_ingreso(a.ingr_ncorr) = 4 " & vbCrLf &_
			"        and a.tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
			"        and a.inst_ccod = '" & q_inst_ccod & "' " & vbCrLf &_
			"        and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
			"        and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'"

'"        and isnull(c.ding_bpacta_cuota, 'N') = 'N'" & vbCrLf &_
'response.Write("<pre>" & consulta & "</pre>")

f_abonos_documentados.Consultar consulta




'---------------------------------------------------------------------------------
set f_detalle = new CFormulario
f_detalle.Carga_Parametros "detalle_abonos.xml", "detalle_cargo"
f_detalle.Inicializar conexion

consulta = "select 1 as orden1, " & vbCrLf &_
			"       case grouping(d.tdet_tdesc)" & vbCrLf &_
			"                when 1 then 2" & vbCrLf &_
			"                else 1" & vbCrLf &_
			"                end as orden2, " & vbCrLf &_
			"       case max(d.tdet_bdescuento)" & vbCrLf &_
			"                when 'S' then 2" & vbCrLf &_
			"                else 1" & vbCrLf &_
			"                end as orden3," & vbCrLf &_
			"       case grouping(d.tdet_tdesc)" & vbCrLf &_
			"                when 1 then '<b><div align=right>TOTAL COMPROMISO</div></b>'" & vbCrLf &_
			"                else d.tdet_tdesc" & vbCrLf &_
			"                end as tdet_tdesc, " & vbCrLf &_
			"	   sum(c.deta_msubtotal) as valor" & vbCrLf &_
			"    from detalle_compromisos a,compromisos b,detalles c,tipos_detalle d" & vbCrLf &_
			"    where a.tcom_ccod = b.tcom_ccod" & vbCrLf &_
			"        and a.inst_ccod = b.inst_ccod" & vbCrLf &_
			"        and a.comp_ndocto = b.comp_ndocto" & vbCrLf &_
			"        and b.tcom_ccod = c.tcom_ccod" & vbCrLf &_
			"        and b.inst_ccod = c.inst_ccod" & vbCrLf &_
			"        and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
			"        and c.tdet_ccod = d.tdet_ccod      " & vbCrLf &_
			"        and a.tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
			"        and a.inst_ccod = '" & q_inst_ccod & "'" & vbCrLf &_
			"        and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
			"        and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'" & vbCrLf &_
			"group by d.tdet_tdesc WITH ROLLUP" & vbCrLf &_
			"union" & vbCrLf &_
			"select 2 as orden1, 1 as orden2, 1 as orden3, '<div align=right>Nº CUOTAS</div>', comp_ncuotas " & vbCrLf &_
			"from compromisos " & vbCrLf &_
			"where tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
			"  and inst_ccod = '" & q_inst_ccod & "' " & vbCrLf &_
			"  and comp_ndocto = '" & q_comp_ndocto & "'  " & vbCrLf &_
			"order by orden1 asc, orden2 asc, orden3 asc "
			
'response.Write("<PRE>" & consulta & "</PRE>")
'response.End()		   

f_detalle.Consultar consulta

i_ = 0
while f_detalle.Siguiente
	if f_detalle.ObtenerValor("orden1") = "2" then
		f_detalle.AgregaCampoFilaParam i_, "valor", "formato", "DECIMAL"
	end if
	
	i_ = i_ + 1
wend
f_detalle.Primero

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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td><%pagina.DibujarLenguetas Array("Detalle de abonos"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="center"><%f_cuota.DibujaRegistro%></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Abonos"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_abonos.DibujaTabla%></div></td>
                        </tr>
                      </table>
                      <br>
                      <br>
                      <%pagina.DibujarSubtitulo "Abonos documentados"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center">
                              <%f_abonos_documentados.DibujaTabla%>
                          </div></td>
                        </tr>
                      </table>
                      <br>
                      <br>
                      <br>
                      <%pagina.DibujarSubtitulo "Detalle Formación del cargo"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center">
                              <%f_detalle.DibujaTabla%>
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
            <td width="14%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("cerrar")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="86%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
