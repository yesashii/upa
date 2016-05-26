 select * from ( 
 select aa.pers_ncorr,carrera, jornada,aa.rut, 
 bb.pers_tnombre as nombre_docente, bb.pers_tape_paterno+' '+bb.pers_tape_materno as apellido_docente, 
 aa.grado,aa.descripcion_grado, sum(hora_semana) as horas_semanales, 
 case when sum(hora_semana)>=40 then 'Completa' when sum(hora_semana)<19 then 'Hora' else 'Media' end as horas_jornada 
 from  ( 
 		select pers_ncorr,rut, carrera, jornada,
 		protic.obtener_grado_docente(pers_ncorr,'G') as grado, 
 		protic.obtener_grado_docente(pers_ncorr,'D') as descripcion_grado, 
 		((sum(horas)*75)/60)/case regimen when 'ANUAL'then 36 
 										  when 'SEMESTRAL'then 18 
 										  when 'TRIMESTRAL'then 12 
 										  when 'PERIODO'then 12 end  as hora_semana 
 		from ( 
 			select protic.obtener_rut(pers_ncorr) as rut,pers_ncorr, 
 			cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,
            carrera, jornada    
 			from (   
 				select  a.pers_ncorr,(c.dane_nsesiones/2) as sesiones,c.duas_ccod,  
 				b.anex_ncorr,c.dane_msesion as monto_cuota  , carr_tdesc as carrera, jorn_tdesc as jornada  
 				  From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,     
 							 asignaturas j, secciones n,tipos_profesores o,profesores p, carreras q, jornadas r       
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
 							 and a.ano_contrato=2006 
                             and n.carr_ccod=q.carr_ccod
                             and n.jorn_ccod=r.jorn_ccod
 							 and n.carr_ccod in (select carr_ccod from carreras where tcar_ccod=1) 
 							 and a.pers_ncorr not in (27208)     
 				group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,c.duas_ccod ,carr_tdesc,jorn_tdesc
 			 ) as aa,     
 			anexos b, duracion_asignatura c    
 			where aa.anex_ncorr=b.anex_ncorr 
 			and  aa.duas_ccod=c.duas_ccod 
 			group by carrera, jornada,b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,duas_tdesc 
 		) as t 
 		group by rut,regimen,pers_ncorr ,carrera, jornada
 ) as aa , personas bb 
 where aa.pers_ncorr=bb.pers_ncorr 
 and aa.pers_ncorr not in ( select distinct pers_ncorr from administrativos_docentes where admd_jornada in (1,2) and pers_ncorr not in (12258)) 
 group by  aa.pers_ncorr,aa.rut,aa.grado,aa.descripcion_grado, 
 bb.pers_tnombre, bb.pers_tape_paterno, bb.pers_tape_materno,carrera, jornada   
 ) as tabla 
-- where horas_jornada like 'Media' 
