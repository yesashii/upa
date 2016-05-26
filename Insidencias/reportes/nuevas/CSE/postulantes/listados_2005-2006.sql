select rut,nombres,apellidos,
(select top 1 sede_tdesc from alumnos aa, ofertas_academicas bb, sedes cc 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod= case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end 
 and bb.sede_ccod=cc.sede_ccod order by aa.alum_fmatricula desc) as sede,
(select top 1 carr_tdesc from alumnos aa, ofertas_academicas bb, especialidades cc, carreras dd 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end
 and bb.espe_ccod=cc.espe_ccod and cc.carr_ccod=dd.carr_ccod order by aa.alum_fmatricula desc) as carrera,
(select top 1 jorn_tdesc from alumnos aa, ofertas_academicas bb, jornadas cc 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end 
 and bb.jorn_ccod=cc.jorn_ccod order by aa.alum_fmatricula desc ) as jornada,
(select top 1 espe_tdesc from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc) as especialidad,
(select top 1 emat_tdesc from alumnos aa, ofertas_academicas bb, estados_matriculas cc 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end 
 and aa.emat_ccod = cc.emat_ccod order by aa.alum_fmatricula desc ) as estado_matricula,
(select case count(*) when 0 then 'No tiene matricula 2005' else 'Con matricula 2005' end
 from alumnos alu, ofertas_academicas oa,especialidades es
 where alu.pers_ncorr=vista.pers_ncorr and alu.ofer_ncorr=oa.ofer_ncorr
 and oa.peri_ccod in (164,200,201) and oa.espe_ccod=es.espe_ccod
 and es.carr_ccod in (select top 1 carr_ccod from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc)) as año_2005,
 isnull((select top 1 emat_tdesc
 from alumnos alu, ofertas_academicas oa,especialidades es,estados_matriculas ema
 where alu.pers_ncorr=vista.pers_ncorr and alu.ofer_ncorr=oa.ofer_ncorr
 and oa.peri_ccod in (164,200,201) and oa.espe_ccod=es.espe_ccod and alu.emat_ccod=ema.emat_ccod
 and es.carr_ccod in (select top 1 carr_ccod from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc) order by oa.peri_ccod desc, alu.audi_fmodificacion desc),'') as ultimo_estado_2005,
 (select case count(*) when 0 then '' else 'cambio a OTRA CARRERA' end
 from alumnos alu, ofertas_academicas oa,especialidades es
 where alu.pers_ncorr=vista.pers_ncorr and alu.ofer_ncorr=oa.ofer_ncorr
 and oa.peri_ccod in (164,200,201) and oa.espe_ccod=es.espe_ccod and alu.emat_ccod in (1,4,8)
 and es.carr_ccod not in (select top 1 carr_ccod from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc)) as otra_carrera,
(select case count(*) when 0 then 'No tiene matricula 2006' else 'Con matricula 2006' end
 from alumnos alu, ofertas_academicas oa,especialidades es
 where alu.pers_ncorr=vista.pers_ncorr and alu.ofer_ncorr=oa.ofer_ncorr
 and oa.peri_ccod in (202,204,205) and oa.espe_ccod=es.espe_ccod
 and es.carr_ccod in (select top 1 carr_ccod from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc)) as año_2006,
 isnull((select top 1 emat_tdesc
 from alumnos alu, ofertas_academicas oa,especialidades es,estados_matriculas ema
 where alu.pers_ncorr=vista.pers_ncorr and alu.ofer_ncorr=oa.ofer_ncorr
 and oa.peri_ccod in (202,204,205) and oa.espe_ccod=es.espe_ccod and alu.emat_ccod=ema.emat_ccod
 and es.carr_ccod in (select top 1 carr_ccod from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc) order by oa.peri_ccod desc, alu.audi_fmodificacion desc),'') as ultimo_estado_2006,
  (select case count(*) when 0 then '' else 'cambio a OTRA CARRERA' end
 from alumnos alu, ofertas_academicas oa,especialidades es
 where alu.pers_ncorr=vista.pers_ncorr and alu.ofer_ncorr=oa.ofer_ncorr
 and oa.peri_ccod in (202,204,205) and oa.espe_ccod=es.espe_ccod and alu.emat_ccod in (1,4,8)
 and es.carr_ccod not in (select top 1 carr_ccod from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 160 when 2 then 162 when 3 then 23 when 4 then 24 end
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc)) as otra_carrera
from
( 
    select pers_ncorr,rut,nombres,apellidos,max(peri) as periodo
    from
    (
    select a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,
    b.pers_tnombre as nombres, b.pers_tape_paterno + ' ' + b.pers_tape_materno as apellidos,
    e.sede_tdesc as sede, f.carr_tdesc as carrera, g.jorn_tdesc as jornada, emat_tdesc as estado,
    case c.peri_ccod when 160 then 1 when 162 then 2 when 23 then 3 when 24 then 4 end as peri
    from alumnos a, personas b, ofertas_academicas c,especialidades d,sedes e, carreras f, jornadas g,estados_matriculas h
    where a.pers_ncorr=b.pers_ncorr
    and a.ofer_ncorr=c.ofer_ncorr
    and c.espe_ccod = d.espe_ccod
    and c.peri_ccod in (160)
    and c.sede_ccod=e.sede_ccod
    and d.carr_ccod=f.carr_ccod
    and c.jorn_ccod=g.jorn_ccod
    and a.emat_ccod=h.emat_ccod
    and a.emat_ccod <> 9
    --and convert(varchar,a.alum_fmatricula,103) <= convert(datetime,'30/04/2005',103)
    and not exists (select 1 from alumnos aa, ofertas_academicas bb, especialidades cc,periodos_academicos dd
                    where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr
                    and bb.espe_ccod=cc.espe_ccod and cc.carr_ccod=f.carr_ccod
                    and bb.peri_ccod=dd.peri_ccod and dd.anos_ccod < '2004')
    ) as tabla1
    group by pers_ncorr,rut,nombres,apellidos
) as vista
order by sede,carrera,jornada,apellidos

