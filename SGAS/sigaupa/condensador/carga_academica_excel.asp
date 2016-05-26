<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=carga_academica.xls"
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
total_fila_carga = request.Form("total_fila_carga")
total_sede = request.Form("total_sede")
fecha2 =conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Carga académica del alumno</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">CARGA ACADÉMICA</font></div></td>
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
  	  <td colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Listado de Cargas del período</strong></font></td>
  </tr>
  <tr>
  	  <td colspan="4" align="left">
	     <table align="left" width="100%" cellpadding="0" cellspacing="0">
		    <tr>
				<th bgcolor="#d1e3fa" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>C&oacute;digo</strong></font></th>
				<th bgcolor="#d1e3fa" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Asignatura</strong></font></th>
				<th bgcolor="#d1e3fa" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Secci&oacute;n</strong></font></th>
				<th bgcolor="#d1e3fa" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Tipo</strong></font></th>
				<th bgcolor="#d1e3fa" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Cr&eacute;ditos</strong></font></th>
			</tr>
			<%fila = 1
			  while fila <= cint(total_fila_carga) 
             %>
			   <tr bgcolor="<%=color%>">
				<%     codigo = request.Form("carga_"&fila&"_1")
        			   asignatura = request.Form("carga_"&fila&"_2")
					   seccion = request.Form("carga_"&fila&"_3")
					   tipo = request.Form("carga_"&fila&"_2")
					   credito = request.Form("carga_"&fila&"_3")
					   
     			       response.write("<td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&codigo&"</strong></font></td>")
                       response.write("<td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&asignatura&"</strong></font></td>")
					   response.write("<td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&seccion&"</strong></font></td>")
					   response.write("<td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&tipo&"</strong></font></td>")
					   response.write("<td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&credito&"</strong></font></td>")
				 %>
			</tr>
			<%fila = fila + 1
			  wend%>	
		 </table>	
	  </td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Horario de clases</strong></font></td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4">
	     <%
			response.write("<table width='98%' border='1' bordercolor='#999999' bgcolor='#FFFFFF' cellspacing='2' cellpadding='2'>")
			contador1 = 0
			   while ( contador1 <= cint(total_sede) )
				  contador2 = 0
				  response.write("<tr>")
			   	  while ( contador2 <= 6 )
					  valor_muestra = request.Form("horario_"&contador1&"_"&contador2)
					  color_celda = "#ffffff"
					  alineacion = "left"
					  if contador1 = 0 then
							color_celda = "#d1e3fa"
							alineacion = "center"
					  end if
					  response.write("		<td  align='"+alineacion+"' bgcolor='"+color_celda+"'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'>"&valor_muestra&"</font></td>")
					  contador2 = contador2 + 1
				  wend
				  contador1 = contador1 + 1
			      response.write("</tr>")
			  wend
		    response.write("</table>")
		  %>
	  </td>
  </tr>
  
</table>
</body>
</html>