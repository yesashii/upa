select distinct protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno,  
emat_tdesc as estado_matricula, protic.ano_ingreso_carrera(b.pers_ncorr,d.carr_ccod) as promocion, 
sede_tdesc as sede,(select carr_tdesc from carreras where carr_ccod=d.carr_ccod) as carrera,  jorn_tdesc as jornada,
case when protic.es_nuevo_carrera(b.pers_ncorr,d.carr_ccod,222)='S' then 'NUEVO' else 'ANTIGUO' end as Tipo_Alumno,
(select count(*) from sdescuentos sd where sd.stde_ccod=1402 and sd.post_ncorr in (select pos.post_ncorr from postulantes pos, alumnos al where pos.post_ncorr=al.post_ncorr and pos.peri_ccod<=220 and pos.pers_ncorr=b.pers_ncorr)) as tenia_cae_anteriores,
case when (select count(*) from sdescuentos sd where sd.stde_ccod=1402 and sd.post_ncorr in (select pos.post_ncorr from postulantes pos, alumnos al where pos.post_ncorr=al.post_ncorr and pos.peri_ccod<=220 and pos.pers_ncorr=b.pers_ncorr))>=1 then 'RENOVANTE' else 'NUEVO CAE' end as tipo_cae
from sdescuentos a, alumnos b , ofertas_academicas c, especialidades d, estados_matriculas e, jornadas f, sedes g
where a.post_ncorr=b.post_ncorr 
and a.ofer_ncorr=b.ofer_ncorr 
and a.esde_ccod = 1 
and a.stde_ccod=1402 
and a.ofer_ncorr=c.ofer_ncorr
and c.peri_ccod=222
and c.espe_ccod=d.espe_ccod
and b.emat_ccod not  in (9)
and b.emat_ccod=e.emat_ccod
and c.jorn_ccod=f.jorn_ccod
and c.sede_ccod=g.sede_ccod