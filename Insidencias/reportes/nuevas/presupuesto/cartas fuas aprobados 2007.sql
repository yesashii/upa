-- APROBADOS NUEVOS 2007
select aa.*,h.pers_tnombre as nombre_apo,h.pers_tape_paterno as a_paterno_apo, h.pers_tape_materno as a_materno_apo, 
protic.obtener_direccion_letra(h.pers_ncorr,1,'CNPB') as direccion_apoderado,protic.obtener_direccion_letra(h.pers_ncorr,1,'C-C') as comunas_apo,
(select count(*) from alumnos where post_ncorr=aa.post_ncorr) as matriculado,e.carr_tdesc as carrera, f.sede_tdesc as sede, g.jorn_tdesc as jornada 
from (
        select a.*,protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB') as direccion,protic.obtener_direccion_letra(b.pers_ncorr,1,'C-C') as comunas_alu,
        (select max(dp.post_ncorr) from postulantes po, detalle_postulantes dp where po.post_ncorr=dp.post_ncorr and po.peri_ccod=206 and po.pers_ncorr=b.pers_ncorr) as post_ncorr,
        (select max(dp.ofer_ncorr) from postulantes po, detalle_postulantes dp where po.post_ncorr=dp.post_ncorr and po.peri_ccod=206 and po.pers_ncorr=b.pers_ncorr) as ofer_ncorr
        from sd_nuevos_fuas_aprobados_2007 a, personas_postulante b
        where a.rut=b.pers_nrut
    ) as aa 
left outer join codeudor_postulacion b
    on aa.post_ncorr=b.post_ncorr
left outer join ofertas_academicas c
    on aa.ofer_ncorr=c.ofer_ncorr
left outer join especialidades d
    on c.espe_ccod=d.espe_ccod
left outer join carreras e
    on d.carr_ccod=e.carr_ccod    
left outer join sedes f  
    on c.sede_ccod=f.sede_ccod     
left outer join jornadas g
    on c.jorn_ccod=g.jorn_ccod
left outer join personas h
    on b.pers_ncorr=h.pers_ncorr    


-- APROBADOS ANTIGUOS 2007 --
select aa.*,h.pers_tnombre as nombre_apo,h.pers_tape_paterno as a_paterno_apo, h.pers_tape_materno as a_materno_apo, 
protic.obtener_direccion_letra(h.pers_ncorr,1,'CNPB') as direccion_apoderado,protic.obtener_direccion_letra(h.pers_ncorr,1,'C-C') as comunas,
(select count(*) from alumnos where post_ncorr=aa.post_ncorr) as matriculado,e.carr_tdesc as carrera, f.sede_tdesc as sede, g.jorn_tdesc as jornada 
from (
        select a.*,protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB') as direccion,protic.obtener_direccion_letra(b.pers_ncorr,1,'C-C') as comunas_alu,
        (select max(dp.post_ncorr) from postulantes po, detalle_postulantes dp where po.post_ncorr=dp.post_ncorr and po.peri_ccod=206 and po.pers_ncorr=b.pers_ncorr) as post_ncorr,
        (select max(dp.ofer_ncorr) from postulantes po, detalle_postulantes dp where po.post_ncorr=dp.post_ncorr and po.peri_ccod=206 and po.pers_ncorr=b.pers_ncorr) as ofer_ncorr
        from sd_antiguos_fuas_aprobados_2007 a, personas_postulante b
        where a.rut=b.pers_nrut
    ) as aa 
left outer join codeudor_postulacion b
    on aa.post_ncorr=b.post_ncorr
left outer join ofertas_academicas c
    on aa.ofer_ncorr=c.ofer_ncorr
left outer join especialidades d
    on c.espe_ccod=d.espe_ccod
left outer join carreras e
    on d.carr_ccod=e.carr_ccod    
left outer join sedes f  
    on c.sede_ccod=f.sede_ccod     
left outer join jornadas g
    on c.jorn_ccod=g.jorn_ccod
left outer join personas h
    on b.pers_ncorr=h.pers_ncorr   


