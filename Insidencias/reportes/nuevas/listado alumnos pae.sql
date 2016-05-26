select e.cont_ncorr,e.contrato,cast(d.aran_mcolegiatura as numeric) as arancel,cast(d.aran_mmatricula as numeric) as matricula,
protic.obtener_rut(a.pers_ncorr) as rut_alumno,b.pers_tnombre,b.pers_tape_paterno,pers_tape_materno,
protic.trunc(alum_fmatricula) as fecha_matricula ,protic.obtener_nombre_carrera(a.ofer_ncorr,'CEJ') as carrera,
(select top 1 b.mcaj_ncorr from abonos a, ingresos b where a.comp_ndocto=e.cont_ncorr and a.tcom_ccod in (1,2)
and a.ingr_ncorr=b.ingr_ncorr and b.ting_ccod=7) as Caja,
(select top 1 b.ingr_nfolio_referencia from abonos a, ingresos b where a.comp_ndocto=e.cont_ncorr and a.tcom_ccod in (1,2)
and a.ingr_ncorr=b.ingr_ncorr and b.ting_ccod=7) as Comprobante
from alumnos a, personas b, ofertas_academicas c, aranceles d, contratos e
where a.ofer_ncorr in (13684,13685,14442,14441)
and a.emat_ccod not in (9)
and a.pers_ncorr=b.pers_ncorr
and a.ofer_ncorr=c.ofer_ncorr
and c.aran_ncorr=d.aran_ncorr
and a.matr_ncorr=e.matr_ncorr
and a.post_ncorr=e.post_ncorr



select top 1 b.mcaj_ncorr from abonos a, ingresos b
where a.comp_ndocto=64749 
and a.tcom_ccod in (1,2)
and a.ingr_ncorr=b.ingr_ncorr
and b.ting_ccod=7


--aranceles
caja
comprobante
n contrato.
fecha comprobante.

select * from estados_matriculas

