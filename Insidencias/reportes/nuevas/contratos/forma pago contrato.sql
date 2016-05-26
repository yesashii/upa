select 	       tcps.tcom_tdesc tipo_documento,isnull (tii.ting_tdesc,'EFECTIVO') documento,  
			       bn.banc_tdesc nombre_banco,dc.dcom_mcompromiso valor_docto, dc.dcom_ncompromiso nro_docto, 
			       convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento, 
			       case cps.tcom_ccod when '1' then cast(cps.comp_mdocumento as numeric) end as total_m , 
			       case cps.tcom_ccod when '2' then cast(cps.comp_mdocumento as numeric) end as total_a
From	    postulantes p 
                join contratos cc 
                    on cc.post_ncorr=p.post_ncorr  
			     join compromisos cps  
                    on cc.cont_ncorr=cps.comp_ndocto  
			     join detalle_compromisos dc 
                    on cps.comp_ndocto=dc.comp_ndocto  
			        and cps.inst_ccod=dc.inst_ccod  
			        and cps.tcom_ccod=dc.tcom_ccod   
			     left outer join detalle_ingresos dii 
                    on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod')   = dii.ting_ccod  
			        and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = dii.ingr_ncorr  
			        and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto')= dii.ding_ndocto    
			     left outer join ingresos ii 
                    on dii.ingr_ncorr = ii.ingr_ncorr
                 left outer join tipos_ingresos tii 
                    on dii.ting_ccod =tii.ting_ccod 
			     left outer join bancos bn 
                    on dii.banc_ccod = bn.banc_ccod  
			     join tipos_compromisos tcps 
                    on  cps.tcom_ccod=tcps.tcom_ccod
			where p.post_ncorr= isnull(172446,p.post_ncorr)  
			  and cps.ecom_ccod <> 3  
			  and cc.econ_ccod in (1, 2)  
  			  and cps.tcom_ccod in (1, 2)  
			  and dc.tcom_ccod in (1,2)  
			  and isnull(dii.ting_ccod, 0) in (0, 3, 4, 52,13,51,59)
