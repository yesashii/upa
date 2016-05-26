select a.*, c.monto
from fox..sd_titulados_por_pagar a, personas b,
    (select b.pers_ncorr,cast(sum(f.abon_mabono) as numeric) as monto,g.ingr_nfolio_referencia
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
                and f.tcom_ccod=4
             join ingresos g
                on f.ingr_ncorr=g.ingr_ncorr
                and g.eing_ccod not in (3,6) --no trae los nulos
                and g.ting_ccod in (16,34) -- trae solo los ingresados por caja
        where a.tcom_ccod in (4)
        and c.tdet_ccod in (1230) --titulaciones
        group by g.ingr_nfolio_referencia,b.pers_ncorr,c.tdet_ccod
    ) as c
where a.rut=b.pers_nrut
and b.pers_ncorr=c.pers_ncorr

