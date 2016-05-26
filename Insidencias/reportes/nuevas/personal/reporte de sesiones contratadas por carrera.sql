select carrera,rut,nombre_docente,tipo_profesor,pers_ncorr, sum (sesiones) as sesiones
from (
        select d.carr_tdesc as carrera,pers_ncorr,protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_docente,
        --cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as sesiones,tipo_profesor
        cast(sum(sesiones)as numeric) as sesiones,tipo_profesor    
        from (  
            select  a.pers_ncorr,c.dane_nsesiones as sesiones,c.duas_ccod, b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor    
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
                         and p.tpro_ccod in (1,2)
                         and a.ano_contrato=datepart(year,getdate())
                         and n.peri_ccod in (210,212)
  			             --and datepart(month,getdate()) between  datepart(month,b.anex_finicio) and datepart(month,b.anex_ffin)    
            group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   
         ) as aa,    
        anexos b, duracion_asignatura c, carreras d   
        where aa.anex_ncorr=b.anex_ncorr
        and  aa.duas_ccod=c.duas_ccod
        and b.carr_ccod=d.carr_ccod
        group by d.carr_tdesc,b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor ,duas_tdesc
) as t
group by carrera,rut,nombre_docente,tipo_profesor,pers_ncorr