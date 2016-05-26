-- Ofertas de vacantes y matriculados

-- nuevos con especialidad , vacantes, programa academico, loce
select e.sede_tdesc as sede,c.carr_tdesc as carrera,b.espe_tdesc as especialidad,f.jorn_tdesc as jornada,
(select count(*) from alumnos where emat_ccod  in (1,2,4,8,13) and ofer_ncorr= a.ofer_ncorr) as matriculados,
a.ofer_nvacantes as vacantes,a.ofer_nquorum as minimo,d.tcar_tdesc as programa,espe_nduracion as semestres, 
case isnull(c.tgra_ccod,0) when 0 then 'No definido' else g.tgra_tdesc  end as Tipo_Carrera, carr_bloce
from ofertas_academicas a, especialidades b, carreras c , tipos_carrera d, 
sedes e, jornadas f, tipos_grados_carreras g
where a.peri_ccod=202 
    and a.post_bnuevo='S'
    and a.espe_ccod=b.espe_ccod
    and b.carr_ccod=c.carr_ccod
    and c.carr_ccod not in ('820')
    and c.tcar_ccod=d.tcar_ccod
    and a.sede_ccod=e.sede_ccod
    and a.jorn_ccod=f.jorn_ccod
    and c.tgra_ccod*=g.tgra_ccod
    and b.espe_nduracion >1
UNION
-- antiguos sin especialidad
select sede,carrera,carrera as especialidad,jornada,sum(matriculados) as matriculados,sum(matriculados) as vacantes,
    max(minimo) as minimo,programa,max(semestres) as semestres,tipo_carrera,carr_bloce
     from (
        select e.sede_tdesc as sede,c.carr_tdesc as carrera,b.espe_tdesc as especialidad,f.jorn_tdesc as jornada,
        (select count(*) from alumnos where emat_ccod  in (1,2,4,8,13) and ofer_ncorr= a.ofer_ncorr) as matriculados,
        a.ofer_nvacantes as vacantes,a.ofer_nquorum as minimo,d.tcar_tdesc as programa,espe_nduracion as semestres, 
        case isnull(c.tgra_ccod,0) when 0 then 'No definido' else g.tgra_tdesc  end as Tipo_Carrera,carr_bloce
        from ofertas_academicas a, especialidades b, carreras c , tipos_carrera d, 
        sedes e, jornadas f, tipos_grados_carreras g
        where a.peri_ccod=202 
            and a.post_bnuevo='N'
            and a.espe_ccod=b.espe_ccod
            and b.carr_ccod=c.carr_ccod
            and c.carr_ccod not in ('820')
            and c.tcar_ccod=d.tcar_ccod
            and a.sede_ccod=e.sede_ccod
            and a.jorn_ccod=f.jorn_ccod
            and c.tgra_ccod*=g.tgra_ccod
            and b.espe_nduracion >1) as tabla
        group by sede,carrera,jornada,programa,tipo_carrera,carr_bloce
        order by sede,carrera, jornada


--##############################################################
-- Por facultad

Select facultad, SUM(matriculados) as matriculados
from (
    select h.facu_tdesc as facultad,
    (select count(*) from alumnos where emat_ccod  in (1,2,4,8,13) and ofer_ncorr= a.ofer_ncorr) as matriculados
    from ofertas_academicas a, especialidades b, carreras c , tipos_carrera d,
        sedes e, jornadas f , areas_academicas g,facultades h
    where a.peri_ccod=202 
        and a.post_bnuevo IN ('S','N')
        and a.espe_ccod=b.espe_ccod
        and b.carr_ccod=c.carr_ccod
        and c.carr_ccod not in ('820')
        and c.tcar_ccod=d.tcar_ccod
        and a.sede_ccod=e.sede_ccod
        and a.jorn_ccod=f.jorn_ccod
        --and b.espe_nduracion >1
        and c.area_ccod=g.area_ccod  
	    and g.facu_ccod=h.facu_ccod
    ) as tabla
group by facultad    
order by facultad

--##############################################################

-- por jornada

Select jornada, SUM(matriculados) as matriculados
from (
    select jorn_tdesc as jornada,
    (select count(*) from alumnos where emat_ccod  in (1,2,4,8,13) and ofer_ncorr= a.ofer_ncorr) as matriculados
    from ofertas_academicas a, especialidades b, carreras c , tipos_carrera d,
        sedes e, jornadas f , areas_academicas g,facultades h
    where a.peri_ccod=202 
        and a.post_bnuevo IN ('S','N')
        and a.espe_ccod=b.espe_ccod
        and b.carr_ccod=c.carr_ccod
        and c.carr_ccod not in ('820')
        and c.tcar_ccod=d.tcar_ccod
        and a.sede_ccod=e.sede_ccod
        and a.jorn_ccod=f.jorn_ccod
        --and b.espe_nduracion >1
        and c.area_ccod=g.area_ccod  
	    and g.facu_ccod=h.facu_ccod
    ) as tabla
group by jornada   
order by jornada

--##############################################################

-- matriculas por genero

select sexo_tdesc as genero, count(*) as cantidad
from alumnos a, ofertas_academicas b, personas c, sexos d
where a.ofer_ncorr=b.ofer_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.sexo_ccod=d.sexo_ccod
and a.emat_ccod  in (1,2,4,8,13)
and b.peri_ccod=202
group by sexo_tdesc


--##############################################################
-- matriculas por proveniencia

