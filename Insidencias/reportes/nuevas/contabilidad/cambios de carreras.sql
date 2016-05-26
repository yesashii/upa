select  a.rut,a.dv,g.emat_tdesc,c.ofer_ncorr,protic.trunc(c.alum_fmatricula) as fecha_matricula_actual,e.peri_tdesc as periodo_actual,
 protic.obtener_nombre_carrera(c.ofer_ncorr,'CE') as carrera_antigua,
 protic.trunc(i.alum_fmatricula) as fecha_matricula_anterior,f.peri_tdesc as periodo_carrera_anterior,
 protic.obtener_nombre_carrera(protic.ultima_carrera_diferente(c.matr_ncorr,c.ofer_ncorr,'o'),'CE') as carrera_anterior,
h.emat_tdesc as estado_matricula_anterior
from fox..sd_alumnos_softland a 
join personas b
    on a.rut=b.pers_nrut
left outer join  alumnos c
    on b.pers_ncorr=c.pers_ncorr
    and matr_ncorr = (select max(matr_ncorr) from alumnos where pers_ncorr=c.pers_ncorr)
left outer join ofertas_academicas d
    on c.ofer_ncorr=d.ofer_ncorr
left outer join periodos_academicos e
    on d.peri_ccod=e.peri_ccod
left outer join periodos_academicos f
   on protic.ultima_carrera_diferente(c.matr_ncorr,c.ofer_ncorr,'p')=f.peri_ccod
left outer join estados_matriculas g
    on c.emat_ccod=g.emat_ccod
left outer join estados_matriculas h    
    on protic.ultima_carrera_diferente(c.matr_ncorr,c.ofer_ncorr,'e')=h.emat_ccod
left outer join alumnos i    
    on protic.ultima_carrera_diferente(c.matr_ncorr,c.ofer_ncorr,'m')=i.matr_ncorr    
order by a.rut



--***********************************************************************************

select * from fox..sd_alumnos_softland
where rut not in (select pers_nrut from personas)

update fox..sd_alumnos_softland set rut=16196199 where rut=16196999

select * from detalle_ingresos where ding_ndocto=8594562


select protic.obtener_rut(pers_ncorr) as rut,pers_ncorr,a.ofer_ncorr,a.jorn_ccod,b.espe_ccod,b.carr_ccod,* 
from ofertas_academicas a, especialidades b, alumnos c
where a.ofer_ncorr=c.ofer_ncorr
and a.espe_ccod=b.espe_ccod
--and matr_ncorr=154636
and pers_ncorr=11284

16300827-0


  select pers_ncorr,a.jorn_ccod,b.espe_ccod,b.carr_ccod 
    from ofertas_academicas a, especialidades b, alumnos c
    where a.ofer_ncorr=c.ofer_ncorr
    and a.espe_ccod=b.espe_ccod
    and c.matr_ncorr=150234
	and c.ofer_ncorr=13557


            select c.ofer_ncorr
            from ofertas_academicas a, especialidades b, alumnos c
            where a.ofer_ncorr=c.ofer_ncorr
            and a.espe_ccod=b.espe_ccod
            and pers_ncorr=4496
            and (b.carr_ccod not in (43) or a.jorn_ccod not in(1))
            and a.peri_ccod in (164,200,202,204)
			order by a.peri_ccod desc