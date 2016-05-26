 select distinct sede_tdesc as sede,i.carr_tdesc as carrera,jorn_tdesc as jornada,cast(g.asig_ccod as varchar)+' '+cast(g.asig_tdesc as varchar) as asignatura,
 protic.profesores_bloque(a.bloq_ccod) as profesor,f1.ssec_ncorr,a.bloq_ccod ,
 protic.trunc(a.bloq_finicio_modulo) as Inicio,protic.trunc(a.bloq_ftermino_modulo) as Termino, d.sala_ciso,     
 d.sala_tdesc as sala,  e.hora_ccod as hora, h.dias_tdesc as Dia, h.dias_ccod,    
 case when a.pers_ncorr is null then 1 else 2 end as asig_docente,    
 case isnull(bloq_ayudantia,0) when 0 then 'Cátedra' when 1 then 'Ayudantía' when 2 then 'Laboratorio' when 3 then 'Terreno' end as tipo,
 (select count(*) from detalle_anexos da, anexos b where da.anex_ncorr=b.anex_ncorr and b.eane_ccod not in (3) and da.bloq_ccod in (a.bloq_ccod) ) as tiene_contrato 
     from     
     bloques_horarios a,salas d, horarios e, secciones f, sub_secciones f1, 
     asignaturas g, dias_semana h, carreras i,sedes j, jornadas k    
     where a.sala_ccod=d.sala_ccod    
     and e.hora_ccod=a.hora_ccod    
     and f.asig_ccod=g.asig_ccod    
     and f.secc_ccod=f1.secc_ccod    
     and a.ssec_ncorr=f1.ssec_ncorr    
     and a.dias_ccod=h.dias_ccod  
     and f.carr_ccod=i.carr_ccod  
     and f.sede_ccod=j.sede_ccod
     and f.jorn_ccod=k.jorn_ccod
     and f1.ssec_ncorr in(select ssec_ncorr from secciones a, bloques_horarios b 
                        where a.secc_ccod=b.secc_ccod
                        and a.peri_ccod=210)   
 	 order by f1.ssec_ncorr,asig_docente, h.dias_ccod, e.hora_ccod  