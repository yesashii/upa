-- Si tomaron
select distinct protic.obtener_rut (pers_ncorr) as rut, protic.obtener_nombre_completo(pers_ncorr,'n') as alumno  
from cargas_academicas a, alumnos b, ofertas_academicas c
where a.matr_ncorr=b.matr_ncorr
and b.ofer_ncorr=c.ofer_ncorr
and c.peri_ccod=224
and pers_ncorr in (
    select distinct pers_ncorr from sd_toma_carga_v3 a, personas b
    where a.rut=b.pers_nrut
)

--No tomaron

    select distinct protic.obtener_rut (pers_ncorr) as rut, protic.obtener_nombre_completo(pers_ncorr,'n') as alumno 
    from sd_toma_carga_v3 a, personas b
    where a.rut=b.pers_nrut
    and b.pers_ncorr not in (
            select distinct pers_ncorr
            from cargas_academicas a, alumnos b, ofertas_academicas c
            where a.matr_ncorr=b.matr_ncorr
            and b.ofer_ncorr=c.ofer_ncorr
            and c.peri_ccod=224
            and pers_ncorr in (
                select distinct pers_ncorr from sd_toma_carga_v3 a, personas b
                where a.rut=b.pers_nrut
            )
)