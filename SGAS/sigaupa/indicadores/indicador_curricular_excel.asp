<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=indicador_curricular.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Indicador curricular" 

set conexion = new cConexion
conexion.inicializar "upacifico"
 carr_ccod  =   request.QueryString("carr_ccod")
 asig_ccod	=	request.querystring("asig_ccod")
 jorn_ccod	=	request.querystring("jorn_ccod")
 sede_ccod	=	request.querystring("sede_ccod")
 anos_ccod	=	request.querystring("anos_ccod")
 todas	    =	request.querystring("todas")
 
 Sede = sede_ccod
 sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
 carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar) ='"&carr_ccod&"'")
 jorn_tdesc = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar) ='"&jorn_ccod&"'")
 if (todas = "" or todas="N") then
 	asig_tdesc = conexion.consultaUno("select asig_ccod + ' --> '+ asig_tdesc from asignaturas where cast(asig_ccod as varchar) ='"&asig_ccod&"'")
 else
    asig_tdesc = "<< Todas las Asignaturas >>"
 end if	
 



fecha_01 = conexion.consultaUno("select protic.trunc(getDate())")

set formulario = new CFormulario
formulario.carga_parametros "tabla_vacia.xml", "tabla"
formulario.inicializar conexion 

 
 if (todas = "" or todas="N") then
 	filtro_asignaturas = "and (cast(a.asig_ccod as varchar) = '"&asig_ccod&"' or '"&asig_ccod&"' is null )"
 else
	filtro_asignaturas = ""
 end if	

consulta = " select peri_ccod, peri_tdesc,asig_ccod + ' ' + asig_tdesc as asignatura, secc_tdesc,nive_ccod,estado,cant_alumnos, "& vbCrLf	&_
			" aprobados, cast((aprobados * 100.00) / cant_alumnos as decimal(5,2)) as porc_aprobados, "& vbCrLf	&_
			" reprobados, cast((reprobados * 100.00) / cant_alumnos as decimal(5,2)) as porc_reprobados, "& vbCrLf	&_
			" faltantes, cast((faltantes * 100.00) / cant_alumnos as decimal(5,2)) as porc_faltantes, "& vbCrLf	&_
			" cast(promedio as decimal (2,1)) as promedio, "& vbCrLf	&_
			" menor_a_4, mayor_o_igual_a_4, profesor "& vbCrLf	&_
			" from "& vbCrLf	&_
			" ( "& vbCrLf	&_
			"  SELECT distinct d.peri_ccod,d.peri_tdesc,a.ASIG_CCOD, a.ASIG_TDESC ,secc_tdesc ,b.secc_ccod,e.nive_ccod, "& vbCrLf	&_
			"  case isnull(b.estado_cierre_ccod,1) when 1 then 'Sin Cerrar' else 'Cerrada' end as estado,  "& vbCrLf	&_
			"  protic.retorna_profesor(b.secc_ccod) as profesor, "& vbCrLf	&_
			" (select count(aa.matr_ncorr) from cargas_academicas aa , alumnos bb  "& vbCrLf	&_
			"  where aa.matr_ncorr=bb.matr_ncorr  "& vbCrLf	&_
			" and aa.secc_ccod = b.secc_ccod  "& vbCrLf	&_
			" and aa.carg_nsence is  null  "& vbCrLf	&_
			" and aa.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where secc_ccod_destino = b.secc_ccod)  "& vbCrLf	&_
			" and aa.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=aa.matr_ncorr and asig_ccod = b.asig_ccod)) as cant_alumnos, "& vbCrLf	&_
			" (select count(matr_ncorr) from cargas_academicas aa, situaciones_finales bb  "& vbCrLf	&_
			"                           where aa.secc_ccod=b.secc_ccod and aa.sitf_ccod=bb.sitf_ccod and sitf_baprueba='S') as aprobados, "& vbCrLf	&_
			" (select count(matr_ncorr) from cargas_academicas aa, situaciones_finales bb  "& vbCrLf	&_
			"                           where aa.secc_ccod=b.secc_ccod and aa.sitf_ccod=bb.sitf_ccod and sitf_baprueba='N') as reprobados, "& vbCrLf	&_
			" (select count(matr_ncorr) from cargas_academicas aa "& vbCrLf	&_
			"                           where aa.secc_ccod=b.secc_ccod and isnull(sitf_ccod,'N')='N') as faltantes, "& vbCrLf	&_
			" (select avg(carg_nnota_final) from cargas_academicas aa "& vbCrLf	&_
            "			                where aa.secc_ccod=b.secc_ccod and isnull(carg_nnota_final,0.0) <> 0.0) as promedio, "& vbCrLf	&_
			" (select count(matr_ncorr) from cargas_academicas aa "& vbCrLf	&_
			"                           where aa.secc_ccod=b.secc_ccod and carg_nnota_final < 4.0 and isnull(carg_nnota_final,0.0)<>0.0) as menor_a_4, "& vbCrLf	&_
			" (select count(matr_ncorr) from cargas_academicas aa "& vbCrLf	&_
			"                           where aa.secc_ccod=b.secc_ccod and carg_nnota_final >= 4.0 and isnull(carg_nnota_final,0.0)<>0.0) as mayor_o_igual_a_4 "& vbCrLf	&_
			" FROM asignaturas a, secciones b, bloques_horarios c, periodos_academicos d, malla_curricular e "& vbCrLf	&_
			" WHERE a.asig_ccod=b.asig_ccod and b.secc_ccod  = c.secc_ccod "& vbCrLf	&_
			" and b.asig_ccod=e.asig_ccod and b.mall_ccod = e.mall_ccod "& vbCrLf	&_
			" and b.peri_ccod = d.peri_ccod and cast(d.anos_ccod as varchar)='"&anos_ccod&"' "& vbCrLf	&_
			" and cast(b.sede_ccod as varchar) = '"&sede_ccod&"' "& vbCrLf	&_
			" and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"' "&filtro_asignaturas& vbCrLf	&_
			" and cast(b.carr_ccod as varchar)='"&carr_ccod&"' "& vbCrLf	&_
			" )tabla_a "& vbCrLf	&_
			" where cant_alumnos > 0 "

