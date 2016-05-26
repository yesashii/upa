select distinct pers_ncorr, protic.obtener_rut(pers_ncorr) as rut,
b.sede_ccod as sede, b.jorn_ccod as jornada, d.carr_tdesc as carrera 
from alumnos a, ofertas_academicas b, especialidades c, carreras d
where a.ofer_ncorr=b.ofer_ncorr
and b.espe_ccod=c.espe_ccod
and c.carr_ccod=d.carr_ccod
and d.tcar_ccod=1
and b.peri_ccod=210
and emat_ccod not in (3,4,5,8,9,10,14)
and a.pers_ncorr not in (
                    select distinct b.pers_ncorr 
                    from cargas_academicas a, alumnos b, ofertas_academicas c
                    where a.matr_ncorr=b.matr_ncorr
                    and b.ofer_ncorr=c.ofer_ncorr
                    and c.peri_ccod=212)
and protic.es_moroso(a.pers_ncorr, getdate())='S'
and protic.retorna_tipo_contrato(a.post_ncorr,b.peri_ccod,'T')='C'


-- los que tienen carga seg semestre
select distinct b.pers_ncorr 
from cargas_academicas a, alumnos b, ofertas_academicas c
where a.matr_ncorr=b.matr_ncorr
and b.ofer_ncorr=c.ofer_ncorr
and c.peri_ccod=208


