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
total_fila_carga = request.Form("total_filas")
fecha2 =conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Evaluación docente del alumno</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">EVALUACI&Oacute;N DOCENTE</font></div></td>
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
				<th bgcolor="#d1e3fa" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&oacute;odo</strong></font></th>
				<th bgcolor="#d1e3fa" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Docente</strong></font></th>
				<th bgcolor="#d1e3fa" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Avance</strong></font></th>
			</tr>
			<%fila = 1
			  while fila <= cint(total_fila_carga) 
             %>
			   <tr>
				<%     codigo = request.Form("encuesta_"&fila&"_asig_ccod")
        			   asignatura = request.Form("encuesta_"&fila&"_asig_tdesc")
					   periodo = request.Form("encuesta_"&fila&"_semestre")
					   docente = request.Form("encuesta_"&fila&"_docente")
					   avance = request.Form("encuesta_"&fila&"_avance")
					   
     			       response.write("<td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&codigo&"</strong></font></td>")
                       response.write("<td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&asignatura&"</strong></font></td>")
					   response.write("<td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&periodo&"</strong></font></td>")
					   response.write("<td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&docente&"</strong></font></td>")
					   response.write("<td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&avance&"% </strong></font></td>")
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
</table>
</body>
</html>