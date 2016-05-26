-- matriculados
    select a.pers_ncorr, e.carr_ccod, c.peri_ccod,f.emat_tdesc as estado_matricula, cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut,   
			    pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre as nombre,   
			   protic.trunc(d.alum_fmatricula) as fecha_matricula,protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) as nuevo,   
			    isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr, (select protic.obtener_nombre_carrera((select top 1 ofer_ncorr    
	   		    From alumnos where matr_ncorr=d.matr_ncorr order by matr_ncorr desc),'CC'))) ,     
                protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso , case c.jorn_ccod when 1 then 'D' else 'V' end as jornada 
			  from personas a, ofertas_academicas c, alumnos d,especialidades e , estados_matriculas f   
			  where a.pers_ncorr = d.pers_ncorr    
			     and c.ofer_ncorr= d.ofer_ncorr    
			     and c.espe_ccod = e.espe_ccod  
                 --and c.jorn_ccod='  & jorn_ccod &  '
                 and d.alum_fmatricula <=convert(datetime,'01/08/2005',103)
                 and d.emat_ccod=f.emat_ccod    
			     and e.carr_ccod='45'   
			     and c.sede_ccod='1'   
			     and d.emat_ccod in (1,4,8,2,13)    
	             and protic.afecta_estadistica(d.matr_ncorr) > 0    
			 	and c.peri_ccod=protic.retorna_max_periodo_matricula(a.pers_ncorr,'  200  ',e.carr_ccod)   
			 	and d.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',   
			                    'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',    
			                    'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',    
			                    'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',    
			                    'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2',    
			                    'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2')    
			  group by f.emat_tdesc,d.alum_fmatricula,c.jorn_ccod,a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, pers_tape_materno,d.matr_ncorr, d.post_ncorr   
              --having (select isnull(post_bnuevo,'N') from postulantes where post_ncorr=d.post_ncorr) = 'S'  order by nombre asc
              
              
-- postulantes 

  select b.audi_tusuario,a.pers_ncorr, e.carr_ccod, g.peri_tdesc, cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut, 
			   pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre  as nombre, 
                case c.jorn_ccod when 1 then 'D' else 'V' end as jornada ,
			    pers_fnacimiento,protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) as ano_ingreso 
			  from personas_postulante a, postulantes b, ofertas_academicas c, especialidades e, detalle_postulantes f , periodos_academicos g 
			  where a.pers_ncorr=b.pers_ncorr  
			    and b.post_ncorr=f.post_ncorr  
			    and c.ofer_ncorr=f.ofer_ncorr  			
			    and c.espe_ccod = e.espe_ccod  
			    and b.epos_ccod='2'  
			    and e.carr_ccod='45'  
			    --and c.jorn_ccod='  & jorn_ccod &  '  
			    and c.peri_ccod in ('202','204')  
			    and c.sede_ccod='1'     
                and c.peri_ccod=g.peri_ccod
                --and protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) is null
                --and protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr)=2005
			    and b.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49', 
			    'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52',  
			    'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88', 
			    'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1','CREAR_MATRICULA_SEG_SEMESTRE','MIGRACION(FCACERES)')  
  			  group by b.audi_tusuario,a.pers_ncorr, e.carr_ccod, g.peri_tdesc,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, pers_tape_materno,pers_fnacimiento, b.post_ncorr,c.jorn_ccod                
              
              
-- profesores 2005

select aa.sede,aa.pers_ncorr,aa.rut,aa.nombre_docente,cc.sexo_tdesc as genero,aa.tipo_profesor,
aa.grado,aa.descripcion_grado, 
sum(hora_pedagogica) as horas_semanales_p, 
case when sum(hora_pedagogica)  >=33 then 'Completa'  when  sum(hora_pedagogica)<33 and sum(hora_pedagogica)  >=20 then 'Media' else 'Hora' end as jornada_pedagogica,
sum(hora_cronologica) as horas_semanales_c,
case when sum(hora_cronologica)  >=33 then 'Completa'  when  sum(hora_cronologica)<33 and sum(hora_cronologica)  >=20 then 'Media' else 'Hora' end as jornada_cronologica

