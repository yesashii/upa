select cast(b.aran_mmatricula as numeric) as matricula, cast(b.aran_mcolegiatura as numeric) as arancel, 
carr_tdesc as carrera, sede_tdesc as sede, jorn_tdesc as jornada --,* 
from ofertas_academicas a, aranceles b, sedes c, jornadas d, carreras e 
where a.aran_ncorr=b.aran_ncorr
and a.post_bnuevo='S'
and a.peri_ccod=218
and a.sede_ccod=c.sede_ccod
and a.jorn_ccod=d.jorn_ccod
and b.carr_ccod=e.carr_ccod
and tcar_ccod=1
and convert(datetime,ingr_fpago,103) between  convert(datetime,'01/02/2010',103) and convert(datetime,getdate(),103)


select 