-- Admision 2007
-- inserta los descuentos propuestos para los alumnos de la admision 2007
--insert into sdescuentos 
select  cast(tdet_ccod as numeric) as stde_ccod,c.post_ncorr,d.ofer_ncorr,2 as esde_ccod , 0 as sdes_mmatricula,
monto_descuento as sdes_mcolegiatura,0 as sdes_nporc_matricula,
cast(porc_mcolegiatura as decimal(2,2) )*100 as sdes_nporc_colegiatura,
'Continuidad de beneficio 2007' sdes_tobservaciones,'propone beca existente' audi_tusuario, getdate() audi_fmodificacion
from 
sd_becas_2007 a 
join personas b
    on a.rut=b.pers_nrut
join postulantes c
    on b.pers_ncorr=c.pers_ncorr
    and c.peri_ccod=206
join detalle_postulantes d
    on c.post_ncorr=d.post_ncorr
join ofertas_academicas e
    on d.ofer_ncorr=e.ofer_ncorr
join especialidades f
    on e.espe_ccod=f.espe_ccod
    and a.carr_ccod=f.carr_ccod

-- Admision 2008
-- crea descuentos a partir de un listado dado de los alumnos y sus desceentos con los porcentajes incluidos
--insert into sdescuentos
select cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,2 as esde_ccod , 0 as sdes_mmatricula,
    aran_mcolegiatura*(porcentaje*0.01) as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje as decimal(4,2) )as sdes_nporc_colegiatura,
    'Continuidad de beneficio 2008' sdes_tobservaciones,'propone beca existente' audi_tusuario, getdate() audi_fmodificacion
    from sd_renovantes_becas_2008 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tipo_descuento= d.tdet_tdesc
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=210
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=210
            and emat_ccod not in (13,4,8,9))


/********************************************************************************/
                            -- Admision 2009
/********************************************************************************/
-- crea descuentos a partir de un listado dado de los alumnos y sus descuentos con los porcentajes incluidos
--DESCUENTO ACTIVO (faltaron 2, revisar)
--insert into sdescuentos
select distinct cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,1 as esde_ccod , 0 as sdes_mmatricula,
    cast(aran_mcolegiatura*(porcentaje) as numeric) as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje*100 as decimal(4,2) ) as sdes_nporc_colegiatura,
    'Continuidad de beneficio 2009' sdes_tobservaciones,'propone beca existente 2009-2010' audi_tusuario, getdate() audi_fmodificacion
    from sd_renovantes_directos_2010 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tipo_descuento= d.tdet_ccod
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=218
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=218
            and emat_ccod in (13,4,8,9))
    and c.post_ncorr not in (
        select sd.post_ncorr from sdescuentos sd
            where stde_ccod not in (1402))            


-- alumnos con pase de matricula
-- PASE MATRICULA
insert into sdescuentos
select cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,2 as esde_ccod , 0 as sdes_mmatricula,
    cast(aran_mcolegiatura*(porcentaje) as numeric) as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje*100 as decimal(4,2) )as sdes_nporc_colegiatura,
    'Debe confirmar Pase Matricula y/o Becas' sdes_tobservaciones,'propone beca existente 2010' audi_tusuario, getdate() audi_fmodificacion
    from sd_renovantes_becas_pase_2010 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tipo_descuento= d.tdet_ccod
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=218
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=218
            and emat_ccod not in (13,4,8,9))
and rut in ( 16726719,
16659235,
16662095,
16538291,
16609023,
16494208,
16365916,
16610294,
16210988,
15929282,
13832613,
16366166,
17084297,
16607918,
16370859,
16334679,
16759540,
16758735,
16509027,
16867629,
16855752,
15373441,
16828808,
16758081,
16677769,
16759477,
16757374)            
    and c.post_ncorr not in (
        select sd.post_ncorr from sdescuentos sd
            where stde_ccod not in (a.tipo_descuento)
            and post_ncorr=c.post_ncorr)              


-- RENOVANTES DESCUENTOS MATRICULA Y ARANCEL (activas) --
--insert into sdescuentos
select distinct cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,1 as esde_ccod , cast(aran_mmatricula*(porcentaje_m) as numeric) as sdes_mmatricula,
    cast(aran_mcolegiatura*(porcentaje_a) as numeric) as sdes_mcolegiatura,cast(porcentaje_m*100 as decimal(4,2) ) as sdes_nporc_matricula,cast(porcentaje_a*100 as decimal(4,2) ) as sdes_nporc_colegiatura,
    'Continuidad de beneficio 2010' sdes_tobservaciones,'propone desc matr-aran 2009-2010' as audi_tusuario, getdate() audi_fmodificacion
    from sd_descuentos_matricula_arancel_2010 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tipo_descuento= d.tdet_ccod
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=218
    and c.ofer_ncorr is not null
    and c.post_ncorr <>"141915"
    and c.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=218
            and emat_ccod in (13,4,8,9))
    and c.post_ncorr not in (
        select sd.post_ncorr from sdescuentos sd
            where stde_ccod not in (1402))   
/********************************************************************************/            


