-- CREA LAS NUEVAS CARRERAS
INSERT INTO CARRERAS ( CARR_CCOD, AREA_CCOD, INST_CCOD, ECAR_CCOD, CARR_TDESC, CARR_FINI_VIGENCIA, CARR_FFIN_VIGENCIA, ANOS_PASE_MATRICULA, AUDI_TUSUARIO, AUDI_FMODIFICACION, CARR_TSIGLA, carr_ccod_legacy, TCAR_CCOD, CARR_NCERRADA ) 
		 VALUES ( '920', 1, 1, 1, 'INGENIERIA COMERCIAL (PAE 9 TRIMESTRES)', NULL, NULL, NULL, 'separa carrera ic', getdate(), 'IC9', NULL, 1, NULL ) 
INSERT INTO CARRERAS ( CARR_CCOD, AREA_CCOD, INST_CCOD, ECAR_CCOD, CARR_TDESC, CARR_FINI_VIGENCIA, CARR_FFIN_VIGENCIA, ANOS_PASE_MATRICULA, AUDI_TUSUARIO, AUDI_FMODIFICACION, CARR_TSIGLA, carr_ccod_legacy, TCAR_CCOD, CARR_NCERRADA ) 
		 VALUES ( '930', 1, 1, 1, 'INGENIERIA COMERCIAL (PAE 5 TRIMESTRES)', NULL, NULL, NULL, 'separa carrera ic', getdate(), 'IC5', NULL, 1, NULL ) 


-- Actualiza las especialidades a los nuevos planes
update especialidades set carr_ccod='920' where espe_ccod=287   -- (Pae 9 trimestres)
update especialidades set carr_ccod='930' where espe_ccod=288   -- (Pae 5 trimestres)


--######################################################################################
-- Actualiza las secciones de Pae 9 trimestres
update secciones set carr_ccod='920' , audi_tusuario='cambio espe 287'
            where secc_ccod in (
                select secc_ccod from secciones a, malla_curricular b, planes_estudio c
                where a.mall_ccod=b.mall_ccod
                and b.plan_ccod=c.plan_ccod
                and c.espe_ccod=287
                and peri_ccod in (202,204,205)
                )
                
update sub_secciones set carr_ccod='920', audi_tusuario='cambio espe 287' 
            where secc_ccod in (
                select secc_ccod from secciones a, malla_curricular b, planes_estudio c
                where a.mall_ccod=b.mall_ccod
                and b.plan_ccod=c.plan_ccod
                and c.espe_ccod=287
                and peri_ccod in (202,204,205)
                )

-- Actualiza las secciones de Pae 5 trimestres
update secciones set carr_ccod='930' , audi_tusuario='cambio espe 288'
            where secc_ccod in (
                select secc_ccod from secciones a, malla_curricular b, planes_estudio c
                where a.mall_ccod=b.mall_ccod
                and b.plan_ccod=c.plan_ccod
                and c.espe_ccod=288
                and peri_ccod in (202,204,205)
                )
                
update sub_secciones set carr_ccod='930' , audi_tusuario='cambio espe 288'
            where secc_ccod in (
                select secc_ccod from secciones a, malla_curricular b, planes_estudio c
                where a.mall_ccod=b.mall_ccod
                and b.plan_ccod=c.plan_ccod
                and c.espe_ccod=288
                and peri_ccod in (202,204,205)
                )
--######################################################################################

    
--######################################################################################                
-- CREA REGISTRO EN CARRERAS DOCENTES (se crearan con fecha de hoy y sin categoria).

-- Pae 9 trimestres
insert into CARRERAS_DOCENTE
select sede_ccod, pers_ncorr,'920' as carr_ccod, jorn_ccod,
'separa carrera ic' as audi_tusuario,getdate() as audi_fmodificacion,
tcat_ccod,peri_ccod,null as observaciones1,null as observaciones2 
from CARRERAS_DOCENTE where carr_ccod=51 and peri_ccod=202 and jorn_ccod=2

-- Pae 5 trimestres
insert into CARRERAS_DOCENTE
select sede_ccod, pers_ncorr,'930' as carr_ccod, jorn_ccod,
'separa carrera ic' as audi_tusuario,getdate() as audi_fmodificacion,
tcat_ccod,peri_ccod,null as observaciones1,null as observaciones2 
from CARRERAS_DOCENTE where carr_ccod=51 and peri_ccod=202 and jorn_ccod=2

--######################################################################################    

--######################################################################################
-- asocia los centros de costos indicados
-- Pae 9 trimestres
insert into centros_costos_asignados
(ccos_ccod,cenc_ccod_sede,cenc_ccod_carrera,cenc_ccod_jornada,tdet_ccod)
Values (324,'2','920','2',Null)
-- Pae 5 trimestres
insert into centros_costos_asignados
(ccos_ccod,cenc_ccod_sede,cenc_ccod_carrera,cenc_ccod_jornada,tdet_ccod)
Values (325,'2','930','2',Null)    
 
--######################################################################################   

