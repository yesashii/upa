CREATE procedure agrega_morosidad 
AS
BEGIN

    -- Actualiza la morosidad del dia anterior
    update indicador_morosidad_upa set imup_bvigente=0 where imup_bvigente=1

    -- Inserta morosidad actual
    insert into indicador_morosidad_upa
    select f.tcom_ccod,f.comp_ndocto,f.dcom_ncompromiso,b.pers_ncorr,convert(datetime,protic.trunc(getdate()),103) as imup_fcorte,
     '1' as imup_bvigente,convert(datetime,protic.trunc(f.dcom_fcompromiso),103) as dcom_fcompromiso, 
     e.peri_ccod,e.post_ncorr,e.ofer_ncorr,e.sede_ccod,
     protic.documento_asociado_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso,'ting_ccod') as ting_ccod,
     protic.ultima_oferta_matriculado(a.pers_ncorr) as ofer_ncorr_actual,c.sede_ccod as sede_ccod_actual, 
     cast(sum(f.dcom_mcompromiso) as numeric) as imup_monto_deuda,
     protic.total_recepcionar_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso) as imup_monto_saldo,
     protic.obtener_nombre_carrera(c.ofer_ncorr, 'CEJ') as imup_carrera 
	    from personas a 
            join alumnos b
                on a.pers_ncorr = b.pers_ncorr
                and b.emat_ccod = 1
            join ofertas_academicas c
                on b.ofer_ncorr = c.ofer_ncorr
                and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr)
            join sedes d
                on c.sede_ccod = d.sede_ccod
            join compromisos e
                on a.pers_ncorr = e.pers_ncorr
                and e.ecom_ccod = 1
            join detalle_compromisos f
                on e.tcom_ccod = f.tcom_ccod 
	            and e.inst_ccod = f.inst_ccod 
	            and e.comp_ndocto = f.comp_ndocto
                and f.ecom_ccod = 1
                and convert(datetime,f.dcom_fcompromiso,103) <= convert(datetime,getdate()-5,103)
        --where protic.total_recepcionar_cuota(f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso)>0
	    group by e.peri_ccod,e.post_ncorr,e.sede_ccod,b.pers_ncorr,a.pers_ncorr,e.ofer_ncorr, c.sede_ccod,  
                f.tcom_ccod,f.inst_ccod,f.comp_ndocto,f.dcom_ncompromiso,f.dcom_fcompromiso,c.ofer_ncorr

END