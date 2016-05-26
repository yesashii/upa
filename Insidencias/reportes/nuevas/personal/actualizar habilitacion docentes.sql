insert into CARRERAS_DOCENTE
select sede_ccod,pers_ncorr,carr_ccod,jorn_ccod,'mr- llena h.d. 2008 v2' as audi_tusuario, getdate() as audi_fmodificacion,
tcat_ccod,'212' as peri_ccod,observaciones1,observaciones2
 from CARRERAS_DOCENTE a
 where a.sede_ccod=1 
 and a.jorn_ccod=1
 and a.peri_ccod=210
 and a.pers_ncorr not in (
                select distinct b.pers_ncorr
                from CARRERAS_DOCENTE b
                where b.sede_ccod=a.sede_ccod 
                and b.jorn_ccod=a.jorn_ccod 
                and b.peri_ccod=212
                and b.carr_ccod=a.carr_ccod 
                --todos los profesores habilitados en segundo semestre para la escuela asociada
)

insert into CARRERAS_DOCENTE
select sede_ccod,pers_ncorr,carr_ccod,jorn_ccod,'mr- llena h.d. 2008 v2' as audi_tusuario, getdate() as audi_fmodificacion,
tcat_ccod,'213' as peri_ccod,observaciones1,observaciones2
 from CARRERAS_DOCENTE a
 where a.sede_ccod=1
 and a.jorn_ccod=1
 and a.peri_ccod=212
 and a.pers_ncorr not in (
                select distinct b.pers_ncorr
                from CARRERAS_DOCENTE b
                where b.sede_ccod=a.sede_ccod 
                and b.jorn_ccod=a.jorn_ccod 
                and b.peri_ccod=213
                and b.carr_ccod=a.carr_ccod 
                --todos los profesores habilitados en tercer trimestre para la escuela asociada
)



/*


insert into CARRERAS_DOCENTE
select 8 as sede_ccod,pers_ncorr,carr_ccod,jorn_ccod,audi_tusuario,audi_fmodificacion,
tcat_ccod,peri_ccod,observaciones1,observaciones2
 from CARRERAS_DOCENTE where sede_ccod=2 and peri_ccod=208
and carr_ccod in (12)



select * from profesores where pers_ncorr in (
select distinct pers_ncorr,carr_ccod from CARRERAS_DOCENTE where sede_ccod=8 and peri_ccod=206 and carr_ccod in (select carr_ccod from carreras where area_ccod=16)
)
and sede_ccod=8




insert into profesores
select 8 as sede_ccod,pers_ncorr,tpro_ccod,audi_tusuario,audi_fmodificacion,prof_ingreso_uas,
prof_exacademica,prof_exprofesional,prof_horas_contratadas,prof_nporcentaje_colacion,mcol_ncorr,jdoc_ccod
 from profesores 
where sede_ccod=1 and tpro_ccod=1
and pers_ncorr not in (
    select distinct pers_ncorr from profesores where sede_ccod=8 and tpro_ccod=1
)
*/

