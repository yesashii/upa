select protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno, 
emat_tdesc as estado_matricula,sede_tdesc as sede, pers_temail, pers_tfono, 
protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') as carrera, socc_mmonto_solicitado as monto_solicitado,
case when socc_bsolicita=1 then 'SI' else 'NO' end as solicita_credito,
case when socc_brenovante=1 then 'SI' else 'NO' end as renovante,
case when socc_bmonto_solicitado=1 then 'SI' else 'NO' end as solicita_monto
from solicitud_credito_cae a 
join ofertas_academicas b 
    on a.ofer_ncorr=b.ofer_ncorr
    and b.peri_ccod in (230)
join sedes c 
    on b.sede_ccod=c.sede_ccod
join alumnos e
    on a.post_ncorr=e.post_ncorr 
join estados_matriculas f
    on a.ofer_ncorr=e.ofer_ncorr
    and e.emat_ccod=f.emat_ccod
join personas_postulante pp
    on a.pers_ncorr=pp.pers_ncorr    
