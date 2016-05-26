-- ----- llamar a la funcion creada

select protic.numero_postulaciones('255851');

-- --- seleccionar usuarios que postulan

SELECT Count(*) 
FROM   usuarios 
WHERE  usua_tusuario = '15370707' 
       AND Upper(usua_tclave) IS NOT NULL 




select * from USUARIOS


-- listar las carreras en las que están postulando.

SELECT count(*)
FROM   detalle_postulantes a, 
       ofertas_academicas b, 
       especialidades c, 
       carreras d, 
       sedes e, 
       jornadas f, 
       estado_examen_postulantes G 
WHERE  a.ofer_ncorr = b.ofer_ncorr 
       AND b.espe_ccod = c.espe_ccod 
       AND c.carr_ccod = d.carr_ccod 
       AND b.sede_ccod = e.sede_ccod 
       AND b.jorn_ccod = f.jorn_ccod 
       AND A.eepo_ccod = G.eepo_ccod 
       AND d.ecar_ccod = 1 
       AND d.inst_ccod = 1 
       AND Cast(a.post_ncorr AS VARCHAR) = '255851' 