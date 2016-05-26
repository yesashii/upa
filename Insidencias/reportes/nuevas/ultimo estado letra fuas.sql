Select c.edin_tdesc,b.edin_ccod_destino,tabla.* from (
select 
(
        select max(dist_ncorr) as dist_ncorr
            from (
                select  dist_ncorr
                from detalle_ingresos_historial 
                where ding_ndocto_origen=g.ding_ndocto
                and ting_ccod_origen=4 
                and edin_ccod_destino not in (11,6)
                group by  dist_ncorr,edin_ccod_origen
            ) as tabla
) as dist_ncorr,
a.*, g.ding_ndocto, h.edin_tdesc as estado_actual, e.tcom_ccod
 from fox..sd_beneficiados_fuas_letras a, postulantes c, 
 contratos d, abonos e, ingresos f, detalle_ingresos g, estados_detalle_ingresos h
where a.pers_ncorr=c.pers_ncorr
and c.peri_ccod=202
and c.post_ncorr=d.post_ncorr
and d.econ_ccod not in (2,3)
and d.cont_ncorr=e.comp_ndocto
and e.tcom_ccod in (1,2)
and e.inst_ccod=1
and e.ingr_ncorr=f.ingr_ncorr
and f.ting_ccod=7
and f.ingr_ncorr=g.ingr_ncorr
and g.ting_ccod=4
and g.edin_ccod=h.edin_ccod
) as tabla , detalle_ingresos_historial b, estados_detalle_ingresos c
where tabla.dist_ncorr=b.dist_ncorr
and b.edin_ccod_destino=c.edin_ccod