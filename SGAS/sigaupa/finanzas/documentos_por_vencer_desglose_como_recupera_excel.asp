<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_documentos_por_vencer_desgloce_como_recupera.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



sql_listado_documentos_como_recupera = "select estado,isnull(sum(vencido),0) as vencido,isnull(sum(por_vencer_0_30),0) as por_vencer_0_30,isnull(sum(por_vencer_31_60),0) as"& vbcrlf & _
"por_vencer_31_60,isnull(sum(por_vencer_61_90),0) as por_vencer_61_90,isnull(sum(por_vencer_91_120),0)as por_vencer_91_120,isnull(sum(por_vencer_121_150),0)as"& vbcrlf & _
"por_vencer_121_150,isnull(sum(por_vencer_151_180),0) as por_vencer_151_180,isnull(sum(por_vencer_181_mas),0)as por_vencer_181_mas"& vbcrlf & _
",isnull(sum(vencido),0)+isnull(sum(por_vencer_0_30),0)+isnull(sum(por_vencer_31_60),0)+isnull(sum(por_vencer_61_90),0)+isnull(sum(por_vencer_91_120),0)+isnull(sum(por_vencer_121_150),0)+isnull(sum(por_vencer_151_180),0)+isnull(sum(por_vencer_181_mas),0)as total"& vbcrlf & _
"from (select estado,"& vbcrlf & _
"case when DATEDIFF ( day , getdate() , fecha_vencimiento )  < 0 then monto end vencido,"& vbcrlf & _
"case when (DATEDIFF ( day , getdate() , fecha_vencimiento ) ) BETWEEN 0 and 30 then monto end por_vencer_0_30,"& vbcrlf & _
"case when (DATEDIFF ( day , getdate() , fecha_vencimiento ) ) BETWEEN 31 and 60 then monto end por_vencer_31_60,"& vbcrlf & _
"case when (DATEDIFF ( day , getdate() , fecha_vencimiento ) ) BETWEEN 61 and 90 then monto end por_vencer_61_90,"& vbcrlf & _
"case when (DATEDIFF ( day , getdate() , fecha_vencimiento ) ) BETWEEN 91 and 120 then monto end por_vencer_91_120,"& vbcrlf & _
"case when (DATEDIFF ( day , getdate() , fecha_vencimiento ) ) BETWEEN 121 and 150 then monto end por_vencer_121_150,"& vbcrlf & _
"case when (DATEDIFF ( day , getdate() , fecha_vencimiento ) ) BETWEEN 151 and 180 then monto end por_vencer_151_180,"& vbcrlf & _
"case when (DATEDIFF ( day , getdate() , fecha_vencimiento ) ) >= 181 then monto end por_vencer_181_mas"& vbcrlf & _
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
  
  <td><div align="center"><strong>Documentos</strong></div></td>
  <td><div align="center"><strong>Vencido</strong></div></td>
    <td><div align="center"><strong>0-30</strong></div></td>
	<td><div align="center"><strong>31-60</strong></div></td>
	<td><div align="center"><strong>61-90</strong></div></td>
    <td><div align="center"><strong>91-120</strong></div></td>
    <td><div align="center"><strong>121-150</strong></div></td>
	<td><div align="center"><strong>151-180</strong></div></td>
	<td><div align="center"><strong>180 y más</strong></div></td>
	<td><div align="center"><strong>Total Deuda</strong></div></td>
	
  </tr>
   
  <%  while f_valor_documentos.Siguiente 
  
 total_vencido = total_vencido  + cdbl(f_valor_documentos.ObtenerValor("vencido"))
 total_por_vencer_0_30c = total_por_vencer_0_30c  + cdbl(f_valor_documentos.ObtenerValor("por_vencer_0_30")) 
 total_por_vencer_31_60c=total_por_vencer_31_60c + cdbl(f_valor_documentos.ObtenerValor("por_vencer_31_60"))
 total_por_vencer_61_90c=total_por_vencer_61_90c + cdbl(f_valor_documentos.ObtenerValor("por_vencer_61_90"))
 total_por_vencer_91_120c=total_por_vencer_91_120c + cdbl(f_valor_documentos.ObtenerValor("por_vencer_91_120"))
 total_por_vencer_121_150c=total_por_vencer_121_150c + cdbl(f_valor_documentos.ObtenerValor("por_vencer_121_150"))
 total_por_vencer_151_180c=total_por_vencer_151_180c + cdbl(f_valor_documentos.ObtenerValor("por_vencer_151_180"))
 total_por_vencer_181_masc=total_por_vencer_181_masc + cdbl(f_valor_documentos.ObtenerValor("por_vencer_181_mas"))
 totalc=totalc + cdbl(f_valor_documentos.ObtenerValor("total"))
  %>
  
  <tr> 
    
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("estado")%></div></td>
    <td><div align="right"><%=f_valor_documentos.ObtenerValor("vencido")%></div></td>
    <td><div align="right"><%=f_valor_documentos.ObtenerValor("por_vencer_0_30")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("por_vencer_31_60")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("por_vencer_61_90")%></div></td>
    <td><div align="right"><%=f_valor_documentos.ObtenerValor("por_vencer_91_120")%></div></td>
    <td><div align="right"><%=f_valor_documentos.ObtenerValor("por_vencer_121_150")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("por_vencer_151_180")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("por_vencer_181_mas")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("total")%></div></td>
   
  </tr>
   
  <%  wend %>
  
     
  <tr> 
    
    <td><div align="center"><strong>Total</strong></div></td>
    <td><div align="right"><%=total_vencido%></div></td>
    <td><div align="right"><%=total_por_vencer_0_30c%></div></td>
	<td><div align="right"><%=total_por_vencer_31_60c%></div></td>
	<td><div align="right"><%=total_por_vencer_61_90c%></div></td>
    <td><div align="right"><%=total_por_vencer_91_120c%></div></td>
    <td><div align="right"><%=total_por_vencer_121_150c%></div></td>
	<td><div align="right"><%=total_por_vencer_151_180c%></div></td>
	<td><div align="right"><%=total_por_vencer_181_masc%></div></td>
	<td><div align="right"><%=totalc%></div></td>
   
  </tr>
   
 
</table>
</body>
</html>