select a.ofer_ncorr,c.espe_ccod,d.carr_tdesc, c.espe_tdesc, b.aran_mmatricula, b.aran_mcolegiatura,e.sede_tdesc, f.jorn_tdesc, a.audi_tusuario, a.audi_fmodificacion, D.AUDI_TUSUARIO
from ofertas_academicas a, aranceles b, especialidades c, carreras d, sedes e, jornadas f
where a.peri_ccod=202
and a.aran_ncorr=b.aran_ncorr
and a.espe_ccod=c.espe_ccod
and c.carr_ccod=d.carr_ccod
and a.sede_ccod=e.sede_ccod
and a.jorn_ccod=f.jorn_ccod