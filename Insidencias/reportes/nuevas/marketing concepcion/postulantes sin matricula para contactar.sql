select distinct protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,
f.carr_tdesc,pers_temail, pers_tfono, pers_tcelular  
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
    join personas_postulante h
        on a.pers_ncorr=h.pers_ncorr                                           
    where a.peri_ccod=214 
        and a.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49',
		   'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', 
 		   'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88',
  		   'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1') 
   and a.post_ncorr not in (select distinct post_ncorr from alumnos)
   and h.pers_nrut not in ( select  distinct pers_nrut from personas_eventos_upa where pers_nrut > 0 )
   
   
-- Solo rut y datos de contacto sin importar la carrera

select distinct protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,
pers_temail, pers_tfono, pers_tcelular  
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
    join personas_postulante h
        on a.pers_ncorr=h.pers_ncorr                                           
    where a.peri_ccod=218 
        and a.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49',
		   'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', 
 		   'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88',
  		   'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1') 
   and a.post_ncorr not in (select distinct post_ncorr from alumnos)
   and h.pers_nrut not in ( select  distinct pers_nrut from personas_eventos_upa where pers_nrut > 0 )   
Union
    select distinct protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,
    pers_temail, pers_tfono, pers_tcelular  
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
        join personas_postulante h
            on a.pers_ncorr=h.pers_ncorr                                           
        where a.peri_ccod=214 
            and a.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49',
		       'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', 
 		       'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88',
  		       'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1') 
       and a.post_ncorr not in (select distinct post_ncorr from alumnos)
       and h.pers_nrut not in ( select  distinct pers_nrut from personas_eventos_upa where pers_nrut > 0 ) 
Union
    select distinct protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,
    pers_temail, pers_tfono, pers_tcelular  
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
        join personas_postulante h
            on a.pers_ncorr=h.pers_ncorr                                           
        where a.peri_ccod=210 
            and a.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49',
		       'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', 
 		       'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88',
  		       'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1') 
       and a.post_ncorr not in (select distinct post_ncorr from alumnos)
       and h.pers_nrut not in ( select  distinct pers_nrut from personas_eventos_upa where pers_nrut > 0 )    