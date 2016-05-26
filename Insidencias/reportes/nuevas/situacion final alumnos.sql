-- Listado de alumnos y situacion final de sus asignaturas
select j.asig_tdesc asignatura,i.asig_ccod,h.secc_ccod,c.sede_tdesc as sede,e.carr_tdesc as carrera,f.jorn_tdesc as jornada,
cast(g.pers_nrut as varchar)+'-'+g.pers_xdv as rut, g.pers_tnombre as nombres,g.pers_tape_paterno + ' ' + g.pers_tape_materno as apellidos,
protic.ano_ingreso_carrera(a.pers_ncorr,d.carr_ccod) as ano_ingreso_carrera,
isnull(sitf_baprueba,'X') as aprueba,h.carg_nnota_final as nota, k.sitf_tdesc as situacion, h.estado_cierre_ccod as cerrado
from alumnos a, ofertas_academicas b, sedes c, especialidades d, carreras e, jornadas f,
personas g,cargas_academicas h, secciones i, asignaturas j, situaciones_finales k
where a.ofer_ncorr=b.ofer_ncorr 
and b.peri_ccod=202 
and a.emat_ccod=1
and b.sede_ccod=c.sede_ccod 
and b.espe_ccod=d.espe_ccod
and d.carr_ccod=e.carr_ccod 
and b.jorn_ccod=f.jorn_ccod
and a.pers_ncorr=g.pers_ncorr
and a.matr_ncorr=h.matr_ncorr
and h.secc_ccod=i.secc_ccod
and i.asig_ccod=j.asig_ccod
and h.sitf_ccod*=k.sitf_ccod
order by sede,carrera,jornada,apellidos



--SELECT  * FROM situaciones_finales

SELECT * FROM INGRESOS WHERE AUDI_TUSUARIO='mriffo crea comprobante'