 select isnull(sum(cheque),0) as cheques,isnull(sum(letra),0) as letras,     
				  isnull(sum(efectivo),0) as efectivo,isnull(sum(credito),0) as credito,    
				  isnull(sum(vale_vista),0) as vale_vista,isnull(sum(debito),0) as debito,    
				  isnull(sum(pagare),0) as pagare,     
				  (isnull(sum(cheque),0) + isnull(sum(letra),0) + isnull(sum(efectivo),0) + isnull(sum(credito),0) +    
				  isnull(sum(vale_vista),0) +isnull(sum(debito),0) + isnull(sum(pagare),0) ) as total   
				  from (     
select mcaj_ncorr,
case ting_ccod when 3 then cast(sum(monto_recaudado) as numeric) end as cheque,     
case ting_ccod when 4 then cast(sum(monto_recaudado) as numeric) end as letra,    
case ting_ccod when 6 then cast(sum(monto_recaudado) as numeric) end as efectivo,    
case ting_ccod when 13 then cast(sum(monto_recaudado) as numeric) end as credito,    
case ting_ccod when 14 then cast(sum(monto_recaudado) as numeric) end as vale_vista,    
case ting_ccod when 51 then cast(sum(monto_recaudado) as numeric) end as debito,    
case ting_ccod when 52 then cast(sum(monto_recaudado) as numeric) end as pagare    
from (    
  select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,    
  case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 
        when a.ting_ccod = 88 then 3 
        else b.ting_ccod end as ting_ccod,    
  case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo else (case a.ting_ccod when 88 then 0 else b.ding_mdetalle end -protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado     
  from ingresos a     
  left outer join detalle_ingresos b     
	  on a.ingr_ncorr=b.ingr_ncorr     
	  and b.ting_ccod in (3,4,6,13,14,51,52,88)     
  where a.ting_ccod  in (7,15,16,33,34,88)  
  --and a.pers_ncorr=103688   
) as tabla     
group by mcaj_ncorr,ting_ccod
	  ) a     
	  join movimientos_cajas b     
		  on a.mcaj_ncorr=b.mcaj_ncorr   
		  and b.tcaj_ccod in (1000)     
				  --group by b.mcaj_finicio



-----------------------------------------------------------------------------                      
--***************************************************************************

select protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A') abonado,a.ingr_ncorr,b.ding_ndocto,
isnull(b.ding_bpacta_cuota,'N') as pacta_cuota,a.mcaj_ncorr,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,    
case when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 else b.ting_ccod end as ting_ccod,    
case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo else b.ding_mdetalle end as monto_recaudado     
from ingresos a     
left outer join detalle_ingresos b     
  on a.ingr_ncorr=b.ingr_ncorr     
  and b.ting_ccod in (3,4,6,13,14,51,52,58)     
where --a.mcaj_ncorr in (select mcaj_ncorr from movimientos_cajas where sede_ccod in (4) ) and    
     a.ting_ccod  in (7,15,16,33,34,88)  
    and a.pers_ncorr=103688   


select tcom_ccod ,inst_ccod, comp_ndocto, dcom_ncompromiso,* 
from abonos where ingr_ncorr=81831


select a.*
from abonos a
where a.tcom_ccod=14 
and a.inst_ccod=1 
and a.comp_ndocto=80
and a.dcom_ncompromiso=1


select * from detalle_ingresos where ding_ndocto=58 and ting_ccod=38
select * from detalle_ingresos where ingr_ncorr in (181456)
select * from ingresos where ingr_ncorr in (181457)

select * from tipos_ingresos 
select * from estados_ingresos 
select * from abonos where comp_ndocto=64953 and tcom_ccod=3

select b.*
from abonos a, ingresos b
where a.ingr_ncorr=b.ingr_ncorr
and a.tcom_ccod=3 
and a.inst_ccod=1 
and a.comp_ndocto=64953
and a.dcom_ncompromiso=1
and a.ingr_ncorr not in (181456)

select protic.documento_pagado_bancaj(181456,'S','A')
select protic.documento_pagado_bancaj(181456,'S','P')
