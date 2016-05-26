select (select count(*) from alumnos where ofer_ncorr=a.ofer_ncorr and emat_ccod=1) as cantidad ,f.sede_tdesc as sede_real,
case f.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
c.carr_tdesc as carrera,jorn_tdesc as jornada,e.anos_ccod as Admision
from ofertas_academicas a, especialidades b, carreras c, jornadas d, periodos_academicos e, sedes f
where a.post_bnuevo='S'
and a.peri_ccod in (164)
and a.espe_ccod=b.espe_ccod
and b.carr_ccod=c.carr_ccod
and a.jorn_ccod=d.jorn_ccod
and a.peri_ccod=e.peri_ccod
and a.sede_ccod=f.sede_ccod
and c.tcar_ccod=1
and c.carr_ccod not in ('001','007','820')
order by admision, sede,carrera



select * from carreras