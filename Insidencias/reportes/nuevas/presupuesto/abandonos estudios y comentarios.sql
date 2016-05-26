--datos para crea matricula 2007
select tabla_1.*,(select top 1 ofe.ofer_ncorr 
          from ofertas_Academicas ofe, aranceles ar 
          where ofe.aran_ncorr=ar.aran_ncorr
          and ofe.sede_ccod = tabla_1.sede_ccod and tabla_1.jorn_ccod=ofe.jorn_ccod and tabla_1.espe_ccod=ofe.espe_ccod
          and ofe.post_bnuevo='N' and ar.aran_nano_ingreso='2006' and ofe.peri_ccod=206) as nueva_oferta
   from   
   
   (select e.pers_ncorr, (select  top 1 espe_ccod from alumnos aa,personas cc, 
                ofertas_academicas bb where aa.pers_ncorr=cc.pers_ncorr and cc.pers_nrut=a.rut and aa.ofer_ncorr=bb.ofer_ncorr
                and aa.emat_ccod <> 9 order by alum_fmatricula desc) as espe_ccod,
  (select  top 1 plan_ccod from alumnos aa,personas cc, 
                ofertas_academicas bb where aa.pers_ncorr=cc.pers_ncorr and cc.pers_nrut=a.rut and aa.ofer_ncorr=bb.ofer_ncorr
                and aa.emat_ccod <> 9 order by alum_fmatricula desc) as plan_ccod, d.sede_ccod, c.jorn_ccod,
   (select  top 1 post_ncorr from alumnos aa,personas cc, 
                ofertas_academicas bb where aa.pers_ncorr=cc.pers_ncorr and cc.pers_nrut=a.rut and aa.ofer_ncorr=bb.ofer_ncorr
                and aa.emat_ccod <> 9 order by alum_fmatricula desc) as post_ncorr                             
   from sd_abandonos_2007 a, carreras b, jornadas c, sedes d,personas e
   where a.carrera=b.carr_tdesc 
   and a.jornada = c.jorn_tdesc 
   and a.sede = d.sede_tdesc
   and a.rut=e.pers_nrut) as tabla_1


select * from postulantes where post_ncorr=60984

--datos base para obtener oferta
select carr_ccod,jorn_ccod,sede_ccod,e.pers_ncorr 
from sd_abandonos_2007 a, carreras b, jornadas c, sedes d, personas e
where a.carrera=b.carr_tdesc
and jornada=c.jorn_tdesc
and sede=d.sede_tdesc
and a.rut=e.pers_nrut


-- ultima oferta academica
select distinct pers_ncorr, max(b.ofer_ncorr) as ofer_ncorr
from alumnos a, ofertas_academicas b 
where a.pers_ncorr in (
    select e.pers_ncorr 
    from sd_abandonos_2007 a, personas e
    where a.rut=e.pers_nrut
)
and a.ofer_ncorr=b.ofer_ncorr
and b.peri_ccod in (202,204)
group by pers_ncorr




select top 1 * from ofertas_academicas a, aranceles b 
where a.aran_ncorr=b.aran_ncorr
and a.espe_ccod=263 
and a.peri_ccod=206 
and a.sede_ccod=1 
and a.jorn_ccod=1 
and b.aran_nano_ingreso=2006

