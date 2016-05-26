select * 
 from BLOQUES_PROFESORES AA, 
 BLOQUES_horarios BB, 
 secciones CC 
     where AA.PERS_NCORR=25335 
         and BB.BLOQ_CCOD=AA.BLOQ_CCOD 
         and CC.SECC_CCOD = BB.SECC_CCOD 
         and CC.CARR_CCOD=47
  --       AND AA.CDOC_NCORR IS NULL
  --       AND AA.BLOQ_ANEXO IS NULL
  
  
  
  select CDOC_NCORR,BLOQ_ANEXO from BLOQUES_PROFESORES where PERS_NCORR=25335 
  and BLOQ_CCOD in (
	87946
	,87947
	,87948
  )
  
  
  
  
  update BLOQUES_PROFESORES 
  set CDOC_NCORR = null
  ,BLOQ_ANEXO = null
  where PERS_NCORR=25335 
  and BLOQ_CCOD in (
	87946
	,87947
	,87948
  )
  
  -- delete from CONTRATOS_DOCENTES_UPA where CDOC_NCORR >= 7196
  
  
  
  
  select * from CONTRATOS_DOCENTES_UPA order by ANO_CONTRATO desc
  
  select datepart(year,getdate())
  
  
   
   
   -- --------------------------------------------------------------------------------
   select * from CONTRATOS_DOCENTES_UPA where PERS_NCORR = 25335
   
   select * from ANEXOS where CDOC_NCORR = 6537
   
   select * from DETALLE_ANEXOS where ANEX_NCORR = 23392 and CDOC_NCORR = 6537
   
   
   
   delete from DETALLE_ANEXOS where ANEX_NCORR = 23392 and CDOC_NCORR = 6537
   
   delete from ANEXOS where ANEX_NCORR = 23392
   
   select CDOC_NCORR, BLOQ_ANEXO from BLOQUES_PROFESORES where PERS_NCORR=25335
   
   update BLOQUES_PROFESORES 
  set CDOC_NCORR = null
  ,BLOQ_ANEXO = null
  where PERS_NCORR=25335 
  and BLOQ_CCOD in (
	87946
	,87947
	,87948
  )
  
-- 
se ejecuta Exec GENERA_CONTRATO_DOCENTE 25335, 1 ,'47 ', 1,1, '15370707'

-- estado de contratos

select * from CONTRATOS_DOCENTES_UPA where PERS_NCORR = 25335

select * into #paso_CONTRATOS_DOCENTES_UPA from CONTRATOS_DOCENTES_UPA where ECDO_CCOD = 1 and ANO_CONTRATO = 2015

update CONTRATOS_DOCENTES_UPA
set ECDO_CCOD = 2
where ECDO_CCOD = 1 and ANO_CONTRATO = 2015



 -- --------------------------------------------------------------------------------
 select * from personas where PERS_NRUT = 6182724
 
   select * from CONTRATOS_DOCENTES_UPA where PERS_NCORR = 23703
   
   select * from ANEXOS where CDOC_NCORR = 6607
   
   select * from DETALLE_ANEXOS where ANEX_NCORR = 23390 and CDOC_NCORR = 6607
   
   
   
   delete from DETALLE_ANEXOS where ANEX_NCORR = 23390 and CDOC_NCORR = 6607
   
   delete from ANEXOS where ANEX_NCORR = 23390
   
   select * from BLOQUES_PROFESORES where PERS_NCORR=23703
   
   update BLOQUES_PROFESORES 
  set CDOC_NCORR = null
  ,BLOQ_ANEXO = null
  where PERS_NCORR=23703 
  and BLOQ_CCOD in (
87967
,87968
,89239
,89240
  )

  
  
  select replace(substring(protic.trunc(secc_finicio_sec),1,5),'/','-')
  
  select replace(substring(protic.trunc(secc_finicio_sec),1,5),'/','-')
  from SECCIONES
  
  
  
  
  
  select * from planificacion_regimen
  
  
  update planificacion_regimen
  set PREG_INICIO = '07-03'
  where PREG_CCOD = 2
   
   
   
   select * from SPAGOS
   
   