--############## PAGO DE PASE ESCOLAR SEGUN LISTADO ################
select a.*, c.monto as monto_pagado,ingr_nfolio_referencia as comprobante,mcaj_ncorr as caja,protic.trunc(ingr_fpago) as fecha_pago
from sd_rut_malos_dae a, personas b,
    (select b.pers_ncorr,cast(sum(f.abon_mabono) as numeric) as monto,g.ingr_nfolio_referencia, g.mcaj_ncorr,g.ingr_fpago
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
        and g.ingr_fpago >= '01-11-2006'
        group by g.ingr_nfolio_referencia,b.pers_ncorr,c.tdet_ccod,g.mcaj_ncorr,g.ingr_fpago
    ) as c
where a.rut=b.pers_nrut
and b.pers_ncorr=c.pers_ncorr


/*
select *
from sd_rut_malos_dae
where rut not in (
    select rut
    from sd_rut_malos_dae a, personas b
    where a.rut=b.pers_nrut
)*/

