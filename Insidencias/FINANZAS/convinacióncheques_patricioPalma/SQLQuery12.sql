


select * from spagos where POST_NCORR = 252875


select b.*

/*a.post_ncorr, a.ofer_ncorr, b.spag_mmatricula, b.spag_mcolegiatura, b.spag_mmatricula + b.spag_mcolegiatura as total */
from postulantes a, 
spagos b 
where a.post_ncorr = b.post_ncorr 
  and a.ofer_ncorr = b.ofer_ncorr 
  and a.post_ncorr = '252875'
  
 update spagos
 set SPAG_MCOLEGIATURA =  4048800
where POST_NCORR = 252875
