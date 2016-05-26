<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

Response.AddHeader "Content-Disposition", "attachment;filename=listado_eva_docente_excel.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
anos_ccod=conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
'response.Write(anos_ccod)
'response.End()

'------------------------------------------------------------------------------------
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion

'consulta =  "  select *, case cantidad_carga_anual when 0 then 0 else cast(((( cantidad_evaluada + cantidad_evaluada2) * 100.00) / cantidad_carga_anual) as decimal(5,2)) end as indicador" & vbCrLf &_
'			" from " & vbCrLf &_
'			" ( " & vbCrLf &_
'			" select distinct cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut,isnull(a.pers_temail,'No ingresado') as email,  " & vbCrLf &_
'			"   a.pers_tape_paterno  as AP_Paterno, a.pers_tape_materno  as AP_Materno, a.pers_tnombre as nombre,protic.trunc(a.pers_fnacimiento) as fecha_nacimiento,  " & vbCrLf &_
'			"   case a.sexo_ccod when 1 then 'Masculino' when 2  then 'Femenino' else 'Sin Seleccionar' end as sexo,  " & vbCrLf &_ 
'			"   pai.pais_tdesc as pais,facu.facu_ccod,facu.facu_tdesc as facultad,h.sede_ccod,h.sede_tdesc as sede,e.carr_ccod ,f.carr_tdesc as Carrera,g.jorn_ccod, g.jorn_tdesc as jornada , " & vbCrLf &_
'			"   case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo,  " & vbCrLf &_
'			"   protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso, " & vbCrLf &_
'			"   (select emat_tdesc from estados_matriculas emat  " & vbCrLf &_
'			"   where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc))  " & vbCrLf &_
'			"   as estado_academico,protic.trunc(cont.cont_fcontrato) as fecha_matricula,protic.trunc(d.audi_fmodificacion) as fecha_modificacion, " & vbCrLf &_
'			"   (select count(*) from alumnos aa3, cargas_academicas bb3,ofertas_academicas dd3 " & vbCrLf &_
'			"    where aa3.matr_ncorr=bb3.matr_ncorr and aa3.emat_ccod = 1 " & vbCrLf &_
'			"    and aa3.pers_ncorr=a.pers_ncorr " & vbCrLf &_
'			"    and exists (select 1 from secciones tt, asignaturas tt2 where tt.secc_ccod=bb3.secc_ccod and tt.asig_ccod=tt2.asig_ccod and tt2.duas_ccod <> 3) " & vbCrLf &_
'			"    and aa3.ofer_ncorr=dd3.ofer_ncorr and dd3.peri_ccod in (select tt.peri_ccod from periodos_academicos tt where cast(tt.anos_ccod as varchar)='"&anos_ccod&"' and tt.peri_ccod in (214) )) as cantidad_carga_anual, " & vbCrLf &_
'			"   (select count(distinct cc3.secc_ccod) from alumnos aa3, cargas_academicas bb3, evaluacion_docente cc3, ofertas_academicas dd3  " & vbCrLf &_
'			"    where aa3.matr_ncorr=bb3.matr_ncorr and aa3.pers_ncorr=a.pers_ncorr and aa3.emat_ccod=1 " & vbCrLf &_
'			"    and bb3.secc_ccod=cc3.secc_ccod and aa3.ofer_ncorr=dd3.ofer_ncorr and dd3.peri_ccod in (select tt.peri_ccod from periodos_academicos tt where cast(tt.anos_ccod as varchar)='"&anos_ccod&"' and tt.peri_ccod in (214) ) " & vbCrLf &_
'			"    and cc3.pers_ncorr_encuestado=a.pers_ncorr) as cantidad_evaluada, " & vbCrLf &_
'			"   (select count(distinct cc3.secc_ccod) from alumnos aa3, cargas_academicas bb3, cuestionario_opinion_alumnos cc3, ofertas_academicas dd3  " & vbCrLf &_
'			"    where aa3.matr_ncorr=bb3.matr_ncorr and aa3.pers_ncorr=a.pers_ncorr and aa3.emat_ccod=1 " & vbCrLf &_
'			"    and bb3.secc_ccod=cc3.secc_ccod and aa3.ofer_ncorr=dd3.ofer_ncorr and dd3.peri_ccod in (select tt.peri_ccod from periodos_academicos tt where cast(tt.anos_ccod as varchar)='"&anos_ccod&"' and tt.peri_ccod in (214) ) " & vbCrLf &_
'			"    and cc3.pers_ncorr=a.pers_ncorr) as cantidad_evaluada2 " & vbCrLf &_
'			"   from personas_postulante a join alumnos d  " & vbCrLf &_
'			"        on a.pers_ncorr = d.pers_ncorr   " & vbCrLf &_
'			"   join ofertas_academicas c  " & vbCrLf &_
'			"        on c.ofer_ncorr = d.ofer_ncorr    " & vbCrLf &_
'			"   join periodos_academicos pea  " & vbCrLf &_
'			"        on c.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)= '"&anos_ccod&"' " & vbCrLf &_
'			"   join postulantes pos " & vbCrLf &_
'			"        on pos.post_ncorr = d.post_ncorr " & vbCrLf &_
'			"    join paises pai " & vbCrLf &_
'			"        on pai.pais_ccod = isnull(a.pais_ccod,0)  " & vbCrLf &_
'			"    join especialidades e  " & vbCrLf &_
'			"        on c.espe_ccod  = e.espe_ccod " & vbCrLf &_
'			"    join carreras f  " & vbCrLf &_
'			"        on e.carr_ccod=f.carr_ccod " & vbCrLf &_
'			"    join areas_academicas aca " & vbCrLf &_
'			"        on f.area_ccod = aca.area_ccod " & vbCrLf &_
'			"    join facultades facu " & vbCrLf &_
'			"        on aca.facu_ccod=facu.facu_ccod " & vbCrLf &_      
'			"    join jornadas g  " & vbCrLf &_
'			"        on c.jorn_ccod=g.jorn_ccod " & vbCrLf &_ 
'			"    join sedes h  " & vbCrLf &_
'			"        on c.sede_ccod=h.sede_ccod  " & vbCrLf &_
'			"    join contratos cont " & vbCrLf &_
'			"        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr  " & vbCrLf &_
'			" where cont.econ_ccod = 1  " & vbCrLf &_
'			" and d.emat_ccod not in (9) " & vbCrLf &_
'			" and exists (select 1 from contratos cont1, compromisos comp1 where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) )   " & vbCrLf &_
'			" group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno, " & vbCrLf &_
'			"         a.pers_tape_materno,a.pers_fnacimiento,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc, " & vbCrLf &_
'			"         pai.pais_tdesc,e.espe_tdesc,a.sexo_ccod,cont.cont_fcontrato, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod," & vbCrLf &_
'			"		 a.pers_temail,facu.facu_ccod,facu_tdesc, h.sede_ccod, g.jorn_ccod " & vbCrLf &_
'			" )tabla_final " & vbCrLf &_
'			" where estado_academico= 'Activa' " & vbCrLf &_
'			" order by sede,carrera,AP_Paterno,AP_Materno,Nombre"

