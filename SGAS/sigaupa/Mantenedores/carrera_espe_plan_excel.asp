<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=datos_generales.xls"
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

consulta =  "  select carr_tdesc,espe_tdesc,c.plan_tdesc,a.carr_ccod ,   " & vbCrlf & _
			"  b.espe_ccod ,c.plan_ccod,d.epes_tdesc as estado_plan,plan_nresolucion as resolucion,  " & vbCrlf & _
			"  espe_nduracion as duracion,espe_ttitulo as titulo,ttit_tdesc as tipo_titulo  " & vbCrlf & _
			"  from carreras a, especialidades b , planes_estudio c,estados_plan_estudio d,tipos_titulos e  " & vbCrlf & _
			"  where a.carr_ccod=b.carr_ccod  " & vbCrlf & _
			"  and b.espe_ccod=c.espe_ccod   " & vbCrlf & _
			"  and c.epes_ccod=d.epes_ccod  " & vbCrlf & _
			"  and b.ttit_ccod=e.ttit_ccod  " & vbCrlf & _
			"  order  by carr_tdesc,espe_tdesc,plan_tdesc " & vbCrlf
			

tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Carreras con especialidades y planes de estudio</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Carreras con especialidades y planes de estudio</font></div>
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
    <td><div align="center"><strong>Fila</strong></div></td>
    <td><div align="center"><strong>Cód. Carrera</strong></div></td>
    <td><div align="center"><strong>Carrera</strong></div></td>
	<td><div align="center"><strong>Cód. Especialidad</strong></div></td>
    <td><div align="center"><strong>Especiliadad</strong></div></td>
	<td><div align="center"><strong>Cód. Plan</strong></div></td>
	<td><div align="center"><strong>Estado Plan</strong></div></td>
	<td><div align="center"><strong>N° Resolución</strong></div></td>
	<td><div align="center"><strong>Duración</strong></div></td>
	<td><div align="center"><strong>Título</strong></div></td>
	<td><div align="center"><strong>Tipo Título</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("carr_ccod")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("carr_tdesc")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("espe_ccod")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("espe_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("plan_ccod")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("estado_plan")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("resolucion")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("duracion")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("titulo")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("tipo_titulo")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>