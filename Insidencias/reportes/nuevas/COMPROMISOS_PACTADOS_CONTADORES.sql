--***************   detalle compromisos pactados    *********************** 
 select  b.inst_ccod, b.comp_ndocto,b.tcom_ccod,b.dcom_ncompromiso, case when b.tcom_ccod in (1,2) then cast(b.comp_ndocto as varchar)+ ' ('+protic.numero_contrato(b.comp_ndocto)+')'else cast(b.comp_ndocto as varchar) end as ncompromiso,    
		case    
			when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35 or b.tcom_ccod=15    
        		then    
				(Select a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod    
				 and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod)    
			when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ')   
			else    
				 (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)    
			 end as tcom_tdesc,    
			 cast(b.dcom_ncompromiso as varchar) + '/' + cast(a.comp_ncuotas as varchar)  as ncuota,   
			 a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso,   
			 protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,   
			 case    
			 when a.tcom_ccod=2 and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')=52   
				 then    
				   (select pag.PAGA_NCORR from  pagares pag 	where  pag.cont_ncorr =a.comp_ndocto)   
				 else   
					 protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto')   
				 end as ding_ndocto,   
			 protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos,    
			 protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado,   
			 isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,    
		 (select d.edin_tdesc+protic.obtener_institucion(c.ingr_ncorr) from estados_detalle_ingresos d   
			 where c.edin_ccod = d.edin_ccod) as edin_tdesc    
		  from compromisos a,detalle_compromisos b,detalle_ingresos c   
		  where a.tcom_ccod = b.tcom_ccod   
			 and a.inst_ccod = b.inst_ccod    
			 and a.comp_ndocto = b.comp_ndocto   
			 and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') *= c.ting_ccod   
			 and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto   
			 and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') *= c.ingr_ncorr   
			 and a.ecom_ccod = '1'  
			 and b.ecom_ccod <> '3'    
			 and cast(a.pers_ncorr as varchar) ='11470'   
			 order by b.dcom_fcompromiso desc 


--**************    detalle del pago de un compromiso   ******************
pers_ncorr, compromiso,cuota,fecha_emision,fecha_vencimiento,documento,
numero_docto, monto, abono, abono_documentado, saldo_final
            
select c.ding_bpacta_cuota,b.ingr_ncorr,protic.obtener_rut(b.pers_ncorr) as rut,b.pers_ncorr,isnull(c.ding_bpacta_cuota,'NO') as compromiso,'' as cuota, b.ingr_fpago as fecha_emision,c.ding_fdocto as fecha_vencimiento, 
c.ting_ccod as documento,c.ding_ndocto as numero_docto,c.ding_mdocto as monto,'' as abono,
cast(case d.ting_brebaje when 'S' then -a.abon_mabono else  a.abon_mabono end as numeric) as abono_documentado,
'' as saldo_final,
 (select ofer_ncorr from alumnos where post_ncorr=protic.obtener_post_ncorr (a.pers_ncorr, a.comp_ndocto,c.ingr_ncorr)) as oferta	  
         
 from abonos a,ingresos b,detalle_ingresos c,tipos_ingresos d 
 where a.ingr_ncorr = b.ingr_ncorr 
	 and b.ingr_ncorr = c.ingr_ncorr 
	 and b.ting_ccod = d.ting_ccod 
	 and protic.estado_origen_ingreso(a.ingr_ncorr) = 4    
	 and a.tcom_ccod = '2'    
	 and a.inst_ccod = '1'    
	 and a.comp_ndocto = '63784 '    
	 and a.dcom_ncompromiso = '2'  
     and isnull(c.ding_bpacta_cuota,'N')='N'              
    
--*******************************

 select  b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso,b.dcom_fcompromiso,
 a.pers_ncorr,a.comp_fdocto, b.dcom_mcompromiso,c.edin_ccod,
 protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as documento,
 protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as numero_docto,
 protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos,    
 protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado,   
 isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,    
 (select ofer_ncorr from alumnos where post_ncorr=protic.obtener_post_ncorr (a.pers_ncorr, a.comp_ndocto,c.ingr_ncorr)) 	  
      from compromisos a,detalle_compromisos b,detalle_ingresos c   
	  where a.tcom_ccod = b.tcom_ccod   
	     and a.inst_ccod = b.inst_ccod    
	     and a.comp_ndocto = b.comp_ndocto   
	     and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') *= c.ting_ccod   
	     and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto   
	     and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') *= c.ingr_ncorr   
	     and a.ecom_ccod = '1'  
	     and b.ecom_ccod <> '3'    
	     and cast(a.pers_ncorr as varchar) ='11470'   
	     order by b.dcom_fcompromiso desc      