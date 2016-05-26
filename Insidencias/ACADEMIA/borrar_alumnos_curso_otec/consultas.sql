-- ------------------------------------------------------

select * from diplomados_cursos


select * from datos_generales_secciones_otec



select * from secciones_otec


select * from sedes


select * from ofertas_otec

select * from certificados_emitidos

-- --------------------------------------------------------------------------------------

SELECT a.pers_ncorr, 
       Cast(a.pers_nrut AS VARCHAR) + '-' 
       + a.pers_xdv                              AS rut, 
       a.pers_nrut, 
       a.pers_xdv, 
       pers_tape_paterno + ' ' + pers_tape_materno 
       + ', ' + pers_tnombre                     AS alumno, 
       c.epot_tdesc                              AS estado_postulacion, 
       CASE fpot_ccod 
         WHEN 1 THEN 'Persona Natural' 
         WHEN 2 THEN 'Empresa sin Sence' 
         WHEN 3 THEN 'Empresa con Sence' 
         WHEN 4 THEN 'Empresa y Otic' 
       END                                       AS forma_pago, 
       protic.Trunc(fecha_postulacion)           AS fecha_postulacion, 
       Replace(pote_nnota_final, ',', '.')       AS pote_nnota_final, 
       pote_nasistencia, 
       Isnull(pote_nest_final, '')               AS pote_nest_final, 
       (SELECT CASE Count(*) 
                 WHEN 0 THEN 'NO' 
                 ELSE 'SI' 
               END 
        FROM   certificados_emitidos_otec tt 
        WHERE  tt.pers_ncorr = b.pers_ncorr 
               AND tt.dgso_ncorr = b.dgso_ncorr) AS solicitado, 
       (SELECT Count(*) 
        FROM   certificados_emitidos_otec tt 
        WHERE  tt.pers_ncorr = b.pers_ncorr 
               AND tt.dgso_ncorr = b.dgso_ncorr) AS bloqueado 
FROM   personas a, 
       postulacion_otec b, 
       estados_postulacion_otec c 
WHERE  a.pers_ncorr = b.pers_ncorr 
       AND b.epot_ccod = c.epot_ccod 
       AND b.epot_ccod = 4 
       AND Cast(dgso_ncorr AS VARCHAR) = '1036' 
ORDER  BY alumno 




select * from estados_postulacion_otec


select * from datos_generales_secciones_otec where dgso_ncorr = '1036' 


select * from diplomados_cursos where dcur_ncorr = 1065


-- alumnos encontrados

245150
270402
270389
270393
270408
245160
270397
270385
249002
270394
270409


select * 
from postulacion_otec 
where pers_ncorr in (
245150,
270402,
270389,
270393,
270408,
245160,
270397,
270385,
249002,
270394,
270409
)
and dgso_ncorr = '1036'


-- update cambio de estado de postulacion a anulado

update postulacion_otec
set epot_ccod = 5
where pers_ncorr in (
245150,
270402,
270389,
270393,
270408,
245160,
270397,
270385,
249002,
270394,
270409
)
and dgso_ncorr = '1036'


-- ------------------------------------
select * from diplomados_cursos where dcur_tdesc like '%wine%'


-- dcur_ncorr = 1072
select * from diplomados_cursos where dcur_ncorr = '1072'





select * from datos_generales_secciones_otec where dcur_ncorr = 1072

-- 

select * 
from postulacion_otec 
where dgso_ncorr = '1044'


-- 9693523-4     De la Barrera Donoso, Carmen Gloria 

select * from personas where pers_nrut = 9693523

-- pers_ncorr = 278610

update postulacion_otec
set epot_ccod = 5
where pers_ncorr in (
278610
)
and dgso_ncorr = '1044'




