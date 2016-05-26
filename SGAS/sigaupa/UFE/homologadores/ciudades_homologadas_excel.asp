<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=Ciudades_Homologadas.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'carr_tdesc = request.querystring("carr_tdesc")
'carrera = carr_tdesc
'
if carrera="" then
	carrera=" Todas las Ciudades"
end if	

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion


consulta =  "select a.ciudh_ccod,a.ciudh_ccod as eliminar , a.uhciu_ccod,a.ciud_ccod,(b.nombre_comuna+' '+b.nombre_ciudad) as DireccionA," & vbCrlf & _ 
	        "(c.ciud_tcomuna+' '+c.ciud_tdesc) as DireccionB "& vbCrlf & _ 
		    "from ufe_ciudades_homologadas a, ufe_ciudades b, ciudades c " & vbCrlf & _
		    "where a.uhciu_ccod=b.uhciu_ccod and a.ciud_ccod=c.ciud_ccod " 
			
			

tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Carreras Homologadas</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Ciudades Homologadas</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="8%"><strong></strong></td>
    <td width="92%" colspan="3"></td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fila</strong></div></td>
    <td><div align="center"><strong>Direccion SGA</strong></div></td>
    <td><div align="center"><strong>Direccion Ingresa</strong></div></td>
</tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("DireccionB")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("DireccionA")%></div></td>
 </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>