from  (
    select aa.carr_ccod,regimen,max(coordinacion) as horas_coordinacion,
        case sede when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
        aa.pers_ncorr,protic.obtener_rut(aa.pers_ncorr) as rut,nombre_docente,tipo_profesor,
        protic.obtener_grado_docente(aa.pers_ncorr,'G') as grado,
        protic.obtener_grado_docente(aa.pers_ncorr,'D') as descripcion_grado,
        ((max(coordinacion)*2)+(sum(horas)*2))/case regimen when 'ANUAL'then 36 
                                  when 'SEMESTRAL'then 18
                                  when 'TRIMESTRAL'then 12
                                  when 'PERIODO'then 12 end  as hora_pedagogica,
        (((max(coordinacion)*75)+(sum(horas)*75))/60)/case regimen when 'ANUAL'then 36 
                                  when 'SEMESTRAL'then 18
                                  when 'TRIMESTRAL'then 12
                                  when 'PERIODO'then 12 end  as hora_cronologica                                    
            from (
	            select   distinct protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_docente,A.CDOC_NCORR, CASE M.TPRO_CCOD WHEN 1 THEN isnull(E.HCOR_Valor1,0) ELSE 0 END as coordinacion 
                        , cast(ISNULL((CASE G.MODA_CCOD WHEN 1 THEN isnull(Y.hopr_nhoras ,protic.retorna_horas_seccion1(f.secc_ccod,m.TPRO_CCOD,e.pers_ncorr)) ELSE G.secc_nhoras_pagar  END)/2 ,0) as numeric) AS horas
			            , E.BLOQ_ANEXO, G.CARR_CCOD , A.PERS_NCORR, A.CDOC_FCONTRATO_Ini, A.CDOC_FCONTRATO_Fin
			            , G.ASIG_CCOD, J.DUAS_TDESC as regimen, E.BPRO_MVALOR
			            , ISNULL(CASE G.MODA_CCOD WHEN 1 THEN  (E.BPRO_MVALOR * (isnull(Y.hopr_nhoras ,protic.retorna_horas_seccion1(f.secc_ccod,m.TPRO_CCOD,e.pers_ncorr))/2)) ELSE (E.BPRO_MVALOR * (G.secc_nhoras_pagar/2)) END ,0)/*(E.BPRO_MVALOR * (I.ASIG_NHORAS/2))*/ AS Valor
                        , X.SEDE_TDESC as sede ,M.TPRO_TDESC AS TIPO_PROFESOR
			            , convert(varchar(10), A.CDOC_FCONTRATO_Ini,103) as FechaI
			            , convert(varchar(10), A.CDOC_FCONTRATO_Fin, 103) as FechaF
			            , convert(varchar(10), A.CDOC_FCONTRATO_Fin1, 103) as FechaF1
			            , cast(P.NIVE_CCOD as varchar) + '-' + cast(G.SECC_TDESC as varchar) as SECC_TDESC
                     ,CASE J.DUAS_CCOD WHEN 1 THEN Z.PROC_CUOTAS_TRIMESTRAL WHEN 2 THEN Z.PROC_CUOTAS_SEMESTRAL WHEN 3 THEN Z.PROC_CUOTAS_ANUAL WHEN 4 THEN Z.PROC_CUOTAS_ANUAL WHEN 5 THEN Z.PROC_CUOTAS_SEMESTRAL END AS num_cuotas
                     ,case J.DUAS_CCOD WHEN 5 then protic.trunc(Z.PROC_FINICIO) else protic.trunc(Z.PROC_FINICIO) end AS FECHA_INICIO
                     ,protic.trunc(CASE J.DUAS_CCOD WHEN 1 THEN Z.PROC_FFIN_TRIMESTRAL WHEN 2 THEN Z.PROC_FFIN_SEMESTRAL WHEN 3 THEN Z.PROC_FFIN_ANUAL WHEN 4 THEN Z.PROC_FFIN_ANUAL WHEN 5 THEN Z.PROC_FFIN_SEMESTRAL END) AS FECHA_FIN
	            from CONTRATOS_DOCENTES	A, PERSONAS B, 
		            BLOQUES_PROFESORES E, BLOQUES_horarios F, 
		            SECCIONES G, CARRERAS H, ASIGNATURAS I, DURACION_ASIGNATURA J, 
		            PROFESORES L, TIPOS_PROFESORES M, MALLA_CURRICULAR P,SEDES X,
		            PROCESOS Z,horas_profesores Y
	            where B.PERS_NCORR = A.PERS_NCORR
			            and E.PERS_NCORR = A.PERS_NCORR
			            and E.CDOC_NCORR	= A.CDOC_NCORR	
                        --and A.PERS_NCORR in (23804,17746,24256,24220)
			            and F.BLOQ_CCOD = E.BLOQ_CCOD
			            and G.SECC_CCOD = F.SECC_CCOD
			            AND H.CARR_CCOD = G.CARR_CCOD
			            AND I.ASIG_CCOD = G.ASIG_CCOD
			            and J.DUAS_CCOD =* I.DUAS_CCOD
			            and L.PERS_NCORR = A.PERS_NCORR
			            and M.TPRO_CCOD =* L.TPRO_CCOD
			            and P.MALL_CCOD = G.MALL_CCOD
                        AND E.SEDE_CCOD = X.SEDE_CCOD 
			            AND E.PROC_CCOD = Z.PROC_CCOD
			            AND E.SEDE_CCOD = l.sede_ccod
			            and E.PERS_NCORR*=Y.pers_ncorr
                        and F.SECC_CCOD *=Y.secc_ccod
			            and Y.hopr_nhoras > 0
                        and datepart(year,a.CDOC_FCONTRATO_Ini)=2005
                        and convert(datetime,A.CDOC_FCONTRATO_Ini,103)<=convert(datetime,'01/08/2005',103)

            ) as aa, carreras b
            where aa.carr_ccod=b.carr_ccod
            and aa.carr_ccod=45
            and b.tcar_ccod=1
        group by aa.pers_ncorr,aa.horas,aa.carr_ccod,aa.sede,aa.regimen,aa.nombre_docente,aa.tipo_profesor
) aa, personas bb, sexos cc
where aa.pers_ncorr=bb.pers_ncorr
and bb.sexo_ccod=cc.sexo_ccod
--and aa.grado in ('DOCTORADO')
group by aa.sede,aa.pers_ncorr,aa.rut,aa.nombre_docente,cc.sexo_tdesc,aa.tipo_profesor,aa.grado,aa.descripcion_grado
--having sum(hora_semana) >= 33            


