select protic.obtener_rut(a.pers_ncorr) as rut,e.sede_ccod,sede_tdesc, a.epos_ccod,f.carr_tdesc,g.jorn_tdesc as jornada,
protic.es_nuevo_carrera(a.pers_ncorr,d.carr_ccod,a.peri_ccod) as nuevo, epos_ccod  
 	from postulantes a 
 	join detalle_postulantes b 
    	on a.post_ncorr=b.post_ncorr 
 	join ofertas_academicas c 
    	on b.ofer_ncorr=c.ofer_ncorr
	join especialidades d 
    	on c.espe_ccod=d.espe_ccod 
	join sedes e 
    	on c.sede_ccod=e.sede_ccod 
    join carreras f
        on d.carr_ccod=f.carr_ccod
    join jornadas g
        on c.jorn_ccod=g.jorn_ccod                        
    left outer join alumnos h
        on a.post_ncorr=h.post_ncorr
        and a.ofer_ncorr=b.ofer_ncorr   
    where a.peri_ccod=222 
        and a.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49',
		   'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', 
 		   'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88',
  		   'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1') 
   -- group by e.sede_ccod,sede_tdesc, a.epos_ccod, 
   --and a.post_ncorr not in (select distinct post_ncorr from alumnos)


    
