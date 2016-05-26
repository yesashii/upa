select * from ordenes_compras_otec where nord_compra in (16,39,201001,201002,201003,201004,201005,201006,201007,201008)
and empr_ncorr=150663
and dgso_ncorr not in (402)

select * from tipos_ingresos

select ding_ndocto, edin_ccod, ding_mdocto 
from detalle_ingresos a, ingresos b 
where ding_ndocto in (16,39,201001,201002,201003,201004,201005,201006,201007,201008)
and a.ting_ccod=5
and a.ingr_ncorr=b.ingr_ncorr
and a.ingr_ncorr not in (572820,572822)


select  dcur_tdesc,protic.obtener_rut(pers_ncorr) as rut_alumno, 
protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_alumno,edin_ccod,ocot_monto_empresa,norc_empresa 
from postulacion_otec a, datos_generales_secciones_otec b, diplomados_cursos c, ordenes_compras_otec d, 
(
    select ding_ndocto, edin_ccod, ding_mdocto 
    from detalle_ingresos a, ingresos b 
    where ding_ndocto in (16,39,201001,201002,201003,201004,201005,201006,201007,201008)
    and a.ting_ccod=5
    and a.ingr_ncorr=b.ingr_ncorr
    and a.ingr_ncorr not in (572820,572822)
) as di
where norc_empresa in (16,39,201001,201002,201003,201004,201005,201006,201007,201008)
and a.dgso_ncorr not in (402)
and a.dgso_ncorr=b.dgso_ncorr
and b.dcur_ncorr=c.dcur_ncorr
and norc_empresa=d.nord_compra
and d.empr_ncorr=150663
and d.dgso_ncorr not in (402)
and di.ding_ndocto=d.nord_compra
order by norc_empresa,rut_alumno


