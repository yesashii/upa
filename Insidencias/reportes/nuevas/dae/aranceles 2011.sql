select distinct case when post_bnuevo='S' then 'NUEVO' else 'ANTIGUO' end as nuevo,cast(aran_mmatricula as numeric) as matricula, cast(aran_mcolegiatura as numeric) as arancel, aran_nano_ingreso as promocion,
carr_tdesc as carrera,jorn_tdesc as jornada,sede_tdesc  as sede--,* 
from aranceles a, periodos_academicos b, carreras c, jornadas d, ofertas_academicas e, sedes f
where a.peri_ccod=b.peri_ccod
and b.peri_ccod=226
and aran_mmatricula >0
and a.carr_ccod=c.carr_ccod
and a.jorn_ccod=d.jorn_ccod
and e.aran_ncorr=a.aran_ncorr
and e.peri_ccod=226
and e.sede_ccod=f.sede_ccod
order by sede,carrera, jornada,promocion
