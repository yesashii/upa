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

-- crea desceuntos a partir de un listado dado de los alumnos y sus descentos con los porcentajes incluidos
--insert into sdescuentos
select a.rut,cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,c.ofer_ncorr,2 as esde_ccod , 0 as sdes_mmatricula,
    --aran_mcolegiatura*(porcentaje*0.01) as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje as decimal(4,2) )as sdes_nporc_colegiatura,
    'Alumno destacado en '+cast(deporte as varchar) sdes_tobservaciones,'propone beca deportiva' audi_tusuario, getdate() audi_fmodificacion
    from sd_becas_2008_deportistas a, personas b, postulantes c,tipos_detalle d, aranceles e
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

-- inserta beca deportiva a alumnso sin contratos
--insert into sdescuentos
select cast(tdet_ccod as numeric) as stde_ccod, c.post_ncorr,f.ofer_ncorr,2 as esde_ccod , 0 as sdes_mmatricula,
    aran_mcolegiatura*(porcentaje*0.01) as sdes_mcolegiatura,0 as sdes_nporc_matricula,cast(porcentaje as decimal(4,2) )as sdes_nporc_colegiatura,
    'Alumno destacado en '+cast(deporte as varchar) sdes_tobservaciones,'propone beca deportiva' audi_tusuario, getdate() audi_fmodificacion
    from sd_becas_2008_deportistas a, personas_postulante b, postulantes c,tipos_detalle d, aranceles e, detalle_postulantes f
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and a.tipo_descuento= d.tdet_tdesc
    and c.post_ncorr=f.post_ncorr
    and f.ofer_ncorr=e.ofer_ncorr
    and e.aran_mmatricula>1 
    and c.peri_ccod=210
    and f.post_ncorr not in (
        select ab.post_ncorr from alumnos ab, ofertas_academicas bc
            where ab.ofer_ncorr=bc.ofer_ncorr
            and bc.peri_ccod=210
            and emat_ccod not in (13,4,8,9))




--crea becas para alumnos con pase matricula, estado pendiente y glosa
insert into sdescuentos 
select  cast(tdet_ccod as numeric) as stde_ccod,c.post_ncorr,d.ofer_ncorr,2 as esde_ccod , 0 as sdes_mmatricula,
cast(cast(a.porc_mcolegiatura as decimal(2,2))*f.aran_mcolegiatura as numeric) as sdes_mcolegiatura, 
0 as sdes_nporc_matricula,cast(a.porc_mcolegiatura as decimal(2,2) )*100 as sdes_nporc_colegiatura,
'Debe confirmar Pase Matricula y/o Becas' sdes_tobservaciones,'propone beca existente' audi_tusuario, getdate() audi_fmodificacion
from 
sd_becas_2007_pase_matricula a 
join personas b
    on a.rut=b.pers_nrut
join postulantes c
    on b.pers_ncorr=c.pers_ncorr
    and c.peri_ccod=206
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
        from 
        sd_becas_2007_pase_matricula a 
        join personas b
            on a.rut=b.pers_nrut
        join postulantes c
            on b.pers_ncorr=c.pers_ncorr
            and c.peri_ccod=206
    )     
)     


update sd_becas_2008_deportistas set porcentaje=replace(porcentaje,'@','')
select * from sd_becas_2008_deportistas
--select * from sdescuentos where sdes_tobservaciones='Continuidad de beneficio'

-- alumnos que ya figuran con algun descuento para esta admision (2007)        
select * from sdescuentos 
where post_ncorr in (
    select  distinct post_ncorr
    from 
    sd_becas_2007_pase_matricula a 
    join personas b
        on a.rut=b.pers_nrut
    join postulantes c
        on b.pers_ncorr=c.pers_ncorr
        and c.peri_ccod=206
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
 select  c.pers_ncorr,count(c.post_ncorr)
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
        group by c.pers_ncorr



