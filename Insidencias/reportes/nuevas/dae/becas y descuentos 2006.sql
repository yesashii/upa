select count(rut) as alumnos, beneficio, carrera
 from (
            select distinct cast(sdes_mmatricula as integer) as d_matricula,cast(sdes_mcolegiatura as integer) as d_colegiatura,
            cast(g.sdes_nporc_matricula as numeric) as porcentaje_matricula,cast(g.sdes_nporc_colegiatura as numeric) as porcentaje_colegiatura,
            i.ingr_nfolio_referencia as comprobante,i.mcaj_ncorr as caja,
            (select tdet_tdesc from tipos_detalle where tdet_ccod=g.stde_ccod) as beneficio,
            protic.trunc(convert(datetime,protic.trunc(c.cont_fcontrato),103)) as fecha_asignacion,
            protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,
            protic.obtener_nombre_carrera(d.ofer_ncorr,'CJ') as carrera
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
             join compromisos f
                on c.cont_ncorr=f.comp_ndocto
                and f.tcom_ccod in (1,2)
             join abonos h
                on f.comp_ndocto=h.comp_ndocto
                and h.tcom_ccod in (1,2)
             join ingresos i
                on h.ingr_ncorr=i.ingr_ncorr
                and i.ting_ccod=7
                --and i.ingr_nfolio_referencia=105944
            join personas j
                on a.pers_ncorr=j.pers_ncorr     
            where b.peri_ccod in (202,204)
            and c.peri_ccod in (202,204)
            and c.econ_ccod not in (2,3)
            and g.esde_ccod in (1)
            and convert(datetime,cont_fcontrato,103) between  convert(datetime,'01/09/2005',103) and convert(datetime,'01/10/2006',103)
            --order by fecha_asignacion
) as tabla
group by beneficio, carrera


--################################################
--**********    Desceuntos regularizados *********
--################################################

select count(rut) as alumnos, beneficio, carrera
from (
select distinct aplicado_sobre,monto_descontado,sobre_monto,comprobante,caja,beneficio,
fecha as fecha_asignacion,rut,nombre_alumno,max(arancel) as arancel, carrera
from (
Select distinct a.mcaj_ncorr as caja,a.ingr_nfolio_referencia as comprobante ,m.tcom_tdesc as aplicado_sobre,
 protic.trunc(a.ingr_fpago) as fecha,a.pers_ncorr,sum(cast(k.abon_mabono as integer)) as monto_descontado,cast(sum(l.dcom_mneto) as numeric) as sobre_monto, c.ting_tdesc as beneficio, 
 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno,
( select top 1 aran_mcolegiatura from aranceles where ofer_ncorr in (select top 1 ofer_ncorr from alumnos where matr_ncorr=d.matr_ncorr and emat_ccod not in (9))) as arancel,
protic.obtener_nombre_carrera((select top 1 ofer_ncorr from alumnos where matr_ncorr=d.matr_ncorr and emat_ccod not in (9)),'CJ') as carrera
From ingresos a
    join  detalle_ingresos b 
        on a.ingr_ncorr=b.ingr_ncorr
    join  tipos_ingresos c
        on b.ting_ccod=c.ting_ccod
    join  postulantes i  
        on a.pers_ncorr=i.pers_ncorr    
    join  alumnos d 
        on i.post_ncorr=d.post_ncorr
        and d.emat_ccod not in (9)
    join  ofertas_academicas e 
        on d.ofer_ncorr=e.ofer_ncorr
    join  especialidades g  
        on e.espe_ccod=g.espe_ccod
    join  carreras f  
        on g.carr_ccod=f.carr_ccod 
    join  estados_matriculas j  
        on d.emat_ccod=j.emat_ccod
    join  abonos k  
        on a.ingr_ncorr=k.ingr_ncorr
    join  detalle_compromisos l  
        on k.tcom_ccod=l.tcom_ccod
        and k.inst_ccod=l.inst_ccod
        and k.comp_ndocto=l.comp_ndocto
        and k.dcom_ncompromiso=l.dcom_ncompromiso
    left outer join tipos_compromisos m
        on l.tcom_ccod=m.tcom_ccod
    Where b.ting_ccod in (
                        select ting_ccod
                        from tipos_ingresos 
                        where ting_bregularizacion='S'
                        and ereg_ccod=4
                        )
        and a.eing_ccod not in (3,6)
        --and i.peri_ccod in (202,204,205)
        and k.comp_ndocto in (select cont_ncorr as comp_ndocto from contratos 
                                union 
                                select  comp_ndocto from compromisos where pers_ncorr=a.pers_ncorr and tcom_ccod in (3,14))
        and convert(datetime,a.ingr_fpago,103) between  convert(datetime,'01/11/2005',103) and convert(datetime,getdate(),103)
       group by m.tcom_tdesc,l.tcom_ccod,a.mcaj_ncorr,d.matr_ncorr,a.ingr_nfolio_referencia,a.ingr_fpago,b.ting_ccod,c.ting_tdesc,a.pers_ncorr
)  as tabla
group by aplicado_sobre,monto_descontado,sobre_monto,beneficio,
fecha,nombre_alumno, rut,carrera, caja,comprobante
) as tabla
where arancel >0
group by  beneficio, carrera