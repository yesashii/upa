<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next
Response.AddHeader "Content-Disposition", "attachment;filename=avance_curricular_listado.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

'------------------------------------------------------------------------------------
'response.End()
fecha=conexion.consultaUno("select getDate() ")
tabla = request.querystring("tabla")

set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conexion
if tabla <> "" then
 consulta = "select pers_ncorr,rut,nombre,carr_ccod, carrera, plan_ccod,protic.ano_ingreso_carrera_egresa2(pers_ncorr,carr_ccod) as ingreso,estado,periodo, "& vbCrLf &_
            "    (select count(*) from malla_curricular tr where tr.plan_ccod = tra.plan_ccod   " & vbCrLf & _
		    "     and isnull(tr.mall_npermiso,0) = 0 ) as total_ramos_malla,   " & vbCrLf & _
		    "    (select count(*) from malla_curricular tr where tr.plan_ccod = tra.plan_ccod   " & vbCrLf & _
		    "     and isnull(tr.mall_npermiso,0) = 0    " & vbCrLf & _
		    "     and isnull(protic.estado_ramo_alumno(tra.pers_ncorr,tr.asig_ccod,tra.carr_ccod,tr.plan_ccod,'222'),'') <> '') as total_ramos_aprobados_o_en_curso  " & vbCrLf & _
            " From "& vbCrLf &_
			"( "& vbCrLf &_
            "	select b.pers_ncorr, cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre as nombre, "& vbCrLf &_
			"	 (select top 1 carr_tdesc from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			"	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			"	   and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as carrera, "& vbCrLf &_
			"	 (select top 1 emat_tdesc from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			"	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			"	   and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as estado, "& vbCrLf &_
            "	 (select top 1 cast(anos_ccod as varchar)+'-'+cast(plec_ccod as varchar) from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			"	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			"	   and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as periodo, "& vbCrLf &_
			"	 (select top 1 f.carr_ccod from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			"	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			"	   and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as carr_ccod, "& vbCrLf &_
			"	 (select top 1 plan_ccod from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			"	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			"	   and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as plan_ccod "& vbCrLf &_
			"	 from "&tabla&" a, personas b "& vbCrLf &_
			"	 where a.rut = cast(b.pers_nrut as varchar) "& vbCrLf &_
			"	 and exists (select 1 from alumnos tt (nolock) where tt.pers_ncorr=b.pers_ncorr and tt.emat_ccod=1) "& vbCrLf &_
			")tra "& vbCrLf &_
			" ORDER BY nombre "
else
 consulta= "select '' "
end if
f_alumnos.Consultar consulta

'response.End()
%>
<html>
<head>
<title>Avance Curricular Alumnos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Avance Curricular Alumnos</font></div></td>
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
				<td bgcolor="#FFFFCC"><div align="center"><strong>Nombre</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Última Carrera</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Año ingreso carrera</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Último Estado</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Último Período</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Total ramos malla</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Total ramos aprobados o en curso</strong></div></td>
			</tr>
			<% fila = 1
			 while f_alumnos.siguiente %>
			<tr> 
				<td><div align="center"><%=fila%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("rut")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("nombre")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("carrera")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("ingreso")%></div></td>
				<td><div align="left"><%=f_alumnos.obtenerValor("estado")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("periodo")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("total_ramos_malla")%></div></td>
				<td><div align="center"><%=f_alumnos.obtenerValor("total_ramos_aprobados_o_en_curso")%></div></td>	
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