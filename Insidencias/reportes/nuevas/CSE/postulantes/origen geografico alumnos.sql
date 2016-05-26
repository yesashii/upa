-- Alumnos Primer año de colegios municipales
select sexo_tdesc as genero, count(*) as cantidad,
    case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
    f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a 
join ofertas_academicas b
    on a.ofer_ncorr=b.ofer_ncorr
join personas c
    on a.pers_ncorr=c.pers_ncorr
join sexos d
    on c.sexo_ccod=d.sexo_ccod
join especialidades e
    on b.espe_ccod=e.espe_ccod
join carreras f 
    on e.carr_ccod=f.carr_ccod
join sedes g
    on b.sede_ccod=g.sede_ccod
join jornadas h
    on b.jorn_ccod=h.jorn_ccod
join colegios i
    on c.cole_ccod =i.cole_ccod
    and i.tcol_ccod in (1,2)
where f.tcar_ccod=1
    and f.carr_ccod not in ('820')
    and a.emat_ccod  in (1,2,4,8,13)
    and a.alum_fmatricula <=convert(datetime,'30/04/2005',103)
    and b.peri_ccod=164
    and b.post_bnuevo IN ('S')
    and (select count(*) from postulantes where len(post_tcarrera_anterior)>1 and ties_ccod in (1,2) and pers_ncorr=a.pers_ncorr)=0
    group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc


-- Alumnos Primer año de colegios Particulares subencionados
select sexo_tdesc as genero, count(*) as cantidad,
    case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
    f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a 
join ofertas_academicas b
    on a.ofer_ncorr=b.ofer_ncorr
join personas c
    on a.pers_ncorr=c.pers_ncorr
join sexos d
    on c.sexo_ccod=d.sexo_ccod
join especialidades e
    on b.espe_ccod=e.espe_ccod
join carreras f 
    on e.carr_ccod=f.carr_ccod
join sedes g
    on b.sede_ccod=g.sede_ccod
join jornadas h
    on b.jorn_ccod=h.jorn_ccod
join colegios i
    on c.cole_ccod =i.cole_ccod
    and i.tcol_ccod in (3)
where f.tcar_ccod=1
    and f.carr_ccod not in ('820')
    and a.emat_ccod  in (1,2,4,8,13)
    and a.alum_fmatricula <=convert(datetime,'30/04/2005',103)
    and b.peri_ccod=164
    and b.post_bnuevo IN ('S')
    and (select count(*) from postulantes where len(post_tcarrera_anterior)>1 and ties_ccod in (1,2) and pers_ncorr=a.pers_ncorr)=0
    group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc

-- Alumnos Primer año de colegios Privados Pagados
select sexo_tdesc as genero, count(*) as cantidad,
    case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
    f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a 
join ofertas_academicas b
    on a.ofer_ncorr=b.ofer_ncorr
join personas c
    on a.pers_ncorr=c.pers_ncorr
join sexos d
    on c.sexo_ccod=d.sexo_ccod
join especialidades e
    on b.espe_ccod=e.espe_ccod
join carreras f 
    on e.carr_ccod=f.carr_ccod
join sedes g
    on b.sede_ccod=g.sede_ccod
join jornadas h
    on b.jorn_ccod=h.jorn_ccod
join colegios i
    on c.cole_ccod =i.cole_ccod
    and i.tcol_ccod in (4,5)
where f.tcar_ccod=1
    and f.carr_ccod not in ('820')
    and a.emat_ccod  in (1,2,4,8,13)
    and a.alum_fmatricula <=convert(datetime,'30/04/2005',103)
    and b.peri_ccod=164
    and b.post_bnuevo IN ('S')
    and (select count(*) from postulantes where len(post_tcarrera_anterior)>1 and ties_ccod in (1,2) and pers_ncorr=a.pers_ncorr)=0
    group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc


--********************************************************
-- Alumnos Primer año provenientes de otra universidad
select sexo_tdesc as genero, count(*) as cantidad,
    case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
    f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a 
join ofertas_academicas b
    on a.ofer_ncorr=b.ofer_ncorr
join personas c
    on a.pers_ncorr=c.pers_ncorr
join sexos d
    on c.sexo_ccod=d.sexo_ccod
join especialidades e
    on b.espe_ccod=e.espe_ccod
join carreras f 
    on e.carr_ccod=f.carr_ccod
join sedes g
    on b.sede_ccod=g.sede_ccod
join jornadas h
    on b.jorn_ccod=h.jorn_ccod
