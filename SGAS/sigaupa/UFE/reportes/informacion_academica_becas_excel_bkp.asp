<!-- #include file = "../../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next

Response.AddHeader "Content-Disposition", "attachment;filename=beneficiarios_cae.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

'------------------------------------------------------------------------------------
'response.End()
fecha=conexion.consultaUno("select getDate() ")

v_mes_actual	= 	Month(now())
v_ano_actual	= 	 Year(now())

sem1_actual = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&v_ano_actual&"' and plec_ccod=1")
sem2_actual = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&v_ano_actual&"' and plec_ccod=2")
sem1_anterior = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&v_ano_actual-1&"' and plec_ccod=1")
sem2_anterior = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&v_ano_actual-1&"' and plec_ccod=2")

c_dato_promedio = ""
mensaje_aclaratorio = ""
if v_mes_actual >= 9 and v_mes_actual <= 11 then
c_dato_promedio = " ,(select count(*) " & vbCrLf & _
                  "   from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d,situaciones_finales e " & vbCrLf & _
                  "   where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.matr_ncorr=d.matr_ncorr " & vbCrLf & _
				  "	  and isnull(d.carg_nnota_final,0.0) > 0.0 and a.pers_ncorr=tra.pers_ncorr and c.carr_ccod=tra.carr_ccod " & vbCrLf & _
				  "	  and d.sitf_ccod=e.sitf_ccod " & vbCrLf & _
				  "	  and cast(b.peri_ccod as varchar)='"&sem1_actual&"' ) as total_carga, " & vbCrLf & _
				  "	 (select count(*)  " & vbCrLf & _
                  "   from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d,situaciones_finales e " & vbCrLf & _
                  "   where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.matr_ncorr=d.matr_ncorr " & vbCrLf & _
				  "   and isnull(d.carg_nnota_final,0.0) > 0.0 and a.pers_ncorr=tra.pers_ncorr and c.carr_ccod=tra.carr_ccod " & vbCrLf & _
				  "   and d.sitf_ccod=e.sitf_ccod and sitf_baprueba='S' " & vbCrLf & _
				  "   and cast(b.peri_ccod as varchar)='"&sem1_actual&"' ) as total_aprobados "
mensaje_aclaratorio = "El avance curricular tomo como base los ramos cursados y aprobados durante el 1er semestre del año actual"
semestre_carga = sem2_actual
elseif  v_mes_actual = 12 then
c_dato_promedio = " ,(select count(*) " & vbCrLf & _
                  "   from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d,situaciones_finales e " & vbCrLf & _
                  "   where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.matr_ncorr=d.matr_ncorr " & vbCrLf & _
				  "   and isnull(d.carg_nnota_final,0.0) > 0.0 and a.pers_ncorr=tra.pers_ncorr and c.carr_ccod=tra.carr_ccod " & vbCrLf & _
				  "   and d.sitf_ccod=e.sitf_ccod " & vbCrLf & _
				  "	  and cast(b.peri_ccod as varchar) in ('"&sem1_actual&"','"&sem2_actual&"') ) as total_carga, " & vbCrLf & _
				  "	 (select count(*)  " & vbCrLf & _
                  "   from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d,situaciones_finales e " & vbCrLf & _
                  "   where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.matr_ncorr=d.matr_ncorr " & vbCrLf & _
				  "   and isnull(d.carg_nnota_final,0.0) > 0.0 and a.pers_ncorr=tra.pers_ncorr and c.carr_ccod=tra.carr_ccod " & vbCrLf & _
				  "   and d.sitf_ccod=e.sitf_ccod and sitf_baprueba='S' " & vbCrLf & _
				  "   and cast(b.peri_ccod as varchar) in ('"&sem1_actual&"','"&sem2_actual&"') ) as total_aprobados " 
mensaje_aclaratorio = "El avance curricular tomo como base los ramos cursados y aprobados durante el 1er y 2do semestre del año anterior "
semestre_carga = sem2_actual

else
c_dato_promedio = " ,isnull((select count(*) " & vbCrLf & _
                  "   from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d,situaciones_finales e " & vbCrLf & _
                  "   where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.matr_ncorr=d.matr_ncorr " & vbCrLf & _
				  "   and isnull(d.carg_nnota_final,0.0) > 0.0 and a.pers_ncorr=tra.pers_ncorr and c.carr_ccod=tra.carr_ccod " & vbCrLf & _
				  "   and d.sitf_ccod=e.sitf_ccod " & vbCrLf & _
				  "	  and cast(b.peri_ccod as varchar) in ('"&sem1_anterior&"','"&sem2_anterior&"') ),0) as total_carga, " & vbCrLf & _
				  
				  "	 isnull((select count(*)  " & vbCrLf & _
                  "   from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d,situaciones_finales e " & vbCrLf & _
                  "   where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.matr_ncorr=d.matr_ncorr " & vbCrLf & _
				  "   and isnull(d.carg_nnota_final,0.0) > 0.0 and a.pers_ncorr=tra.pers_ncorr and c.carr_ccod=tra.carr_ccod " & vbCrLf & _
				  "   and d.sitf_ccod=e.sitf_ccod and sitf_baprueba='S' " & vbCrLf & _
				  "   and cast(b.peri_ccod as varchar) in ('"&sem1_anterior&"','"&sem2_anterior&"') ),0) as total_aprobados " 
