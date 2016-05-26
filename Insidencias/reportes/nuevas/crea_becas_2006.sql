-- inserta los descuentos propuestos para los alumnos de la admision 2007

insert into sdescuentos 
select  cast(tdet_ccod as numeric) as stde_ccod,c.post_ncorr,d.ofer_ncorr,1 as esde_ccod , 0 as sdes_mmatricula,
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

  
  
Eduardo Solis de LastCall 

17324496