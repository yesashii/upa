<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=carreras.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

carr_tdesc = request.querystring("carr_tdesc")
carrera = carr_tdesc

if carrera="" then
	carrera=" Todas las carreras"
end if	

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

consulta ="    select a.carr_ccod,a.carr_tdesc,area_tdesc,inst_trazon_social,d.ecar_tdesc,e.facu_tdesc,f.tcar_tdesc, " & vbCrlf & _
		  "    isnull(acar_tdesc,'') as acar_tdesc,isnull(saca_tdesc,'') as saca_tdesc  " & vbCrlf & _
		  "    from " & vbCrlf & _
		  "       carreras a join areas_academicas b " & vbCrlf & _
		  "         on a.area_ccod = b.area_ccod" & vbCrlf & _
		  "       join instituciones c " & vbCrlf & _
		  "         on a.inst_ccod = c.inst_ccod " & vbCrlf & _
		  "       join estados_de_carreras d " & vbCrlf & _
		  "         on a.ecar_ccod = d.ecar_ccod  " & vbCrlf & _
		  "       join facultades e " & vbCrlf & _
		  "         on a.inst_ccod = e.inst_ccod and b.facu_ccod = e.facu_ccod " & vbCrlf & _
		  "       left outer join tipos_carrera f   " & vbCrlf & _
		  "         on a.tcar_ccod = f.tcar_ccod " & vbCrlf & _
		  "       left outer join areas_carreras g " & vbCrlf & _
		  "         on a.acar_ccod=g.acar_ccod " & vbCrlf & _
		  "       left outer join sub_areas_carreras h   " & vbCrlf & _
		  "         on a.saca_ccod = h.saca_ccod " & vbCrlf & _						
		  "  where a.carr_tdesc like '%"&carr_tdesc&"%' " & vbCrlf & _
		  "  order  by carr_tdesc"

tabla.consultar consulta 

'response.Write("<pre>"&consulta&"</pre>")

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Carreras</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Carreras</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="8%"><strong>Carrera</strong></td>
    <td width="92%" colspan="3"><strong>:</strong> <%=Carrera%> </td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="3%"><div align="center"><strong>Fila</strong></div></td>
    <td width="7%"><div align="center"><strong>Código</strong></div></td>
    <td width="25%"><div align="center"><strong>Carrera</strong></div></td>
	<td width="5%"><div align="center"><strong>Área</strong></div></td>
    <td width="5%"><div align="center"><strong>Estado</strong></div></td>
	<td width="10%"><div align="center"><strong>Facultad</strong></div></td>
	<td width="10%"><div align="center"><strong>Tipo</strong></div></td>
	<td width="10%"><div align="center"><strong>Área Carrera</strong></div></td>
	<td width="10%"><div align="center"><strong>Sub Área Carrera</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("carr_ccod")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("carr_tdesc")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("area_tdesc")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("ecar_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("facu_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("tcar_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("acar_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("saca_tdesc")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>