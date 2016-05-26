select * from personas where pers_ncorr in ( 103170, 12118, 101130 )




consulta_datos:  

select a.pers_ncorr,protic.format_rut(pers_nrut) as rut, 
 a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' +a.pers_tape_materno as nombre, 
 isnull(b.sexo_tdesc,'-No ingresado-') as sexo,isnull(c.pais_tdesc,'-No ingresado-') as pais  
 from personas_postulante a LEFT OUTER JOIN sexos b 
 ON a.sexo_ccod = b.sexo_ccod 
 LEFT OUTER JOIN paises c 
 ON a.pais_ccod = c.pais_ccod 
 WHERE cast(a.pers_nrut as varchar)='15370707' 
 
 
 
 
 select distinct b.ofer_ncorr as num_ofe,b.post_ncorr as num_pos,c.peri_ccod,protic.initcap(f.peri_tdesc) as periodo,protic.initcap(g.sede_tdesc) as sede, protic.initcap(e.carr_tdesc) as carrera,case h.jorn_ccod when 1 then '(D)' else '(V)' end as jornada,cast(d.espe_ccod as varchar)+ '-->' + protic.initcap(d.espe_tdesc) as mension  
 ,case a.epos_ccod when 1 then 'No enviada' when 2 then 'Enviada' end as estado_pos, protic.initcap(i.eepo_tdesc) as estado_examen,f.anos_ccod,f.plec_ccod 
 from postulantes a, detalle_postulantes b, ofertas_academicas c, especialidades d, 
     carreras e, periodos_Academicos f, sedes g, jornadas h,estado_examen_postulantes i 
 where cast(a.pers_ncorr as varchar)='256114'
	and a.post_ncorr = b.post_ncorr 
	and b.ofer_ncorr = c.ofer_ncorr 
	and c.espe_ccod  = d.espe_ccod 
	and d.carr_ccod  = e.carr_ccod 
	and c.peri_ccod  = f.peri_ccod 
	and c.sede_ccod  = g.sede_ccod 
	and c.jorn_ccod  = h.jorn_ccod 
	and b.eepo_ccod  = i.eepo_ccod 
 order by f.anos_ccod asc,f.plec_ccod asc,b.post_ncorr asc 
 
 
 -- 
 select case when m.espe_ccod <> d.espe_ccod then ''+cast(a.matr_ncorr as varchar)+'' else cast(a.matr_ncorr as varchar) end  as num_matricula, a.post_ncorr as num_pos,cast(j.cont_ncorr as varchar) + case j.contrato when null then '' else '(' + cast(contrato as varchar) + ')' end  as num_con,protic.initcap(f.peri_tdesc) as periodo,protic.initcap(g.sede_tdesc) as sede, protic.initcap(e.carr_tdesc) as carrera,case h.jorn_ccod when 1 then '(D)' else '(V)' end as jornada,cast(d.espe_ccod as varchar)+ '-->' + protic.initcap(d.espe_tdesc) as mension, 
 protic.initcap(i.emat_tdesc) as estado_alumno, protic.trunc(isnull(j.cont_fcontrato,a.alum_fmatricula)) as fecha, isnull(k.econ_tdesc,'*') as estado_matricula 
 ,'('+cast(l.plan_ccod as varchar)+') '+ l.plan_tdesc as plan_estu, m.espe_ccod as espe_plan,f.anos_ccod,f.plec_ccod,isnull(j.cont_fcontrato,a.alum_fmatricula) as fecha2  
 from 
 alumnos a join ofertas_academicas c 
    on a.ofer_ncorr = c.ofer_ncorr 
 join especialidades d 
    on c.espe_ccod  = d.espe_ccod 
 join carreras e 
    on d.carr_ccod  = e.carr_ccod 
 join periodos_Academicos f 
    on c.peri_ccod  = f.peri_ccod  
 join sedes g 
    on c.sede_ccod  = g.sede_ccod 
 join jornadas h 
    on c.jorn_ccod  = h.jorn_ccod  
 join estados_matriculas i 
    on a.emat_ccod  = i.emat_ccod 
 left outer join contratos j 
    on a.matr_ncorr = j.matr_ncorr 
 left outer join estados_contrato k 
    on j.econ_ccod = k.econ_ccod 
left outer join planes_estudio l 
    on a.plan_ccod = l.plan_ccod   
 left outer join especialidades m 
    on l.espe_ccod = m.espe_ccod 
 where cast(a.pers_ncorr as varchar)='256114' 
 union  
 select '' as num_matricula, null as num_pos,null  as num_con,protic.initcap(d.peri_tdesc) as periodo,null as sede, protic.initCap(linea_1_certificado + ' ' + linea_2_certificado) as carrera,  
 null as jornada,protic.initCap(linea_1_certificado + ' ' + linea_2_certificado) as mension,   
 protic.initcap(c.emat_tdesc) as estado_alumno, protic.trunc(a.fecha_proceso) as fecha, '*' as estado_matricula   
 ,null as plan_estu, null as espe_plan,d.anos_ccod,d.plec_ccod,a.fecha_proceso as fecha2   
 from alumnos_salidas_intermedias a, salidas_carrera b,estados_matriculas c,periodos_academicos d, carreras e  
 where cast(a.pers_ncorr as varchar)='256114' and a.saca_ncorr=b.saca_ncorr    
 and a.emat_ccod=c.emat_ccod  and a.peri_ccod = d.peri_ccod and b.carr_ccod=e.carr_ccod 
 order by anos_ccod asc,plec_ccod asc, fecha2 asc 