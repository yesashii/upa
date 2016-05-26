-- ver letras por mes
select *,protic.trunc(ding_fdocto),ingr_ncorr,edin_ccod, ding_ndocto
from detalle_ingresos where envi_ncorr in (39675)
and datepart(month,ding_fdocto)<=4
and datepart(year,ding_fdocto)=2011


-- Quita letras por mes de un deposito
delete from detalle_envios 
    where ingr_ncorr in (
                select ingr_ncorr
                from detalle_ingresos where envi_ncorr=6326
                and datepart(month,ding_fdocto)=7
                and datepart(year,ding_fdocto)=2006
    )

update detalle_ingresos set audi_tusuario='quita mes julio', envi_ncorr=null
    where envi_ncorr=6326
      and datepart(month,ding_fdocto)=7
      and datepart(year,ding_fdocto)=2006

--**************************************************************************
