-- valores de matricula y arancel
select a.ofer_ncorr, case e.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,c.carr_tdesc as carrera,b.espe_tdesc as especialidad,f.jorn_tdesc as jornada,
cast(h.aran_mmatricula as numeric) as Matricula, cast(aran_mcolegiatura as numeric) as Arancel 
from ofertas_academicas a, especialidades b, carreras c , tipos_carrera d, 
sedes e, jornadas f, aranceles h --, tipos_grados_carreras g
where a.peri_ccod=164 
    and a.post_bnuevo='S'
    and a.espe_ccod=b.espe_ccod
    and b.carr_ccod=c.carr_ccod
    and c.carr_ccod not in ('820','001')
    and c.tcar_ccod=d.tcar_ccod
    and a.sede_ccod=e.sede_ccod
    and a.jorn_ccod=f.jorn_ccod
    and a.aran_ncorr=h.aran_ncorr
    and c.tcar_ccod=1


-- numero de vacantes por programa
select case e.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,c.carr_tdesc as carrera,b.espe_tdesc as especialidad,f.jorn_tdesc as jornada,
a.ofer_nvacantes as vacantes,a.ofer_nquorum as minimo 
from ofertas_academicas a, especialidades b, carreras c , tipos_carrera d, 
sedes e, jornadas f--, tipos_grados_carreras g
where a.peri_ccod=164 
    and a.post_bnuevo='S'
    and a.espe_ccod=b.espe_ccod
    and b.carr_ccod=c.carr_ccod
    and c.carr_ccod not in ('820','001')
    and c.tcar_ccod=d.tcar_ccod
    and a.sede_ccod=e.sede_ccod
    and a.jorn_ccod=f.jorn_ccod
   -- and c.tgra_ccod*=g.tgra_ccod
    and c.tcar_ccod=1
    --and b.espe_nduracion >1



-- Total Postulantes Hombres y Mujeres primer año
select sexo_tdesc as genero, count(*) as cantidad,
case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from postulantes a, ofertas_academicas b, personas c, sexos d,especialidades e, carreras f ,sedes g, jornadas h
where a.ofer_ncorr=b.ofer_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.sexo_ccod=d.sexo_ccod
and b.sede_ccod=g.sede_ccod
and b.jorn_ccod=h.jorn_ccod
and b.espe_ccod=e.espe_ccod
and e.carr_ccod=f.carr_ccod
and f.tcar_ccod=1
and f.carr_ccod not in ('820','001')
and a.epos_ccod=2
and a.post_fpostulacion <=convert(datetime,'30/04/2005',103)
and b.peri_ccod=164
and b.post_bnuevo IN ('S')
group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc


-- Total Postulantes Extranjeros primer año
select d.pais_tdesc as pais_origen, count(*) as cantidad,
case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from postulantes a, ofertas_academicas b, personas c, paises d,especialidades e, carreras f ,sedes g, jornadas h
where a.ofer_ncorr=b.ofer_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.pais_ccod=d.pais_ccod
and b.sede_ccod=g.sede_ccod
and b.jorn_ccod=h.jorn_ccod
and b.espe_ccod=e.espe_ccod
and e.carr_ccod=f.carr_ccod
and f.tcar_ccod=1
and f.carr_ccod not in ('820','001')
and a.epos_ccod=2
and a.post_fpostulacion <=convert(datetime,'30/04/2005',103)
and b.peri_ccod=164
and b.post_bnuevo IN ('S')
and c.pais_ccod not in (1)
group by d.pais_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc

