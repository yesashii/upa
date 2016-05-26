 Select * 
   From contratos_docentes_upa a 
    Where a.pers_ncorr=259043
     and cast(a.ano_contrato as varchar)='2015'
     and a.ecdo_ccod <> 3 
     
     


Select top 1 cdoc_ncorr 
   From contratos_docentes_upa a 
    Where a.pers_ncorr=259043
     and cast(a.ano_contrato as varchar)='2016'
     and a.ecdo_ccod <> 3 


select cdoc_ncorr
from contratos_docentes_upa
Where pers_ncorr=259043 
and AUDI_FMODIFICACION = (select MAX(AUDI_FMODIFICACION) from contratos_docentes_upa Where pers_ncorr=259043 )