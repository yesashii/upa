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
-- crea descuentos a partir de un listado dado de los alumnos y sus desceentos con los porcentajes incluidos
insert into sdescuentos
select cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,1 as esde_ccod , 0 as sdes_mmatricula,
    aran_mcolegiatura*(porcentaje*0.01) as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje as decimal(4,2) )as sdes_nporc_colegiatura,
    'Continuidad de beneficio 2009' sdes_tobservaciones,'propone beca existente 2008-2009' audi_tusuario, getdate() audi_fmodificacion
    from sd_renovantes_becas_2009 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tipo_descuento= d.tdet_tdesc
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=214
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (116935,115646,115521)
    and c.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=214
            and emat_ccod not in (13,4,8,9))


-- alumnos con pase de matricula
insert into sdescuentos
select cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,2 as esde_ccod , 0 as sdes_mmatricula,
    0 as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje as decimal(4,2) )as sdes_nporc_colegiatura,
    'Debe confirmar Pase Matricula y/o Becas' sdes_tobservaciones,'propone beca existente 2008-2009' audi_tusuario, getdate() audi_fmodificacion
    from sd_renovantes_becas_pase_2009 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tipo_descuento= d.tdet_tdesc
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=214
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (116861)
    and c.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=214
            and emat_ccod not in (13,4,8,9))


-- RENOVANTES BECA UREPUBLICA --
insert into sdescuentos
select distinct cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,1 as esde_ccod , desc_matricula as sdes_mmatricula,
    desc_arancel as sdes_mcolegiatura,a.porc_matricula as sdes_nporc_matricula, a.porc_arancel as sdes_nporc_colegiatura,
    'Continuidad beca Urepublica 2009' sdes_tobservaciones,'propone beca urepublica 2009' audi_tusuario, getdate() audi_fmodificacion
    from sd_renovantes_urepublica a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and d.tdet_ccod= 1510
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=214
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (
        select sd.post_ncorr from sdescuentos sd where sd.stde_ccod=1510)



-- RENOVANTES BECA JULIO ORTUZAR ROJAS --
insert into sdescuentos
select cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,1 as esde_ccod , 0 as sdes_mmatricula,
    aran_mcolegiatura*(porcentaje*0.01) as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje as decimal(4,2) )as sdes_nporc_colegiatura,
    'Beneficio socioeconomico' sdes_tobservaciones,'beca Julio Ortuzar Rojas' audi_tusuario, getdate() audi_fmodificacion
    from sd_becas_ortuzar_2009 a, personas b, postulantes c,tipos_detalle d, aranceles e
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tipo_descuento= d.tdet_tdesc
    and c.ofer_ncorr=e.ofer_ncorr 
    and c.peri_ccod=214
    and c.ofer_ncorr is not null
    and c.post_ncorr not in (-- quitando los alumnos ya matriculados
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=214
            and emat_ccod  in (1))
/********************************************************************************/            


--crea becas para alumnos con pase matricula, estado pendiente y glosa
--insert into sdescuentos 
select  cast(tdet_ccod as numeric) as stde_ccod,c.post_ncorr,d.ofer_ncorr,2 as esde_ccod , 0 as sdes_mmatricula,
aran_mcolegiatura*(porcentaje*0.01) as sdes_mcolegiatura, 
0 as sdes_nporc_matricula,cast(porcentaje as decimal(4,2) )as sdes_nporc_colegiatura,
'Debe confirmar Pase Matricula y/o Becas' sdes_tobservaciones,'propone beca existente 2008-2009' audi_tusuario, getdate() audi_fmodificacion
from 
sd_renovantes_becas_pase_2009 a 
join personas b
    on a.rut=b.pers_nrut
join postulantes c
    on b.pers_ncorr=c.pers_ncorr
    and c.peri_ccod=214
    and c.post_ncorr not in (116861)
join detalle_postulantes d
    on c.post_ncorr=d.post_ncorr
join ofertas_academicas e
    on d.ofer_ncorr=e.ofer_ncorr
join aranceles f
    on e.ofer_ncorr=f.ofer_ncorr
where c.post_ncorr not in (
    select post_ncorr from sdescuentos 
    where post_ncorr in (
        select  distinct post_ncorr
        from sd_renovantes_becas_pase_2009 a 
        join personas b
            on a.rut=b.pers_nrut
        join postulantes c
            on b.pers_ncorr=c.pers_ncorr
            and c.peri_ccod=214
            and c.post_ncorr not in (116861)
    )     
)     

--select * from sdescuentos where sdes_tobservaciones='Continuidad de beneficio'

-- alumnos que ya figuran con algun descuento para esta admision (2009)        
select * from sdescuentos 
where post_ncorr in (
    select  distinct post_ncorr
    from 
    sd_renovantes_becas_2009 a 
    join personas b
        on a.rut=b.pers_nrut
    join postulantes c
        on b.pers_ncorr=c.pers_ncorr
        and c.peri_ccod=214
)     

-- alumnos que no tienen postulacion para el 2007
select top 1 * from sd_becas_2007
where rut not in (
    select  rut
    from 
    sd_becas_2007 a 
    join personas b
        on a.rut=b.pers_nrut
    join postulantes c
        on b.pers_ncorr=c.pers_ncorr
        and c.peri_ccod=206
 )
 
 
-- alumno con mas de una postulacion
 select  a.rut,c.pers_ncorr,count(c.post_ncorr)
    from 
    sd_renovantes_becas_2009 a 
    join personas b
        on a.rut=b.pers_nrut
    join postulantes c
        on b.pers_ncorr=c.pers_ncorr
        and c.peri_ccod=214
    join detalle_postulantes d
        on c.post_ncorr=d.post_ncorr
    join ofertas_academicas e
        on d.ofer_ncorr=e.ofer_ncorr
    join especialidades f
        on e.espe_ccod=f.espe_ccod
        group by c.pers_ncorr,a.rut



        select  rut,b.pers_ncorr, count(*)
        from sd_renovantes_becas_pase_2009 a 
        join personas b
            on a.rut=b.pers_nrut
        join postulantes c
            on b.pers_ncorr=c.pers_ncorr
            and c.peri_ccod=214
            group by b.pers_ncorr, rut