consulta =  "  select *, case cantidad_carga_anual when 0 then 0 else cast(((( cantidad_evaluada ) * 100.00) / cantidad_carga_anual) as decimal(5,2)) end as indicador" & vbCrLf &_
			" from " & vbCrLf &_
			" ( " & vbCrLf &_
			" select distinct cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut,isnull(a.pers_temail,'No ingresado') as email,  " & vbCrLf &_
			"   a.pers_tape_paterno  as AP_Paterno, a.pers_tape_materno  as AP_Materno, a.pers_tnombre as nombre,protic.trunc(a.pers_fnacimiento) as fecha_nacimiento,  " & vbCrLf &_
			"   case a.sexo_ccod when 1 then 'Masculino' when 2  then 'Femenino' else 'Sin Seleccionar' end as sexo,  " & vbCrLf &_ 
			"   pai.pais_tdesc as pais,facu.facu_ccod,facu.facu_tdesc as facultad,h.sede_ccod,h.sede_tdesc as sede,e.carr_ccod ,f.carr_tdesc as Carrera,g.jorn_ccod, g.jorn_tdesc as jornada , " & vbCrLf &_
			"   case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo,  " & vbCrLf &_
			"   protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso, " & vbCrLf &_
			"   (select emat_tdesc from estados_matriculas emat  " & vbCrLf &_
			"   where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc))  " & vbCrLf &_
			"   as estado_academico,protic.trunc(cont.cont_fcontrato) as fecha_matricula,protic.trunc(d.audi_fmodificacion) as fecha_modificacion, " & vbCrLf &_
			"   (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc,secciones dd, asignaturas ee " & vbCrLf &_
			"	where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr " & vbCrLf &_
			"	and cc.secc_ccod=dd.secc_ccod and dd.asig_ccod=ee.asig_ccod and ee.duas_ccod<>3 " & vbCrLf &_
			"	and bb.peri_ccod in ((select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1)) " & vbCrLf &_
			"	and convert(datetime,protic.trunc(isnull(cc.fecha_ingreso_carga,'29-05-"&anos_ccod&"')),103) < convert(datetime,'30-05-"&anos_ccod&"',103) " & vbCrLf &_
			"	and not exists (select 1 from secciones sec,convalidaciones conv " & vbCrLf &_
			"							  where sec.secc_ccod=cc.secc_ccod and cc.matr_ncorr=conv.matr_ncorr and sec.asig_ccod=conv.asig_ccod) " & vbCrLf &_
			"	and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc " & vbCrLf &_
			"						 where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  " & vbCrLf &_
			"						 and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 " & vbCrLf &_
			"						 and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'30-05-"&anos_ccod&"',103)))  as cantidad_carga_anual, " & vbCrLf &_
			"   (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc,secciones dd, asignaturas ee  " & vbCrLf &_
			"						 where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr " & vbCrLf &_
			"						 and cc.secc_ccod=dd.secc_ccod and dd.asig_ccod=ee.asig_ccod and ee.duas_ccod <> 3 " & vbCrLf &_
			"						 and bb.peri_ccod in ((select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1)) " & vbCrLf &_
			"						 and convert(datetime,protic.trunc(isnull(cc.fecha_ingreso_carga,'29-05-"&anos_ccod&"')),103) < convert(datetime,'30-05-"&anos_ccod&"',103) " & vbCrLf &_
			"						 and not exists (select 1 from secciones sec,convalidaciones conv  " & vbCrLf &_
			"										 where sec.secc_ccod=cc.secc_ccod and cc.matr_ncorr=conv.matr_ncorr and sec.asig_ccod=conv.asig_ccod) " & vbCrLf &_
			"						 and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc  " & vbCrLf &_
			"									  where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod   " & vbCrLf &_
			"									  and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1  " & vbCrLf &_
			"									  and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'30-05-"&anos_ccod&"',103))  " & vbCrLf &_
			"						 and exists (select 1 from cuestionario_opinion_alumnos ffff where ffff.pers_ncorr=aa.pers_ncorr   " & vbCrLf &_
			"									 and ffff.secc_ccod=cc.secc_ccod   " & vbCrLf &_
			"									 union  " & vbCrLf &_
			"									 select 1 from evaluacion_docente ffff where ffff.pers_ncorr_encuestado=aa.pers_ncorr   " & vbCrLf &_
			"									 and ffff.secc_ccod=cc.secc_ccod) " & vbCrLf &_
			"						 ) as cantidad_evaluada, lower(a.pers_temail) as email_par, (select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=a.pers_ncorr) as email_upa  " & vbCrLf &_
			"   from personas_postulante a join alumnos d  " & vbCrLf &_
			"        on a.pers_ncorr = d.pers_ncorr   " & vbCrLf &_
			"   join ofertas_academicas c  " & vbCrLf &_
			"        on c.ofer_ncorr = d.ofer_ncorr    " & vbCrLf &_
			"   join periodos_academicos pea  " & vbCrLf &_
			"        on c.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)= '"&anos_ccod&"' " & vbCrLf &_
			"   join postulantes pos " & vbCrLf &_
			"        on pos.post_ncorr = d.post_ncorr " & vbCrLf &_
			"    join paises pai " & vbCrLf &_
			"        on pai.pais_ccod = isnull(a.pais_ccod,0)  " & vbCrLf &_
			"    join especialidades e  " & vbCrLf &_
			"        on c.espe_ccod  = e.espe_ccod " & vbCrLf &_
			"    join carreras f  " & vbCrLf &_
			"        on e.carr_ccod=f.carr_ccod " & vbCrLf &_
			"    join areas_academicas aca " & vbCrLf &_
			"        on f.area_ccod = aca.area_ccod " & vbCrLf &_
			"    join facultades facu " & vbCrLf &_
			"        on aca.facu_ccod=facu.facu_ccod " & vbCrLf &_      
			"    join jornadas g  " & vbCrLf &_
			"        on c.jorn_ccod=g.jorn_ccod " & vbCrLf &_ 
			"    join sedes h  " & vbCrLf &_
			"        on c.sede_ccod=h.sede_ccod  " & vbCrLf &_
			"    join contratos cont " & vbCrLf &_
			"        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr  " & vbCrLf &_
			" where cont.econ_ccod = 1  " & vbCrLf &_
			" and d.emat_ccod not in (9) and f.carr_ccod='45' " & vbCrLf &_
			" and exists (select 1 from contratos cont1, compromisos comp1 where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) )   " & vbCrLf &_
			" group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno, " & vbCrLf &_
			"         a.pers_tape_materno,a.pers_fnacimiento,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc, " & vbCrLf &_
			"         pai.pais_tdesc,e.espe_tdesc,a.sexo_ccod,cont.cont_fcontrato, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod," & vbCrLf &_
			"		 a.pers_temail,facu.facu_ccod,facu_tdesc, h.sede_ccod, g.jorn_ccod " & vbCrLf &_
			" )tabla_final " & vbCrLf &_
			" where estado_academico= 'Activa' " & vbCrLf &_
			" order by sede,carrera,AP_Paterno,AP_Materno,Nombre"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
