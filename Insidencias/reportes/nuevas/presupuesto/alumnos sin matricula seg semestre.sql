select protic.es_moroso(b.pers_ncorr, getdate()),protic.es_moroso_monto(b.pers_ncorr, getdate()),a.*
from fox..sd_alumnos_diseno a, personas b, alumnos c, ofertas_academicas d,especialidades e
where a.rut=b.pers_nrut
and b.pers_ncorr=c.pers_ncorr
and c.ofer_ncorr=d.ofer_ncorr
and d.peri_ccod=202
and d.espe_ccod=e.espe_ccod
and e.carr_ccod in ('16','21','23')
and emat_ccod not in (9)
and b.pers_ncorr not in (
        select distinct pers_ncorr from alumnos a, ofertas_academicas b, especialidades c, carreras d
        where a.ofer_ncorr=b.ofer_ncorr
        and b.peri_ccod=204
        and emat_ccod not in (9)
        and b.espe_ccod=c.espe_ccod
        and c.carr_ccod=d.carr_ccod
        and d.carr_ccod in ('16','21','23')
    )
    
    
--**********************************************
select protic.es_moroso(a.pers_ncorr, getdate()),protic.es_moroso_monto(a.pers_ncorr, getdate())
 from alumnos a, ofertas_academicas b, especialidades c, carreras d
where a.ofer_ncorr=b.ofer_ncorr
    and b.peri_ccod=202
    and emat_ccod not in (9)
    and b.espe_ccod=c.espe_ccod
    and c.carr_ccod=d.carr_ccod
    and d.carr_ccod in ('16','21','23')
    and a.pers_ncorr not in (
        select distinct pers_ncorr from alumnos a, ofertas_academicas b, especialidades c, carreras d
        where a.ofer_ncorr=b.ofer_ncorr
        and b.peri_ccod=204
        and emat_ccod not in (9)
        and b.espe_ccod=c.espe_ccod
        and c.carr_ccod=d.carr_ccod
        and d.carr_ccod in ('16','21','23')
    )    