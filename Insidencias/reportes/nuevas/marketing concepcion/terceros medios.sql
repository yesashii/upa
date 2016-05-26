select distinct a.pers_nrut,a.pers_xdv,b.caev_tdesc as curso,pers_tdireccion as direccion,pers_tnombre as nombres,pers_tape_paterno as paterno, pers_tape_materno as materno,d.ciud_tdesc as comuna_alumno,
d.ciud_tcomuna as ciudad_alumno,c.cole_tdesc as colegio,pers_temail as email, pers_tfono as fono_fijo,pers_tcelular as celular, (select carre_tdesc from carreras_eventos where carre_ccod=isnull(carre_ccod_1,0)) as preferencia
from personas_eventos_upa a, cursos_alumnos_eventos b, colegios c, ciudades d,eventos_alumnos e
where a.caev_ccod=b.caev_ccod
and a.cole_ccod=c.cole_ccod
and a.ciud_ccod=d.ciud_ccod
and a.caev_ccod=3
and a.pers_ncorr_alumno=e.pers_ncorr_alumno
and a.pers_ncorr_alumno in (
    select distinct pers_ncorr_alumno from eventos_alumnos a, eventos_upa b, tipo_evento c
    where a.even_ncorr=b.even_ncorr
    and year(even_fevento)=2008
    and b.teve_ccod=c.teve_ccod
)


select distinct a.pers_nrut,a.pers_xdv,b.caev_tdesc as curso,pers_tdireccion as direccion,pers_tnombre as nombres,pers_tape_paterno as paterno, pers_tape_materno as materno,d.ciud_tdesc as comuna_alumno,
d.ciud_tcomuna as ciudad_alumno,c.cole_tdesc as colegio,pers_temail as email, pers_tfono as fono_fijo,pers_tcelular as celular, (select carre_tdesc from carreras_eventos where carre_ccod=isnull(carre_ccod_1,0)) as preferencia
from personas_eventos_upa a, cursos_alumnos_eventos b, colegios c, ciudades d,eventos_alumnos e
where a.caev_ccod=b.caev_ccod
and a.cole_ccod=c.cole_ccod
and a.ciud_ccod=d.ciud_ccod
and a.caev_ccod=3
and a.pers_ncorr_alumno=e.pers_ncorr_alumno
and a.pers_ncorr_alumno in (
    select distinct pers_ncorr_alumno from eventos_alumnos a, eventos_upa b, tipo_evento c
    where a.even_ncorr=b.even_ncorr
    and year(even_fevento)=2009
    and b.teve_ccod=c.teve_ccod
)



select distinct a.pers_nrut,a.pers_xdv,b.caev_tdesc as curso,pers_tdireccion as direccion,pers_tnombre as nombres,pers_tape_paterno as paterno, pers_tape_materno as materno,d.ciud_tdesc as comuna_alumno,
d.ciud_tcomuna as ciudad_alumno,c.cole_tdesc as colegio,pers_temail as email, pers_tfono as fono_fijo,pers_tcelular as celular, (select carre_tdesc from carreras_eventos where carre_ccod=isnull(carre_ccod_1,0)) as preferencia
from personas_eventos_upa a, cursos_alumnos_eventos b, colegios c, ciudades d,eventos_alumnos e
where a.caev_ccod=b.caev_ccod
and a.cole_ccod=c.cole_ccod
and a.ciud_ccod=d.ciud_ccod
and a.caev_ccod=3
and a.pers_ncorr_alumno=e.pers_ncorr_alumno
and a.pers_ncorr_alumno in (
    select distinct pers_ncorr_alumno from eventos_alumnos a, eventos_upa b, tipo_evento c
    where a.even_ncorr=b.even_ncorr
    and year(even_fevento)=2010
    and b.teve_ccod=c.teve_ccod
)