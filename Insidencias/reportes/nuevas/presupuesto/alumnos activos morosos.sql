select ab.*, ting_tdesc as tipo_docto,e.emat_tdesc as estado_matricula,
protic.obtener_nombre_carrera(c.ofer_ncorr,'CJ') as carrera,i.sede_tdesc as sede_carrera,
protic.obtener_rut(g.pers_ncorr) as rut_apo,protic.obtener_nombre_completo(g.pers_ncorr,'n') as nombres_apo,
protic.obtener_direccion_letra(g.pers_ncorr,1,'CNPB') as direccion_apo,
protic.obtener_direccion_letra(g.pers_ncorr,1,'C-C') as ciudad_comuna,
a.pers_temail as correo_alumno,g.pers_temail as correo_apoderado
from (
    select distinct b.pers_ncorr,
    protic.obtener_rut(b.pers_ncorr) as rut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre ,b.mcaj_ncorr as caja, a.ting_ccod, 
    a.ding_ndocto as num_docto, cast(a.ding_mdocto as numeric) as monto,protic.total_recepcionar_cuota(c.tcom_ccod,c.inst_ccod,c.comp_ndocto,c.dcom_ncompromiso) as saldo,
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
    and convert(datetime,a.ding_fdocto,103)< convert(datetime,getdate(),103)
    and protic.total_recepcionar_cuota(c.tcom_ccod,c.inst_ccod,c.comp_ndocto,c.dcom_ncompromiso) > 0
) as ab 
join tipos_ingresos d
    on ab.ting_ccod=d.ting_ccod
join alumnos c
    on ab.pers_ncorr=c.pers_ncorr
join personas a
    on c.pers_ncorr=a.pers_ncorr    
join estados_matriculas e
    on c.emat_ccod=e.emat_ccod
join codeudor_postulacion f
    on c.post_ncorr=f.post_ncorr
join personas g
    on f.pers_ncorr=g.pers_ncorr
join ofertas_academicas h
    on  c.ofer_ncorr=h.ofer_ncorr
    --and h.peri_ccod=212   
join sedes i
    on h.sede_ccod=i.sede_ccod  
where c.emat_ccod in (1)      
order by convert(datetime,ab.fecha_vencimiento, 103) desc,ab.ting_ccod,rut desc

