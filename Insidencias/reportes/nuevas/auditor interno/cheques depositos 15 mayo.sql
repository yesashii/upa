-- cheques en depositos desde el 15 de mayo 2007
select a.envi_ncorr as deposito,f.inen_tdesc as institucion,protic.trunc(a.envi_fenvio) as fecha_deposito, 
c.ding_ndocto as numero_ch,c.ding_tcuenta_corriente as cta_cte_ch,protic.trunc(c.ding_fdocto) as fecha_ch,
cast(c.ding_mdocto as numeric) as monto_ch,g.banc_tdesc as banco_ch,h.edin_tdesc as estado_ch,
 case 
            when d.ingr_fpago < '03/12/2006' then (select sede_tdesc from sedes where sede_ccod=1) 
            else e.sede_tdesc end as sede_origen,
            protic.obtener_rut(d.pers_ncorr) as rut_alumno 
from envios a, detalle_envios b, detalle_ingresos c, ingresos d, sedes e, instituciones_envio f, bancos g, estados_detalle_ingresos h
where convert(datetime,a.envi_fenvio,103) BETWEEN  convert(datetime,'15/05/2007',103) and convert(datetime,getdate(),103)
and a.tenv_ccod=2
and a.envi_ncorr=b.envi_ncorr
and b.ingr_ncorr=c.ingr_ncorr
and c.ingr_ncorr=d.ingr_ncorr
and c.sede_actual*=e.sede_ccod
and a.inen_ccod=f.inen_ccod
and c.banc_ccod=g.banc_ccod
and c.edin_ccod=h.edin_ccod
order by a.envi_fenvio, a.envi_ncorr desc

