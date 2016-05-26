select rut,nombre_docente,tipo_profesor,grado,pers_ncorr, sum (hora_semana) as hora_semana 
from (
    select pers_ncorr,rut,nombre_docente,tipo_profesor,
    protic.obtener_grado_docente(pers_ncorr,'G') as grado,
    protic.obtener_grado_docente(pers_ncorr,'D') as descripcion_grado,
    case regimen when 'TRIMESTRAL' then sum(horas) else 0 end as Trimestral,
    case regimen when 'SEMESTRAL' then sum(horas) else 0 end as Semestral ,
    case regimen when 'ANUAL' then sum(horas) else 0 end as Anual  ,
    case regimen when 'PERIODO' then sum(horas) else 0 end as Periodo,
    ((sum(horas)*75)/60)/case regimen when 'ANUAL'then 36
                                      when 'SEMESTRAL'then 18
                                      when 'TRIMESTRAL'then 12
                                      when 'PERIODO'then 3 end   as hora_semana
    from (
        select pers_ncorr,protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_docente,
        cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,tipo_profesor    
        from (  
            select  a.pers_ncorr,(c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor    
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
                         and n.peri_ccod in (210,212)
                         and a.pers_ncorr=48    
  			             --and datepart(month,getdate()) between  datepart(month,b.anex_finicio) and datepart(month,b.anex_ffin)    
            group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   
         ) as aa,    
        anexos b, duracion_asignatura c   
        where aa.anex_ncorr=b.anex_ncorr
        and  aa.duas_ccod=c.duas_ccod
        group by b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor ,duas_tdesc
    ) as t
    group by rut,nombre_docente,regimen,tipo_profesor,pers_ncorr
    --order by nombre_docente,grado,descripcion_grado
) as tabla_final
group by rut,nombre_docente,tipo_profesor,grado,pers_ncorr
--having sum(hora_semana) < 20 
order by nombre_docente,grado