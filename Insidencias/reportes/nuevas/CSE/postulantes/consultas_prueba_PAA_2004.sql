select genero, cantidad, sede,carrera,especialidad,jornada,minimo, máximo,
cast((isnull(suma,0) / case cantidad2 when 0 then 1 else cantidad2 end) as decimal (4,1)) as promedio,
no_rindieron_psu,rindieron_PSU_anteriores,ponderado_ultimo_matriculado,
cast((isnull(suma_promedios,0) / case cantidad3 when 0 then 1 else cantidad3 end) as decimal (3,2)) as promedio_ens_media
from
(  
select sexo_tdesc as genero, count(*) as cantidad,
case g.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
f.carr_tdesc as carrera,e.espe_tdesc as especialidad, h.jorn_tdesc as jornada,
(select count(*) from postulantes po,personas pe where po.ofer_ncorr=b.ofer_ncorr 
 and po.pers_ncorr=pe.pers_ncorr and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004
 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) > 800.5 ) as mayores_800,
(select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 700.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 800 ) as entre_700_800,
(select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 600.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 700 ) as entre_600_700,
 (select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 575.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 600 ) as entre_575_600,  
 (select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 550.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 575 ) as entre_550_575,
 (select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0  
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 525.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 550 ) as entre_525_550,
 (select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 500.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 525 ) as entre_500_525,
(select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 475.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 500 ) as entre_475_500,
(select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 450.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 475 ) as entre_450_475,
(select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 425.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 450 ) as entre_425_450, 
(select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 400.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 425 ) as entre_400_425, 
(select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 375.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 400 ) as entre_375_400,
 (select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 350.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 375 ) as entre_350_375,
(select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 325.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 350 ) as entre_325_350,
 (select count(*) from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 300.5
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) <= 325 ) as entre_300_325,
(select min(cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) )
 from postulantes po,personas pe 
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 300.5) as minimo,
(select max(cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) )
 from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 300.5) as máximo,
(select sum(cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(7,2)) )
 from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 300.5) as suma,
(select count(*)
 from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1)) >= 300.5) as cantidad2,
(select count(*)
 from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and (isnull(po.post_nano_paa,0) <> 2004 or isnull(post_npaa_verbal,0) = 0 or isnull(post_npaa_matematicas,0) = 0)
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 ) as no_rindieron_psu,
(select count(*)
 from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa <= 2003 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 ) as rindieron_PSU_anteriores,
 (select top 1 cast(((isnull(post_npaa_verbal,0) + isnull(post_npaa_matematicas,0))/ 2) as decimal(4,1))
 from postulantes po,personas pe, alumnos alu
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod and po.post_nano_paa = 2004 and isnull(post_npaa_verbal,0) <> 0 and isnull(post_npaa_matematicas,0) <> 0
 and alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103)
 order by alu.alum_fmatricula desc) as ponderado_ultimo_matriculado,
 (select count(*)
 from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod 
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and isnull(pe.pers_nnota_ens_media,0) <> 0
 ) as cantidad3,
 (select sum(pe.pers_nnota_ens_media)
 from postulantes po,personas pe
 where po.ofer_ncorr = b.ofer_ncorr and po.pers_ncorr = pe.pers_ncorr
 and pe.sexo_ccod=c.sexo_ccod 
 and exists (select 1 from alumnos alu where alu.post_ncorr=po.post_ncorr 
 and alu.ofer_ncorr=po.ofer_ncorr and alu.emat_ccod in (1,2,4,8,13) and alu.alum_fmatricula <=convert(datetime,'30/04/2005',103) )
 and isnull(pe.pers_nnota_ens_media,0) <> 0
 ) as suma_promedios
from alumnos a, ofertas_academicas b, personas c, sexos d,especialidades e, carreras f ,sedes g, jornadas h
where a.ofer_ncorr=b.ofer_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.sexo_ccod=d.sexo_ccod
and b.sede_ccod=g.sede_ccod
and b.jorn_ccod=h.jorn_ccod
and b.espe_ccod=e.espe_ccod
and e.carr_ccod=f.carr_ccod
and f.tcar_ccod=1
and f.carr_ccod not in ('820')
and a.emat_ccod  in (1,2,4,8,13)
and a.alum_fmatricula <=convert(datetime,'30/04/2005',103)
and b.peri_ccod=164
and b.post_bnuevo IN ('S')
group by sexo_tdesc,c.sexo_ccod,g.sede_tdesc,f.carr_tdesc,e.espe_tdesc,h.jorn_tdesc,b.ofer_ncorr
)aaaaa