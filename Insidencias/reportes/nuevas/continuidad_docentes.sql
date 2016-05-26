select protic.obtener_rut(a.pers_ncorr) as rut_docente,
protic.obtener_nombre_completo(a.pers_ncorr,'a') as nombre_docente,
protic.trunc(max(anex_ffin)) as fecha_fin, case min(c.jorn_ccod) when 1 then 'DIURNO' else 'VESPERTINO' end as jornada
from contratos_docentes_upa a, anexos b, jornadas c
where a.cdoc_ncorr=b.cdoc_ncorr
and  b.jorn_ccod=c.jorn_ccod
and b.tpro_ccod=1
and   a.pers_ncorr in (
        select pers_ncorr from (
            select b.pers_ncorr ,max(
            protic.trunc(case f.duas_ccod 
            when 1 then c.proc_ffin_trimestral 
            when 2 then c.proc_ffin_semestral 
            when 3 then c.proc_ffin_anual 
            when 4 then c.proc_ffin_anual 
            when 5 then e.secc_ftermino_sec end)) as fecha_fin
            from contratos_docentes a, bloques_profesores b, 
            procesos c, bloques_horarios d, secciones e, asignaturas f
            where a.cdoc_ncorr=b.cdoc_ncorr
            and b.proc_ccod=c.proc_ccod
            and b.bloq_ccod=d.bloq_ccod
            and d.secc_ccod=e.secc_ccod
            and e.asig_ccod=f.asig_ccod
            --and f.duas_ccod not in (5)-- excluye los periodos 
           -- and carr_ccod not in (select carr_ccod from carreras where tcar_ccod=2 ) -- excluye las carreras de post grado
            group by b.pers_ncorr,e.jorn_ccod
            ) a
) 
group by a.pers_ncorr