select c.ciud_ccod_origen,e.teve_tdesc,a.pers_nrut,a.pers_xdv,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno,
a.pers_tdireccion,g.ciud_tcomuna as ciudad_alumno, g.ciud_tdesc as comuna_alumno,
a.pers_temail,a.pers_tfono,a.pers_tcelular,
e.teve_tdesc as tipo_evento,d.pest_tdesc as preferencia_estudio,
f.cole_tdesc as colegio_alumno,i.ciud_tdesc as comuna_colegio, i.ciud_tcomuna as ciudad_colegio,
h.caev_tdesc as curso_alumno,b.*,(select cole_tdesc  from colegios where cole_ccod=c.cole_ccod) as colegio_evento,c.*
from personas_eventos_upa a,
eventos_alumnos b, 
eventos_upa c, 
preferencia_estudio d, 
tipo_evento e, 
colegios f,
ciudades g,
cursos_alumnos_eventos h,
ciudades i
where a.pers_ncorr_alumno=b.pers_ncorr_alumno  
and b.pest_ccod=d.pest_ccod
and b.even_ncorr=c.even_ncorr
and c.teve_ccod=e.teve_ccod
and a.cole_ccod=f.cole_ccod
and a.ciud_ccod=g.ciud_ccod
and a.caev_ccod=h.caev_ccod
and f.ciud_ccod=i.ciud_ccod
and c.ciud_ccod_origen is not null


--********************* FICHAS *****************************
-- Cantidad de fichas ingresadas para eventos 2010
select count(*) from eventos_alumnos a, eventos_upa b, tipo_evento c
where a.even_ncorr=b.even_ncorr
and year(even_fevento)=2010
and b.teve_ccod=c.teve_ccod
and convert(datetime,a.audi_fmodificacion,103) < convert(datetime,'30/07/2010',103)

--*******************   PROMOCIONES ************************
select pers_npromociones,b.caev_tdesc as curso,pers_tdireccion as direccion,pers_tnombre,pers_tape_paterno, pers_tape_materno,d.ciud_tdesc as comuna_alumno,
d.ciud_tcomuna as ciudad_alumno,c.cole_tdesc as colegio
from personas_eventos_upa a, cursos_alumnos_eventos b, colegios c, ciudades d
where a.caev_ccod=b.caev_ccod
and a.cole_ccod=c.cole_ccod
and a.ciud_ccod=d.ciud_ccod
and a.caev_ccod=3


--************** SUBE ALUMNOS DE CURSO ***************
--update personas_eventos_upa set caev_ccod=caev_ccod+1, pers_npromociones=isnull(pers_npromociones,0)+1 , PERS_FULTIMA_PROMOCION=GETDATE()
where pers_ncorr_alumno in (
    select pers_ncorr_alumno
    from personas_eventos_upa a, cursos_alumnos_eventos b, colegios c, ciudades d
    where a.caev_ccod=b.caev_ccod
    and a.cole_ccod=c.cole_ccod
    and a.ciud_ccod=d.ciud_ccod
    and a.caev_ccod=1
    and pers_npromociones is null
)

--*****************************************************************

--************** ALUMNOS SEGUN CARRERA DE PREFERENCIA  ***************
select distinct PATINDEX('%@%',c.pers_temail),a.carrera_1,a.carrera_2,a.carrera_3,c.pers_tnombre as nombre, 
isnull(f.pcol_ccod,1) as perfil,
c.pers_tape_paterno as a_paterno,c.pers_tape_materno as a_materno,c.pers_nrut as rut,c.pers_xdv as dv,
c.pers_tdireccion as direccion,d.ciud_tcomuna as ciudad,d.ciud_tdesc as comuna,c.pers_temail as email,caev_tdesc as curso,
case when carrera_1 like '%social%' then cast(1 as varchar)+'ª' 
when carrera_2 like '%social%' then cast(2 as varchar)+'ª'
when carrera_3 like '%social%' then cast(3 as varchar)+'ª' end as opcion_carrera
 from eventos_alumnos a,(
            select max(pers_ncorr_alumno) as pers_ncorr_alumno,
            pers_tnombre, pers_tape_paterno,pers_tape_materno 
            from personas_eventos_upa 
            group by pers_tnombre, pers_tape_paterno,pers_tape_materno) b,
personas_eventos_upa c, ciudades d, cursos_alumnos_eventos e, eventos_upa f
where a.pers_ncorr_alumno=b.pers_ncorr_alumno
and c.pers_ncorr_alumno=b.pers_ncorr_alumno
and c.ciud_ccod=d.ciud_ccod
and c.caev_ccod=e.caev_ccod
and c.pers_temail is not null
and len(c.pers_temail) >4
and (a.carrera_1 like '%social%' or  a.carrera_2 like '%social%' or  a.carrera_3 like '%social%')
and a.even_ncorr=f.even_ncorr
and datepart(yyyy,even_fevento)='2006'
and PATINDEX('%@%',c.pers_temail)>0
and e.caev_ccod=4
and f.teve_ccod not in (8)
order by perfil,opcion_carrera,c.pers_tnombre, c.pers_tape_paterno,c.pers_tape_materno