select e.ciud_tcomuna as ciudad,e.ciud_tdesc as comuna, count(*) as cantidad
from alumnos a, ofertas_academicas b, personas c, direcciones d, ciudades e
where a.ofer_ncorr=b.ofer_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.pers_ncorr=d.pers_ncorr
and d.tdir_ccod=1
and d.ciud_ccod=e.ciud_ccod
and a.emat_ccod  in (1,2,4,8,13)
and b.peri_ccod=202
group by e.ciud_tcomuna,e.ciud_tdesc

--##############################################################
--matriculas por establecimiento.
select b.tcol_tdesc as tipo_colegio,sum(cantidad) as cantidad_matriculas
from (    
    select isnull(tcol_ccod,0) as tipo_colegio, count(*) as cantidad
    from alumnos a, ofertas_academicas b, personas c, colegios d--, tipos_colegios e
    where a.ofer_ncorr=b.ofer_ncorr
    and a.pers_ncorr=c.pers_ncorr
    and c.cole_ccod*=d.cole_ccod
    and a.emat_ccod  in (1,2,4,8,13)
    and b.peri_ccod=202
    group by tcol_ccod
) as a, tipos_colegios b
where a.tipo_colegio=b.tcol_ccod
group by  b.tcol_tdesc


--###########################################################
-- reporte proceso admision especial
select count(*) as cantidad, 'Postulantes' as estado_postulantes 
from (
 select distinct cast((isnull(post_npaa_verbal,0) +	isnull(post_npaa_matematicas,0)) / 2 as numeric) as puntaje_total,
 post_npaa_verbal,post_npaa_matematicas, a.pers_ncorr
 from postulantes a , detalle_postulantes b
 where a.peri_ccod=202 
     and a.post_ncorr=b.post_ncorr
     and a.post_bnuevo='S' 
     --and a.epos_ccod=2
     --and (isnull(post_npaa_verbal,0) +	isnull(post_npaa_matematicas,0)) / 2 >= 300
     and (isnull(post_npaa_verbal,0) +	isnull(post_npaa_matematicas,0)) / 2 <= 470
     and post_npaa_verbal is not null
     and post_npaa_matematicas is not null
) as tabla  
union
select count(*) as cantidad, 'Matriculados' as estado_postulantes 
from (
 select distinct cast((isnull(post_npaa_verbal,0) +	isnull(post_npaa_matematicas,0)) / 2 as numeric) as puntaje_total,
 post_npaa_verbal,post_npaa_matematicas, a.pers_ncorr
 from postulantes a , detalle_postulantes b, alumnos c
 where a.peri_ccod=202 
     and a.post_ncorr=b.post_ncorr
     and a.post_bnuevo='S' 
     --and a.epos_ccod=2
     and a.post_ncorr=c.post_ncorr
     and a.ofer_ncorr is not null
     and c.emat_ccod  in (1,2,4,8,13)
     --and (isnull(post_npaa_verbal,0) +	isnull(post_npaa_matematicas,0)) / 2 >= 300
     and (isnull(post_npaa_verbal,0) +	isnull(post_npaa_matematicas,0)) / 2 <= 470
     and post_npaa_verbal is not null
     and post_npaa_matematicas is not null 
) as tabla  


--###########################################################
-- alumnos por asignaturas
select b.clas_tdesc as tipo_asignatura, count(cantidad) as alumnos 
from (                                       
select distinct  case f.clas_ccod when 1 then 1 else 2 end  as clas_ccod,b.matr_ncorr as cantidad 
from ofertas_academicas a, alumnos b, cargas_academicas c,
secciones d,asignaturas e, clases_asignatura f
where a.peri_ccod=202 
    and a.post_bnuevo IN ('S','N')
    and a.ofer_ncorr=b.ofer_ncorr
    and b.matr_ncorr=c.matr_ncorr
    and c.secc_ccod=d.secc_ccod
    and d.asig_ccod=e.asig_ccod
    and isnull(e.clas_ccod,1)=f.clas_ccod
    and emat_ccod  in (1,2,4,8,13)       
) as a,  clases_asignatura b
where a.clas_ccod=b.clas_ccod
group by  b.clas_tdesc    

--###########################################################
-- alumnos por asignaturas o creditos
select tipo_asignatura,count(cantidad) as alumnos 
from (                                  
    select distinct  'CREDITOS' as tipo_asignatura,b.matr_ncorr as cantidad 
    from ofertas_academicas a, alumnos b, cargas_academicas c,
    secciones d,asignaturas e, clases_asignatura f
    where a.peri_ccod=202 
        and a.post_bnuevo IN ('S','N')
        and a.ofer_ncorr=b.ofer_ncorr
        and b.matr_ncorr=c.matr_ncorr
        and c.secc_ccod=d.secc_ccod
        and d.asig_ccod=e.asig_ccod
        and isnull(e.clas_ccod,1)=f.clas_ccod
        and cred_ccod is not null
        and emat_ccod  in (1,2,4,8,13)
UNION
    select distinct  'HORAS' as tipo_asignatura,b.matr_ncorr as cantidad 
    from ofertas_academicas a, alumnos b, cargas_academicas c,
    secciones d,asignaturas e, clases_asignatura f
    where a.peri_ccod=202 
        and a.post_bnuevo IN ('S','N')
        and a.ofer_ncorr=b.ofer_ncorr
        and b.matr_ncorr=c.matr_ncorr
        and c.secc_ccod=d.secc_ccod
        and d.asig_ccod=e.asig_ccod
        and isnull(e.clas_ccod,1)=f.clas_ccod
        and cred_ccod is null
        and emat_ccod  in (1,2,4,8,13)
 )as tabla
group by  tipo_asignatura          
   