select * from carreras where carr_tdesc like '%licenciatura en comunicaciones%'






select * from orden_carreras_admision 

where carrera like '%licenciatura en comunicaciones%'

ORDER BY carrera



select * from SEDES


insert into orden_carreras_admision values (
1,
992,
2,
'Sede Las Condes: Magíster en Resolución de Conflictos y Mediación Socio-Familiar',
99
)


update orden_carreras_admision

set CARRERA = 'Sede Las Condes: Magíster en Psicología Clínica Humanista Transpersonal'

where carrera like '%en Psicología Clínica Humanista Transpersonal%'



