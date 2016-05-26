  select distinct peri_tdesc as periodo,o.ingr_nfolio_referencia as comprobante, mcaj_ncorr as caja, protic.trunc(ingr_fpago) as fecha_contrato,d.post_bnuevo as nuevo,
             i.tben_tdesc as tipo, a.stde_ccod, b.stde_tdesc as nombre_descuento, c.esde_tdesc as estado, a.post_ncorr, d.pers_ncorr, a.ofer_ncorr, e.sede_ccod,   
		     cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_alumno, f.pers_nrut,   
		     f.pers_tape_paterno + ' ' + f.pers_tape_materno + ' ' + f.pers_tnombre as nombre_alumno,   
		     h.carr_tdesc as carrera,sede_tdesc as sede,cast(a.sdes_mmatricula as int) as sdes_mmatricula,   
		     a.sdes_nporc_matricula as sdes_nporc_matricula,   
		     cast(a.sdes_mcolegiatura as int) as sdes_mcolegiatura,a.sdes_nporc_colegiatura as sdes_nporc_colegiatura,   
		     cast(isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as int) as subtotal, c.esde_ccod   
		     from sdescuentos a,stipos_descuentos b,sestados_descuentos c,   
		           postulantes d,ofertas_academicas e,personas_postulante f,   
		           especialidades g,carreras h,tipos_beneficios i,sedes j, contratos k, abonos l, ingresos o, periodos_academicos p   
		     where a.stde_ccod = b.stde_ccod   
		         and a.esde_ccod = c.esde_ccod    
		         and a.post_ncorr = d.post_ncorr    
		         and a.ofer_ncorr = d.ofer_ncorr   
		         and d.ofer_ncorr = e.ofer_ncorr    
		         and d.pers_ncorr = f.pers_ncorr   
		         and e.espe_ccod = g.espe_ccod    
		         and g.carr_ccod = h.carr_ccod   
		         and e.sede_ccod = j.sede_ccod     
		         and b.tben_ccod = i.tben_ccod    
		         and d.peri_ccod >='226'
                 and d.peri_ccod=p.peri_ccod
                 and a.esde_ccod=1
                 and a.stde_ccod=1593
                 and d.post_ncorr=k.post_ncorr
                 and econ_ccod=1
                 and k.cont_ncorr=l.comp_ndocto
                 and l.tcom_ccod=1
                 and l.ingr_ncorr=o.ingr_ncorr
                 and o.ting_ccod=7  