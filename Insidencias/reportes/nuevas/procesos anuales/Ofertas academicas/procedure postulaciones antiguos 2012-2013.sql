CREATE PROCEDURE dbo.genera_postulacion_antiguos_de_un_anio_a_otro_2013
AS
BEGIN
--############
-- PROCEDIMIENTO QUE GENERA POSTULACIONES MASIVAS PARA ALUMNOS ANTIGUOS
-- CON EL FIN DE MANTENER SU POSTULACION APROBADA Y FACILITAR SU CONTRATACION
--############

-- ULTIMA EJECUCION ADMISION 2013

declare @peri_ccod numeric(3)
declare @nuevo_post numeric(10)
--------------------------------variable del cursos c_alumno-----------------------
declare @vc_pers_ncorr numeric(10)
declare @vc_post_ncorr numeric(10)
declare @vc_ofer_ncorr numeric(8)
----------------------------------cursor c_alumno-----------------------------------
declare c_alumno cursor for

 select pers_ncorr, post_ncorr, nueva_oferta as ofer_ncorr
			 from 
			 ( 
			 select distinct a.pers_ncorr,cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut,isnull(a.pers_temail,'No ingresado') as email,  
			   a.pers_tape_paterno  as AP_Paterno, a.pers_tape_materno  as AP_Materno, a.pers_tnombre as nombre,protic.trunc(a.pers_fnacimiento) as fecha_nacimiento,  
			   case a.sexo_ccod when 1 then 'Masculino' when 2  then 'Femenino' else 'Sin Seleccionar' end as sexo,   
			   pai.pais_tdesc as pais,facu.facu_ccod,facu.facu_tdesc as facultad,
               case when h.sede_ccod = 2 and e.carr_ccod in ('51','110') then 1
                                     when h.sede_ccod = 2 and e.carr_ccod not in ('51','110') then 8
                                     else h.sede_ccod end as sede_ccod,
               case when h.sede_ccod = 2 and e.carr_ccod in ('51','110') then 'LAS CONDES'
                                     when h.sede_ccod = 2 and e.carr_ccod not in ('51','110') then 'BAQUEDANO'
                                     else h.sede_tdesc end as sede,
               e.carr_ccod ,f.carr_tdesc as Carrera,g.jorn_ccod, g.jorn_tdesc as jornada , 
			   case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo,  
			   protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso, 
			   (select emat_tdesc from estados_matriculas emat  
			   where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc))  
			   as estado_academico,e.espe_ccod, aran_nano_ingreso as anio_ingreso,
               (select top 1 aaa.ofer_ncorr 
                   from ofertas_academicas aaa, aranceles bbb
                    where aaa.sede_ccod=case when h.sede_ccod = 2 and e.carr_ccod in ('51','110') then 1
                                         when h.sede_ccod = 2 and e.carr_ccod not in ('51','110') then 8
                                         else h.sede_ccod end
                    and aaa.espe_ccod=e.espe_ccod 
                    and aaa.jorn_ccod=g.jorn_ccod
                    and aaa.aran_ncorr = bbb.aran_ncorr 
                    and bbb.aran_nano_ingreso = aran.aran_nano_ingreso
                    and aaa.peri_ccod=230
                    and bbb.aran_mmatricula <> 0 
                    and bbb.aran_mcolegiatura <> 0) as nueva_oferta, 
               d.post_ncorr
			   from personas_postulante a join alumnos d  
			        on a.pers_ncorr = d.pers_ncorr   
			   join ofertas_academicas c  
			        on c.ofer_ncorr = d.ofer_ncorr
               join aranceles aran
                    on  c.aran_ncorr = aran.aran_ncorr         
			   join periodos_academicos pea  
			        on c.peri_ccod = pea.peri_ccod and pea.anos_ccod= datepart(year,getDate()) 
			   join postulantes pos 
			        on pos.post_ncorr = d.post_ncorr 
			    join paises pai 
			        on pai.pais_ccod = isnull(a.pais_ccod,0)  
			    join especialidades e  
			        on c.espe_ccod  = e.espe_ccod 
			    join carreras f  
			        on e.carr_ccod=f.carr_ccod 
			    join areas_academicas aca 
			        on f.area_ccod = aca.area_ccod 
			    join facultades facu 
			        on aca.facu_ccod=facu.facu_ccod       
			    join jornadas g  
			        on c.jorn_ccod=g.jorn_ccod  
			    join sedes h  
			       on c.sede_ccod=h.sede_ccod  
			    join contratos cont 
			        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr  
			 where cont.econ_ccod = 1  
			 and d.emat_ccod not in (14,7,8,6,9)
             and f.tcar_ccod=1
             and exists (select 1 from contratos cont1, compromisos comp1 where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) )   
			 group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno, 
			         a.pers_tape_materno,a.pers_fnacimiento,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc, 
			         pai.pais_tdesc,e.espe_tdesc,a.sexo_ccod,cont.cont_fcontrato, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod,
					 a.pers_temail,facu.facu_ccod,facu_tdesc, h.sede_ccod, g.jorn_ccod,e.espe_ccod, aran.aran_nano_ingreso, d.post_ncorr 
			 )tabla_final 
			 where estado_academico= 'Activa' 
             and isnull(nueva_oferta,1)<> 1
		 order by sede,carrera,AP_Paterno,AP_Materno,Nombre


