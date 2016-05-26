select carrera,especialidad,sede,isnull(grado,'SIN TITULO') as Grado,genero,jornada_docente,count(*) as cantidad
from (
select carrera,especialidad,jornada,aa.sede,aa.pers_ncorr,aa.rut,aa.nombre_docente,cc.sexo_tdesc as genero,aa.tipo_profesor,aa.grado,
aa.descripcion_grado, --sum(hora_semana) as horas_semanales
case  When sum(hora_semana)>=33 then 'JORNADA COMPLETA'
      When sum(hora_semana)>=20 and sum(hora_semana) <33 then 'JORNADA MEDIA'
      When sum(hora_semana) < 20  then 'JORNADA HORA' end as jornada_docente
from  (
        select carrera,especialidad,jornada,case sede when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
        pers_ncorr,rut, nombre_docente,tipo_profesor,
        protic.obtener_grado_docente(pers_ncorr,'G') as grado,
        protic.obtener_grado_docente(pers_ncorr,'D') as descripcion_grado,
        (sum(horas)*2)/case regimen when 'ANUAL'then 36
                                          when 'SEMESTRAL'then 18
                                          when 'TRIMESTRAL'then 12
                                          when 'PERIODO'then 12 end  as hora_semana
        from (
            select carrera,especialidad,jornada,protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_docente,
            sede,pers_ncorr,cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,tipo_profesor    
            from (  
                select  t.carr_tdesc as carrera,s.espe_tdesc as especialidad,n.jorn_ccod as jornada,e.sede_tdesc as sede,a.pers_ncorr,(c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor    
                  From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,asignaturas j, secciones n,    
 			                 tipos_profesores o,profesores p, malla_curricular q, planes_estudio r, especialidades s,carreras t      
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
                             and n.mall_ccod=q.mall_ccod
                             and q.plan_ccod=r.plan_ccod
                             and r.espe_ccod=s.espe_ccod
                             and n.carr_ccod=t.carr_ccod
                             --and n.carr_ccod in (select carr_ccod from carreras where tcar_ccod=1)
                             and convert(datetime,b.anex_finicio,103)<=convert(datetime,'30/04/2006',103)
                             and a.pers_ncorr not in (27208)    
                group by t.carr_tdesc,s.espe_tdesc,n.jorn_ccod,e.sede_tdesc,c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   
             ) as aa,    
            anexos b, duracion_asignatura c   
            where aa.anex_ncorr=b.anex_ncorr
            and  aa.duas_ccod=c.duas_ccod
            group by carrera,especialidad,jornada,sede,b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor ,duas_tdesc
        ) as t
        group by carrera,especialidad,jornada,sede,rut,nombre_docente,regimen,tipo_profesor,pers_ncorr
) as aa , personas bb, sexos cc
where aa.pers_ncorr=bb.pers_ncorr
and bb.sexo_ccod=cc.sexo_ccod
--and aa.pers_ncorr not in ( select distinct pers_ncorr from administrativos_docentes where admd_jornada=1)
--and grado in ('DOCTORADO')
group by  carrera,especialidad,jornada,aa.sede,aa.pers_ncorr,aa.rut,aa.nombre_docente,aa.tipo_profesor,aa.grado,aa.descripcion_grado,cc.sexo_tdesc  
--having sum(hora_semana) >=33
) as tabla
group by carrera,especialidad,sede,grado,jornada,tipo_profesor,jornada_docente,genero
order by sede,carrera,especialidad,grado,genero,jornada_docente