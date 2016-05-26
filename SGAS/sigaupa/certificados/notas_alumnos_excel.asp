<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=notas_alumno.xls"
Response.ContentType = "application/vnd.ms-excel"

rut = request.QueryString("rut")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")
rut_alumno = conexion.consultaUno("select protic.format_rut('"&rut&"')")
nombre_alumno = conexion.consultaUno("select pers_tnombre + ' '+ pers_tape_paterno + ' '+ pers_tape_materno from personas where cast(pers_nrut as varchar)='"&rut&"'")

set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

consulta = " select distinct d.plec_ccod, c.peri_ccod,asig.asig_ccod,asig.asig_tdesc,pea.peri_tdesc as periodo, pea.anos_ccod as año_ingreso, "& vbCrLf &_
		   " case cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) when ' .0' then '0.0' else cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) end as carg_nnota_final,  "& vbCrLf &_
		   " sed.sede_tdesc as sede, car.carr_tdesc as carrera,jor.jorn_tdesc as jornada,ples.plan_tdesc as plan_estudios, esp.espe_tdesc as mensión, "& vbCrLf &_
		   " case ('('+ cast(d.anos_ccod as varchar) + '-' +  cast(b.sitf_ccod as varchar)+')') "& vbCrLf &_
		   " when ('('+ cast(d.anos_ccod as varchar) + '-' +')') then ' ' "& vbCrLf &_
		   " when '(-)' then ' ' "& vbCrLf &_
		   " else ('('+ cast(d.anos_ccod as varchar) + '-' + case cast(b.sitf_ccod as varchar) when 'A' then 'Apr' when 'R' then 'Repr' when 'C' then 'Conv' when 'SP' then 'S.P' when 'H' then 'Homologado' when 'S' then 'Suficiencia' end +')') end as anos_ccod,  "& vbCrLf &_
		   " isnull(cast(g.pers_nrut as varchar)+'-'+g.pers_xdv,'Sin Datos') as rut_docente,duas.duas_tdesc as duracion,isnull(g.pers_tape_paterno + ' '+g.pers_tape_materno + ',' + g.pers_tnombre,'Sin Datos') as nombre_profesor "& vbCrLf &_
		   "	 From personas per join alumnos alu "& vbCrLf &_
		   " 	    on per.pers_ncorr = alu.pers_ncorr "& vbCrLf &_
		   "     join cargas_academicas b "& vbCrLf &_
		   "        on alu.matr_ncorr = b.matr_ncorr "& vbCrLf &_
		   "     join secciones c  "& vbCrLf &_
		   "	    on b.secc_ccod = c.secc_ccod "& vbCrLf &_
		   "     join asignaturas asig "& vbCrLf &_
		   "	    on asig.asig_ccod = c.asig_ccod "& vbCrLf &_
		   "     join duracion_asignatura duas "& vbCrLf &_
		   "	    on asig.duas_ccod = duas.duas_ccod "& vbCrLf &_
		   "     join periodos_academicos d "& vbCrLf &_
		   "        on c.peri_ccod = d.peri_ccod "& vbCrLf &_
		   "     left outer join bloques_horarios e "& vbCrLf &_
		   "        on c.secc_ccod = e.secc_ccod "& vbCrLf &_
		   "     left outer join bloques_profesores f "& vbCrLf &_
		   "        on e.bloq_ccod = f.bloq_ccod and 1 = f.tpro_ccod  "& vbCrLf &_
		   "     left outer join personas g "& vbCrLf &_
		   "	    on f.pers_ncorr = g.pers_ncorr "& vbCrLf &_
		   "     join carreras car "& vbCrLf &_
		   "        on car.carr_ccod = c.carr_ccod "& vbCrLf &_
		   "     join sedes sed "& vbCrLf &_
		   "        on sed.sede_ccod = c.sede_ccod "& vbCrLf &_
		   "     join jornadas jor "& vbCrLf &_
		   "        on jor.jorn_ccod = c.jorn_ccod   "& vbCrLf &_
		   "     left outer join planes_estudio ples "& vbCrLf &_
		   "	    on alu.plan_ccod=ples.plan_ccod "& vbCrLf &_
		   "     join ofertas_academicas ofac "& vbCrLf &_
		   "        on alu.ofer_ncorr=ofac.ofer_ncorr "& vbCrLf &_
		   "     join especialidades esp "& vbCrLf &_
		   "        on ofac.espe_ccod=esp.espe_ccod   "& vbCrLf &_
		   "     join periodos_Academicos pea "& vbCrLf &_
		   "        on c.peri_ccod = pea.peri_ccod     "& vbCrLf &_
		   "     where isnull(b.carg_noculto,0) <> 1  "& vbCrLf &_
		   "     and (b.sitf_ccod <> '' or cast(b.carg_nnota_final as varchar)<>'') "& vbCrLf &_
		   "   and cast(per.pers_nrut as varchar)='"&rut&"' "& vbCrLf &_
		   "  union all "& vbCrLf &_   
		   " select distinct d.plec_ccod,d.peri_ccod,b.asig_ccod,b.asig_tdesc,d.peri_tdesc as periodo,d.anos_ccod as año_ingreso, "& vbCrLf &_
		   " case cast(cast(a.conv_nnota as decimal(2,1))as varchar) when ' .0' then '0.0' else cast(cast(a.conv_nnota as decimal(2,1))as varchar) end as carg_nnota_final,  "& vbCrLf &_
	 	   " (select sede_tdesc from sedes ss where ss.sede_ccod = c.sede_ccod) as sede, "& vbCrLf &_
		   " (select carr_tdesc from especialidades ee, carreras ca where ee.espe_ccod=c.espe_ccod and ee.carr_ccod= ca.carr_ccod) as carrera, "& vbCrLf &_
		   " case c.jorn_ccod when 1 then 'DIURNO' when 2 then 'VESPERTINO' end as jornada, "& vbCrLf &_
		   " (select plan_tdesc from planes_estudio ss where ss.plan_ccod = al.plan_ccod) as plan_estudios, "& vbCrLf &_
		   " (select espe_tdesc from especialidades ee where ee.espe_ccod=c.espe_ccod) as mensión, "& vbCrLf &_
		   " case ('('+ cast(d.anos_ccod as varchar) + '-' +  cast(a.sitf_ccod as varchar)+')')  "& vbCrLf &_
           " when ('('+ cast(d.anos_ccod as varchar) + '-' +')') then ' '  "& vbCrLf &_
		   " when '(-)' then ' ' "& vbCrLf &_
		   " else ('('+ cast(d.anos_ccod as varchar) + '-' + case cast(a.sitf_ccod as varchar) when 'A' then 'Apr' when 'R' then 'Repr' when 'C' then 'Conv' when 'SP' then 'S.P' when 'H' then 'Homologado' when 'S' then 'Suficiencia' end +')') end as anos_ccod,  "& vbCrLf &_
		   " 'Sin Datos' as rut_docente,e.duas_tdesc as duracion,'Sin Datos' as nombre_profesor "& vbCrLf &_
		   " from convalidaciones a, asignaturas b, personas p, alumnos al,ofertas_academicas c,periodos_Academicos d,duracion_asignatura e "& vbCrLf &_
		   " where al.pers_ncorr=p.pers_ncorr "& vbCrLf &_
		   " and cast(p.pers_nrut as varchar)='"&rut&"' "& vbCrLf &_
		   " and  a.matr_ncorr = al.matr_ncorr           "& vbCrLf &_
		   " and a.asig_ccod=b.asig_ccod   "& vbCrLf &_
           " and al.ofer_ncorr = c.ofer_ncorr "& vbCrLf &_
		   " and c.peri_ccod = d.peri_ccod "& vbCrLf &_
		   " and b.duas_ccod = e.duas_ccod   "& vbCrLf &_  
		   " order by año_ingreso desc,d.plec_ccod desc "

