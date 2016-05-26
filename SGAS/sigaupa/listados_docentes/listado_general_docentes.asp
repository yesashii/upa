<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'Response.AddHeader "Content-Disposition", "attachment;filename=listado_general_docentes.xls"
'Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------------------------------------
'-----------a modo de unificar el listado debemos sacar el periodo y el año que se esta consultando---------
periodo = negocio.obtenerPeriodoAcademico("PLANIFICACION")
ano_consulta = conexion.consultaUno("Select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set f_docentes = new CFormulario
 f_docentes.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_docentes.Inicializar conexion

 consulta = " select distinct c.sede_tdesc as sede,d.carr_tdesc as carrera,h.jorn_tdesc as jornada,j.facu_tdesc as facultad,cast(g.pers_nrut as varchar)+'-'+g.pers_xdv as rut, " & vbCrLf &_
			" g.pers_tnombre as nombre,g.pers_tape_paterno as ap_paterno,g.pers_tape_materno as ap_materno, " & vbCrLf &_
			" datediff(year,g.pers_fnacimiento,getDate()) as edad, " & vbCrLf &_
			" protic.obtener_asignaturas_docente_carrera_anuales_jornada(a.sede_ccod,a.carr_ccod,g.pers_ncorr,"&ano_consulta&",a.jorn_ccod) as asignaturas, " & vbCrLf &_
			" (select grac_tdesc from grados_academicos " & vbCrLf &_
			" where grac_ccod in (select max(grac_ccod) " & vbCrLf &_
			" from(  " & vbCrLf &_
			"    select grac_ccod from grados_profesor ti where ti.pers_ncorr=g.pers_ncorr and grac_ccod in (8,4,3) and egra_ccod=1 " & vbCrLf &_
			"    union " & vbCrLf &_
			"    select grac_ccod from grados_profesor ti where ti.pers_ncorr=g.pers_ncorr and grac_ccod in (5) and egra_ccod in (1,3)" & vbCrLf &_
			"    union " & vbCrLf &_
			"    select grac_ccod from curriculum_docente ti where ti.pers_ncorr=g.pers_ncorr and grac_ccod in (1,2) " & vbCrLf &_
			"    )a) ) as maximo_grado, " & vbCrLf &_
			" protic.obtener_grados_docente_con_institucion(g.pers_ncorr) as grados_academicos, " & vbCrLf &_
			" protic.obtener_titulos_docente_con_institucion(g.pers_ncorr) as titulos " & vbCrLf &_
			" from secciones a, periodos_Academicos b, sedes c, carreras d,bloques_horarios e, bloques_profesores f, personas g,jornadas h, " & vbCrLf &_
			" areas_academicas i, facultades j " & vbCrLf &_
			" where a.peri_ccod=b.peri_ccod and cast(b.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			" and a.sede_ccod=c.sede_ccod and a.carr_ccod = d.carr_ccod " & vbCrLf &_
			" and d.area_ccod = i.area_ccod and i.facu_ccod = j.facu_ccod " & vbCrLf &_
			" and a.secc_ccod = e.secc_ccod and e.bloq_ccod=f.bloq_ccod " & vbCrLf &_
			" and f.tpro_ccod=1 and f.pers_ncorr = g.pers_ncorr  and a.jorn_ccod = h.jorn_ccod " & vbCrLf &_
			" order by sede,facultad,carrera,jornada"
response.Write("<pre>"&consulta&"</pre>")
f_docentes.Consultar consulta

'response.End()
%>
<html>
<head>
<title> Listado general docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado General de docentes para el año solicitado</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Año</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=ano_consulta %></td>
  </tr>
  <tr> 
    <td><strong>Fecha</strong></td>
    <td colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td bgcolor="#FFFFCC"><div align="left"><strong>Fila</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>Sede</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>Facultad</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>Carrera</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>Jornada</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>Nombre Docente</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Apellido Paterno</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>Apellido Materno</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>Edad</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>Asignaturas Impartidas en el año</strong></div></td>
   	<td bgcolor="#FFFFCC"><div align="center"><strong>Máximo Grado</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>Grados Académicos del docente</strong></div></td>
   	<td bgcolor="#FFFFCC"><div align="center"><strong>Títulos del docente</strong></div></td>
  </tr>
  <%fila = 1
  while f_docentes.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("facultad")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("jornada")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("ap_paterno")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("ap_materno")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("edad")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("asignaturas")%></div></td>
    <td><div align="left"><strong><%=f_docentes.ObtenerValor("maximo_grado")%></strong></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("grados_Academicos")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("titulos")%></div></td>
  </tr>
  <%fila = fila + 1
  wend%>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>