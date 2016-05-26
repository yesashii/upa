<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=docentes_sedes.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
sede_ccod=request.QueryString("sede_ccod")
'------------------------------------------------------------------------------------
sede = conexion.consultauno("SELECT sede_tdesc FROM sedes WHERE cast(sede_ccod as varchar)= '" & sede_ccod & "'")

'----------------------------------------------------------------------------------------------
'-----------a modo de unificar el listado debemos sacar el periodo y el año que se esta consultando---------
periodo = negocio.obtenerPeriodoAcademico("PLANIFICACION")
ano_consulta = conexion.consultaUno("Select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

'response.Write(ano_consulta)

'----------------------------------------------------------------------- 


if sede_ccod <> "" then
	filtro = " and cast(bb.sede_ccod as varchar)='"&sede_ccod&"'"
	nombre_sede = sede
else
	filtro = ""
	nombre_sede = "Todas las Sedes"
end if
fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set f_docentes = new CFormulario
 f_docentes.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_docentes.Inicializar conexion

consulta =  "  select distinct  a.*, Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo as Totales " & vbCrLf &_
			" from (select dd.sede_tdesc as sede,cc.carr_tdesc as carrera, " & vbCrLf &_
			" (select count(distinct c.pers_ncorr) " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and d.egra_ccod in (1,3) and tpro_ccod=1  and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod) as Doctor,  " & vbCrLf &_
			" (select count(distinct c.pers_ncorr) " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea " & vbCrLf &_
		    "  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			"  and d.egra_ccod=1 and tpro_ccod=1 " & vbCrLf &_
			"  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod) as Magister, " & vbCrLf &_
		    " (select count(distinct c.pers_ncorr)  " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
		    "  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1) " & vbCrLf &_
			"  and d.egra_ccod=1 and tpro_ccod=1 " & vbCrLf &_
		    "  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod) as Licenciado,  " & vbCrLf &_
			" (select count(*) " & vbCrLf &_
			"  from ( " & vbCrLf &_
			"  select distinct c.pers_ncorr " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1) " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			" union all " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d, asignaturas f,periodos_academicos pea  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			" and d.grac_ccod = 2  and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod)a ) as Profesional, " & vbCrLf &_
			" (select count(*) " & vbCrLf &_
			" from ( " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 ) " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
 			" union all " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d, asignaturas f,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			" and d.grac_ccod = 1 and tpro_ccod=1  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod )a" & vbCrLf &_
			" ) as tecnico, " & vbCrLf &_
			" ( select count(*)" & vbCrLf &_
			" from (" & vbCrLf &_
			" select distinct c.pers_ncorr " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea" & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod" & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) ) " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod	and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" union all " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea" & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod" & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod )a) as sin_grado_titulo" & vbCrLf &_
			" from secciones bb,carreras cc,sedes dd,periodos_academicos pa " & vbCrLf &_
			" where  bb.carr_ccod=cc.carr_ccod" & vbCrLf &_
			" and bb.sede_ccod = dd.sede_ccod and bb.peri_ccod = pa.peri_ccod" & vbCrLf &_
			" and cast(pa.anos_ccod as varchar)='"&ano_consulta&"' and cc.tcar_ccod=1" & vbCrLf &_
			" "&filtro&" ) a " & vbCrLf &_
 			" where (Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo) <> 0 " & vbCrLf &_
		    " order by sede,carrera " 
'response.Write("<pre>"&consulta&"</pre>")
f_docentes.Consultar consulta
%>
<html>
<head>
<title> Listado docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Disposici&oacute;n de Docentes por Sede</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_sede %></td>
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
    <td width="15%"><div align="left"><strong>Sede</strong></div></td>
	<td width="15%"><div align="left"><strong>Carrera</strong></div></td>
    <td width="10%"><div align="center"><strong>Doctor</strong></div></td>
    <td width="10%"><div align="center"><strong>Magister</strong></div></td>
	<td width="10%"><div align="center"><strong>Licenciado</strong></div></td>
	<td width="10%"><div align="center"><strong>Profesional</strong></div></td>
	<td width="10%"><div align="center"><strong>T&eacute;cnico</strong></div></td>
	<td width="10%"><div align="center"><strong>Sin T&iacute;tulos</strong></div></td>
    <td width="10%"><div align="center"><strong>Totales</strong></div></td>
  </tr>
  <%  
    total_doctor=0
	total_magister=0
	total_licenciado=0
	total_profesional=0
	total_tecnico=0
	total_singrado=0
	total_general=0
    while f_docentes.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_docentes.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("carrera")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("doctor")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("magister")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("licenciado")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("profesional")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("tecnico")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("sin_grado_titulo")%></div></td>
    <td><div align="center"><strong><%=f_docentes.ObtenerValor("totales")%></strong></div></td>
  </tr>
  <% total_doctor= total_doctor +  f_docentes.ObtenerValor("doctor")
     total_magister= total_magister +  f_docentes.ObtenerValor("magister")
	 total_licenciado= total_licenciado +  f_docentes.ObtenerValor("licenciado")
	 total_profesional= total_profesional +  f_docentes.ObtenerValor("profesional")
	 total_tecnico= total_tecnico +  f_docentes.ObtenerValor("tecnico")
	 total_singrado= total_singrado +  f_docentes.ObtenerValor("sin_grado_titulo")
	 total_general= total_general +  f_docentes.ObtenerValor("totales")
    wend %>
  <tr> 
    <td colspan="2"><div align="right"><strong>Totales</strong></div></td>
    <td><div align="center"><strong><%=total_doctor%></strong></div></td>
    <td><div align="center"><strong><%=total_magister%></strong></div></td>
    <td><div align="center"><strong><%=total_licenciado%></strong></div></td>
	<td><div align="center"><strong><%=total_profesional%></strong></div></td>
	<td><div align="center"><strong><%=total_tecnico%></strong></div></td>
	<td><div align="center"><strong><%=total_singrado%></strong></div></td>
    <td><div align="center"><strong><%=total_general%></strong></div></td>
  </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>