select distinct f.secc_ccod codigo,secc_tdesc as num_seccion,i.sede_tdesc as sede,h.carr_tdesc as carrera,protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as docente,
cast(g.asig_ccod as varchar)+' '+cast(g.asig_tdesc as varchar) as asignatura, 
case isnull(bloq_ayudantia,0) when 0 then 'Cátedra' when 1 then 'Ayudantía' when 2 then 'Laboratorio' when 3 then 'Terreno' when 4 then 'Elearning' end as tipo 
    from bloques_profesores a, bloques_horarios b,secciones f, asignaturas g, carreras h, sedes i
    where a.bloq_ccod=b.bloq_ccod
    and b.secc_ccod=f.secc_ccod
    and f.asig_ccod=g.asig_ccod 
    and f.carr_ccod=h.carr_ccod
    and f.sede_ccod=i.sede_ccod
    and f.peri_ccod in (226)
    and f.secc_ccod in(
                    select secc_ccod from  (
                        select distinct c.secc_ccod,a.pers_ncorr
                        from bloques_profesores a, bloques_horarios b, secciones c
                        where a.bloq_ccod=b.bloq_ccod
                        and b.secc_ccod=c.secc_ccod
                        and c.peri_ccod=226
                        and tpro_ccod=1
                    ) as tabla
                    group by secc_ccod
                    having count(*)>1
        )
    and f.secc_ccod not  in (select distinct secc_ccod from horas_profesores where secc_ccod in ( 
                    select distinct c.secc_ccod
                        from bloques_profesores a, bloques_horarios b, secciones c
                        where a.bloq_ccod=b.bloq_ccod
                        and b.secc_ccod=c.secc_ccod
                        and c.peri_ccod=226
                        and tpro_ccod=1)
                        )    
 order by sede, carrera asc, f.secc_ccod desc