<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=docentes_edad.xls"
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

 consulta = " select distinct  a.*, m30 + m40 + m50 + m60 + m70 + m80 as Totales " & vbCrLf &_
			" from (select dd.sede_tdesc as sede,cc.carr_tdesc as carrera, " & vbCrLf &_
			" (select count(distinct c.pers_ncorr) " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, personas d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and tpro_ccod=1  and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod" & vbCrLf &_
			"  and datediff(year,d.pers_fnacimiento,getDate()) <= 30" & vbCrLf &_
		    "  ) as m30,  " & vbCrLf &_
		    " (select count(distinct c.pers_ncorr) " & vbCrLf &_
		    "  from secciones a, bloques_horarios b, bloques_profesores c, personas d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and tpro_ccod=1 " & vbCrLf &_
		    "  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod " & vbCrLf &_
			"  and datediff(year,d.pers_fnacimiento,getDate()) > 30 and datediff(year,d.pers_fnacimiento,getDate()) <= 40 " & vbCrLf &_
			"  ) as m40, " & vbCrLf &_
			"  (select count(distinct c.pers_ncorr) " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, personas d,asignaturas f,periodos_academicos pea " & vbCrLf &_
		    "  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod  " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
		    "  and tpro_ccod=1  " & vbCrLf &_
			"  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod" & vbCrLf &_
			"  and datediff(year,d.pers_fnacimiento,getDate()) > 40 and datediff(year,d.pers_fnacimiento,getDate()) <= 50" & vbCrLf &_
		    "  ) as m50, " & vbCrLf &_
		    "  (select count(distinct c.pers_ncorr) " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, personas d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and tpro_ccod=1 " & vbCrLf &_
			"  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod" & vbCrLf &_
			"  and datediff(year,d.pers_fnacimiento,getDate()) > 50 and datediff(year,d.pers_fnacimiento,getDate()) <= 60" & vbCrLf &_
			"  ) as m60," & vbCrLf &_
			"  (select count(distinct c.pers_ncorr) " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, personas d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and tpro_ccod=1 " & vbCrLf &_
			"  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod" & vbCrLf &_
			"  and datediff(year,d.pers_fnacimiento,getDate()) > 60 and datediff(year,d.pers_fnacimiento,getDate()) <= 70" & vbCrLf &_
			"  ) as m70," & vbCrLf &_
			"  (select count(distinct c.pers_ncorr) " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, personas d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and tpro_ccod=1 " & vbCrLf &_
			"  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod" & vbCrLf &_
			"  and datediff(year,d.pers_fnacimiento,getDate()) > 70 " & vbCrLf &_
			"  ) as m80" & vbCrLf &_
			" from secciones bb,carreras cc,sedes dd,periodos_academicos pa " & vbCrLf &_
			" where  bb.carr_ccod=cc.carr_ccod" & vbCrLf &_
			" and bb.sede_ccod = dd.sede_ccod and bb.peri_ccod = pa.peri_ccod" & vbCrLf &_
			" and cast(pa.anos_ccod as varchar)='"&ano_consulta&"' and cc.tcar_ccod=1" & vbCrLf &_
			" "&filtro&" ) a " & vbCrLf &_
 			" where (m30 + m40 + m50 + m60 + m70 + m80) <> 0 " & vbCrLf &_
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
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Disposici&oacute;n de Docentes por Sede <br> Según rangos de edad</font></div>
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
    <td width="10%"><div align="center"><strong>Menores de 30</strong></div></td>
    <td width="10%"><div align="center"><strong>31-40</strong></div></td>
	<td width="10%"><div align="center"><strong>41-50</strong></div></td>
	<td width="10%"><div align="center"><strong>51-60</strong></div></td>
	<td width="10%"><div align="center"><strong>61-70</strong></div></td>
	<td width="10%"><div align="center"><strong>Más de 70</strong></div></td>
    <td width="10%"><div align="center"><strong>Totales</strong></div></td>
  </tr>
  <%  
    total_m30=0
	total_m40=0
	total_m50=0
	total_m60=0
	total_m70=0
	total_m80=0
	total_general=0
    while f_docentes.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_docentes.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("carrera")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("m30")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("m40")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("m50")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("m60")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("m70")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("m80")%></div></td>
    <td><div align="center"><strong><%=f_docentes.ObtenerValor("totales")%></strong></div></td>
  </tr>
  <% total_m30= total_m30 +  f_docentes.ObtenerValor("m30")
     total_m40= total_m40 +  f_docentes.ObtenerValor("m40")
	 total_m50= total_m50 +  f_docentes.ObtenerValor("m50")
	 total_m60= total_m60 +  f_docentes.ObtenerValor("m60")
	 total_m70= total_m70 +  f_docentes.ObtenerValor("m70")
	 total_m80= total_m80 +  f_docentes.ObtenerValor("m80")
	 total_general= total_general +  f_docentes.ObtenerValor("totales")
    wend %>
  <tr> 
    <td colspan="2"><div align="right"><strong>Totales</strong></div></td>
    <td><div align="center"><strong><%=total_m30%></strong></div></td>
    <td><div align="center"><strong><%=total_m40%></strong></div></td>
    <td><div align="center"><strong><%=total_m50%></strong></div></td>
	<td><div align="center"><strong><%=total_m60%></strong></div></td>
	<td><div align="center"><strong><%=total_m70%></strong></div></td>
	<td><div align="center"><strong><%=total_m80%></strong></div></td>
    <td><div align="center"><strong><%=total_general%></strong></div></td>
  </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>