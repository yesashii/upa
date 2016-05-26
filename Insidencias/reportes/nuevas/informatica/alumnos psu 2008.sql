select protic.obtener_rut(a.pers_ncorr) as rut_alumno,post_npaa_verbal,post_npaa_matematicas,pers_nnota_ens_media,
g.sede_tdesc as sede,f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a, ofertas_academicas b, personas_postulante c, sexos d,especialidades e, carreras f ,sedes g, jornadas h, postulantes i
where a.ofer_ncorr=b.ofer_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.sexo_ccod=d.sexo_ccod
and b.sede_ccod=g.sede_ccod
and b.jorn_ccod=h.jorn_ccod
and b.espe_ccod=e.espe_ccod
and e.carr_ccod=f.carr_ccod
and a.post_ncorr=i.post_ncorr
and f.carr_ccod not in ('820','001')
and a.emat_ccod  in (1,2,4,8,13)
and b.peri_ccod=210
and b.post_bnuevo IN ('S')
and post_npaa_verbal is not null
and post_npaa_matematicas is not null
and pers_nnota_ens_media is not null
and a.pers_ncorr=129175