'response.Write("<pre>"&consulta&"</pre>")
f_listado.Consultar consulta

%>
<html>
<head>
<title>Asignaturas históricas del alumno </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado 
        de Asignaturas Realizadas por el Alumno </font></div>
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
    <td width="10%"><strong>Rut Alumno</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=rut_alumno%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Alumno</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=nombre_alumno%></td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2" bgcolor="#FFFFCC"><div align="left"><strong>N°</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="left"><strong>COD.ASIGNATURA</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="left"><strong>ASIGNATURA</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>PERIODO</strong></div></td>
	<td width="3%" bgcolor="#FFFFCC"><div align="left"><strong>AÑO</strong></div></td>
	<td width="3%" bgcolor="#FFFFCC"><div align="center"><strong>NOTA</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>CONCEPTO</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>DURACIÓN</strong></div></td>
    <td width="8%" bgcolor="#FFFFCC"><div align="center"><strong>RUT PROFESOR</strong></div></td>
	<td width="20%" bgcolor="#FFFFCC"><div align="left"><strong>NOMBRE</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="left"><strong>SEDE</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>CARRERA</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>JORNADA</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>PLAN ESTUDIOS</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MENCIÓN</strong></div></td>
  </tr>
  
  <%  fila = 1
    while f_listado.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("asig_ccod")%></div></td>
	<td><div align="left"><%=f_listado.ObtenerValor("asig_tdesc")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("periodo")%></div></td>
    <td><div align="center"><%=f_listado.ObtenerValor("año_ingreso")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("carg_nnota_final")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("anos_ccod")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("duracion")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("rut_docente")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("nombre_profesor")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("sede")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("carrera")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("jornada")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("plan_estudios")%></div></td>
	<td><div align="center"><%=f_listado.ObtenerValor("mensión")%></div></td>
  </tr>
  <% fila=fila + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>