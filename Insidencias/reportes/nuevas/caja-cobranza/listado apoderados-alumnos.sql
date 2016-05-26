-- LISTADO DE APODERADOS Y SUS ALUMNOS DADOS
select nombre_apoderado,rut,dv, protic.obtener_rut(b.pers_ncorr) as rut_alumno, 
protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno,protic.ES_MOROSO_MONTO(b.pers_ncorr,getdate()) monto_morosidad
from (
    select nombre_apoderado,dv,rut,max(c.post_ncorr)as post_ncorr,c.pers_ncorr 
    from sd_apoderados_deudores a
    left outer join personas b
     on  a.rut=b.pers_nrut
    left outer join codeudor_postulacion c
        on b.pers_ncorr=c.pers_ncorr 
    group by nombre_apoderado,dv,rut,c.pers_ncorr
) aa
left outer join postulantes b
    on aa.post_ncorr=b.post_ncorr
left outer join personas c
    on b.pers_ncorr=c.pers_ncorr    
    


select * from aranceles where ofer_ncorr=28678
select * from postulantes where post_ncorr=147823
