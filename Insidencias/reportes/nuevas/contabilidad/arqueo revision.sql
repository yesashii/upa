Select  a.envi_ncorr, a.ding_ndocto,a.banc_ccod, d.edin_tdesc, convert(varchar,b.ingr_fpago,103) as ingr_fpago, 
        convert(varchar,a.ding_fdocto,103) as ding_fdocto, b.ingr_mdocto as ding_mdocto, 
        protic.obtener_rut(b.pers_ncorr) as rut_alumno, 
        protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado, 
        case d.udoc_ccod when 2 then e.inen_tdesc else 
 case when(a.edin_ccod =12 or a.edin_ccod=6) then e.inen_tdesc end end as institucion, 
 b.ingr_nfolio_referencia as comprobante, b.mcaj_ncorr as caja 
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
    and b.eing_ccod not in (1,3)   
    and a.ding_ncorrelativo > 0    
    and a.ting_ccod in (3,38)   
    AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'01/12/2000',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'30/01/2004',103),convert(datetime,a.ding_fdocto,103))
    and a.edin_ccod in (1)
order by a.edin_ccod,a.banc_ccod,a.ding_ndocto asc, a.ding_fdocto asc, b.ingr_fpago asc
