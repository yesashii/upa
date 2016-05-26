<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=causal_eliminacion.xls"
Response.ContentType = "application/vnd.ms-excel"

'----------------------------------------------------------------------------------
anos_ccod = Request.QueryString("busqueda[0][anos_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "ALUMNOS EN CAUSAL DE ELIMINACIÓN LETRA C PARA "

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

p_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1")
s_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=2")
t_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=3")
fecha_01 = conexion.consultaUno("select getDate() ")

'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 

consulta = 	" select *, case (total_anual) when 0 then 0 "& vbCrLf &_
			" else cast((((total_reprobados) * 100.00 ) / "& vbCrLf &_
			"       (total_anual)) as decimal(5,2)) end as porcentaje_reprobación, "& vbCrLf &_
			" case (total_creditos) when 0 then 0 "& vbCrLf &_
			" else cast((((total_creditos_reprobados) * 100.00 ) / "& vbCrLf &_
			"       (total_creditos)) as decimal(5,2)) end as porcentaje_creditos_reprobación        "& vbCrLf &_
			" from  "& vbCrLf &_
			" (  "& vbCrLf &_
			" select distinct cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut, "& vbCrLf &_
			"   a.pers_tape_paterno  +' ' + a.pers_tape_materno + ', ' + a.pers_tnombre as alumno, "& vbCrLf &_
			"   case a.sexo_ccod when 1 then 'Masculino' when 2  then 'Femenino' else 'Sin Seleccionar' end as sexo, "& vbCrLf &_
            "   isnull(a.pers_temail,'No ingresado') as email,isnull(a.pers_tfono,'') as fono, isnull(a.pers_tcelular,'') as celular,      "& vbCrLf &_
			"   facu.facu_tdesc as facultad,h.sede_ccod,h.sede_tdesc as sede,e.carr_ccod ,f.carr_tdesc as Carrera,g.jorn_ccod, g.jorn_tdesc as jornada , "& vbCrLf &_ 
			"   case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo,   "& vbCrLf &_
			"   protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso,  "& vbCrLf &_
			"   (select emat_tdesc from estados_matriculas emat   "& vbCrLf &_
			"   where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc))  "& vbCrLf &_
			"   as estado_academico, "& vbCrLf &_
            "   (select case isnull(plan_tcreditos,0) when '1' then 'PLAN CREDITOS' else 'PLAN SESIONES' end "& vbCrLf &_
            "    from planes_estudio pla   "& vbCrLf &_
			"    where pla.plan_ccod in (select top 1 plan_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc))   "& vbCrLf &_
			"    as tipo_plan_estudio,  "& vbCrLf &_
			"   (select count(*) from alumnos aa3, cargas_academicas bb3,ofertas_academicas dd3,especialidades ee3  "& vbCrLf &_
			"    where aa3.matr_ncorr=bb3.matr_ncorr and aa3.emat_ccod = 1  "& vbCrLf &_
			"    and aa3.pers_ncorr=a.pers_ncorr  "& vbCrLf &_
			"    and aa3.ofer_ncorr=dd3.ofer_ncorr and dd3.peri_ccod in ('"&p_semestre&"','"&s_semestre&"','"&t_semestre&"') "& vbCrLf &_
            "    and dd3.espe_ccod=ee3.espe_ccod and ee3.carr_ccod=e.carr_ccod) as total_anual, "& vbCrLf &_
            "   (select count(*) from alumnos aa3, cargas_academicas bb3,ofertas_academicas dd3,especialidades ee3  "& vbCrLf &_
			"    where aa3.matr_ncorr=bb3.matr_ncorr and aa3.emat_ccod = 1  "& vbCrLf &_
			"    and aa3.pers_ncorr=a.pers_ncorr  and bb3.sitf_ccod in ('R','RI') --and carg_nnota_final < 4.0 "& vbCrLf &_
			"    and aa3.ofer_ncorr=dd3.ofer_ncorr and dd3.peri_ccod in ('"&p_semestre&"','"&s_semestre&"','"&t_semestre&"') "& vbCrLf &_
            "    and dd3.espe_ccod=ee3.espe_ccod and ee3.carr_ccod=e.carr_ccod "& vbCrLf &_
            "    ) as total_reprobados, "& vbCrLf &_
            "   (select sum(cred_valor) "& vbCrLf &_
            "    from alumnos aa3, cargas_academicas bb3,ofertas_academicas dd3, "& vbCrLf &_
            "         secciones ee3, asignaturas ff3, creditos_asignatura gg3,especialidades hh3  "& vbCrLf &_                 
			"    where aa3.matr_ncorr=bb3.matr_ncorr and aa3.emat_ccod = 1 "& vbCrLf &_
			"    and aa3.pers_ncorr=a.pers_ncorr  "& vbCrLf &_
			"    and aa3.ofer_ncorr=dd3.ofer_ncorr and dd3.peri_ccod in ('"&p_semestre&"','"&s_semestre&"','"&t_semestre&"') "& vbCrLf &_
            "    and bb3.secc_ccod=ee3.secc_ccod and ee3.asig_ccod=ff3.asig_ccod "& vbCrLf &_
            "    and ff3.cred_ccod = gg3.cred_ccod  "& vbCrLf &_
            "    and dd3.espe_ccod=hh3.espe_ccod and hh3.carr_ccod=e.carr_ccod) as total_creditos, "& vbCrLf &_
            "   (select sum(cred_valor) "& vbCrLf &_
            "    from alumnos aa3, cargas_academicas bb3,ofertas_academicas dd3, "& vbCrLf &_
            "         secciones ee3, asignaturas ff3, creditos_asignatura gg3,especialidades hh3  "& vbCrLf &_                
			"    where aa3.matr_ncorr=bb3.matr_ncorr and aa3.emat_ccod = 1  "& vbCrLf &_
			"    and aa3.pers_ncorr=a.pers_ncorr  "& vbCrLf &_
			"    and aa3.ofer_ncorr=dd3.ofer_ncorr and dd3.peri_ccod in ('"&p_semestre&"','"&s_semestre&"','"&t_semestre&"') "& vbCrLf &_
            "    and bb3.secc_ccod=ee3.secc_ccod and ee3.asig_ccod=ff3.asig_ccod "& vbCrLf &_
            "    and bb3.sitf_ccod in ('R','RI') --and carg_nnota_final < 4.0 "& vbCrLf &_
            "    and ff3.cred_ccod = gg3.cred_ccod "& vbCrLf &_
            "    and dd3.espe_ccod=hh3.espe_ccod and hh3.carr_ccod=e.carr_ccod ) as total_creditos_reprobados, "& vbCrLf &_
			"    isnull((select top 1 'SI en '+ cast(ttt.anos_ccod as varchar) from ufe_alumnos_cae ttt where esca_ccod=1 and ttt.rut = a.pers_nrut order by ttt.anos_ccod desc),'NO') as es_cae "& vbCrLf &_
            "   from personas_postulante a join alumnos d  "& vbCrLf &_
			"        on a.pers_ncorr = d.pers_ncorr    "& vbCrLf &_
			"   join ofertas_academicas c  "& vbCrLf &_
			"        on c.ofer_ncorr = d.ofer_ncorr    "& vbCrLf &_
			"   join periodos_academicos pea  "& vbCrLf &_
			"        on c.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"' "& vbCrLf &_
			"   join postulantes pos "& vbCrLf &_
			"        on pos.post_ncorr = d.post_ncorr "& vbCrLf &_
			"    join paises pai  "& vbCrLf &_
			"        on pai.pais_ccod = isnull(a.pais_ccod,0)   "& vbCrLf &_
			"    join especialidades e  "& vbCrLf &_
			"        on c.espe_ccod  = e.espe_ccod  "& vbCrLf &_
			"    join carreras f  "& vbCrLf &_
			"        on e.carr_ccod=f.carr_ccod  "& vbCrLf &_
			"    join areas_academicas aca "& vbCrLf &_
			"        on f.area_ccod = aca.area_ccod  "& vbCrLf &_
			"    join facultades facu "& vbCrLf &_
			"        on aca.facu_ccod=facu.facu_ccod       "& vbCrLf &_
			"    join jornadas g  "& vbCrLf &_
			"        on c.jorn_ccod=g.jorn_ccod  "& vbCrLf &_
			"    join sedes h  "& vbCrLf &_
			"       on c.sede_ccod=h.sede_ccod  "& vbCrLf &_
			"    join contratos cont (nolock) "& vbCrLf &_
			"        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr   "& vbCrLf &_
			" where cont.econ_ccod = 1   "& vbCrLf &_
			" and d.emat_ccod not in (9) "& vbCrLf &_
			" and exists (select 1 from contratos cont1 (nolock), compromisos comp1 where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) )   "& vbCrLf &_
			" group by a.pers_ncorr,a.pers_tfono,a.pers_tcelular,e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno,  "& vbCrLf &_
			"         a.pers_tape_materno,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc, "& vbCrLf &_
			"         pai.pais_tdesc,e.espe_tdesc,a.sexo_ccod, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod, "& vbCrLf &_
			"		 a.pers_temail,facu.facu_ccod,facu_tdesc, h.sede_ccod, g.jorn_ccod "& vbCrLf &_
			" )tabla_final "& vbCrLf &_
			" where estado_academico in ('Activa','Egresado') "& vbCrLf &_
		 	" order by sede,carrera,alumno "
 
			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta 'este hace la pega
'response.write(consulta)
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
<p>
	<center><font size="+3"><%=pagina.Titulo%>(<%=anos_siguiente%>)</font><br><%=fecha_01%></center>
</p>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="#FF9900"><div align="center"><strong>NUM</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Sede</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Carrera</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Jornada</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Facultad</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Rut</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Nombre</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Sexo</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Tipo</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Año de ingreso</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Estado</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Tipo de plan de estudios</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Total anual</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Total reprobados</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Total Créditos</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Total Créditos reprobados</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Porcentaje Reprobación</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Porcentaje de Créditos reprobados</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Es CAE</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Email</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Teléfono</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Celular</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td align="left"><%=NUMERO%> </td>
    <td align="left"><%=f_listado.ObtenerValor("sede")%></td>
	<td align="left"><%=f_listado.ObtenerValor("carrera")%></td>
	<td align="left"><%=f_listado.ObtenerValor("jornada")%></td>
	<td align="left"><%=f_listado.ObtenerValor("facultad")%></td>
    <td align="left"><%=f_listado.ObtenerValor("rut")%></td>
	<td align="left"><%=f_listado.ObtenerValor("alumno")%></td>
	<td align="left"><%=f_listado.ObtenerValor("sexo")%></td>
	<td align="left"><%=f_listado.ObtenerValor("tipo")%></td>
	<td align="left"><%=f_listado.ObtenerValor("ano_ingreso")%></td>
	<td align="left"><%=f_listado.ObtenerValor("estado_academico")%></td>
	<td align="left"><%=f_listado.ObtenerValor("tipo_plan_estudio")%></td>
	<td align="left"><%=f_listado.ObtenerValor("total_anual")%></td>
	<td align="left"><%=f_listado.ObtenerValor("total_reprobados")%></td>
	<td align="left"><%=f_listado.ObtenerValor("total_creditos")%></td>
	<td align="left"><%=f_listado.ObtenerValor("total_creditos_reprobados")%></td>
	<td align="left"><%=f_listado.ObtenerValor("porcentaje_reprobación")%></td>
	<td align="left"><%=f_listado.ObtenerValor("porcentaje_creditos_reprobación")%></td>
	<td align="left"><%=f_listado.ObtenerValor("es_cae")%></td>
	<td align="left"><%=f_listado.ObtenerValor("email")%></td>
	<td align="left"><%=f_listado.ObtenerValor("fono")%></td>
	<td align="left"><%=f_listado.ObtenerValor("celular")%></td>
   </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
