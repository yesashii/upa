<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=carga_academica.doc"
Response.ContentType = "application/vnd.ms-word"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

rut = request.Form("rut")
nombres = request.Form("nombres")
carrera = request.Form("carrera")
estado = request.Form("estado")
periodo = request.Form("periodo")
especialidad_plan = request.Form("especialidad_plan")
tabla_parciales = request.Form("tabla_parciales")
fecha2 =conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>NOTAS PARCIALES</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">NOTAS PARCIALES</font></div></td>
 </tr>
 <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
       <td colspan="4" align="left"><%response.Write("Rut: <strong>"&rut&"</strong>")%></td>
  </tr>
  <tr>
       <td colspan="4" align="left"><%response.Write("Nombre: <strong>"&nombres&"</strong>")%></td>
  </tr>
  <tr>
      <td colspan="4" align="left"><%response.Write("Carrera: <strong>"&carrera&"</strong>")%></td>
  </tr>
  <tr>
      <td colspan="4" align="left"><%response.Write("Estado: <strong>"&estado&"</strong>")%></td>
  </tr>
    <tr>
      <td colspan="4" align="left"><%response.Write("Periodo: <strong>"&periodo&"</strong>")%></td>
  </tr>
  <tr>
      <td colspan="4" align="left"><%response.Write("Fecha Actual: <strong>"&fecha2&"</strong>")%></td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4"><%=tabla_parciales%></td>
  </tr>
</table>
</body>
</html>