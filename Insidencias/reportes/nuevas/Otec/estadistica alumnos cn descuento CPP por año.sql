 
 /*
 Query que entrega el total de alumnos matriculados con compromisos activos por año y que han optado a un descuento de CPP
 
 */
 select tdet_tdesc as descuento,anio_admision as año_matricula,count(pote_ncorr) as cantidad_alumnos  
 from postulacion_otec pot,datos_generales_secciones_otec dgot,ofertas_otec oot, tipos_detalle td   
 where pot.dgso_ncorr=dgot.dgso_ncorr  
 and dgot.dcur_ncorr=oot.dcur_ncorr  
 --and anio_admision= 2012
 and pot.epot_ccod in (3,4) 
 and pot.tdet_ccod in (1332)
 and td.TDET_CCOD=pot.tdet_ccod
 and pot.comp_ndocto is not null
 group by tdet_tdesc,anio_admision


-- Validado contra compromiso activo
 select tdet_tdesc as descuento,anio_admision as año_matricula,count(pote_ncorr) as cantidad_alumnos  
 from postulacion_otec pot,datos_generales_secciones_otec dgot,ofertas_otec oot, tipos_detalle td, compromisos cp  
 where pot.dgso_ncorr=dgot.dgso_ncorr  
 and dgot.dcur_ncorr=oot.dcur_ncorr  
 --and anio_admision= 2012
 and pot.epot_ccod in (3,4) 
 and pot.tdet_ccod in (1332)
 and td.TDET_CCOD=pot.tdet_ccod
 and pot.comp_ndocto=cp.COMP_NDOCTO
 and cp.ECOM_CCOD=1
 and cp.TCOM_CCOD=7
 group by tdet_tdesc,anio_admision