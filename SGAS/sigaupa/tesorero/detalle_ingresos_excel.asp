<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_documentos.xls"
Response.ContentType = "application/vnd.ms-excel"

'----------------------------------------------------------------------------------
q_mcaj_ncorr = Request.QueryString("mcaj_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Cuadratura de Cajas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "detalle_caja.xml", "botonera"

'---------------------------------------------------------------------------------------------------

set f_movimiento_caja = new CFormulario
f_movimiento_caja.Carga_Parametros "detalle_caja.xml", "movimiento_caja"
f_movimiento_caja.Inicializar conexion

consulta = "select protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_completo, a.mcaj_ncorr, a.mcaj_ncorr as c_mcaj_ncorr, a.mcaj_finicio, getDate() as fecha_emision, a.mcaj_mrendicion " & vbCrLf &_
           "from movimientos_cajas a, cajeros b " & vbCrLf &_
		   "where a.sede_ccod = b.sede_ccod " & vbCrLf &_
		   "  and a.caje_ccod = b.caje_ccod " & vbCrLf &_
		   "  and cast(a.mcaj_ncorr as varchar) = '" & q_mcaj_ncorr & "'"

f_movimiento_caja.Consultar consulta


'-----------------------------------------------------------------------------------------------
v_inst_ccod = "1"
v_tdoc_tdesc = conexion.ConsultaUno("select protic.initcap(tdoc_tdesc) from tipos_documentos_mov_cajas where cast(tdoc_ccod as varchar)= '" & q_tdoc_ccod & "'")

'------------------------------------------------------------------------------------------------
set f_ingresos = new CFormulario
f_ingresos.Carga_Parametros "consulta.xml", "consulta"
f_ingresos.Inicializar conexion

consulta = "select a.ting_ccod, a.ingr_nfolio_referencia, a.ingr_fpago, sum(a.ingr_mefectivo) as ingr_mefectivo, sum(a.ingr_mdocto) as ingr_mdocto, sum(a.ingr_mtotal) as ingr_mtotal, b.ting_tdesc, " & vbCrLf &_
		   "       protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo " & vbCrLf &_
		   "from ingresos a, tipos_ingresos b " & vbCrLf &_
		   "where a.ting_ccod = b.ting_ccod " & vbCrLf &_
		   "  and a.eing_ccod <> 3 " & vbCrLf &_
		   "  and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
		   "group by a.ting_ccod, a.ingr_nfolio_referencia, a.ingr_fpago, a.pers_ncorr, b.ting_tdesc" & vbCrLf &_
		   "order by nombre_completo asc"


consulta = "select a.ingr_ncorrelativo_caja,a.ting_ccod, a.ingr_nfolio_referencia, a.ingr_fpago, sum(a.ingr_mefectivo) as ingr_mefectivo, sum(a.ingr_mdocto) as ingr_mdocto, sum(a.ingr_mtotal) as ingr_mtotal, b.ting_tdesc,  " & vbCrLf &_
	           "       protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo, " & vbCrLf &_
			   "	   sum(case when isnull(a.ingr_mefectivo, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "') else 0 end) as anulado_efectivo, " & vbCrLf &_
			   "	   sum(case when isnull(a.ingr_mdocto, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "') else 0 end) as anulado_documentos, " & vbCrLf &_
			   "	   sum(protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')) as total_anulado, " & vbCrLf &_
			   "	   sum(a.ingr_mefectivo - case when isnull(a.ingr_mefectivo, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "') else 0 end) as saldo_efectivo, " & vbCrLf &_
			   "	   sum(a.ingr_mdocto - case when isnull(a.ingr_mdocto, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "') else 0 end) as saldo_documentos, " & vbCrLf &_
			   "	   sum(a.ingr_mtotal - protic.total_rebajado_ingreso(a.ingr_ncorr, '" & q_mcaj_ncorr & "')) as saldo_total " & vbCrLf &_
			   "from ingresos a, tipos_ingresos b  " & vbCrLf &_
			   "where a.ting_ccod = b.ting_ccod  " & vbCrLf &_
			   "  and a.eing_ccod not in (3, 7) " & vbCrLf &_
			   "  and isnull(b.ting_brebaje, 'N') <> 'S'  " & vbCrLf &_
			   "  and a.mcaj_ncorr = '" & q_mcaj_ncorr & "'  " & vbCrLf &_
			   "group by a.ingr_ncorrelativo_caja,a.ting_ccod, a.ingr_nfolio_referencia, a.ingr_fpago, a.pers_ncorr, b.ting_tdesc " & vbCrLf &_
			   "order by ingr_nfolio_referencia asc"

consulta = "select a.ingr_ncorrelativo_caja,a.ting_ccod,  a.ingr_nfolio_referencia," & vbCrLf &_
            "    protic.trunc(a.ingr_fpago) as ingr_fpago," & vbCrLf &_
			"    cast(isnull(sum(a.ingr_mefectivo),0) as numeric) as ingr_mefectivo," & vbCrLf &_
			"    cast(sum(a.ingr_mdocto) as numeric) as ingr_mdocto, cast(sum(a.ingr_mtotal) as numeric) as ingr_mtotal, b.ting_tdesc," & vbCrLf &_
			"    protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"    sum(case " & vbCrLf &_
			"            when isnull(a.ingr_mefectivo, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,1) " & vbCrLf &_
			"            else 0" & vbCrLf &_
			"        end) as anulado_efectivo," & vbCrLf &_
			"    sum(case " & vbCrLf &_
			"            when isnull(a.ingr_mdocto, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,4) " & vbCrLf &_
			"            else 0" & vbCrLf &_
			"        end) as anulado_documentos," & vbCrLf &_
			"    sum(protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,null) ) as total_anulado," & vbCrLf &_
			"    sum(isnull(a.ingr_mefectivo,0) - " & vbCrLf &_
			"                case " & vbCrLf &_
			"                    when isnull(a.ingr_mefectivo, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,1) " & vbCrLf &_
			"                    else 0" & vbCrLf &_
			"                end) as saldo_efectivo," & vbCrLf &_
			"    sum(a.ingr_mdocto - " & vbCrLf &_
			"                case " & vbCrLf &_
			"                    when isnull(a.ingr_mdocto, 0) > 0 then protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,4)  " & vbCrLf &_
			"                    else 0" & vbCrLf &_
			"                end) as saldo_documentos," & vbCrLf &_
			"    sum(cast(a.ingr_mtotal as numeric) - cast(protic.total_rebajado_ingreso(a.ingr_ncorr, null)+ protic.total_anulado_contrato(a.ingr_ncorr,null) as numeric) ) as saldo_total" & vbCrLf &_
			"    from ingresos a,tipos_ingresos b" & vbCrLf &_
			"    where a.ting_ccod = b.ting_ccod" & vbCrLf &_
			"        and a.eing_ccod not in (3,7)" & vbCrLf &_
			"        and isnull(b.ting_brebaje, 'N') <> 'S'" & vbCrLf &_
			"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "'" & vbCrLf &_
			"group by a.ingr_ncorrelativo_caja,a.ting_ccod, a.ingr_nfolio_referencia, protic.trunc(a.ingr_fpago), a.pers_ncorr, b.ting_tdesc" & vbCrLf &_
			"order by ingr_nfolio_referencia asc, nombre_completo asc"


'response.Write("<pre>"&consulta&"<pre>")
'response.End()
f_ingresos.Consultar consulta

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">
</script>

</head>
<body>
<%
f_movimiento_caja.DibujaRegistro
%>
<br>
<b>INGRESOS</b>
<br>
<br>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>DOCUMENTO</strong></div></td>
    <td><div align="center"><strong>FOLIO</strong></div></td>
    <td><div align="center"><strong>EFECTIVO</strong></div></td>
    <td><div align="center"><strong>DOCUMENTOS</strong></div></td>
    <td><div align="center"><strong>TOTAL</strong></div></td>
    <td><div align="center"><strong>ANULADO EFECTIVO </strong></div></td>
    <td><div align="center"><strong>ANULADO DOCUMENTOS </strong></div></td>
    <td><div align="center"><strong>TOTAL ANULADO</strong></div></td>
    <td><div align="center"><strong>SALDO EFECTIVO</strong></div></td>
    <td><div align="center"><strong>SALDO DOCUMENTOS </strong></div></td>
    <td><div align="center"><strong>SALDO TOTAL </strong></div></td>
    <td><div align="center"><strong>R.U.T.</strong></div></td>
    <td><div align="center"><strong>NOMBRE</strong></div></td>
  </tr>
  <%while f_ingresos.Siguiente%>
  <tr>
	<td><%=f_ingresos.ObtenerValor("ingr_ncorrelativo_caja")%></td>
    <td><%=f_ingresos.ObtenerValor("ting_tdesc")%></td>
    <td><%=f_ingresos.ObtenerValor("ingr_nfolio_referencia")%></td>
    <td><%=FormatCurrency(f_ingresos.ObtenerValor("ingr_mefectivo"),0)%></td>
    <td><%=FormatCurrency(f_ingresos.ObtenerValor("ingr_mdocto"),0)%></td>
    <td><%=FormatCurrency(f_ingresos.ObtenerValor("ingr_mtotal"),0)%></td>
    <td><%=FormatCurrency(f_ingresos.ObtenerValor("anulado_efectivo"),0)%></td>
    <td><%=FormatCurrency(f_ingresos.ObtenerValor("anulado_documentos"),0)%></td>
    <td><%=FormatCurrency(f_ingresos.ObtenerValor("total_anulado"),0)%></td>
    <td><%=FormatCurrency(f_ingresos.ObtenerValor("saldo_efectivo"),0)%></td>
    <td><%=FormatCurrency(f_ingresos.ObtenerValor("saldo_documentos"),0)%></td>
    <td><%=FormatCurrency(f_ingresos.ObtenerValor("saldo_total"),0)%></td>
    <td><%=f_ingresos.ObtenerValor("rut")%></td>
    <td><%=f_ingresos.ObtenerValor("nombre_completo")%></td>
  </tr>
  <%wend%>
</table>
</body>
</html>
