select grado, sum(numero) as cantidad,sum (horas_semanales) as horas_semana 
from (
    select aa.grado,count(*) as numero,sum(hora_semana) as horas_semanales
    from  (
        SELECT SUM(hora_semana)  AS hora_semana, grado 
        from (
            select  pers_ncorr,rut, nombre_docente,
            protic.obtener_grado_docente(pers_ncorr,'G') as grado,
            ((sum(horas)*75)/60)/case regimen when 'ANUAL'then 36
                                              when 'SEMESTRAL'then 18
                                              when 'TRIMESTRAL'then 12
                                              when 'PERIODO'then 12 end  as hora_semana
            from (
                select protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_docente,
                pers_ncorr,cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,sede,duas_tdesc as regimen,tipo_profesor    
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
                                 --and convert(datetime,b.anex_finicio,103)<=convert(datetime,'30/04/2006',103)
                                 and a.pers_ncorr not in ( select distinct pers_ncorr from administrativos_docentes where admd_jornada in (1,2))
                                 and a.pers_ncorr not in (27208)    
                    group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,e.sede_tdesc,c.duas_ccod   
                 ) as aa,    
                anexos b, duracion_asignatura c   
                where aa.anex_ncorr=b.anex_ncorr
                and  aa.duas_ccod=c.duas_ccod
                group by b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,sede,tipo_profesor ,duas_tdesc
            ) as t
            group by rut,nombre_docente,regimen,pers_ncorr
        ) as tabla
        group by pers_ncorr,grado
    ) as aa 
   -- and grado in ('DOCTORADO')
    group by  aa.grado
    --having sum(hora_semana) >=33

    UNION 

    select grado,count(*) as numero, sum (horas_semanales) as horas_semanales from (
        select   distinct a.pers_ncorr, protic.obtener_grado_docente(a.pers_ncorr,'G') as grado,45 as horas_semanales
        From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,    
 		          secciones n,tipos_profesores o,profesores p, sexos q ,administrativos_docentes r 
 	          Where a.cdoc_ncorr     =   b.cdoc_ncorr     
 		         and b.anex_ncorr    =   c.anex_ncorr     
 		         and a.pers_ncorr    =   d.pers_ncorr     
 		         and b.sede_ccod     =   e.sede_ccod     
 		         and n.secc_ccod     =   c.secc_ccod     
 		         and o.TPRO_CCOD     =   p.TPRO_CCOD     
 		         and p.pers_ncorr    =   d.pers_ncorr     
 		         AND b.SEDE_CCOD     =   p.sede_ccod
                 and d.sexo_ccod     =   q.sexo_ccod
                 and a.pers_ncorr    =   r.pers_ncorr    
                 and admd_jornada    in ( 1,2)
                 and a.ecdo_ccod     <> 3    
                 and b.eane_ccod     <> 3
                 and p.tpro_ccod=1    
                 and a.ano_contrato=datepart(year,getdate())
                 and n.carr_ccod in (select carr_ccod from carreras where tcar_ccod=1)
                 --and convert(datetime,b.anex_finicio,103)<=convert(datetime,'30/04/2006',103)
                 and a.pers_ncorr not in (27208)
                 --AND protic.obtener_grado_docente(a.pers_ncorr,'G')='DOCTORADO'
        ) as tabla
        group by grado
)as bbb
group by grado

