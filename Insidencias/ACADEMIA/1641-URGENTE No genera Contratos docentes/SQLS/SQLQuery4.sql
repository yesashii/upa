select * from CONTRATOS_DOCENTES_UPA order by ANO_CONTRATO desc



select COUNT(*) from CONTRATOS_DOCENTES_UPA where ANO_CONTRATO = 2010
-- 732
select COUNT(*) from CONTRATOS_DOCENTES_UPA where ANO_CONTRATO = 2011
-- 812
select COUNT(*) from CONTRATOS_DOCENTES_UPA where ANO_CONTRATO = 2012
-- 812
select COUNT(*) from CONTRATOS_DOCENTES_UPA where ANO_CONTRATO = 2013
-- 776
select COUNT(*) from CONTRATOS_DOCENTES_UPA where ANO_CONTRATO = 2014
-- 765
select COUNT(*) from CONTRATOS_DOCENTES_UPA where ANO_CONTRATO = 2015
-- 700



select * from jerarquias_docentes

insert into jerarquias_docentes values(
10
,'Categoría Única Técnicos'
,'lherrera'
,GETDATE()
)

insert into jerarquias_docentes values(
11
,'Categoría A'
,'lherrera'
,GETDATE()
)

insert into jerarquias_docentes values(
12
,'Categoría B'
,'lherrera'
,GETDATE()
)

insert into jerarquias_docentes values(
13
,'Categoría C'
,'lherrera'
,GETDATE()
)


select * from PERSONAS where PERS_NRUT = 10282990


insert into CONTRATOS_DOCENTES_UPA

select * from CONTRATOS_DOCENTES_UPA

select * INTO #PASO
from CONTRATOS_DOCENTES_UPA 
where ANO_CONTRATO = 2015

INSERT INTO CONTRATOS_DOCENTES_UPA SELECT * FROM #PASO
UPDATE #PASO SET audi_fmodificacion=GETDATE()

select MAX(CDOC_NCORR) from CONTRATOS_DOCENTES_UPA



select * from personas where PERS_NRUT = 9002305




select * from CONTRATOS_DOCENTES_UPA where PERS_NCORR = 25335

6537

select * from ANEXOS where CDOC_NCORR = 6537


delete from DETALLE_ANEXOS 
where ANEX_NCORR in (23387,23389)
and cdoc_ncorr = 6537


delete from ANEXOS where cdoc_ncorr = 6537 and ANEX_NCORR in (23387,23389)







