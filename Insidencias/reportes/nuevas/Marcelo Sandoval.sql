select * from cargas_academicas where matr_ncorr=190658---------------------lyon
select * from secciones where asig_ccod='FGODD002' and peri_ccod=214--------lyon
insert into cargas_academicas (matr_ncorr,secc_ccod,audi_tusuario,audi_fmodificacion)
values (190658,42803,'solicitud MTMerino',getDate())
--------------------------------------------------------------------

select * from cargas_academicas where matr_ncorr=190658---------------------lyon
select * from secciones where asig_ccod='FFFDD001' and peri_ccod=214--------lyon
--------------------------------------------------------------------

select * from cargas_academicas where matr_ncorr=189685---------------------lyon
select * from secciones where asig_ccod='FGODD002' and peri_ccod=214--------lyon
--------------------------------------------------------------------

select * from carreras

select distinct cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut,d.pers_tnombre as nombre, d.pers_tape_paterno + ' ' + d.pers_tape_materno as apellidos,
e.susu_tlogin as login, e.susu_tclave as clave,
(select lower(email_upa) from sd_cuentas_email_totales tt where tt.rut=d.pers_nrut) as email 
from bloques_profesores a, bloques_horarios b, secciones c,personas d,sis_usuarios e
where a.bloq_ccod=b.bloq_ccod and b.secc_ccod=c.secc_ccod
and c.carr_ccod='41' and c.peri_ccod=214 and a.tpro_ccod=1
and a.pers_ncorr=d.pers_ncorr and d.pers_ncorr=e.pers_ncorr