select rut,nombres,apellidos,
(select top 1 sede_tdesc from alumnos aa, ofertas_academicas bb, sedes cc 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod= case vista.periodo when 1 then 164 when 2 then 200 when 3 then 201 end 
 and bb.sede_ccod=cc.sede_ccod order by aa.alum_fmatricula desc) as sede,
(select top 1 carr_tdesc from alumnos aa, ofertas_academicas bb, especialidades cc, carreras dd 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 164 when 2 then 200 when 3 then 201 end 
 and bb.espe_ccod=cc.espe_ccod and cc.carr_ccod=dd.carr_ccod order by aa.alum_fmatricula desc) as carrera,
 (select top 1 espe_tdesc from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 164 when 2 then 200 when 3 then 201 end 
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc) as especialidad,
(select top 1 jorn_tdesc from alumnos aa, ofertas_academicas bb, jornadas cc 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 164 when 2 then 200 when 3 then 201 end 
 and bb.jorn_ccod=cc.jorn_ccod order by aa.alum_fmatricula desc ) as jornada,
(select top 1 emat_tdesc from alumnos aa, ofertas_academicas bb, estados_matriculas cc 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 164 when 2 then 200 when 3 then 201 end 
 and aa.emat_ccod = cc.emat_ccod order by aa.alum_fmatricula desc ) as estado_matricula,
(select case count(*) when 0 then 'No tiene matricula 2006' else 'Con matricula 2006' end
 from alumnos alu, ofertas_academicas oa,especialidades es
 where alu.pers_ncorr=vista.pers_ncorr and alu.ofer_ncorr=oa.ofer_ncorr
 and oa.peri_ccod in (202,204,205) and oa.espe_ccod=es.espe_ccod
 and es.carr_ccod in (select top 1 carr_ccod from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 164 when 2 then 200 when 3 then 201 end 
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc)) as año_2006,
 isnull((select top 1 emat_tdesc
 from alumnos alu, ofertas_academicas oa,especialidades es,estados_matriculas ema
 where alu.pers_ncorr=vista.pers_ncorr and alu.ofer_ncorr=oa.ofer_ncorr
 and oa.peri_ccod in (202,204,205) and oa.espe_ccod=es.espe_ccod and alu.emat_ccod=ema.emat_ccod
 and es.carr_ccod in (select top 1 carr_ccod from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 164 when 2 then 200 when 3 then 201 end 
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc) order by oa.peri_ccod desc, alu.audi_fmodificacion desc),'') as ultimo_estado_2006,
  (select case count(*) when 0 then '' else 'cambio a OTRA CARRERA' end
 from alumnos alu, ofertas_academicas oa,especialidades es
 where alu.pers_ncorr=vista.pers_ncorr and alu.ofer_ncorr=oa.ofer_ncorr
 and oa.peri_ccod in (202,204,205) and oa.espe_ccod=es.espe_ccod and alu.emat_ccod in (1,4,8)
 and es.carr_ccod not in (select top 1 carr_ccod from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 164 when 2 then 200 when 3 then 201 end 
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc)) as otra_carrera
from
( 
    select pers_ncorr,rut,nombres,apellidos,max(peri) as periodo
    from
    (
    select a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,
    b.pers_tnombre as nombres, b.pers_tape_paterno + ' ' + b.pers_tape_materno as apellidos,
    e.sede_tdesc as sede, f.carr_tdesc as carrera, g.jorn_tdesc as jornada, emat_tdesc as estado,
    case c.peri_ccod when 164 then 1 when 200 then 2 when 201 then 3 end as peri
    from alumnos a, personas b, ofertas_academicas c,especialidades d,sedes e, carreras f, jornadas g,estados_matriculas h
    where a.pers_ncorr=b.pers_ncorr
    and a.ofer_ncorr=c.ofer_ncorr
    and c.espe_ccod = d.espe_ccod
    and c.peri_ccod in (164,200,201)
    and c.sede_ccod=e.sede_ccod
    and d.carr_ccod=f.carr_ccod
    and c.jorn_ccod=g.jorn_ccod
    and a.emat_ccod=h.emat_ccod
    --and f.carr_ccod='51'
    and a.emat_ccod <> 9
    and convert(varchar,a.alum_fmatricula,103) <= convert(datetime,'30/04/2005',103)
    and not exists (select 1 from alumnos aa, ofertas_academicas bb, especialidades cc,periodos_academicos dd
                    where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr
                    and bb.espe_ccod=cc.espe_ccod and cc.carr_ccod=f.carr_ccod
                    and bb.peri_ccod=dd.peri_ccod and dd.anos_ccod < '2005')
    ) as tabla1
    group by pers_ncorr,rut,nombres,apellidos
) as vista
order by sede,carrera,jornada,apellidos




