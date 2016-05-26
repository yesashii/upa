-- Socofin
select distinct rut, dv,d.ding_ndocto as nro_docto,protic.trunc(d.ding_fdocto) as fecha,cast(d.ding_mdocto as numeric) as monto,
d.envi_ncorr as envio,f.ting_tdesc as tipo_doc, e.edin_tdesc  as estado, cast(c.mto_cuota as numeric) as monto_informado,c.fecha_venc as fecha_informada
from envios a, detalle_envios b, sd_socofin_deudas c, detalle_ingresos d, 
estados_detalle_ingresos e, tipos_ingresos f
where tenv_ccod=1 
and inen_ccod in (10)
and a.envi_ncorr=b.envi_ncorr
and b.ding_ndocto=c.num_operacion
and b.ting_ccod=c.producto
and b.ingr_ncorr=d.ingr_ncorr
and d.edin_ccod=e.edin_ccod
and d.ting_ccod=f.ting_ccod

-- no estan en SGA
select protic.obtener_rut(pers_ncorr) as rut,d.ding_ndocto as nro_docto,protic.trunc(d.ding_fdocto) as fecha,
cast(d.ding_mdocto as numeric) as monto,d.envi_ncorr as envio,f.ting_tdesc as tipo_doc, e.edin_tdesc  as estado
from  envios a, detalle_envios b, detalle_ingresos d, ingresos c,estados_detalle_ingresos e, tipos_ingresos f  
where c.ingr_ncorr not in (
        select distinct b.ingr_ncorr
        from envios a, detalle_envios b, sd_socofin_deudas c, detalle_ingresos d, 
        estados_detalle_ingresos e, tipos_ingresos f
        where tenv_ccod=1 
        and inen_ccod in (10)
        and a.envi_ncorr=b.envi_ncorr
        and b.ding_ndocto=c.num_operacion
        and b.ting_ccod=c.producto
        and b.ingr_ncorr=d.ingr_ncorr
        and d.edin_ccod=e.edin_ccod
        and d.ting_ccod=f.ting_ccod
)
and tenv_ccod=1 
and inen_ccod in (10)
and a.envi_ncorr    = b.envi_ncorr
and b.ingr_ncorr    = d.ingr_ncorr
and d.ingr_ncorr    = c.ingr_ncorr
and d.edin_ccod     = e.edin_ccod
and d.ting_ccod     = f.ting_ccod



-- no estan en socofin
select * from sd_socofin_deudas 
where correlativo not in (
        select distinct c.correlativo
        from envios a, detalle_envios b, sd_socofin_deudas c, detalle_ingresos d, 
        estados_detalle_ingresos e, tipos_ingresos f
        where tenv_ccod=1 
        and inen_ccod in (10)
        and a.envi_ncorr=b.envi_ncorr
        and b.ding_ndocto=c.num_operacion
        and b.ting_ccod=c.producto
        and b.ingr_ncorr=d.ingr_ncorr
        and d.edin_ccod=e.edin_ccod
        and d.ting_ccod=f.ting_ccod
)


-- Base socofin
select protic.obtener_rut(pers_ncorr) as rut,d.ding_ndocto as nro_docto,protic.trunc(d.ding_fdocto) as fecha,
cast(d.ding_mdocto as numeric) as monto,d.envi_ncorr as envio,f.ting_tdesc as tipo_doc, e.edin_tdesc  as estado 
from  envios a, detalle_envios b, detalle_ingresos d, ingresos c,estados_detalle_ingresos e, tipos_ingresos f  
where  tenv_ccod=1 
and inen_ccod in (10)
and a.envi_ncorr    = b.envi_ncorr
and b.ingr_ncorr    = d.ingr_ncorr
and d.ingr_ncorr    = c.ingr_ncorr
and d.edin_ccod     = e.edin_ccod
and d.ting_ccod     = f.ting_ccod




--*********************************************************************
-- cobracard
--*********************************************************************