mensaje_aclaratorio = "El avance curricular tomo como base los ramos cursados y aprobados durante el 1er y 2do semestre del año anterior "
semestre_carga = sem2_actual

end if

if v_mes_actual >= 1 and v_mes_actual <= 4 then
	v_ano_actual	= v_ano_actual	- 1
END IF

set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conexion

 consulta = "select pers_ncorr,pers_nrut as rut,pers_xdv as dv,nombre,carr_ccod,anos_adicionales,arancel_solicitado,rut_banco, carrera,sede,jornada, plan_ccod,ingreso,ano_obtencion,estado,periodo,nivel_estudio,nivel_estudio_max, "& vbCrLf &_
            " tra2.total_carga,tra2.total_aprobados, case when tra2.total_carga <> 0 then cast((tra2.total_aprobados * 100) / tra2.total_carga as numeric(5,2)) else 0 end as avance, "& vbCrLf &_
            " (select max(espe_nduracion) from especialidades ttt where ttt.carr_ccod=tra2.carr_ccod) as duracion_carrera"& vbCrLf &_
			" from "& vbCrLf &_
			"( "& vbCrLf &_
            "select pers_ncorr,pers_nrut,pers_xdv,nombre,carr_ccod, carrera,sede,jornada, plan_ccod,anos_adicionales,arancel_solicitado,rut_banco,protic.ano_ingreso_carrera_egresa2(pers_ncorr,carr_ccod) as ingreso,ano_obtencion,estado,periodo, "& vbCrLf &_
		    "    (select top 1 nive_ccod from malla_curricular tr where tr.plan_ccod = tra.plan_ccod   " & vbCrLf & _
		    "     and isnull(tr.mall_npermiso,0) = 0    " & vbCrLf & _
		    "     and isnull(protic.estado_ramo_alumno(tra.pers_ncorr,tr.asig_ccod,tra.carr_ccod,tr.plan_ccod,'"&semestre_carga&"'),'') in ('','CA') order by nive_ccod) as nivel_estudio,  " & vbCrLf & _
		    "    (select top 1 nive_ccod from malla_curricular tr where tr.plan_ccod = tra.plan_ccod   " & vbCrLf & _
		    "     and isnull(tr.mall_npermiso,0) = 0    " & vbCrLf & _
		    "     and isnull(protic.estado_ramo_alumno(tra.pers_ncorr,tr.asig_ccod,tra.carr_ccod,tr.plan_ccod,'"&semestre_carga&"'),'') <> '' order by nive_ccod desc) as nivel_estudio_max  " & vbCrLf & _			
            "  "& c_dato_promedio & vbCrLf & _
			" From "& vbCrLf &_
			" ( "& vbCrLf &_
            "	 select distinct b.pers_ncorr, b.pers_nrut,b.pers_xdv , pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre as nombre, "& vbCrLf &_
			"	(select top 1 carr_tdesc "& vbCrLf &_
			"	 from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f,  "& vbCrLf &_
			"		  estados_matriculas g,periodos_academicos h  "& vbCrLf &_
			"	 where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod  "& vbCrLf &_
			"	 and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod  "& vbCrLf &_
			"	 and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as carrera,  "& vbCrLf &_
			"	(select top 1 sede_tdesc "& vbCrLf &_
			"	 from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f,  "& vbCrLf &_
			"		  estados_matriculas g,periodos_academicos h,sedes i  "& vbCrLf &_
			"	 where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod  "& vbCrLf &_
			"	 and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod  "& vbCrLf &_
			"	 and d.peri_ccod=h.peri_ccod and d.sede_ccod=i.sede_ccod order by d.peri_ccod desc) as sede,  "& vbCrLf &_
			"	(select top 1 jorn_tdesc "& vbCrLf &_
			"	 from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f,  "& vbCrLf &_
			"		  estados_matriculas g,periodos_academicos h,jornadas i  "& vbCrLf &_
			"	 where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod  "& vbCrLf &_
			"	 and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod  "& vbCrLf &_
			"	 and d.peri_ccod=h.peri_ccod and d.jorn_ccod=i.jorn_ccod order by d.peri_ccod desc) as jornada,  "& vbCrLf &_
			"	 (select top 1 anos_adicionales from ufe_alumnos_cae ttt where ttt.rut=b.pers_nrut and ttt.anos_ccod=a.anos_ccod) as anos_adicionales,  "& vbCrLf &_
			"	 (select isnull((select arancel_solicitado from ufe_alumnos_cae ttt where ttt.rut=b.pers_nrut and ttt.anos_ccod=a.anos_ccod),0)) as arancel_solicitado,  "& vbCrLf &_
			"	 (select baca_tdesc from ufe_alumnos_cae ttt,ufe_bancos_cae fff where ttt.rut=b.pers_nrut and ttt.anos_ccod=a.anos_ccod and ttt.rut_banco=fff.baca_nrut) as rut_banco,  "& vbCrLf &_
			" (select top 1 anos_ccod from ufe_alumnos_cae ggg where ggg.taca_ccod =1 and ggg.rut=b.pers_nrut ) as ano_obtencion, "& vbCrLf &_
			"	(select top 1 emat_tdesc  "& vbCrLf &_
			"	 from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f,  "& vbCrLf &_
			"		  estados_matriculas g, periodos_academicos h  "& vbCrLf &_
			"	 where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod  "& vbCrLf &_
			"	 and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod  "& vbCrLf &_
			"	 and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as estado,  "& vbCrLf &_
			"	(select top 1 cast(anos_ccod as varchar)+'-'+cast(plec_ccod as varchar)  "& vbCrLf &_
			"	 from alumnos c (nolock), ofertas_academicas d, especialidades e,  "& vbCrLf &_
			"		  carreras f, estados_matriculas g, periodos_academicos h  "& vbCrLf &_
			"	 where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod  "& vbCrLf &_
			"	 and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod  "& vbCrLf &_
			"	 and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as periodo,  "& vbCrLf &_
			"	(select top 1 f.carr_ccod  "& vbCrLf &_
			"	 from alumnos c (nolock), ofertas_academicas d, especialidades e,  "& vbCrLf &_
			"		  carreras f, estados_matriculas g, periodos_academicos h  "& vbCrLf &_
			"	 where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod  "& vbCrLf &_
			"	 and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod  "& vbCrLf &_
			"	 and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as carr_ccod,  "& vbCrLf &_
			"	(select top 1 plan_ccod  "& vbCrLf &_
			"	 from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f,  "& vbCrLf &_
			"		  estados_matriculas g, periodos_academicos h  "& vbCrLf &_
			"	 where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod  "& vbCrLf &_
			"	 and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod  "& vbCrLf &_
			"	 and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as plan_ccod "& vbCrLf &_
			"	 from ufe_alumnos_cae a, personas b "& vbCrLf &_
			"	 where a.rut = b.pers_nrut "& vbCrLf &_
			"    and esca_ccod=1"& vbCrLf &_
			"	 and cast(a.anos_ccod as varchar)='"&v_ano_actual&"'  "& vbCrLf &_
			" )tra "& vbCrLf &_
			")tra2 "& vbCrLf &_
			" ORDER BY nombre "
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_alumnos.Consultar consulta

