<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=Carreras_mineduc.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'carr_tdesc = request.querystring("carr_tdesc")
'carrera = carr_tdesc


if carrera="" then
	carrera=" Todas las carreras"
end if	

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion


consulta =  "  select UHCIU_CCOD, CODIGO_REGION, NOMBRE_REGION,  " & vbCrlf & _
		    " CODIGO_COMUNA, NOMBRE_COMUNA, CODIGO_CIUDAD, NOMBRE_CIUDAD  " & vbCrlf & _
 			" from  ufe_ciudades" & vbCrlf & _
			" order  by CODIGO_REGION" 

			

tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Comunas Mineduc</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Carreras Ingresa</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>FILA</strong></div></td>
    <td><div align="center"><strong>CODIGO REGION</strong></div></td>
    <td><div align="center"><strong>NOMBRE REGION</strong></div></td>
    <td><div align="center"><strong>CODIGO COMUNA</strong></div></td>
    <td><div align="center"><strong>NOMBRE COMUNA</strong></div></td>
	<td><div align="center"><strong>CODIGO CIUDAD</strong></div></td>
    <td><div align="center"><strong>NOMBRE CIUDAD</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("CODIGO_REGION")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("NOMBRE_REGION")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("CODIGO_COMUNA")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("NOMBRE_COMUNA")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("CODIGO_CIUDAD")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("NOMBRE_CIUDAD")%></div></td>
 </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>