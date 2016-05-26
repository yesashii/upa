select protic.trunc(a.comp_fdocto) as fecha_matricula,d.tdet_tdesc as nombre_curso,
(select ting_tdesc from tipos_ingresos where ting_ccod=(select isnull(protic.documento_asociado_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso, 'ting_ccod'),6))) as docto_pagado,
isnull((select protic.documento_asociado_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso, 'ding_ndocto')),0) as numero_pagado,
isnull((select protic.documento_asociado_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso, 'monto')),0) as monto_docto,
isnull(i.ting_tdesc,'EFECTIVO') as forma_pago,isnull(h.ding_ndocto,0) as numero_documento,cast(isnull(h.ding_mdetalle,g.ingr_mefectivo) as numeric) as abono_pago,
protic.trunc(g.ingr_fpago) as fecha_pago,g.ingr_nfolio_referencia as comprobante, g.mcaj_ncorr as numero_caja,
protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno
from compromisos a 
    join detalle_compromisos b     
		on a.tcom_ccod = b.tcom_ccod        
		and a.inst_ccod = b.inst_ccod        
		and a.comp_ndocto = b.comp_ndocto 
        and a.ecom_ccod = '1'
     join detalles c
        on c.tcom_ccod = b.tcom_ccod        
		and c.inst_ccod = b.inst_ccod        
		and c.comp_ndocto = b.comp_ndocto
     join tipos_detalle d
        on c.tdet_ccod=d.tdet_ccod
     join personas e
        on b.pers_ncorr=e.pers_ncorr
     join abonos f
        on b.tcom_ccod = f.tcom_ccod        
		and b.inst_ccod = f.inst_ccod        
		and b.comp_ndocto = f.comp_ndocto 
        and b.dcom_ncompromiso = f.dcom_ncompromiso
     join ingresos g
        on f.ingr_ncorr=g.ingr_ncorr
        and g.eing_ccod not in (2,3,6) --no trae los nulos
        and g.ting_ccod in (8,10,15,16,17,34,39,46) -- trae solo los ingresados por caja
    left outer join detalle_ingresos h
        on g.ingr_ncorr=h.ingr_ncorr
    left outer join tipos_ingresos i
        on h.ting_ccod=i.ting_ccod
where c.tcom_ccod in (7) --Cursos
and c.tdet_ccod not in (909)
order by d.tdet_tdesc,protic.documento_asociado_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso, 'ding_ndocto'),g.ingr_fpago

