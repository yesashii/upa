select ab.*,bb.banc_tdesc as banco, ting_tdesc as tipo_docto,e.emat_tdesc as estado_matricula,
protic.obtener_nombre_carrera(c.ofer_ncorr,'CJ') as carrera,i.sede_tdesc as sede_carrera,ii.sede_tdesc as sede_actual,
protic.obtener_rut(g.pers_ncorr) as rut_apo,protic.obtener_nombre_completo(g.pers_ncorr,'n') as nombres_apo,
protic.obtener_direccion_letra(g.pers_ncorr,1,'CNPB') as direccion_apo,
protic.obtener_direccion_letra(g.pers_ncorr,1,'C-C') as comuna_ciudad
from (
    select distinct (select max(matr_ncorr) from alumnos where pers_ncorr=b.pers_ncorr and emat_ccod not in (9)) as matr_ncorr,
    protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,b.mcaj_ncorr as caja, a.ting_ccod, 
    a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto, protic.documento_pagado_x_otro(a.ingr_ncorr,a.ding_bpacta_cuota,'S') as abonado,
    a.banc_ccod, protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado, 
    isnull(a.sede_actual,(select sede_ccod  from movimientos_cajas where mcaj_ncorr=b.mcaj_ncorr)) as sede_actual
    from detalle_ingresos a, ingresos b , abonos c, compromisos d, estados_detalle_ingresos e
    where a.edin_ccod not in (6,11,16)
    and a.ting_ccod in (3,4,13,14,38,51,52)
    and a.ingr_ncorr=b.ingr_ncorr
    and b.eing_ccod not in (3,6)
    and mcaj_ncorr > 1
    and b.ingr_ncorr=c.ingr_ncorr
    and c.comp_ndocto=d.comp_ndocto
    and c.tcom_ccod=d.tcom_ccod
    and c.inst_ccod=d.inst_ccod
    and d.ecom_ccod=1
    and a.edin_ccod=e.edin_ccod
    --and b.pers_ncorr in (16120)
    --and convert(datetime,a.ding_fdocto,103) <= convert(datetime,getdate(),103)
    and convert(datetime,a.ding_fdocto,103) <= convert(datetime,'31/05/2009',103)
) as ab 
join tipos_ingresos d
    on ab.ting_ccod=d.ting_ccod
left outer join alumnos c
    on ab.matr_ncorr=c.matr_ncorr
left outer join estados_matriculas e
    on c.emat_ccod=e.emat_ccod
left outer join codeudor_postulacion f
    on c.post_ncorr=f.post_ncorr
left outer join personas g
    on f.pers_ncorr=g.pers_ncorr
left outer join ofertas_academicas h
    on  c.ofer_ncorr=h.ofer_ncorr   
left outer join sedes i
    on h.sede_ccod=i.sede_ccod
left outer join sedes ii
    on ab.sede_actual=ii.sede_ccod
left outer join bancos bb
    on ab.banc_ccod=bb.banc_ccod                
order by ab.ting_ccod,rut desc


