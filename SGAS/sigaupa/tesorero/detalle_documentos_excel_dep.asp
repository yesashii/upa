<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_documentos_depositados.xls"
Response.ContentType = "application/vnd.ms-excel"

'----------------------------------------------------------------------------------
q_mcaj_ncorr = Request.QueryString("mcaj_ncorr")
q_ting_ccod = Request.QueryString("ting_ccod")
q_tdoc_ccod = Request.QueryString("tdoc_ccod")
q_leng = Request.QueryString("q_leng")

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
		   "  and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "'"
'response.Write(consulta)
'response.End()
f_movimiento_caja.Consultar consulta


'-----------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------
set f_documentos = new CFormulario
f_documentos.Carga_Parametros "consulta.xml", "consulta"
f_documentos.Inicializar conexion

IF q_leng=4 then

v_descripcion="CHEQUES A DEPOSITO"

	consulta = "select protic.obtener_rut(a.pers_ncorr) as rut," & vbCrLf &_
				" protic.obtener_rut((SELECT pers_ncorr FROM codeudor_postulacion WHERE post_ncorr in (SELECT MAX(post_ncorr) AS post_ncorr FROM postulantes WHERE pers_ncorr = a.pers_ncorr))) as rut_apoderado,"& vbCrLf &_
				"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre," & vbCrLf &_
				"    b.ting_ccod, b.ding_ndocto, isnull(cast(b.banc_ccod as varchar),'N/B') as banc_ccod, b.plaz_ccod," & vbCrLf &_
				"    b.ding_fdocto, cast(b.ding_mdetalle as numeric) as ding_mdetalle," & vbCrLf &_
				"    cast(b.ding_mdocto as numeric) as ding_mdocto, " & vbCrLf &_
				"    protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as anulado," & vbCrLf &_
				"    b.ding_mdetalle - protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as saldo" & vbCrLf &_
				"    from ingresos a,detalle_ingresos b" & vbCrLf &_
				"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
				"        and a.eing_ccod not in (3,6) " & vbCrLf &_
				"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
				"        and b.ting_ccod = '3'" & vbCrLf &_
				"         and (b.ding_fdocto) <= (select mcaj_finicio from movimientos_cajas where mcaj_ncorr='" & q_mcaj_ncorr & "') "& vbCrLf &_
				"ORDER BY b.banc_ccod ASC, b.ding_ndocto asc, rut ASC"
				
				consulta_total= "select isnull(sum(b.ding_mdetalle -protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "')),0) AS Total " & vbCrLf &_
				"    from ingresos a,detalle_ingresos b" & vbCrLf &_
				"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
				"        and a.eing_ccod not in (3,6) " & vbCrLf &_
				"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
				"        and b.ting_ccod = '3'" & vbCrLf &_
				"         and (b.ding_fdocto) <= (select mcaj_finicio from movimientos_cajas where mcaj_ncorr='" & q_mcaj_ncorr & "') "

else
v_descripcion="CHEQUES A CUSTODIA"
' documentos en custodia
	consulta = "select protic.obtener_rut(a.pers_ncorr) as rut," & vbCrLf &_
			" protic.obtener_rut((SELECT pers_ncorr FROM codeudor_postulacion WHERE post_ncorr in (SELECT MAX(post_ncorr) AS post_ncorr FROM postulantes WHERE pers_ncorr = a.pers_ncorr))) as rut_apoderado,"& vbCrLf &_
			"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre," & vbCrLf &_
			"    b.ting_ccod, b.ding_ndocto, isnull(cast(b.banc_ccod as varchar),'N/B') as banc_ccod, b.plaz_ccod," & vbCrLf &_
			"    b.ding_fdocto, cast(b.ding_mdetalle as numeric) as ding_mdetalle," & vbCrLf &_
			"    cast(b.ding_mdocto as numeric) as ding_mdocto, " & vbCrLf &_
			"    protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as anulado," & vbCrLf &_
			"    b.ding_mdetalle - protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as saldo" & vbCrLf &_
			"    from ingresos a,detalle_ingresos b" & vbCrLf &_
			"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
			"        and a.eing_ccod not in (3,6) " & vbCrLf &_
			"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
			"        and b.ting_ccod = '3'" & vbCrLf &_
			"        and (b.ding_fdocto) > (select mcaj_finicio from movimientos_cajas where mcaj_ncorr='" & q_mcaj_ncorr & "') "& vbCrLf &_
			"ORDER BY b.banc_ccod ASC, b.ding_ndocto asc, rut ASC"
			
			
			consulta_total= "select isnull(sum(b.ding_mdetalle -protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "')),0) AS Total " & vbCrLf &_
				"    from ingresos a,detalle_ingresos b" & vbCrLf &_
				"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
				"        and a.eing_ccod not in (3,6) " & vbCrLf &_
				"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
				"        and b.ting_ccod = '3'" & vbCrLf &_
				"         and (b.ding_fdocto) > (select mcaj_finicio from movimientos_cajas where mcaj_ncorr='" & q_mcaj_ncorr & "') "

end if	
'response.Write("<pre>"&consulta&"</pre>")	   
'response.End()
f_documentos.Consultar consulta
		

		
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
<b>TIPO DE DOCUMENTOS : <%=v_descripcion%></b>
<br>
<br>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td><div align="center"><strong>COD. BANCO</strong></div></td>
    <td><div align="center"><strong>N&ordm; DOCTO </strong></div></td>
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
    <td>&nbsp;<%=f_documentos.ObtenerValor("ding_fdocto")%></td>
    <td><font><%=formatNumber(f_documentos.ObtenerValor("ding_mdetalle"),0, 0, -1, -1)%></font></td>
    <td><font><%=formatNumber(f_documentos.ObtenerValor("anulado"),0, 0, -1, -1)%></font></td>
    <td><font><%=formatNumber(f_documentos.ObtenerValor("saldo"),0, 0, -1, -1)%></font></td>
    <td><%=f_documentos.ObtenerValor("rut")%></td>
    <td><%=f_documentos.ObtenerValor("rut_apoderado")%></td>
  </tr>
  <%wend%>
  <tr>
  <td colspan="5" align="center"> <b>Total:</b></td>
  <td align="left"><b>$<%=formatNumber(v_totalizado,0, 0, -1, -1)%></b></td>
  </tr>
</table>
</body>
</html>
