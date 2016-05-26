SELECT a.cont_ncorr, 
       a.cont_ncorr                                      AS c_cont_ncorr, 
       protic.Obtener_nombre_carrera(b.ofer_ncorr, 'CJ') AS carrera, 
       CONVERT(VARCHAR, a.cont_fcontrato, 103)           AS cont_fcontrato, 
       a.post_ncorr, 
       b.pers_ncorr, 
       c.pers_nrut, 
       c.pers_xdv, 
       Cast(c.pers_nrut AS VARCHAR) + '-' 
       + c.pers_xdv                                      AS rut_alumno, 
       c.pers_tape_paterno + ' ' 
       + c.pers_tape_materno + ' ' + c.pers_tnombre      AS nombre_alumno, 
       a.peri_ccod, 
       a.econ_ccod, 
       d.econ_tdesc 
FROM   contratos a, 
       postulantes b, 
       personas_postulante c, 
       estados_contrato d 
WHERE  a.post_ncorr = b.post_ncorr 
       AND b.pers_ncorr = c.pers_ncorr 
       AND a.econ_ccod = d.econ_ccod 
       AND a.peri_ccod = '242' 
       AND a.econ_ccod <> 3 
       AND Cast(c.pers_nrut AS VARCHAR) = Isnull('18957582', '0') 
ORDER  BY a.cont_ncorr DESC 




select * from CONTRATOS where CONT_NCORR = 167331


update contratos
set ECON_CCOD = 2
where cONT_NCORR = 167331


select * from ESTADOS_CONTRATO


delete from CONTRATOS  where cONT_NCORR = 167335



--------------------------------------------------------------------
SELECT a.cont_ncorr, 
       a.cont_ncorr                                      AS c_cont_ncorr, 
       protic.Obtener_nombre_carrera(b.ofer_ncorr, 'CJ') AS carrera, 
       CONVERT(VARCHAR, a.cont_fcontrato, 103)           AS cont_fcontrato, 
       a.post_ncorr, 
       b.pers_ncorr, 
       c.pers_nrut, 
       c.pers_xdv, 
       Cast(c.pers_nrut AS VARCHAR) + '-' 
       + c.pers_xdv                                      AS rut_alumno, 
       c.pers_tape_paterno + ' ' 
       + c.pers_tape_materno + ' ' + c.pers_tnombre      AS nombre_alumno, 
       a.peri_ccod, 
       a.econ_ccod, 
       d.econ_tdesc 
FROM   contratos a, 
       postulantes b, 
       personas_postulante c, 
       estados_contrato d 
WHERE  a.post_ncorr = b.post_ncorr 
       AND b.pers_ncorr = c.pers_ncorr 
       AND a.econ_ccod = d.econ_ccod 
       AND a.peri_ccod = '242' 
       AND a.econ_ccod <> 3 
       AND Cast(c.pers_nrut AS VARCHAR) = Isnull('18957582', '0') 
ORDER  BY a.cont_ncorr DESC 




select * from CONTRATOS where CONT_NCORR = 167331


update contratos
set ECON_CCOD = 2
where cONT_NCORR = 167331


select * from ESTADOS_CONTRATO


delete from CONTRATOS  where cONT_NCORR = 167331


-- SOLUCION:

SELECT *
FROM   contratos a 
       JOIN alumnos b 
         ON a.matr_ncorr = b.matr_ncorr 
       JOIN ofertas_academicas c 
         ON b.ofer_ncorr = c.ofer_ncorr 
       JOIN especialidades d 
         ON c.espe_ccod = d.espe_ccod 
       JOIN carreras e 
         ON d.carr_ccod = e.carr_ccod 
       JOIN personas f 
         ON b.pers_ncorr = f.pers_ncorr 
       LEFT OUTER JOIN direcciones g 
                    ON b.pers_ncorr = g.pers_ncorr 
       LEFT OUTER JOIN ciudades h 
                    ON g.ciud_ccod = h.ciud_ccod 
       JOIN codeudor_postulacion i 
         ON a.post_ncorr = i.post_ncorr 
       JOIN personas j 
         ON i.pers_ncorr = j.pers_ncorr 
       LEFT OUTER JOIN direcciones k 
                    ON i.pers_ncorr = k.pers_ncorr 
       LEFT OUTER JOIN ciudades l 
                    ON k.ciud_ccod = l.ciud_ccod 
WHERE  a.cont_ncorr = 167338
       AND a.peri_ccod = 242 
       AND g.tdir_ccod = 1 
       AND k.tdir_ccod = 1 
       
select * from contratos where cont_ncorr = 167334      
select * from alumnos where PERS_NCORR = (select pers_ncorr from personas where PERS_NRUT =18957582 )   


update top(2) contratos set MATR_NCORR = 282412 where cont_ncorr = 167334  -- Nelson sepulveda :http://fangorn.upacifico.cl/sigaupa/REPORTESNET/Comprobante.aspx?contrato=167334&periodo=242


select * from contratos where cont_ncorr = 167338 
select * from alumnos where PERS_NCORR = (select pers_ncorr from personas where PERS_NRUT =19213074 )


update top(2) contratos set MATR_NCORR = 282416 where cont_ncorr =167338 -- valeska :http://fangorn.upacifico.cl/sigaupa/REPORTESNET/Comprobante.aspx?contrato=167338&periodo=242


-- reparando alumno:
update top (2) alumnos  set ETCA_CCOD = 2 where PERS_NCORR = (select pers_ncorr from personas where PERS_NRUT =18957582 ) and MATR_NCORR = 282412

update top (2) alumnos  set ETCA_CCOD = 2 where PERS_NCORR = (select pers_ncorr from personas where PERS_NRUT =19213074 ) and MATR_NCORR = 282416






