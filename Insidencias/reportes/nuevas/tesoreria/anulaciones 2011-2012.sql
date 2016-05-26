select mc.mcaj_ncorr as caja,sede_tdesc as sede,isnull(g.banc_tdesc,'sin banco') as banco,protic.trunc(d.ding_fdocto) as fecha_vencimiento, d.ding_ndocto  as numero_docto, 
t.ting_tdesc as tipo_docto,cast(d.ding_mdocto as numeric)  as monto_docto,cast(k.abon_mabono as numeric) as monto_anulado, protic.trunc(a.ingr_fpago) as fecha_pago,
protic.obtener_rut(a.pers_ncorr) as rut_alumno,e.edin_tdesc as estado, c.ting_tdesc as tipo_regularizacion,ccos_tcompuesto as centro_costo,protic.obtener_nombre_carrera(al.ofer_ncorr,'CJ') as carrera
From ingresos a
    join  detalle_ingresos b 
        on a.ingr_ncorr=b.ingr_ncorr
    join  movimientos_cajas mc
        on a.mcaj_ncorr=mc.mcaj_ncorr 
        and mc.caje_ccod=11       
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
    left outer join alumnos al
        on protic.obtener_post_ncorr(a.pers_ncorr,k.tcom_ccod,a.ingr_ncorr)=al.post_ncorr
        and al.emat_ccod not in (9)
    left outer join ofertas_academicas oc
        on al.ofer_ncorr=oc.ofer_ncorr    
    left outer join  especialidades es  
        on oc.espe_ccod=es.espe_ccod
    left outer join centros_costos_asignados cc
        on oc.sede_ccod=cc.cenc_ccod_sede
        and oc.jorn_ccod=cc.cenc_ccod_jornada
        and es.carr_ccod=cc.cenc_ccod_carrera
    left outer join centros_costo ck
        on cc.ccos_ccod=ck.ccos_ccod            
    join sedes s
        on mc.sede_ccod=s.sede_ccod
    Where b.ting_ccod in (
                        select ting_ccod
                        from tipos_ingresos 
                        where ting_bregularizacion='S'
                        and ereg_ccod=1
                        )
    and a.eing_ccod not in (3,6)

and convert(datetime,a.ingr_fpago,103) between  convert(datetime,'01/01/2011',103) and convert(datetime,'31/12/2012',103)    
--and year(a.ingr_fpago) =2007
order by a.ingr_fpago desc