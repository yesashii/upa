select distinct cast(sdes_mmatricula as integer) as d_matricula,cast(sdes_mcolegiatura as integer) as d_colegiatura,
cast(g.sdes_nporc_matricula as numeric) as porcentaje_matricula,cast(g.sdes_nporc_colegiatura as numeric) as porcentaje_colegiatura,
i.ingr_nfolio_referencia as comprobante,i.mcaj_ncorr as caja,
(select tdet_tdesc from tipos_detalle where tdet_ccod=g.stde_ccod) as beneficio,
protic.trunc(convert(datetime,protic.trunc(c.cont_fcontrato),103)) as fecha_asignacion,
protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,
protic.obtener_nombre_carrera(d.ofer_ncorr,'CJ') as carrera,cast(m.aran_mmatricula as numeric) as matricula, cast(m.aran_mcolegiatura as numeric) as arancel, m.aran_nano_ingreso as promocion,
ccos_tcompuesto as  centro_costo, isnull((select pers_tnombre+' '+pers_tape_paterno from personas where cast(pers_nrut as varchar) =g.audi_tusuario), g.audi_tusuario) as autorizado_por
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
join sdescuentos g
    on a.post_ncorr=g.post_ncorr
    and b.ofer_ncorr=g.ofer_ncorr
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
join personas j
    on a.pers_ncorr=j.pers_ncorr
join centros_costos_asignados cc
    on d.sede_ccod=cc.cenc_ccod_sede
    and d.jorn_ccod=cc.cenc_ccod_jornada
    and k.carr_ccod=cc.cenc_ccod_carrera
join centros_costo ck
    on cc.ccos_ccod=ck.ccos_ccod    
where b.peri_ccod in (210)
and c.peri_ccod in (210)
and c.econ_ccod not in (2,3)
and convert(datetime,cont_fcontrato,103) between  convert(datetime,'01/08/2007',103) and convert(datetime,'01/08/2008',103)
order by fecha_asignacion,beneficio

