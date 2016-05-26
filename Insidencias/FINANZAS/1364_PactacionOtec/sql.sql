-- Para poder habilitar el curso y verificar a los inscritos 

update top(1) datos_generales_secciones_otec set esot_ccod = 1 where dgso_ncorr = 1041



-- -----------------

select * from personas where pers_nrut = 15633073
select * from postulacion_otec where dgso_ncorr = 1041 and pers_ncorr = 278283



select * from estados_postulacion_otec


-- ---------------------

-- así anulamos la postulacion del estudiante
update top(1) postulacion_otec 
set epot_ccod = 5
where dgso_ncorr = 1041 and pers_ncorr = 278283

-- Para poder desabilitar el curso

update top(1) datos_generales_secciones_otec set esot_ccod = 4 where dgso_ncorr = 1041