
--**** conteo de docuemntos pendientes de pago
select  distinct c.ingr_ncorr
 		  from     
	  compromisos a     
	  join detalle_compromisos b     
		on a.tcom_ccod = b.tcom_ccod        
			and a.inst_ccod = b.inst_ccod        
			and a.comp_ndocto = b.comp_ndocto 
            and a.ecom_ccod = '1'
	join detalle_ingresos c    
	        on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = 4
            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto
            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr
            and c.ting_ccod =4 
            and c.edin_ccod not in (6,11)    
        join ingresos e
                on c.ingr_ncorr=e.ingr_ncorr
                and e.eing_ccod not in (3,6)           
	join personas alu
                on e.pers_ncorr=alu.pers_ncorr
        join personas apo
                on c.pers_ncorr_codeudor=apo.pers_ncorr
        left outer join direcciones dir
                on apo.pers_ncorr=dir.pers_ncorr        
        left outer join ciudades ciu
                on dir.ciud_ccod = ciu.ciud_ccod 
        where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) = 0
	--and dir.tdir_ccod=1	


select * from detalle_ingresos where ding_ndocto in (264466)