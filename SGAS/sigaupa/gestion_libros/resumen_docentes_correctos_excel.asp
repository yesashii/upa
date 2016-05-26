<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=resumen_docentes_pcorrectos.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pers_ncorr   =   request.QueryString("pers_ncorr")
nombre_docente= conexion.consultaUno("select pers_tnombre +' ' +pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut_docente= conexion.consultaUno("select cast(pers_nrut as varchar) + '-' +pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
carr_ccod   =   request.QueryString("carr_ccod")
asig_ccod	=	request.querystring("asig_ccod")
inicio = request.querystring("inicio")
termino = request.querystring("termino")
estado_prestamo = request.querystring("estado_prestamo")

periodo = negocio.obtenerPeriodoAcademico("Planificacion")
peri = negocio.obtenerPeriodoAcademico("CLASES18")
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")
'----------------------------declaramos los filtros que se seleccionaron para reducir resultados
filtro=""
if not esvacio(carr_ccod) then 
	filtro = filtro & " and cast(a.carr_ccod as varchar)='"&carr_ccod&"'"
end if
if not esvacio(asig_ccod) then 
	filtro = filtro & " and cast(a.asig_ccod as varchar)='"&asig_ccod&"'"
end if

filtro_2 = ""
if not esVacio(inicio) and not esVacio(termino) then
	filtro_2 = " and convert(varchar,pres.pres_fprestamo,103) between " & vbcrlf & _
	           " case when convert(datetime,'"&inicio&"',103) >= convert(varchar,b.bloq_finicio_modulo,103) then convert(datetime,'"&inicio&"',103)" & vbcrlf & _
			   " else convert(varchar,b.bloq_finicio_modulo,103) end  " & vbcrlf & _
			   " and case when convert(datetime,'"&termino&"',103) <= convert(varchar,b.bloq_ftermino_modulo,103) then convert(datetime,'"&termino&"',103) else case when convert(varchar,b.bloq_ftermino_modulo,103) < convert(varchar,getDate(),103) then convert(varchar,b.bloq_ftermino_modulo,103) else convert(varchar,getDate(),103) end end"
elseif not esVacio(inicio) and  esVacio(termino) then
	filtro_2 = " and convert(varchar,pres.pres_fprestamo,103) between " & vbcrlf & _
	           " case when convert(datetime,'"&inicio&"',103) >= convert(varchar,b.bloq_finicio_modulo,103) then convert(datetime,'"&inicio&"',103)" & vbcrlf & _
			   " else convert(varchar,b.bloq_finicio_modulo,103) end  " & vbcrlf & _
			   " and case when convert(varchar,b.bloq_ftermino_modulo,103) < convert(varchar,getDate(),103) then convert(varchar,b.bloq_ftermino_modulo,103) else convert(varchar,getDate(),103) end"
elseif esVacio(inicio) and  not esVacio(termino) then
	filtro_2 = " and convert(varchar,pres.pres_fprestamo,103) between convert(varchar,b.bloq_finicio_modulo,103) " & vbcrlf & _
			   " and case when convert(datetime,'"&termino&"',103) <= convert(varchar,b.bloq_ftermino_modulo,103) then convert(datetime,'"&termino&"',103) else case when convert(varchar,b.bloq_ftermino_modulo,103) < convert(varchar,getDate(),103) then convert(varchar,b.bloq_ftermino_modulo,103) else convert(varchar,getDate(),103) end end"
else
 	filtro_2 = " and convert(datetime,pres.pres_fprestamo,103) between convert(datetime,b.bloq_finicio_modulo,103) and case when convert(datetime,b.bloq_ftermino_modulo,103) < convert(datetime,getDate(),103) then convert(datetime,b.bloq_ftermino_modulo,103) else convert(datetime,getDate(),103) end "
end if

filtro_3=""
if not esVacio(estado_prestamo) then
	filtro_3=" and cast(k.espr_ccod as varchar)='"&estado_prestamo&"'"
end if
'--------------------------------fin de filtros-----------------------------



set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

consulta = " select * from ( " & vbcrlf & _
           " select distinct k.espr_ccod as est,pres.pres_ncorr as codigo,d.carr_tdesc as carrera,e.asig_ccod +' --> ' + e.asig_tdesc as asignatura,pres.pres_fprestamo, " & vbcrlf & _
		   " protic.trunc(pres.pres_fprestamo) as fecha,h.dias_tdesc as dia,i.hora_tdesc as bloque, " & vbcrlf & _
		   " case when datepart(hour,j.hora_hinicio) < 10 then '0' else '' end + cast(datepart(hour,j.hora_hinicio) as varchar)+':'+ case when datepart(minute,j.hora_hinicio) < 10 then '0' else '' end + cast(datepart(minute,j.hora_hinicio) as varchar)  " & vbcrlf & _
           " +' A '+ case when datepart(hour,j.hora_htermino) < 10 then '0' else '' end + cast(datepart(hour,j.hora_htermino) as varchar)+':'+ case when datepart(minute,j.hora_htermino) < 10  then '0' else '' end + cast(datepart(minute,j.hora_htermino) as varchar) as horario, " & vbcrlf & _
		   " '<font color=''' + case k.espr_ccod when 4 then '#009966' when 2 then '#0033FF' when 5 then '#FF6600' when 6 then '#FF0000' when 8 then '#FF0033' end +'''>' + ltrim(rtrim(k.espr_tdesc)) + '</font>' as estado, " & vbcrlf & _
		   " pres.pres_tobservacion_prestamo as ob_1,pres.pres_tobservacion_devolucion as ob_2, isnull(pres_nminutos_atraso,0) as min_atraso, isnull(pres_nminutos_adelanto,0) as min_adelanto, " & vbcrlf & _
		   " isnull((select protic.trunc(fecha_recuperacion) from registro_recuperativas bb where bb.pres_ncorr=pres.pres_ncorr),'') as fecha_recuperacion, " & vbcrlf & _
 		   " (select isnull(devuelto_descuento,'N') from registro_recuperativas bb where bb.pres_ncorr=pres.pres_ncorr) as devuelta,  " & vbcrlf & _
		   "  (select tcdo_tdesc from contratos_docentes_upa aaa, tipos_contratos_docentes baa " & vbcrlf & _
		   "  where aaa.tcdo_ccod = baa.tcdo_ccod and aaa.pers_ncorr=c.pers_ncorr and aaa.ano_contrato=pea.anos_ccod " & vbcrlf & _
		   " ) as tipo_contrato,  " & vbcrlf & _
		   "  (select tido_tdesc from anos_tipo_docente aaa, tipos_docente baa " & vbcrlf & _
		   "  where aaa.tido_ccod = baa.tido_ccod and aaa.pers_ncorr=c.pers_ncorr and aaa.anos_ccod=pea.anos_ccod " & vbcrlf & _
		   " ) as tipo_docente,opli_ccod_prestamo,opli_ccod_devolucion  " & vbcrlf & _
		   " from secciones a, bloques_horarios b, bloques_profesores c,carreras d, " & vbcrlf & _
		   "  	  asignaturas e, libros_clases g,dias_semana h,horarios i,prestamos_libros pres,horarios_sedes j,estados_prestamo k, periodos_academicos pea " & vbcrlf & _
		   " where a.secc_ccod=b.secc_ccod  "& filtro & vbcrlf & _
		   "	and b.bloq_ccod=c.bloq_ccod " & vbcrlf & _
		   "	and b.dias_ccod=h.dias_ccod " & vbcrlf & _
		   " 	and b.hora_ccod=i.hora_ccod " & vbcrlf & _
		   "	and a.carr_ccod=d.carr_ccod " & vbcrlf & _
		   "	and a.asig_ccod=e.asig_ccod " & vbcrlf & _
		   "	and a.secc_ccod=g.secc_ccod " & vbcrlf & _
		   "	and c.pers_ncorr=g.pers_ncorr and a.peri_ccod=pea.peri_ccod " & vbcrlf & _
		   "    and b.hora_ccod=j.hora_ccod and a.sede_ccod=j.sede_ccod " & vbcrlf & _
		   "	and datepart(weekday,pres.pres_fprestamo) = b.dias_ccod " & vbcrlf & _
		   "	and g.libr_ncorr=pres.libr_ncorr and b.bloq_ccod=pres.bloq_ccod " & vbcrlf & _
		   "    and (pres.pres_estado_prestamo in (2,5,6) or pres.pres_estado_devolucion=4) " & vbcrlf & _
		   "    "& filtro_2 & vbcrlf & _
		   "    and k.espr_ccod = case when pres.pres_estado_devolucion=4 then pres.pres_estado_devolucion else pres.pres_estado_prestamo end " & vbcrlf & _
		   " 	and cast(a.peri_ccod as varchar)=case e.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end " & vbcrlf & _
		   "	and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' "& filtro_3 & vbcrlf & _
		   "	and datepart(year,pres.pres_fprestamo)='"&anos_ccod&"' "& vbcrlf & _
		   "	) tabla_1 "& vbcrlf & _
           "    where (isnull(min_atraso,0) > 10 or isnull(min_adelanto,0) > 10 or est = 6) "& vbcrlf & _
		   "    and isnull(tabla_1.devuelta,'NO') <> 'SI'  "& vbcrlf & _
		   "    order by pres_fprestamo "

consulta = " select distinct k.espr_ccod as est,pres.pres_ncorr as codigo, ss.sede_tdesc as sede,d.carr_tdesc as carrera, jj.jorn_tdesc as jornada,e.asig_ccod +' --> ' + e.asig_tdesc as asignatura,pres.pres_fprestamo, " & vbcrlf & _
		   " protic.trunc(pres.pres_fprestamo) as fecha,h.dias_tdesc as dia,i.hora_tdesc as bloque,  " & vbcrlf & _
		   " cast(pp.pers_nrut as varchar)+'-'+ pp.pers_xdv as rut,pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' '+ pp.pers_tape_materno as docente,  " & vbcrlf & _
		   " case when datepart(hour,j.hora_hinicio) < 10 then '0' else '' end + cast(datepart(hour,j.hora_hinicio) as varchar)+':'+ case when datepart(minute,j.hora_hinicio) < 10 then '0' else '' end + cast(datepart(minute,j.hora_hinicio) as varchar)  " & vbcrlf & _
		   " +' A '+ case when datepart(hour,j.hora_htermino) < 10 then '0' else '' end + cast(datepart(hour,j.hora_htermino) as varchar)+':'+ case when datepart(minute,j.hora_htermino) < 10  then '0' else '' end + cast(datepart(minute,j.hora_htermino) as varchar) as horario,   " & vbcrlf & _
		   " '' + k.espr_tdesc + '' as estado,  " & vbcrlf & _
		   "  pres.pres_tobservacion_prestamo as ob_1,pres.pres_tobservacion_devolucion as ob_2,  " & vbcrlf & _
		   " isnull((select protic.trunc(fecha_recuperacion) from registro_recuperativas bb where bb.pres_ncorr=pres.pres_ncorr),'') as fecha_recuperacion,   " & vbcrlf & _
		   " isnull(pres.pres_nminutos_atraso,0) as minutos_atraso,isnull(pres_nminutos_adelanto,0) as minutos_devolucion_adelanto, 1 as tipopo   " & vbcrlf & _
		   " from prestamos_libros pres, estados_prestamo k, libros_clases g, bloques_horarios b, secciones a,sedes ss,carreras d, " & vbcrlf & _
		   " jornadas jj,asignaturas e,horarios i, dias_semana h,horarios_sedes j,personas pp  " & vbcrlf & _
		   " where datepart(year,pres.pres_fprestamo)='"&anos_ccod&"' "& filtro & vbcrlf & _
		   " and pres.pres_estado_prestamo = 1 and pres.pres_estado_devolucion=3 " & vbcrlf & _
		   " and pres.pres_estado_prestamo = k.espr_ccod " & vbcrlf & _
		   " and pres.libr_ncorr = g.libr_ncorr  " & vbcrlf & _    
		   " and pres.bloq_ccod  = b.bloq_ccod  " & vbcrlf & _
		   " and b.secc_ccod = a.secc_ccod   " & vbcrlf & _
		   " and a.sede_ccod=ss.sede_ccod " & vbcrlf & _ 
		   " and a.carr_ccod=d.carr_ccod " & vbcrlf & _  
		   " and a.jorn_ccod=jj.jorn_ccod " & vbcrlf & _
		   " and a.asig_ccod=e.asig_ccod   " & vbcrlf & _
		   " and b.hora_ccod=i.hora_ccod " & vbcrlf & _
		   " and b.dias_ccod=h.dias_ccod " & vbcrlf & _ 	
		   " and b.hora_ccod=j.hora_ccod and a.sede_ccod=j.sede_ccod " & vbcrlf & _
		   " and g.pers_ncorr= pp.pers_ncorr " & vbcrlf & _
		   " and cast(pp.pers_ncorr as varchar)='"&pers_ncorr&"'   " & vbcrlf & _ 	
		   " and b.dias_ccod = datepart(weekday,pres.pres_fprestamo) " & vbcrlf & _
		   "    "& filtro_2 & vbcrlf & _	
		   " and cast(a.peri_ccod as varchar)=case e.duas_ccod when 3 then '"&peri&"' else '"&periodo&"'  end   " & vbcrlf & _
		   " union " & vbcrlf & _
		   " select *  " & vbcrlf & _ 
		   " from (   " & vbcrlf & _ 
		   " select distinct k.espr_ccod as est,pres.pres_ncorr as codigo,tt.sede_tdesc as sede,d.carr_tdesc as carrera,t2.jorn_tdesc as jornada,e.asig_ccod +' --> ' + e.asig_tdesc as asignatura,pres.pres_fprestamo,   " & vbcrlf & _ 
		   " protic.trunc(pres.pres_fprestamo) as fecha,h.dias_tdesc as dia,i.hora_tdesc as bloque,   " & vbcrlf & _ 
		   " cast(t3.pers_nrut as varchar)+'-'+t3.pers_xdv as rut, pers_tnombre+' '+pers_tape_paterno + ' ' + pers_tape_materno as docente,  " & vbcrlf & _ 
		   " case when datepart(hour,j.hora_hinicio) < 10 then '0' else '' end + cast(datepart(hour,j.hora_hinicio) as varchar)+':'+ case when datepart(minute,j.hora_hinicio) < 10 then '0' else '' end + cast(datepart(minute,j.hora_hinicio) as varchar)    " & vbcrlf & _ 
		   " +' A '+ case when datepart(hour,j.hora_htermino) < 10 then '0' else '' end + cast(datepart(hour,j.hora_htermino) as varchar)+':'+ case when datepart(minute,j.hora_htermino) < 10  then '0' else '' end + cast(datepart(minute,j.hora_htermino) as varchar) as horario,   " & vbcrlf & _ 
		   " '' + ltrim(rtrim(k.espr_tdesc)) + '' as estado,   " & vbcrlf & _ 
		   " pres.pres_tobservacion_prestamo as ob_1,pres.pres_tobservacion_devolucion as ob_2,   " & vbcrlf & _ 
		   " isnull((select protic.trunc(fecha_recuperacion) from registro_recuperativas bb where bb.pres_ncorr=pres.pres_ncorr),'') as fecha_recuperacion,  isnull(pres_nminutos_atraso,0) as minutos_atraso, isnull(pres_nminutos_adelanto,0) as minutos_devolucion_adelanto, 2 as tipopo  " & vbcrlf & _ 
		   " from secciones a, bloques_horarios b, bloques_profesores c,carreras d,   " & vbcrlf & _ 
		   "	  asignaturas e, libros_clases g,dias_semana h,horarios i,prestamos_libros pres,horarios_sedes j,estados_prestamo k, periodos_academicos pea,sedes tt, jornadas t2,personas t3   " & vbcrlf & _ 
		   " where a.secc_ccod=b.secc_ccod   " & filtro & vbcrlf & _
		   "	and b.bloq_ccod=c.bloq_ccod   " & vbcrlf & _ 
		   "	and b.dias_ccod=h.dias_ccod   " & vbcrlf & _ 
		   "	and b.hora_ccod=i.hora_ccod   " & vbcrlf & _ 
		   "	and a.carr_ccod=d.carr_ccod   " & vbcrlf & _ 
		   "	and a.asig_ccod=e.asig_ccod   " & vbcrlf & _ 
		   "	and a.secc_ccod=g.secc_ccod and a.sede_ccod=tt.sede_ccod and a.jorn_ccod=t2.jorn_ccod  " & vbcrlf & _ 
		   "	and c.pers_ncorr=t3.pers_ncorr  " & vbcrlf & _ 
		   "	and c.pers_ncorr=g.pers_ncorr and a.peri_ccod=pea.peri_ccod  " & vbcrlf & _ 
		   "	and b.hora_ccod=j.hora_ccod and a.sede_ccod=j.sede_ccod  " & vbcrlf & _ 
		   "	and datepart(weekday,pres.pres_fprestamo) = b.dias_ccod  " & vbcrlf & _ 
		   "	and g.libr_ncorr=pres.libr_ncorr and b.bloq_ccod=pres.bloq_ccod  " & vbcrlf & _ 
		   "	and (pres.pres_estado_prestamo in (2,5,6) or pres.pres_estado_devolucion=4)  " & vbcrlf & _ 
		   "    "& filtro_2 & vbcrlf & _
		   "	and k.espr_ccod = case when pres.pres_estado_devolucion=4 then pres.pres_estado_devolucion else pres.pres_estado_prestamo end  " & vbcrlf & _ 
		   "	and cast(a.peri_ccod as varchar)=case e.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end   " & vbcrlf & _ 
		   "	and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"'   " & vbcrlf & _ 
		   "	and datepart(year,pres.pres_fprestamo)='"&anos_ccod&"' " & vbcrlf & _ 
		   "	) tabla_1   " & vbcrlf & _ 
		   "	where ((isnull(minutos_atraso,0) > 0 and isnull(minutos_atraso,0) <= 10   " & vbcrlf & _ 
		   "										 and isnull(minutos_devolucion_adelanto,0) <= 10) or   " & vbcrlf & _ 
		   "		   (isnull(minutos_devolucion_adelanto,0) > 0 and isnull(minutos_devolucion_adelanto,0) <= 10   " & vbcrlf & _ 
		   "													  and isnull(minutos_atraso,0) <= 10))   " & vbcrlf & _ 
		   "  order by pres_fprestamo " 		   

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta
%>
<html>
<head>
<title>resumen por docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">RESUMEN GENERAL POR DOCENTES </font></div>
      <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="10%"><strong>R.u.t</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=rut_docente%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Nombre</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=nombre_docente%></td>
  </tr>
  <tr> 
    <td width="10%"><strong>Fecha</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td bgcolor="#FFFFCC"><div align="left"><strong>N°</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CÓDIGO</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>FECHA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CARRERA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>ASIGNATURA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>D&Iacute;A</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>BLOQUE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>HORARIO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>ESTADO</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>OBSERVACI&Oacute;N PRESTAMO</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>CÓD. OBS. PRESTAMO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>OBSERVACI&Oacute;N DEVOLUCI&Oacute;N</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>CÓD. OBS. DEVOLUCION</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>MINUTOS ATRASOS</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>MINUTOS ANTES</strong></div></td>
  </tr>
  
  <%  fila = 1
    while f_listado.Siguiente 
	'response.Write("<br>atraso "&f_listado.ObtenerValor("min_atraso"))
	'response.Write("<br>adelanto "&f_listado.ObtenerValor("min_adelanto"))
	'response.Write("<br>estado "&f_listado.ObtenerValor("estado"))
	'if  cint(f_listado.ObtenerValor("min_atraso")) > 10 or cint(f_listado.ObtenerValor("min_adelanto")) > 10 or cint(f_listado.ObtenerValor("est")) = 6 then  
	tipopo = f_listado.ObtenerValor("tipopo")
	color = "#FFFFFF"
	if tipopo = "2" then
		color = "#FFCC00"
	end if
	%>
  <tr> 
   	<td  bgcolor="<%=color%>"><div align="left"><%=fila%></div></td>
	<td  bgcolor="<%=color%>"><div align="left"><%=f_listado.ObtenerValor("codigo")%></div></td>
	<td  bgcolor="<%=color%>"><div align="left"><%=f_listado.ObtenerValor("fecha")%></div></td>
	<td  bgcolor="<%=color%>"><div align="left"><%=f_listado.ObtenerValor("carrera")%></div></td>
    <td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("asignatura")%></div></td>
    <td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("dia")%></div></td>
	<td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("bloque")%></div></td>
	<td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("horario")%></div></td>
	<td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("estado")%></div></td>
	<td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("ob_1")%></div></td>
    <td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("opli_ccod_prestamo")%></div></td>
	<td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("ob_2")%></div></td>
    <td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("opli_ccod_devolucion")%></div></td>
	<td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("minutos_atraso")%></div></td>
	<td  bgcolor="<%=color%>"><div align="center"><%=f_listado.ObtenerValor("minutos_devolucion_adelanto")%></div></td>
  </tr>
  <% fila=fila + 1
    'end if
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>