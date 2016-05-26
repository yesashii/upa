<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_ceremonia.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
'---------------------------------------------------------------------------------------------------
carr_ccod = request.QueryString("carr_ccod")
codigo_fecha = request.QueryString("codigo_fecha")
'response.Write("carrera :" & carr_ccod)
'response.End()

set pagina = new CPagina
pagina.Titulo = "Listado de alumnos participantes en ceremonia de titulación" 

set conexion = new cConexion
conexion.inicializar "upacifico"

if carr_ccod <> "" then
	carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")
else
	carr_tdesc = "Todas las Carreras"
end if

fecha_01 = conexion.consultaUno("select protic.trunc(getDate())")
fecha_ceremonia = conexion.consultaUno("select protic.initCap(sede_tdesc)+': '+ protic.trunc(fecha_ceremonia) from ceremonias_titulacion a, sedes b where a.sede_ccod=b.sede_ccod and cast(a.id_ceremonia as varchar)='"&codigo_fecha&"'")
'---------------------------------------------------------------------------------------------------
set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion
 consulta = "select distinct * "& vbCrLf &_
			" from ( "& vbCrLf &_
			" select  "& vbCrLf &_
			" (select top 1 sede_tdesc from alumnos tt, ofertas_academicas rr, sedes uu, especialidades zz "& vbCrLf &_
			"  where tt.pers_ncorr=e.pers_ncorr and tt.emat_ccod in (4,8) and tt.ofer_ncorr=rr.ofer_ncorr "& vbCrLf &_
			"  and rr.espe_ccod = zz.espe_ccod and zz.carr_ccod=c.carr_ccod and rr.sede_ccod=uu.sede_ccod) as sede_tdesc, "& vbCrLf &_
			"   d.carr_tdesc, "& vbCrLf &_
			"  (select top 1 jorn_tdesc from alumnos tt, ofertas_academicas rr, jornadas uu, especialidades zz "& vbCrLf &_
			"   where tt.pers_ncorr=e.pers_ncorr and tt.emat_ccod in (4,8) and tt.ofer_ncorr=rr.ofer_ncorr "& vbCrLf &_
			"   and rr.espe_ccod=zz.espe_ccod and zz.carr_ccod=c.carr_ccod and rr.jorn_ccod=uu.jorn_ccod) as jorn_tdesc, "& vbCrLf &_
			"   case isnull(incluir_mencion,'0') when '0' then '' else nombre_mencion end as mencion, "& vbCrLf &_
 			"   cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, "& vbCrLf &_
			"   pers_tnombre as nombres, pers_tape_paterno + ' ' + pers_tape_materno as apellidos, "& vbCrLf &_
			"   replace(isnull(promedio_final,asca_nnota),',','.') as nota, "& vbCrLf &_
			"  datepart(year,g.asca_fsalida) as anos_ccod, "& vbCrLf &_
			"  case when datepart(year,g.asca_fsalida) <= 2005  "& vbCrLf &_
			"                                then case when isnull(promedio_final,asca_nnota) >= 4.0 and isnull(promedio_final,asca_nnota) < 5.0 then 'UNANIMIDAD' "& vbCrLf &_
			"                                          when isnull(promedio_final,asca_nnota) >= 5.0 and isnull(promedio_final,asca_nnota) < 5.5 then 'UN VOTO DE DISTINCION'  "& vbCrLf &_
			"                                          when isnull(promedio_final,asca_nnota) >= 5.5 and isnull(promedio_final,asca_nnota) < 6.0 then 'DOS VOTOS DE DISTINCION' "& vbCrLf &_
			"                                          when isnull(promedio_final,asca_nnota) >= 6.0 and isnull(promedio_final,asca_nnota) < 6.5 then 'TRES VOTOS DE DISTINCION' "& vbCrLf &_
			"                                          when isnull(promedio_final,asca_nnota) >= 6.5 and isnull(promedio_final,asca_nnota) <= 7.0 then 'APROBADO CON DISTINCION MAXIMA' "& vbCrLf &_
			"                                      end  "& vbCrLf &_
			"                                 else case when isnull(promedio_final,asca_nnota) >= 4.0 and isnull(promedio_final,asca_nnota) < 5.0 then 'APROBADO POR UNANIMIDAD' "& vbCrLf &_
			"                                           when isnull(promedio_final,asca_nnota) >= 5.0 and isnull(promedio_final,asca_nnota) < 6.0 then 'APROBADO CON DISTINCION'   "& vbCrLf &_
			"                                           when isnull(promedio_final,asca_nnota) >= 6.0 and isnull(promedio_final,asca_nnota) <= 7.0 then 'APROBADO CON DISTINCION MAXIMA' "& vbCrLf &_
			"                                      end "& vbCrLf &_
 			" end as distincion_obtenida,g.asca_nfolio as folio, protic.trunc(g.asca_fsalida) as fecha_examen, "& vbCrLf &_
			" protic.obtener_direccion(e.pers_ncorr,1,'CNPB') as dirección, protic.obtener_direccion(e.pers_ncorr,1,'C-C') as ciudad, "& vbCrLf &_
			" e.pers_tfono as teléfono, e.pers_tcelular as celular, e.pers_temail as email, "& vbCrLf &_
			" case when replace(replace(c.espe_tdesc,'(D)',''),'(V)','') "& vbCrLf &_
			"       like '%sin mencion%' then ''  "& vbCrLf &_
			"       when replace(replace(c.espe_tdesc,'(D)',''),'(V)','') "& vbCrLf &_
			"       like '%plan comun%' then '' "& vbCrLf &_
			" else replace(replace(c.espe_tdesc,'(D)',''),'(V)','') end  as mencion_x_defecto, "& vbCrLf &_
			" case f.tsca_ccod when 4 then 'NO' else (select case count(*) when 0 then 'NO' else 'SI' end from alumnos_salidas_carrera ta, salidas_carrera tb where ta.pers_ncorr=e.pers_ncorr and ta.saca_ncorr=tb.saca_ncorr "& vbCrLf &_
			"  and tb.carr_ccod=d.carr_ccod and tb.tsca_ccod=3) end as tiene_grado, "& vbCrLf &_
			" case f.tsca_ccod when 4 then '' else isnull((select TOP 1 tb.saca_tdesc from alumnos_salidas_carrera ta, salidas_carrera tb where ta.pers_ncorr=e.pers_ncorr and ta.saca_ncorr=tb.saca_ncorr "& vbCrLf &_
			"  and tb.carr_ccod=d.carr_ccod and tb.tsca_ccod=3),'') end as grado_academico, isnull(f.linea_1_certificado,'') + ' ' + isnull(f.linea_2_certificado,'') as  mencion_x_defecto2, "& vbCrLf &_
			" case isnull(tta.ACADEMICA,'N') when 'N' then ' - ACADEMICA' else ' ' end + case isnull(tta.FINANCIERA,'N') when 'N' then ' - FINANCIERA' else ' ' end +  "& vbCrLf &_
			" case isnull(tta.BIBLIOTECA,'N') when 'N' then ' - BIBLIOTECA' else ' ' end + case isnull(tta.AUDIOVISUAL,'N') when 'N' then ' - AUDIOVISUAL' else ' ' end +   "& vbCrLf &_
			" case isnull(tta.CEDULA_DI,'N') when 'N' then ' - CÉDULA DE IDENTIDAD' else ' ' end +  "& vbCrLf &_
			" case when f.tsca_ccod = 1 or tsca_ccod=2 or tsca_ccod=4 or tsca_ccod=5 or tsca_ccod=6  "& vbCrLf &_
			"      then  case isnull(tta.LICENCIA_EM,'N') when 'N' then ' - LICENCIA ENSEÑANZA MEDIA' else ' ' end + case isnull(tta.CONCENTRACION_EM,'N') when 'N' then ' - NOTAS ENSEÑANZA MEDIA' else ' ' end +  "& vbCrLf &_
			"             case isnull(tta.PAA_PSU,'N') when 'N' then ' - RESULTADOS PAA/PSU' else ' ' end   "& vbCrLf &_
			" else  case isnull(tta.CERTIFICADO_TG,'N') when 'N' then ' - CERTIFICADO TITULO O GRADO' else ' ' end + case isnull(tta.CONCENTRACION_NU,'N') when 'N' then ' - CONCENTRACION NOTAS UNIVERSIDAD' else ' ' end +  "& vbCrLf &_
			"        case isnull(tta.CURRICULUM_VITAE,'N') when 'N' then ' - CURRICULUM VITAE' else ' ' end	  "& vbCrLf &_			   
			" end as restricciones  "& vbCrLf &_
			" from detalles_titulacion_carrera a join  planes_estudio b  "& vbCrLf &_
			"		on a.plan_ccod=b.plan_ccod  "& vbCrLf &_
			" join especialidades c  "& vbCrLf &_
			"  		on b.espe_ccod=c.espe_ccod  "& vbCrLf &_
			" join carreras d  "& vbCrLf &_
			"  		on c.carr_ccod=d.carr_ccod  "& vbCrLf &_
			" join personas e "& vbCrLf &_ 
			"  		on a.pers_ncorr=e.pers_ncorr  "& vbCrLf &_
			" join alumnos_salidas_carrera g  "& vbCrLf &_
			"		on a.pers_ncorr=g.pers_ncorr  "& vbCrLf &_
			" join salidas_carrera f "& vbCrLf &_
			"  		on g.saca_ncorr=f.saca_ncorr and a.carr_ccod=f.carr_ccod "& vbCrLf &_
			" left outer join requerimientos_titulacion tta " & vbCrLf &_
			"       on a.pers_ncorr = tta.pers_ncorr " & vbCrLf &_
			" where isnull(id_ceremonia,0) <> 0 "& vbCrLf &_
			" and cast(a.id_ceremonia as varchar) = '"&codigo_fecha&"' "
			
			if carr_ccod <> "" then 
				consulta = consulta & " and d.carr_ccod='"&carr_ccod&"'"
			end if
			
			consulta = consulta & " UNION  "& vbCrLf &_
								  "	  select    "& vbCrLf &_
								  "	 (select top 1 sede_tdesc from sedes uu  "& vbCrLf &_
								  "	   where uu.sede_ccod=g.sede_ccod) as sede_tdesc,   "& vbCrLf &_
								  "	  linea_1_certificado + ' ' + linea_2_certificado as carr_tdesc,  "& vbCrLf &_ 
								  "	  '' as jorn_tdesc,   "& vbCrLf &_
								  "	   '' as mencion,   "& vbCrLf &_
								  "	   cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut,   "& vbCrLf &_
								  "	   pers_tnombre as nombres, pers_tape_paterno + ' ' + pers_tape_materno as apellidos,   "& vbCrLf &_
								  "	   replace(isnull(promedio_final,asca_nnota),',','.') as nota,   "& vbCrLf &_
								  "	  (select top 1 anos_ccod from alumnos_salidas_intermedias t2, periodos_academicos t4   "& vbCrLf &_
								  "	  where t2.pers_ncorr=e.pers_ncorr and t2.saca_ncorr=f.saca_ncorr and t2.peri_ccod=t4.peri_ccod) as anos_ccod,   "& vbCrLf &_
								  "	  case when (select top 1 anos_ccod from alumnos_salidas_intermedias t2, periodos_academicos t4   "& vbCrLf &_
								  "	  where t2.pers_ncorr=e.pers_ncorr and t2.saca_ncorr=f.saca_ncorr and t2.peri_ccod=t4.peri_ccod) <= 2005    "& vbCrLf &_
								  "									then case when isnull(promedio_final,asca_nnota) >= 4.0 and isnull(promedio_final,asca_nnota) < 5.0 then 'UNANIMIDAD'   "& vbCrLf &_
								  "											  when isnull(promedio_final,asca_nnota) >= 5.0 and isnull(promedio_final,asca_nnota) < 5.5 then 'UN VOTO DE DISTINCION'    "& vbCrLf &_
								  "											  when isnull(promedio_final,asca_nnota) >= 5.5 and isnull(promedio_final,asca_nnota) < 6.0 then 'DOS VOTOS DE DISTINCION'   "& vbCrLf &_
								  "											  when isnull(promedio_final,asca_nnota) >= 6.0 and isnull(promedio_final,asca_nnota) < 6.5 then 'TRES VOTOS DE DISTINCION'   "& vbCrLf &_
								  "											  when isnull(promedio_final,asca_nnota) >= 6.5 and isnull(promedio_final,asca_nnota) <= 7.0 then 'APROBADO CON DISTINCION MAXIMA'   "& vbCrLf &_
								  "										  end    "& vbCrLf &_
								  "									 else case when isnull(promedio_final,asca_nnota) >= 4.0 and isnull(promedio_final,asca_nnota) < 5.0 then 'APROBADO POR UNANIMIDAD'   "& vbCrLf &_
								  "											   when isnull(promedio_final,asca_nnota) >= 5.0 and isnull(promedio_final,asca_nnota) < 6.0 then 'APROBADO CON DISTINCION'     "& vbCrLf &_
								  "											   when isnull(promedio_final,asca_nnota) >= 6.0 and isnull(promedio_final,asca_nnota) <= 7.0 then 'APROBADO CON DISTINCION MAXIMA'   "& vbCrLf &_
								  "										  end   "& vbCrLf &_
								  "	 end as distincion_obtenida,g.asca_nfolio as folio, protic.trunc(g.asca_fsalida) as fecha_examen,   "& vbCrLf &_
								  "	 protic.obtener_direccion(e.pers_ncorr,1,'CNPB') as dirección, protic.obtener_direccion(e.pers_ncorr,1,'C-C') as ciudad,   "& vbCrLf &_
								  "	 e.pers_tfono as teléfono, e.pers_tcelular as celular, e.pers_temail as email,   "& vbCrLf &_
								  "	 ''  as mencion_x_defecto,   "& vbCrLf &_
								  "	 'NO' as tiene_grado,   "& vbCrLf &_
								  "	 '' as grado_academico, isnull(f.linea_1_certificado,'') + ' ' + isnull(f.linea_2_certificado,'') as  mencion_x_defecto2,   "& vbCrLf &_
								  "  case isnull(tta.ACADEMICA,'N') when 'N' then ' - ACADEMICA' else ' ' end + case isnull(tta.FINANCIERA,'N') when 'N' then ' - FINANCIERA' else ' ' end +  "& vbCrLf &_
								  "  case isnull(tta.BIBLIOTECA,'N') when 'N' then ' - BIBLIOTECA' else ' ' end + case isnull(tta.AUDIOVISUAL,'N') when 'N' then ' - AUDIOVISUAL' else ' ' end +   "& vbCrLf &_
								  "  case isnull(tta.CEDULA_DI,'N') when 'N' then ' - CÉDULA DE IDENTIDAD' else ' ' end +  "& vbCrLf &_
								  "  case when f.tsca_ccod = 1 or tsca_ccod=2 or tsca_ccod=4 or tsca_ccod=5 or tsca_ccod=6  "& vbCrLf &_
								  "       then  case isnull(tta.LICENCIA_EM,'N') when 'N' then ' - LICENCIA ENSEÑANZA MEDIA' else ' ' end + case isnull(tta.CONCENTRACION_EM,'N') when 'N' then ' - NOTAS ENSEÑANZA MEDIA' else ' ' end +  "& vbCrLf &_
								  "             case isnull(tta.PAA_PSU,'N') when 'N' then ' - RESULTADOS PAA/PSU' else ' ' end   "& vbCrLf &_
								  "  else  case isnull(tta.CERTIFICADO_TG,'N') when 'N' then ' - CERTIFICADO TITULO O GRADO' else ' ' end + case isnull(tta.CONCENTRACION_NU,'N') when 'N' then ' - CONCENTRACION NOTAS UNIVERSIDAD' else ' ' end +  "& vbCrLf &_
								  "        case isnull(tta.CURRICULUM_VITAE,'N') when 'N' then ' - CURRICULUM VITAE' else ' ' end	  "& vbCrLf &_			   
								  "  end as restricciones  "& vbCrLf &_
								  "	 from detalles_titulacion_carrera a join  personas e "& vbCrLf &_
								  "		on a.pers_ncorr = e.pers_ncorr "& vbCrLf &_
								  "   join alumnos_salidas_carrera g "& vbCrLf &_
								  "	 	on a.pers_ncorr = g.pers_ncorr "& vbCrLf &_
								  "	 join salidas_carrera f "& vbCrLf &_
								  "	 	on a.plan_ccod = f.saca_ncorr and a.carr_ccod = f.carr_ccod "& vbCrLf &_
								  "	 join carreras d   "& vbCrLf &_
								  "	 	on f.carr_ccod = d.carr_ccod  "& vbCrLf &_
								  "  left outer join requerimientos_titulacion tta " & vbCrLf &_
						    	  "     on a.pers_ncorr = tta.pers_ncorr " & vbCrLf &_
								  "	 where isnull(id_ceremonia,0) <> 0   "& vbCrLf &_
								  "	 AND EXISTS (SELECT 1 FROM ALUMNOS_SALIDAS_INTERMEDIAS TTT WHERE TTT.PERS_NCORR = A.PERS_NCORR and ttt.saca_ncorr=g.saca_ncorr)  "& vbCrLf &_
								  "	 and cast(a.id_ceremonia as varchar) = '"&codigo_fecha&"' "
							if carr_ccod <> "" then 
								consulta = consulta & " and d.carr_ccod='"&carr_ccod&"'"
							end if  
								  

