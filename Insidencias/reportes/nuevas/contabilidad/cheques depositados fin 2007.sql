select a.envi_ncorr as num_deposito, protic.trunc(envi_fenvio) as fecha_deposito, envi_tdescripcion as glosa_deposito,
c.ding_ndocto as num_docto, protic.trunc(c.ding_fdocto) as fecha_vencimiento, cast(c.ding_mdocto as numeric) as monto, banc_tdesc as bando
from envios a, detalle_envios b, detalle_ingresos c, bancos d
where a.envi_ncorr=b.envi_ncorr
and b.ingr_ncorr=c.ingr_ncorr
and tdep_ccod in (1,2)
and c.banc_ccod=d.banc_ccod
and convert(datetime,envi_fenvio,103) 
BETWEEN  isnull(convert(datetime,'27/12/2007',103),convert(datetime,envi_fenvio,103)) 
and isnull(convert(datetime,'31/12/2007',103),convert(datetime,envi_fenvio,103))
order by envi_fenvio desc,a.envi_ncorr