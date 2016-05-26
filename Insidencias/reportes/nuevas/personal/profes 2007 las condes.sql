select distinct protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente,
protic.obtener_direccion(a.pers_ncorr,1,'CNPB') as direccion,
protic.obtener_direccion(a.pers_ncorr,1,'C-C') as comuna  
from contratos_docentes_upa a, anexos b, personas c
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and sede_ccod=1
and a.pers_ncorr=c.pers_ncorr