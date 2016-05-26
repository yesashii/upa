SELECT b.*
FROM   detalle_ingresos a (nolock) 
       JOIN ingresos b (nolock) 
         ON a.ingr_ncorr = b.ingr_ncorr 
       JOIN movimientos_cajas m (nolock) 
         ON b.mcaj_ncorr = m.mcaj_ncorr 
       JOIN abonos c (nolock) 
         ON b.ingr_ncorr = c.ingr_ncorr 
       JOIN compromisos d (nolock) 
         ON c.tcom_ccod = d.tcom_ccod 
            AND c.inst_ccod = d.inst_ccod 
            AND c.comp_ndocto = d.comp_ndocto 
            AND c.pers_ncorr = d.pers_ncorr 
       LEFT OUTER JOIN bancos e 
                    ON a.banc_ccod = e.banc_ccod 
       LEFT OUTER JOIN envios f 
                    ON a.envi_ncorr = f.envi_ncorr 
       JOIN estados_detalle_ingresos g 
         ON a.edin_ccod = g.edin_ccod 
       JOIN personas h (nolock) 
         ON b.pers_ncorr = h.pers_ncorr 
       LEFT OUTER JOIN personas i (nolock) 
                    ON a.pers_ncorr_codeudor = i.pers_ncorr 
WHERE  d.ecom_ccod <> 3 
       AND a.ting_ccod IN ( 3, 38, 14 ) 
       AND a.ding_ncorrelativo >= 1 
       AND b.eing_ccod <> 3 
       AND h.pers_nrut = '17085007' 
       AND a.ding_ndocto = '640' 
ORDER  BY a.ding_fdocto ASC, 
          a.ding_ndocto ASC, 
          a.ding_ncorrelativo 

-- ------------------------------

ingr_ncorr : 348942



select * from INGRESOS where ingr_ncorr = 348942

select * from DETALLE_INGRESOS where ingr_ncorr = 348942

select * from abonos where ingr_ncorr = 348942


delete top(1) from INGRESOS where ingr_ncorr = 348942

delete top(1) from DETALLE_INGRESOS where ingr_ncorr = 348942

delete top(1) from abonos where ingr_ncorr = 348942













