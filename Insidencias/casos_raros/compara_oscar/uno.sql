select rp.repa_ncorr          as pupa_ncorr, 
       (select Sum(repa_mrepactacion) 
        from   repactaciones r 
        where  r.repa_ncorr = rp.repa_ncorr 
        group  by repa_ncorr) as monto_actual, 
       (select Count(*) 
        from   repactaciones r 
        where  r.repa_ncorr = rp.repa_ncorr 
        group  by repa_ncorr) as num_cuotas, 
       ding_fdocto            as fecha 
from   repactaciones rp, 
       detalle_ingresos di, 
       compromisos com 
where  rp.repa_ncorr = di.repa_ncorr 
       and rp.repa_ncorr = com.comp_ndocto 
       and com.tcom_ccod = 3 
       and di.ting_ccod = 173 
       and Cast(rp.repa_ncorr as varchar) = '771141' 
       and com.ecom_ccod <> 3 