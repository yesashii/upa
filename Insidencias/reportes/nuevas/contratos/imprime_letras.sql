 select protic.nro_letra(dii.ding_ndocto,ii.ingr_ncorr, 136433)  as valores, 
		  convert(varchar,pp.PERS_NRUT) +'-'+pp.PERS_XDV as rut_post,  
		  cc.carr_tdesc + ' ('+ substring(jorn_tdesc,1,1) + ')' as carrera,ciu.ciud_tdesc ciudad_sede,  
		  convert (varchar,dii.DING_FDOCTO,103) as fecha_entera_v,  
		  (select mes_tdesc from meses Where mes_ccod=datepart (month,dii.DING_FDOCTO)) as mes_v,  
		  datepart (dd,dii.DING_FDOCTO) as dd_v,  
		  datepart (yyyy,dii.DING_FDOCTO) as ano_v,  
		  (select mes_tdesc from meses Where mes_ccod=datepart (month,cps.COMP_FDOCTO)) as mes_e,  
		  datepart (dd,cps.COMP_FDOCTO) as dd_e,  
		  datepart (yyyy,cps.COMP_FDOCTO) as ano_e,  
		  dii.DING_MDETALLE monto,  
		  dii.ding_ndocto nro_docto,  
		  convert(varchar,ppc.PERS_NRUT) +'-'+ppc.PERS_XDV as rut_codeudor,   
		  ppc.PERS_TFONO as fono_codeudor, 'Carrera' as descripcion,  
		  protic.obtener_nombre(ppc.pers_ncorr,'c')  as nombre_codeudor,  
		  protic.obtener_direccion_letra(ppc.pers_ncorr, 1,'CNPB') as direccion,  
		  c.CIUD_TDESC ciudad, c.CIUD_TCOMUNA comuna  
		  from postulantes p,personas_postulante pp,  
		  personas_postulante ppc,ofertas_academicas oa,   
		  especialidades ee, carreras cc,  
		  direcciones_publica ddp, ciudades c,  
		  contratos con,compromisos cps , detalle_compromisos dc,  
	      abonos bb, ingresos ii, detalle_ingresos dii, sedes ss, ciudades ciu, jornadas  
		   where p.pers_ncorr=pp.pers_ncorr   
          and con.post_ncorr=p.post_ncorr and    
	      cps.ecom_ccod <> 3 and   
	      con.econ_ccod not in (3,4) and       
	      cps.comp_ndocto=dc.comp_ndocto and      
	      cps.tcom_ccod=dc.tcom_ccod and      
	      bb.comp_ndocto=dc.comp_ndocto and      
	      bb.tcom_ccod=dc.tcom_ccod and       
	      bb.dcom_ncompromiso=dc.dcom_ncompromiso and       
	      bb.ingr_ncorr=ii.ingr_ncorr and   
	      ii.eing_ccod <> 3 and       
	      dii.ingr_ncorr = ii.ingr_ncorr and   
		  dii.ting_ccod =4  
		  and dii.pers_ncorr_codeudor = ppc.pers_ncorr   
		  and ppc.pers_ncorr = ddp.pers_ncorr  
		  and ddp.tdir_ccod =1  
		  and ddp.ciud_ccod=c.ciud_ccod   
		  and p.ofer_ncorr=oa.ofer_ncorr   
		  and oa.espe_ccod=ee.espe_ccod   
		  and oa.sede_ccod=ss.sede_ccod   
		  and ss.ciud_ccod= ciu.ciud_ccod  
		  and ee.carr_ccod=cc.carr_ccod  
		  and oa.jorn_ccod = jornadas.jorn_ccod
           and dii.ding_ndocto=311388
           and dii.ting_ccod=4
           and p.post_ncorr=136433
           and dii.ingr_ncorr=775505 