-- profesores 2006
select aa.sede,aa.pers_ncorr,aa.rut,aa.nombre_docente,cc.sexo_tdesc as genero,aa.tipo_profesor,aa.grado,
aa.descripcion_grado, 
sum(hora_pedagogica) as horas_semanales_p, 
case when sum(hora_pedagogica)  >=33 then 'Completa'  when  sum(hora_pedagogica)<33 and sum(hora_pedagogica)  >=20 then 'Media' else 'Hora' end as jornada_pedagogica,
sum(hora_cronologica) as horas_semanales_c,
case when sum(hora_cronologica)  >=33 then 'Completa'  when  sum(hora_cronologica)<33 and sum(hora_cronologica)  >=20 then 'Media' else 'Hora' end as jornada_cronologica

from  (
        select case sede when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
        pers_ncorr,rut, nombre_docente,tipo_profesor,
        protic.obtener_grado_docente(pers_ncorr,'G') as grado,
        protic.obtener_grado_docente(pers_ncorr,'D') as descripcion_grado,
        (sum(horas)*2)/case regimen when 'ANUAL'then 36
                                          when 'SEMESTRAL'then 18
                                          when 'TRIMESTRAL'then 12
                                          when 'PERIODO'then 12 end  as hora_pedagogica,
        ((sum(horas)*75)/60)/case regimen when 'ANUAL'then 36
                                  when 'SEMESTRAL'then 18
                                  when 'TRIMESTRAL'then 12
                                  when 'PERIODO'then 12 end  as hora_cronologica
        from (
            select protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_docente,
            sede,pers_ncorr,cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,tipo_profesor    
            from (  
                select  e.sede_tdesc as sede,a.pers_ncorr,(c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor    
                  From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,    
 			                 asignaturas j, secciones n,tipos_profesores o,profesores p      
 		                  Where a.cdoc_ncorr     =   b.cdoc_ncorr     
 			                 and b.anex_ncorr    =   c.anex_ncorr     
 			                 and a.pers_ncorr    =   d.pers_ncorr     
 			                 and b.sede_ccod     =   e.sede_ccod     
 			                 and c.asig_ccod     =   j.asig_ccod     
 			                 and n.secc_ccod     =   c.secc_ccod     
 			                 and o.TPRO_CCOD     =   p.TPRO_CCOD     
 			                 and p.pers_ncorr    =   d.pers_ncorr     
 			                 AND b.SEDE_CCOD     =   p.sede_ccod    
                             and a.ecdo_ccod     <> 3    
                             and b.eane_ccod     <> 3
                             and p.tpro_ccod=1    
                             and a.ano_contrato=datepart(year,getdate())
                             and n.carr_ccod in (select carr_ccod from carreras where tcar_ccod=1)
                             --and convert(datetime,b.anex_finicio,103)<=convert(datetime,'01/08/2006',103)
                             and a.pers_ncorr not in (27208)
                             and b.carr_ccod=45    
                group by e.sede_tdesc,c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   
             ) as aa,    
            anexos b, duracion_asignatura c   
            where aa.anex_ncorr=b.anex_ncorr
            and  aa.duas_ccod=c.duas_ccod
            group by sede,b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor ,duas_tdesc
        ) as t
        group by sede,rut,nombre_docente,regimen,tipo_profesor,pers_ncorr
) as aa , personas bb, sexos cc
where aa.pers_ncorr=bb.pers_ncorr
and bb.sexo_ccod=cc.sexo_ccod
--and aa.pers_ncorr not in ( select distinct pers_ncorr from administrativos_docentes where admd_jornada=1)
--and aa.grado in ('MAGISTER','MAESTRIA')
group by  aa.sede,aa.pers_ncorr,aa.rut,aa.nombre_docente,aa.tipo_profesor,aa.grado,aa.descripcion_grado,cc.sexo_tdesc  
--having sum(hora_semana) between 20 and 32  