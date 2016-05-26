
--Listado de empresas que han contratado cursos.

select distinct b.empr_trazon_social as empresa,b.empr_tgiro as giro, b.empr_tdireccion as direccion, b.empr_tejecutivo as ejecutivo, b.empr_tfono as fono,  b.empr_temail_ejecutivo as email, 
d.DCUR_TDESC  as nombre_programa, protic.trunc(c.dgso_finicio) as inicio, protic.trunc(c.dgso_ftermino) as fin
from ordenes_compras_otec a, empresas b, datos_generales_secciones_otec c, diplomados_cursos d
where a.empr_ncorr=b.empr_ncorr
and a.dgso_ncorr=c.dgso_ncorr
and c.dcur_ncorr=d.DCUR_NCORR
and fpot_ccod in (2,3)
--(empresas sin otic)
UNION
-- Empresas con otic, no se incluye la otic
select distinct b.empr_trazon_social as empresa,b.empr_tgiro as giro, b.empr_tdireccion as direccion, b.empr_tejecutivo as ejecutivo, b.empr_tfono as fono,  b.empr_temail_ejecutivo as email, 
d.DCUR_TDESC  as nombre_programa, protic.trunc(c.dgso_finicio) as inicio, protic.trunc(c.dgso_ftermino) as fin
from ordenes_compras_otec a, empresas b, datos_generales_secciones_otec c, diplomados_cursos d
where a.empr_ncorr_2=b.empr_ncorr
and a.dgso_ncorr=c.dgso_ncorr
and c.dcur_ncorr=d.DCUR_NCORR
and fpot_ccod in (4)

--select * from ordenes_compras_otec where fpot_ccod in (4)