select rut,nombres,apellidos,
(select top 1 sede_tdesc from alumnos aa, ofertas_academicas bb, sedes cc 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod= case vista.periodo when 1 then 202 when 2 then 204 when 3 then 205 end
 and bb.sede_ccod=cc.sede_ccod order by aa.alum_fmatricula desc) as sede,
(select top 1 carr_tdesc from alumnos aa, ofertas_academicas bb, especialidades cc, carreras dd 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 202 when 2 then 204 when 3 then 205 end 
 and bb.espe_ccod=cc.espe_ccod and cc.carr_ccod=dd.carr_ccod order by aa.alum_fmatricula desc) as carrera,
 (select top 1 espe_tdesc from alumnos aa, ofertas_academicas bb, especialidades cc
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 202 when 2 then 204 when 3 then 205 end 
 and bb.espe_ccod=cc.espe_ccod order by aa.alum_fmatricula desc) as especialidad,
(select top 1 jorn_tdesc from alumnos aa, ofertas_academicas bb, jornadas cc 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 202 when 2 then 204 when 3 then 205 end 
 and bb.jorn_ccod=cc.jorn_ccod order by aa.alum_fmatricula desc ) as jornada,
(select top 1 emat_tdesc from alumnos aa, ofertas_academicas bb, estados_matriculas cc 
 where aa.pers_ncorr= vista.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr 
 and bb.peri_ccod=case vista.periodo when 1 then 202 when 2 then 204 when 3 then 205 end 
 and aa.emat_ccod = cc.emat_ccod order by aa.alum_fmatricula desc ) as estado_matricula
from
( 
    select pers_ncorr,rut,nombres,apellidos,max(peri) as periodo
    from
    (
    select a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,
    b.pers_tnombre as nombres, b.pers_tape_paterno + ' ' + b.pers_tape_materno as apellidos,
    e.sede_tdesc as sede, f.carr_tdesc as carrera, g.jorn_tdesc as jornada, emat_tdesc as estado,
    case c.peri_ccod when 202 then 1 when 204 then 2 when 205 then 3 end as peri
    from alumnos a, personas b, ofertas_academicas c,especialidades d,sedes e, carreras f, jornadas g,estados_matriculas h
    where a.pers_ncorr=b.pers_ncorr
    and a.ofer_ncorr=c.ofer_ncorr
    and c.espe_ccod = d.espe_ccod
    and c.peri_ccod in (202,204,205)
    and c.sede_ccod=e.sede_ccod
    and d.carr_ccod=f.carr_ccod
    and c.jorn_ccod=g.jorn_ccod
    and a.emat_ccod=h.emat_ccod
    --and f.carr_ccod='51'
    and a.emat_ccod <> 9
    and convert(varchar,a.alum_fmatricula,103) <= convert(datetime,'30/04/2006',103)
    and not exists (select 1 from alumnos aa, ofertas_academicas bb, especialidades cc,periodos_academicos dd
                    where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr
                    and bb.espe_ccod=cc.espe_ccod and cc.carr_ccod=f.carr_ccod
                    and bb.peri_ccod=dd.peri_ccod and dd.anos_ccod < '2006')
    ) as tabla1
    group by pers_ncorr,rut,nombres,apellidos
) as vista
order by sede,carrera,jornada,apellidos