formulario.Consultar consulta 


set formulario_facultad = new CFormulario
formulario_facultad.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario_facultad.Inicializar conexion
consulta2 = " select facu_ccod, facu_tdesc from facultades a " & vbCrLf &_
		   " where exists (select 1 from areas_academicas b, carreras c, especialidades d, ofertas_academicas e, periodos_academicos f,alumnos g " & vbCrLf &_
           "               where a.facu_ccod=b.facu_ccod and b.area_ccod=c.area_ccod and  c.carr_ccod=d.carr_ccod and d.espe_ccod=e.espe_ccod " & vbCrLf &_
           "               and e.peri_ccod=f.peri_ccod and f.anos_ccod = datePart(year,getdate()) and c.carr_ccod <> '820' " & vbCrLf &_
           "               and e.ofer_ncorr=g.ofer_ncorr and g.emat_ccod=1) " & vbCrLf &_
		   " order by facu_tdesc" 
formulario_facultad.Consultar consulta2


'response.Write("<hr>")
set formulario_sede = new CFormulario
formulario_sede.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario_sede.Inicializar conexion
consulta3 = " select sede_ccod, sede_tdesc from sedes a " & vbCrLf &_
			" where exists (select 1 from ofertas_academicas e, periodos_academicos f,alumnos g " & vbCrLf &_
			"               where a.sede_ccod=e.sede_ccod " & vbCrLf &_
			"               and e.peri_ccod=f.peri_ccod and f.anos_ccod = datePart(year,getdate()) " & vbCrLf &_
			"               and e.ofer_ncorr=g.ofer_ncorr and g.emat_ccod=1) " & vbCrLf &_
			" order by sede_tdesc " 
