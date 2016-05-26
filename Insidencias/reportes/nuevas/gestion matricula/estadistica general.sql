 Select aa.sede_ccod,aa.sede_tdesc, 
 cast(isnull(EN_PROCESO_n,0) as integer) as EN_PROCESO_n, 
 cast(isnull(EN_PROCESO_a,0) as integer) as EN_PROCESO_a, 
 cast(isnull(EN_PROCESO_n,0)+isnull(EN_PROCESO_a,0) as integer) as EN_PROCESO_t, 
 cast(isnull(ENVIADOS_n,0) as integer) as ENVIADOS_n, 
 cast(isnull(ENVIADOS_a,0) as integer) as ENVIADOS_a, 
 cast(isnull(ENVIADOS_n,0) + isnull(ENVIADOS_a,0) as integer) as ENVIADOS_t, 
 cast(isnull(MATRICULADOS_n,0) as integer) as MATRICULADOS_n, 
 cast(isnull(MATRICULADOS_a,0) as integer) as MATRICULADOS_a, 
 cast(isnull(MATRICULADOS_n,0) + isnull(MATRICULADOS_a,0) as integer) as MATRICULADOS_t  
 from -- obtencion de primera tabla a 
     (select a.sede_ccod,a.sede_tdesc, 
        SUM(case EPOS_CCOD When 1 then (case nuevo when 'S' then total_pos end )else 0 end) as EN_PROCESO_n, 
        SUM(case EPOS_CCOD When 1 then (case nuevo when 'N' then total_pos end )else 0 end) as EN_PROCESO_a, 
        SUM(case EPOS_CCOD When 2 then (case nuevo when 'S' then total_pos end )else 0 end) as ENVIADOS_n, 
        SUM(case EPOS_CCOD When 2 then (case nuevo when 'N' then total_pos end )else 0 end) as ENVIADOS_a 
        from( select e.sede_ccod,sede_tdesc, a.epos_ccod,protic.es_nuevo_carrera(a.pers_ncorr,d.carr_ccod,a.peri_ccod) as nuevo,count(*) as total_pos  
 					from postulantes a 
 					join detalle_postulantes b n
    					on a.post_ncorr=b.post_ncorr 
 					join ofertas_academicas c 
    					on b.ofer_ncorr=c.ofer_ncorr 
					join especialidades d 
    					on c.espe_ccod=d.espe_ccod 
					join sedes e 
    					on c.sede_ccod=e.sede_ccod 
                    where a.peri_ccod=protic.retorna_max_periodo_matricula(c.pers_ncorr,'218',d.carr_ccod)  
                        and a.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49',
						   'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', 
 						   'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88',
  						   'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1') 
                            group by e.sede_ccod,sede_tdesc, a.epos_ccod, protic.es_nuevo_carrera(a.pers_ncorr,d.carr_ccod,a.peri_ccod) 
            ) a 
        GROUP BY a.sede_ccod,a.SEDE_TDESC 
     ) aa 
     left outer join -- segunda tabla del from (B) 
    (select b.sede_ccod, sede_tdesc,  count(*) as MATRICULADOS_n 
        from ofertas_academicas a 
            left outer join sedes b 
                on a.sede_ccod =b.sede_ccod 
            left outer join alumnos c 
                on a.ofer_ncorr =c.ofer_ncorr 
            right outer join especialidades d 
                on a.espe_ccod = d.espe_ccod 
 			where c.emat_ccod in (1,4,8,2,15,16)  and c.audi_tusuario not like '%ajunte matricula%'
			and protic.afecta_estadistica(c.matr_ncorr) > 0 
			and a.peri_ccod=protic.retorna_max_periodo_matricula(c.pers_ncorr,'218',d.carr_ccod)  
			and isnull(c.alum_nmatricula,0) not in (7777) 
	        and c.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',
                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno', 
                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65', 
                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN', 
                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2', 
                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2') 
 		 		And c.pers_ncorr > 0 
       -- and protic.es_nuevo_carrera(c.pers_ncorr,d.carr_ccod,a.peri_ccod) = 'S' 
		 and (select post_bnuevo from postulantes where post_ncorr=c.post_ncorr) = 'S' 
        group by b.sede_ccod,sede_tdesc 
     ) B on aa.sede_ccod=b.sede_ccod 
     left outer join -- tercera tabla del form (bb) 
    ( select b.sede_ccod,sede_tdesc,  count(*) as MATRICULADOS_a 
        from ofertas_academicas a 
            left outer join sedes b 
                on a.sede_ccod=b.sede_ccod 
            left outer join alumnos c 
                on a.ofer_ncorr = c.ofer_ncorr 
            right outer join especialidades d 
                on a.espe_ccod = d.espe_ccod 
        where protic.afecta_estadistica(c.matr_ncorr) > 0 and c.audi_tusuario not like '%ajunte matricula%'
			and a.peri_ccod=protic.retorna_max_periodo_matricula(c.pers_ncorr,'218',d.carr_ccod) 
            and isnull(c.alum_nmatricula,0) not in (7777) 
	        and c.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',
                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno', 
                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65', 
                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN', 
                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2', 
                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2') 
                and c.emat_ccod in (1,4,8,2,15,16)  
 		 		And c.pers_ncorr > 0 
        --and protic.es_nuevo_carrera(c.pers_ncorr,d.carr_ccod,a.peri_ccod) = 'N' 
		 and (select post_bnuevo from postulantes where post_ncorr=c.post_ncorr) = 'N' 
        group by b.sede_ccod,sede_tdesc 
    ) BB on aa.sede_ccod = bb.sede_ccod 
and exists (select 1 from sis_sedes_usuarios x, personas y where x.pers_ncorr=y.pers_ncorr and cast(y.pers_nrut as varchar)= '13582834' and x.sede_ccod = aa.sede_ccod ) 