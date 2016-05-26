select * from datos_generales_secciones_otec where dcur_ncorr=534

select distinct comp_ndocto from postulantes_cargos_otec where pote_ncorr in (
    select pote_ncorr from postulacion_otec where dgso_ncorr in (291,292,293,294,295,296,298,290)
)
--and comp_ndocto not in (183298)


--los que no seran matriculados (Facturas)
update  postulacion_otec set dgso_ncorr=536 where dgso_ncorr=297
--ofertas temporales
select * from datos_generales_secciones_otec where dcur_ncorr in (528,529,530,531,532,533,534,536)

/*******************************************************/

--Los que deben ser matriculados
update  postulacion_otec set dgso_ncorr=297 where dgso_ncorr=2979

--Ofertas reales con ajustes de alumnos
select * from datos_generales_secciones_otec where dcur_ncorr in (289,288,287,284,285,282,286)



select * from diplomados_cursos

select * from postulantes_cargos_otec where comp_ndocto in (183298)

select * from postulacion_otec where dgso_ncorr=297


6370
6371-6551


Select * From rangos_facturas_cajeros Where pers_ncorr=101130 and tfac_ccod=2 and sede_ccod=1 and erfa_ccod=1  

09-9390232

44
45
46
48
49
