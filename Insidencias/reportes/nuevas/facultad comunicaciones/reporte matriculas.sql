select protic.obtener_rut(a.pers_ncorr) as rut,e.sede_tdesc,f.carr_tdesc,g.jorn_tdesc as jornada,
case when protic.es_nuevo_carrera(a.pers_ncorr,d.carr_ccod,a.peri_ccod)='S' then 'SI' else 'NO' end as nuevo, case when epos_ccod=1 then 'Sin enviar' Else 'Enviada' end as estado_postulacion, ep.eepo_tdesc as estado_postulacion, 
isnull((select emat_tdesc from estados_matriculas where emat_ccod=h.emat_ccod),'Sin Matricula')  as estado_matricula
 	from postulantes a 
 	join detalle_postulantes b 
    	on a.post_ncorr=b.post_ncorr
    left outer join estado_examen_postulantes ep
        on b.eepo_ccod=ep.eepo_ccod      
 	join ofertas_academicas c 
    	on b.ofer_ncorr=c.ofer_ncorr
	join especialidades d 
    	on c.espe_ccod=d.espe_ccod
	join sedes e 
    	on c.sede_ccod=e.sede_ccod 
    join carreras f
        on d.carr_ccod=f.carr_ccod
    join areas_academicas ac
        on f.area_ccod=ac.area_ccod  
    join jornadas g
        on c.jorn_ccod=g.jorn_ccod                        
    left outer join alumnos h
        on a.post_ncorr=h.post_ncorr
        and a.ofer_ncorr=b.ofer_ncorr
    where a.peri_ccod=222
        and ac.facu_ccod= 3
        and c.sede_ccod=1
        and a.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49',
		   'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', 
 		   'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88',
  		   'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1') 
   order by f.carr_tdesc desc
