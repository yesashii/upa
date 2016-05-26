 select distinct cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut,isnull(a.pers_temail,'No ingresado') as email,   
		    a.pers_tape_paterno  as AP_Paterno, a.pers_tape_materno  as AP_Materno, a.pers_tnombre as nombre,protic.trunc(a.pers_fnacimiento) as fecha_nacimiento,   
			case a.sexo_ccod when 1 then 'Masculino' when 2  then 'Femenino' else 'Sin Seleccionar' end as sexo,datediff(year,a.pers_fnacimiento,getDate()) as edad,   
			case pos.tpad_ccod when 1 then 'P.A.A' when 2 then 'P.S.U' else '--' end as tipo_prueba,   
			case when  cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) < 475 then 'Ingreso Especial' else cast( isnull(cast(pos.post_npaa_verbal as varchar),'--')as varchar) end as puntaje_verbal,   
			case when  cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) < 475 then 'Ingreso Especial' else cast( isnull(cast(pos.post_npaa_matematicas as varchar),'--') as varchar) end as puntaje_matematicas,   
			case when  cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) < 475 then 'Ingreso Especial' else cast(cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) as varchar) end as promedio_prueba,pos.POST_NANO_PAA as ano_paa,   
		 	cast( isnull(cast(pos.post_npaa_verbal as varchar),'--')as varchar) as puntaje_verbal_real,   
			cast( isnull(cast(pos.post_npaa_matematicas as varchar),'--') as varchar) as puntaje_matematicas_real,   
			cast( cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) as varchar) as promedio_prueba_real,   
            protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB') as dire_particular,  
			(select case count(*) when 0 then 'No' else 'Sí' end from cargas_academicas carg where carg.matr_ncorr=d.matr_ncorr) as con_carga,   
			(select count(*) from cargas_academicas carg where carg.matr_ncorr=d.matr_ncorr) as cant_asignaturas, 
            case protic.es_moroso(a.pers_ncorr,getdate()) when 'N' then 'No' else 'Sí' end as es_moroso,protic.es_moroso_monto(a.pers_ncorr,getdate())as monto_morosidad, 
            isnull(cast(pos.post_nano_paa as varchar),'--') as ano_rindio_prueba,isnull(pos.post_tinstitucion_anterior,'--') as institucion_anterior,   
			pai.pais_tdesc as pais,e.carr_ccod as cod_carrera,f.carr_tdesc as Carrera,e.espe_tdesc as especialidad,pl.plan_tdesc as plan_est,case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo,case talu_ccod when 1 then '' when 2 then 'ALUMNO UPA DE INTERCAMBIO' when 3 then 'ALUMNO EXTRANJERO DE INTERCAMBIO' end  as tipo_intercambio,   
			g.jorn_tdesc as jornada ,h.sede_tdesc as sede,ARA.ARAN_MMATRICULA,ARA.ARAN_MCOLEGIATURA,protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso,isnull(cast(protic.PROMEDIO_MEDIA(a.pers_ncorr) as varchar),'') as promedio_media,   
			i.dire_tfono as telefono_particular,j.ciud_tdesc as comuna_particular,j.ciud_tcomuna as ciudad_particular,reg.regi_tdesc as region_particular,   
			protic.obtener_direccion_letra(a.pers_ncorr,2,'CNPB')  as dire_academica,   
			dire2.dire_tfono as telefono_academica,ciud2.ciud_tdesc as comuna_academica,ciud2.ciud_tcomuna as ciudad_academica,   
			isnull(k.cole_tdesc,a.pers_tcole_egreso) as nombre_colegio, isnull(l.ciud_tdesc,'--') as comuna_colegio, isnull(l.ciud_tcomuna,'--') as ciudad_colegio, isnull(m.tcol_tdesc,'--') as tipo_colegio, a.pers_nano_egr_media as ano_egreso,   
			isnull(case tip_ens.tens_ccod when 4 then a.pers_ttipo_ensenanza else tip_ens.tens_tdesc end,'--') as tipo_ensenanza,   
			(select emat_tdesc from estados_matriculas emat   
    		where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc)) as estado_academico,  
			(select facu_tdesc from areas_academicas ttt, facultades rrr where ttt.area_ccod=f.area_ccod and ttt.facu_ccod=rrr.facu_ccod) as facultad ,  
			protic.trunc(cont.cont_fcontrato) as fecha_matricula,protic.trunc(d.audi_fmodificacion) as fecha_modificacion,  
			(select top 1 isnull(oema_tobservacion,'--')   
		            from alumnos mm,observaciones_estado_matricula om,ofertas_academicas ccc,periodos_academicos ddd, especialidades eee    
		            where mm.matr_ncorr = om.matr_ncorr and mm.ofer_ncorr=ccc.ofer_ncorr   
			        and ccc.peri_ccod=ddd.peri_ccod and mm.emat_ccod <> 1 and mm.pers_ncorr = d.pers_ncorr   
                    and ccc.espe_ccod=eee.espe_ccod and eee.carr_ccod=f.carr_ccod    
                    and ddd.anos_ccod >= pea.anos_ccod and isnull(oema_tobservacion,'')<>''   
                    order by ddd.peri_ccod desc) as observacion,   
		   (select top 1 (select isnull(om2.eoma_tdesc,'--') from estado_observaciones_matriculas om2 where om2.eoma_ccod = isnull(om.eoma_ccod,0))   
		            from alumnos mm,observaciones_estado_matricula om,ofertas_academicas ccc,periodos_academicos ddd, especialidades eee    
		            where mm.matr_ncorr = om.matr_ncorr and mm.ofer_ncorr=ccc.ofer_ncorr   
			        and ccc.peri_ccod=ddd.peri_ccod and mm.emat_ccod <> 1 and mm.pers_ncorr = d.pers_ncorr   
                    and ccc.espe_ccod=eee.espe_ccod and eee.carr_ccod=f.carr_ccod    
                    and ddd.anos_ccod >= pea.anos_ccod and isnull(oema_tobservacion,'')<>''   
                    order by ddd.peri_ccod desc) as condicion,   
			cast(pers2.pers_nrut as varchar)+'-'+pers2.pers_xdv as rut_codeudor, pers2.pers_tnombre + ' ' +pers2.pers_tape_paterno + ' ' + pers2.pers_tape_materno  as codeudor, protic.trunc(pers2.pers_fnacimiento) as fecha_nacimiento_codeudor,   
			protic.obtener_direccion_letra(pers2.pers_ncorr,1,'CNPB')  as direccion_codeudor,protic.obtener_direccion_letra(pers2.pers_ncorr,1,'C-C')  as ciudad_codeudor, max(isnull(pers2.pers_temail,'')) as email_codeudor,  
			(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 1 and isnull(entregado,'N')='S') as Ced_identidad,   
			(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 2 and isnull(entregado,'N')='S') as Lic_Enseñanza_Media,  
			(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 3 and isnull(entregado,'N')='S') as Conc_de_notas_Enseñanza_Media,   
			(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 4 and isnull(entregado,'N')='S') as Puntaje_PSU,   
			(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 6 and isnull(entregado,'N')='S') as Fotografias,	  
			(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 7 and isnull(entregado,'N')='S') as Certificado_Residencia,  
			(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 8 and isnull(entregado,'N')='S') as Seguro_Salud 
			from personas_postulante a join alumnos d  (nolock)   
			     on a.pers_ncorr = d.pers_ncorr    
			 join ofertas_academicas c   
			     on c.ofer_ncorr = d.ofer_ncorr     
			 join ARANCELES ARA   
			     on ARA.ARAN_NCORR = C.ARAN_NCORR     
			 join periodos_Academicos pea 
                on c.peri_ccod = pea.peri_ccod 
			 left outer join tipos_ensenanza_media tip_ens   
			     on a.tens_ccod = tip_ens.tens_ccod      
			 join postulantes pos  (nolock)   
			     on pos.post_ncorr = d.post_ncorr   
			 join paises pai   
			     on pai.pais_ccod = isnull(a.pais_ccod,0)   
			 left outer join colegios k   
			     on a.cole_ccod = k.cole_ccod     
			 join especialidades e   
			     on c.espe_ccod  = e.espe_ccod   
			 left outer join planes_estudio pl   
			     on d.plan_ccod = pl.plan_ccod   
			 join carreras f   
			     on e.carr_ccod=f.carr_ccod  
                and cast(f.carr_ccod as varchar)='45'
			 join jornadas g   
			     on c.jorn_ccod=g.jorn_ccod   
			 join sedes h   
			     on c.sede_ccod=h.sede_ccod   
			 left outer join direcciones i   
			     on a.pers_ncorr = i.pers_ncorr    
			 left outer join direcciones dire2   
			     on a.pers_ncorr = dire2.pers_ncorr    
                 and 2 = dire2.tdir_ccod   
			 left outer join ciudades j   
			     on i.ciud_ccod = j.ciud_ccod   
			 left outer join regiones reg   
			     on j.regi_ccod = reg.regi_ccod    
			 left outer join ciudades ciud2   
			     on dire2.ciud_ccod = ciud2.ciud_ccod      
			 left outer join ciudades l   
			     on k.ciud_ccod = l.ciud_ccod   
			 left outer join tipos_colegios m   
			     on k.tcol_ccod = m.tcol_ccod   
			 join contratos cont (nolock)   
			     on d.matr_ncorr = cont.matr_ncorr 
                 and d.post_ncorr = cont.post_ncorr   
			 left outer join codeudor_postulacion copo   
			     on pos.post_ncorr = copo.post_ncorr   
			 left outer join personas_postulante pers2  
			     on copo.pers_ncorr = pers2.pers_ncorr   
		  where cont.econ_ccod = 1   
		  and d.emat_ccod not in (9)   
		  and i.tdir_ccod = 1   
		  and cast(c.peri_ccod as varchar)>'222'
		  and exists (select 1 from contratos cont1 (nolock), compromisos comp1  (nolock) where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) )  
	      --and cast(protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as varchar)= '2011' 
    group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno,   
			          a.pers_tape_materno,a.pers_fnacimiento,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc,   
			          i.dire_tcalle,pai.pais_tdesc,i.dire_tnro,i.dire_tpoblacion,i.dire_tblock,i.dire_tfono,j.ciud_tdesc,j.ciud_tcomuna,f.carr_ccod,   
			          dire2.dire_tcalle,dire2.dire_tnro,dire2.dire_tpoblacion,dire2.dire_tblock,dire2.dire_tfono,e.espe_tdesc,pl.plan_tdesc,   
			          ciud2.ciud_tdesc,ciud2.ciud_tcomuna,k.cole_tdesc,l.ciud_tdesc,l.ciud_tcomuna,a.pers_nnota_ens_media, reg.regi_tdesc,  
			          m.tcol_tdesc,a.pers_nano_egr_media,a.sexo_ccod,pos.tpad_ccod,pos.post_npaa_verbal,pos.POST_NANO_PAA,f.area_ccod, pea.anos_ccod,   
			          pos.post_npaa_matematicas,pos.post_nano_paa,pos.post_tinstitucion_anterior,a.pers_tcole_egreso,a.pers_ttipo_ensenanza,tip_ens.tens_ccod,tens_tdesc,  
			          cont.cont_fcontrato, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod,ARA.ARAN_MMATRICULA,ARA.ARAN_MCOLEGIATURA,  
			 		  pers2.pers_ncorr,pers2.pers_nrut,pers2.pers_xdv,a.pers_temail,pers2.pers_tnombre,pers2.pers_tape_paterno,pers2.pers_tape_materno,pers2.pers_fnacimiento,talu_ccod 
    order by sede,carrera,AP_Paterno,AP_Materno,Nombre 
     
 	--   select * from ( & consulta &  ) table_1 where table_1.estado_academico =' &emat_tdesc& '  