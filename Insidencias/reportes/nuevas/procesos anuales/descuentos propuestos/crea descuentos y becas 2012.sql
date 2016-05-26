/********************************************************************************/
                            -- Admision 2012
/********************************************************************************/
-- crea descuentos a partir de un listado dado de los alumnos y sus descuentos con los porcentajes incluidos
insert into sdescuentos
select distinct cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,1 as esde_ccod , 0 as sdes_mmatricula,
    aran_mcolegiatura*(porcentaje*0.01) as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje as decimal(4,2) )as sdes_nporc_colegiatura,
    'Continuidad de beneficio 2011' sdes_tobservaciones,'propone beca existente 2012' audi_tusuario, getdate() audi_fmodificacion
    from sd_renovantes_becas_2012 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where substring(a.rut,0,patindex('%-%',a.rut))=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    ---and a.descuento COLLATE Modern_Spanish_CI_AS = d.tdet_tdesc COLLATE Modern_Spanish_CI_AS
    and protic.extrae_acentos(a.descuento) COLLATE SQL_Latin1_General_CP1_CI_AS  = protic.extrae_acentos(d.tdet_tdesc)  COLLATE SQL_Latin1_General_CP1_CI_AS
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=226
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (182926,183019,183370,184308,184891)
    and c.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=226
            and emat_ccod not in (13,4,8,9))


-- #### Alumnos con pase de matricula
insert into sdescuentos
select cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,2 as esde_ccod , 0 as sdes_mmatricula,
    0 as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje as decimal(5,2) )as sdes_nporc_colegiatura,
    'Debe confirmar Pase Matricula y/o Becas' sdes_tobservaciones,'propone beca existente 2011-2012 pase' audi_tusuario, getdate() audi_fmodificacion
    from sd_renovantes_becas_pase_2012 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and protic.extrae_acentos(a.descuento) COLLATE Modern_Spanish_CI_AS = protic.extrae_acentos(d.tdet_tdesc) COLLATE Modern_Spanish_CI_AS
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=226
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (116861)
    and c.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=226
            and emat_ccod not in (13,4,8,9))


/********************************************************************************/       