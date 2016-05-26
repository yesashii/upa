     select a.pers_ncorr, f.carr_tdesc as carrera,h.sede_tdesc as sede,i.jorn_tdesc as jornada, c.peri_ccod, cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut,     
			    pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre as nombre,     
			    pers_fnacimiento,protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) as nuevo,     
			    isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr, (select protic.obtener_nombre_carrera((select top 1 ofer_ncorr      
	   		    From alumnos where matr_ncorr=d.matr_ncorr order by matr_ncorr desc),'CC'))) ,       
                protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso     
			  from personas a, ofertas_academicas c, alumnos d,especialidades e, carreras f, postulantes g, sedes h, jornadas i      
			  where a.pers_ncorr = d.pers_ncorr      
			    and c.ofer_ncorr= d.ofer_ncorr      
			    and c.espe_ccod = e.espe_ccod
                and e.carr_ccod=f.carr_ccod 
                and c.sede_ccod=h.sede_ccod
                and c.jorn_ccod=i.jorn_ccod   
			    and d.emat_ccod in (1,4,8,2,15,16)  
                and d.audi_tusuario not like '%ajunte matricula%'
                and g.audi_tusuario not like '%CREAR_MATRICULA_SEG_SEMESTRE_M%'
                and d.post_ncorr=g.post_ncorr     
	            and protic.afecta_estadistica(d.matr_ncorr) > 0      
			 	and c.peri_ccod=210--protic.retorna_max_periodo_matricula(a.pers_ncorr,'  & periodo &  ',e.carr_ccod)     
			    and isnull(d.alum_nmatricula,0) not in (7777)  
                and not exists (select 1 from postulantes po, alumnos al where po.pers_ncorr=al.pers_ncorr and po.post_ncorr=al.post_ncorr and po.pers_ncorr=d.pers_ncorr and po.peri_ccod=210 and po.post_bnuevo='S')
			 	and d.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',     
			                    'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',      
			                    'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',      
			                    'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',      
			                    'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2',      
			                    'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2')      
			  group by a.pers_ncorr,e.carr_ccod, f.carr_tdesc,h.sede_tdesc,i.jorn_tdesc, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, pers_tape_materno,pers_fnacimiento,d.matr_ncorr, d.post_ncorr   
               having (select isnull(post_bnuevo,'N') from postulantes where post_ncorr=d.post_ncorr) = 'S'  order by nombre asc