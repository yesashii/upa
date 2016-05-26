--###################################################################
-- Consulta para traer totales de descuentos y becas por item 
-- y ademas separa los alumnos nuevos de antiguos
--###################################################################
select sum (deta_msubtotal) as total_descuento, tdet_tdesc, count(rut_alumno) as cantidad_alumnos, case nuevo when 'S' then 'NUEVOS' else 'ANTIGUOS' end as procedencia
from (
select cast(c.deta_msubtotal as integer)*-1 as deta_msubtotal,d.tdet_tdesc,'Sobre -'+p.tcom_tdesc as destino, protic.obtener_nombre(b.pers_ncorr,'n') as nombre_alumno,protic.obtener_rut(b.pers_ncorr) as rut_alumno,
    isnull(protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB'),protic.obtener_direccion_letra(b.pers_ncorr,2,'CNPB')) direccion_alumno, max(e.pers_tfono) as telefono
    ,max(m.carr_tdesc) as carrera, max(k.espe_tdesc) as especialidad, case max(j.jorn_ccod)   when 1 then 'Diurno' when 2 then 'Vespertino' end as jornada,
    protic.ano_ingreso_carrera(b.pers_ncorr,max(m.carr_ccod)) as ano_carrera,protic.trunc(a.comp_fdocto) as fecha_asignacion
    ,protic.es_nuevo_institucion(b.pers_ncorr,'164') as nuevo
    from compromisos a 
    join detalle_compromisos b     
		on a.tcom_ccod = b.tcom_ccod        
		and a.inst_ccod = b.inst_ccod        
		and a.comp_ndocto = b.comp_ndocto 
     join detalles c
        on c.tcom_ccod = b.tcom_ccod        
		and c.inst_ccod = b.inst_ccod        
		and c.comp_ndocto = b.comp_ndocto
     join tipos_detalle d
        on c.tdet_ccod=d.tdet_ccod
     join personas e
        on b.pers_ncorr=e.pers_ncorr
     /*join abonos f
        on b.tcom_ccod = f.tcom_ccod        
		and b.inst_ccod = f.inst_ccod        
		and b.comp_ndocto = f.comp_ndocto 
        and b.dcom_ncompromiso = f.dcom_ncompromiso
     join ingresos g
        on f.ingr_ncorr=g.ingr_ncorr
        and g.eing_ccod not in (3,6) --no trae los nulos
        and g.ting_ccod in (7)*/
     join alumnos h
        on b.pers_ncorr=h.pers_ncorr
        and emat_ccod not in (9)
     join postulantes i
        on h.post_ncorr=i.post_ncorr
     join ofertas_academicas j
       on i.ofer_ncorr=j.ofer_ncorr
     join especialidades k
        on j.espe_ccod=k.espe_ccod
     join carreras m
        on k.carr_ccod=m.carr_ccod 
     join codeudor_postulacion n
        on i.post_ncorr=n.post_ncorr
     left outer join personas o
        on n.pers_ncorr=o.pers_ncorr
     join tipos_compromisos p
        on c.tcom_ccod=p.tcom_ccod                     
where a.tcom_ccod in (1,2)
and a.ecom_ccod = 1
and d.tben_ccod in (2,3)
and convert(datetime,a.comp_fdocto,103)>='01/11/2004'
group by a.comp_ndocto,b.pers_ncorr,c.tdet_ccod,d.tdet_tdesc,c.deta_msubtotal,a.comp_fdocto,m.carr_tdesc,p.tcom_tdesc --, i.peri_ccod
) aa
group by tdet_tdesc,nuevo
