-- Filtrando carrera
select protic.obtener_rut(al.pers_ncorr) as rut,protic.obtener_nombre_completo(al.pers_ncorr,'n') as nombre_alumno,
(select emat_tdesc from estados_matriculas em where em.emat_ccod=al.emat_ccod) as estado_matricula,
protic.obtener_nombre_carrera(al.ofer_ncorr,'CJ') as carrera 
from alumnos al 
where alum_nmatricula=7777
and ofer_ncorr in (select distinct a.ofer_ncorr from ofertas_academicas a, especialidades b
where a.peri_ccod=222
and a.espe_ccod=b.espe_ccod
--and b.carr_ccod=45
)
order by carrera,rut, estado_matricula desc



-- General para admision 2012
select protic.trunc(alum_fmatricula) as fecha_matricula,protic.obtener_rut(al.pers_ncorr) as rut,
protic.obtener_nombre_completo(al.pers_ncorr,'n') as nombre_alumno,emat_tdesc as estado_matricula,
pa.peri_tdesc as periodo,oema_tobservacion as observacion,protic.obtener_nombre_carrera(al.ofer_ncorr,'CJ') as carrera 
from alumnos al, ofertas_academicas oa, estados_matriculas em, 
    periodos_academicos pa, observaciones_estado_matricula oe
where al.alum_nmatricula='7777'
and al.ofer_ncorr= oa.ofer_ncorr
and oa.peri_ccod>=226
and al.emat_ccod=em.emat_ccod
and oa.peri_ccod=pa.peri_ccod
and al.matr_ncorr*=oe.matr_ncorr
order by carrera, estado_matricula desc