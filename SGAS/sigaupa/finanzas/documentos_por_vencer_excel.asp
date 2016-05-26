<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 5000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_documentos_por_vencer.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
q_anos_ccod =Request.QueryString("anos_ccod")
q_mes_ccod = Request.QueryString("mes_ccod")
'response.Write("<pre>"&q_anos_ccod&"</pre>")
'response.Write("<pre>"&q_mes_ccod&"</pre>")
'response.End()
set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

'sql_listado_documentos_pendientes="select ''"

sql_listado_documentos_pendientes = "select matr_ncorr,rut,nombre,caja,ting_ccod,num_docto,monto,banco_ccod,fecha_vencimiento,estado,sede_actual,banco,tipo_docto,estado_matricula,carrera,sede_carrera,sede_actuali,rut_apo,nombres_apo,dire_apo,comuna_ciudad,anio,mes from documentos_por_vencer_listado where anio="&q_anos_ccod&" and mes="&q_mes_ccod&" order by nombre"     
						


	
	
	
response.Write("<pre>"&sql_listado_documentos_pendientes&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql_listado_documentos_pendientes

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="75%" border="1">
  
 
  
  <td><div align="center"><strong>rut</strong></div></td>
  <td><div align="center"><strong>Nombre</strong></div></td>
    <td><div align="center"><strong>caja</strong></div></td>
	<td><div align="center"><strong>num_docto</strong></div></td>
	<td><div align="center"><strong>monto</strong></div></td>
    <td><div align="center"><strong>fecha de vencimiento</strong></div></td>
    <td><div align="center"><strong>Estado</strong></div></td>
	<td><div align="center"><strong>Banco</strong></div></td>
	<td><div align="center"><strong>Tipo Docto</strong></div></td>
	<td><div align="center"><strong>Estado Matricula</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
	<td><div align="center"><strong>Sede Carrera</strong></div></td>
	<td><div align="center"><strong>Sede Actual</strong></div></td>
	<td><div align="center"><strong>Rut Apoderado</strong></div></td>
	<td><div align="center"><strong>Nombre Apoderado</strong></div></td>
	<td><div align="center"><strong>Direccion Apoderado</strong></div></td>
	<td><div align="center"><strong>Comuna-Ciudad</strong></div></td>
	
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  
  
  <tr> 
    
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("caja")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("num_docto")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("monto")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("fecha_vencimiento")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("estado")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("banco")%></div></td>
	<td><div align="right"><%=f_valor_documentos.ObtenerValor("tipo_docto")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("estado_matricula")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede_carrera")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede_actuali")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("rut_apo")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("nombres_apo")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("direccion_apo")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("comuna_ciudad")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>