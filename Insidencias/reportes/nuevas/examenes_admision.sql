--############################################################
-- Trae examenes de admision entre 13/12/2004 - 31/12/2004
--############################################################

select g.ingr_nfolio_referencia as comprobante,f.ABON_MABONO AS PAGADO,protic.trunc(max(f.abon_fabono)) as fecha_pago,
    d.tdet_tdesc, protic.obtener_nombre(b.pers_ncorr,'n') as nombre_alumno,protic.obtener_rut(b.pers_ncorr) as rut_alumno,
    protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB') direccion_alumno,
    protic.obtener_nombre(o.pers_ncorr,'n') as nombre_apoderado,protic.obtener_rut(o.pers_ncorr) as rut_APODERADO,
    protic.obtener_direccion_letra(o.pers_ncorr,1,'CNPB') direccion_apoderado, PROTIC.OBTENER_DIRECCION_LETRA(o.pers_ncorr,1,'C-C') AS CIUDAD_apoderado,
    max(m.carr_tdesc) as carrera, max(k.espe_tdesc) as especialidad, case max(j.jorn_ccod)   when 1 then 'Diurno' when 2 then 'Vespertino' end as jornada,
    protic.ano_ingreso_carrera(b.pers_ncorr,max(m.carr_ccod)) as ano_carrera, e.pers_nrut,e.pers_xdv,
    (select count (*) from detalle_postulantes where post_ncorr=i.post_ncorr) as total,max(q.ofer_ncorr) as ofer_ncorr,o.pers_ncorr,i.post_ncorr,A.COMP_NDOCTO
   from compromisos a 
    join detalle_compromisos b     
		on a.tcom_ccod = b.tcom_ccod        
		and a.inst_ccod = b.inst_ccod        
		and a.comp_ndocto = b.comp_ndocto 
        and a.ecom_ccod = '1'
     join detalles c
        on c.tcom_ccod = b.tcom_ccod        
		and c.inst_ccod = b.inst_ccod        
		and c.comp_ndocto = b.comp_ndocto
     join tipos_detalle d
        on c.tdet_ccod=d.tdet_ccod
     join personas_postulante e
        on b.pers_ncorr=e.pers_ncorr
     join abonos f
        on b.tcom_ccod = f.tcom_ccod        
		and b.inst_ccod = f.inst_ccod        
		and b.comp_ndocto = f.comp_ndocto 
        and b.dcom_ncompromiso = f.dcom_ncompromiso
     join ingresos g
        on f.ingr_ncorr=g.ingr_ncorr
        and g.eing_ccod not in (3,6) --no trae los nulos
        and g.ting_ccod in (16,34) -- trae solo los ingresados por caja
     join postulantes i
        on b.pers_ncorr=i.pers_ncorr
        and f.peri_ccod=i.peri_ccod
        and tpos_ccod=1
    left outer join detalle_postulantes q
        on i.post_ncorr=q.post_ncorr
        --and i.ofer_ncorr=q.ofer_ncorr       
     left outer join ofertas_academicas j
       on q.ofer_ncorr=j.ofer_ncorr
     left outer join especialidades k
        on j.espe_ccod=k.espe_ccod
     left outer join carreras m
        on k.carr_ccod=m.carr_ccod 
     left outer join codeudor_postulacion n
        on i.post_ncorr=n.post_ncorr
     left outer join personas_postulante o
        on n.pers_ncorr=o.pers_ncorr
     /*join estados_matriculas p
        on h.emat_ccod=p.emat_ccod   */             
where a.tcom_ccod=15
and c.tdet_ccod in (1243) --  pago examen de admision
and convert(datetime,g.ingr_fpago,103) between convert(datetime,'13/12/2004',103) and convert(datetime,'01/01/2005',103)
group by f.ABON_MABONO,o.pers_ncorr,i.post_ncorr,A.COMP_NDOCTO,g.ingr_nfolio_referencia,b.pers_ncorr,c.tdet_ccod,d.tdet_tdesc,e.pers_nrut,e.pers_xdv, o.pers_ncorr

--publicidad 2005