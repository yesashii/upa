Select g.ingr_nfolio_referencia as comprobante,cast(sum(ingr_mtotal) as numeric) as monto,protic.trunc(max(g.ingr_fpago)) as fecha_inscrito, 
				 d.tdet_tdesc, protic.obtener_nombre(b.pers_ncorr,'n') nombre_persona, 
				 protic.obtener_rut(b.pers_ncorr) as rut, isnull(e.pers_tfono,'s/n') as telefono ,
				 protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB') as direccion 
				    From compromisos a 
				    join detalle_compromisos b     
						on a.tcom_ccod = b.tcom_ccod        
						and a.inst_ccod = b.inst_ccod        
						and a.comp_ndocto = b.comp_ndocto 
				        and a.ecom_ccod = '1' 
				     join detalles c 
				        on c.tcom_ccod = b.tcom_ccod   
						and c.inst_ccod = b.inst_ccod    
						and c.comp_ndocto = b.comp_ndocto 
				    	and c.tdet_ccod not in (909)  
				     join tipos_detalle d 
				        on c.tdet_ccod=d.tdet_ccod 
						 and tdet_bvigente in ('S','N')
				     join personas e 
				        on b.pers_ncorr=e.pers_ncorr 
				     join abonos f 
				        on b.tcom_ccod = f.tcom_ccod   
						 and b.inst_ccod = f.inst_ccod    
						 and b.comp_ndocto = f.comp_ndocto 
				        and b.dcom_ncompromiso = f.dcom_ncompromiso 
				     join ingresos g 
				        on f.ingr_ncorr=g.ingr_ncorr 
				        and ting_ccod=33 
				 Where a.tcom_ccod=7    
				 Group by g.ingr_nfolio_referencia,b.pers_ncorr,c.tdet_ccod,d.tdet_tdesc,e.pers_tfono
                 having cast(sum(ingr_mtotal) as numeric) >1