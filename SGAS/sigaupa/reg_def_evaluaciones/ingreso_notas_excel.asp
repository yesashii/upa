<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=notas_evaluacion.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usuario=negocio.obtenerUsuario
periodo = negocio.obtenerPeriodoAcademico("Postulacion")



'-----------------------------------------------------------------------
secc_ccod = request.QueryString("secc_ccod")
cali_ncorr = request.QueryString("cali_ncorr")
'------------------------------------------------------------------------------------
if secc_ccod <> "" and secc_ccod <> "-1" then
  nombre_seccion = conexion.consultaUno("select  secc_tdesc from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
  profesor = conexion.consultaUno("select  pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where cast(pers_nrut as varchar)='"&usuario&"'")
  asig_ccod = conexion.consultaUno("select  asig_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
  nombre_asignatura = conexion.consultaUno("select b.asig_ccod + ' ' + asig_tdesc from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
  nombre_sede = conexion.consultaUno("select sede_tdesc from secciones a, sedes b where a.sede_ccod=b.sede_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
  nombre_carrera = conexion.consultaUno("select carr_tdesc from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
  periodo_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

end if
if cali_ncorr <> "" and cali_ncorr <>"-1" then
  nombre_calificacion = conexion.consultauno("select 'Nº '+ cast(cali_nevaluacion as varchar)+ ' - ' + cast(convert(datetime,a.cali_fevaluacion,103)as varchar)+' - '+ teva_tdesc as evaluacion from calificaciones_seccion a, tipos_evaluacion b where a.teva_ccod=b.teva_ccod and cast(cali_ncorr as varchar)='"&cali_ncorr&"' ")
end if
fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")
'------------------------------------------------------------------------------------

'-----------------------si la asignatura es anual y el periodo es priemr sem 2006 no considere estados matr. 
'---------------------------si es semestral o trimestral y el periodo mayor a 202 entonces no considere matr.
duracion_asig = conexion.consultaUno("select duas_ccod from asignaturas where asig_ccod ='"&asig_ccod&"'")
filtro_matr = " and b.emat_ccod in (1,2,16) "
if duracion_asig = "3" and periodo >= "202" then
	filtro_matr = " "
elseif (duracion_asig = "1" or duracion_asig ="2") and periodo > "202" then
    filtro_matr = " "
end if
'-----------------------------------------------------------------------------------------------------------


set alumnos		=	new cformulario
alumnos.carga_parametros "notas.xml" , "alumnos"
alumnos.Inicializar conexion

consulta = "select  " & vbCrlf & _
					" c.matr_ncorr,isnull(c.estado_cierre_ccod,1)as estado_cierre_ccod, " & vbCrlf & _
				    " case d.cali_njustificacion when 1 then '<font color=red>' + cast(a.pers_nrut as varchar) +' - ' + a.pers_xdv + '</font>' else  " & vbCrlf & _
					" cast(a.pers_nrut as varchar) +' - ' + a.pers_xdv end as rut," & vbCrlf & _
					" case d.cali_njustificacion when 1 then '<font color=red>' + pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre + '</font>' else  " & vbCrlf & _
					" pers_tape_paterno + ' '+ pers_tape_materno + ', ' + pers_tnombre end as alumno," & vbCrlf & _
  					" replace(case cala_nnota when null then '1.0' when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else cala_nnota end,',','.') as cala_nnota,  " & vbCrlf & _
					" d.cali_njustificacion" & vbCrlf & _
					"	from  " & vbCrlf & _
					"		personas a join alumnos b " & vbCrlf & _
					"       	on a.pers_ncorr=b.pers_ncorr " & vbCrlf & _
					"       join cargas_academicas c " & vbCrlf & _
					"			on b.matr_ncorr=c.matr_ncorr " & vbCrlf & _
					"		left outer join calificaciones_alumnos d " & vbCrlf & _
					"           on c.secc_ccod=d.secc_ccod and c.matr_ncorr=d.matr_ncorr and case d.cali_ncorr when null then 'N' else cast(d.cali_ncorr as varchar) end = case d.cali_ncorr when null then 'N' else '"&cali_ncorr&"' end " & vbCrlf & _
					"		left outer join calificaciones_seccion e " & vbCrlf & _
					"			on d.cali_ncorr = e.cali_ncorr " & vbCrlf & _			
					"	where   c.carg_nsence is null  "&filtro_matr & vbCrlf & _
					"		and cast(c.secc_ccod as varchar) =	'"& secc_ccod &"' " & vbCrlf & _
					"		and c.matr_ncorr not in (select matr_ncorr_destino from resoluciones_homologaciones  where cast(secc_ccod_destino as varchar)='"&secc_ccod&"') " & vbCrlf & _				
					"		and c.matr_ncorr not in (select matr_ncorr from convalidaciones where matr_ncorr=c.matr_ncorr and cast(asig_ccod as varchar)='"&asig_ccod&"') " & vbCrlf & _
					"		and (c.sitf_ccod<>'EE' or sitf_ccod is null)" & vbCrlf & _
                    " order by pers_tape_paterno, pers_tape_materno, pers_tnombre"
'response.Write("<pre>"&consulta&"</pre>")
alumnos.Consultar consulta
%>
<html>
<head>
<title>Listado de Alumnos Evaluados</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de alumnos evaluados</font></div>
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
    <td width="16%"><strong>Carrera</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_carrera %></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Secci&oacute;n</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_seccion %></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Asignatura</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_asignatura %></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Periodo</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=periodo_tdesc%></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Calificaci&oacute;n</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_calificacion%></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Profesor</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=profesor%></td>
  </tr>
  <tr> 
    <td><strong>Fecha</strong></td>
    <td colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  
  
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="5%"><div align="left"><strong>N°</strong></div></td>
    <td width="20%"><div align="center"><strong>R.U.T.</strong></div></td>
    <td width="60%"><div align="center"><strong>ALUMNO</strong></div></td>
	<td width="10%"><div align="center"><strong>NOTA</strong></div></td>
   
  </tr>
  <%  fila = 1
    while alumnos.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
    <td><div align="left"><%=alumnos.ObtenerValor("rut")%></div></td>
	<td><div align="left"><%=alumnos.ObtenerValor("alumno")%></div></td>
    <td><div align="center"><%=alumnos.ObtenerValor("cala_nnota")%></div></td>
  </tr>
  <%fila = fila +1
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>