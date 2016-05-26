select distinct cast(sdes_mmatricula as integer) as d_matricula,cast(sdes_mcolegiatura as integer) as d_colegiatura,
cast(g.sdes_nporc_matricula as numeric) as porcentaje_matricula,cast(g.sdes_nporc_colegiatura as numeric) as porcentaje_colegiatura,
i.ingr_nfolio_referencia as comprobante,i.mcaj_ncorr as caja,
(select tdet_tdesc from tipos_detalle where tdet_ccod=g.stde_ccod) as beneficio,
protic.trunc(convert(datetime,protic.trunc(c.cont_fcontrato),103)) as fecha_asignacion,
protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,
protic.obtener_nombre_carrera(d.ofer_ncorr,'CJ') as carrera,
cast((select comp_mneto from compromisos where comp_ndocto=f.comp_ndocto and tcom_ccod=1) as numeric) as neto_matricula,
cast((select comp_mneto from compromisos where comp_ndocto=f.comp_ndocto and tcom_ccod=2) as numeric) as neto_arancel,
cast(m.aran_mmatricula as numeric) as matricula, cast(m.aran_mcolegiatura as numeric) as arancel, 
m.aran_nano_ingreso as promocion, o.ccos_tcompuesto as centro_costo, emat_tdesc as estado_matricula
from alumnos a 
join postulantes b
    on a.pers_ncorr=b.pers_ncorr
    and a.post_ncorr=b.post_ncorr
join contratos c
    on a.matr_ncorr=c.matr_ncorr
join ofertas_academicas d
    on b.ofer_ncorr=d.ofer_ncorr
join aranceles m
    on d.aran_ncorr=m.aran_ncorr    
join especialidades k
    on d.espe_ccod=k.espe_ccod     
left outer join sdescuentos g
    on a.post_ncorr=g.post_ncorr
    and d.ofer_ncorr=g.ofer_ncorr
    and g.esde_ccod in (1)
 join compromisos f
    on c.cont_ncorr=f.comp_ndocto
    and f.tcom_ccod in (1,2)
 join abonos h
    on f.comp_ndocto=h.comp_ndocto
    and h.tcom_ccod in (1,2)
 join ingresos i
    on h.ingr_ncorr=i.ingr_ncorr
    and i.ting_ccod=7
    --and i.ingr_nfolio_referencia=105944
join personas j
    on a.pers_ncorr=j.pers_ncorr  
left outer join centros_costos_asignados n
    on k.carr_ccod= n.cenc_ccod_carrera
    and d.sede_ccod=n.cenc_ccod_sede
    and d.jorn_ccod=n.cenc_ccod_jornada
left outer join centros_costo o
    on n.ccos_ccod=o.ccos_ccod   
join estados_matriculas p
    on a.emat_ccod= p.emat_ccod          
where b.peri_ccod in (206,208)
and c.peri_ccod in (206,208)
and c.econ_ccod not in (2,3)
and convert(datetime,cont_fcontrato,103) between  convert(datetime,'01/10/2006',103) and convert(datetime,'01/08/2007',103)
order by fecha_asignacion,beneficio,rut
