
-- doctos anulados
select e.banc_tdesc as banco, protic.trunc(ding_fdocto) as fecha_vencimiento,ding_ndocto as numero_docto, 
d.ting_tdesc as tipo_docto,cast(ding_mdocto as numeric) as monto_docto, 'anulado' as estado_docto,
protic.obtener_rut(a.pers_ncorr) as rut_alumno, protic.obtener_rut(b.pers_ncorr_codeudor) as rut_aceptante
 from ingresos a, detalle_ingresos b, estados_detalle_ingresos c, tipos_ingresos d, bancos e
where a.ingr_ncorr=b.ingr_ncorr
and b.ting_ccod in (3,4,52)
and a.eing_ccod in (3,6)
and year(a.ingr_fpago) =2007
and b.edin_ccod=c.edin_ccod
and b.ting_ccod=d.ting_ccod
and b.banc_ccod*=e.banc_ccod
--and convert(datetime,a.ingr_fpago,103)>=convert(datetime,'30/10/2006',103)


-- letras emitidas
select ding_ndocto as numero_letra,protic.trunc(ingr_fpago) as fecha_creacion, 
protic.trunc(ding_fdocto) as fecha_vencimiento,
cast(ding_mdocto as numeric) as monto_letra,edin_tdesc as estado_documento 
from detalle_ingresos a, estados_detalle_ingresos b, ingresos c
where a.ting_ccod =4
and convert(datetime,c.ingr_fpago,103)>=convert(datetime,'31/08/2006',103)
and a.edin_ccod=b.edin_ccod
and a.ingr_ncorr=c.ingr_ncorr
order by ding_ndocto asc


--doctos regularizados

select g.banc_tdesc as banco,protic.trunc(d.ding_fdocto) as fecha_vencimiento , d.ding_ndocto  as numero_docto,
cast(d.ding_mdocto as numeric)  as monto_docto,cast(k.abon_mabono as numeric) as monto_anulado,t.ting_tdesc as tipo_docto,
protic.obtener_rut(a.pers_ncorr) as rut_alumno,protic.obtener_rut(d.pers_ncorr_codeudor) as rut_aceptante,
 e.edin_tdesc as estado, c.ting_tdesc as tipo_regularizacion
From ingresos a
    join  detalle_ingresos b 
        on a.ingr_ncorr=b.ingr_ncorr
    join  tipos_ingresos c
        on b.ting_ccod=c.ting_ccod
    join  abonos k  
        on a.ingr_ncorr=k.ingr_ncorr
    join detalle_ingresos d
        on protic.documento_asociado_cuota(k.tcom_ccod, k.inst_ccod, k.comp_ndocto, k.dcom_ncompromiso, 'ingr_ncorr')=d.ingr_ncorr
    join tipos_ingresos t
        on d.ting_ccod=t.ting_ccod
    join estados_detalle_ingresos e
        on d.edin_ccod=e.edin_ccod
    left outer join bancos g
        on d.banc_ccod=g.banc_ccod        
    Where b.ting_ccod in (
                        select ting_ccod
                        from tipos_ingresos 
                        where ting_bregularizacion='S'
                        and ereg_ccod=2
                        )
    and a.eing_ccod not in (3,6)
and year(a.ingr_fpago) =2007