formulario.Consultar consulta &" order by peri_ccod, asignatura, secc_tdesc"
v_filas=formulario.nroFilas
'response.Write("<pre>"&consulta &" order by peri_ccod, asignatura, secc_tdesc </pre>")
%>
<html>
<head>
<title><%=titulo%></title>  
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="1" align="left"><font size="3"><strong>Indicador de Calificaciones por asignatura</strong></font></td>
</tr>
<tr>
	<td colspan="1">&nbsp;</td>
</tr>
<tr> 
    <td align="left"><strong>Fecha Actual : </strong><%=fecha_01%></td>
</tr>
<tr> 
    <td align="left"><strong>Sede : </strong><%=sede_tdesc%></td>
</tr>
<tr> 
    <td align="left"><strong>Carrera : </strong><%=carr_tdesc%></td>
</tr>
<tr> 
    <td align="left"><strong>Jornada : </strong><%=jorn_tdesc%></td>
</tr>
<tr> 
    <td align="left"><strong>Asignatura : </strong><%=asig_tdesc%></td>
</tr>
<tr> 
    <td align="left"><strong>Año : </strong><%=anos_ccod%></td>
</tr>
<tr>
	<td colspan="1">&nbsp;</td>
</tr>
<tr>
	<td colspan="1" align="left"><table width="100%" border="1">
									  <tr> 
										<td bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Periodo</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Asignatura</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Sección</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Nivel</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Estado</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Profesor</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>N° de Alumnos</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Aprobados</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Indicador Aprobados(%)</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Reprobados</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Indicador Reprobados(%)</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Faltantes</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Indicador Faltantes(%)</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Promedio notas alumnos</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Nota menor que 4.0</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Nota mayor o igual a 4.0</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("peri_tdesc")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("asignatura")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("secc_tdesc")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("nive_ccod")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("estado")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("profesor")%></div></td>
										<td><div align="center"><%=formulario.ObtenerValor("cant_alumnos")%></div></td>
										<td><div align="center"><%=formulario.ObtenerValor("aprobados")%></div></td>	
										<td bgcolor="#FFFFCC"><div align="center"><%=formulario.ObtenerValor("porc_aprobados")%></div></td>	
										<td><div align="center"><%=formulario.ObtenerValor("reprobados")%></div></td>	
										<td bgcolor="#FFFFCC"><div align="center"><%=formulario.ObtenerValor("porc_reprobados")%></div></td>	
										<td><div align="center"><%=formulario.ObtenerValor("faltantes")%></div></td>	
										<td bgcolor="#FFFFCC"><div align="center"><%=formulario.ObtenerValor("porc_faltantes")%></div></td>	
										<td><div align="center"><%=formulario.ObtenerValor("promedio")%></div></td>	
										<td><div align="center"><%=formulario.ObtenerValor("menor_a_4")%></div></td>	
										<td><div align="center"><%=formulario.ObtenerValor("mayor_o_igual_a_4")%></div></td>
										</tr>
									        <%fila= fila + 1  
										wend %>
									 </table>
	</td>
</tr>
</table>

</body>
</html>