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
fila_detalle = request.Form("fila_detalle")
filas_becas = request.Form("filas_becas")
filas_comentarios = request.Form("filas_comentarios")
filas_morosidad = request.Form("filas_morosidad")
fecha2 =conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Cuenta Corriente</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">CUENTA CORRIENTE</font></div></td>
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
  	  <td colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Detalle de Compromisos</strong></font></td>
  </tr>
  <tr>
  	  <td colspan="4" align="left">
	     <table align="left" width="100%" cellpadding="0" cellspacing="0">
		    <%fila = 0
			if fila_detalle <> "" then
			  while fila < cint(fila_detalle) 
					   
					   periodo 			= request.Form("detalle_"&fila&"_periodo")
					   num_compromiso 	= request.Form("detalle_"&fila&"_num_compromiso")
					   n_item 			= request.Form("detalle_"&fila&"_item")
					   num_cuota		= request.Form("detalle_"&fila&"_num_cuota")
					   fecha_emision	= request.Form("detalle_"&fila&"_fecha_emision")
					   fecha_vencimiento= request.Form("detalle_"&fila&"_fecha_vencimiento")
					   docto_pactado	= request.Form("detalle_"&fila&"_docto_pactado")
					   num_docto        = request.Form("detalle_"&fila&"_num_docto")
					   estado_doc		= request.Form("detalle_"&fila&"_estado_doc")
					   monto			= request.Form("detalle_"&fila&"_monto")
					   abono			= request.Form("detalle_"&fila&"_abono")
					   abonos_doc       = request.Form("detalle_"&fila&"_abonos_doc")
					   saldo            = request.Form("detalle_"&fila&"_saldo")
					   color_c          = request.Form("detalle_"&fila&"_color")
					   
					   response.Write("<tr  bgcolor='"&color_c&"'>")
     			       response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&periodo&"</strong></font></td>")
                       response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&num_compromiso&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&n_item&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&num_cuota&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&fecha_emision&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&fecha_vencimiento&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&docto_pactado&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&num_docto&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&estado_doc&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&monto&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&abono&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&abonos_doc&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&saldo&"</strong></font></td>")
					   response.Write("</tr>")
				 
				 fila = fila + 1
			  wend
			  end if%>	
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
  	  <td colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Becas y Descuentos</strong></font></td>
  </tr>
  <tr>
  	  <td colspan="4" align="left">
	     <table align="left" width="100%" cellpadding="0" cellspacing="0">
		    <%fila = 0
			 if filas_becas <> "" then
			  while fila < cint(filas_becas) 
					   
					   num_contrato 	= request.Form("becas_"&fila&"_num_contrato")
					   tipo				= request.Form("becas_"&fila&"_tipo")
					   beneficio		= request.Form("becas_"&fila&"_benficio")
					   fecha_1			= request.Form("becas_"&fila&"_fecha")
					   monto_beneficio	= request.Form("becas_"&fila&"_monto_beneficio")
					   porc_matricula	= request.Form("becas_"&fila&"_porc_matricula")
					   porc_colegiatura	= request.Form("becas_"&fila&"_porc_colegiatura")
					   color_c2			= request.Form("becas_"&fila&"_color")
					   
					   response.Write("<tr  bgcolor='"&color_c2&"'>")
     			       response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&num_contrato&"</strong></font></td>")
                       response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&tipo&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&beneficio&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&fecha_1&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&monto_beneficio&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&porc_matricula&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&porc_colegiatura&"</strong></font></td>")
					   response.Write("</tr>")
				 
				 fila = fila + 1
			  wend
			 end if%>	
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
  	  <td colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Comentarios</strong></font></td>
  </tr>
  <tr>
  	  <td colspan="4" align="left">
	     <table align="left" width="100%" cellpadding="0" cellspacing="0">
		    <%fila = 0
			  if filas_comentarios <> "" then 
				  while fila < cint(filas_comentarios) 
						   
						   fecha_comentario   = request.Form("comentarios_"&fila&"_fecha_comentario")
						   detalle_comentario = request.Form("comentarios_"&fila&"_detalle_comentario")
						   tipo_comentario    = request.Form("comentarios_"&fila&"_tipo_comentario")
						   color_c3           = request.Form("comentarios_"&fila&"_color")
											   
						   response.Write("<tr  bgcolor='"&color_c3&"'>")
						   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&fecha_comentario&"</strong></font></td>")
						   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&detalle_comentario&"</strong></font></td>")
						   response.write("  <td align='center'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&tipo_comentario&"</strong></font></td>")
						   response.Write("</tr>")
					 
					 fila = fila + 1
				  wend
			  end if%>	
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
  	  <td colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Morosidad</strong></font></td>
  </tr>
  <tr>
  	  <td colspan="4" align="left">
	     <table align="left" width="100%" cellpadding="0" cellspacing="0">
		    <%fila = 0
			 if filas_morosidad <> "" then 
			  while fila < cint(filas_morosidad) 
					   
					   item_0			= request.Form("morosidad_"&fila&"_item")
					   n_cuota			= request.Form("morosidad_"&fila&"_n_cuota")
					   fecha_vencimiento= request.Form("morosidad_"&fila&"_fecha_vencimiento")
					   docto_pactado    = request.Form("morosidad_"&fila&"_docto_pactado")
					   n_docto			= request.Form("morosidad_"&fila&"_n_docto")
					   estado_doc		= request.Form("morosidad_"&fila&"_estado_doc")
					   monto			= request.Form("morosidad_"&fila&"_monto")
					   abono			= request.Form("morosidad_"&fila&"_abono")
					   saldo			= request.Form("morosidad_"&fila&"_saldo")
					   dias				= request.Form("morosidad_"&fila&"_dias")
					   interes			= request.Form("morosidad_"&fila&"_interes")
					   pagar			= request.Form("morosidad_"&fila&"_a_pagar")
					   color_c4			= request.Form("morosidad_"&fila&"_a_color")
								
										   
					   response.Write("<tr  bgcolor='"&color_c4&"'>")
     			       response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&item_0&"</strong></font></td>")
                       response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&n_cuota&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&fecha_vencimiento&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&docto_pactado&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&n_docto&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&estado_doc&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&monto&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&abono&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&saldo&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&dias&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&interes&"</strong></font></td>")
					   response.write("  <td align='left'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'><strong>"&pagar&"</strong></font></td>")
					   response.Write("</tr>")
				 
				 fila = fila + 1
			  wend
			  end if%>	
		 </table>	
	  </td>
  </tr>
</table>
</body>
</html>