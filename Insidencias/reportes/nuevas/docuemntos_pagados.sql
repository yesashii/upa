Select ii.ingr_nfolio_referencia,
    protic.obtener_rut(ii.pers_ncorr) as rut_alumno,
    protic.obtener_rut((select pers_ncorr_codeudor from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) ) as rut_apoderado,
    isnull(cast(protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as numero_docto,  
    (select banc_ccod from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) as banco,
    protic.trunc((select ding_fdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr'))) as fecha_vencimiento,
    (select ding_mdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) as monto_docto,
    SUM(ab.ABON_MABONO) monto_abonado,
    protic.total_recepcionar_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso)   as saldo, 
    case upper(ti.ting_tdesc) when 'DOCUMENTO EN CAJA' then 'CHEQUE' else ti.ting_tdesc end  as docto_pagado,
    (select ting_tdesc from tipos_ingresos where ting_ccod=isnull(b.ting_ccod,6)) as pagado_con   
		     from ingresos ii,abonos ab,tipos_ingresos ti, detalle_ingresos b   
		     where ii.ingr_ncorr = ab.ingr_ncorr   
		       and ii.ingr_nfolio_referencia in (select ingr_nfolio_referencia from ingresos where mcaj_ncorr=2789 )   
		         and ii.ting_ccod in (9,34)
                 and ii.ingr_ncorr*=b.ingr_ncorr   
		         and protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ting_ccod') = ti.ting_ccod   
                 and ti.ting_ccod in (3,4,13,51,52,88,38)
---                 and ii.ingr_nfolio_referencia=70472
		  GROUP BY  b.pers_ncorr_codeudor,ii.pers_ncorr,b.ting_ccod,ii.ingr_nfolio_referencia, ab.inst_ccod,ab.tcom_ccod, ab.comp_ndocto, ab.dcom_ncompromiso,ti.ting_tdesc
order by docto_pagado, numero_docto


select protic.obtener_rut(a.pers_ncorr),a.ting_ccod,a.mcaj_ncorr,b.* 
from ingresos a, abonos b 
where ingr_nfolio_referencia=61552
and a.ingr_ncorr=b.ingr_ncorr

select * from detalle_ingresos where ding_ndocto=3580194

select * from ingresos where ingr_nfolio_referencia=78983 and ting_ccod=15

select * from tipos_detalle where tben_ccod in (2,3)

select * from 