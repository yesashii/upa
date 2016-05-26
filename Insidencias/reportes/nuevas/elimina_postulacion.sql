
select * from detalle_postulantes where post_ncorr in (104962)
select * from codeudor_postulacion where post_ncorr in (104704)
select * from grupo_familiar where post_ncorr in (104962)
select * from contratos where post_ncorr  in (104962)
select * from postulantes where post_ncorr  in (104962)
select * from alumnos where post_ncorr  in (104962)

select * from personas_postulante where pers_ncorr in (103187,103212,103215,103218,103221,103223,103227,103228,103235,103239,103241)

delete from detalle_postulantes where post_ncorr in (173643)
delete from codeudor_postulacion where post_ncorr in (173643)
delete from grupo_familiar where post_ncorr in (173643)
delete from contratos where post_ncorr in (173643)
delete from postulantes where post_ncorr in (173643)
delete from alumnos where post_ncorr in (173643)
--delete from personas_postulante where pers_ncorr in (63595,63596,63597,63598,63599)



select * from detalle_ingresos where ding_ndocto=9082171