-- Total Postulantes Extranjeros totales (nuevos y antiguos)
select d.pais_tdesc as pais_origen, count(*) as cantidad,
case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from postulantes a, ofertas_academicas b, personas c, paises d,especialidades e, carreras f ,sedes g, jornadas h
where a.ofer_ncorr=b.ofer_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.pais_ccod=d.pais_ccod
and b.sede_ccod=g.sede_ccod
and b.jorn_ccod=h.jorn_ccod
and b.espe_ccod=e.espe_ccod
and e.carr_ccod=f.carr_ccod
and f.tcar_ccod=1
and f.carr_ccod not in ('820','001')
and a.epos_ccod=2
and a.post_fpostulacion <=convert(datetime,'30/04/2005',103)
and b.peri_ccod=164
and b.post_bnuevo IN ('S','N')
and c.pais_ccod not in (1)
group by d.pais_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc


-- Total Matriculados Extranjeros primer año
select d.pais_tdesc as pais_origen, count(*) as cantidad,
case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a, ofertas_academicas b, personas c, paises d,especialidades e, carreras f ,sedes g, jornadas h
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
and a.alum_fmatricula <=convert(datetime,'30/04/2006',103)
and b.peri_ccod=202
and b.post_bnuevo IN ('S')
and c.pais_ccod not in (1)
group by d.pais_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc


-- Total Hombres y Mujeres primer año
select sexo_tdesc as genero, count(*) as cantidad,
case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a, ofertas_academicas b, personas c, sexos d,especialidades e, carreras f ,sedes g, jornadas h
where a.ofer_ncorr=b.ofer_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.sexo_ccod=d.sexo_ccod
and b.sede_ccod=g.sede_ccod
and b.jorn_ccod=h.jorn_ccod
and b.espe_ccod=e.espe_ccod
and e.carr_ccod=f.carr_ccod
and f.tcar_ccod=1
and f.carr_ccod not in ('820','001')
and a.emat_ccod  in (1,2,4,8,13)
and a.alum_fmatricula <=convert(datetime,'30/04/2006',103)
and b.peri_ccod=202
and b.post_bnuevo IN ('S')
group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc

-- Total Hombres y Mujeres total matriculados
select sexo_tdesc as genero, count(*) as cantidad,
case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a, ofertas_academicas b, personas c, sexos d,especialidades e, carreras f ,sedes g, jornadas h
where a.ofer_ncorr=b.ofer_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.sexo_ccod=d.sexo_ccod
and b.sede_ccod=g.sede_ccod
and b.jorn_ccod=h.jorn_ccod
and b.espe_ccod=e.espe_ccod
and e.carr_ccod=f.carr_ccod
and f.tcar_ccod=1
and f.carr_ccod not in ('820','001')
and a.emat_ccod  in (1,2,4,8,13)
and a.alum_fmatricula <=convert(datetime,'30/04/2005',103)
and b.peri_ccod=164
and b.post_bnuevo IN ('S','N')
group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc


-- Total Matriculados Extranjeros totales
select d.pais_tdesc as pais_origen, count(*) as cantidad,
case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a, ofertas_academicas b, personas c, paises d,especialidades e, carreras f ,sedes g, jornadas h
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
and a.alum_fmatricula <=convert(datetime,'30/04/2005',103)
and b.peri_ccod=164
and b.post_bnuevo IN ('S','N')
and c.pais_ccod not in (1)
group by d.pais_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc


--*************************************************
-- Alumnos por programa (PSU,PAA,NEM)
select protic.obtener_rut(a.pers_ncorr) as rut_alumno,post_npaa_verbal,post_npaa_matematicas,pers_nnota_ens_media,
case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a, ofertas_academicas b, personas c, sexos d,especialidades e, carreras f ,sedes g, jornadas h, postulantes i
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
and a.alum_fmatricula <=convert(datetime,'30/04/2006',103)
and b.peri_ccod=202
and b.post_bnuevo IN ('S')
and post_npaa_verbal is not null
and post_npaa_matematicas is not null
and pers_nnota_ens_media is not null
and g.sede_tdesc <> 'MELIPILLA'
group by a.pers_ncorr,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc,post_npaa_verbal,post_npaa_matematicas,pers_nnota_ens_media
order by sede,f.carr_tdesc,e.espe_tdesc
