select a.*,
(select case count(*) when 0 then 'NO' else 'SI' end from alumnos aa, ofertas_academicas bb
 where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=226
 and isnull(aa.alum_nmatricula,0) <> 7777 and aa.emat_ccod not in (6,9,11) ) as matriculado_2012,
isnull((select top 1 sede_tdesc 
 from alumnos aa, ofertas_academicas bb, sedes cc, especialidades dd, carreras ee
 where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=226
 and isnull(aa.alum_nmatricula,0) <> 7777 and aa.emat_ccod not in (6,9,11)
 and bb.sede_ccod=cc.sede_ccod and bb.espe_ccod=dd.espe_ccod and dd.carr_ccod=ee.carr_ccod
 order by emat_ccod asc), '-Sin Sede-') as sede,
isnull((select top 1 carr_tdesc 
 from alumnos aa, ofertas_academicas bb, sedes cc, especialidades dd, carreras ee
 where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=226
 and isnull(aa.alum_nmatricula,0) <> 7777 and aa.emat_ccod not in (6,9,11)
 and bb.sede_ccod=cc.sede_ccod and bb.espe_ccod=dd.espe_ccod and dd.carr_ccod=ee.carr_ccod
 order by emat_ccod asc),'-Sin Carrera-') as carrera 
from encuestas_postulantes a 
where peri_ccod=226