formulario_sede.Consultar consulta3



%>
<html>
<head>
<title>Indicador de completación Ev. Docente <%=anos_ccod%></title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Indicador de completación Ev. Docente <%=anos_ccod%></font></div></td>
 </tr>
 <tr> 
    <td colspan="4">&nbsp;</td>
 </tr>
 <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=fecha%></td>
 </tr>
</table>

<p>&nbsp;</p>
<table width="100%" border="0">
  <tr>
  	  <td colspan="18"><font color="#003399" size="3">Indicador de completación Evaluación Docente por Facultades</font></td>	
  </tr>
  <tr>
      <td bgcolor="#9999FF"><div align="center"><strong>N°</strong></div></td>
	  <td bgcolor="#9999FF"><div align="center"><strong>Facultad</strong></div></td>
	  <td bgcolor="#9999FF"><div align="center"><strong>Total Carga Anual</strong></div></td>
	  <td bgcolor="#9999FF"><div align="center"><strong>Total Carga Evaluada</strong></div></td>
	  <td bgcolor="#9999FF"><div align="center"><strong>Indicador</strong></div></td>
  </tr>
  <%fila_facultad = 1
  while formulario_facultad.siguiente
   facu_ccod_1 = formulario_facultad.obtenerValor("facu_ccod")
   facu_tdesc  = formulario_facultad.obtenerValor("facu_tdesc")
   cantidad_carga_anual = 0
   cantidad_evaluada = 0
   formulario.primero
   while formulario.siguiente
   		facu_ccod_2 = formulario.obtenerValor("facu_ccod")
        if facu_ccod_1=facu_ccod_2 then
		 	cantidad_carga_anual = cantidad_carga_anual + cint(formulario.obtenerValor("cantidad_carga_anual"))
			cantidad_evaluada  = cantidad_evaluada + cint(formulario.obtenerValor("cantidad_evaluada"))
		end if
   wend
   if cantidad_carga_anual <> 0 then 
	   indicador_facultad = ((cantidad_evaluada * 100.00) / cantidad_carga_anual)
   else
   	   indicador_facultad = 0
   end if
   response.Write("<tr>")
   response.Write("<td><div align='center'>"&fila_facultad&"</div></td>")
   response.Write("<td><div align='left'>"&facu_tdesc&"</div></td>")
   response.Write("<td><div align='center'>"&cantidad_carga_anual&"</div></td>")
   response.Write("<td><div align='center'>"&cantidad_evaluada&"</div></td>")
   response.Write("<td><div align='center'>"&formatnumber(cdbl(indicador_facultad),2,-1,0,0)&"</div></td>")
   response.Write("<td colspal='13'>&nbsp;</td>")
   response.Write("</tr>")		 
   fila_facultad = fila_facultad + 1  	   
