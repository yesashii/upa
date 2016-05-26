<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_asignaturas.xls"
Response.ContentType = "application/vnd.ms-excel"

set pagina = new CPagina
pagina.Titulo = "Listado de Asignaturas del Sistema"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 
f_listado.Inicializar conexion 

consulta =  " select a.asig_ccod as cod_asignatura,b.asig_tdesc as asignatura,d.sede_tdesc as sede,e.carr_tdesc as carrera, "& vbCrLf &_
			" e.carr_ccod as cod_carrera,f.plan_tdesc as plan_estudios, f.plan_ccod as cod_plan, "& vbCrLf &_
			" g.espe_tdesc as mension,g.espe_ccod as cod_mension,b.asig_nhoras as horas, "& vbCrLf &_
			" isnull(cred_ccod,0) as creditos,h.area_tdesc as area_formacion, "& vbCrLf &_
			" case (select count(distinct secc.secc_ccod) from secciones secc,bloques_horarios bloq "& vbCrLf &_
			" where a.mall_ccod=secc.mall_ccod and a.asig_ccod=secc.asig_ccod and bloq.secc_ccod = secc.secc_ccod) when 0 then 'NO' else 'SÍ' end as planificada, "& vbCrLf &_
			" (select count(distinct secc.secc_ccod) from secciones secc,bloques_horarios bloq  "& vbCrLf &_
			" where a.mall_ccod=secc.mall_ccod and a.asig_ccod=secc.asig_ccod and bloq.secc_ccod = secc.secc_ccod) as num_secciones, "& vbCrLf &_
			" case(select count(distinct secc.secc_ccod) from secciones secc,bloques_horarios bloq,bloques_profesores prof "& vbCrLf &_
		    " where a.mall_ccod=secc.mall_ccod and a.asig_ccod=secc.asig_ccod "& vbCrLf &_
			" and bloq.secc_ccod = secc.secc_ccod and bloq.bloq_ccod=prof.bloq_ccod and prof.tpro_ccod=1) when 0 then 'NO' else 'SÍ' end as con_docente "& vbCrLf &_
			" from malla_curricular a join  asignaturas b "& vbCrLf &_
		    "        on a.asig_ccod = b.asig_ccod "& vbCrLf &_
			"    join secciones c "& vbCrLf &_
		    "        on a.asig_ccod=c.asig_ccod and a.mall_ccod=c.mall_ccod "& vbCrLf &_
		    "    join sedes d "& vbCrLf &_
			"        on c.sede_ccod=d.sede_ccod "& vbCrLf &_
			"    join carreras e "& vbCrLf &_
			"        on c.carr_ccod=e.carr_ccod "& vbCrLf &_
			"    join planes_estudio f "& vbCrLf &_
			"        on a.plan_ccod=f.plan_ccod "& vbCrLf &_
			"    join especialidades g "& vbCrLf &_
			"        on f.espe_ccod=g.espe_ccod "& vbCrLf &_
			"    left outer join area_asignatura h "& vbCrLf &_
			"        on b.area_ccod = h.area_ccod "
			

f_listado.Consultar consulta 

'-----------------------------------------------------------------------------------------------
'                   listado de asignaturas que pertenecen a una malla pero que no estan en la tabla secciones
'        vale decir nunca han sido asignadas a algún alumno ya sea para notas históricas o para toma de ramos.
set f_listado_malla = new CFormulario
f_listado_malla.Carga_Parametros "consulta.xml", "consulta" 
f_listado_malla.Inicializar conexion 

