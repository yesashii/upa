46098
bci-->santander --> 0017080-1


   select '' as ofer_ncorr,'Selecciona el Postgrado a Postular' as carrera_ofertada,0 as orden
	union 
	select cast(a.ofer_ncorr as varchar) as ofer_ncorr,
	carrera  as carrera_ofertada,orden
	from ofertas_academicas a, sedes b, especialidades c, carreras d, jornadas e,orden_carreras_admision f
	where a.sede_ccod=b.sede_ccod and a.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod
	and a.jorn_ccod=e.jorn_ccod and cast(a.peri_ccod as varchar)='222' and a.post_bnuevo='S'
	and a.sede_ccod=f.sede_ccod and a.jorn_ccod=f.jorn_ccod and f.carr_ccod=d.carr_ccod
	and ofer_bactiva = 'S' and d.tcar_ccod=2
	and not exists (select 1 from detalle_postulantes bb where bb.ofer_ncorr=a.ofer_ncorr and cast(bb.post_ncorr as varchar)='180245')
	UNION
    select cast(a.ofer_ncorr as varchar) as ofer_ncorr,
	carrera  as carrera_ofertada,orden
	from ofertas_academicas a, sedes b, especialidades c, carreras d, jornadas e,orden_carreras_admision f
	where a.sede_ccod=b.sede_ccod and a.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod
	and a.jorn_ccod=e.jorn_ccod and cast(a.peri_ccod as varchar)='222' and a.post_bnuevo='S'
	and a.sede_ccod=f.sede_ccod and a.jorn_ccod=f.jorn_ccod and f.carr_ccod=d.carr_ccod
	and ofer_bactiva = 'S' and d.tcar_ccod=1 AND d.carr_ccod='600'
	and not exists (select 1 from detalle_postulantes bb where bb.ofer_ncorr=a.ofer_ncorr and cast(bb.post_ncorr as varchar)='180245')
	order by orden


 select c.ofer_ncorr,protic.initcap(sede_tdesc)as sede, protic.initcap(g.carr_tdesc) as carrera,
				 protic.initcap(h.jorn_tdesc) as jornada, protic.trunc(b.audi_fmodificacion) as fecha 
				 from postulantes a,detalle_postulantes b, ofertas_academicas c, sedes d, especialidades f,
				 carreras g, jornadas h
				 where a.post_ncorr = b.post_ncorr and b.ofer_ncorr = c.ofer_ncorr and c.sede_ccod = d.sede_ccod
				 and c.espe_ccod = f.espe_ccod and f.carr_ccod = g.carr_ccod and c.jorn_ccod=h.jorn_ccod
				 and cast(a.peri_ccod as varchar)='226' and cast(a.pers_ncorr as varchar)='30126'
				 and g.tcar_ccod=2
				 order by sede,carrera,jornada