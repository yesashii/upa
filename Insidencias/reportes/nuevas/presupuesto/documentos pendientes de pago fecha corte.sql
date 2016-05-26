select ab.*, ting_tdesc as tipo_docto,e.emat_tdesc as estado_matricula,
protic.obtener_nombre_carrera(c.ofer_ncorr,'CJ') as carrera,i.sede_tdesc as sede_carrera,
protic.obtener_rut(g.pers_ncorr) as rut_apo,protic.obtener_nombre_completo(g.pers_ncorr,'n') as nombres_apo,
protic.obtener_direccion_letra(g.pers_ncorr,1,'CNPB') as direccion_apo,
protic.obtener_direccion_letra(g.pers_ncorr,1,'C-C') as ciudad_comuna,
a.pers_temail as correo_alumno,g.pers_temail as correo_apoderado
from (
    select distinct (select max(matr_ncorr) from alumnos where pers_ncorr=b.pers_ncorr and emat_ccod not in (9)) as matr_ncorr,
    protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,b.mcaj_ncorr as caja, a.ting_ccod, 
    a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,
    protic.trunc(a.ding_fdocto) as fecha_vencimiento,e.edin_tdesc as estado
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
) as ab 
join tipos_ingresos d
    on ab.ting_ccod=d.ting_ccod
left outer join alumnos c
    on ab.matr_ncorr=c.matr_ncorr
left outer join personas a
    on c.pers_ncorr=a.pers_ncorr    
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
where convert(datetime,ab.fecha_vencimiento, 103) <= '20/07/2007'
    and c.emat_ccod in (1)      
order by convert(datetime,ab.fecha_vencimiento, 103) desc,ab.ting_ccod,rut desc