consulta_malla =  " select distinct b.asig_ccod as cod_asignatura,b.asig_tdesc as asignatura,'' as sede,e.carr_tdesc as carrera, "& vbCrLf &_
				  " e.carr_ccod as cod_carrera,f.plan_tdesc as plan_estudios, f.plan_ccod as cod_plan, "& vbCrLf &_
				  " g.espe_tdesc as mension,g.espe_ccod as cod_mension,b.asig_nhoras as horas, "& vbCrLf &_
				  " isnull(cred_ccod,0) as creditos,h.area_tdesc as area_formacion, "& vbCrLf &_
				  " 'NO' as planificada, '0' as num_secciones, 'NO' as con_docente "& vbCrLf &_
				  " from malla_curricular a join  asignaturas b "& vbCrLf &_
				  "        on a.asig_ccod = b.asig_ccod "& vbCrLf &_
			      "    join planes_estudio f "& vbCrLf &_
				  "        on a.plan_ccod=f.plan_ccod "& vbCrLf &_
				  "    join especialidades g "& vbCrLf &_
			      "        on f.espe_ccod=g.espe_ccod "& vbCrLf &_
			      "    join carreras e "& vbCrLf &_
			      "        on g.carr_ccod=e.carr_ccod    "& vbCrLf &_
				  "    left outer join area_asignatura h "& vbCrLf &_
				  "        on b.area_ccod = h.area_ccod "& vbCrLf &_
				  " where not exists ( select 1 from secciones bb where b.asig_ccod = bb.asig_ccod) "& vbCrLf &_
				  " and exists (select 1 from malla_curricular bb where b.asig_ccod = bb.asig_ccod )"

			

f_listado_malla.Consultar consulta_malla 
'-----------------------------------------------------------------------------------------------
'                   listado de asignaturas que NO pertenecen a una malla y tampoco estan en la tabla secciones
'        vale decir nunca han sido asignadas a algún alumno ya sea para notas históricas o para toma de ramos.
set f_listado_sin_malla = new CFormulario
f_listado_sin_malla.Carga_Parametros "consulta.xml", "consulta" 
f_listado_sin_malla.Inicializar conexion 

consulta_sin_malla =  " select distinct a.asig_ccod as cod_asignatura,A.asig_tdesc as asignatura,'' as sede,'' as carrera, "& vbCrLf &_
					  " '' as cod_carrera,'' as plan_estudios, '' as cod_plan, "& vbCrLf &_
					  " '' as mension,'' as cod_mension,a.asig_nhoras as horas, "& vbCrLf &_
					  " isnull(a.cred_ccod,0) as creditos,h.area_tdesc as area_formacion, "& vbCrLf &_
					  " 'NO' as planificada,'0' as num_secciones,'NO' as con_docente "& vbCrLf &_
					  " from asignaturas a left outer join area_asignatura h "& vbCrLf &_
				      "    on a.area_ccod = h.area_ccod "& vbCrLf &_
					  " where not exists ( select 1 from secciones b where a.asig_ccod = b.asig_ccod) "& vbCrLf &_
					  " and not exists (select 1 from malla_curricular b where a.asig_ccod = b.asig_ccod ) "


			

f_listado_sin_malla.Consultar consulta_sin_malla 

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">
</script>

