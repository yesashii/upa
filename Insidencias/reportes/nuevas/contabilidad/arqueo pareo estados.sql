Select  a.edin_ccod,a.banc_ccod,a.ding_ndocto, protic.trunc(ingr_fpago) as fecha, 
        convert(varchar,a.ding_fdocto,103) as ding_fdocto, sum(b.ingr_mdocto) as ding_mdocto,
        sum(b.ingr_mtotal) as total
 From detalle_ingresos a 
    join   ingresos b 
        on a.ingr_ncorr = b.ingr_ncorr 
    left outer join   envios c 
        on a.envi_ncorr = c.envi_ncorr 
    join   estados_detalle_ingresos d 
        on a.edin_ccod = d.edin_ccod 
    left outer join   instituciones_envio e 
        on c.inen_ccod = e.inen_ccod  
    join  personas f 
        on b.pers_ncorr = f.pers_ncorr 
    left outer join  personas g 
        on a.pers_ncorr_codeudor = g.pers_ncorr  
    join   abonos h 
        on b.ingr_ncorr = h.ingr_ncorr 
    join   compromisos i 
        on h.tcom_ccod = i.tcom_ccod  
        and h.inst_ccod = i.inst_ccod  
        and h.comp_ndocto = i.comp_ndocto 
 Where i.ecom_ccod <> 3   
    and b.eing_ccod <> 3   
    and a.ding_ncorrelativo > 0    
    and a.ting_ccod in (3,38)   
    AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'01/12/2000',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'30/01/2005',103),convert(datetime,a.ding_fdocto,103))
    and a.edin_ccod in (1,10)
    and a.audi_tusuario not like '%CH-2E%' 
group by a.edin_ccod,a.banc_ccod,a.ding_ndocto,a.ding_fdocto,d.edin_tdesc,ingr_fpago
--having a.edin_ccod not in (1)
order by a.ding_ndocto, a.edin_ccod,a.banc_ccod asc, a.ding_fdocto asc, b.ingr_fpago asc


--******************************************************--
/*
select count(ding_ndocto) as cantidad_doctos,ding_ndocto
 from (
    Select  distinct max(pers_ncorr),a.edin_ccod,a.banc_ccod,a.ding_ndocto, sum(b.ingr_mtotal) as total
     From detalle_ingresos a 
        join   ingresos b 
            on a.ingr_ncorr = b.ingr_ncorr 
        left outer join   envios c 
            on a.envi_ncorr = c.envi_ncorr 
        join   estados_detalle_ingresos d 
            on a.edin_ccod = d.edin_ccod 
        left outer join   instituciones_envio e 
            on c.inen_ccod = e.inen_ccod  
        join  personas f 
            on b.pers_ncorr = f.pers_ncorr 
        left outer join  personas g 
            on a.pers_ncorr_codeudor = g.pers_ncorr  
        join   abonos h 
            on b.ingr_ncorr = h.ingr_ncorr 
        join   compromisos i 
            on h.tcom_ccod = i.tcom_ccod  
            and h.inst_ccod = i.inst_ccod  
            and h.comp_ndocto = i.comp_ndocto 
     Where i.ecom_ccod <> 3   
        and b.eing_ccod <> 3   
        and a.ding_ncorrelativo > 0    
        and a.ting_ccod in (3,38)   
        AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'01/12/2000',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'30/01/2005',103),convert(datetime,a.ding_fdocto,103))
        and a.edin_ccod in (1,10)
    group by a.edin_ccod,a.banc_ccod,a.ding_ndocto,a.ding_fdocto,d.edin_tdesc,ingr_fpago
) as tabla_contada
group by ding_ndocto
*/

