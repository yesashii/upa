<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=incidentes.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

'-----------------------------------------------------------------------
folio_buscar=request.QueryString("folio_buscar")
servidor=request.QueryString("servidor")
fecha=conexion.consultaUno("select getDate() as fecha")
'------------------------------------------------------------------------------------

set formulario = new cformulario
formulario.carga_parametros "tabla_vacia.xml", "tabla"
formulario.inicializar conexion

consulta =" select inci_ccod,protic.trunc(fecha_incidente) + ' ' + hora_incidente as fecha_incidente, lower(incidente) as incidente,solucion_planteada, "& vbCrLf &_
		  " isnull((select serv_tdesc from servidores tt where tt.serv_ccod=a.serv_ccod),'') as servidor, "& vbCrLf &_
		  " isnull((select ered_tdesc from ELEMENTOS_DE_RED tt where tt.ered_ccod=a.ered_ccod),'') as elementos_red, "& vbCrLf &_
		  " isnull((select cele_tdesc from COMPONENTES_ELECTRICOS tt where tt.cele_ccod=a.cele_ccod),'') as componentes, "& vbCrLf &_
		  " status_solucion as status, "& vbCrLf &_
		  " protic.trunc(fecha_solucion)+' '+hora_solucion as fecha_solucion, "& vbCrLf &_
		  " protic.initCap(personal_tecnico) as personal_tecnico, fecha_incidente as ff, "& vbCrLf &_
		  " isnull((select einc_tdesc from ESTADOS_INCIDENTES tt where tt.einc_ccod=a.einc_ccod),'') as estado_final, "& vbCrLf &_
		  " case primera_vez when 'N' then 'NO' else 'SI' end as primera_vez,case incidente_mayor when 'N' then 'NO' else 'SI' end as incidente_mayor,lower(observaciones) as observaciones  "& vbCrLf &_
		  " from INCIDENTES  a where 1=1 "
		  
if folio_buscar <> "" then
	consulta = consulta & " and inci_ccod like '%"&folio_buscar&"%'"
end if
if servidor <> "" then
	consulta = consulta & " and serv_ccod = '"&servidor&"'"
end if
'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta & " order by ff desc"


%>
<html>
<head>
<title>Incidentes registrados</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Incidentes Registrados</font></div></td>
 </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =fecha%> </td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td bgcolor="#6699CC"><div align="center"><strong>Folio</strong></div></td>
    <td bgcolor="#6699CC"><div align="center"><strong>Fecha Incidente</strong></div></td>
    <td bgcolor="#6699CC"><div align="center"><strong>Incidente</strong></div></td>
	<td bgcolor="#6699CC"><div align="center"><strong>Equipo</strong></div></td>
	<td bgcolor="#6699CC"><div align="center"><strong>Elementos Red</strong></div></td>
	<td bgcolor="#6699CC"><div align="center"><strong>Otros</strong></div></td>
	<td bgcolor="#6699CC"><div align="center"><strong>Solución planteada</strong></div></td>
	<td bgcolor="#6699CC"><div align="center"><strong>Status</strong></div></td>
    <td bgcolor="#6699CC"><div align="center"><strong>Fecha solución</strong></div></td>
    <td bgcolor="#6699CC"><div align="center"><strong>Personal Técnico</strong></div></td>
	<td bgcolor="#FF9933"><div align="center"><strong>Estado Incidente</strong></div></td>
	<td bgcolor="#6699CC"><div align="center"><strong>Primera vez que ocurre</strong></div></td>
	<td bgcolor="#6699CC"><div align="center"><strong>Parte de incidente mayor</strong></div></td>
	<td bgcolor="#6699CC"><div align="center"><strong>Observaciones</strong></div></td>
  </tr>
  <%  while formulario.Siguiente %>
  <tr> 
    <td><div align="left"><%=formulario.ObtenerValor("inci_ccod")%></div></td>
    <td><div align="center"><%=formulario.ObtenerValor("fecha_incidente")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("incidente")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("servidor")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("elementos_red")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("componentes")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("solucion_planteada")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("status")%></div></td>
    <td><div align="center"><%=formulario.ObtenerValor("fecha_solucion")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("personal_tecnico")%></div></td>
	<td  bgcolor="#FF9933"><div align="left"><%=formulario.ObtenerValor("estado_final")%></div></td>
	<td><div align="center"><%=formulario.ObtenerValor("primera_vez")%></div></td>
	<td><div align="center"><%=formulario.ObtenerValor("incidente_mayor")%></div></td>
	<td><div align="center"><%=formulario.ObtenerValor("observaciones")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>