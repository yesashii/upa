select facu_tdesc,a.codigo,a.rut,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno,a.tipo_profesor,
c.carr_tdesc as carrera,d.sede_tdesc as sede,a.anex_ncodigo, 
protic.trunc(b.anex_finicio) as fecha_inicio,protic.trunc(b.anex_ffin) as fecha_fin, b.anex_ncuotas, 
sum(enero) as t_enero,sum(febrero) as t_febrero,sum(marzo) as t_marzo,sum(abril) as t_abril,
sum(mayo) as t_mayo,sum(junio) as t_junio,sum(julio) as t_julio,sum(agosto) as t_agosto,
sum(septiembre) as t_septiembre,sum(octubre) as t_octubre,sum(noviembre) as t_noviembre,sum(diciembre) as t_diciembre, 
sum(monto_mensual) as total_carrera_anexo
 From (
        select case mes when 1 then sum(valor_mensual) end as enero,
        case mes when 2 then sum(valor_mensual) end as febrero,
        case mes when 3 then sum(valor_mensual) end as marzo,
        case mes when 4 then sum(valor_mensual) end as abril,
        case mes when 5 then sum(valor_mensual) end as mayo,
        case mes when 6 then sum(valor_mensual) end as junio,
        case mes when 7 then sum(valor_mensual) end as julio,
        case mes when 8 then sum(valor_mensual) end as agosto,
        case mes when 9 then sum(valor_mensual) end as septiembre,
        case mes when 10 then sum(valor_mensual) end as octubre,
        case mes when 11 then sum(valor_mensual) end as noviembre,
        case mes when 12 then sum(valor_mensual) end as diciembre,
        carr_ccod,anex_ncodigo,anex_ncorr,b.pers_nrut as codigo,protic.obtener_rut(b.pers_ncorr) as rut,b.pers_tnombre,
        b.pers_tape_paterno,b.pers_tape_materno,ss.tipo_profesor, sum(valor_mensual) as monto_mensual    
          from (   
             select b.carr_ccod,mes,b.anex_ncodigo,b.anex_ncorr,pers_ncorr,cast(((sum(sesiones)+b.anex_nhoras_coordina)*monto_cuota) /b.anex_ncuotas as numeric) as valor_mensual,tipo_profesor    
             from (    
                 select b.carr_ccod,q.mes_ccod as mes, a.pers_ncorr,(c.dane_nsesiones/2) as sesiones, b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor    
 	                  From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,    
 			                     asignaturas j, secciones n,tipos_profesores o,profesores p , meses q     
 			                  Where a.cdoc_ncorr     =   b.cdoc_ncorr     
 			                      and b.anex_ncorr    =   c.anex_ncorr     
 			                      and a.pers_ncorr    =   d.pers_ncorr     
 			                      and b.sede_ccod     =   e.sede_ccod     
 			                      and c.asig_ccod     =   j.asig_ccod     
 			                      and n.secc_ccod     =   c.secc_ccod     
 			                      and o.TPRO_CCOD     =   p.TPRO_CCOD     
 			                      and p.pers_ncorr    =   d.pers_ncorr     
 			                      AND b.SEDE_CCOD     =   p.sede_ccod    
                                  and a.ecdo_ccod     <>   3    
                                  and b.eane_ccod     <> 3  
                                  and a.ano_contrato=datepart(year,getdate())  
                                  and q.mes_ccod  >=  datepart(month,b.anex_finicio) 
                                  and q.mes_ccod <= datepart(month,b.anex_ffin)
                 group by b.carr_ccod,q.mes_ccod,c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc    
             ) as aa,    
             anexos b   
             where aa.anex_ncorr=b.anex_ncorr    
             group by b.carr_ccod,aa.mes,b.anex_ncodigo,b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor    
         ) ss ,personas b    
          where ss.pers_ncorr=cast(b.pers_ncorr as varchar)    
          group by  carr_ccod,mes,anex_ncodigo,anex_ncorr,b.pers_nrut,b.pers_ncorr,b.pers_tnombre,b.pers_tape_paterno,b.pers_tape_materno,ss.tipo_profesor  
) as a ,anexos b, carreras c, sedes d, areas_academicas e, facultades f
where a.anex_ncorr=b.anex_ncorr
and b.carr_ccod=c.carr_ccod
and b.sede_ccod=d.sede_ccod
and c.area_ccod=e.area_ccod
and e.facu_ccod=f.facu_ccod
group by  a.carr_ccod,a.anex_ncodigo,a.anex_ncorr,a.rut,a.codigo,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno,a.tipo_profesor,
b.anex_finicio,b.anex_ffin, b.anex_ncuotas, b.sede_ccod, c.carr_tdesc,d.sede_tdesc, facu_tdesc 
order by  a.anex_ncodigo desc