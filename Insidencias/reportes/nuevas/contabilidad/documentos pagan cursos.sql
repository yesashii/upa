select protic.obtener_rut(d.pers_ncorr) as rut_alumno,
(select ting_tdesc from tipos_ingresos where ting_ccod=d.ting_ccod)as forma_ingreso ,
f.ding_ndocto as nro_docto_pagado,f.edin_ccod as estado,(select ting_tdesc from tipos_ingresos where ting_ccod=f.ting_ccod) as tipo_docto,f.ding_mdocto as monto,
e.ding_ndocto as nro_docto_pago, isnull(e.ding_mdocto,case when d.ingr_mdocto=0 then d.ingr_mefectivo else d.ingr_mdocto end) as monto,
e.edin_ccod as estado,(select ting_tdesc from tipos_ingresos where ting_ccod=isnull(e.ting_ccod,6)) as medio_pago,
d.ingr_nfolio_referencia as folio, d.mcaj_ncorr as caja, 
(select top 1 tdet_tdesc from tipos_detalle a, detalles b where a.tdet_ccod=b.tdet_ccod and b.comp_ndocto=c.comp_ndocto and b.tcom_ccod=7 and b.tdet_ccod not in (909) ) as curso
from ingresos a, abonos b,detalle_ingresos f, abonos c, ingresos d, detalle_ingresos e
where a.ingr_ncorr=b.ingr_ncorr
and a.ting_ccod=33
and a.eing_ccod not in (2,3)
and b.ingr_ncorr*=f.ingr_ncorr
and b.tcom_ccod=c.tcom_ccod
and b.comp_ndocto=c.comp_ndocto
and b.inst_ccod=c.inst_ccod
and b.dcom_ncompromiso=c.dcom_ncompromiso
and c.ingr_ncorr=d.ingr_ncorr
and d.ting_ccod in (9,17,34)
and d.ingr_ncorr*=e.ingr_ncorr
