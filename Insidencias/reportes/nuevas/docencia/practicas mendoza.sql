select * from sd_causal_eliminacion where rut in (21757208)
delete from sd_causal_eliminacion where rut in (9832609)

21757208
16021469
select * from malla_curricular where mall_ccod='4974'
select * from planes_estudio where plan_ccod=365
select * from especialidades where espe_ccod=73  
select * from alumnos where matr_ncorr=177439
select * from malla_curricular where plan_ccod=365
select * from malla_curricular where asig_ccod='460450G'


select a.mall_ccod from malla_curricular a,planes_estudio b, alumnos c
where a.plan_ccod=b.plan_ccod
and b.plan_ccod=c.plan_ccod
and c.matr_ncorr=177439

15716065-6

select * from  malla_curricular a,planes_estudio b
where a.plan_ccod=b.plan_ccod
--and b.espe_ccod=199
and a.asig_ccod='402'

select * from planes_estudio where espe_ccod=199
select top 1 * from alumnos 

astrid leon 5334


select  case when convert(varchar,getDate(),103) > convert(datetime,'27/01/2008',103) then 'S' else 'N' end 

10339541

select * from alumnos where matr_ncorr=172346

select * from cargas_academicas where matr_ncorr=159295

select mall_ccod,* from secciones where secc_ccod in (40191,37302)
select * from secciones where asig_ccod='460450G' and peri_ccod=164

select * from carreras

select * from cargas_academicas where sitf_ccod is not null

select * from modalidades

select * from periodos_academicos where anos_ccod=2007