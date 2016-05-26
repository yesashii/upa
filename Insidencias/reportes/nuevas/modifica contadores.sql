-- CREA LAS NUEVAS CARRERAS
INSERT INTO CARRERAS ( CARR_CCOD, AREA_CCOD, INST_CCOD, ECAR_CCOD, CARR_TDESC, CARR_FINI_VIGENCIA, CARR_FFIN_VIGENCIA, ANOS_PASE_MATRICULA, AUDI_TUSUARIO, AUDI_FMODIFICACION, CARR_TSIGLA, carr_ccod_legacy, TCAR_CCOD, CARR_NCERRADA ) 
		 VALUES ( '890', 3, 1, 1, 'CONTADOR AUDITOR (TALAGANTE)', NULL, NULL, NULL, 'separa carrera ca', getdate(), 'CAT', NULL, 1, NULL ) 

INSERT INTO CARRERAS ( CARR_CCOD, AREA_CCOD, INST_CCOD, ECAR_CCOD, CARR_TDESC, CARR_FINI_VIGENCIA, CARR_FFIN_VIGENCIA, ANOS_PASE_MATRICULA, AUDI_TUSUARIO, AUDI_FMODIFICACION, CARR_TSIGLA, carr_ccod_legacy, TCAR_CCOD, CARR_NCERRADA ) 
		 VALUES ( '900', 3, 1, 1, 'CONTADOR AUDITOR (SANTIAGO)', NULL, NULL, NULL, 'separa carrera ca', getdate(), 'CAS', NULL, 1, NULL ) 

INSERT INTO CARRERAS ( CARR_CCOD, AREA_CCOD, INST_CCOD, ECAR_CCOD, CARR_TDESC, CARR_FINI_VIGENCIA, CARR_FFIN_VIGENCIA, ANOS_PASE_MATRICULA, AUDI_TUSUARIO, AUDI_FMODIFICACION, CARR_TSIGLA, carr_ccod_legacy, TCAR_CCOD, CARR_NCERRADA ) 
		 VALUES ( '910', 3, 1, 1, 'CONTADOR AUDITOR (SAN BERNARDO)', NULL, NULL, NULL, 'separa carrera ca', getdate(), 'CAB', NULL, 1, NULL ) 

-- Actualiza las especialidades a los nuevos planes
update especialidades set carr_ccod='890', audi_tusuario='cambio espe 187' where espe_ccod=187   -- (Talagante)
update especialidades set carr_ccod='900', audi_tusuario='cambio espe 63' where espe_ccod=63    -- (Santiago)
update especialidades set carr_ccod='910', audi_tusuario='cambio espe 186' where espe_ccod=186   -- (San Bernardo)


--######################################################################################
-- Actualiza las secciones de San bernardo
update secciones set carr_ccod='910', audi_tusuario='cambio espe 186'
            where secc_ccod in (
                select secc_ccod from secciones a, malla_curricular b, planes_estudio c
                where a.mall_ccod=b.mall_ccod
                and b.plan_ccod=c.plan_ccod
                and c.espe_ccod=186
                and peri_ccod in (202,204,205)
                )
                
update sub_secciones set carr_ccod='910',audi_tusuario='cambio espe 186' 
            where secc_ccod in (
                select secc_ccod from secciones a, malla_curricular b, planes_estudio c
                where a.mall_ccod=b.mall_ccod
                and b.plan_ccod=c.plan_ccod
                and c.espe_ccod=186
                and peri_ccod in (202,204,205)
                )


-- Actualiza las secciones de Santiago
update secciones set carr_ccod='900', audi_tusuario='cambio espe 63'
            where secc_ccod in (
                select secc_ccod from secciones a, malla_curricular b, planes_estudio c
                where a.mall_ccod=b.mall_ccod
                and b.plan_ccod=c.plan_ccod
                and c.espe_ccod=63
                and peri_ccod in (202,204,205)
                )
                
update sub_secciones set carr_ccod='900',audi_tusuario='cambio espe 63'
            where secc_ccod in (
                select secc_ccod from secciones a, malla_curricular b, planes_estudio c
                where a.mall_ccod=b.mall_ccod
                and b.plan_ccod=c.plan_ccod
                and c.espe_ccod=63
                and peri_ccod in (202,204,205)
                )
                
-- Actualiza las secciones de Talagante
update secciones set carr_ccod='890', audi_tusuario='cambio espe 187'
            where secc_ccod in (
                select secc_ccod from secciones a, malla_curricular b, planes_estudio c
                where a.mall_ccod=b.mall_ccod
                and b.plan_ccod=c.plan_ccod
                and c.espe_ccod=187
                and peri_ccod in (202,204,205)
                )
                
update sub_secciones set carr_ccod='890',audi_tusuario='cambio espe 187' 
            where secc_ccod in (
                select secc_ccod from secciones a, malla_curricular b, planes_estudio c
                where a.mall_ccod=b.mall_ccod
                and b.plan_ccod=c.plan_ccod
                and c.espe_ccod=187
                and peri_ccod in (202,204,205)
                )
--######################################################################################


--######################################################################################                
-- CREA REGISTRO EN CARRERAS DOCENTES (se crearan con fecha de hoy y sin categoria).

-- Contador San Bernardo
insert into CARRERAS_DOCENTE
select sede_ccod, pers_ncorr,'910' as carr_ccod, jorn_ccod,
'separa carrera ca' as audi_tusuario,getdate() as audi_fmodificacion,
null as tcat_ccod,peri_ccod,null as observaciones1,null as observaciones2 
from CARRERAS_DOCENTE where carr_ccod=12 and peri_ccod=202

-- Contador Santiago
insert into CARRERAS_DOCENTE
select sede_ccod, pers_ncorr,'900' as carr_ccod, jorn_ccod,
'separa carrera ca' as audi_tusuario,getdate() as audi_fmodificacion,
null as tcat_ccod,peri_ccod,null as observaciones1,null as observaciones2 
from CARRERAS_DOCENTE where carr_ccod=12 and peri_ccod=202

-- Contador Talagante
insert into CARRERAS_DOCENTE
select sede_ccod, pers_ncorr,'890' as carr_ccod, jorn_ccod,
'separa carrera ca' as audi_tusuario,getdate() as audi_fmodificacion,
null as tcat_ccod,peri_ccod,null as observaciones1,null as observaciones2 
from CARRERAS_DOCENTE where carr_ccod=12 and peri_ccod=202
--######################################################################################    

--######################################################################################
-- asocia los centros de costos indicados
-- Contador San Bernardo
insert into centros_costos_asignados
(ccos_ccod,cenc_ccod_sede,cenc_ccod_carrera,cenc_ccod_jornada,tdet_ccod)
Values (341,'2','910','2',Null)
-- Contador Santiago
insert into centros_costos_asignados
(ccos_ccod,cenc_ccod_sede,cenc_ccod_carrera,cenc_ccod_jornada,tdet_ccod)
Values (339,'2','900','2',Null)    
-- Contador Talagante
insert into centros_costos_asignados
(ccos_ccod,cenc_ccod_sede,cenc_ccod_carrera,cenc_ccod_jornada,tdet_ccod)
Values (340,'2','890','2',Null)         
--######################################################################################   