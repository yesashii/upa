select c.facu_tdesc,b.presc_carrera_desc,b.presc_aranceles,b.presc_titulaciones,b.presc_total,
isnull(ff.arancel,0) arancel,isnull(ff.titulacion,0) total,isnull(ff.total,0) total 
from  presupuestos_escuelas b
left outer join 
(select facu_ccod, jorn_ccod,sede_ccod,facultad,carrera + case jorn_ccod when 1 then '- (D)' else '- (V)' end as carrera, carr_ccod,  
cast(max(total_arancel) as numeric) as arancel,cast(max(total_titulacion) as numeric) as titulacion, cast(isnull(max(total_arancel),0)+isnull(max(total_titulacion),0) as numeric) as total
From (
    select d.facu_ccod,d.facu_tdesc as facultad ,b.carr_tdesc as carrera, 
     a.carr_ccod ,  a.tipo_ingreso,a.jorn_ccod,a.sede_ccod,
    case tipo_ingreso when 1 then sum(monto_recaudado) end as total_arancel,
    case tipo_ingreso when 2 then sum(monto_recaudado) end as total_titulacion
         from (     
          select case when rtrim(protic.obtener_carrera_ingreso(a.mcaj_ncorr,a.ting_ccod,ingr_nfolio_referencia,a.pers_ncorr))=12 and g.espe_ccod in(186,187,63,286) then rtrim(protic.obtener_carrera_ingreso(a.mcaj_ncorr,a.ting_ccod,ingr_nfolio_referencia,a.pers_ncorr))+cast(g.espe_ccod as varchar) else protic.obtener_carrera_ingreso(a.mcaj_ncorr,a.ting_ccod,ingr_nfolio_referencia,a.pers_ncorr) end as carr_ccod,
          1 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo, 
          case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 
               else b.ting_ccod end as ting_ccod,    
          case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo 
               else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado,
                g.jorn_ccod,g.sede_ccod    
            From ingresos a      
            left outer join detalle_ingresos b    
              on a.ingr_ncorr=b.ingr_ncorr
              and b.ting_ccod in (3,4,6,13,14,51,52)    
            left outer join tipos_ingresos c      
              on b.ting_ccod=c.ting_ccod     
            join abonos d
              on a.ingr_ncorr=d.ingr_ncorr
              and d.tcom_ccod in (1,2)
            join contratos e
                on d.comp_ndocto=e.cont_ncorr 
                and e.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod ='2007')
            join alumnos f
                on e.matr_ncorr=f.matr_ncorr
            join ofertas_academicas g
                on f.ofer_ncorr=g.ofer_ncorr
             where a.ting_ccod  in (7)     
                  and a.eing_ccod not in (3,6)
                  and e.econ_ccod not in (3)
                  and g.sede_ccod in ('1')   
         UNION	 
          -- Titulaciones pagadas directamente  
          select  case when rtrim(protic.obtener_carrera_cargo(f.post_ncorr))=12 and g.espe_ccod in(186,187,63,286) then rtrim(protic.obtener_carrera_cargo(f.post_ncorr))+cast(g.espe_ccod as varchar) else protic.obtener_carrera_cargo(f.post_ncorr) end as carr_ccod,
          j.tipo_ingreso,
          j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo, 
          j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod
          from (
           select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  
           case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  
 	           else b.ting_ccod end as ting_ccod, 
           case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  
 	           else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado,
           protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr
           from ingresos a   
           left outer join detalle_ingresos b  
 	          on a.ingr_ncorr=b.ingr_ncorr   
 	          and  b.ting_ccod in (3,4,6,13,14,51,52)   
           left outer join tipos_ingresos c   
 	          on b.ting_ccod=c.ting_ccod  
           join abonos d  
 	            on a.ingr_ncorr=d.ingr_ncorr  
 	            and d.tcom_ccod=4  
           join detalles e  
 	            on d.comp_ndocto=e.comp_ndocto  
 	            and d.tcom_ccod=e.tcom_ccod  
 	            and e.tdet_ccod in (1230)
          where a.ting_ccod  in (34)     
               and a.eing_ccod not in (3,6)  
               and datepart(year,a.ingr_fpago)='2007' 
           ) j
           join alumnos f
                on j.pers_ncorr =f.pers_ncorr
                and f.post_ncorr=j.post_ncorr
                and f.emat_ccod not in (9)
           join ofertas_academicas g
                on f.ofer_ncorr=g.ofer_ncorr 
                and g.sede_ccod='1'	  

       UNION  
           -- Titulaciones repactadas  
        select case when rtrim(protic.obtener_carrera_cargo(f.post_ncorr))=12 and g.espe_ccod in(186,187,63,286) then rtrim(protic.obtener_carrera_cargo(f.post_ncorr))+cast(g.espe_ccod as varchar) else protic.obtener_carrera_cargo(f.post_ncorr) end as carr_ccod,
                j.tipo_ingreso,  j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo, 
                  j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod
         from (
           Select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  
           case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  
 	           else b.ting_ccod end as ting_ccod,     
           case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  
 	           else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado,
               protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr 
              From ingresos a  
                  left outer join detalle_ingresos b  
 	                  on a.ingr_ncorr=b.ingr_ncorr    
 	                  and  b.ting_ccod in (3,4,6,13,14,51,52)
                  left outer join tipos_ingresos c  
 	                  on b.ting_ccod=c.ting_ccod  
                  join abonos d  
 		                on a.ingr_ncorr=d.ingr_ncorr  
 		                and d.tcom_ccod=3  
                  join compromisos e  
 	                    on d.comp_ndocto=e.comp_ndocto  
 	                    and d.tcom_ccod=e.tcom_ccod  
                  Where a.eing_ccod not in (5,3,6) 
                        and a.ting_ccod=15 
                        and a.ingr_nfolio_referencia in ( 
 		                            select a.ingr_nfolio_referencia  
                                     from ingresos a, detalle_ingresos b, abonos c  
                                     where a.ingr_ncorr=b.ingr_ncorr  
 	                                    and a.ingr_ncorr=c.ingr_ncorr  
 	                                    and c.tcom_ccod=4  
 	                                    and a.ting_ccod=9  
 	                                    and b.ting_ccod=9 
 	                                    and a.eing_ccod=5 
                                    ) 
                and datepart(year,a.ingr_fpago)='2007'   
           ) j
           join alumnos f
                on j.pers_ncorr =f.pers_ncorr
                and f.post_ncorr=j.post_ncorr
                and f.emat_ccod not in (9)
           join ofertas_academicas g
                on f.ofer_ncorr=g.ofer_ncorr 
                and g.sede_ccod='1'	  
    ) as a, carreras_bancaj b, areas_academicas c,facultades d  
    where  a.carr_ccod=b.carr_ccod
    and b.area_ccod=c.area_ccod
    and c.facu_ccod=d.facu_ccod
    group by a.carr_ccod,a.tipo_ingreso,b.carr_tdesc,d.facu_tdesc,d.facu_ccod,a.jorn_ccod,a.sede_ccod     
) as tabla_final
group by facu_ccod,facultad,carrera,carr_ccod,jorn_ccod,sede_ccod
) ff
on  b.presc_facultad=ff.facu_ccod
and b.presc_carrera=ff.carr_ccod
and b.presc_sede=ff.sede_ccod
and b.presc_jornada=ff.jorn_ccod
join facultades c
    on b.presc_facultad=c.facu_ccod
where  b.presc_sede=1