where f.tcar_ccod=1
    and f.carr_ccod not in ('820')
    and a.emat_ccod  in (1,2,4,8,13)
    and a.alum_fmatricula <=convert(datetime,'30/04/2006',103)
    and b.peri_ccod=202
    and b.post_bnuevo IN ('S')
    and (select count(*) from postulantes where len(post_tcarrera_anterior)>1 and ties_ccod in (1,2) and pers_ncorr=a.pers_ncorr)>0
    group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc


--********************************************************
-- Alumnos Primer año provenientes de la upacifico pero de otro programa
select sexo_tdesc as genero, count(*) as cantidad,
    case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
    f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a 
join ofertas_academicas b
    on a.ofer_ncorr=b.ofer_ncorr
join personas c
    on a.pers_ncorr=c.pers_ncorr
join sexos d
    on c.sexo_ccod=d.sexo_ccod
join especialidades e
    on b.espe_ccod=e.espe_ccod
join carreras f 
    on e.carr_ccod=f.carr_ccod
join sedes g
    on b.sede_ccod=g.sede_ccod
join jornadas h
    on b.jorn_ccod=h.jorn_ccod
where f.tcar_ccod=1
    and f.carr_ccod not in ('820')
    and a.emat_ccod  in (1,2,4,8,13)
    and a.alum_fmatricula <=convert(datetime,'30/04/2005',103)
    and b.peri_ccod=164
    and b.post_bnuevo IN ('S')
    and (select count(*) from alumnos x, ofertas_academicas y 
        where x.ofer_ncorr=y.ofer_ncorr
        and x.pers_ncorr=a.pers_ncorr
        and y.espe_ccod <>e.espe_ccod
        and y.peri_ccod <164 ) >0
    group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc

--********************************************************

-- Alumnos Primer año de otros colegios
select sexo_tdesc as genero, count(*) as cantidad,
    case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
    f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a 
join ofertas_academicas b
    on a.ofer_ncorr=b.ofer_ncorr
join personas c
    on a.pers_ncorr=c.pers_ncorr
join sexos d
    on c.sexo_ccod=d.sexo_ccod
join especialidades e
    on b.espe_ccod=e.espe_ccod
join carreras f 
    on e.carr_ccod=f.carr_ccod
join sedes g
    on b.sede_ccod=g.sede_ccod
join jornadas h
    on b.jorn_ccod=h.jorn_ccod
left outer join colegios i
    on c.cole_ccod =i.cole_ccod
    --and i.tcol_ccod is null
where f.tcar_ccod=1
    and f.carr_ccod not in ('820')
    and a.emat_ccod  in (1,2,4,8,13)
    and a.alum_fmatricula <=convert(datetime,'30/04/2006',103)
    and b.peri_ccod=202
    and b.post_bnuevo IN ('S')
    and (select count(*) from postulantes where len(post_tcarrera_anterior)>1 and ties_ccod in (1,2) and pers_ncorr=a.pers_ncorr)=0
    group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc

--********************************************************

-- Alumnos Primer año de la misma  region
select sexo_tdesc as genero, count(*) as cantidad,
    case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
    f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a 
join ofertas_academicas b
    on a.ofer_ncorr=b.ofer_ncorr
join personas c
    on a.pers_ncorr=c.pers_ncorr
join sexos d
    on c.sexo_ccod=d.sexo_ccod
join especialidades e
    on b.espe_ccod=e.espe_ccod
join carreras f 
    on e.carr_ccod=f.carr_ccod
join sedes g
    on b.sede_ccod=g.sede_ccod
join jornadas h
    on b.jorn_ccod=h.jorn_ccod
join direcciones i
    on a.pers_ncorr=i.pers_ncorr
    and tdir_ccod=1
join ciudades j
    on i.ciud_ccod=j.ciud_ccod   
where f.tcar_ccod=1
    and f.carr_ccod not in ('820')
    and a.emat_ccod  in (1,2,4,8,13)
    and a.alum_fmatricula <=convert(datetime,'30/04/2005',103)
    and b.peri_ccod=164
    and b.post_bnuevo IN ('S')
    and regi_ccod in (13)
    --and c.pais_ccod not in (1)
    group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc


-- Alumnos Primer año distinta region de la sede
select sexo_tdesc as genero, count(*) as cantidad,
    case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
    f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a 
join ofertas_academicas b
    on a.ofer_ncorr=b.ofer_ncorr
join personas c
    on a.pers_ncorr=c.pers_ncorr
join sexos d
    on c.sexo_ccod=d.sexo_ccod
join especialidades e
    on b.espe_ccod=e.espe_ccod
join carreras f 
    on e.carr_ccod=f.carr_ccod
