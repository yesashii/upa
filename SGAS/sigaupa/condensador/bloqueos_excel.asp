<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=bloqueos.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

rut = request.Form("rut")
nombres = request.Form("nombres")
carrera = request.Form("carrera")
estado = request.Form("estado")
periodo = request.Form("periodo")
especialidad_plan = request.Form("especialidad_plan")

tabla_bloqueos= request.Form("tabla_bloqueos")


fecha2 =conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>HISTORIAL DE BLOQUEOS</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">HISTORIAL DE BLOQUEOS</font></div></td>
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
	  <td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>HISTORIAL DE BLOQUEOS</strong></font></td>
  </tr>
  <tr>
      <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
      <td colspan="4"><%=tabla_bloqueos%></td>
  </tr>
</table>
</body>
</html>