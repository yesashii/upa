select distinct protic.obtener_rut(a.pers_ncorr) as rut,cont_ncorr as compromiso,i.emat_tdesc as estado_matricula,
g.ting_tdesc as docto,f.ding_ndocto as nro_docto,cast(f.ding_mdocto as numeric) as monto, h.edin_tdesc as estado,
protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ')  as carrera
from alumnos a, contratos b, compromisos c, abonos d, ingresos e, detalle_ingresos f, 
tipos_ingresos g, estados_detalle_ingresos h, estados_matriculas i
where a.matr_ncorr=b.matr_ncorr
    and b.peri_ccod=206
    and b.cont_ncorr=c.comp_ndocto
    and c.comp_ndocto=d.comp_ndocto
    and c.tcom_ccod=d.tcom_ccod
    and c.inst_ccod=d.inst_ccod
    and d.ingr_ncorr=e.ingr_ncorr
    and e.ting_ccod=7
    and e.ingr_ncorr=f.ingr_ncorr
    and f.ting_ccod=g.ting_ccod
    and f.edin_ccod=h.edin_ccod
    and a.emat_ccod=i.emat_ccod
    and a.emat_ccod not in (1)
    

