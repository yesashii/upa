select *,case when promedio_paa > '691.5' then 5 
when   promedio_paa >= '654.5' and promedio_paa < '691' then 4 
when   promedio_paa >= '630' and promedio_paa < '654' then 3
when   promedio_paa >= '610.5' and promedio_paa < '629.5' then 2  
when   promedio_paa >= '595' and promedio_paa < '610' then 1 
else 0 end as rango
 from  (
select cast((a.post_npaa_verbal + a.post_npaa_matematicas)/2 as decimal(5,1)) as promedio_paa,
a.post_npaa_verbal as verbal,a.post_npaa_matematicas as matematicas, protic.obtener_rut(a.pers_ncorr) as rut
from postulantes a , ofertas_academicas b, alumnos c
where a.peri_ccod in (202)
and a.post_bnuevo='S'
and a.ofer_ncorr=b.ofer_ncorr
and a.post_ncorr=c.post_ncorr
and b.ofer_ncorr=c.ofer_ncorr
and a.post_nano_paa=2005
) as tabla


