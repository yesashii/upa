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
'
if carrera="" then
	carrera=" Todas las carreras"
end if	

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion


consulta ="  select car_min_ncorr,cod_carrera_min, nom_carrera_min  " & vbCrlf & _
			" from  ufe_carreras_mineduc" & vbCrlf & _
			" order  by nom_carrera_min" 

			

tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Carreras Mineduc</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Carreras Mineduc</font></div>
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
	
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("cod_carrera_min")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("nom_carrera_min")%></div></td>
 </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>