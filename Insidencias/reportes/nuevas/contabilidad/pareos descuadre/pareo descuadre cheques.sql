/* CHEQUES QUE ESTABANA EN SISTEMA EN CAJAS DE MIGRACION */
select ab.*,'<---------->' as separa, ch.*
from (
    select a.ingr_ncorr,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,
    a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,
    protic.documento_pagado_x_otro(a.ingr_ncorr,'S','A') as abono,
    protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado
    from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e
    where a.edin_ccod not in (6,11,16)
    and a.ting_ccod in (3)
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
join sd_cheques_descuadre ch
    on ab.num_docto = ch.num_docto
    and ab.rut=cast(ch.rut as varchar)+'-'+dv
order by ab.num_docto, ab.ingr_ncorr
    


/* CHEQUES QUE ESTABAN EN SISTEMA EN CAJAS DE MIGRACION */
-- y estan como abonos
select ab.*,'<---------->' as separa, ch.*, ting_tdesc as tipo_docto
from (    
    select a.ingr_ncorr,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,
    b.mcaj_ncorr as caja, a.ting_ccod,a.ding_ndocto as num_docto, 0 as monto,
    protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado,
    cast(a.ding_mdocto as numeric) as abono
    from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e
    where a.edin_ccod not in (6,11,16)
    and a.ting_ccod in (3)
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
join sd_cheques_descuadre ch
    on ab.num_docto = ch.num_docto
    and ab.rut=cast(ch.rut as varchar)+'-'+dv
    
    
/* CHEQUES QUE NO ESTAN EN EL PAREO*/
-- ESTAN PAGADOS EN SGA
select distinct ch.*, edin_ccod from (
select * from sd_cheques_descuadre
where num_docto not in (
    select ab.num_docto
    from (
        select a.ingr_ncorr,protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,
        a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,
        protic.documento_pagado_x_otro(a.ingr_ncorr,'S','A') as abono,
        protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado
        from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e
        where a.edin_ccod not in (6,11,16)
        and a.ting_ccod in (3)
        and a.ingr_ncorr=b.ingr_ncorr
        and b.eing_ccod not in (1,3,6)
        and mcaj_ncorr IN (1)
        and b.ingr_ncorr=c.ingr_ncorr
        and c.comp_ndocto=d.comp_ndocto
        and c.tcom_ccod=d.tcom_ccod
        and c.inst_ccod=d.inst_ccod
        and d.ecom_ccod=1
        and a.edin_ccod=e.edin_ccod) as ab 
    ) ) ch left outer join detalle_ingresos b
on b.ting_ccod=3
and ch.num_docto=b.ding_ndocto

    
/* CHEQUES QUE NO ESTAN EN EL PAREO*/
-- ESTAN PAGADOS EN SGA   (calculo con clave compuesta) 

select distinct lp.*,b.ingr_ncorr, edin_ccod, envi_ncorr from (
select * from sd_cheques_descuadre lt
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
            and a.ting_ccod in (3)
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
        join sd_cheques_descuadre ld
            on ab.num_docto = ld.num_docto
            and ab.rut=cast(ld.rut as varchar)+'-'+dv
        --order by ab.num_docto, ab.ingr_ncorr
    ) as tabla
)) lp join personas per
    on lp.rut=per.pers_nrut
join ingresos ing
    on per.pers_ncorr= ing.pers_ncorr    
join detalle_ingresos b
    on b.ting_ccod=3
    and lp.num_docto=b.ding_ndocto
    and ing.ingr_ncorr=b.ingr_ncorr
order by b.ingr_ncorr desc,lp.num_docto    