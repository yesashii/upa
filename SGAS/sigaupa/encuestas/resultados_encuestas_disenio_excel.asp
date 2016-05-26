<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=encuestas_disenio.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

tipo = request.QueryString("tipo")
fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")

set f_listado = new CFormulario
f_listado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_listado.Inicializar conexion

if tipo = "ALUMNO" then 
consulta =  " select cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, "& vbCrLf &_
			" b.pers_tape_paterno + ' ' + b.pers_tape_materno + ', '+ b.pers_tnombre as alumno, "& vbCrLf &_
			" c.sexo_tdesc as sexo, edad, anio_ingreso,consideraciones, "& vbCrLf &_
			" case espacios_escenograficos when 1 then 'X' else '' end as espacios_escenograficos, "& vbCrLf &_
			" case espacios_equipamiento when 1 then 'X' else '' end as espacios_equipamiento, "& vbCrLf &_
			" case espacios_efimeras when 1 then 'X' else '' end as espacios_efimeras, "& vbCrLf &_
			" case espacios_sustentable when 1 then 'X' else '' end as espacios_sustentable, "& vbCrLf &_
			" case espacios_comerciales when 1 then 'X' else '' end as espacios_comerciales, "& vbCrLf &_
			" case espacios_exposiciones when 1 then 'X' else '' end as espacios_exposiciones, "& vbCrLf &_
			" case espacios_intervenciones when 1 then 'X' else '' end as espacios_intervenciones, "& vbCrLf &_
			" espacios_otros,materias_complementarias "& vbCrLf &_
			" from encuestas_disenio a, personas b,sexos c "& vbCrLf &_
			" where tipo='"&tipo&"' "& vbCrLf &_    
			" and a.pers_ncorr_encuestado = b.pers_ncorr "& vbCrLf &_
			" and a.sexo_ccod=c.sexo_ccod  "& vbCrLf &_
			" order by alumno "
elseif tipo = "PROFESOR" then 
consulta =  " select cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, "& vbCrLf &_
			" b.pers_tape_paterno + ' ' + b.pers_tape_materno + ', '+ b.pers_tnombre as profesor, "& vbCrLf &_ 
			" c.sexo_tdesc as sexo,profesion,case clases_disenio when 1 then 'Sí' else 'No' end as clases_Diseño, "& vbCrLf &_
			" case clases_disenio_grafico when 1 then 'Sí' else 'No' end as clases_Diseño_grafico, "& vbCrLf &_
			" case ejerce_profesion when 1 then 'Sí' else 'No' end as ejerce_profesion, "& vbCrLf &_
			" consideraciones, "& vbCrLf &_
			" case espacios_escenograficos when 1 then 'X' else '' end as espacios_escenograficos, "& vbCrLf &_
			" case espacios_equipamiento when 1 then 'X' else '' end as espacios_equipamiento, "& vbCrLf &_		
			" case espacios_efimeras when 1 then 'X' else '' end as espacios_efimeras, "& vbCrLf &_
			" case espacios_sustentable when 1 then 'X' else '' end as espacios_sustentable, "& vbCrLf &_
			" case espacios_comerciales when 1 then 'X' else '' end as espacios_comerciales, "& vbCrLf &_
			" case espacios_exposiciones when 1 then 'X' else '' end as espacios_exposiciones, "& vbCrLf &_
			" case espacios_intervenciones when 1 then 'X' else '' end as espacios_intervenciones, "& vbCrLf &_
			" espacios_otros,materias_complementarias "& vbCrLf &_
			" from encuestas_disenio a, personas b,sexos c "& vbCrLf &_
			" where tipo='"&tipo&"'     "& vbCrLf &_
			" and a.pers_ncorr_encuestado = b.pers_ncorr "& vbCrLf &_
			" and a.sexo_ccod=c.sexo_ccod  "& vbCrLf &_
			" order by profesor "
elseif tipo = "PROFESIONAL" then 
consulta =	" select nombre_profesional, apellidos_profesional,profesion, empresa_profesional, "& vbCrLf &_
			" consideraciones, "& vbCrLf &_
			" case espacios_escenograficos when 1 then 'X' else '' end as espacios_escenograficos, "& vbCrLf &_
			" case espacios_equipamiento when 1 then 'X' else '' end as espacios_equipamiento, "& vbCrLf &_
			" case espacios_efimeras when 1 then 'X' else '' end as espacios_efimeras, "& vbCrLf &_
			" case espacios_sustentable when 1 then 'X' else '' end as espacios_sustentable, "& vbCrLf &_
			" case espacios_comerciales when 1 then 'X' else '' end as espacios_comerciales, "& vbCrLf &_
			" case espacios_exposiciones when 1 then 'X' else '' end as espacios_exposiciones, "& vbCrLf &_
			" case espacios_intervenciones when 1 then 'X' else '' end as espacios_intervenciones, "& vbCrLf &_
			" espacios_otros,materias_complementarias"& vbCrLf &_ 
			" from encuestas_disenio a "& vbCrLf &_
			" where tipo='"&tipo&"'     "& vbCrLf &_
			" order by apellidos_profesional "
end if
'response.Write(consulta)
f_listado.Consultar consulta

