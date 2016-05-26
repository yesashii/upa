antiguo  comuni multime diruno 

aparecen 162  
deben ser 163

tenorio guerra. esta listo

select top 30 protic.obtener_rut(pers_ncorr) as rut,* from alumnos 
where emat_ccod not in (1) 
order by audi_fmodificacion desc

-- Ofertas de alumnos para carrera X
select distinct b.ofer_ncorr, b.post_bnuevo 
from especialidades a, ofertas_academicas b
where a.espe_ccod=b.espe_ccod
and a.carr_ccod=8
and peri_ccod=206

-- chequea los estados de matricuald e los alumnos
select b.emat_tdesc as estado_matricula,protic.obtener_rut(a.pers_ncorr) as  rut,
protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno, a.* 
from alumnos a, estados_matriculas b
where ofer_ncorr in (
    select distinct b.ofer_ncorr
    from especialidades a, ofertas_academicas b
    where a.espe_ccod=b.espe_ccod
    and a.carr_ccod=8
    and peri_ccod=206
)
and a.emat_ccod=b.emat_ccod
order by a.audi_fmodificacion desc


-- chequea las ofertas de la postulacion
select protic.obtener_nombre_carrera(ofer_ncorr,'CJ') as carrera,protic.obtener_rut(pers_ncorr) as  rut,
    protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_alumno
 from alumnos where post_ncorr in (
    select post_ncorr 
    from detalle_postulantes a
    where ofer_ncorr in (
        select distinct b.ofer_ncorr
        from especialidades a, ofertas_academicas b
        where a.espe_ccod=b.espe_ccod
        and a.carr_ccod=8
        and peri_ccod=206
    )
)

