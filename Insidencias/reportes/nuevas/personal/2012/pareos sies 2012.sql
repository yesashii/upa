select jerarquia,d.tcdo_tdesc,protic.obtener_grado_docente(b.pers_ncorr,'G') as grado,a.* 
from sd_sies_2011 a join personas b
    on a.rut=b.pers_nrut
left outer join contratos_docentes_upa c
    on b.pers_ncorr=c.pers_ncorr
    and c.ano_contrato=2011
left outer join tipos_contratos_docentes d
    on c.tcdo_ccod=d.tcdo_ccod
left outer join (select pers_ncorr, max(jd.jdoc_tdesc) as jerarquia 
    from profesores pe, jerarquias_docentes jd
    where pe.jdoc_ccod=jd.jdoc_ccod
    group by pers_ncorr) e
on b.pers_ncorr=e.pers_ncorr