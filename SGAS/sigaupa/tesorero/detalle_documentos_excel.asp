<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_documentos.xls"
Response.ContentType = "application/vnd.ms-excel"

'----------------------------------------------------------------------------------
q_mcaj_ncorr = Request.QueryString("mcaj_ncorr")
q_ting_ccod = Request.QueryString("ting_ccod")
q_tdoc_ccod = Request.QueryString("tdoc_ccod")

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
' datos del cajero
set f_movimiento_caja = new CFormulario
f_movimiento_caja.Carga_Parametros "detalle_caja.xml", "movimiento_caja"
f_movimiento_caja.Inicializar conexion

consulta = "select protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_completo, a.mcaj_ncorr, a.mcaj_ncorr as c_mcaj_ncorr, a.mcaj_finicio, getDate() as fecha_emision, a.mcaj_mrendicion " & vbCrLf &_
           "from movimientos_cajas a, cajeros b " & vbCrLf &_
		   "where a.sede_ccod = b.sede_ccod " & vbCrLf &_
		   "  and a.caje_ccod = b.caje_ccod " & vbCrLf &_
		   "  and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "'"
'response.Write(consulta)
'response.End()
f_movimiento_caja.Consultar consulta


'-----------------------------------------------------------------------------------------------
v_inst_ccod = "1"
v_tdoc_tdesc = conexion.ConsultaUno("select protic.initcap(tdoc_tdesc) from tipos_documentos_mov_cajas where cast(tdoc_ccod as varchar)= '" & q_tdoc_ccod & "'")

if EsVacio(q_tdoc_ccod) then
	v_tdoc_tdesc = conexion.ConsultaUno("select protic.initcap(ting_tdesc) from tipos_ingresos where cast(ting_ccod as varchar)= '" & q_ting_ccod & "'")
end if
'response.Write(q_ting_ccod)
SELECT CASE q_ting_ccod

CASE "52" 

	sql_extra= " case when len(isnull(b.ding_ndocto,0))<=4 "& vbCrLf &_
				" then protic.obtener_numero_pagare_pagado(b.ingr_ncorr) "& vbCrLf &_
				" else cast(b.ding_ndocto as varchar) end as ding_ndocto, 'N/B' as banc_ccod, "
CASE "10" 
	sql_extra=" cast(b.ding_ndocto as varchar) as ding_ndocto,cast(protic.obtener_numero_docto_pagado(b.ingr_ncorr) as varchar) as num_letra, isnull(cast(b.banc_ccod as varchar),'N/B') as banc_ccod,"
cols_span=6
CASE ELSE 
cols_span=5
sql_extra=" b.ding_ndocto, isnull(cast(b.banc_ccod as varchar),'N/B') as banc_ccod,"

END SELECT 

'------------------------------------------------------------------------------------------------
set f_documentos = new CFormulario
f_documentos.Carga_Parametros "consulta.xml", "consulta"
f_documentos.Inicializar conexion

consulta = " Select protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.ting_ccod, "& vbCrLf &_
		   " "&sql_extra&" "& vbCrLf &_
		   " b.plaz_ccod, b.ding_fdocto, cast(b.ding_mdetalle as numeric) as ding_mdetalle, cast(b.ding_mdocto as numeric) as ding_mdocto, c.ting_tdesc, " & vbCrLf &_
           " protic.obtener_rut((SELECT pers_ncorr FROM codeudor_postulacion WHERE post_ncorr in (SELECT MAX(post_ncorr) AS post_ncorr FROM postulantes WHERE pers_ncorr = a.pers_ncorr))) as rut_apoderado, "& vbCrLf &_
		   " isnull(protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "'),0) as anulado, b.ding_mdetalle - protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as saldo " & vbCrLf &_
           " From ingresos a, detalle_ingresos b, tipos_ingresos c " & vbCrLf &_
		   " Where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
		   "  and b.ting_ccod = c.ting_ccod " & vbCrLf &_
		   "  and a.eing_ccod  not in (3,6)  " & vbCrLf &_
		   "  and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
		   "  and cast(b.ting_ccod as varchar)= '" & q_ting_ccod & "'" & vbCrLf &_
		   " ORDER BY banc_ccod ASC, b.ding_ndocto asc, rut , b.ding_fdocto ASC"
	
'response.Write("<pre>"&consulta&"</pre>")	   
'response.End()
f_documentos.Consultar consulta
		
consulta_total= "select isnull(sum(b.ding_mdetalle -protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "')),0) AS Total " & vbCrLf &_
			   " from ingresos a, detalle_ingresos b, tipos_ingresos c " & vbCrLf &_
			   " where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
			   "  and b.ting_ccod = c.ting_ccod " & vbCrLf &_
			   "  and a.eing_ccod  not in (3,6) " & vbCrLf &_
			   "  and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
			   "  and cast(b.ting_ccod as varchar)= '" & q_ting_ccod & "'" 
		
v_totalizado=conexion.consultauno(consulta_total)		   
'------------------------------------------------------------------------------------------
url_leng_1 = "detalle_caja.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=1"
url_leng_2 = "detalle_caja.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=2"
url_leng_3 = "detalle_caja.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=3"
url_leng_4 = "detalle_caja.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=4"
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
<b>TIPO DE DOCUMENTOS : <%=UCase(v_tdoc_tdesc)%></b>
<br>
<br>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td><div align="center"><strong>COD. BANCO</strong></div></td>
    <td><div align="center"><strong>N&ordm; DOCTO </strong></div></td>
<% if q_ting_ccod="10" then %>
	<td><div align="center"><strong>Numero Letra</strong></div></td>
<%end if%>
    <td><div align="center"><strong>FECHA DOCTO. </strong></div></td>
    <td><div align="center"><strong>MONTO</strong></div></td>
    <td><div align="center"><strong>ANULADO</strong></div></td>
    <td><div align="center"><strong>SALDO</strong></div></td>
    <td><div align="center"><strong>R.U.T.</strong></div></td>
    <td><div align="center"><strong>RUT APODERADO</strong></div></td>
  </tr>
  <%while f_documentos.Siguiente%>
  <tr>
    <td><%=f_documentos.ObtenerValor("banc_ccod")%></td>
    <td><%=f_documentos.ObtenerValor("ding_ndocto")%></td>
<% if q_ting_ccod="10" then %>
<td><%=f_documentos.ObtenerValor("num_letra")%></td>
<%end if%>
    <td>&nbsp;<%=f_documentos.ObtenerValor("ding_fdocto")%></td>
    <td><font><%=formatNumber(f_documentos.ObtenerValor("ding_mdetalle"),0, 0, -1, -1)%></font></td>
    <td><font><%=formatNumber(f_documentos.ObtenerValor("anulado"),0, 0, -1, -1)%></font></td>
    <td><font><%=formatNumber(f_documentos.ObtenerValor("saldo"),0, 0, -1, -1)%></font></td>
    <td><%=f_documentos.ObtenerValor("rut")%></td>
    <td><%=f_documentos.ObtenerValor("rut_apoderado")%></td>
  </tr>
  <%wend%>
  <tr>
  <td colspan="<%=cols_span%>" align="center"> <b>Total:</b></td>
  <td align="center"><b>$ <%=formatNumber(v_totalizado,0, 0, -1, -1)%></b></td>
  </tr>
</table>
</body>
</html>
