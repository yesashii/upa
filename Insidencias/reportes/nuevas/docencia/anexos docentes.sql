select a.anex_ncodigo as Anexo,(select carr_tdesc from carreras where carr_ccod=a.carr_ccod) as Carrera,b.* from anexos a,(
select distinct dane_nsesiones as Horas,asig_ccod as Asignatura,anex_ncorr,secc_ccod from detalle_anexos where cdoc_ncorr=1465 and anex_ncorr not  in (
    select anex_ncorr from anexos where cdoc_ncorr=1465 and eane_ccod=3
)) as b
where a.anex_ncorr=b.anex_ncorr