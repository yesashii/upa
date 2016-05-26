<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=encuesta_directores_docentes_excel.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 450000

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

sede_ccod = request.QueryString("sede_ccod")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
todos = request.QueryString("todas")

periodo = negocio.obtenerPeriodoAcademico("TOMACARGA")

fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")

if (todos = "" or todos="N") then
 	 filtro = ""
else
	 filtro = " and (select count(*) from dir_encuesta_docente_hhrr tt where tt.secc_ccod=a.secc_ccod and tt.pers_ncorr=d.pers_ncorr) > 0 "
end if

set f_listado = new CFormulario
f_listado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_listado.Inicializar conexion

consulta = " select distinct sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada,  " & vbCrLf & _
		   " a.asig_ccod,e.asig_tdesc,a.secc_ccod,d.pers_ncorr,a.secc_tdesc,  " & vbCrLf & _
		   " cast(d.pers_nrut as varchar)+'-'+ d.pers_xdv as rut_docente,d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' + d.pers_tape_materno as docente,  " & vbCrLf & _
		   " (select case count(*) when 0 then 'No' else 'Si' end from dir_encuesta_docente_hhrr tt   " & vbCrLf & _
		   "  where tt.secc_ccod=a.secc_ccod and tt.pers_ncorr=d.pers_ncorr) as evaluado,  " & vbCrLf & _
		   " i.audi_fmodificacion as fecha,    " & vbCrLf & _
		   " i.derh_preg_I_1,i.derh_preg_I_2,i.derh_preg_I_3,i.derh_preg_I_4,i.derh_preg_I_5,  " & vbCrLf & _
		   " i.derh_preg_I_6,i.derh_preg_I_7,i.derh_preg_I_8,  " & vbCrLf & _
		   " i.derh_preg_I_9,i.derh_preg_I_10,i.derh_preg_II_1,i.derh_preg_II_2,i.derh_preg_II_3,i.derh_preg_II_4,  " & vbCrLf & _
		   " i.derh_preg_II_5,i.derh_preg_II_6,i.derh_preg_II_7,i.derh_preg_II_8,i.derh_preg_II_9,  " & vbCrLf & _
		   " i.derh_preg_II_10,i.derh_preg_II_11,i.derh_I_foraleza_debilidad,i.derh_II_foraleza_debilidad,  " & vbCrLf & _
		   " i.derh_III_a,i.derh_III_b,i.derh_III_c,i.derh_IV_fortaleza_debilidad,  " & vbCrLf & _
		   " j.pers_tnombre + ' ' + j.pers_tape_paterno + ' ' + j.pers_tape_materno as director  " & vbCrLf & _
		   " from secciones a join bloques_horarios b  " & vbCrLf & _
		   "    on a.secc_ccod=b.secc_ccod  " & vbCrLf & _
		   " join bloques_profesores c  " & vbCrLf & _
		   "    on b.bloq_ccod=c.bloq_ccod  " & vbCrLf & _
		   " join personas d  " & vbCrLf & _
		   "    on c.pers_ncorr=d.pers_ncorr  " & vbCrLf & _
		   " join asignaturas e  " & vbCrLf & _
		   "    on a.asig_ccod=e.asig_ccod  " & vbCrLf & _
		   " join sedes f  " & vbCrLf & _
		   "    on a.sede_ccod=f.sede_ccod  " & vbCrLf & _
		   " join carreras g  " & vbCrLf & _
		   "    on a.carr_ccod=g.carr_ccod  " & vbCrLf & _
		   " join jornadas h  " & vbCrLf & _
		   "    on a.jorn_ccod=h.jorn_ccod  " & vbCrLf & _	
		   " left outer join dir_encuesta_docente_hhrr i  " & vbCrLf & _
		   "    on a.secc_ccod = i.secc_ccod and d.pers_ncorr = i.pers_ncorr " & vbCrLf & _
		   " left outer join personas j  " & vbCrLf & _
		   "    on i.pers_ncorr_director = j.pers_ncorr  " & vbCrLf & _
		   " where cast(a.peri_ccod as varchar)='"&periodo&"'  "&filtro& vbCrLf & _
		   " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' and a.carr_ccod='"&carr_ccod&"' and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"'  " & vbCrLf & _
		   " order by docente " 
'response.Write("<pre>"&consulta&"</pre>")

f_listado.Consultar consulta
'response.End()
%>
<html>
<head>
<title>Resultados Evaluación de Directores a Docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="12"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resultados Evaluación de Directores a Docentes</font></div>
      <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="12">&nbsp;</td>
  </tr>
  <tr> 
    <td width="6%"><strong>Fecha</strong></td>
    <td width="94%" colspan="11"><strong>:</strong> <%=fecha_01%></td>
  </tr>
</table>

<p>&nbsp;</p>
 <table width="100%" border="1">
  <tr> 
    <td bgcolor="#99FF99"><div align="center"><strong>N°</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>SEDE</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>CARRERA</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>JORNADA</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>CÓD.ASIGNATURA</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>ASIGNATURA</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>SECCIÓN</strong></div></td>
    <td bgcolor="#99FF99"><div align="center"><strong>RUT DOCENTE</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>DOCENTE</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>EVALUADO</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>FECHA</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG I-1</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG I-2</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG I-3</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG I-4</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG I-5</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG I-6</strong></div></td>
    <td bgcolor="#99FF99"><div align="center"><strong>PREG I-7</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG I-8</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG I-9</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG I-10</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-1</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-2</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-3</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-4</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-5</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-6</strong></div></td>
    <td bgcolor="#99FF99"><div align="center"><strong>PREG II-7</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-8</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-9</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-10</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-11</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>DIRECTOR</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>I: Fortaleza/Debilidad</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>II: Fortaleza/Debilidad</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>IV: Fortaleza/Debilidad</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG III - a</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG III - b</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG III - c</strong></div></td>
  </tr>
  
  <%  fila = 1
    while f_listado.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("jornada")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("asig_ccod")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("asig_tdesc")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("secc_tdesc")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("rut_docente")%></div></td>	
	<td><div align="left"><%=f_listado.ObtenerValor("docente")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("evaluado")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("fecha")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_I_1")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_I_2")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_I_3")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_I_4")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_I_5")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_I_6")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_I_7")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_I_8")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_I_9")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_I_10")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_1")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_2")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_3")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_4")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_5")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_6")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_7")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_8")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_9")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_10")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_preg_II_11")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("director")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("derh_I_foraleza_debilidad")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_II_foraleza_debilidad")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_IV_fortaleza_debilidad")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_III_a")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_III_b")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("derh_III_c")%></div></td>
  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>