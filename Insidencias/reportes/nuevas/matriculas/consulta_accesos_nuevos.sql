select cast(f.pers_nrut as varchar)+'-'+pers_xdv as rut, f.pers_tnombre as nombre,
f.pers_tape_paterno as ape_paterno,f.pers_tape_materno as ape_materno,
c.sede_tdesc as sede, e.carr_tdesc as carrera,case b.post_bnuevo when 'S' then 'Nuevo' else 'Antiguo' end as tipo_alumno,
g.susu_tlogin as login, g.susu_tclave as clave,
(select top 1 lower(email_upa) from sd_cuentas_email_totales tt where tt.rut=f.pers_nrut) as email_upa
from alumnos a, ofertas_academicas b, sedes c, especialidades d, carreras e, personas f,sis_usuarios g
where a.ofer_ncorr=b.ofer_ncorr 
and b.sede_ccod=c.sede_ccod 
and b.espe_Ccod=d.espe_ccod
and d.carr_ccod=e.carr_ccod 
and a.pers_ncorr=f.pers_ncorr 
and a.emat_ccod=1
and b.peri_ccod=214 
--and b.post_bnuevo='S' 
and e.tcar_ccod=1
and a.pers_ncorr=g.pers_ncorr 
and e.carr_ccod in ('51','990','980') 
and b.jorn_ccod in (1,2)
and b.sede_ccod=2 
order by sede,tipo_alumno desc, carrera, ape_paterno


