select aa.pers_ncorr,aa.rut,
(select top 1 prof_ingreso_uas from profesores where pers_ncorr=aa.pers_ncorr) as anio_ingreso,
(select tcdo_tdesc from tipos_contratos_docentes where tcdo_ccod=aa.tcdo_ccod) as tipo_contrato,
protic.trunc(bb.pers_fnacimiento) as fecha_nacimiento,
bb.pers_tnombre as nombre_docente, bb.pers_tape_paterno+' '+bb.pers_tape_materno as apellido_docente,
cc.sexo_tdesc as genero,aa.tipo_profesor,aa.grado,institucion, aa.pais,aa.egreso,
aa.descripcion_grado as nombre_grado, sum(hora_semana) as horas_semanales,
case when sum(hora_semana)>=40 then 'Completa' when sum(hora_semana)<19 then 'Hora' else 'Media' end as jornada
from  (
        select --case sede when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
        pers_ncorr,rut,tipo_profesor,tcdo_ccod,
        protic.obtener_grado_docente(pers_ncorr,'G') as grado,
        protic.obtener_grado_docente(pers_ncorr,'D') as descripcion_grado,
        protic.obtener_grado_docente(pers_ncorr,'I') as institucion,
        protic.obtener_grado_docente(pers_ncorr,'P') as pais,
        protic.obtener_grado_docente(pers_ncorr,'E') as egreso,
        ((sum(horas)*75)/60)/case regimen when 'ANUAL'then 36
                                          when 'SEMESTRAL'then 18
                                          when 'TRIMESTRAL'then 12
                                          when 'PERIODO'then 12 end  as hora_semana
        from (
            select tcdo_ccod,protic.obtener_rut(pers_ncorr) as rut,pers_ncorr,
            cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,tipo_profesor    
            from (  
                select  tcdo_ccod,a.pers_ncorr,(c.dane_nsesiones/2) as sesiones,c.duas_ccod, 
                b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor   
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
                             and a.ano_contrato=2007
                             --and b.sede_ccod=4
                             and n.carr_ccod in (select carr_ccod from carreras where tcar_ccod=1)
                             and convert(datetime,b.anex_finicio,103)<=convert(datetime,'30/07/2007',103)
                             and a.pers_ncorr not in (27208)    
                group by tcdo_ccod,c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod
             ) as aa,    
            anexos b, duracion_asignatura c   
            where aa.anex_ncorr=b.anex_ncorr
            and  aa.duas_ccod=c.duas_ccod
            group by tcdo_ccod,b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor ,duas_tdesc
        ) as t
        group by tcdo_ccod,rut,regimen,tipo_profesor,pers_ncorr
) as aa , personas bb, sexos cc
where aa.pers_ncorr=bb.pers_ncorr
and bb.sexo_ccod=cc.sexo_ccod
--and aa.pers_ncorr not in ( select distinct pers_ncorr from administrativos_docentes where admd_jornada in (1,2) and pers_ncorr not in (12258))
group by  aa.pers_ncorr,aa.rut,aa.tipo_profesor,aa.grado,aa.descripcion_grado,aa.institucion,aa.pais,egreso,
cc.sexo_tdesc,bb.pers_tnombre, bb.pers_tape_paterno, bb.pers_tape_materno,bb.pers_fnacimiento,tcdo_ccod  


