    select distinct f.ting_tdesc as tipo,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, 
    a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,
    cast(a.ding_mdocto as numeric) -protic.total_recepcionar_cuota(c.tcom_ccod,c.inst_ccod,c.comp_ndocto,c.dcom_ncompromiso) as abonado, 
    protic.total_recepcionar_cuota(c.tcom_ccod,c.inst_ccod,c.comp_ndocto,c.dcom_ncompromiso) as saldo,
    a.banc_ccod, protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado, 
    isnull(a.sede_actual,(select sede_ccod  from movimientos_cajas where mcaj_ncorr=b.mcaj_ncorr)) as sede_actual
    from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e, tipos_ingresos f
    where a.edin_ccod not in (6,11,16)
    and a.ting_ccod in (38)
    and a.ingr_ncorr=b.ingr_ncorr
    and b.eing_ccod not in (3,6)
    and mcaj_ncorr > 1
    and b.ingr_ncorr=c.ingr_ncorr
    and c.comp_ndocto=d.comp_ndocto
    and c.tcom_ccod=d.tcom_ccod
    and c.inst_ccod=d.inst_ccod
    and d.ecom_ccod=1
    and a.edin_ccod=e.edin_ccod
    and a.ting_ccod=f.ting_ccod
    and convert(datetime,a.ding_fdocto,103) <= convert(datetime,getdate(),103)
UNION    
    select distinct f.ting_tdesc as tipo,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, 
    a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,
    cast(a.ding_mdocto as numeric) -protic.total_recepcionar_cuota(c.tcom_ccod,c.inst_ccod,c.comp_ndocto,c.dcom_ncompromiso) as abonado,   
    protic.total_recepcionar_cuota(c.tcom_ccod,c.inst_ccod,c.comp_ndocto,c.dcom_ncompromiso) as saldo,
    a.banc_ccod,protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado, 
    isnull(a.sede_actual,(select sede_ccod  from movimientos_cajas where mcaj_ncorr=b.mcaj_ncorr)) as sede_actual
    from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e, tipos_ingresos f
    where a.edin_ccod not in (6,11,16)
    and a.ting_ccod in (3,14)
    and a.ingr_ncorr=b.ingr_ncorr
    and b.eing_ccod not in (3,6)
    and mcaj_ncorr > 1
    and b.ingr_ncorr=c.ingr_ncorr
    and c.comp_ndocto=d.comp_ndocto
    and c.tcom_ccod=d.tcom_ccod
    and c.inst_ccod=d.inst_ccod
    and d.ecom_ccod=1
    and a.edin_ccod=e.edin_ccod
    and a.ting_ccod=f.ting_ccod
    and convert(datetime,a.ding_fdocto,103) >= convert(datetime,'31/10/2008',103)    
    
    