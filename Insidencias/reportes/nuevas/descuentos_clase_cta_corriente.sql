 select a.*,
     protic.obtener_nombre(b.pers_ncorr,'n') as nombre_alumno,protic.obtener_rut(b.pers_ncorr) as rut_alumno,
    isnull(protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB'),protic.obtener_direccion_letra(b.pers_ncorr,2,'CNPB')) direccion_alumno, b.pers_tfono as telefono
    ,m.carr_tdesc as carrera, k.espe_tdesc as especialidad, case j.jorn_ccod   when 1 then 'Diurno' when 2 then 'Vespertino' end as jornada,
    protic.ano_ingreso_carrera(b.pers_ncorr,m.carr_ccod) as ano_carrera,
     protic.obtener_nombre(o.pers_ncorr,'n') as nombre_apoderado,protic.obtener_rut(o.pers_ncorr) as rut_apoderado,
    isnull(protic.obtener_direccion_letra(o.pers_ncorr,1,'CNPB'),protic.obtener_direccion_letra(o.pers_ncorr,2,'CNPB')) direccion_apoderado, o.pers_tfono as telefono_apo,
    c.emat_tdesc,i.peri_ccod
 from 
( 	  Select ofer_ncorr,post_ncorr,cont_ncorr, stde_ccod , stde_tdesc as tipo_descuento, cast(bene_mmonto as numeric) as total_descontado,
      cast(monto_matricula as numeric) as descuento_matricula,bene_nporcentaje_matricula,cast(monto_arancel as numeric) as descuento_arancel,bene_nporcentaje_colegiatura,
      tben_ccod,protic.trunc(max(bene_fbeneficio)) as bene_fbeneficio   
			  From (   
			  select a.ofer_ncorr,a.post_ncorr,b.peri_ccod,b.cont_ncorr, e.stde_ccod, e.stde_tdesc,   
					 isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto,   
					 isnull(c.bene_mmonto_matricula, 0) as monto_matricula, isnull(c.bene_mmonto_colegiatura, 0) as monto_arancel, 
                     c.mone_ccod, c.bene_nporcentaje_matricula, c.bene_nporcentaje_colegiatura, e.tben_ccod, c.bene_fbeneficio    
						 from postulantes a, contratos b, beneficios c, stipos_descuentos e    
						 where a.post_ncorr = b.post_ncorr    
						   and b.cont_ncorr = c.cont_ncorr    
						   and c.stde_ccod = e.stde_ccod    
						   and e.tben_ccod <> 1    
						   and b.econ_ccod = '1'    
						   and c.eben_ccod = '1'    
						   and b.econ_ccod <> 3    
						  -- and cast(a.pers_ncorr as varchar) in (27757,23366,100626,12397)  			
			 union    
				select d.ofer_ncorr,d.post_ncorr,k.peri_ccod, k.cont_ncorr, a.stde_ccod, b.stde_tdesc,    
					cast(isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as int) as bene_mmonto,
                    cast(isnull(a.sdes_mmatricula, 0)as int) as monto_matricula, cast(isnull(a.sdes_mcolegiatura, 0) as int) as monto_arancel,    
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
						--and cast(f.pers_ncorr as varchar) in (27757,23366,100626,12397)													
			  ) as tabla   --&v_sql_credito& 
 			  group by ofer_ncorr,post_ncorr,cont_ncorr, stde_ccod, stde_tdesc, bene_mmonto,bene_nporcentaje_matricula,bene_nporcentaje_colegiatura,tben_ccod,monto_matricula,monto_arancel 
) a
join postulantes i
        on a.post_ncorr=i.post_ncorr
     join ofertas_academicas j
       on i.ofer_ncorr=j.ofer_ncorr
       --and a.ofer_ncorr=j.ofer_ncorr
     join especialidades k
        on j.espe_ccod=k.espe_ccod
     join carreras m
        on k.carr_ccod=m.carr_ccod 
     join codeudor_postulacion n
        on i.post_ncorr=n.post_ncorr
     left outer join personas_postulante o --codeudor
        on n.pers_ncorr=o.pers_ncorr
    join personas_postulante b
        on i.pers_ncorr=b.pers_ncorr 
    join alumnos h
        on b.pers_ncorr=h.pers_ncorr
        and a.post_ncorr=h.post_ncorr
        and h.emat_ccod not in (9)
    join estados_matriculas c
        on h.emat_ccod=c.emat_ccod                      
where convert(datetime,a.bene_fbeneficio,103)>='01/09/2004'
and i.peri_ccod in (164,200)