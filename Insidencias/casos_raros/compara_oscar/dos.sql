select rp.repa_ncorr             as pupa_ncorr, 
       (select Sum(ding_mdetalle) 
        from   detalle_ingresos r 
        where  r.repa_ncorr = rp.repa_ncorr 
               and r.ting_ccod = di.ting_ccod 
        group  by ding_mdetalle) as monto_actual, 
       (select Count(*) 
        from   detalle_ingresos r 
        where  r.repa_ncorr = rp.repa_ncorr 
               and r.ting_ccod = di.ting_ccod 
        group  by ding_mdetalle) as num_cuotas, 
       ding_fdocto               as fecha 
from   repactaciones rp, 
       detalle_ingresos di, 
       compromisos com 
where  rp.repa_ncorr = di.repa_ncorr 
       and rp.repa_ncorr = com.comp_ndocto 
       and com.tcom_ccod = 3 
       and di.ting_ccod = 173 
       and Cast(rp.repa_ncorr as varchar) = '771141' 
       and com.ecom_ccod <> 3 