</head>
<body>
<br>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
<tr>
	    <td align="center">&nbsp;
		</td>
		<td align="center" colspan="15">
			<font size="+1"><strong>LISTADO DE ASIGNATURAS DEL SISTEMA</strong></font>
		</td>
	</tr>
	<tr>
	    <td align="center" colspan="16">&nbsp;
		</td>
	</tr>
	<tr>
	    <td align="left"><strong>Fecha: </strong> </td>
		<td align="left" colspan="15"><%=Date%>
		</td>
	</tr>
	<tr>
	    <td align="center">&nbsp;</td>
		<td align="left" colspan="15"><strong>Clasificaci&oacute;n</strong></td>
	</tr>
	<tr>
	    <td align="center" bgcolor="#FFFFCC">&nbsp;</td>
		<td align="left" colspan="15">Asignaturas del sistema pertenecientes a una malla y asignadas a alumnos</td>
	</tr>
	<tr>
	    <td align="center" bgcolor="#C6E1CE">&nbsp;</td>
		<td align="left" colspan="15">Asignaturas del sistema pertenecientes a una malla pero sin ser asignadas a alumnos</td>
	</tr>
	<tr>
	    <td align="center" bgcolor="#CC9933">&nbsp;</td>
		<td align="left" colspan="15">Asignaturas del sistema sin una malla y sin ser asignadas a alumnos</td>
	</tr>
    <tr>
	    <td align="center" colspan="16">&nbsp;
		</td>
	</tr>
  <tr>
    <td><div align="center"><strong>NUM</strong></div></td>
	<td><div align="center"><strong>COD. ASIGNATURA</strong></div></td>
    <td><div align="left"><strong>ASIGNATURA</strong></div></td>
    <td><div align="left"><strong>SEDE</strong></div></td>
    <td><div align="left"><strong>CARRERA</strong></div></td>
    <td><div align="left"><strong>COD. CARRERA</strong></div></td>
    <td><div align="center"><strong>PLAN ESTUDIOS</strong></div></td>
	<td><div align="left"><strong>COD. PLAN</strong></div></td>
    <td><div align="left"><strong>MENSIÓN</strong></div></td>
    <td><div align="center"><strong>COD. MENSIÓN</strong></div></td>
	<td><div align="left"><strong>HORAS</strong></div></td>
    <td><div align="center"><strong>CRÉDITOS</strong></div></td>
	<td><div align="center"><strong>ÁREA FORMACIÓN</strong></div></td>
	<td><div align="left"><strong>¿ PLANIFICADA ?</strong></div></td>
    <td><div align="left"><strong>NUM. SECCIONES</strong></div></td>
    <td><div align="left"><strong>¿ CON DOCENTE ?</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hacer-->
  <tr>
    <td bgcolor="#FFFFCC"><%=NUMERO%></td>
	<td><%=f_listado.ObtenerValor("cod_asignatura")%></td>
    <td><%=f_listado.ObtenerValor("asignatura")%></td>
    <td><%=f_listado.ObtenerValor("sede")%></td>
    <td><%=f_listado.ObtenerValor("carrera")%></td>
	<td><%=f_listado.ObtenerValor("cod_carrera")%></td>
	<td><%=f_listado.ObtenerValor("plan_estudios")%></td>
	<td><%=f_listado.ObtenerValor("cod_plan")%></td>
	<td><%=f_listado.ObtenerValor("mension")%></td>
	<td><%=f_listado.ObtenerValor("cod_mension")%></td>
	<td><%=f_listado.ObtenerValor("horas")%></td>
	<td><%=f_listado.ObtenerValor("creditos")%></td>
	<td><%=f_listado.ObtenerValor("area_formacion")%></td>
	<td><%=f_listado.ObtenerValor("planificada")%></td>
	<td><%=f_listado.ObtenerValor("num_secciones")%></td>
	<td><%=f_listado.ObtenerValor("con_docente")%></td>
  </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
  <%NUMERO=1%>
  <%while f_listado_malla.Siguiente%> <!-- mientras hay registro hacer-->
  <tr>
    <td bgcolor="#C6E1CE"><%=NUMERO%></td>
	<td><%=f_listado_malla.ObtenerValor("cod_asignatura")%></td>
    <td><%=f_listado_malla.ObtenerValor("asignatura")%></td>
    <td><%=f_listado_malla.ObtenerValor("sede")%></td>
    <td><%=f_listado_malla.ObtenerValor("carrera")%></td>
	<td><%=f_listado_malla.ObtenerValor("cod_carrera")%></td>
	<td><%=f_listado_malla.ObtenerValor("plan_estudios")%></td>
	<td><%=f_listado_malla.ObtenerValor("cod_plan")%></td>
	<td><%=f_listado_malla.ObtenerValor("mension")%></td>
	<td><%=f_listado_malla.ObtenerValor("cod_mension")%></td>
	<td><%=f_listado_malla.ObtenerValor("horas")%></td>
	<td><%=f_listado_malla.ObtenerValor("creditos")%></td>
	<td><%=f_listado_malla.ObtenerValor("area_formacion")%></td>
	<td><%=f_listado_malla.ObtenerValor("planificada")%></td>
	<td><%=f_listado_malla.ObtenerValor("num_secciones")%></td>
	<td><%=f_listado_malla.ObtenerValor("con_docente")%></td>
  </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
  <%NUMERO=1%>
  <%while f_listado_sin_malla.Siguiente%> <!-- mientras hay registro hacer-->
  <tr>
    <td bgcolor="#CC9933"><%=NUMERO%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("cod_asignatura")%></td>
    <td><%=f_listado_sin_malla.ObtenerValor("asignatura")%></td>
    <td><%=f_listado_sin_malla.ObtenerValor("sede")%></td>
    <td><%=f_listado_sin_malla.ObtenerValor("carrera")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("cod_carrera")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("plan_estudios")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("cod_plan")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("mension")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("cod_mension")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("horas")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("creditos")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("area_formacion")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("planificada")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("num_secciones")%></td>
	<td><%=f_listado_sin_malla.ObtenerValor("con_docente")%></td>
  </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
