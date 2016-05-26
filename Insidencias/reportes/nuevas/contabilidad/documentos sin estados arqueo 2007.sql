--**************    LETRAS    **************
select a.*,d.edin_tdesc 
from sd_letras_sin_estado_arqueo a, detalle_ingresos b, ingresos c, estados_detalle_ingresos d
where a.n_refencia=b.ding_ndocto
and b.ingr_ncorr=c.ingr_ncorr
and b.ting_ccod=4
and b.ding_ncorrelativo>0
and a.rut=protic.obtener_rut(pers_ncorr)
and b.edin_ccod=d.edin_ccod
and b.audi_tusuario not like '%LT-2E%'
and c.eing_ccod not  in (2,3,6)


--**************    CHEQUES    **************
select a.*,d.edin_tdesc,b.banc_ccod as banco 
from sd_cheques_sin_estado_arqueo a, detalle_ingresos b, ingresos c, estados_detalle_ingresos d
where a.n_refencia=b.ding_ndocto
and b.ingr_ncorr=c.ingr_ncorr
and b.ting_ccod=case tipo when 'CX' then 38 else 3 end
and b.ding_ncorrelativo>0
and a.rut=protic.obtener_rut(pers_ncorr)
and b.edin_ccod=d.edin_ccod
and b.audi_tusuario not like '%CH-2E%'
--and a.n_refencia=148385
and c.eing_ccod not  in (2,3,6)


--**************    PAGARES    **************
select a.*,d.edin_tdesc,b.banc_ccod as banco 
from sd_pagares_sin_estado_arqueo a, detalle_ingresos b, ingresos c, estados_detalle_ingresos d
where a.n_refencia=b.ding_ndocto
and b.ingr_ncorr=c.ingr_ncorr
and b.ting_ccod=52
and b.ding_ncorrelativo>0
and a.rut=protic.obtener_rut(pers_ncorr)
and b.edin_ccod=d.edin_ccod
--and b.audi_tusuario not like '%CH-2E%'
--and a.n_refencia=148385
and c.eing_ccod not  in (2,3,6)


select * from sd_cheques_sin_estado_arqueo where n_refencia=4157241

select n_refencia, count(*) 
from sd_letras_sin_estado_arqueo
group by n_refencia

