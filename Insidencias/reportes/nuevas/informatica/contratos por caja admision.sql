  Select isnull(a.mcaj_ncorr,0) as mcaj_ncorr,d.econ_ccod,d.contrato as n_contrato,g.sede_tdesc,   
			  protic.obtener_nombre_carrera(f.ofer_ncorr,'C') as carrera,h.jorn_tdesc,i.econ_tdesc,   
			  protic.obtener_nombre_completo(e.pers_ncorr,'n') as alumno, protic.trunc(d.cont_fcontrato) as fecha,   
			  protic.obtener_nombre(k.pers_ncorr,'c') as cajero,   
			  Case e.post_bnuevo when 'S' then 'Nuevo' when 'N' then 'Antiguo' end as tipo_alumno,   
		      case cast(isnull(m.sdes_nporc_colegiatura,999) as numeric)     
		      when 0 then 'Completo'   
		      when 50 then 'Medio'   
		      when 100 then 'Matricula'    
		      when 999 then 'Completo'    
		      end as tipo_contrato   
			  From    
			  ingresos a    
			  join abonos b    
			      on a.ingr_ncorr=b.ingr_ncorr   
			  join compromisos c   
			      on b.comp_ndocto=c.comp_ndocto   
			      and b.tcom_ccod=c.tcom_ccod   
			      and b.inst_ccod=c.inst_ccod   
			  	  and c.tcom_ccod in (1,2)   
			  join contratos d   
			      on c.comp_ndocto=d.cont_ncorr   
			  join postulantes e   
			      on d.post_ncorr=e.post_ncorr   
			  join ofertas_academicas f   
			      on e.ofer_ncorr=f.ofer_ncorr      
			  join sedes g   
			      on f.sede_ccod=g.sede_ccod           
			  join jornadas h   
			      on f.jorn_ccod=h.jorn_ccod     
			  join estados_contrato i   
			      on d.econ_ccod=i.econ_ccod     
			  left outer join movimientos_cajas j   
			     on a.mcaj_ncorr=j.mcaj_ncorr   
			  left outer join cajeros k   
			     on j.caje_ccod=k.caje_ccod   
			   left outer join sdescuentos m   
			 	on e.post_ncorr=m.post_ncorr   
			 	and e.ofer_ncorr=m.ofer_ncorr   
			    and m.stde_ccod=1262   
			  where a.ting_ccod=7   
			  and d.econ_ccod not in (2,3)
              -- calculo hasta igual fecha año 2005
              and cast(d.peri_ccod as varchar)='202' -- admision 2006  
			  and  protic.trunc(convert(datetime,j.mcaj_finicio,103))<=convert(datetime,'18/12/2005',103)
			  group by m.sdes_nporc_colegiatura,e.post_bnuevo,k.pers_ncorr,d.cont_fcontrato,i.econ_tdesc,a.mcaj_ncorr,d.econ_ccod,d.cont_ncorr,d.contrato,g.sede_tdesc,h.jorn_tdesc,protic.obtener_nombre_carrera(f.ofer_ncorr,'C'),protic.obtener_nombre_completo(e.pers_ncorr,'n') 
