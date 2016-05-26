<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_documentos_por_vencer_desgloce_X_ano.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



sql_listado_documentos_como_recupera = "select estado,isnull(sum(_2004_),0) as '_2004_',isnull(sum(_2005_),0) as '_2005_',isnull(sum(_2006_),0) as '_2006_',isnull(sum(_2007_),0) as '_2007_',isnull(sum(_2008_),0)as '_2008_',isnull(sum(_2009_),0)as '_2009_',(isnull(sum(_2004_),0)+isnull(sum(_2005_),0)+isnull(sum(_2006_),0)+isnull(sum(_2007_),0)+isnull(sum(_2008_),0)+isnull(sum(_2009_),0))as total"& vbcrlf & _
"from (select estado,"& vbcrlf & _
"case when DATEPART(year,fecha_vencimiento)= 2004  then monto end _2004_,"& vbcrlf & _
"case when DATEPART(year, fecha_vencimiento)= 2005  then monto end _2005_,"& vbcrlf & _
"case when DATEPART(year, fecha_vencimiento)= 2006  then monto end _2006_,"& vbcrlf & _
"case when DATEPART(year, fecha_vencimiento)= 2007  then monto end _2007_,"& vbcrlf & _
"case when DATEPART(year, fecha_vencimiento)= 2008  then monto end _2008_,"& vbcrlf & _
"case when DATEPART(year, fecha_vencimiento)= 2009  then monto end _2009_"& vbcrlf & _
"from documentos_por_vencer_listado) as mm"& vbcrlf & _
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
  <td><div align="center"><strong>2004</strong></div></td>
  <td><div align="center"><strong>2005</strong></div></td>
  <td><div align="center"><strong>2006</strong></div></td>
  <td><div align="center"><strong>2007</strong></div></td>
  <td><div align="center"><strong>2008</strong></div></td>
  <td><div align="center"><strong>2009</strong></div></td>
  <td><div align="center"><strong>Total Deuda</strong></div></td>  
  </tr>
   
  <%  while f_valor_documentos.Siguiente
  total_2004 = total_2004 + cdbl(f_valor_documentos.ObtenerValor("_2004_"))
  total_2005 = total_2005 + cdbl(f_valor_documentos.ObtenerValor("_2005_"))
  total_2006=total_2006 + cdbl(f_valor_documentos.ObtenerValor("_2006_"))
  total_2007=total_2007 + cdbl(f_valor_documentos.ObtenerValor("_2007_"))
  total_2008=total_2008 + cdbl(f_valor_documentos.ObtenerValor("_2008_"))
  total_2009=total_2009 + cdbl(f_valor_documentos.ObtenerValor("_2009_"))
  total=total + cdbl(f_valor_documentos.ObtenerValor("total"))
  %>
  
  <tr> 
    
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("estado")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("_2004_")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("_2005_")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("_2006_")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("_2007_")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("_2008_")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("_2009_")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("total")%></div></td>
  </tr>
   
  <%  wend %>
  
     
  <tr> 
    
    <td><div align="center"><strong>Total</strong></div></td>
	<td><div align="right"><%=total_2004%></div></td>
	<td><div align="right"><%=total_2005%></div></td>
	 <td><div align="right"><%=total_2006%></div></td>
	  <td><div align="right"><%=total_2007%></div></td>
	  <td><div align="right"><%=total_2008%></div></td>
	  <td><div align="right"><%=total_2009%></div></td>
	  <td><div align="right"><%=total%></div></td>
  </tr>
</table>
</body>
</html>