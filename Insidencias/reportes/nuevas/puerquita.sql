select count(*) cantidad ,protic.trunc(convert(datetime,audi_fmodificacion,103)) as fecha
from personas_eventos_upa 
where audi_tusuario='15329931'
and protic.trunc(convert(datetime,audi_fmodificacion,103))= protic.trunc(getdate())
group by protic.trunc(convert(datetime,audi_fmodificacion,103))
order by fecha desc


select count(*) from eventos_alumnos

select  * 
from personas_eventos_upa a, eventos_alumnos b,eventos_upa c
where a.pers_ncorr_alumno=b.pers_ncorr_alumno
and b.even_ncorr=c.even_ncorr 
and datepart(year,even_fevento)='2006'


select  b.* 
from personas_eventos_upa a, eventos_alumnos b,eventos_upa c
where a.pers_ncorr_alumno=b.pers_ncorr_alumno
and b.even_ncorr=c.even_ncorr 
and teve_ccod not in (8)
and b.audi_tusuario not in ('mriffo')
and datepart(year,b.audi_fmodificacion)='2006'

select * from personas_eventos_upa where pers_nrut='16661775'
select * from eventos_alumnos where pers_ncorr_alumno='182'
select top 1 * from eventos_upa where pers_ncorr_alumno='182'

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



-----------------------------------------------------------------
-- perfiles colegios
select protic.trunc(a.even_fevento) as fecha,
case a.even_perfil when 1 then 'SANTIAGO' when 2 then 'MELIPILLA' end as perfil_colegio,
c.cole_tdesc,b.ciud_tcomuna,b.ciud_tdesc
from eventos_upa a, ciudades b, colegios c
where a.ciud_ccod_origen*=b.ciud_ccod 
and a.cole_ccod=c.cole_ccod 
and datepart(year,a.even_fevento)='2006'
and a.even_perfil in (1,2)
order by even_ncorr desc
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
    and a.even_perfil in (2)
)
and carrera_3 is not null
group by carrera_3

-- Datos de ingresos por fichas en un dia dado
select  distinct protic.obtener_rut(d.pers_ncorr) as rut,protic.obtener_nombre_completo(d.pers_ncorr,'n') as digitador,
count(a.pers_ncorr_alumno) as  cantidad,protic.trunc(convert(datetime,a.audi_fmodificacion,103)) as fecha
from personas_eventos_upa a, eventos_alumnos b,eventos_upa c, personas d
where a.pers_ncorr_alumno=b.pers_ncorr_alumno
and b.even_ncorr=c.even_ncorr 
--and teve_ccod not in (8)
and cast(a.audi_tusuario as varchar)=cast(d.pers_nrut as varchar)
and datepart(year,b.audi_fmodificacion)='2011'
and protic.trunc(convert(datetime,a.audi_fmodificacion,103))= convert(datetime,'11/06/2011',103)
group by protic.trunc(convert(datetime,a.audi_fmodificacion,103)),d.pers_ncorr