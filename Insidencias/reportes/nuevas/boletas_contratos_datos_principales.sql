select rut_alumno,nombre_alumno,carr_tdesc + case d.jorn_ccod when 1 then '(D)' when 2 then '(V)' end as carrera, 
protic.obtener_direccion_letra (g.pers_ncorr,1,'CNPB') as direccion_codeudor,protic.obtener_direccion_letra (g.pers_ncorr,1,'C-C') as ciudad_comuna,
cast(arancel as integer) as arancel, cast(matricula as integer) as matricula,
datepart(day,fecha_contrato)as dia,datepart(month,fecha_contrato)as mes,datepart(year,fecha_contrato)as anio,
nombre_codeudor, rut_codeudor
from fox..sd_contratos_diciembre a
join  contratos b
    on a.cont_ncorr=b.cont_ncorr
join postulantes c
    on b.post_ncorr=c.post_ncorr
join ofertas_academicas d
    on c.ofer_ncorr=d.ofer_ncorr
join especialidades e
    on d.espe_ccod=e.espe_ccod
join carreras f
    on e.carr_ccod=f.carr_ccod
join codeudor_postulacion g
    on c.post_ncorr=g.post_ncorr    

