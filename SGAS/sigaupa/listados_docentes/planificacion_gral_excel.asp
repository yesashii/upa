<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_planificacion_general.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
'---------------------------------------------------------------------------------------------------
carr_ccod = request.QueryString("busqueda[0][carr_ccod]")
'response.Write("carrera :" & carr_ccod)
'response.End()
if 	carr_ccod <> "" then
	filtro = " and carr_ccod in  ('" & carr_ccod & "')"
else
	filtro = ""
end if
set pagina = new CPagina
pagina.Titulo = "Reporte Planificacion General" 

set conexion = new cConexion
set negocio = new cNegocio
set formu_resul= new cformulario
set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion

usuario_paso=negocio.obtenerUsuario
autorizada = conexion.consultaUno("select isnull(count(*),0) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=72 and cast(a.pers_nrut as varchar)='"&usuario_paso&"'")
actividad = session("_actividad")
'response.Write("actividad "&actividad&" autorizada "&autorizada)
'if ((actividad = "6") and (autorizada > "0")) then
'	periodo = session("_periodo")
'else
periodo =  negocio.obtenerPeriodoAcademico("PLANIFICACION")
'end if
ano_planificacion = conexion.consultaUno("select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

if ano_planificacion < "2006" then
 peri =  negocio.obtenerPeriodoAcademico("CLASES18")
else
 peri =  periodo
end if


'conexion.consultaUno("select max(peri_ccod) from actividades_periodos where tape_ccod=6 and acpe_bvigente='S'")

'----------------------Debemos buscar solo aquellas carreras en las que el usuario tiene permiso de ver-------------
usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
	
	

sql_detalles_mate = " select za.ccos_tcompuesto,c.jorn_tdesc,(select plan_tdesc from planes_estudio where plan_ccod= a.plan_ccod) as plan_tdesc, plan_ccod, nive_ccod, " & vbcrlf & _
					"  (select espe_tdesc from planes_estudio aa, especialidades bb where aa.plan_ccod= a.plan_ccod and aa.espe_ccod = bb.espe_ccod ) as espe_tdesc, " & vbcrlf &_
					"  (select espe_nduracion from planes_estudio aa, especialidades bb where aa.plan_ccod= a.plan_ccod and aa.espe_ccod = bb.espe_ccod ) as espe_nduracion, " & vbcrlf &_
					" (Select carr_tdesc from carreras where carr_ccod=a.carr_ccod) as carrera," & vbcrlf & _
					" a.secc_ccod, cast(a.asig_ccod as varchar)+ '-' + cast(a.secc_tdesc as varchar) as seccion, asig_tdesc,duas_tdesc, a.sede_ccod,(Select sede_tdesc from sedes where sede_ccod=a.sede_ccod) as sede_tdesc, peri_ccod," & vbcrlf & _
 					" protic.horario_con_sala_hora(b.secc_ccod) AS horario, asig_nhoras,secc_ncupo," & vbcrlf & _
" COUNT (distinct bloq_ccod) AS horas" & vbcrlf & _
" , isnull(round(cast(100/isnull(cast(asig_nhoras as numeric),999999999)as decimal(5,2))*sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)),2),0) as porc " & vbcrlf & _
" , case when isnull(cast(asig_nhoras as int),999999999) > isnull(sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)),0) then 1 else 2 end as estado " & vbcrlf & _
" , cast(isnull(round(sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)),2),0)*2 as varchar)" & vbcrlf & _
" + ' ( ' + cast( isnull(round(cast(100/isnull(cast(asig_nhoras as numeric),999999999)as decimal(5,2))*sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)),0),0)*2 as varchar) + '% )' as hrs_asignadas" & vbcrlf & _
" ,  cast(sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)) as varchar)+' ('+cast(isnull(round(cast(100/isnull(cast(asig_nhoras as int),999999999)as decimal(5,2))*sum(protic.dias_habiles(dias_ccod ,bloq_finicio_modulo,bloq_ftermino_modulo)),2),0) as varchar)+'%)' as horas_plan, " & vbcrlf & _
" protic.retorna_rut_profesor(a.secc_ccod) as rut_profesor,protic.retorna_profesor_con_valor(a.secc_ccod) as profesor,protic.retorna_ayudante_con_valor(a.secc_ccod) as Ayudante,(select count(*) from cargas_Academicas carg where carg.secc_ccod=a.secc_ccod) as num_alumnos, "& vbcrlf &_
" (select protic.trunc(min(bloq_finicio_modulo)) as f_inicio from bloques_horarios bh where bh.secc_ccod=a.secc_ccod) as f_inicio, "& vbcrlf &_
" (select protic.trunc(min(bloq_ftermino_modulo)) as f_termino from bloques_horarios bh where bh.secc_ccod=a.secc_ccod) as f_termino, "& vbcrlf &_
" (select clas_tdesc from asignaturas asig, clases_asignatura b where isnull(asig.clas_ccod,1)=b.clas_ccod and asig.asig_ccod=a.asig_ccod) as tipo_asignatura, "& vbcrlf &_
" (select tasg_tdesc from asignaturas asig,tipos_asignatura b where asig.tasg_ccod=b.tasg_ccod and asig.asig_ccod=a.asig_ccod) as tipo_modalidad_asignatura, "& vbcrlf &_
" (select moda_tdesc from secciones secc, modalidades b where secc.moda_ccod=b.moda_ccod and secc.secc_ccod=a.secc_ccod)as modalidad_seccion "& vbcrlf &_
" from ( " & vbcrlf & _
" select b.jorn_ccod,b.carr_ccod,secc_ccod, secc_tdesc,b.secc_ncupo,c.asig_ccod, asig_tdesc,duas_tdesc, asig_nhoras, sede_ccod, b.peri_ccod,d.plan_ccod,d.nive_ccod " & vbcrlf & _
" from ( " & vbcrlf & _
" select asig_ccod ,a.mall_ccod  " & vbcrlf & _
" from  " & vbcrlf & _
" malla_curricular a " & vbcrlf & _
" , planes_estudio b " & vbcrlf & _
" , especialidades c " & vbcrlf & _
" where " & vbcrlf & _
" a.plan_ccod=b.plan_ccod " & vbcrlf & _
" and b.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
" and b.espe_ccod=c.espe_ccod " & vbcrlf & _
" ) a " & vbcrlf & _
" , secciones b " & vbcrlf & _
" , asignaturas c , malla_curricular d,duracion_asignatura e, periodos_academicos pea" & vbcrlf & _
" where " & vbcrlf & _
" a.mall_ccod = d.mall_ccod and a.mall_ccod = b.mall_ccod and " & vbcrlf & _
" a.asig_ccod=b.asig_ccod and c.duas_ccod=e.duas_ccod and b.peri_ccod=pea.peri_ccod" & vbcrlf & _
" and a.asig_ccod=c.asig_ccod and secc_finicio_sec is not null and secc_ftermino_sec is not null" & vbcrlf & _
" " & vbcrlf & _
filtro & vbcrlf & _
" and b.peri_ccod = case c.duas_ccod when 3 then "&peri&" else "& periodo &" end " & vbcrlf & _
" and cast(pea.anos_ccod as varchar)='"&ano_planificacion&"'" & vbcrlf & _
" ) a " & vbcrlf & _
" left outer join bloques_horarios b " & vbcrlf & _
"    on a.secc_ccod = b.secc_ccod  " & vbcrlf & _
" left outer join centros_costos_asignados z " & vbcrlf & _
"    on a.carr_ccod=z.cenc_ccod_carrera " & vbcrlf & _
"    and a.sede_ccod = z.cenc_ccod_sede " & vbcrlf & _
"    and a.jorn_ccod=z.cenc_ccod_jornada " & vbcrlf & _
" left outer join centros_costo za " & vbcrlf & _
"    on za.ccos_ccod=z.ccos_ccod " & vbcrlf & _
" join jornadas c " & vbcrlf & _
"    on a.jorn_ccod=c.jorn_ccod " & vbcrlf & _
" GROUP BY za.ccos_tcompuesto,c.jorn_tdesc,a.secc_ccod, b.secc_ccod,a.carr_ccod, " & vbcrlf & _
" a.asig_ccod, a.secc_tdesc,a.plan_ccod,a.nive_ccod, asig_tdesc,duas_tdesc, " & vbcrlf & _
" a.sede_ccod,peri_ccod,secc_ncupo, asig_nhoras,  protic.horario (b.secc_ccod) " & vbcrlf & _ 
" order by carrera, asig_tdesc,estado"& vbcrlf 
	
'response.Write("<pre>"&sql_detalles_mate&"</pre>")
'response.End()
set f_detalle_mat  = new cformulario
f_detalle_mat.carga_parametros "planificacion_gral_excel.xml", "f_detalle_serv"
f_detalle_mat.inicializar conexion							
f_detalle_mat.consultar sql_detalles_mate

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
<table width="75%" border="1">
  <tr> 
    <td><div align="center"><strong>N°</strong></div></td>
	<td><div align="center"><strong>Sede</strong></div></td>
    <td><div align="center"><strong>Carrera</strong></div></td>
	<td><div align="center"><strong>Jornada</strong></div></td>
	<td><div align="center"><strong>Especialidad</strong></div></td>
	<td><div align="center"><strong>Cant. Semestres</strong></div></td>
    <td><div align="center"><strong>Codigo Seccion</strong></div></td>
    <td><div align="center"><strong>Seccion</strong></div></td>
    <td><div align="center"><strong>Asignatura</strong></div></td>
	<td><div align="center"><strong>Duraci&oacute;n</strong></div></td>
	<td><div align="center"><strong>Plan</strong></div></td>
	<td><div align="center"><strong>Nivel</strong></div></td>
    <td><div align="center"><strong>Periodo</strong></div></td>		
    <td><div align="center"><strong>Horario</strong></div></td>
    <td><div align="center"><strong>Total hrs x asig</strong></div></td>		
	<td><div align="center"><strong>Horas</strong></div></td>
	<td><div align="center"><strong>Cupos</strong></div></td>
	<td><div align="center"><strong>RUT Profesor</strong></div></td>
	<td><div align="center"><strong>Profesor</strong></div></td>
	<td><div align="center"><strong>Ayudante</strong></div></td>		
	<td><div align="center"><strong>N° Alumnos</strong></div></td>
	<td><div align="center"><strong>Fecha Inicio</strong></div></td>
	<td><div align="center"><strong>Fecha Termino</strong></div></td>
	<td><div align="center"><strong>Tipo Asignatura</strong></div></td>
	<td><div align="center"><strong>Modalidad Asignatura</strong></div></td>
	<td><div align="center"><strong>Modalidad Sección</strong></div></td>
	<td><div align="center"><strong>Centro Costo</strong></div></td>		
	<!--<td><div align="center"><strong>Hrs. Asignadas</strong></div></td>				
	<td><div align="center"><strong>Hrs. Plan</strong></div></td>-->
  </tr>
  <% fila = 1 
     while f_detalle_mat.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("sede_tdesc")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("carrera")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("jorn_tdesc")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("espe_tdesc")%></div></td>	
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("espe_nduracion")%></div></td>	
    <td><div align="center"><%=f_detalle_mat.ObtenerValor("secc_ccod")%></div></td>
    <td><div align="left"><%=f_detalle_mat.ObtenerValor("seccion")%></div></td>
    <td><div align="center"><%=f_detalle_mat.ObtenerValor("asig_tdesc")%></div></td>
	<td><div align="left"><%=f_detalle_mat.ObtenerValor("duas_tdesc")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("plan_tdesc")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("nive_ccod")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("peri_ccod")%></div></td>
    <td><div align="left"><%=f_detalle_mat.ObtenerValor("horario")%></div></td>
    <td><div align="center"><%=f_detalle_mat.ObtenerValor("asig_nhoras")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("horas")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("secc_ncupo")%></div></td>
	<td><div align="left"><%=f_detalle_mat.ObtenerValor("rut_profesor")%></div></td>
	<td><div align="left"><%=f_detalle_mat.ObtenerValor("profesor")%></div></td>
	<td><div align="left"><%=f_detalle_mat.ObtenerValor("ayudante")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("num_alumnos")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("f_inicio")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("f_termino")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("tipo_asignatura")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("tipo_modalidad_asignatura")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("modalidad_seccion")%></div></td>
	<td><div align="center"><%=f_detalle_mat.ObtenerValor("ccos_tcompuesto")%></div></td>
  </tr>
  <%fila= fila + 1  
    wend %>
</table>
</body>
</html>