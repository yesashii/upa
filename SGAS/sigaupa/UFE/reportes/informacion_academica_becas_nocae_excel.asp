<!-- #include file = "../../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next

Response.AddHeader "Content-Disposition", "attachment;filename=informacion_academica_no_CAE.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

'------------------------------------------------------------------------------------
'response.End()
fecha=conexion.consultaUno("select getDate() ")

v_mes_actual	= 	Month(now())
v_ano_actual	= 	 Year(now())

c_dato_promedio = ""
mensaje_aclaratorio = ""


if v_mes_actual >= 1 and v_mes_actual <= 4 then
	v_ano_actual	= v_ano_actual	- 1
END IF

set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conexion


			
			
consulta =  "	select pers_nrut,pers_xdv,NOMBRE,SEDE,CARRERA, "& vbCrLf &_ 
			"    JORNADA, EMAIL, ANO_INGRESO,ESTADO_ACADEMICO, total_carga,total_aprobados, "& vbCrLf &_ 
			"    case when total_carga <> 0 then cast((total_aprobados * 100) / total_carga as numeric(5,2)) else 0 end as avance, duracion_carrera "& vbCrLf &_ 
			"	 "& vbCrLf &_
			"	from   "& vbCrLf &_ 
			"	(select distinct ma.pers_nrut,ma.pers_xdv,(ma.ap_paterno + ' ' + ma.ap_materno + ' ' + ma.nombre ) as NOMBRE,ma.SEDE,ma.CARRERA, "& vbCrLf &_ 
			"    ma.email,ma.JORNADA, ma.ANO_INGRESO,ma.ESTADO_ACADEMICO,(select max(espe_nduracion) from especialidades ttt where ttt.carr_ccod=ca.carr_ccod) as duracion_carrera  ,    "& vbCrLf &_ 
			"    (select count(*)  "& vbCrLf &_ 
			"      from alumnos ta, ofertas_academicas tb, especialidades tc, cargas_academicas td,situaciones_finales te  "& vbCrLf &_ 
			"      where ta.ofer_ncorr=tb.ofer_ncorr and tb.espe_ccod=tc.espe_ccod and ta.matr_ncorr=td.matr_ncorr  "& vbCrLf &_ 
			"	  and isnull(td.carg_nnota_final,0.0) > 0.0 and ta.pers_ncorr=b.pers_ncorr and tc.carr_ccod=ca.carr_ccod  "& vbCrLf &_ 
			"	  and td.sitf_ccod=te.sitf_ccod  "& vbCrLf &_ 
			"	  and tb.peri_ccod in (case when datepart(month,getdate()) >= 9 and datepart(month,getdate()) <=12   "& vbCrLf &_ 
			"                       then (select peri_ccod from periodos_academicos ttt where ttt.anos_ccod=ee.anos_ccod  "& vbCrLf &_ 
			"                              and ttt.plec_ccod=1) "& vbCrLf &_ 
			"                        else (select top 1 peri_ccod from periodos_academicos ttt where ttt.anos_ccod=ee.anos_ccod -1 "& vbCrLf &_ 
			"                              and ttt.plec_ccod in (1,2)) "& vbCrLf &_ 
			"                        end)                              "& vbCrLf &_ 
			"      ) as total_carga,									"& vbCrLf &_ 
			"     (select count(*) 										"& vbCrLf &_ 
			"      from alumnos ta, ofertas_academicas tb, especialidades tc, cargas_academicas td,situaciones_finales te "& vbCrLf &_ 
			"      where ta.ofer_ncorr=tb.ofer_ncorr and tb.espe_ccod=tc.espe_ccod and ta.matr_ncorr=td.matr_ncorr  "& vbCrLf &_ 
			"	  and isnull(td.carg_nnota_final,0.0) > 0.0 and ta.pers_ncorr=b.pers_ncorr and tc.carr_ccod=ca.carr_ccod  "& vbCrLf &_ 
			"	  and td.sitf_ccod=te.sitf_ccod and te.sitf_baprueba='S' "& vbCrLf &_ 
			"	  and tb.peri_ccod in (case when datepart(month,getdate()) >= 9 and datepart(month,getdate()) <=12   "& vbCrLf &_ 
			"                       then (select peri_ccod from periodos_academicos ttt where ttt.anos_ccod=ee.anos_ccod "& vbCrLf &_ 
			"                              and ttt.plec_ccod=1) "& vbCrLf &_ 
			"                        else (select top 1 peri_ccod from periodos_academicos ttt where ttt.anos_ccod=ee.anos_ccod -1 "& vbCrLf &_ 
			"                              and ttt.plec_ccod in (1,2)) "& vbCrLf &_ 
			"                       end)                                       "& vbCrLf &_ 
			"      ) as total_aprobados  "& vbCrLf &_ 
			"    from  "& vbCrLf &_ 
			"       personas b, alumnos cc, ofertas_academicas dd,  "& vbCrLf &_ 
			"       periodos_academicos ee, aranceles ar, especialidades es , "& vbCrLf &_ 
			"       matriculas_totales_ufe ma, carreras ca  "& vbCrLf &_ 
			"    where b.PERS_NCORR=cc.PERS_NCORR  "& vbCrLf &_ 
			"    and ma.pers_nrut=b.PERS_NRUT "& vbCrLf &_ 
			"    and ma.COD_CARRERA=ca.carr_ccod "& vbCrLf &_ 
			"    and ma.periodo_aca= ee.peri_ccod  "& vbCrLf &_ 
			"    and b.PERS_NRUT not in (select rut from ufe_alumnos_cae where cast(anos_ccod as varchar)='"&v_ano_actual&"' ) "& vbCrLf &_
			"    and cc.OFER_NCORR=dd.OFER_NCORR  "& vbCrLf &_ 
			"    and dd.PERI_CCOD=ee.PERI_CCOD   "& vbCrLf &_ 
			"    and dd.espe_ccod= es.espe_ccod  "& vbCrLf &_ 
			"    and dd.aran_ncorr= ar.aran_ncorr  "& vbCrLf &_ 
			"    and cast(ee.anos_ccod as varchar)='"&v_ano_actual&"' "& vbCrLf &_ 
			"    and cc.EMAT_CCOD <> 9  "& vbCrLf &_ 
			"    and cc.ALUM_NMATRICULA <>777  "& vbCrLf &_ 
			"    and ma.aran_mcolegiatura >0  "& vbCrLf &_ 
			"    ) vs "& vbCrLf &_ 
			"	ORDER BY nombre  "

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
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Alumnos UPA <%=v_ano_actual%></font></div></td>
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
                <td bgcolor="#FFFFCC"><div align="center"><strong>Email</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Año ingreso carrera</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Último Estado</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Total ramos cursados</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Total ramos aprobados</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Rendimiento académico</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Duración carrera (semestres)</strong></div></td>
		</tr>
			<% fila = 1
			 while f_alumnos.siguiente %>
			<tr> 
				<td><div align="center"><%=fila%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("pers_nrut")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("pers_xdv")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("nombre")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("sede")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("carrera")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("jornada")%></div></td>
                <td><div align="left"><%=f_alumnos.obtenerValor("email")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("ano_ingreso")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("estado_academico")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("total_carga")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("total_aprobados")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("avance")%>%</div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("duracion_carrera")%></div></td>
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