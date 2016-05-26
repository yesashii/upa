  select protic.obtener_rut(a.pers_ncorr), protic.obtener_nombre_carrera(
(select top 1 c.ofer_ncorr
from compromisos com, contratos b, postulantes c 
where com.tcom_ccod=2
and com.comp_ndocto=b.cont_ncorr
and b.post_ncorr=c.post_ncorr
and c.peri_ccod=214
and com.ecom_ccod=1
and com.pers_ncorr=a.pers_ncorr),'CJ') as carrera,
  (select distinct top 1 com.comp_mdocumento 
from compromisos com, contratos b, postulantes c 
where com.tcom_ccod=2
and com.comp_ndocto=b.cont_ncorr
and b.post_ncorr=c.post_ncorr
and c.peri_ccod=214
and com.ecom_ccod=1
and com.pers_ncorr=a.pers_ncorr) as monto_arancel,
            cast(isnull(f.fint_nfactor_anual/(12*100),0) as decimal(5,4) ) as factor_interes,    
						  case when datediff(day,b.dcom_fcompromiso, getdate())>5 then datediff(day,b.dcom_fcompromiso, getdate()) else 0 end as dias_mora,    
						  ROUND((cast(isnull(f.fint_nfactor_anual,0)/(12*100) as decimal(5,4))*protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso)*case when datediff(day,b.dcom_fcompromiso, getdate())>5 then datediff(day,b.dcom_fcompromiso, getdate())else 0 end)/30,0) as interes,   
						  protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)+ ROUND((cast(isnull(f.fint_nfactor_anual,0)/(12*100) as decimal(5,4))*protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso)*case when datediff(day,b.dcom_fcompromiso, getdate())>5 then datediff(day,b.dcom_fcompromiso, getdate())else 0 end)/30,0) as a_pagar,   
						      case    
						    when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35   
						 		then    
						        (Select a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod    
						         and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod)    
						  	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ')   
						    else    
						         (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)    
						     end as tcom_tdesc,    
						 			b.comp_ndocto as c_comp_ndocto, cast(b.dcom_ncompromiso as varchar) + ' / '+ cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso,   
						 			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,     
						 			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,     
						 			protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) + protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)as abonos,   
						 			protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,   
						 		    d.edin_tdesc    
						 	 from   
						 		compromisos a   
						 		join detalle_compromisos b   
						 			on a.tcom_ccod = b.tcom_ccod      
						 			and a.inst_ccod = b.inst_ccod      
						 			and a.comp_ndocto = b.comp_ndocto   
						 		left outer join detalle_ingresos c   
						 			on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod     
						 			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto    
						 			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr      
						 		left join estados_detalle_ingresos d     
						 			on c.edin_ccod = d.edin_ccod   
						  		left outer join rango_factor_interes h     
						 			on datediff(day,b.dcom_fcompromiso, getdate()) between rafi_ndias_minimo and rafi_ndias_maximo      
						 			and floor(b.dcom_mcompromiso/protic.valor_uf()) between rafi_mufes_min and rafi_mufes_max     
						 		left outer join factor_interes f     
						 			on f.rafi_ccod=h.rafi_ccod     
						 			and f.anos_ccod=datepart(year, getdate())     
						 			and f.efin_ccod=1   
						 	 where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0    
						 	   --and isnull(d.udoc_ccod, 1) = 1    
						 	   and ( (c.ting_ccod is null) or    
						 			 (c.ting_ccod = 4 and d.edin_ccod not in (6) ) or    
						 			 (c.ting_ccod = 5 and d.edin_ccod not in (6) ) or    
						 			  (c.ting_ccod in (2, 50)) or    
						 			  (c.ting_ccod in (3,38) and d.edin_ccod not in (6, 12, 51)) or    
						     		  (c.ting_ccod = 52 and d.edin_ccod not in (6) ) or   
						     		  (c.ting_ccod = 87 and d.edin_ccod not in (6) ) or   
						     		  (c.ting_ccod = 88 and d.edin_ccod not in (6) )   
						 			)    
						 	   and a.ecom_ccod = '1'    
						 	   and b.ecom_ccod = '1'    
						   	and cast(a.pers_ncorr  as varchar)= '19164'  
						    and datediff(day,b.dcom_fcompromiso, getdate())>1   
						 	order by b.dcom_fcompromiso asc, b.dcom_ncompromiso asc, b.tcom_ccod asc  