'response.End()
%>
<html>
<head>
<title>Renovantes históricos por estado cae <%=v_ano_actual%></title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Renovantes históricos CAE por estado <%=v_ano_actual%></font></div></td>
 </tr>
 <tr> 
    <td colspan="4">&nbsp;</td>
 </tr>
 <tr> 
    <td colspan="4">Fecha Actual: <%=fecha%></div></td>
 </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
<tr>
	<td colspan="2" align="center">
		<table width="90%" border="1">
		  <tr> 
				<td bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>DV</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Nombre</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Última Sede</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Última Carrera</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Última Jornada</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Año ingreso carrera</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Año obtención CAE</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Último Estado</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Último Período</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Total ramos cursados</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Total ramos aprobados</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Rendimiento académico</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Nivel de estudio Actual</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Nivel de estudio Avance</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Duración carrera (semestres)</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Años adicionales</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Arancel solicitado</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Rut banco</strong></div></td>
			</tr>
			<% fila = 1
			 while f_alumnos.siguiente %>
			<tr> 
				<td><div align="center"><%=fila%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("rut")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("dv")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("nombre")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("sede")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("carrera")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("jornada")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("ingreso")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("ano_obtencion")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("estado")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("periodo")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("total_carga")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("total_aprobados")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("avance")%>%</div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("nivel_estudio")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("nivel_estudio_max")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("duracion_carrera")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("anos_adicionales")%></div></td>
				<td><div align="center"><%=formatcurrency(f_alumnos.obtenerValor("arancel_solicitado"),0)%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("rut_banco")%></div></td>	
			</tr>
			<%fila= fila + 1  
			wend %>
		</table>
	</td>
</tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>