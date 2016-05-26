select * from presupuestos_escuelas
select distinct * from sd_presupuestos_escuelas_2010


select top 5 2010 as admision, * from sd_ofertas_antiguos_2010
select  * from estructura_indicador_ofertas

--insert into presupuestos_escuelas 
select * from sd_ofertas_antiguos_2010


select * from sd_ofertas_antiguos_2010 a, carreras b
where a.carr_ccod=b.carr_ccod

insert into presupuesto_upa.protic.presupuesto_upa_2010  (cod_anio,cod_pre,cod_area,descripcion_area,concepto,detalle,enero,febrero,marzo,abril,mayo,junio,julio,agosto,septiembre,octubre,noviembre,diciembre,total)  
values  (2010,'1-J1-01070',1,'PPTO ASUNTOS ESTUD LAS CONDES','CAJA CHICA','333333',0,0,0,0,0,0,0,0,0,0,0,0,0)