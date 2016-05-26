select * from ofertas_academicas where CAST (peri_ccod AS VARCHAR) = '238'



select * from ofertas_academicas where CAST (ofer_ncorr AS VARCHAR) = '39394'



BEGIN TRANSACTION

update ofertas_academicas 

set peri_ccod = '238'

where CAST (ofer_ncorr AS VARCHAR) = '39397'

COMMIT