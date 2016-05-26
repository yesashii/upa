<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_documentos_por_vencer_desgloce_estado_dcto.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



sql_listado_documentos_como_recupera = "select estado,isnull(sum(no_vencido),0) as no_vencido,isnull(sum(vencio_0_30),0) as vencio_0_30,isnull(sum(vencio_31_60),0) as"& vbcrlf & _
 "vencio_31_60,isnull(sum(vencio_61_90),0) as vencio_61_90,isnull(sum(vencio_91_120),0)as vencio_91_120,isnull(sum(vencio_121_150),0)as"& vbcrlf & _
  "vencio_121_150,isnull(sum(vencio_151_180),0) as vencio_151_180,isnull(sum(vencio_181_mas),0)as vencio_181_mas"& vbcrlf & _
",isnull(sum(no_vencido),0)+isnull(sum(vencio_0_30),0)+isnull(sum(vencio_31_60),0)+isnull(sum(vencio_61_90),0)+isnull(sum(vencio_91_120),0)+isnull(sum(vencio_121_150),0)+isnull(sum(vencio_151_180),0)+isnull(sum(vencio_181_mas),0)as total"& vbcrlf & _
"from (select estado,"& vbcrlf & _
"case when DATEDIFF ( day  , fecha_vencimiento, getdate() )  < 0 then monto end no_vencido,"& vbcrlf & _
"case when (DATEDIFF ( day  , fecha_vencimiento, getdate() ) ) BETWEEN 0 and 30 then monto end vencio_0_30,"& vbcrlf & _
"case when (DATEDIFF ( day  , fecha_vencimiento, getdate() ) ) BETWEEN 31 and 60 then monto end vencio_31_60,"& vbcrlf & _
"case when (DATEDIFF ( day  , fecha_vencimiento, getdate() ) ) BETWEEN 61 and 90 then monto end vencio_61_90,"& vbcrlf & _
"case when (DATEDIFF ( day  , fecha_vencimiento, getdate() ) ) BETWEEN 91 and 120 then monto end vencio_91_120,"& vbcrlf & _
"case when (DATEDIFF ( day  , fecha_vencimiento, getdate() ) ) BETWEEN 121 and 150 then monto end vencio_121_150,"& vbcrlf & _
"case when (DATEDIFF ( day  , fecha_vencimiento, getdate() ) ) BETWEEN 151 and 180 then monto end vencio_151_180,"& vbcrlf & _
"case when (DATEDIFF ( day  , fecha_vencimiento, getdate() ) ) >= 181 then monto end vencio_181_mas"& vbcrlf & _
"from documentos_por_vencer_listado)as mm"& vbcrlf & _
"group by estado"


	
	
	
response.Write("<pre>"&sql_listado_documentos_como_recupera&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql_listado_documentos_como_recupera


'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="85%" border="1">
  <tr> 
  
  <td><div align="center"><strong>Estado documento</strong></div></td>
  <td><div align="center"><strong>180 y más</strong></div></td>
  <td><div align="center"><strong>151-180</strong></div></td>
  <td><div align="center"><strong>121-150</strong></div></td>
  <td><div align="center"><strong>91-120</strong></div></td>
  <td><div align="center"><strong>61-90</strong></div></td>
  <td><div align="center"><strong>31-60</strong></div></td>
  <td><div align="center"><strong>0-30</strong></div></td>
  <td><div align="center"><strong>No Vencido</strong></div></td>
   <td><div align="center"><strong>Total Deuda</strong></div></td>  
  </tr>
   
  <%  while f_valor_documentos.Siguiente
  total_por_vencer_181_mas = total_por_vencer_181_mas + cdbl(f_valor_documentos.ObtenerValor("vencio_181_mas"))
  total_por_vencer_151_180 = total_por_vencer_151_180 + cdbl(f_valor_documentos.ObtenerValor("vencio_151_180"))
  total_por_vencer_121_150=total_por_vencer_121_150 + cdbl(f_valor_documentos.ObtenerValor("vencio_121_150"))
  total_por_vencer_91_120=total_por_vencer_91_120 + cdbl(f_valor_documentos.ObtenerValor("vencio_91_120"))
  total_por_vencer_61_90=total_por_vencer_61_90 + cdbl(f_valor_documentos.ObtenerValor("vencio_61_90"))
  total_por_vencer_31_60=total_por_vencer_31_60 + cdbl(f_valor_documentos.ObtenerValor("vencio_31_60"))
  total_por_vencer_0_30 = total_por_vencer_0_30  + cdbl(f_valor_documentos.ObtenerValor("vencio_0_30"))
 total_vencido = total_vencido  + cdbl(f_valor_documentos.ObtenerValor("no_vencido"))
 total=total + cdbl(f_valor_documentos.ObtenerValor("total"))
  %>
  
  <tr> 
    
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("estado")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("vencio_181_mas")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("vencio_151_180")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("vencio_121_150")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("vencio_91_120")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("vencio_61_90")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("vencio_31_60")%></div></td>
	 <td><div align="right"><%=f_valor_documentos.ObtenerValor("vencio_0_30")%></div></td>
    <td><div align="right"><%=f_valor_documentos.ObtenerValor("no_vencido")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("total")%></div></td>
  </tr>
   
  <%  wend %>
  
     
  <tr> 
    
    <td><div align="center"><strong>Total</strong></div></td>
	<td><div align="right"><%=total_por_vencer_181_mas%></div></td>
	<td><div align="right"><%=total_por_vencer_151_180%></div></td>
	 <td><div align="right"><%=total_por_vencer_121_150%></div></td>
	  <td><div align="right"><%=total_por_vencer_91_120%></div></td>
	  <td><div align="right"><%=total_por_vencer_61_90%></div></td>
	  <td><div align="right"><%=total_por_vencer_31_60%></div></td>
	  <td><div align="right"><%=total_por_vencer_0_30%></div></td>
    <td><div align="right"><%=total_vencido%></div></td>
	<td><div align="right"><%=total%></div></td>
  </tr>
</table>
</body>
</html>