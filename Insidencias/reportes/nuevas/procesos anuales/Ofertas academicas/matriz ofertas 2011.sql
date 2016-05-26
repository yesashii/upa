
/*Lista las ofertas que se impartieron para el año 2011, considerando cada promocion*/
select distinct c.espe_ccod,a.ofer_nvacantes,
    case when a.sede_ccod = 2 and c.carr_ccod in ('51','110') then 1
     when a.sede_ccod = 2 and c.carr_ccod not in ('51','110') then 8
     else a.sede_ccod end as cod_sede,
     case when a.sede_ccod = 2 and c.carr_ccod in ('51','110') then 'LAS CONDES'
     when a.sede_ccod = 2 and c.carr_ccod not in ('51','110') then 'BAQUEDANO'
     else b.sede_tdesc end as sede, d.carr_ccod as cod_carrera, carr_tdesc as carrera,
e.jorn_ccod as cod_jornada, jorn_tdesc as jornada, aran_nano_ingreso as año_ingreso, '' as matricula, '' as colegiatura
from ofertas_academicas a, sedes b, especialidades c, carreras d, jornadas e, aranceles f
where a.sede_ccod=b.sede_ccod 
    and a.espe_ccod=c.espe_ccod 
    and c.carr_ccod=d.carr_ccod 
    and a.jorn_ccod=e.jorn_ccod
    and a.peri_ccod in (222) 
    and a.aran_ncorr=f.aran_ncorr 
    and f.aran_mmatricula > 0 
    and f.aran_mcolegiatura > 0
    and exists (select 1 from alumnos tt where tt.ofer_ncorr=a.ofer_ncorr and tt.alum_nmatricula <> 7777)
    and tcar_ccod=1
    order by sede,carrera, jornada, año_ingreso desc
    



