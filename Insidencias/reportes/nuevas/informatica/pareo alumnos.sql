-- Matriculados
select protic.obtener_nombre_carrera(c.ofer_ncorr,'CJ') as carrera,a.* 
from sd_postulantes_upa_rezagados a, personas_postulante b, alumnos c, postulantes d
where a.rut=b.pers_nrut
and b.pers_ncorr=c.pers_ncorr
and c.post_ncorr=d.post_ncorr
and d.peri_ccod=206


-- No matriculados
select a.* from sd_postulantes_upa_rezagados a, personas_postulante b, postulantes c
where a.rut=b.pers_nrut
and b.pers_ncorr=c.pers_ncorr
and c.peri_ccod=202
and b.pers_ncorr not in (
        select distinct b.pers_ncorr
        from sd_postulantes_upa_rezagados a, personas_postulante b, alumnos c, postulantes d
        where a.rut=b.pers_nrut
        and b.pers_ncorr=c.pers_ncorr
        and c.post_ncorr=d.post_ncorr
        and d.peri_ccod=206
)

-- No figuran en Base datos
select * from sd_postulantes_upa_rezagados
where rut not in (
    select rut from sd_postulantes_upa_rezagados a, personas_postulante b
    where a.rut=b.pers_nrut
    ) 