select protic.obtener_rut(c.pers_ncorr),a.ding_ndocto, a.edin_ccod,b.edin_ccod,a.ingr_ncorr,b.ingr_ncorr,c.eing_ccod,c.ingr_ncorr,
a.ding_mdocto,a.ding_mdetalle,a.ding_ncorrelativo, a.audi_tusuario
from detalle_ingresos a, detalle_ingresos b, ingresos c
where a.ting_ccod=b.ting_ccod
and a.ding_ndocto=b.ding_ndocto
and a.edin_ccod<>b.edin_ccod
and a.ingr_ncorr=c.ingr_ncorr
and c.eing_ccod in (1,4)
and a.ting_ccod=3
and a.ding_ncorrelativo=b.ding_ncorrelativo
and a.ding_ncorrelativo=1
and a.edin_ccod=1
and datepart(year,a.ding_fdocto)<=2005
order by c.pers_ncorr,a.ding_ndocto, a.edin_ccod


select * from detalle_ingresos a, ingresos b 
where a.audi_tusuario like 'cheques sin estados'
and a.ingr_ncorr=b.ingr_ncorr