select rut,nombre,facu_ccod,jorn_ccod,sede_ccod, carr_ccod,facultad,centro_costo,fecha_pago,
        cast(carrera+ case jorn_ccod when 1 then '- (D)' else '- (V)' end as varchar(150)) as carrera, 
		cast(isnull(max(total_matricula),0) as numeric) as total_matricula,cast(isnull(max(total_arancel),0) as numeric) as arancel,
        cast(isnull(max(total_titulacion),0) as numeric) as titulacion,cast(isnull(max(conoc_relevantes),0) as numeric) as conoc_relevantes,
        cast(isnull(max(convalidaciones),0) as numeric) as convalidaciones
from (                 
	  select rut,nombre,d.facu_ccod,d.facu_tdesc as facultad ,b.carr_tdesc as carrera, a.carr_ccod,a.tipo_ingreso,
      a.jorn_ccod,a.sede_ccod,ccos_tcompuesto as  centro_costo, fecha_pago,   
		  case tipo_ingreso when 1 then sum(monto_recaudado) end as total_matricula,
          case tipo_ingreso when 2 then sum(monto_recaudado) end as total_arancel,    
		  case tipo_ingreso when 3 then sum(monto_recaudado) end as total_titulacion,
          case tipo_ingreso when 4 then sum(monto_recaudado) end as conoc_relevantes, 
          case tipo_ingreso when 5 then sum(monto_recaudado) end as convalidaciones   
			   from (         
				select  protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,
                protic.obtener_carrera_ingreso(a.mcaj_ncorr,a.ting_ccod,ingr_nfolio_referencia,a.pers_ncorr)  as carr_ccod,    
				case tcom_ccod when 1 then 1 else 2 end as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,     
				case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6     
					else b.ting_ccod end as ting_ccod,        
				case when b.ting_ccod is null and a.ingr_mefectivo is not null then d.abon_mabono     
				   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado,    
					g.jorn_ccod,g.sede_ccod, protic.trunc(a.ingr_fpago) as fecha_pago        
				From ingresos a          
				left outer join detalle_ingresos b        
				  on a.ingr_ncorr=b.ingr_ncorr    
				  and b.ting_ccod in (3,4,6,13,14,51,52)        
				left outer join tipos_ingresos c          
				  on b.ting_ccod=c.ting_ccod         
				join abonos d    
				  on a.ingr_ncorr=d.ingr_ncorr    
				  and d.tcom_ccod in (1,2)    
				join contratos e    
					on d.comp_ndocto=e.cont_ncorr     
					and e.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod ='2008')    
				join alumnos f    
					on e.matr_ncorr=f.matr_ncorr    
				join ofertas_academicas g    
					on f.ofer_ncorr=g.ofer_ncorr    
				 where a.ting_ccod  in (7)         
					  and a.eing_ccod not in (3,6)    
					  and e.econ_ccod not in (3)    
					  --and g.sede_ccod in ('8')       
			   UNION	     
				-- Titulaciones pagadas directamente      
				select  protic.obtener_rut(f.pers_ncorr) as rut,protic.obtener_nombre_completo(f.pers_ncorr,'n') as nombre,
                protic.obtener_carrera_cargo(f.post_ncorr) as carr_ccod,    
				j.tipo_ingreso,j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,     
				j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod, fecha_pago     
			   from (    
				 select a.pers_ncorr,case e.tdet_ccod when 1233 then 4 when 1231 then 5 else 3 end as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,      
				 case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6      
				   else b.ting_ccod end as ting_ccod,     
				 case when b.ting_ccod is null and a.ingr_mefectivo is not null then d.abon_mabono      
				   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado,    
				 protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr,protic.trunc(a.ingr_fpago) as fecha_pago     
				 from ingresos a       
				 left outer join detalle_ingresos b      
				  on a.ingr_ncorr=b.ingr_ncorr       
				  and  b.ting_ccod in (3,4,6,13,14,51,52)       
				 left outer join tipos_ingresos c       
				  on b.ting_ccod=c.ting_ccod      
				 join abonos d      
					on a.ingr_ncorr=d.ingr_ncorr      
					and d.tcom_ccod in (25,4)      
				 join detalles e      
					on d.comp_ndocto=e.comp_ndocto      
					and d.tcom_ccod=e.tcom_ccod      
					and e.tdet_ccod in (1230,1233,1231)    
				where a.ting_ccod  in (34)         
				   and a.eing_ccod not in (3,6)      
				  and convert(datetime,a.ingr_fpago,103) between convert(datetime,'26/11/2007',103) and convert(datetime,'26/11/2008',103)     
				 ) j    
				 join alumnos f     
					on j.pers_ncorr =f.pers_ncorr    
					and f.post_ncorr=j.post_ncorr    
					and f.emat_ccod not in (9)    
				 join ofertas_academicas g    
					on f.ofer_ncorr=g.ofer_ncorr     
					--and g.sede_ccod='1'	      
			   UNION      
				 -- Titulaciones repactadas      
				select  protic.obtener_rut(f.pers_ncorr) as rut,protic.obtener_nombre_completo(f.pers_ncorr,'n') as nombre,
                protic.obtener_carrera_cargo(f.post_ncorr) as carr_ccod,    
					  j.tipo_ingreso,j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,     
					  j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod,fecha_pago    
			   from (    
				 Select a.pers_ncorr,3 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,      
				 case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6      
				   else b.ting_ccod end as ting_ccod,         
				 case when b.ting_ccod is null and a.ingr_mefectivo is not null then d.abon_mabono      
				   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado,    
				   protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr,protic.trunc(a.ingr_fpago) as fecha_pago     
				  From ingresos a      
					  left outer join detalle_ingresos b      
						  on a.ingr_ncorr=b.ingr_ncorr        
						  and  b.ting_ccod in (3,4,6,13,14,51,52)    
					  left outer join tipos_ingresos c      
						  on b.ting_ccod=c.ting_ccod      
					  join abonos d      
						  	on a.ingr_ncorr=d.ingr_ncorr      
						  	and d.tcom_ccod=3      
					  join compromisos e      
						  	on d.comp_ndocto=e.comp_ndocto      
						  	and d.tcom_ccod=e.tcom_ccod      
					  Where a.eing_ccod not in (5,3,6)     
						  	and a.ting_ccod=15     
						  	and a.ingr_nfolio_referencia in (     
						  				select a.ingr_nfolio_referencia      
						  				 from ingresos a, detalle_ingresos b, abonos c      
						  				 where a.ingr_ncorr=b.ingr_ncorr      
						  					and a.ingr_ncorr=c.ingr_ncorr      
						  					and c.tcom_ccod=4      
						  					and a.ting_ccod=9      
						  					and b.ting_ccod=9     
						  					and a.eing_ccod=5     
						  				)     
					and convert(datetime,a.ingr_fpago,103) between convert(datetime,'26/11/2007',103) and convert(datetime,'26/11/2008',103)     						
				) j    
				 join alumnos f    
					on j.pers_ncorr =f.pers_ncorr    
					and f.post_ncorr=j.post_ncorr    
					and f.emat_ccod not in (9)    
				 join ofertas_academicas g    
					on f.ofer_ncorr=g.ofer_ncorr     
					---and g.sede_ccod='1'	      
			  ) as a, carreras b, areas_academicas c,facultades d,centros_costos_asignados cc,centros_costo ck      
			  where  cast(a.carr_ccod as varchar)= cast(b.carr_ccod as varchar)    
			  and b.area_ccod=c.area_ccod    
			  and c.facu_ccod=d.facu_ccod
              and a.sede_ccod=cc.cenc_ccod_sede
              and a.jorn_ccod=cc.cenc_ccod_jornada
              and a.carr_ccod=cc.cenc_ccod_carrera
              and cc.ccos_ccod=ck.ccos_ccod     
			  group by fecha_pago,rut,nombre,a.carr_ccod,a.tipo_ingreso,b.carr_tdesc,d.facu_tdesc,d.facu_ccod,a.jorn_ccod,a.sede_ccod,ccos_tcompuesto    
 ) as tabla_final  
group by rut,nombre,facu_ccod,facultad,carrera,carr_ccod,jorn_ccod,sede_ccod,centro_costo,fecha_pago                