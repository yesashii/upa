select distinct a.espe_ccod,50 as ofer_nvacantes,a.sede_ccod as cod_sede,c.carr_ccod, d.jorn_ccod as jornada,case when post_bnuevo='S' then 'NUEVO' else 'ANTIGUO' end as nuevo,
cast(aran_mmatricula as numeric) as matricula, cast(aran_mcolegiatura as numeric) as arancel, 
aran_nano_ingreso as promocion,carr_tdesc as carrera,jorn_tdesc as jornada,sede_tdesc  as sede
from ofertas_academicas e,aranceles a, periodos_academicos b, carreras c, jornadas d,  sedes f
where a.peri_ccod=b.peri_ccod
and aran_mmatricula >1
and a.carr_ccod=c.carr_ccod
and e.jorn_ccod=d.jorn_ccod
and e.aran_ncorr=a.aran_ncorr
and e.peri_ccod=b.peri_ccod
and e.sede_ccod=f.sede_ccod
--and e.ofer_ncorr=33541
and b.peri_ccod in (226,228)
order by sede,carrera, jornada,promocion

