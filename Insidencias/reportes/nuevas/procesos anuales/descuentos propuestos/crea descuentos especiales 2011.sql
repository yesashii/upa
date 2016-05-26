-- RENOVANTES BECA UREPUBLICA, luis galdames, --
insert into sdescuentos
select distinct cast(d.tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,1 as esde_ccod , descuento_matricula as sdes_mmatricula,
    descuento_arancel as sdes_mcolegiatura,a.porc_matricula as sdes_nporc_matricula, a.porc_arancel as sdes_nporc_colegiatura,
    'Continuidad beca Luis Galdames 2011' sdes_tobservaciones,'propone beca Luis Galdames 2011' audi_tusuario, getdate() audi_fmodificacion
    from sd_renovantes_especiales_2011_v2 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tdet_ccod= d.tdet_ccod
    and d.tdet_ccod= 1734
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=222
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (
        select sd.post_ncorr from sdescuentos sd where sd.stde_ccod=1734)


-- RENOVANTES BECA JULIO ORTUZAR ROJAS --
--insert into sdescuentos
select cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,1 as esde_ccod , 0 as sdes_mmatricula,
    aran_mcolegiatura*(cast(((descuento*100)/arancel)as numeric)*0.01) as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(((descuento*100)/arancel)as numeric)*0.01 as sdes_nporc_colegiatura,
    'Beneficio socioeconomico' sdes_tobservaciones,'beca Julio Ortuzar Rojas 2011' audi_tusuario, getdate() audi_fmodificacion
    from sd_becas_ortuzar_2011 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and c.peri_ccod=222
    and protic.extrae_acentos(a.tipo_descuento)= protic.extrae_acentos(d.tdet_tdesc)
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (-- quitando los alumnos ya matriculados
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=222
            and emat_ccod  in (1))