<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=curriculum.xls"
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

nombre_fp= request.Form("nombre_fp")
fnacimiento_fp= request.Form("fnacimiento_fp")
direccion_fp= request.Form("direccion_fp")
ciud_tdesc_fp= request.Form("ciud_tdesc_fp")
ciud_tcomuna_fp= request.Form("ciud_tcomuna_fp")
regi_tdesc_fp= request.Form("regi_tdesc_fp")
dire_tcelular_fp= request.Form("dire_tcelular_fp")
dire_tfono_fp= request.Form("dire_tfono_fp")
nacionalidad_fp= request.Form("nacionalidad_fp")
estado_civil_fp= request.Form("estado_civil_fp")
sexo_fp= request.Form("sexo_fp")
pers_temail_fp= request.Form("pers_temail_fp")
pers_temail2_fp= request.Form("pers_temail2_fp")
tabla_cursos= request.Form("tabla_cursos")
tabla_laboral= request.Form("tabla_laboral")
tabla_practica= request.Form("tabla_practica")
tabla_actividades= request.Form("tabla_actividades")
tabla_idiomas= request.Form("tabla_idiomas")
tabla_software= request.Form("tabla_software")
profesionales= request.Form("profesionales")
tecnicas= request.Form("tecnicas")
personales= request.Form("personales")
laborales= request.Form("laborales")

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
	  <td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>DATOS PERSONALES</strong></font></td>
  </tr>
  <tr>
      <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
      <td colspan="4">
	    <table width="100%" cellpadding="0" cellspacing="0">
	      <tr>
		  		<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombres :</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Fecha Nacimiento :</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>&nbsp;</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>&nbsp;</strong></font></td>
		  </tr>
		  <tr>
		  		<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=nombre_fp%></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fnacimiento_fp%></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
		  </tr>
		  <tr>
		  		<td colspan="4" height="20">&nbsp;</td>
		  </tr>
		  <tr>
		  		<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Dirección :</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Comuna :</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Ciudad :</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Región :</strong></font></td>
		  </tr>
		  <tr>
		  				
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=direccion_fp%></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=ciud_tdesc_fp%></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=ciud_tcomuna_fp%></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=regi_tdesc_fp%></font></td>
		  </tr>
		  <tr>
		  		<td colspan="4" height="20">&nbsp;</td>
		  </tr>
		  <tr>
		  		<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Celular :</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Telefono :</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nacionalidad :</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>&nbsp;</strong></font></td>
		  </tr>
		  <tr>
		  				
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=dire_tcelular_fp%></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=dire_tfono_fp%></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=nacionalidad_fp%></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
		  </tr>
		  <tr>
		  		<td colspan="4" height="20">&nbsp;</td>
		  </tr>
		  <tr>
		  		<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado Civil :</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Sexo :</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>&nbsp;</strong></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>&nbsp;</strong></font></td>
		  </tr>
		  <tr>
		  				
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=estado_civil_fp%></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=sexo_fp%></font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
				<td width="25%" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
		  </tr>
		  <tr>
		  		<td colspan="4" height="20">&nbsp;</td>
		  </tr>
		  <tr>
		  		<td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Email 1 : </strong></font></td>
		  </tr>
		  <tr>
		  				
				<td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=pers_temail_fp%></font></td>
		  </tr>
		  <tr>
		  		<td colspan="4" height="20">&nbsp;</td>
		  </tr>
		  <tr>
		  		<td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Email 2 : </strong></font></td>
		  </tr>
		  <tr>
		  				
				<td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=pers_temail2_fp%></font></td>
		  </tr>
		  <tr>
		  		<td colspan="4" height="20">&nbsp;</td>
		  </tr>
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
	  <td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>CURSOS Y DIPLOMADOS</strong></font></td>
  </tr>
  <tr>
      <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
      <td colspan="4"><%=tabla_cursos%></td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
	  <td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>EXPERIENCIA LABORAL</strong></font></td>
  </tr>
  <tr>
      <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
      <td colspan="4"><%=tabla_laboral%></td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
	  <td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>PRÁCTICA LABORAL</strong></font></td>
  </tr>
  <tr>
      <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
      <td colspan="4"><%=tabla_practica%></td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
	  <td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>ACTIVIDADES TEMPRANAS</strong></font></td>
  </tr>
  <tr>
      <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
      <td colspan="4"><%=tabla_actividades%></td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
	  <td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>IDIOMAS</strong></font></td>
  </tr>
  <tr>
      <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
      <td colspan="4"><%=tabla_idiomas%></td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
	  <td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>DOMINIO DE SOFTWARE</strong></font></td>
  </tr>
  <tr>
      <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
      <td colspan="4"><%=tabla_software%></td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
	  <td colspan="4" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>HABILIDADES</strong></font></td>
  </tr>
  <tr>
      <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="4" align="left">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20%"><font face="Times New Roman, Times, serif" size="2" color="#777777"><strong>HABILIDADES PROFESIONALES</strong></font></td>
				<td width="3%"><font face="Times New Roman, Times, serif" size="2" color="#777777"><strong>:</strong></font></td>
				<td width="77%"><font face="Times New Roman, Times, serif" size="1" color="#000000"><%=profesionales%></font></td>
			</tr>
			<tr>
				<td width="20%"><font face="Times New Roman, Times, serif" size="2" color="#777777"><strong>HABILIDADES TÉCNICAS</strong></font></td>
				<td width="3%"><font face="Times New Roman, Times, serif" size="2" color="#777777"><strong>:</strong></font></td>
				<td width="77%"><font face="Times New Roman, Times, serif" size="1" color="#000000"><%=tecnicas%></font></td>
			</tr>
			<tr>
				<td width="20%"><font face="Times New Roman, Times, serif" size="2" color="#777777"><strong>HABILIDADES PERSONALES</strong></font></td>
				<td width="3%"><font face="Times New Roman, Times, serif" size="2" color="#777777"><strong>:</strong></font></td>
				<td width="77%"><font face="Times New Roman, Times, serif" size="1" color="#000000"><%=personales%></font></td>
			</tr>
			<tr>
				<td width="20%"><font face="Times New Roman, Times, serif" size="2" color="#777777"><strong>AREAS EN LAS QUE DESEA TRABAJAR</strong></font></td>
				<td width="3%"><font face="Times New Roman, Times, serif" size="2" color="#777777"><strong>:</strong></font></td>
				<td width="77%"><font face="Times New Roman, Times, serif" size="1" color="#000000"><%=laborales%></font></td>
			</tr>
		</table>
	</td>
  </tr>
</table>
</body>
</html>