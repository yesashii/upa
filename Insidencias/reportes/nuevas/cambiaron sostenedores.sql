select protic.obtener_rut(alumno_2006) rut_alumno,a.pers_tape_paterno as apellido_paterno, pers_tape_materno as apellido_materno,pers_tnombre as nombres,
protic.trunc(a.pers_fnacimiento) as fecha_nacimiento,case c.post_bnuevo when 'S' then 'Nuevo' else 'Antiguo' end as tipo_alumno,
d.emat_tdesc,carr_tdesc as carrera,i.sede_tdesc as sede,h.jorn_tdesc as jornada,
protic.obtener_rut(apoderado_2006) rut_apoderado_2006,protic.obtener_nombre_completo(apoderado_2006,'n') as nombre_apoderado_2006,(select protic.trunc(pers_fnacimiento) from personas where pers_ncorr = apoderado_2006) as fecha_nacimiento,
protic.obtener_rut(apoderado_2005) rut_apoderado_2005,protic.obtener_nombre_completo(apoderado_2005,'n') as nombre_apoderado_2005 ,(select protic.trunc(pers_fnacimiento) from personas where pers_ncorr = apoderado_2006) as fecha_nacimiento
from (
    select  a.pers_ncorr as alumno_2006,c.pers_ncorr as apoderado_2006
    from  alumnos a, postulantes b,codeudor_postulacion c
    where a.post_ncorr=b.post_ncorr
    and b.post_ncorr=c.post_ncorr
    and b.peri_ccod=202
    and a.emat_ccod not in (9,3)
    group by a.pers_ncorr,b.post_ncorr,c.pers_ncorr 
) as a_2006,
( 
    select  a.pers_ncorr as alumno_2005,c.pers_ncorr as apoderado_2005
    from  alumnos a, postulantes b,codeudor_postulacion c, contratos d
    where a.post_ncorr=b.post_ncorr
    and b.post_ncorr=c.post_ncorr
    and a.matr_ncorr=d.matr_ncorr
    and b.post_ncorr=d.post_ncorr
    and d.econ_ccod not in (2,3)     
    and b.peri_ccod=164
    and a.emat_ccod not in (9,3)
    group by a.pers_ncorr, c.pers_ncorr
) as a_2005,
personas a,  alumnos b,postulantes c, estados_matriculas d,
ofertas_academicas e, especialidades f, carreras g, jornadas h, sedes i
where alumno_2006=alumno_2005
and apoderado_2006 <> apoderado_2005
and alumno_2006=a.pers_ncorr
and a.pers_ncorr=b.pers_ncorr
and b.post_ncorr=c.post_ncorr
and c.peri_ccod=202
and b.emat_ccod=d.emat_ccod
and b.ofer_ncorr=e.ofer_ncorr
and e.espe_ccod=f.espe_ccod
and f.carr_ccod=g.carr_ccod
and e.jorn_ccod=h.jorn_ccod
and e.sede_ccod=i.sede_ccod