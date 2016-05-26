 select mes_ccod,mes_tdesc+'(Año '+cast(ano as varchar)+')' as mes_tdesc,sum(cheques) as cheques, sum(letras) as letras, sum(efectivo) as efectivo,  
 sum(credito) as credito, sum(debito) as debito, sum(vale_vista) as vale_vista, sum(pagare) as pagare,  
 (sum(cheques)+sum(letras)+sum(efectivo)+sum(credito)+sum(debito)+sum(vale_vista)+sum(pagare)) as total 
 from ( 
 select datepart(month,b.mcaj_finicio) as mes,datepart(year,b.mcaj_finicio) as ano,isnull(max(cheque),0) as cheques,isnull(max(letra),0) as letras,    
 isnull(max(efectivo),0) as efectivo,isnull(max(credito),0) as credito,    
 isnull(max(vale_vista),0) as vale_vista,isnull(max(debito),0) as debito,     
 isnull(max(pagare),0) as pagare,    
 (isnull(max(cheque),0) + isnull(max(letra),0) + isnull(max(efectivo),0) + isnull(max(credito),0) +    
 isnull(max(vale_vista),0) +isnull(max(debito),0) + isnull(max(pagare),0) ) as total    
 from (
     select mcaj_ncorr,case ting_ccod when 3 then cast(sum(monto_recaudado) as numeric) end as cheque,    
     case ting_ccod when 4 then cast(sum(monto_recaudado) as numeric) end as letra,     
     case ting_ccod when 6 then cast(sum(monto_recaudado) as numeric) end as efectivo,   
     case ting_ccod when 13 then cast(sum(monto_recaudado) as numeric) end as credito,     
     case ting_ccod when 14 then cast(sum(monto_recaudado) as numeric) end as vale_vista,     
     case ting_ccod when 51 then cast(sum(monto_recaudado) as numeric) end as debito,     
     case ting_ccod when 52 then cast(sum(monto_recaudado) as numeric) end as pagare     
     from (    
            -- Titulaciones pagadas directamente 
              select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo, 
              case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 
                   else b.ting_ccod end as ting_ccod,    
              case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo 
                   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado    
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
              where a.mcaj_ncorr in (
                                    select  distinct e.mcaj_ncorr
                                     from compromisos b, abonos c, ingresos d, movimientos_cajas e, detalles f	
                                     where b.comp_ndocto=c.comp_ndocto	
                                     and b.tcom_ccod=c.tcom_ccod	
                                     and b.inst_ccod=c.inst_ccod	
                                     and c.ingr_ncorr=d.ingr_ncorr	
                                     and d.ting_ccod in (34)	
                                     and d.eing_ccod not in (3,6)	
                                     and d.mcaj_ncorr=e.mcaj_ncorr
                                     and b.tcom_ccod=4	
                                     and e.sede_ccod in ('1')
                                     and b.tcom_ccod=f.tcom_ccod
                                     and b.comp_ndocto=f.comp_ndocto
                                     and f.tdet_ccod in (1230)	
            )
              and a.ting_ccod  in (34)     
              and a.eing_ccod not in (3,6) 
              and datepart(year,a.ingr_fpago)='2005'
               
              UNION 
              
              -- Titulaciones repactadas
              Select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo, 
              case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 
                   else b.ting_ccod end as ting_ccod,    
              case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo 
                   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado    
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
                and e.sede_ccod='1'                  
             Where ingr_nfolio_referencia in (
                    select a.ingr_nfolio_referencia
                    from ingresos a, detalle_ingresos b, abonos c
                    where a.ingr_ncorr=b.ingr_ncorr
                        and a.ingr_ncorr=c.ingr_ncorr
                        and c.tcom_ccod=4
                        and a.ting_ccod=9
                        and b.ting_ccod=9
                        and a.eing_ccod=5
            )
            and a.eing_ccod not in (5,3,6)
            and a.ting_ccod=15
            and datepart(year,a.ingr_fpago)='2005'  
 ) as tabla      
     group by mcaj_ncorr,ting_ccod
 ) a      
 join movimientos_cajas b   
     on a.mcaj_ncorr=b.mcaj_ncorr    
 	 and b.tcaj_ccod in (1000)   
	 group by b.mcaj_finicio 
    ) as tabla 
 join meses 
    on mes_ccod=mes   
 group by mes_tdesc,mes_ccod,ano 
 order by ano asc,mes_ccod asc 
 
--************************************************************************
--          para las titulaciones que han sido repactadas   **************

 Select datepart(year,a.ingr_fpago),a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo, 
      case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 
           else b.ting_ccod end as ting_ccod,    
      case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo 
           else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado    
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
    and e.sede_ccod='4'
 Where ingr_nfolio_referencia in (
        select a.ingr_nfolio_referencia
        from ingresos a, detalle_ingresos b, abonos c
        where a.ingr_ncorr=b.ingr_ncorr
            and a.ingr_ncorr=c.ingr_ncorr
            and c.tcom_ccod=4
            and a.ting_ccod=9
            and b.ting_ccod=9
            and a.eing_ccod=5
           --and datepart(year,a.ingr_fpago)=2005
)
and a.eing_ccod not in (5,3,6)
and a.ting_ccod=15

--************************************************************************

 
-- select * from detalles where comp_ndocto in (31988,32735)