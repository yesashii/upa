select ting_tdesc,sum(ingr_mtotal) as total,protic.obtener_rut(pers_ncorr) as rut, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_alumno
from (
    select e.ting_tdesc,c.ingr_mtotal,b.pers_ncorr
    from sd_alumnos_regularizados a, personas b, ingresos c, detalle_ingresos d, tipos_ingresos e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and c.ingr_ncorr=d.ingr_ncorr
    and d.ting_ccod=e.ting_ccod
    and c.eing_ccod not in(3,6)
    and d.ting_ccod in ( select ting_ccod 
                        from tipos_ingresos 
                        where ting_bregularizacion='S' )
 ) aa
 
group by  ting_tdesc,pers_ncorr