---------------------------------------------fin cursor c_alumno---------------------------------        
		open c_alumno
        fetch next from c_alumno
        into   @vc_pers_ncorr,@vc_post_ncorr,@vc_ofer_ncorr
        while @@FETCH_STATUS = 0
        begin
            
            select @peri_ccod = peri_ccod from ofertas_academicas where ofer_ncorr = @vc_ofer_ncorr
			
			execute protic.RetornarSecuencia 'postulantes', @nuevo_post output

   insert into postulantes (POST_NCORR,PERS_NCORR,EPOS_CCOD,TPOS_CCOD,PERI_CCOD,POST_BNUEVO,OCUP_CCOD,OFER_NCORR,POST_FPOSTULACION,TPAD_CCOD,POST_NPAA_VERBAL,POST_NPAA_MATEMATICAS,POST_NANO_PAA,IESU_CCOD,POST_TINSTITUCION_ANTERIOR,TIES_CCOD,POST_TTIPO_INSTITUCION_ANT,POST_TCARRERA_ANTERIOR,POST_NSEM_CURSADOS,POST_NSEM_APROBADOS,POST_NANO_INICIO_EST_ANT,POST_NANO_TERMINO_EST_ANT,POST_BTITULADO,POST_TTITULO_OBTENIDO,POST_BREQUIERE_EXAMEN,POST_NNOTA_EXAMEN,POST_BPASE_ESCOLAR,POST_TOTRO_COLEGIO,POST_NCORR_CODEUDOR,TBEN_CCOD1,TBEN_CCOD2,POST_BTRABAJA,POST_NINICIO,POST_BRECONOCIMIENTO_ESTUDIOS,POST_TOTRAS_ACTIVIDADES,AUDI_TUSUARIO,AUDI_FMODIFICACION,POST_BPAGA,POST_NCORRELATIVO)
            select @nuevo_post as post_ncorr,pers_ncorr,2 as epos_ccod,tpos_ccod,@peri_ccod as peri_ccod,'N' as post_bnuevo,ocup_ccod,@vc_ofer_ncorr as ofer_ncorr,getDate() as post_fpostulacion,tpad_ccod,post_npaa_verbal,post_npaa_matematicas,post_nano_paa,iesu_ccod,
         post_tinstitucion_anterior,ties_ccod,post_ttipo_institucion_ant,post_tcarrera_anterior,post_nsem_cursados,post_nsem_aprobados,post_nano_inicio_est_ant,post_nano_termino_est_ant,
            post_btitulado,post_ttitulo_obtenido,post_brequiere_examen,post_nnota_examen,post_bpase_escolar,post_totro_colegio,post_ncorr_codeudor,tben_ccod1,tben_ccod2,post_btrabaja,post_ninicio,
            post_breconocimiento_estudios,post_totras_Actividades,'Trasp antiguos a 2013' as audi_tusuario,getDate() as audi_fmodificacion,post_bpaga,post_ncorrelativo
            from postulantes where post_ncorr = @vc_post_ncorr
            
            insert into detalle_postulantes (post_ncorr,ofer_ncorr,audi_tusuario,audi_fmodificacion,dpos_tobservacion,eepo_ccod,dpos_ncalificacion,dpos_fexamen)
            values(@nuevo_post,@vc_ofer_ncorr,'Trasp antiguos a 2013',getDate(),'Trasp antiguos a 2013',5,NULL,NULL)
        
            insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod,audi_tusuario,audi_fmodificacion,grup_nindependiente)
    select @nuevo_post as post_ncorr,pers_ncorr,pare_ccod,'Trasp antiguos a 2013' as audi_tusuario,getDate() as audi_fmodificacion,null
            from grupo_familiar where post_ncorr = @vc_post_ncorr
            
            insert into codeudor_postulacion (post_ncorr,pers_ncorr,pare_ccod,audi_tusuario,audi_fmodificacion)
            select @nuevo_post as post_ncorr,pers_ncorr,pare_ccod,'Trasp antiguos a 2013' as audi_tusuario,getDate() as audi_fmodificacion
            from codeudor_postulacion where post_ncorr = @vc_post_ncorr
       
        fetch next from c_alumno
        into  @vc_pers_ncorr,@vc_post_ncorr,@vc_ofer_ncorr
			  
END --fin while
close c_alumno
DEALLOCATE c_alumno
END
