select distinct c.espe_ccod,a.ofer_nvacantes,a.sede_ccod as cod_sede,b.sede_tdesc as sede, d.carr_ccod as cod_carrera, carr_tdesc as carrera,
e.jorn_ccod as cod_jornada, jorn_tdesc as jornada, aran_nano_ingreso as año_ingreso, '' as matricula, '' as colegiatura
from ofertas_academicas a, sedes b, especialidades c, carreras d, jornadas e, aranceles f
where a.sede_ccod=b.sede_ccod 
and a.espe_ccod=c.espe_ccod 
and c.carr_ccod=d.carr_ccod 
and a.jorn_ccod=e.jorn_ccod
and a.peri_ccod in (214,216) 
and a.aran_ncorr=f.aran_ncorr 
and f.aran_mmatricula > 0 
and f.aran_mcolegiatura > 0
and exists (select 1 from alumnos tt where tt.ofer_ncorr=a.ofer_ncorr and tt.alum_nmatricula <> 7777)
order by sede,carrera, jornada, año_ingreso desc