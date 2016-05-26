select   distinct h.carr_tdesc,f.sede_tdesc,c.pers_temail,e.tpro_tdesc,c.pers_tnombre, 
c.pers_tape_paterno, c.pers_tape_materno,c.pers_nrut, c.pers_xdv,a.pers_ncorr, protic.obtener_direccion(a.pers_ncorr,1,'CNPB') as direccion

--*******************************************************
-- LISTADO DE PROFES POR CARRERA SEDE JORNADA
select   distinct i.jorn_tdesc as jornada,f.sede_tdesc as sede,h.carr_tdesc as carrera,
c.pers_tape_paterno, c.pers_tape_materno,c.pers_tnombre, protic.obtener_rut(c.pers_ncorr) as rut_profe,
j.susu_tlogin as login_profe, j.susu_tclave as clave_profe
from bloques_profesores a, bloques_horarios b, personas c, profesores d,
     tipos_profesores e, sedes f, secciones g, carreras h, jornadas i, sis_usuarios j
where a.bloq_ccod=b.bloq_ccod
--and a.bloq_ccod is not null
--and a.cdoc_ncorr is not null
and a.pers_ncorr = c.pers_ncorr
and b.sede_ccod  = d.sede_ccod
and a.pers_ncorr = d.pers_ncorr
and a.tpro_ccod  = d.tpro_ccod
and d.tpro_ccod  = e.tpro_ccod
and b.sede_ccod  = f.sede_ccod
and b.secc_ccod  = g.secc_ccod
and g.carr_ccod  = h.carr_ccod
and g.jorn_ccod=i.jorn_ccod
and g.peri_ccod=202
and c.pers_ncorr=j.pers_ncorr
order by f.sede_tdesc,h.carr_tdesc,i.jorn_tdesc,c.pers_tape_paterno, c.pers_tape_materno,c.pers_tnombre


--*******************************************************
--  LISTADO PROFESORES UNICOS (TOMA LA MAXIMA SECCION)
select b.sede_tdesc as sede,c.carr_tdesc as carrera, d.jorn_tdesc as jornada,a.* from (
    select   max(g.secc_ccod) as secc_ccod,c.pers_tape_paterno, c.pers_tape_materno,c.pers_tnombre
    from bloques_profesores a, bloques_horarios b, personas c, profesores d,
     tipos_profesores e, sedes f, secciones g, carreras h, jornadas i
    where a.bloq_ccod=b.bloq_ccod
    and a.pers_ncorr = c.pers_ncorr
    and b.sede_ccod  = d.sede_ccod
    and a.pers_ncorr = d.pers_ncorr
    and a.tpro_ccod  = d.tpro_ccod
    and d.tpro_ccod  = e.tpro_ccod
    and b.sede_ccod  = f.sede_ccod
    and b.secc_ccod  = g.secc_ccod
    and g.carr_ccod  = h.carr_ccod
    and g.jorn_ccod=i.jorn_ccod
    and e.tpro_ccod=1
    and g.peri_ccod=202
    group by c.pers_tape_paterno, c.pers_tape_materno,c.pers_tnombre
) a, secciones x ,sedes b,carreras c, jornadas d
where a.secc_ccod=x.secc_ccod
    and x.sede_ccod=b.sede_ccod
    and x.carr_ccod=c.carr_ccod
    and x.jorn_ccod=d.jorn_ccod
order by b.sede_tdesc,c.carr_tdesc,d.jorn_tdesc,pers_tape_paterno, pers_tape_materno,pers_tnombre