select distinct rut, dv,d.ding_ndocto as nro_docto,protic.trunc(d.ding_fdocto) as fecha,cast(d.ding_mdocto as numeric) as monto,
d.envi_ncorr as envio,f.ting_tdesc as tipo_doc, e.edin_tdesc  as estado, c.*
from envios a, detalle_envios b, sd_cobracard_deudas c, detalle_ingresos d, 
estados_detalle_ingresos e, tipos_ingresos f, ingresos g, personas h 
where tenv_ccod=1 
and inen_ccod in (11)
and a.envi_ncorr    = b.envi_ncorr
and b.ingr_ncorr    = d.ingr_ncorr
and d.ding_fdocto   = c.vence
and d.ting_ccod     = c.td
and d.ding_mdocto   = c.capital
and d.edin_ccod     = e.edin_ccod
and d.ting_ccod     = f.ting_ccod
and d.ingr_ncorr    = g.ingr_ncorr
and g.pers_ncorr    = h.pers_ncorr
and rut=h.pers_nrut

-- No estan en Cobracard
select * from sd_cobracard_deudas 
where correlativo not in (
    select distinct  c.correlativo
    from envios a, detalle_envios b, sd_cobracard_deudas c, detalle_ingresos d, 
    estados_detalle_ingresos e, tipos_ingresos f
    where tenv_ccod=1 
    and inen_ccod in (11)
    and a.envi_ncorr    = b.envi_ncorr
    and b.ingr_ncorr    = d.ingr_ncorr
    and d.ding_fdocto   = c.vence
    and d.ting_ccod     = c.td
    and d.ding_mdocto   = c.capital
    and d.edin_ccod     = e.edin_ccod
    and d.ting_ccod     = f.ting_ccod
)


-- no estan en SGA
select protic.obtener_rut(pers_ncorr) as rut,d.ding_ndocto as nro_docto,protic.trunc(d.ding_fdocto) as fecha,
cast(d.ding_mdocto as numeric) as monto,d.envi_ncorr as envio,f.ting_tdesc as tipo_doc, e.edin_tdesc  as estado
from  envios a, detalle_envios b, detalle_ingresos d, ingresos c,estados_detalle_ingresos e, tipos_ingresos f  
where c.ingr_ncorr not in (
        select distinct  b.ingr_ncorr
        from envios a, detalle_envios b, sd_cobracard_deudas c, detalle_ingresos d, 
        estados_detalle_ingresos e, tipos_ingresos f
        where tenv_ccod=1 
        and inen_ccod in (11)
        and a.envi_ncorr    = b.envi_ncorr
        and b.ingr_ncorr    = d.ingr_ncorr
        and d.ding_fdocto   = c.vence
        and d.ting_ccod     = c.td
        and d.ding_mdocto   = c.capital
        and d.edin_ccod     = e.edin_ccod
        and d.ting_ccod     = f.ting_ccod
)
and tenv_ccod=1 
and inen_ccod in (11)
and a.envi_ncorr    = b.envi_ncorr
and b.ingr_ncorr    = d.ingr_ncorr
and d.ingr_ncorr    = c.ingr_ncorr
and d.edin_ccod     = e.edin_ccod
and d.ting_ccod     = f.ting_ccod

-- Base cobracar
select protic.obtener_rut(pers_ncorr) as rut,d.ding_ndocto as nro_docto,protic.trunc(d.ding_fdocto) as fecha,
cast(d.ding_mdocto as numeric) as monto,d.envi_ncorr as envio,f.ting_tdesc as tipo_doc, e.edin_tdesc  as estado 
from  envios a, detalle_envios b, detalle_ingresos d, ingresos c,estados_detalle_ingresos e, tipos_ingresos f  
where  tenv_ccod=1 
and inen_ccod in (10)
and a.envi_ncorr    = b.envi_ncorr
and b.ingr_ncorr    = d.ingr_ncorr
and d.ingr_ncorr    = c.ingr_ncorr
and d.edin_ccod     = e.edin_ccod
and d.ting_ccod     = f.ting_ccod