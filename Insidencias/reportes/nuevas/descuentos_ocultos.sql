select aa.* from (
        select  a.comp_ndocto,sum(dcom_mneto) as total_acumulado,f.aran_mcolegiatura, cast(f.aran_mcolegiatura -sum(dcom_mneto) as integer) as total_descuento,a.comp_ncuotas
        from compromisos a, contratos b,postulantes c,
        ofertas_academicas d, especialidades e, aranceles f, detalle_compromisos g
        where a.tcom_ccod=2 
        and convert(datetime,a.comp_fdocto,103)>='01/11/2004'
        --and a.audi_tusuario not in ('MIGRACION(FCACERES)')
        and a.comp_ndocto=b.cont_ncorr
        and a.ecom_ccod=1
        and a.comp_ncuotas <=10
        and b.econ_ccod=1
        --and b.peri_ccod >=164
        and b.post_ncorr=c.post_ncorr
        and c.ofer_ncorr=d.ofer_ncorr
        and d.espe_ccod=e.espe_ccod
        and d.aran_ncorr=f.aran_ncorr
        and a.comp_ndocto=g.comp_ndocto
        and a.tcom_ccod=g.tcom_ccod
        and a.inst_ccod=g.inst_ccod
        group by a.comp_ndocto,a.comp_mneto,f.aran_mcolegiatura,a.comp_ncuotas
        having
        sum(dcom_mneto) < f.aran_mcolegiatura
) aa
where aa.comp_ndocto not in(
    select a.comp_ndocto
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
    and convert(datetime,a.comp_fdocto,103)>='01/11/2004'
    and d.tben_ccod in (2,3)
    group by a.comp_ndocto,b.pers_ncorr,c.tdet_ccod,d.tdet_tdesc,c.deta_msubtotal,a.comp_fdocto,m.carr_tdesc,p.tcom_tdesc
    )