wend
formulario.primero
  
  %>
  <tr><td colspan="18">&nbsp;</td></tr>
  <tr><td colspan="18">&nbsp;</td></tr>
  <tr>
  	  <td colspan="18"><font color="#003399" size="3">Indicador de completación Evaluación Docente por Sedes</font></td>	
  </tr>
  <tr>
      <td bgcolor="#9999FF"><div align="center"><strong>N°</strong></div></td>
	  <td bgcolor="#9999FF"><div align="center"><strong>Sede</strong></div></td>
	  <td bgcolor="#9999FF"><div align="center"><strong>Total Carga Anual</strong></div></td>
	  <td bgcolor="#9999FF"><div align="center"><strong>Total Carga Evaluada</strong></div></td>
	  <td bgcolor="#9999FF"><div align="center"><strong>Indicador</strong></div></td>
  </tr>
<% 
   fila_sede = 1
   while formulario_sede.siguiente
   sede_ccod_1 = formulario_sede.obtenerValor("sede_ccod")
   sede_tdesc  = formulario_sede.obtenerValor("sede_tdesc")
   cantidad_carga_anual = 0
   cantidad_evaluada = 0
   formulario.primero
   while formulario.siguiente
   		sede_ccod_2 = formulario.obtenerValor("sede_ccod")
        if cint(sede_ccod_1) = cint(sede_ccod_2) then
		 	cantidad_carga_anual = cantidad_carga_anual + cint(formulario.obtenerValor("cantidad_carga_anual"))
			cantidad_evaluada  = cantidad_evaluada + cint(formulario.obtenerValor("cantidad_evaluada")) 
		end if
   wend
   if cantidad_carga_anual <> 0 then 
	   indicador_sede = ((cantidad_evaluada * 100.00) / cantidad_carga_anual)
   else
   	   indicador_sede = 0
   end if
   response.Write("<tr>")
   response.Write("<td><div align='center'>"&fila_sede&"</div></td>")
   response.Write("<td><div align='left'>"&sede_tdesc&"</div></td>")
   response.Write("<td><div align='center'>"&cantidad_carga_anual&"</div></td>")
   response.Write("<td><div align='center'>"&cantidad_evaluada&"</div></td>")
   response.Write("<td><div align='center'>"&formatnumber(cdbl(indicador_sede),2,-1,0,0)&"</div></td>")
   response.Write("<td colspal='13'>&nbsp;</td>")
   response.Write("</tr>")	
   fila_sede = fila_sede + 1	   	   
wend
formulario.primero
  
%>
  <tr><td colspan="18">&nbsp;</td></tr>
  <tr><td colspan="18">&nbsp;</td></tr>
  <tr>
  	  <td colspan="18"><font color="#003399" size="3">Indicador de completación Evaluación Docente por Escuelas y Alumnado</font></td>	
  </tr>
  <tr> 
    <td bgcolor="#9999FF"><div align="center"><strong>N°</strong></div></td>
    <td bgcolor="#9999FF"><div align="center"><strong>Facultad</strong></div></td>
    <td bgcolor="#9999FF"><div align="center"><strong>Sede</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Carrera</strong></div></td>
    <td bgcolor="#9999FF"><div align="center"><strong>Jornada</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Rut</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Alumno</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Email Part.</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Email UPA</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Sexo</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Fecha Nacimiento</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Tipo</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Año de Ingreso</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Estado</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Fecha_matrícula</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Cant. Asignaturas Tomadas</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Cant. Asignaturas Evaluadas</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>Indicador(%)</strong></div></td>
  </tr>
  <% fila = 1 
   while formulario.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("facultad")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("rut")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("Ap_paterno")%>&nbsp;<%=formulario.ObtenerValor("Ap_materno")%>&nbsp;<%=formulario.ObtenerValor("nombre")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("email_par")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("email_upa")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("sexo")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("fecha_nacimiento")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("tipo")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("ano_ingreso")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("estado_academico")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("fecha_matricula")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("cantidad_carga_anual")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("cantidad_evaluada")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("indicador")%></div></td>
  </tr>
  <% fila = fila + 1  
    wend 
  %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>