
--Cantidad eventos ingresados por un usuario
select count(*) cantidad ,protic.trunc(convert(datetime,audi_fmodificacion,103)) as fecha
from personas_eventos_upa 
where audi_tusuario='9252160'
and protic.trunc(convert(datetime,audi_fmodificacion,103))= protic.trunc(getdate())
group by protic.trunc(convert(datetime,audi_fmodificacion,103))
order by fecha desc

-- Personas eventos por año (2010)
select count(*) from eventos_alumnos a, eventos_upa b
where a.even_ncorr=b.even_ncorr
and year(even_fevento)=2010

-- personas ingresadas en el año 2010
select count(*) as cantidad,protic.trunc(convert(datetime,audi_fmodificacion,103)) as fecha 
from personas_eventos_upa 
where year(audi_fmodificacion)=2010
group by protic.trunc(convert(datetime,audi_fmodificacion,103))
order by fecha desc


select * from personas_eventos_upa where pers_nrut='16661775'
select * from eventos_alumnos where pers_ncorr_alumno='182'
select * from eventos_upa where pers_ncorr_alumno='182'

-- pareo con alumnos de eventos que se han matriculado 
select distinct  protic.obtener_nombre_carrera(f.ofer_ncorr,'CEJ'),post_bnuevo,c.teve_ccod,ciud_tcomuna,ciud_tdesc, d.* 
from personas_eventos_upa a,eventos_alumnos b,
eventos_upa c, personas_postulante d ,
 postulantes e, alumnos f, ciudades g
where a.pers_ncorr_alumno=b.pers_ncorr_alumno
and b.even_ncorr=c.even_ncorr 
and c.teve_ccod not in (5)
and a.pers_nrut=d.pers_nrut
and d.pers_ncorr=e.pers_ncorr
and e.post_ncorr=f.post_ncorr
and a.ciud_ccod=g.ciud_ccod
and e.peri_ccod=202



select b.ciud_tdesc,b.ciud_tcomuna,* 
from eventos_upa a , ciudades b 
where a.even_ncorr>442 
and a.pcol_ccod is  null 
and a.teve_ccod not in (8)
and a.ciud_ccod_origen=b.ciud_ccod
-----------------------------------------------------------------
-- perfiles colegios
select even_ncorr,protic.trunc(a.even_fevento) as Fecha,e.pcol_tdesc as Perfil_Colegio,
c.cole_tdesc as Colegio,isnull(b.ciud_tcomuna,d.ciud_tcomuna) as Ciudad ,isnull(b.ciud_tdesc,d.ciud_tdesc) as Comuna
from eventos_upa a, ciudades b, colegios c, ciudades d,perfil_colegio e 
where a.ciud_ccod_origen*=b.ciud_ccod 
and a.cole_ccod=c.cole_ccod
and c.ciud_ccod=d.ciud_ccod 
and a.pcol_ccod=e.pcol_ccod
and a.teve_ccod not in (8)
and datepart(year,a.even_fevento)='2006'
and a.pcol_ccod in (1,2)
order by convert(datetime,a.even_fevento,103) asc
-----------------------------------------------------------------

-- prioridades dentro de los perfiles
select  carrera_3 as Preferencia, count(*) as Cantidad 
from eventos_alumnos
where even_ncorr in (
    select even_ncorr
    from eventos_upa a, ciudades b, colegios c
    where a.ciud_ccod_origen*=b.ciud_ccod 
    and a.cole_ccod=c.cole_ccod 
    and datepart(year,a.even_fevento)='2006'
    and a.pcol_ccod in (1)
)
and carrera_3 is not null
and carrera_3 not in ('')
group by carrera_3
order by cantidad desc

-- prioridades dentro de los perfiles con tipo evento
 select  pcol_tdesc as perfil,teve_tdesc as tipo_evento,carrera_1 as Preferencia, count(*) as Cantidad   
  from eventos_alumnos a, eventos_upa b, perfil_colegio c , tipo_evento d   
  where a.even_ncorr in (   
	select even_ncorr   
	from eventos_upa a, ciudades b, colegios c   
	where a.ciud_ccod_origen*=b.ciud_ccod   
	and a.cole_ccod=c.cole_ccod   
	and datepart(year,a.even_fevento)=datepart(year,getdate())   
  )   
  and a.even_ncorr=b.even_ncorr   
  and b.pcol_ccod=c.pcol_ccod
  and b.teve_ccod=d.teve_ccod   									
  and carrera_1 is not null  
  and carrera_1 not in ('')   
  group by carrera_1,pcol_tdesc,teve_tdesc   
  order by cantidad desc,carrera_1 desc,tipo_evento desc  




select distinct carrera_3 from eventos_alumnos

select  count(*) from eventos_upa where pcol_ccod is not null

select * from colegios where cole_ccod=310432
select * from alumnos where ofer_ncorr=12986



select * from detalle_ingresos where ting_ccod=3 and ding_ndocto=1845270

select * from colegios where regi_ccod=13
select top 1 * from personas_eventos_upa
select top 1 * from tipo_evento  


Select b.cole_ccod,c.ciud_ccod, c.regi_ccod 
 From eventos_upa a,  colegios b , ciudades c
 Where a.cole_ccod=b.cole_ccod
 and b.ciud_ccod*=c.ciud_ccod
 and a.even_ncorr=719
 

 
select * from eventos_upa where audi_tusuario in ('109374','109373','109375','109376')