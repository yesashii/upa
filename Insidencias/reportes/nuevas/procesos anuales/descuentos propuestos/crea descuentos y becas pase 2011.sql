-- alumnos con pase de matricula, se deja el descuento propuesto y no activo
-- PASE MATRICULA
insert into sdescuentos
select cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,2 as esde_ccod , 0 as sdes_mmatricula,
    cast(aran_mcolegiatura*(porcentaje) as numeric) as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje*100 as decimal(4,2) )as sdes_nporc_colegiatura,
    'Debe confirmar Pase Matricula y/o Becas' sdes_tobservaciones,'propone beca existente 2011' audi_tusuario, getdate() audi_fmodificacion
    from sd_renovantes_becas_pase_2011 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tipo_descuento= d.tdet_ccod
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=222
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=222
            and emat_ccod not in (13,4,8,9))
    and c.post_ncorr not in (
           select sd.post_ncorr from sdescuentos sd
            where stde_ccod not in (a.tipo_descuento)
            and post_ncorr=c.post_ncorr)         
            
            

--update SDESCUENTOS set sdes_tobservaciones='Debe confirmar Pase Matricula y/o Becas' WHERE POST_NCORR IN (
select * from sdescuentos 
WHERE POST_NCORR IN (
select c.post_ncorr
    from sd_renovantes_becas_pase_2011 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tipo_descuento= d.tdet_ccod
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=222
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=222
            and emat_ccod not in (13,4,8,9))
    and c.post_ncorr not in (
           select sd.post_ncorr from sdescuentos sd
            where stde_ccod not in (a.tipo_descuento)
            and post_ncorr=c.post_ncorr)         
)            