%>
<html>
<head>
<title>Resultados Encuesta Disenio</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resultados Encuesta Diseño</font></div>
      <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="10%"><strong>Fecha</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
   <tr> 
    <td width="10%"><strong>Encuestado</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=tipo%> (S,ES)</td>
  </tr>
</table>

<p>&nbsp;</p>
<table width="100%" border="1">
  <%if tipo= "ALUMNO" then %>
		  <tr> 
			<td bgcolor="#99FF99" align="center"><strong>N°</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>RUT</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>ALUMNO</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>SEXO</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>EDAD</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>ANIO INGRESO</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>¿Qué otras competencias específicas cree usted que deben ser incluidas y que no aparece en el listado anterior?</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>a) Diseño de Espacios Escenográficos</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>b) Diseño de Equipamiento de Interiores</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>c) Instalaciones Efímeras</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>d) Diseño Sustentable- Ecodiseño</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>e) Espacios Comerciales y Puntos de Venta</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>f) Diseño de Exposiciones y Espacios Culturales</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>g) Diseño de intervenciones en el espacio público y Equipamiento Urbano</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>h) Otro, ¿Cúal?</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>¿Qué nuevas materias emergentes y/o conocimientos cree usted que se  deben considerar en un plan de estudio de la carrera de Diseño?</strong></td>
		  </tr>
		  <%  fila = 1
		  while f_listado.Siguiente %>
		  <tr> 
			<td><div align="left"><%=fila%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("rut")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("alumno")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("sexo")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("edad")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("anio_ingreso")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("consideraciones")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_escenograficos")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_equipamiento")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_efimeras")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_sustentable")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_comerciales")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_exposiciones")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_intervenciones")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("espacios_otros")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("materias_complementarias")%></div></td>
		  </tr>
		  <% fila=fila + 1
		  wend %>
  <%elseif tipo= "PROFESOR" then %>
		  <tr> 
			<td bgcolor="#99FF99" align="center"><strong>N°</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>RUT</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>PROFESOR</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>SEXO</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>PROFESION</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>EJERCE PROFESION</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>Realiza clases en escuela de Diseño</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>Realiza clases en escuela de Diseño Gráfico</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>¿Qué otras competencias específicas cree usted que deben ser incluidas y que no aparece en el listado anterior?</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>a) Diseño de Espacios Escenográficos</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>b) Diseño de Equipamiento de Interiores</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>c) Instalaciones Efímeras</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>d) Diseño Sustentable- Ecodiseño</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>e) Espacios Comerciales y Puntos de Venta</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>f) Diseño de Exposiciones y Espacios Culturales</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>g) Diseño de intervenciones en el espacio público y Equipamiento Urbano</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>h) Otro, ¿Cúal?</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>¿Qué nuevas materias emergentes y/o conocimientos cree usted que se  deben considerar en un plan de estudio de la carrera de Diseño?</strong></td>
		  </tr>
		  <%  fila = 1
		  while f_listado.Siguiente %>
		  <tr> 
			<td><div align="left"><%=fila%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("rut")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("profesor")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("sexo")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("profesion")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("ejerce_profesion")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("clases_diseño")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("clases_Diseño_grafico")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("consideraciones")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_escenograficos")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_equipamiento")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_efimeras")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_sustentable")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_comerciales")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_exposiciones")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_intervenciones")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("espacios_otros")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("materias_complementarias")%></div></td>
		  </tr>
		  <% fila=fila + 1
		  wend %>
<%elseif tipo= "PROFESIONAL" then %>
		  <tr> 
			<td bgcolor="#99FF99" align="center"><strong>N°</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>NOMBRE</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>APELLIDOS</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>PROFESION</strong></td>
			<td bgcolor="#99FF99" align="center"><strong>EMPRESA</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>¿Qué otras competencias específicas cree usted que deben ser incluidas y que no aparece en el listado anterior?</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>a) Diseño de Espacios Escenográficos</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>b) Diseño de Equipamiento de Interiores</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>c) Instalaciones Efímeras</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>d) Diseño Sustentable- Ecodiseño</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>e) Espacios Comerciales y Puntos de Venta</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>f) Diseño de Exposiciones y Espacios Culturales</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>g) Diseño de intervenciones en el espacio público y Equipamiento Urbano</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>h) Otro, ¿Cúal?</strong></td>
			<td bgcolor="#99FF99" align="left"><strong>¿Qué nuevas materias emergentes y/o conocimientos cree usted que se  deben considerar en un plan de estudio de la carrera de Diseño?</strong></td>
		  </tr>
		  <%  fila = 1
		  while f_listado.Siguiente %>
		  <tr> 
			<td><div align="left"><%=fila%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("nombre_profesional")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("apellidos_profesional")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("profesion")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("empresa_profesional")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("consideraciones")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_escenograficos")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_equipamiento")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_efimeras")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_sustentable")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_comerciales")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_exposiciones")%></div></td>
			<td><div align="center"><%=f_listado.ObtenerValor("espacios_intervenciones")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("espacios_otros")%></div></td>
			<td><div align="left"><%=f_listado.ObtenerValor("materias_complementarias")%></div></td>
		  </tr>
		  <% fila=fila + 1
		  wend %>		  
  <%end if%>
  
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>