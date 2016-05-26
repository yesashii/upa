Select e.ting_tdesc as docto, a.ding_ndocto,k.banc_tdesc as banco, d.edin_tdesc, convert(varchar,b.ingr_fpago,103) as ingr_fpago, 
        convert(varchar,a.ding_fdocto,103) as ding_fdocto, 
        cast(b.ingr_mdocto as numeric) as ding_mdocto,
        protic.obtener_rut(b.pers_ncorr) as rut_alumno, 
        b.ingr_nfolio_referencia as comprobante, b.mcaj_ncorr as caja ,(select sede_tdesc from sedes where sede_ccod=isnull(sede_actual,j.sede_ccod)) as sede_actual
 From detalle_ingresos a 
    join   ingresos b 
        on a.ingr_ncorr = b.ingr_ncorr 
    left outer join   envios c 
        on a.envi_ncorr = c.envi_ncorr 
    join   estados_detalle_ingresos d 
        on a.edin_ccod = d.edin_ccod 
    left outer join   tipos_ingresos e 
        on a.ting_ccod = e.ting_ccod  
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
    join movimientos_cajas j
        on b.mcaj_ncorr=j.mcaj_ncorr
left outer join bancos k
    on a.banc_ccod=k.banc_ccod                
 Where i.ecom_ccod <> 3   
    and b.eing_ccod not in (1,3)   
    and a.ding_ncorrelativo > 0    
    and a.ting_ccod in (3,4,38,52)   
    AND convert(datetime,b.ingr_fpago,103) BETWEEN  isnull(convert(datetime,'31/12/2007',103),convert(datetime,b.ingr_fpago,103)) and isnull(convert(datetime,'01/01/2008',103),convert(datetime,b.ingr_fpago,103))
    --and a.edin_ccod in (1)
order by a.edin_ccod,a.banc_ccod,a.ding_ndocto asc, a.ding_fdocto asc, b.ingr_fpago asc
