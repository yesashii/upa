Select b.ting_ccod,sum(cast(a.ingr_mtotal as integer)) as monto_total,
c.ting_tdesc, count(a.pers_ncorr) as cantidad_alumno,
protic.es_nuevo_institucion(a.pers_ncorr,'164') as nuevo
From ingresos a, detalle_ingresos b, tipos_ingresos c, alumnos d , ofertas_academicas e, carreras f, especialidades g
Where a.ingr_ncorr=b.ingr_ncorr
    and b.ting_ccod=c.ting_ccod
    and b.ting_ccod in (
                    select ting_ccod 
                    from tipos_ingresos 
                    where ting_bregularizacion='S'
                    )
    and a.pers_ncorr=d.pers_ncorr
    and d.ofer_ncorr=e.ofer_ncorr
    and e.espe_ccod=g.espe_ccod
    and g.carr_ccod=f.carr_ccod
    group by b.ting_ccod,c.ting_tdesc,protic.es_nuevo_institucion(a.pers_ncorr,'164')
    
    