join sedes g
    on b.sede_ccod=g.sede_ccod
join jornadas h
    on b.jorn_ccod=h.jorn_ccod
join direcciones i
    on a.pers_ncorr=i.pers_ncorr
    and tdir_ccod=1
join ciudades j
    on i.ciud_ccod=j.ciud_ccod   
where f.tcar_ccod=1
    and f.carr_ccod not in ('820')
    and a.emat_ccod  in (1,2,4,8,13)
    and a.alum_fmatricula <=convert(datetime,'30/04/2005',103)
    and b.peri_ccod=164
    and b.post_bnuevo IN ('S')
    and regi_ccod not in (13)
   -- and c.pais_ccod not in (1)
    group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc


-- Alumnos nuevos con ingresos como deportistas destacados
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
and a.pers_ncorr in (105281,109204,104212,104197,109131,109497,109499,98882,104113)-- deportistas destacados
group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc

--********************************************************
-- Alumnos Primer año PROfesionales de otra Universidad
select sexo_tdesc as genero, count(*) as cantidad,
    case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
    f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a 
join ofertas_academicas b
    on a.ofer_ncorr=b.ofer_ncorr
join personas c
    on a.pers_ncorr=c.pers_ncorr
join sexos d
    on c.sexo_ccod=d.sexo_ccod
join especialidades e
    on b.espe_ccod=e.espe_ccod
join carreras f 
    on e.carr_ccod=f.carr_ccod
join sedes g
    on b.sede_ccod=g.sede_ccod
join jornadas h
    on b.jorn_ccod=h.jorn_ccod
where f.tcar_ccod=1
    and f.carr_ccod not in ('820')
    and a.emat_ccod  in (1,2,4,8,13)
    and a.alum_fmatricula <=convert(datetime,'30/04/2006',103)
    and b.peri_ccod=202
    and b.post_bnuevo IN ('S')
    and (select count(*) from postulantes where len(post_tcarrera_anterior)>1 and ties_ccod in (1,2) and post_btitulado='S' and pers_ncorr=a.pers_ncorr)>0
    group by sexo_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc

--  Alumnos Extranjeros por sexo
select i.sexo_tdesc as genero,d.pais_tdesc as pais_origen, count(*) as cantidad,
case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada
from alumnos a, ofertas_academicas b, personas c, paises d,especialidades e, carreras f ,sedes g, jornadas h,sexos i
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
and c.sexo_ccod=i.sexo_ccod
group by d.pais_tdesc,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc,i.sexo_tdesc



-- Alumnos segun formacion Colegio
    select   case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
    e.sexo_tdesc as genero,tens_tdesc as tipo_formacion, count(*) as cantidad
    from alumnos a, ofertas_academicas b, personas c, tipos_ensenanza_media d, sedes g,sexos e
    where a.ofer_ncorr=b.ofer_ncorr
    and a.pers_ncorr=c.pers_ncorr
    and b.sede_ccod=g.sede_ccod
    and c.tens_ccod=d.tens_ccod
    and c.sexo_ccod=e.sexo_ccod
    and a.emat_ccod  in (1,2,4,8,13)
    and b.post_bnuevo IN ('S')
    and a.alum_fmatricula <=convert(datetime,'30/04/2006',103)
    and b.peri_ccod=202
    group by g.sede_tdesc,e.sexo_tdesc,tens_tdesc
order by g.sede_tdesc desc,e.sexo_tdesc,tens_tdesc


-- Alumnos segun tipo de Administracion de la enseñanza
select sede,genero,b.tcol_tdesc as tipo_colegio,sum(cantidad) as cantidad_matriculas
from (    
    select e.sexo_tdesc as genero,isnull(tcol_ccod,0) as tipo_colegio, count(*) as cantidad,
    case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede
    from alumnos a, ofertas_academicas b, personas c, colegios d, sedes g,sexos e
    where a.ofer_ncorr=b.ofer_ncorr
    and a.pers_ncorr=c.pers_ncorr
    and b.sede_ccod=g.sede_ccod
    and c.cole_ccod*=d.cole_ccod
    and c.sexo_ccod=e.sexo_ccod
    and a.emat_ccod  in (1,2,4,8,13)
    and b.post_bnuevo IN ('S')
    and a.alum_fmatricula <=convert(datetime,'30/04/2006',103)
    and b.peri_ccod=202
    group by g.sede_tdesc,e.sexo_tdesc,tcol_ccod
) as a, tipos_colegios b
where a.tipo_colegio=b.tcol_ccod
group by  sede,b.tcol_tdesc,genero
order by sede,b.tcol_tdesc,genero
   