 select mes_tdesc,sum(cheques) as cheques, sum(letras) as letras, sum(efectivo) as efectivo, 
 sum(credito) as credito, sum(debito) as debito, sum(vale_vista) as vale_vista 
 from (
 select datepart(month,b.mcaj_finicio) as mes,isnull(max(cheque),0) as cheques,isnull(max(letra),0) as letras,     
				  isnull(max(efectivo),0) as efectivo,isnull(max(credito),0) as credito,    
				  isnull(max(vale_vista),0) as vale_vista,isnull(max(debito),0) as debito,    
				  isnull(max(pagare),0) as pagare,     
				  (isnull(max(cheque),0) + isnull(max(letra),0) + isnull(max(efectivo),0) + isnull(max(credito),0) +    
				  isnull(max(vale_vista),0) +isnull(max(debito),0) + isnull(max(pagare),0) ) as total   
				  from (     
				      select mcaj_ncorr,case ting_ccod when 3 then cast(sum(monto_recaudado) as numeric) end as cheque,     
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
				          where a.mcaj_ncorr in (select mcaj_ncorr from movimientos_cajas where datepart(year,mcaj_finicio)='2006'   )     
				          and  a.ting_ccod  in (7,15,16,33,34,88)
                          and a.pers_ncorr=103688        
				      ) as tabla     
				      group by mcaj_ncorr,ting_ccod     
				  ) a     
				  join movimientos_cajas b     
				      on a.mcaj_ncorr=b.mcaj_ncorr   
				  	  and b.tcaj_ccod in (1000)     
				  group by b.mcaj_finicio
    ) as tabla 
join meses
    on mes_ccod=mes   
group by mes_tdesc              
            