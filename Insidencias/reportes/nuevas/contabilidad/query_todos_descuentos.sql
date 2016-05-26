select distinct convert(datetime,protic.trunc(c.cont_fcontrato),103) as fecha_asignacion,
cast(sdes_mmatricula as integer) as d_matricula,cast(sdes_mcolegiatura as integer) as d_colegiatura,
cast(g.sdes_nporc_matricula as numeric) as porcentaje_matricula,cast(g.sdes_nporc_colegiatura as numeric) as porcentaje_colegiatura,
i.ingr_nfolio_referencia as comprobante,
(select tdet_tdesc from tipos_detalle where tdet_ccod=g.stde_ccod) as beneficio,
protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,
protic.obtener_nombre_carrera(d.ofer_ncorr,'CJ') as carrera
from alumnos a 
join postulantes b
    on a.pers_ncorr=b.pers_ncorr
    and a.post_ncorr=b.post_ncorr
join contratos c
    on a.matr_ncorr=c.matr_ncorr
join ofertas_academicas d
    on b.ofer_ncorr=d.ofer_ncorr
join sdescuentos g
    on a.post_ncorr=g.post_ncorr
    and d.ofer_ncorr=g.ofer_ncorr
 join compromisos f
    on c.cont_ncorr=f.comp_ndocto
    and f.tcom_ccod in (1,2)
 join abonos h
    on f.comp_ndocto=h.comp_ndocto
    and h.tcom_ccod in (1,2)
   -- and h.tcom_ccod in (2)
 join ingresos i
    on h.ingr_ncorr=i.ingr_ncorr
    and i.ting_ccod=7 
where --c.peri_ccod=202
--and b.peri_ccod=202
--and 
--c.econ_ccod not in (2,3)
--and g.esde_ccod in (1,2)
--and 
i.pers_ncorr in (21799)
--and a.pers_ncorr=99846
order by fecha_asignacion

--convert(datetime,protic.trunc(alum_fmatricula),103) as fecha,
--select top 5 * from sdescuentos where post_ncorr=60931

select protic.obtener_rut(pers_ncorr),pers_ncorr,* from ingresos where ingr_nfolio_referencia=90889   