select distinct sd.sede_tdesc as sede,d.dcur_tdesc,protic.obtener_rut(pers_ncorr) as rut, 
protic.obtener_nombre_completo(b.pers_ncorr,'n') as participante,protic.trunc(c.dgso_finicio) as inifio,
 protic.trunc(c.dgso_ftermino) as fin,o.anio_admision, o.nro_resolucion,o.ofot_narancel, o.ofot_nmatricula,o.udpo_ccod, 
 f.ccos_tcompuesto as centro_costo, u.UDPO_TDESC
from postulantes_cargos_otec a 
join postulacion_otec b
    on a.pote_ncorr=b.pote_ncorr
join  datos_generales_secciones_otec c 
    on b.dgso_ncorr=c.dgso_ncorr
join sedes sd
    on c.sede_ccod=sd.SEDE_CCOD    
join  diplomados_cursos d
    on c.dcur_ncorr=d.dcur_ncorr 
join ofertas_otec o
    on d.dcur_ncorr=o.dcur_ncorr
left outer join UNIDADES_DICTAN_PROGRAMAS_OTEC u
    on o.udpo_ccod=u.UDPO_CCOD    
left outer join centros_costos_asignados e
    on d.TDET_CCOD=e.TDET_CCOD
left outer join centros_costo f
    on e.ccos_ccod=f.CCOS_CCOD
where b.epot_ccod=4    
