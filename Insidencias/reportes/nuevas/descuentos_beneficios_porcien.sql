 select sum(bene_mmonto) as beneficion,convenio, count(pers_ncorr) from (
 Select pers_ncorr,peri_ccod,cont_ncorr, stde_ccod as tdet_ccod, stde_tdesc as convenio, cast(bene_mmonto as integer)as bene_mmonto ,mone_ccod,bene_nporcentaje_matricula,bene_nporcentaje_colegiatura,tben_ccod,max(bene_fbeneficio) as bene_fbeneficio 
								 From ( 
								 select a.pers_ncorr,b.peri_ccod,b.cont_ncorr, e.stde_ccod, e.stde_tdesc, 
								        isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto, 
								        c.mone_ccod, c.bene_nporcentaje_matricula, c.bene_nporcentaje_colegiatura, e.tben_ccod, c.bene_fbeneficio  
								            from postulantes a, contratos b, beneficios c, stipos_descuentos e, ofertas_academicas f ,especialidades g,carreras h 
								            where a.post_ncorr = b.post_ncorr  
								              and b.cont_ncorr = c.cont_ncorr  
								              and c.stde_ccod = e.stde_ccod  
                                              and a.ofer_ncorr=f.ofer_ncorr
                                              and f.espe_ccod = g.espe_ccod   
											  and g.carr_ccod = h.carr_ccod
								              and e.tben_ccod <> 1  
								              and b.econ_ccod = '1'  
								              and c.eben_ccod = '1'  
								              and b.econ_ccod <> 3  
                                              --and e.stde_ccod= '1265'
								             -- and cast(a.pers_ncorr as varchar) = ' & v_pers_ncorr & ' 			
								union  
									select d.pers_ncorr,k.peri_ccod, k.cont_ncorr, a.stde_ccod, b.stde_tdesc,  
										cast(isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as int) as bene_mmonto,  
											1 as mone_ccod,a.sdes_nporc_matricula as bene_nporcentaje_matricula,a.sdes_nporc_colegiatura as bene_nporcentaje_colegiatura,  
										i.tben_ccod, cont_fcontrato as bene_fbeneficio  
										from sdescuentos a,stipos_descuentos b,sestados_descuentos c,  
											  postulantes d,ofertas_academicas e,personas_postulante f,  
											  especialidades g,carreras h,tipos_beneficios i,sedes j, contratos k  
										where a.stde_ccod = b.stde_ccod  
											and a.esde_ccod = c.esde_ccod   
											and a.post_ncorr = d.post_ncorr   
											and a.ofer_ncorr = d.ofer_ncorr  
											and d.ofer_ncorr = e.ofer_ncorr   
											and d.pers_ncorr = f.pers_ncorr  
											and e.espe_ccod = g.espe_ccod   
											and g.carr_ccod = h.carr_ccod  
											and e.sede_ccod = j.sede_ccod    
											and b.tben_ccod = i.tben_ccod   
											and d.post_ncorr=k.post_ncorr  
											and k.econ_ccod <> 3 
                                            --and a.stde_ccod= '1265'
											--and cast(f.pers_ncorr as varchar) =' & v_pers_ncorr & ' 													
								 ) as tabla   
 								 group by pers_ncorr,peri_ccod,cont_ncorr, stde_ccod, stde_tdesc, bene_mmonto,mone_ccod,bene_nporcentaje_matricula,bene_nporcentaje_colegiatura,tben_ccod
                                 
) a

group by  convenio                               