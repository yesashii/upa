Select ii.ingr_nfolio_referencia as comprobante,
    protic.obtener_rut(ii.pers_ncorr) as rut_alumno,
    protic.obtener_rut((select pers_ncorr_codeudor from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) ) as rut_apoderado,
    isnull(cast(protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as numero_docto,  
    (select banc_tdesc from bancos where banc_ccod=(select banc_ccod from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr'))) as banco,
    (select envi_ncorr from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) as deposito,
    (select protic.trunc(envi_fenvio) from envios where envi_ncorr=(select envi_ncorr from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')))as fecha_deposito,
    protic.trunc((select ding_fdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr'))) as fecha_vencimiento,
    cast((select ding_mdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) as numeric) as monto_docto,
    cast(SUM(ab.ABON_MABONO) as numeric) monto_abonado,
    protic.total_recepcionar_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso)   as saldo, 
    case upper(ti.ting_tdesc) when 'DOCUMENTO EN CAJA' then 'CHEQUE' else ti.ting_tdesc end  as docto_pagado,
    (select ting_tdesc from tipos_ingresos where ting_ccod=isnull(b.ting_ccod,6)) as pagado_con, protic.trunc(ii.ingr_fpago) as fecha_pago   
		     from ingresos ii,abonos ab,tipos_ingresos ti, detalle_ingresos b   
		     where ii.ingr_ncorr = ab.ingr_ncorr   
		      -- and ii.ingr_nfolio_referencia in (select ingr_nfolio_referencia from ingresos where mcaj_ncorr=2789 )   
		         --and ii.ting_ccod in (9,15,17,34)
                 and ii.ting_ccod not in (7,8,15,87,88)
                 and ii.ingr_ncorr*=b.ingr_ncorr   
		         and protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ting_ccod') = ti.ting_ccod   
                 and ti.ting_ccod in (3,4,13,51,52,88,38)
                 and convert(datetime,ii.ingr_fpago,103) BETWEEN  isnull(convert(datetime,'27/12/2007',103),convert(datetime,ii.ingr_fpago,103)) and isnull(convert(datetime,'31/12/2007',103),convert(datetime,ii.ingr_fpago,103))
		  GROUP BY  ii.ting_ccod,ii.ingr_fpago,b.pers_ncorr_codeudor,ii.pers_ncorr,b.ting_ccod,ii.ingr_nfolio_referencia, ab.inst_ccod,ab.tcom_ccod, ab.comp_ndocto, ab.dcom_ncompromiso,ti.ting_tdesc
order by docto_pagado, numero_docto



--select * from tipos_ingresos

/*
select protic.* from ingresos 
where convert(datetime,ingr_fpago,103) BETWEEN  isnull(convert(datetime,'27/12/2007',103),convert(datetime,ingr_fpago,103)) 
and isnull(convert(datetime,'31/12/2007',103),convert(datetime,ingr_fpago,103))
and ting_ccod not in(7)*/