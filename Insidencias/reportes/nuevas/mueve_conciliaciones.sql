--update ingresos set mcaj_ncorr=1617, audi_tusuario='mov.dep.ja 02/11' 
where ingr_ncorr in (
   select ingr_ncorr from detalle_ingresos 
    where ding_ndocto in (
                        select b.ding_nsecuencia 
                        from detalle_envios a, detalle_ingresos b 
                        where a.envi_ncorr in (3965)
                        and a.ingr_ncorr=b.ingr_ncorr
                        )
    and ting_ccod=8
)



select * from ingresos 
where ingr_ncorr in (
   select ingr_ncorr from detalle_ingresos 
    where ding_ndocto in (
                        select b.edin_ccod,b.ding_nsecuencia 
                        from detalle_envios a, detalle_ingresos b 
                        where a.envi_ncorr in (3965)
                        and a.ingr_ncorr=b.ingr_ncorr
                        )
    and ting_ccod=8
)



select * from detalle_ingresos where ding_nsecuencia=99040441 --and ting_ccod=8

select * from detalle_ingresos where ding_ndocto=99040439 and ting_ccod=8

select * from ingresos where mcaj_ncorr=1509

select * from ingresos where ingr_ncorr=103879


