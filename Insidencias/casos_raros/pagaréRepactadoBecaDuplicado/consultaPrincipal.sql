SELECT  distinct 
 rp.repa_ncorr AS ciudad_codeudor1, dii.DING_NDOCTO AS nro_pagare,    
 (SELECT SUM(DING_MDETALLE) FROM detalle_ingresos r WHERE r.repa_ncorr =rp.repa_ncorr and r.TING_CCOD=dii.TING_CCOD GROUP BY DING_MDETALLE ) AS valor_pagar,  
 (SELECT COUNT(*) FROM detalle_ingresos r WHERE r.repa_ncorr=rp.repa_ncorr and r.TING_CCOD=dii.TING_CCOD GROUP BY DING_MDETALLE ) AS NUMERO_CUOTAS,      
 cast(DATEPART(dd, GETDATE()) AS varchar) dd_hoy,
 protic.trunc(dii.ding_fdocto) as fecha_pago,    
 (SELECT mes_tdesc FROM meses WHERE mes_ccod = DATEPART(mm, GETDATE()))AS mm_hoy,    
 cast(DATEPART(mm, GETDATE()) AS varchar) mm_antiguo,    
 dii.ding_tcuenta_corriente cuenta_cte,(select banc_tdesc from bancos where banc_ccod=dii.banc_ccod) as banco ,  
 cast(DATEPART(yy, GETDATE())AS varchar) yy_hoy, ciu.ciud_tdesc    
 ciudad_sede, pac.anos_ccod periodo_academico, (pac.anos_ccod + 1) AS inicio_vencimiento,    
 (pac.anos_ccod + 2) AS final_vencimiento, cast(pp.pers_nrut AS varchar) + '-' + cast(pp.pers_xdv AS varchar) AS rut_post,    
 pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno AS nombre_alumno,    
 cc.carr_tdesc AS carrera, cast(ppc.pers_nrut AS varchar) + '-' + cast(ppc.pers_xdv AS varchar) AS rut_codeudor,    
 ppc.pers_tnombre + ' ' + ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno    
 AS nombre_codeudor, ddc.dire_tcalle + ' ' + cast(ddc.dire_tnro AS varchar)+' '+ case ddc.DIRE_TBLOCK when '' then '' else 'Depto '+cast(ddc.DIRE_TBLOCK as varchar) end AS direccion_codeudor,    
 c.ciud_tcomuna ciudad_codeudor, ddp.dire_tcalle + ' ' + cast(ddp.dire_tnro AS varchar) AS direccion_postulante,   
 ccp.ciud_tdesc ciudad_codeudor1_x_contrato,dii.ding_mdetalle as valor_cuota,c.ciud_tdesc comuna_codeudor    
 FROM postulantes p    
 join personas_postulante pp    
 on p.pers_ncorr = pp.pers_ncorr  
 and cast(p.post_ncorr as varchar)='258924'--'"+post_ncorr+"'    
 join codeudor_postulacion cp    
 on p.post_ncorr = cp.post_ncorr    
 join personas_postulante ppc    
 on cp.pers_ncorr = ppc.pers_ncorr    
 join ofertas_academicas oa    
 on p.ofer_ncorr = oa.ofer_ncorr    
 join especialidades ee    
 on oa.espe_ccod = ee.espe_ccod    
 join carreras cc    
 on ee.carr_ccod = cc.carr_ccod    
 join direcciones_publica ddp    
 on pp.pers_ncorr = ddp.pers_ncorr    
 left outer join ciudades ccp    
 on ddp.ciud_ccod =ccp.ciud_ccod    
 join direcciones_publica ddc    
 on ppc.pers_ncorr = ddc.pers_ncorr    
 left outer join ciudades c    
 on ddc.ciud_ccod =c.ciud_ccod    
 join periodos_academicos pac    
 on oa.peri_ccod = pac.peri_ccod    
 join compromisos cps      
 on p.pers_ncorr=cps.pers_ncorr  
 and cps.tcom_ccod=3      
 join repactaciones rp  
 on cps.comp_ndocto=rp.repa_ncorr     
 join sedes ss    
 on oa.sede_ccod = ss.sede_ccod    
 join ciudades ciu     
 on ss.ciud_ccod = ciu.ciud_ccod    
 join detalle_compromisos dc     
 on cps.comp_ndocto=dc.comp_ndocto      
 and cps.inst_ccod=dc.inst_ccod      
 and cps.tcom_ccod=dc.tcom_ccod       
 join detalle_ingresos dii     
 ON rp.repa_ncorr = dii.repa_ncorr
 left outer join ingresos ii     
 on dii.ingr_ncorr = ii.ingr_ncorr    
 left outer join tipos_ingresos tii    
 on dii.ting_ccod =tii.ting_ccod    
 left outer join bancos bn     
 on dii.banc_ccod = bn.banc_ccod    
 WHERE  cast(rp.repa_ncorr as varchar) = '773435'--'"+repa_ncorr+"'  
 and dii.DING_NDOCTO IN(174,175) 
 and ddc.tdir_ccod = 1     
 AND ddp.tdir_ccod = 1     
 and cps.ecom_ccod <> 3      
 and cps.tcom_ccod in (3)    
 and dc.tcom_ccod in (3) 