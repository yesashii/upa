<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=aranceles_ext.xls"
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


consulta= 	"select a.aran_ccor,a.aran_ccor as eliminar ,c.carr_tdesc, b.jorn_tdesc, a.anos_ccod, a.arancel_ext " & vbCrlf & _	
			" from ufe_aranceles_ext a, jornadas b, carreras c  " & vbCrlf & _	
			" where a.jorn_ccod=b.jorn_ccod and a.carr_ccod COLLATE Modern_Spanish_CI_AS= c.carr_ccod" 
			
			

			

tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Oferta Academica Ingresa</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Aranceles Ext</font></div>
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
    <td><div align="center"><strong>Fila</strong></div></td>
    <td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>Jornada</strong></div></td>
    <td><div align="center"><strong>Años</strong></div></td>
	 <td><div align="center"><strong>Arancel Ext</strong></div></td>
  </tr>
 
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("carr_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("jorn_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("anos_ccod")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("arancel_ext")%></div></td>
   </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>