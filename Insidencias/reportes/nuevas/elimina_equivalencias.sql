select * from cargas_academicas where matr_ncorr=190700
select * from cargas_academicas where matr_ncorr=190353
select * from cargas_academicas where matr_ncorr=177868
select * from cargas_academicas where matr_ncorr=160344


select * from equivalencias where secc_ccod in (
    select secc_ccod from secciones where asig_ccod='FFFDD004'
)
and matr_ncorr=160344


--delete from equivalencias where matr_ncorr=201046 and secc_ccod=44675 


delete from equivalencias where secc_ccod in (
    select secc_ccod from secciones where asig_ccod='FFFDD004'
)
and matr_ncorr=160344




