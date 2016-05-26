select distinct a.carrera_1,a.carrera_2,a.carrera_3,c.pers_tnombre, c.pers_tape_paterno,c.pers_tape_materno,c.pers_nrut,c.pers_xdv,
c.pers_tdireccion,d.ciud_tcomuna,d.ciud_tdesc,c.pers_temail,caev_tdesc as curso,
case when carrera_1 like '%dise%' then cast(1 as varchar)+'ª' 
when carrera_2 like '%dise%' then cast(2 as varchar)+'ª'
when carrera_3 like '%dise%' then cast(3 as varchar)+'ª' end as opcion_disenio
 from eventos_alumnos a,(
            select max(pers_ncorr_alumno) as pers_ncorr_alumno,
            pers_tnombre, pers_tape_paterno,pers_tape_materno 
            from personas_eventos_upa 
            group by pers_tnombre, pers_tape_paterno,pers_tape_materno) b,
personas_eventos_upa c, ciudades d, cursos_alumnos_eventos e, eventos_upa f
where a.pers_ncorr_alumno=b.pers_ncorr_alumno
and c.pers_ncorr_alumno=b.pers_ncorr_alumno
and c.ciud_ccod=d.ciud_ccod
and c.caev_ccod=e.caev_ccod
and c.pers_temail is not null
and len(c.pers_temail) >4
and (a.carrera_1 like '%dise%' or  a.carrera_2 like '%dise%' or  a.carrera_3 like '%dise%')
and a.even_ncorr=f.even_ncorr
--and datepart(yyyy,even_fevento)='2006'
order by opcion_disenio,c.pers_tnombre, c.pers_tape_paterno,c.pers_tape_materno


select * from personas_eventos_upa where pers_ncorr_alumno=12368

select * from eventos_alumnos where pers_ncorr_alumno=12368

select * from eventos_upa