-- listado de profesores nuevos ingresados al sistema
select  distinct protic.obtener_rut(a.pers_ncorr) as rut,
protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,
(select count(*) from bloques_profesores bp, bloques_horarios bb, secciones cc 
where bp.pers_ncorr=a.pers_ncorr
and bp.bloq_ccod=bb.bloq_ccod
and bb.secc_ccod=cc.secc_ccod
and cc.peri_ccod in (206,208,209)) as bloques,
b.susu_tlogin as login, b.susu_tclave as clave
from profesores a, sis_usuarios b
where a.pers_ncorr=b.pers_ncorr
and isnull(prof_ingreso_uas,2007) in (2007,2006)

-- listado profes con carga
select  distinct d.carr_tdesc as Carrera,sede_tdesc as sede, jorn_tdesc as jornada,
protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,
b.susu_tlogin as login, b.susu_tclave as clave 
from profesores a, sis_usuarios b,bloques_profesores bp, bloques_horarios bb, 
secciones cc,carreras d, sedes e, jornadas f
where a.pers_ncorr=b.pers_ncorr
--and a.pers_ncorr=123165
and cc.peri_ccod in (206,208,209)
and bp.pers_ncorr=a.pers_ncorr
and bp.bloq_ccod=bb.bloq_ccod
and bb.secc_ccod=cc.secc_ccod
and cc.carr_ccod=d.carr_ccod
and cc.sede_ccod=e.sede_ccod
and cc.jorn_ccod=f.jorn_ccod
/*
filtra solo a los nuevos
and a.pers_ncorr not in (
    select  distinct a.pers_ncorr
    from profesores a, sis_usuarios b
    where a.pers_ncorr=b.pers_ncorr
    and prof_ingreso_uas in (2007)
)*/
order by sede,carrera,jornada, nombre desc


--select * from bloques_profesores where pers_ncorr=123165

select * from sis_usuarios where pers_ncorr=123165

9-98744574
Eduardo Hernandez
