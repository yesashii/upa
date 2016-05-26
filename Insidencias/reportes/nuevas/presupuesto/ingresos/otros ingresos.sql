select protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre,
cast(sum(f.abon_mabono) as numeric) as monto,g.ingr_nfolio_referencia, protic.trunc(g.ingr_fpago) as fecha,tdet_tdesc as tipo_ingreso,
(select carr_tdesc from carreras where carr_ccod in (protic.OBTENER_CARRERA_INGRESO(g.mcaj_ncorr,g.ting_ccod,g.ingr_nfolio_referencia,b.pers_ncorr))) as carrera,
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
            and f.tcom_ccod not in (1,2,3,4,13,14)
         join ingresos g
            on f.ingr_ncorr=g.ingr_ncorr
            and g.eing_ccod not in (3,6) 
            and g.ting_ccod in (16,34) 
    where a.tcom_ccod not in (1,2,3,4,13,14)
    and c.tdet_ccod not in (909,1230) 
    and convert(datetime,ingr_fpago,103) between  convert(datetime,'01/02/2010',103) and convert(datetime,getdate(),103)
    group by g.ingr_fpago,g.mcaj_ncorr,g.ting_ccod,g.ingr_nfolio_referencia,b.pers_ncorr,c.tdet_ccod,tdet_tdesc