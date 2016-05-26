select a.* from bloques_profesores a, bloques_horarios b, secciones c
where a.bloq_ccod=b.bloq_ccod
and b.secc_ccod=c.secc_ccod
and c.peri_ccod=202
and c.sede_ccod=1
and c.carr_ccod=49
and c.jorn_ccod=2
and a.pers_ncorr in (
select distinct pers_ncorr from carreras_docente 
    where sede_ccod=1 
    and peri_ccod=202 
    and jorn_ccod=2 
    and carr_ccod=49
)



delete from bloques_profesores where bloq_ccod in (17573,17574,17571,17572)

delete from carreras_docente 
where sede_ccod=1 
and peri_ccod=202 
and jorn_ccod=2 
and carr_ccod=49

select * from carreras



