<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_Creditos.xls"
Response.ContentType = "application/vnd.ms-excel"

ano_ccod =Request.Form("a[0][anos_ccod]")
mes_ccod = Request.Form("a[0][mes_ccod]")
sede_ccod =Request.Form("a[0][sede_ccod]")
esho_ccod= request.Form("a[0][esho_ccod]")
'q_anos_ccod= request.Form("anos_ccod")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

usu=negocio.obtenerUsuario	
 
 if sede_ccod <> "" then
	

  	filtro=filtro&"and b.sede_ccod='"&sede_ccod&"'"
end if

 
sql_descuentos="select pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,protic.trunc(d.hoto_fecha)as fecha_hora, hora_ini+'-'+hora_fin as hora,"& vbCrLf &_
			"(select sede_tdesc from sedes cc where cc.SEDE_CCOD=b.sede_ccod)as sede,"& vbCrLf &_
			"(select esho_tdesc from estado_horas cc where cc.esho_ccod=d.esho_ccod)as estado"& vbCrLf &_
			"from bloques_sicologos a,"& vbCrLf &_
			"sicologos_sede b,"& vbCrLf &_
			"sicologos c,"& vbCrLf &_
			"horas_tomadas d,"& vbCrLf &_
			"personas e"& vbCrLf &_
			"where a.side_ncorr=b.side_ncorr"& vbCrLf &_
			"and b.sico_ncorr=c.sico_ncorr"& vbCrLf &_
			" " &filtro&" "& vbCrLf &_
			"and c.pers_ncorr=protic.obtener_pers_ncorr("&usu&")"& vbCrLf &_
			"and datepart(mm,d.hoto_fecha)="&mes_ccod&""& vbCrLf &_
			"and datepart(yyyy,d.hoto_fecha)="&ano_ccod&""& vbCrLf &_
			"and a.blsi_ncorr=d.blsi_ncorr"& vbCrLf &_
			"and d.pers_ncorr=e.PERS_NCORR"& vbCrLf &_
			"and d.esho_ccod="&esho_ccod&""& vbCrLf &_
			"order by nombre"
			
 


				'
					


	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&q_tdet_ccod&"</pre>")
'response.Write("<pre>"&q_sede_ccod&"</pre>")
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql_descuentos

'-------------------------------------------------------------------------------



'response.End()		

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title></head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">
  <tr>
    <td width="28%"><div align="center"><strong>Nombre </strong></div></td>
	<td width="12%"><div align="center"><strong>Rut</strong></div></td>
	<td width="20%"><div align="center"><strong>Estado</strong></div></td>
    <td width="11%"><div align="center"><strong>Fecha Hora</strong></div></td>
	<td width="11%"><div align="center"><strong>Bloque Hora</strong></div></td>
    <td width="18%"><div align="center"><strong>Sede</strong></div></td>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("nombre")%></div></td>
	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("estado")%></div></td>
	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("fecha_hora")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("hora")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>