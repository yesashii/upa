select c.ting_ccod, c.ding_ndocto, c.ingr_ncorr
from envios a, detalle_envios b, detalle_ingresos c, tipos_ingresos d, ingresos e, estados_detalle_ingresos f 
where a.envi_ncorr = b.envi_ncorr 
  and b.ting_ccod = c.ting_ccod 
  and b.ingr_ncorr = c.ingr_ncorr 
  and b.ding_ndocto = c.ding_ndocto 
  and c.ting_ccod = d.ting_ccod 
  and c.ingr_ncorr = e.ingr_ncorr 
  and c.edin_ccod = f.edin_ccod 
  and cast(a.envi_ncorr as varchar)= '77611'
 Order by c.ding_ndocto asc,c.ting_ccod asc

-- ---------------------------

begin TRANSACTION

update detalle_ingresos
set edin_ccod = 100

WHERE

ting_ccod in (select c.ting_ccod from envios a, detalle_envios b, detalle_ingresos c, tipos_ingresos d, ingresos e, estados_detalle_ingresos f 
where a.envi_ncorr = b.envi_ncorr 
  and b.ting_ccod = c.ting_ccod 
  and b.ingr_ncorr = c.ingr_ncorr 
  and b.ding_ndocto = c.ding_ndocto 
  and c.ting_ccod = d.ting_ccod 
  and c.ingr_ncorr = e.ingr_ncorr 
  and c.edin_ccod = f.edin_ccod 
  and cast(a.envi_ncorr as varchar)= '77611')

and ding_ndocto in (select c.ding_ndocto from envios a, detalle_envios b, detalle_ingresos c, tipos_ingresos d, ingresos e, estados_detalle_ingresos f 
where a.envi_ncorr = b.envi_ncorr 
  and b.ting_ccod = c.ting_ccod 
  and b.ingr_ncorr = c.ingr_ncorr 
  and b.ding_ndocto = c.ding_ndocto 
  and c.ting_ccod = d.ting_ccod 
  and c.ingr_ncorr = e.ingr_ncorr 
  and c.edin_ccod = f.edin_ccod 
  and cast(a.envi_ncorr as varchar)= '77611')

and ingr_ncorr in (select c.ingr_ncorr from envios a, detalle_envios b, detalle_ingresos c, tipos_ingresos d, ingresos e, estados_detalle_ingresos f 
where a.envi_ncorr = b.envi_ncorr 
  and b.ting_ccod = c.ting_ccod 
  and b.ingr_ncorr = c.ingr_ncorr 
  and b.ding_ndocto = c.ding_ndocto 
  and c.ting_ccod = d.ting_ccod 
  and c.ingr_ncorr = e.ingr_ncorr 
  and c.edin_ccod = f.edin_ccod 
  and cast(a.envi_ncorr as varchar)= '77611')

COMMIT



