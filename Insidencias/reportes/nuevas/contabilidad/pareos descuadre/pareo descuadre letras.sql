/* LETRAS QUE ESTABANA EN SISTEMA EN CAJAS DE MIGRACION */
select ab.*,'<---------->' as separa, ld.*
from (
    select a.ingr_ncorr,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,
    a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,
    protic.documento_pagado_x_otro(a.ingr_ncorr,'S','A') as abono,
    protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado
    from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e
    where a.edin_ccod not in (6,11,16)
    and a.ting_ccod in (4)
    and a.ingr_ncorr=b.ingr_ncorr
    and b.eing_ccod not in (1,3,6)
    and mcaj_ncorr IN (1)
    and b.ingr_ncorr=c.ingr_ncorr
    and c.comp_ndocto=d.comp_ndocto
    and c.tcom_ccod=d.tcom_ccod
    and c.inst_ccod=d.inst_ccod
    and d.ecom_ccod=1
    and a.edin_ccod=e.edin_ccod
) as ab 
join sd_letras_descuadre ld
    on ab.num_docto = ld.num_docto
    and ab.rut=cast(ld.rut as varchar)+'-'+dv
order by ab.num_docto, ab.ingr_ncorr
    


/* LETRAS QUE ESTABAN EN SISTEMA EN CAJAS DE MIGRACION */
-- y estan como abonos
select ab.*,'<---------->' as separa, ld.*, ting_tdesc as tipo_docto
from (    
    select a.ingr_ncorr,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,
    b.mcaj_ncorr as caja, a.ting_ccod,a.ding_ndocto as num_docto, 0 as monto,
    protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado,
    cast(a.ding_mdocto as numeric) as abono
    from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e
    where a.edin_ccod not in (6,11,16)
    and a.ting_ccod in (4)
    and a.ingr_ncorr=b.ingr_ncorr
    and b.eing_ccod in (1)
    and mcaj_ncorr  IN (1)
    and b.ingr_ncorr=c.ingr_ncorr
    and c.comp_ndocto=d.comp_ndocto
    and c.tcom_ccod=d.tcom_ccod
    and c.inst_ccod=d.inst_ccod
    and d.ecom_ccod=1
    and a.edin_ccod=e.edin_ccod
) as ab 
join tipos_ingresos d
    on ab.ting_ccod=d.ting_ccod
join sd_letras_descuadre ld
    on ab.num_docto = ld.num_docto
    and ab.rut=cast(ld.rut as varchar)+'-'+dv
    
    
/* LETRAS QUE NO ESTAN EN EL PAREO*/
-- ESTAN PAGADAS EN SGA  (no funciona bien)
select distinct lp.*, edin_ccod from (
select * from sd_letras_descuadre
where num_docto not in (
    select ab.num_docto
    from (
        select a.ingr_ncorr,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,
        a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,
        protic.documento_pagado_x_otro(a.ingr_ncorr,'S','A') as abono,
        protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado
        from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e
        where a.edin_ccod not in (6,11,16)
        and a.ting_ccod in (4)
        and a.ingr_ncorr=b.ingr_ncorr
        and b.eing_ccod not in (1,3,6)
        and mcaj_ncorr IN (1)
        and b.ingr_ncorr=c.ingr_ncorr
        and c.comp_ndocto=d.comp_ndocto
        and c.tcom_ccod=d.tcom_ccod
        and c.inst_ccod=d.inst_ccod
        and d.ecom_ccod=1
        and a.edin_ccod=e.edin_ccod) as ab 
    ) ) lp, detalle_ingresos b
where b.ting_ccod=4
and lp.num_docto=b.ding_ndocto

/* LETRAS QUE NO ESTAN EN EL PAREO*/
-- ESTAN PAGADAS EN SGA   (calculo con clave compuesta) 
select distinct lp.*, edin_ccod from (
select * from sd_letras_descuadre lt
where cast(lt.num_docto as varchar)+'-'+cast(lt.rut as varchar) not in (
    select clave from (
        select cast(ld.num_docto as varchar)+'-'+cast(ld.rut as varchar) as clave
        from (
            select a.ingr_ncorr,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,
            a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,
            protic.documento_pagado_x_otro(a.ingr_ncorr,'S','A') as abono,
            protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado
            from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e
            where a.edin_ccod not in (6,11,16)
            and a.ting_ccod in (4)
            and a.ingr_ncorr=b.ingr_ncorr
            and b.eing_ccod not in (1,3,6)
            and mcaj_ncorr IN (1)
            and b.ingr_ncorr=c.ingr_ncorr
            and c.comp_ndocto=d.comp_ndocto
            and c.tcom_ccod=d.tcom_ccod
            and c.inst_ccod=d.inst_ccod
            and d.ecom_ccod=1
            and a.edin_ccod=e.edin_ccod
        ) as ab 
        join sd_letras_descuadre ld
            on ab.num_docto = ld.num_docto
            and ab.rut=cast(ld.rut as varchar)+'-'+dv
        --order by ab.num_docto, ab.ingr_ncorr
    ) as tabla
)) lp left outer join detalle_ingresos b
on b.ting_ccod=4
and lp.num_docto=b.ding_ndocto


/***********************************************************/
/* LETRAS DE MIGRACION QUE FALTARON EN EL PAREO */
select a.ingr_ncorr,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,
    a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,
    protic.documento_pagado_x_otro(a.ingr_ncorr,'S','A') as abono,
    protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado
    from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e
    where a.edin_ccod not in (6,11,16)
    and a.ting_ccod in (4)
    and a.ingr_ncorr=b.ingr_ncorr
    and b.eing_ccod not in (1,3,6)
    and mcaj_ncorr IN (1)
    and b.ingr_ncorr=c.ingr_ncorr
    and c.comp_ndocto=d.comp_ndocto
    and c.tcom_ccod=d.tcom_ccod
    and c.inst_ccod=d.inst_ccod
    and d.ecom_ccod=1
    and a.edin_ccod=e.edin_ccod
    and a.ingr_ncorr not in (
                select ab.ingr_ncorr
                from (
                    select a.ingr_ncorr,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,
                    a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,
                    protic.documento_pagado_x_otro(a.ingr_ncorr,'S','A') as abono,
                    protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado
                    from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e
                    where a.edin_ccod not in (6,11,16)
                    and a.ting_ccod in (4)
                    and a.ingr_ncorr=b.ingr_ncorr
                    and b.eing_ccod not in (1,3,6)
                    and mcaj_ncorr IN (1)
                    and b.ingr_ncorr=c.ingr_ncorr
                    and c.comp_ndocto=d.comp_ndocto
                    and c.tcom_ccod=d.tcom_ccod
                    and c.inst_ccod=d.inst_ccod
                    and d.ecom_ccod=1
                    and a.edin_ccod=e.edin_ccod
                ) as ab 
                join sd_letras_descuadre ld
                    on ab.num_docto = ld.num_docto
                    and ab.rut=cast(ld.rut as varchar)+'-'+dv
)    