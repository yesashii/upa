select post_bnuevo as nuevo,max(arancel_neto) as arancel_neto, max(matricula_neta) as matricula_neta,
max(arancel_bruto) as arancel_bruto, max(matricula_bruta) as matricula_bruta,
rut,nombre_alumno,pais_origen,sede,carrera,jornada, min(fecha) as fecha
 from (
select distinct case j.tcom_ccod when 1 then cast(j.comp_mneto as numeric) end  as matricula_bruta,
case j.tcom_ccod when 1 then cast(j.comp_mdocumento as numeric) end  as matricula_neta,
case j.tcom_ccod when 2 then cast(j.comp_mneto as numeric) end  as arancel_bruto,
case j.tcom_ccod when 2 then cast(j.comp_mdocumento as numeric) end  as arancel_neto,
protic.trunc(cont_fcontrato) as fecha,post_bnuevo,
protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno,
d.pais_tdesc as pais_origen, g.sede_tdesc as sede,f.carr_tdesc as carrera, h.jorn_tdesc as jornada
from alumnos a, ofertas_academicas b, personas c, paises d,
especialidades e, carreras f ,sedes g, jornadas h, contratos i, compromisos j
where a.ofer_ncorr=b.ofer_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.pais_ccod=d.pais_ccod
and b.sede_ccod=g.sede_ccod
and b.jorn_ccod=h.jorn_ccod
and b.espe_ccod=e.espe_ccod
and e.carr_ccod=f.carr_ccod
and f.tcar_ccod=1
and f.carr_ccod not in ('820','001')
and a.emat_ccod  in (1,2,4,8,13)
and b.peri_ccod in (206,208)
--and b.post_bnuevo IN ('S')
and a.matr_ncorr=i.matr_ncorr
and c.pais_ccod not in (1)
and j.tcom_ccod in (1,2)
and i.cont_ncorr=j.comp_ndocto
) as tabla
group by post_bnuevo,rut,nombre_alumno,pais_origen,sede,carrera,jornada


