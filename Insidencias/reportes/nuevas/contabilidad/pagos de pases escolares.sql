select protic.obtener_rut(b.pers_ncorr) as rut,cast(sum(f.abon_mabono) as numeric) as monto,
g.ingr_nfolio_referencia as comprobante, g.mcaj_ncorr as caja,protic.trunc(g.ingr_fpago) as fecha_pago
            from compromisos a 
            join detalle_compromisos b     
		        on a.tcom_ccod = b.tcom_ccod        
		        and a.inst_ccod = b.inst_ccod        
		        and a.comp_ndocto = b.comp_ndocto 
                and a.ecom_ccod = '1'
             join detalles c
                on c.tcom_ccod = b.tcom_ccod        
		        and c.inst_ccod = b.inst_ccod        
		        and c.comp_ndocto = b.comp_ndocto
             join tipos_detalle d
                on c.tdet_ccod=d.tdet_ccod
             join personas e
                on b.pers_ncorr=e.pers_ncorr
             join abonos f
                on b.tcom_ccod = f.tcom_ccod        
		        and b.inst_ccod = f.inst_ccod        
		        and b.comp_ndocto = f.comp_ndocto 
                and b.dcom_ncompromiso = f.dcom_ncompromiso
                and f.tcom_ccod=27 -- Tipo comp del Pase
             join ingresos g
                on f.ingr_ncorr=g.ingr_ncorr
                and g.eing_ccod not in (3,6) --no trae los nulos
                and g.ting_ccod in (16,34) -- trae solo los ingresados por caja
        where a.tcom_ccod in (27)
        and c.tdet_ccod in (1224) --Pase esolar
        and convert(datetime,g.ingr_fpago,103) >= convert(datetime,'01-10-2007',103)
        --and g.ingr_fpago <= '01-11-2008'
        group by g.ingr_nfolio_referencia,b.pers_ncorr,c.tdet_ccod,g.mcaj_ncorr,g.ingr_fpago
                