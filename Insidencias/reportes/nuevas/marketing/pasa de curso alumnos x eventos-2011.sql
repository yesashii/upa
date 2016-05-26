--************** EGRESA ALUMNOS DE LICEO ***************
update personas_eventos_upa set caev_ccod=11, pers_npromociones=isnull(pers_npromociones,0)+1 , PERS_FULTIMA_PROMOCION=GETDATE()
where pers_ncorr_alumno in (
    select pers_ncorr_alumno
    from personas_eventos_upa a, cursos_alumnos_eventos b, colegios c, ciudades d
    where a.caev_ccod=b.caev_ccod
    and a.cole_ccod=c.cole_ccod
    and a.ciud_ccod=d.ciud_ccod
    and a.caev_ccod in (1,2,3)
    and pers_npromociones is null
    and year(a.audi_fmodificacion)<2011
)

--************** SUBE ALUMNOS DE CURSO ***************
-- DE TERCERO A CUARTO
update personas_eventos_upa set caev_ccod=caev_ccod+1, pers_npromociones=isnull(pers_npromociones,0)+1 , PERS_FULTIMA_PROMOCION=GETDATE()
where pers_ncorr_alumno in (
    select pers_ncorr_alumno
    from personas_eventos_upa a, cursos_alumnos_eventos b, colegios c, ciudades d
    where a.caev_ccod=b.caev_ccod
    and a.cole_ccod=c.cole_ccod
    and a.ciud_ccod=d.ciud_ccod
    and a.caev_ccod=3
    --and pers_npromociones=1
    and year(a.audi_fmodificacion)=2010
)

-- DE SEGUNDO A TERCERO
update personas_eventos_upa set caev_ccod=caev_ccod+1, pers_npromociones=isnull(pers_npromociones,0)+1 , PERS_FULTIMA_PROMOCION=GETDATE()
where pers_ncorr_alumno in (
    select pers_ncorr_alumno
    from personas_eventos_upa a, cursos_alumnos_eventos b, colegios c, ciudades d
    where a.caev_ccod=b.caev_ccod
    and a.cole_ccod=c.cole_ccod
    and a.ciud_ccod=d.ciud_ccod
    and a.caev_ccod=2
    --and pers_npromociones=1
    and year(a.audi_fmodificacion)=2010
)

-- DE PRIMERO A SEGUNDO
update personas_eventos_upa set caev_ccod=caev_ccod+1, pers_npromociones=isnull(pers_npromociones,0)+1 , PERS_FULTIMA_PROMOCION=GETDATE()
where pers_ncorr_alumno in (
    select pers_ncorr_alumno
    from personas_eventos_upa a, cursos_alumnos_eventos b, colegios c, ciudades d
    where a.caev_ccod=b.caev_ccod
    and a.cole_ccod=c.cole_ccod
    and a.ciud_ccod=d.ciud_ccod
    and a.caev_ccod=1
    --and pers_npromociones=1
    and year(a.audi_fmodificacion)=2010
)

select * from personas_eventos_upa where pers_npromociones is null AND caev_ccod in (1,2,3)
select * from cursos_alumnos_eventos
select * from eventos_alumnos
