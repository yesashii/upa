<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=malla_curricular.xls"
Response.ContentType = "application/vnd.ms-excel"
'Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

rut = request.Form("rut")
nombres = request.Form("nombres")
carrera = request.Form("carrera")
estado = request.Form("estado")
periodo = request.Form("periodo")
especialidad_plan = request.Form("especialidad_plan")
total_columnas = request.Form("total_columnas")
total_filas = request.Form("total_filas")

fecha2 =conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Postulaciones Otec</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">MALLA CURRICULAR</font></div></td>
 </tr>
  <tr> 
    <td colspan="4"><div align="center"><font size="2" face="Arial, Helvetica, sans-serif"><%=especialidad_plan%></font></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
       <td colspan="4"><%response.Write("Rut: <strong>"&rut&"</strong>")%></td>
  </tr>
  <tr>
       <td colspan="4"><%response.Write("Nombre: <strong>"&nombres&"</strong>")%></td>
  </tr>
  <tr>
      <td colspan="4"><%response.Write("Carrera: <strong>"&carrera&"</strong>")%></td>
  </tr>
  <tr>
      <td colspan="4"><%response.Write("Estado: <strong>"&estado&"</strong>")%></td>
  </tr>
    <tr>
      <td colspan="4"><%response.Write("Periodo: <strong>"&periodo&"</strong>")%></td>
  </tr>
  <tr>
      <td colspan="4"><%response.Write("Fecha Actual: <strong>"&fecha2&"</strong>")%></td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4" align="left">
	     <table align="left" width="100%" cellpadding="0" cellspacing="0">
		    <tr>
				<%columna = 1
				  while columna <= cint(total_columnas)
				       valor = request.Form("malla_0_"&columna)
					   color = request.Form("color_0_"&columna)
					   if valor = "" then
					      valor = "&nbsp;"
					   end if
				       response.write("<td bgcolor='"&color&"' bordercolor='#0033CC' align='center'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>"&valor&"</strong></font></td>")
				    columna = columna + 1 
				  wend%>
			</tr>
			<%fila = 1
			  while fila <= cint(total_filas) %>
			   <tr>
				<%columna = 1
				  while columna <= cint(total_columnas)
				       valor = request.Form("malla_"&fila&"_"&columna)
					   color = request.Form("color_"&fila&"_"&columna)
					   if valor = "" then
					      valor = "&nbsp;"
					   end if
					   if color = "" then
					      color = "#FFFFFF"
					   end if
				       response.write("<td bgcolor='"&color&"' align='center'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&valor&"</strong></font></td>")
				    columna = columna + 1 
				  wend%>
			</tr>
			<%fila = fila + 1
			  wend%>	
		 </table>	
	  </td>
  </tr>
</table>
</body>
</html>