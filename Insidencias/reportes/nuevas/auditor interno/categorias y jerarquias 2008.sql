select jdoc_tdesc,tcat_tdesc,tcat_valor, c.peri_tdesc 
from tipos_categoria a, jerarquias_docentes b, periodos_academicos c
where a.jdoc_ccod=b.jdoc_ccod
and a.peri_ccod=c.peri_ccod
and a.anos_ccod=2008
and a.jdoc_ccod not in (0)



select * from tipos_categoria where anos_ccod=2008


select tcat_tdesc,tcat_ccod,case jdoc_ccod when 9 then tcat_valor else ceiling(tcat_valor+(tcat_valor*0.071)) end as monto,jdoc_ccod
from tipos_categoria where anos_ccod=2008
and tcat_ccod  in (
    select distinct tcat_ccod from carreras_docente where peri_ccod >=210
)


select b.* from personas a, postulacion_otec b  
where a.pers_nrut in (4925438,9492385,8804991,4362834)
and a.pers_ncorr=b.pers_ncorr

select * from jerarquias_docentes



grado-descripcion, profesion, jerarquia,carrera, tipo_contrato
cgarcia@upacifico.cl
gbecerra@upacifico.cl