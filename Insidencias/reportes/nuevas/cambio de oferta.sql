----------Buscar datos relacionados a la Oferta
select ofer_ncorr,* from alumnos where post_ncorr=210602            
select ofer_ncorr,peri_ccod,* from postulantes where post_ncorr=210602
select ofer_ncorr,* from detalle_postulantes where post_ncorr=210602

select ofer_ncorr,* from sdescuentos where post_ncorr=210602
select ofer_ncorr,* from spagos where post_ncorr=210602
select ofer_ncorr,* from sdetalles_forma_pago where post_ncorr=210602
select ofer_ncorr,* from sdetalles_pagos where post_ncorr=210602

select ofer_ncorr,peri_ccod,* from compromisos where post_ncorr=210602

select ofer_ncorr,peri_ccod,* from pase_matricula where post_ncorr=210602
select ofer_ncorr,* from solicitud_seguro_escolaridad where post_ncorr=210602


-- para cambiar de carrera a un alumno sin crear otro contrato.
-- usado para las educaciones que se cambian a pedagogias 
update alumnos                      set ofer_ncorr=34116, audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()    where post_ncorr in (210602) and ofer_ncorr=33791
update postulantes                  set ofer_ncorr=34116, audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()    where post_ncorr in (210602) and ofer_ncorr=33791
update detalle_postulantes          set ofer_ncorr=34116, audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()    where post_ncorr in (210602) and ofer_ncorr=33791
update sdescuentos                  set ofer_ncorr=34116, audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()    where post_ncorr in (210602) and ofer_ncorr=33791
update spagos                       set ofer_ncorr=34116, audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()    where post_ncorr in (210602) and ofer_ncorr=33791
update sdetalles_forma_pago         set ofer_ncorr=34116, audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()    where post_ncorr in (210602) and ofer_ncorr=33791
update sdetalles_pagos              set ofer_ncorr=34116, audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()    where post_ncorr in (210602) and ofer_ncorr=33791
update compromisos                  set ofer_ncorr=34116, audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()    where post_ncorr in (210602) and ofer_ncorr=33791
update pase_matricula               set ofer_ncorr=34116, audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()    where post_ncorr in (210602) and ofer_ncorr=33791
update solicitud_seguro_escolaridad set ofer_ncorr=34116, audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()    where post_ncorr in (210602) and ofer_ncorr=33791

--Modificar solo si en informacion alumno no estan cuadrados (encasillados) los planes con la especialidad
update alumnos set plan_ccod = (
    select top 1 plan_ccod from planes_estudio where espe_ccod in (select espe_ccod from ofertas_academicas where ofer_ncorr in (34116))
), audi_tusuario='mr cambia oferta TS (V)', audi_fmodificacion=getdate()  
where post_ncorr in (210602)

-- CONSULTAS DE ACTUALIZACION DE PERIODOS ASOCIADOS EN COMPROMISOS
select * from  abonos where     (comp_ndocto = 118602) and (tcom_ccod in (1, 2))
update abonos set peri_ccod=224 where     (comp_ndocto = 118602) and (tcom_ccod in (1, 2))
update detalle_compromisos set peri_ccod=224 where     (comp_ndocto = 118602) and (tcom_ccod in (1, 2))
 