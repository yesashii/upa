-- Cierra contratos del año anterior
update contratos_docentes_upa set ecdo_ccod=2, audi_tusuario= audi_tusuario+ ' cierre 2010' where ano_contrato=2010

update contratos_docentes_upa set audi_tusuario=replace(audi_tusuario,'cierre 2010',' cierre 2010') from contratos_docentes_upa where ano_contrato=2010

select audi_tusuario from contratos_docentes_upa where ano_contrato=2011