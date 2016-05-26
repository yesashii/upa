--############################################################
-- Consulta para traer los alumnos con becas y descuentos
--############################################################
select c.deta_msubtotal,d.tdet_tdesc,'Sobre -'+p.tcom_tdesc, protic.obtener_nombre(b.pers_ncorr,'n') as nombre_alumno,protic.obtener_rut(b.pers_ncorr) as rut_alumno,
    isnull(protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB'),protic.obtener_direccion_letra(b.pers_ncorr,2,'CNPB')) direccion_alumno, max(e.pers_tfono) as telefono
    ,max(m.carr_tdesc) as carrera, max(k.espe_tdesc) as especialidad, case max(j.jorn_ccod)   when 1 then 'Diurno' when 2 then 'Vespertino' end as jornada,
    protic.ano_ingreso_carrera(b.pers_ncorr,max(m.carr_ccod)) as ano_carrera,protic.trunc(a.comp_fdocto) as fecha_asignacion
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
     join personas e
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
--and i.ofer_ncorr=10000
and protic.trunc(a.comp_fdocto)>='01/05/2004'
--and c.tdet_ccod in (1273,924,1270,1271,206,207,208,1266,1263,1264,1265) --seguro escolar, seguro escolar mancomunado
and d.tben_ccod in (2)
group by a.comp_ndocto,b.pers_ncorr,c.tdet_ccod,d.tdet_tdesc,c.deta_msubtotal,a.comp_fdocto,m.carr_tdesc,p.tcom_tdesc --,j.jorn_ccod--, o.pers_ncorr--,m.carr_ccod --,j.jorn_ccod


-- forma simple, solo consultando tabla sdescuentos

select distinct b.post_ncorr,b.pers_ncorr,d.tdet_tdesc as beca,protic.trunc(c.cont_fcontrato) as fecha_asignacion,cast(a.sdes_mmatricula as numeric)as matricula,cast(a.sdes_mcolegiatura as numeric) as monto_beca,
protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') as carrera,protic.obtener_nombre(b.pers_ncorr,'n') as nombre_alumno,protic.obtener_rut(b.pers_ncorr) as rut_alumno   
from sdescuentos a, postulantes b, contratos c, tipos_detalle d, alumnos e
where a.post_ncorr=b.post_ncorr
and b.post_ncorr=c.post_ncorr
and c.matr_ncorr=e.matr_ncorr
and b.post_ncorr=e.post_ncorr
and a.stde_ccod=d.tdet_ccod
and b.peri_ccod in (225,224,222)
and d.tben_ccod in (2,3)
and c.econ_ccod not in (2,3)
and a.esde_ccod in (1,2)
and b.pers_ncorr not in (
            select distinct b.pers_ncorr
            from alumnos a 
            join postulantes b
                on a.pers_ncorr=b.pers_ncorr
                and a.post_ncorr=b.post_ncorr
            join contratos c
                on a.matr_ncorr=c.matr_ncorr
            join ofertas_academicas d
                on b.ofer_ncorr=d.ofer_ncorr
            join sdescuentos g
                on a.post_ncorr=g.post_ncorr
                and d.ofer_ncorr=g.ofer_ncorr
            left outer join compromisos f
                on c.cont_ncorr=f.comp_ndocto
                and f.tcom_ccod=2
            left outer join abonos h
                on f.comp_ndocto=h.comp_ndocto
                and h.tcom_ccod=2 
            left outer join ingresos i
                on h.ingr_ncorr=i.ingr_ncorr
                and i.ting_ccod=7 
            where c.peri_ccod in (225,224,222)
            and b.peri_ccod in (225,224,222)
            and c.econ_ccod not in (3)
            and g.esde_ccod in (1,2)
)
order by beca , fecha_asignacion 




select * from SESTADOS_DESCUENTOS

-- select top 1 * from detalles where comp_ndocto=63712
-- select top 1 * from compromisos
-- select * from tipos_detalle where tben_ccod in (2)