select distinct  protic.es_moroso_monto(a.pers_ncorr, '07/07/2009') as monto_deuda,
protic.obtener_rut(a.pers_ncorr) as rut_alumno, a.pers_tnombre as nombre, 
a.pers_tape_paterno as ap_paterno, a.pers_tape_materno as ap_materno, 
a.pers_temail as correo_alumno,g.pers_temail as correo_apoderado,
protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB') as direccion, 
protic.obtener_direccion_letra(a.pers_ncorr,1,'C-C') as comuna_ciudad,
protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') as carrera, e.sede_tdesc as sede_carrera
from personas a, alumnos b, ofertas_academicas c , contratos d, sedes e, codeudor_postulacion f, personas g
where a.pers_ncorr=b.pers_ncorr
and b.ofer_ncorr=c.ofer_ncorr
and b.emat_ccod not in (9)
and b.matr_ncorr=d.matr_ncorr
and c.sede_ccod=e.sede_ccod
and b.post_ncorr=f.post_ncorr
and f.pers_ncorr=g.pers_ncorr
and protic.es_moroso(a.pers_ncorr, '07/07/2009')='S'


select protic.obtener_nombre_carrera(
(select top 1 c.ofer_ncorr
from compromisos a, contratos b, postulantes c 
where a.tcom_ccod=2
and a.comp_ndocto=b.cont_ncorr
and b.post_ncorr=c.post_ncorr
and c.peri_ccod=214
and a.ecom_ccod=1),'CJ')


17684632

comp_ndocto,109434 
