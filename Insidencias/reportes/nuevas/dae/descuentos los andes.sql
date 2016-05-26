 select distinct cast(sdes_mmatricula as integer) as d_matricula,cast(sdes_mcolegiatura as integer) as d_colegiatura,
            cast(g.sdes_nporc_matricula as numeric) as porcentaje_matricula,cast(g.sdes_nporc_colegiatura as numeric) as porcentaje_colegiatura,
            i.ingr_nfolio_referencia as comprobante,i.mcaj_ncorr as caja,
            (select tdet_tdesc from tipos_detalle where tdet_ccod=g.stde_ccod) as beneficio,
            protic.trunc(convert(datetime,protic.trunc(c.cont_fcontrato),103)) as fecha_asignacion,
            protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,
            protic.obtener_nombre_carrera(d.ofer_ncorr,'CJ') as carrera, sede_tdesc as sede,ccos_tcompuesto,
            (select tdet_detalle_softland from tipos_detalle where tdet_ccod=g.stde_ccod) as detalle_gasto
            from alumnos a 
            join postulantes b
                on a.pers_ncorr=b.pers_ncorr
                and a.post_ncorr=b.post_ncorr
            join contratos c
                on a.matr_ncorr=c.matr_ncorr
                and b.peri_ccod=c.peri_ccod
            join ofertas_academicas d
                on b.ofer_ncorr=d.ofer_ncorr
            join especialidades ep
                on d.espe_ccod=ep.espe_ccod    
            join sedes s
                on d.sede_ccod=s.sede_ccod    
            join sdescuentos g
                on a.post_ncorr=g.post_ncorr
                and d.ofer_ncorr=g.ofer_ncorr
                --and stde_ccod in (1262)
            join compromisos f
                on c.cont_ncorr=f.comp_ndocto
                and f.tcom_ccod in (1,2)
            join abonos h
                on f.comp_ndocto=h.comp_ndocto
                and h.tcom_ccod in (1,2)
            join ingresos i
                on h.ingr_ncorr=i.ingr_ncorr
                and i.ting_ccod in (7)
                --and i.ingr_nfolio_referencia=342678
            join personas j
                on a.pers_ncorr=j.pers_ncorr
           left outer join centros_costos_asignados z    	
				on z.cenc_ccod_carrera  =ep.carr_ccod       
				and z.cenc_ccod_sede    =d.sede_ccod       
				and z.cenc_ccod_jornada =d.jorn_ccod    	
			left outer join centros_costo za    			
				on za.ccos_ccod=z.ccos_ccod          
            where b.peri_ccod in (218)
           -- and c.econ_ccod not in (2,3)
           and convert(datetime,cont_fcontrato,103) between  convert(datetime,'01/02/2010',103) and convert(datetime,getdate(),103)
           order by fecha_asignacion asc