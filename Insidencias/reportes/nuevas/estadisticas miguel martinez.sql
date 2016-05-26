select distinct protic.obtener_rut(a.pers_ncorr) as rut, pers_temail, pers_tfono, pers_tcelular,sede_tdesc, eepo_tdesc, 
        protic.trunc(dpos_fexamen) as fecha_examen,f.carr_tdesc,g.jorn_tdesc as jornada,emat_tdesc,
        protic.es_nuevo_carrera(a.pers_ncorr,d.carr_ccod,a.peri_ccod) as nuevo, protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB-C') as direccion,
        pers_tnombre, pers_tape_paterno, pers_tape_materno 
 	from postulantes a 
 	join detalle_postulantes b 
    	on a.post_ncorr=b.post_ncorr
        and b.eepo_ccod not in (1,4) 
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
    join personas_postulante h
        on a.pers_ncorr=h.pers_ncorr
    join estado_examen_postulantes i
        on b.eepo_ccod=i.eepo_ccod
    join alumnos j
        on a.post_ncorr=j.post_ncorr
        and a.ofer_ncorr=j.ofer_ncorr
    join estados_matriculas k
       on j.emat_ccod=k.emat_ccod                                                   
    where a.peri_ccod=206
        and epos_ccod=2 
        and a.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49',
		   'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', 
 		   'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88',
  		   'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1')
        and a.audi_tusuario not like '%aju%'
   -- group by e.sede_ccod,sede_tdesc, a.epos_ccod, 
