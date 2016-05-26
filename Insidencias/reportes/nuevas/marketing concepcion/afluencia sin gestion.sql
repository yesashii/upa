select rut,sede_tdesc as sede,carr_tdesc as carera,jornada, case When epos_ccod=1 and nuevo='S' then 1 end  EN_PROCESO_n,
       case When epos_ccod=1 and nuevo='N' then 1 end  EN_PROCESO_a,
       case When epos_ccod=2 and nuevo='S' then 1 end  ENVIADOS_n
       ,case When epos_ccod=2 and nuevo='N' then 1 end  ENVIADOS_a
    from  (
            select protic.obtener_rut(a.pers_ncorr) as rut,e.sede_ccod,sede_tdesc, a.epos_ccod,f.carr_tdesc,g.jorn_tdesc as jornada,
            protic.es_nuevo_carrera(a.pers_ncorr,d.carr_ccod,a.peri_ccod) as nuevo  
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
                where a.peri_ccod=218 
                    and a.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49',
					   'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', 
 					   'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88',
  					   'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1') 
               -- group by e.sede_ccod,sede_tdesc, a.epos_ccod, 
               and protic.es_nuevo_carrera(a.pers_ncorr,d.carr_ccod,a.peri_ccod)='S'
               and a.post_bnuevo='S'
               and a.post_ncorr not in (select distinct post_ncorr from observaciones_postulacion where eopo_ccod not in (1))
    ) as tabla

    