f_lista.Consultar consulta & " )table1 order by carr_tdesc, mencion, apellidos "
'response.write("<pre>"&consulta&" )table1 order by carr_tdesc, mencion, apellidos </pre>")	
'Response.Write("<pre>"&sql_detalles_mate&"</pre>")
'response.End()

'------------------------------------------------------------------------------
%>
<html>
<head>
<title><%=pagina.Titulo%></title>  
<!--<meta http-equiv="Content-Type" content="text/html;">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">-->

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="center"><font size="4"><strong>Listado de alumnos participantes en Ceremonia de Titulación</strong></font></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Carrera : </strong><%=carr_tdesc%></td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Fecha Actual : </strong><%=fecha_01%></td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Ceremonia : <%=fecha_ceremonia%></strong></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="center"><table width="75%" border="1">
									  <tr> 
										<td bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Mención</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Mención Por Defecto</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Nombres</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Apellidos</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Con Grado</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Grado Académico</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Calificación</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Distinción Obtenida</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>N° de Folio</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Fecha Examen</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Dirección</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Ciudad</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Teléfono</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Celular</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>E-mail</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Restricciones</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while f_lista.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("sede_tdesc")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("carr_tdesc")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("jorn_tdesc")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("mencion")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("mencion_x_defecto2")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("rut")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("nombres")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("apellidos")%></div></td>	
										<td><div align="left"><%=f_lista.ObtenerValor("tiene_grado")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("grado_academico")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("nota")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("distincion_obtenida")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("folio")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("fecha_examen")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("dirección")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("ciudad")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("teléfono")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("celular")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("email")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("restricciones")%></div></td>
									  </tr>
									  <%fila= fila + 1  
										wend %>
									</table>
	</td>
</tr>
</table>

</body>
</html>