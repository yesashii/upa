
select * from CARRERAS where carr_ccod = 32 like '%foto%'



Select isnull(anos_pase_matricula,0) from carreras where cast(carr_ccod as varchar)='32'

-- diferencia_carrera : 2



select * from CARRERAS  where CARR_TDESC like '%psico%'  

select * from CARRERAS where carr_ccod = 32





-- --------------------------------------

select * from CARRERAS where carr_ccod = 32


update top(2) CARRERAS
set anos_pase_matricula = 2
where carr_ccod = 32













select a.stde_ccod, b.stde_ccod,
a.post_ncorr, 
a.ofer_ncorr, 
isnull(a.sdes_nporc_matricula,0) as sdes_nporc_matricula, 
isnull(a.sdes_nporc_colegiatura,0) as sdes_nporc_colegiatura, 
a.esde_ccod, b.stde_tdesc, isnull(a.sdes_mmatricula,0) as sdes_mmatricula, 
isnull(a.sdes_mcolegiatura,0) as sdes_mcolegiatura, isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as subtotal, 
a.sdes_tobservaciones 
from sdescuentos a, 
stipos_descuentos b, 
postulantes c 
where a.stde_ccod = b.stde_ccod 
and a.post_ncorr = c.post_ncorr 
and a.ofer_ncorr = c.ofer_ncorr 
and c.post_ncorr = 253397--'252949' 


select * from sdescuentos where post_ncorr = 253397

select * from sdescuentos where post_ncorr = 252949


select * from pase_matricula where post_ncorr = 252949

select * from pase_matricula where post_ncorr = 253397




update top(2) pase_matricula
set post_ncorr = 252949
where post_ncorr = 253397
and pama_ncorr = 18434



update top(2) sdescuentos
set post_ncorr = 252949, sdes_tobservaciones = 'HASTA 2 ASIGNATURAS'
where post_ncorr = 253397
and stde_ccod = 1385

select * from stipos_descuentos where stde_ccod = 1262








