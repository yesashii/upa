select d.emat_ccod,d.audi_fmodificacion,(select isnull(post_bnuevo,'S') from postulantes where post_ncorr=d.post_ncorr) as nuevo,c.jorn_ccod as jornada,
 cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut,d.post_ncorr,a.pers_ncorr, f.carr_tdesc as carrera, c.sede_ccod, f.area_ccod, c.peri_ccod,
(select facu_tdesc from areas_academicas aa, facultades fa where aa.facu_ccod=fa.facu_ccod and aa.area_ccod=f.area_ccod )  as facultad,  
   pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre as nombre,  
   pers_fnacimiento,protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) as nuevo,  
   isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr, (select protic.obtener_nombre_carrera((select top 1 ofer_ncorr   
   From alumnos where matr_ncorr=d.matr_ncorr order by matr_ncorr desc),'CC'))) ,    
   protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso  
 from personas a, ofertas_academicas c, alumnos d,especialidades e, carreras f   
 where a.pers_ncorr = d.pers_ncorr   
   and c.ofer_ncorr= d.ofer_ncorr   
   and c.espe_ccod = e.espe_ccod 
   --and c.jorn_ccod='1'   
   --and e.carr_ccod='800'  
   --and c.sede_ccod='1'  
   --and d.emat_ccod in (1,4,8,2,15,16)  
   and d.audi_tusuario not like '%ajunte matricula%'  
   and protic.afecta_estadistica(d.matr_ncorr) > 0   
   and c.peri_ccod=218--protic.retorna_max_periodo_matricula(a.pers_ncorr,'218',e.carr_ccod)  
   and isnull(d.alum_nmatricula,0) not in (7777) 
   and e.carr_ccod=f.carr_ccod
   and d.alum_fmatricula < convert(datetime,'04/04/2010',103)
   and d.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',  
                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',   
                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',   
                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',   
                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2',   
                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2')   
 group by a.pers_ncorr, f.carr_tdesc, e.carr_ccod,f.area_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,
          pers_tape_paterno,pers_tape_materno,pers_fnacimiento,d.matr_ncorr, d.post_ncorr, c.sede_ccod, d.emat_ccod,d.audi_fmodificacion,c.jorn_ccod
 having (select isnull(post_bnuevo,'S') from postulantes where post_ncorr=d.post_ncorr) = 'N'  order by nombre asc
 
-- select top 1 * from alumnos