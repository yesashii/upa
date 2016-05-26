<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=encuesta_autoevaluacion_docentes_excel.xls"
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
	 filtro = " and (select count(*) from auto_encuesta_docente_hhrr tt where tt.secc_ccod=a.secc_ccod and tt.pers_ncorr=d.pers_ncorr) > 0 "
end if

set f_listado = new CFormulario
f_listado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_listado.Inicializar conexion

consulta = " select distinct sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada,  " & vbCrLf & _
		   " a.asig_ccod,e.asig_tdesc,a.secc_ccod,d.pers_ncorr,a.secc_tdesc,  " & vbCrLf & _
		   " cast(d.pers_nrut as varchar)+'-'+ d.pers_xdv as rut_docente,d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' + d.pers_tape_materno as docente,  " & vbCrLf & _
		   " (select case count(*) when 0 then 'No' else 'Si' end from auto_encuesta_docente_hhrr tt   " & vbCrLf & _
		   "  where tt.secc_ccod=a.secc_ccod and tt.pers_ncorr=d.pers_ncorr) as evaluado,  " & vbCrLf & _
		   " i.audi_fmodificacion as fecha,    " & vbCrLf & _
		   " i.edrh_preg_I_1,i.edrh_preg_I_2,i.edrh_preg_I_3,i.edrh_preg_I_4,i.edrh_preg_I_5,i.edrh_preg_I_6,i.edrh_preg_II_1, " & vbCrLf & _
		   " i.edrh_preg_II_2,i.edrh_preg_II_3,i.edrh_preg_II_4,i.edrh_preg_II_5,i.edrh_preg_II_6,i.edrh_preg_II_7,i.edrh_preg_II_8, " & vbCrLf & _
		   " i.edrh_preg_III_1,i.edrh_preg_III_2,i.edrh_preg_III_3,i.edrh_preg_III_4,i.edrh_preg_IV_1,i.edrh_preg_IV_2,i.edrh_preg_IV_3, " & vbCrLf & _
		   " i.edrh_preg_IV_4,i.edrh_preg_V_1,i.edrh_preg_V_2,i.edrh_preg_V_3,i.edrh_I_foraleza_debilidad,i.edrh_II_foraleza_debilidad, " & vbCrLf & _
		   " i.edrh_III_foraleza_debilidad,i.edrh_IV_foraleza_debilidad,i.edrh_V_foraleza_debilidad  " & vbCrLf & _
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
		   " left outer join auto_encuesta_docente_hhrr i  " & vbCrLf & _
		   "    on a.secc_ccod = i.secc_ccod and d.pers_ncorr = i.pers_ncorr " & vbCrLf & _
		   " where cast(a.peri_ccod as varchar)='"&periodo&"'  "&filtro& vbCrLf & _
		   " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' and a.carr_ccod='"&carr_ccod&"' and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"'  " & vbCrLf & _
		   " order by docente " 
'response.Write("<pre>"&consulta&"</pre>")

f_listado.Consultar consulta
'response.End()
%>
<html>
<head>
<title>Resultados Autoevaluación Docente</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="12"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resultados Autoevaluación Docente</font></div></td>
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
    <td bgcolor="#99FF99"><div align="center"><strong>PREG II-1</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-2</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-3</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-4</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-5</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-6</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-7</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG II-8</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG III-1</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG III-2</strong></div></td>
    <td bgcolor="#99FF99"><div align="center"><strong>PREG III-3</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG III-4</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG IV-1</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG IV-2</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG IV-3</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG IV-4</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG V-1</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG V-2</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>PREG V-3</strong></div></td>A
	<td bgcolor="#99FF99"><div align="center"><strong>I: Fortaleza/Debilidad</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>II: Fortaleza/Debilidad</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>III: Fortaleza/Debilidad</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>IV: Fortaleza/Debilidad</strong></div></td>
	<td bgcolor="#99FF99"><div align="center"><strong>V: Fortaleza/Debilidad</strong></div></td>
  </tr>
  
  <%fila = 1
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
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_I_1")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_I_2")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_I_3")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_I_4")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_I_5")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_I_6")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_II_1")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_II_2")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_II_3")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_II_4")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_II_5")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_II_6")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_II_7")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_II_8")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_III_1")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_III_2")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_III_3")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_III_4")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_IV_1")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_IV_2")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_IV_3")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_IV_4")%></div></td>	
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_V_1")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_V_2")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("edrh_preg_V_3")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("edrh_I_foraleza_debilidad")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("edrh_II_foraleza_debilidad")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("edrh_III_foraleza_debilidad")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("edrh_IV_foraleza_debilidad")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("edrh_V_foraleza_debilidad")%></div></td>
  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>