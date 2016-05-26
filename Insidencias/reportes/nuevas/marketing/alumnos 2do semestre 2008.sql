 select protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,protic.trunc(c.audi_fmodificacion) as fecha,
 a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre,
 a.pers_tfono as fono, case a.pers_temail when null then '' else ''+a.pers_temail+'' end  as email,
 h.sede_tdesc as sede,f.carr_tdesc as carrera,g.jorn_tdesc as jornada,
 cast(protic.trunc(i.audi_fmodificacion) as varchar)+'-->'+isnull(i.obpo_tobservacion,'--') as observacion
 from  
 personas_postulante a,postulantes b,detalle_postulantes c, 
 ofertas_academicas d,especialidades e,carreras f,jornadas g, 
 sedes h,observaciones_postulacion i 
 where a.pers_ncorr = b.pers_ncorr 
 and cast(b.peri_ccod as varchar)='212'
 and b.post_ncorr = c.post_ncorr 
 and c.ofer_ncorr = d.ofer_ncorr 
 and d.espe_ccod = e.espe_ccod  
 and e.carr_ccod = f.carr_ccod   
 and d.jorn_ccod = g.jorn_ccod  
 and d.sede_ccod = h.sede_ccod  
 --and isnull(c.eepo_ccod,1) =1
 and b.epos_ccod = 2
 and b.post_bnuevo='S'
 and c.post_ncorr *= i.post_ncorr 
 and c.ofer_ncorr *= i.ofer_ncorr 
 and b.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46',
            'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp',
            'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80',
            'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99')  
and not exists(select 1 from alumnos where pers_ncorr=a.pers_ncorr and emat_ccod in (1,4,8))  
order by rut          


