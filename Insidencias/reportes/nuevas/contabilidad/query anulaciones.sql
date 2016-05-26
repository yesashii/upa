-- comprobantes de anulacion
select ingr_ncorr as ingreso_anulacion,protic.obtener_rut(pers_ncorr) as rut_alumno ,mcaj_ncorr as caja,
cast(ingr_mdocto as numeric) as monto,ingr_nfolio_referencia as comprobante_anulacion,protic.trunc(ingr_fpago) as fecha
from ingresos where ting_ccod=30


select * from NOTASCREDITOS_DOCUMENTOS

-- documentos anulados
select b.ingr_ncorr_notacredito as ingreso_anulacion, a.ingr_ncorr as ingreso_anulado,protic.obtener_rut(pers_ncorr) as rut_alumno,
mcaj_ncorr as caja_ingreso_anulado,cast(ingr_mefectivo as numeric) as monto_efectivo_anulado,cast(ingr_mtotal as numeric) as monto_documentado_anulado,
a.ingr_nfolio_referencia as comprobante_anulado,protic.trunc(ingr_fpago) as fecha_ingreso_anulado, d.ting_tdesc as tipo_comprobante_anulado, 
case when ingr_mefectivo>0 then 'EFECTIVO' else e.ting_tdesc end as tipo_docto_anulado
from ingresos a 
join NOTASCREDITOS_DOCUMENTOS b 
on a.ingr_ncorr=b.ingr_ncorr_documento
join tipos_ingresos d
    on a.ting_ccod=d.ting_ccod 
left outer join detalle_ingresos c
    on b.ingr_ncorr_documento=c.ingr_ncorr
left outer join tipos_ingresos e
    on c.ting_ccod=e.ting_ccod   
      
      
select * from 
(
    select ingr_ncorr as ingreso_anulacion,protic.obtener_rut(pers_ncorr) as rut_alumno ,mcaj_ncorr as caja_anulacion,
    cast(ingr_mdocto as numeric) as monto_anulacion,ingr_nfolio_referencia as comprobante_anulacion,protic.trunc(ingr_fpago) as fecha_anulacion
    from ingresos where ting_ccod=30
) as aa,
(
    select b.ingr_ncorr_notacredito as ingreso_anulacion, a.ingr_ncorr as ingreso_anulado,protic.obtener_rut(pers_ncorr) as rut_alumno,
    mcaj_ncorr as caja_ingreso_anulado,cast(ingr_mefectivo as numeric) as monto_efectivo_anulado,cast(ingr_mtotal as numeric) as monto_documentado_anulado,
    a.ingr_nfolio_referencia as comprobante_anulado,protic.trunc(ingr_fpago) as fecha_ingreso_anulado, d.ting_tdesc as tipo_comprobante_anulado, 
    case when ingr_mefectivo>0 then 'EFECTIVO' else e.ting_tdesc end as tipo_docto_anulado
    from ingresos a 
    join NOTASCREDITOS_DOCUMENTOS b 
    on a.ingr_ncorr=b.ingr_ncorr_documento
    join tipos_ingresos d
        on a.ting_ccod=d.ting_ccod 
    left outer join detalle_ingresos c
        on b.ingr_ncorr_documento=c.ingr_ncorr
    left outer join tipos_ingresos e
        on c.ting_ccod=e.ting_ccod   
) as bb   
where aa.ingreso_anulacion=bb.ingreso_anulacion  