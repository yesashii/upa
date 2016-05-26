select cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,
    pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno as docente,
    b.susu_tlogin as login, b.susu_tclave as clave 
from personas a, sis_usuarios b
    where a.pers_ncorr=b.pers_ncorr 
    and a.pers_nrut in (
            select distinct  b.pers_nrut 
            from carreras_docente a, personas b, carreras c, jornadas d, sedes e, periodos_academicos i
            where a.peri_ccod=i.peri_ccod
            and a.pers_ncorr=b.pers_ncorr
            and a.carr_ccod=c.carr_ccod
            and a.jorn_ccod=d.jorn_ccod
            and a.sede_ccod=e.sede_ccod
            and i.anos_ccod=2010 
            and c.carr_ccod in (870,940,950,880,860)
            and a.pers_ncorr in (
                select distinct pers_ncorr from contratos_docentes_upa where ano_contrato=2010
            )   
)

    
--***************************
-- Email docentes x carrera    
select distinct  b.pers_nrut as rut,b.pers_xdv as digito, b.pers_tnombre, b.pers_tape_paterno,
protic.obtener_direccion(b.pers_ncorr,'1','CNPB') as direccion,protic.obtener_direccion(b.pers_ncorr,'1','C-C') as ciudad_comuna, 
b.pers_tape_materno,pers_tfono as telefono,pers_temail as correo_particular,email_nuevo as correo_institucional,carr_tdesc as carrera, jorn_tdesc as jornada, sede_tdesc as sede
from carreras_docente a, personas b, carreras c, jornadas d, sedes e, periodos_academicos i, cuentas_email_upa j
where a.peri_ccod=i.peri_ccod
and a.pers_ncorr=b.pers_ncorr
and a.carr_ccod=c.carr_ccod
and a.jorn_ccod=d.jorn_ccod
and a.sede_ccod=e.sede_ccod
and b.pers_ncorr=j.pers_ncorr
and i.anos_ccod=2010 
and c.carr_ccod in (
            select carr_ccod from carreras a, areas_academicas b, facultades c
            where a.area_ccod=b.area_ccod
            and b.facu_ccod=c.facu_ccod
            and c.facu_ccod=1
)
and a.pers_ncorr in (
    select distinct pers_ncorr from contratos_docentes_upa where ano_contrato=2010
)   


--***************************
-- Email docentes unicos x facultad
select distinct  b.pers_nrut as rut,b.pers_xdv as digito, b.pers_tnombre, b.pers_tape_paterno, 
b.pers_tape_materno,pers_tfono as telefono,pers_temail as correo_particular,email_nuevo as correo_institucional,
protic.obtener_direccion(b.pers_ncorr,'1','CNPB') as direccion,protic.obtener_direccion(b.pers_ncorr,'1','C-C') as ciudad_comuna
from carreras_docente a, personas b, carreras c, jornadas d, sedes e, periodos_academicos i, cuentas_email_upa j
where a.peri_ccod=i.peri_ccod
and a.pers_ncorr=b.pers_ncorr
and a.carr_ccod=c.carr_ccod
and a.jorn_ccod=d.jorn_ccod
and a.sede_ccod=e.sede_ccod
and b.pers_ncorr=j.pers_ncorr
and i.anos_ccod=2010
and c.carr_ccod in (
            select carr_ccod from carreras a, areas_academicas b, facultades c
            where a.area_ccod=b.area_ccod
            and b.facu_ccod=c.facu_ccod
            and c.facu_ccod=1
)
and a.pers_ncorr in (
    select distinct pers_ncorr from contratos_docentes_upa where ano_contrato=2010
)   


select carr_ccod from carreras a, areas_academicas b, facultades c
where a.area_ccod=b.area_ccod
and b.facu_ccod=c.facu_ccod
and c.facu_ccod=3

