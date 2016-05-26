 select *
			 from 
			 ( 
			 select distinct a.pers_ncorr,cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut,isnull(lower(a.pers_temail),'No ingresado') as email, a.pers_tfono as fono,a.pers_tcelular as celular,  
			   a.pers_tape_paterno  as AP_Paterno, a.pers_tape_materno  as AP_Materno, a.pers_tnombre as nombre,protic.trunc(a.pers_fnacimiento) as fecha_nacimiento,  
			   case a.sexo_ccod when 1 then 'Masculino' when 2  then 'Femenino' else 'Sin Seleccionar' end as sexo,   
			   pai.pais_tdesc as pais,facu.facu_ccod,facu.facu_tdesc as facultad,h.sede_ccod,h.sede_tdesc as sede,e.carr_ccod ,f.carr_tdesc as Carrera,g.jorn_ccod, g.jorn_tdesc as jornada , 
			   case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo,  
			   protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso,
			   (select emat_tdesc from estados_matriculas emat  
			   where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc))  
			   as estado_academico,protic.trunc(cont.cont_fcontrato) as fecha_matricula,protic.trunc(d.audi_fmodificacion) as fecha_modificacion 
			   from personas_postulante a join alumnos d  
			        on a.pers_ncorr = d.pers_ncorr   
			   join ofertas_academicas c  
			        on c.ofer_ncorr = d.ofer_ncorr    
			   join periodos_academicos pea  
			        on c.peri_ccod = pea.peri_ccod and pea.anos_ccod in ('2006','2007','2008','2009','2010')
			   join postulantes pos 
			        on pos.post_ncorr = d.post_ncorr 
			    join paises pai 
			        on pai.pais_ccod = isnull(a.pais_ccod,0)  
			    join especialidades e  
			        on c.espe_ccod  = e.espe_ccod 
			    join carreras f  
			        on e.carr_ccod=f.carr_ccod --and f.carr_ccod in ('850')
			    join areas_academicas aca 
			        on f.area_ccod = aca.area_ccod 
			    join facultades facu 
			        on aca.facu_ccod=facu.facu_ccod       
			    join jornadas g  
			        on c.jorn_ccod=g.jorn_ccod  
			    join sedes h  
			       on c.sede_ccod=h.sede_ccod  --and h.sede_ccod = '4'
			    join contratos cont 
			        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr  
			 where cont.econ_ccod = 1  
			 and d.emat_ccod not in (9) 
			 and exists (select 1 from contratos cont1, compromisos comp1 where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) )   
             --and exists (select 1 from sdescuentos where stde_ccod=1402 and post_ncorr=d.post_ncorr )
			 group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno, 
			         a.pers_tape_materno,a.pers_fnacimiento,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc, 
			         pai.pais_tdesc,e.espe_tdesc,a.sexo_ccod,cont.cont_fcontrato, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod,
					 a.pers_temail,facu.facu_ccod,facu_tdesc, h.sede_ccod, g.jorn_ccod, a.pers_tfono,a.pers_tcelular 
			 )tabla_final 
			 --where estado_academico = 'Activa' 
            -- and tipo = "NUEVO"
		 order by sede,carrera,AP_Paterno,AP_Materno,Nombre