select dii.ingr_ncorr,protic.nro_letra_pactada(dii.ding_ndocto,ii.ingr_ncorr,cps.comp_ndocto,3)  as valores, 
  convert(varchar,pp.PERS_NRUT) +'-'+pp.PERS_XDV as rut_post,  
  cc.carr_tdesc + ' ('+ substring(jorn_tdesc,1,1) + ')' as carrera,ciu.ciud_tdesc ciudad_sede,  
  convert (varchar,dii.DING_FDOCTO,103) as fecha_entera_v  
  from postulantes p,personas_postulante pp,  
  personas_postulante ppc,ofertas_academicas oa,   
  especialidades ee, carreras cc,  
  direcciones_publica ddp, ciudades c,  
  compromisos cps , detalle_compromisos dc,  
  abonos bb, ingresos ii, detalle_ingresos dii, sedes ss, ciudades ciu, jornadas  
  where p.pers_ncorr=pp.pers_ncorr 
   and ee.carr_ccod=cc.carr_ccod    
  and cps.ecom_ccod <> 3    
  and cps.comp_ndocto=dc.comp_ndocto 
  and dii.ding_ndocto=349082
  and dii.ting_ccod=4
  and p.post_ncorr=171965
  and dii.ingr_ncorr=886758 
  and cps.tcom_ccod=dc.tcom_ccod       
  and bb.comp_ndocto=dc.comp_ndocto       
  and bb.tcom_ccod=dc.tcom_ccod        
  and bb.dcom_ncompromiso=dc.dcom_ncompromiso        
  and bb.ingr_ncorr=ii.ingr_ncorr    
  and ii.eing_ccod <> 3        
  and dii.ingr_ncorr = ii.ingr_ncorr    
  and dii.ting_ccod =4  
  and dii.pers_ncorr_codeudor = ppc.pers_ncorr   
  and ppc.pers_ncorr = ddp.pers_ncorr  
  and ddp.tdir_ccod =1  
  and ddp.ciud_ccod=c.ciud_ccod   
  and p.ofer_ncorr=oa.ofer_ncorr   
  and oa.espe_ccod=ee.espe_ccod   
  and oa.sede_ccod=ss.sede_ccod   
  and ss.ciud_ccod= ciu.ciud_ccod  
  and oa.jorn_ccod = jornadas.jorn_ccod 
  --and p.peri_ccod=222
  
------------------------------------------------------------------------------
--************* OPCION CON FORMATO SQL ESTANDARD (hay que depurar esta query) *********************
------------------------------------------------------------------------------

 select dii.ingr_ncorr,protic.nro_letra_pactada(dii.ding_ndocto,ii.ingr_ncorr,cps.comp_ndocto,3)  as valores, 
  convert(varchar,pp.PERS_NRUT) +'-'+pp.PERS_XDV as rut_post,  
  cc.carr_tdesc + ' ('+ substring(jorn_tdesc,1,1) + ')' as carrera,ciu.ciud_tdesc ciudad_sede,  
  convert (varchar,dii.DING_FDOCTO,103) as fecha_entera_v 
  from postulantes p 
    join personas_postulante pp
        on   p.pers_ncorr=pp.pers_ncorr 
    join ofertas_academicas oa  
        on p.ofer_ncorr=oa.ofer_ncorr 
    join jornadas 
        on oa.jorn_ccod = jornadas.jorn_ccod 
    join sedes ss
        on oa.sede_ccod=ss.sede_ccod 
    join especialidades ee
        on oa.espe_ccod=ee.espe_ccod
    join  carreras cc
        on ee.carr_ccod=cc.carr_ccod
    join compromisos cps
        on cps.ecom_ccod <> 3          
    join  detalle_compromisos dc
        on cps.comp_ndocto=dc.comp_ndocto       
        and cps.tcom_ccod=dc.tcom_ccod  
    join abonos bb
        on bb.comp_ndocto=dc.comp_ndocto       
        and  bb.tcom_ccod=dc.tcom_ccod        
        and  bb.dcom_ncompromiso=dc.dcom_ncompromiso   
    join ingresos ii
        on bb.ingr_ncorr=ii.ingr_ncorr
    join detalle_ingresos dii
        on dii.ingr_ncorr = ii.ingr_ncorr    
        and dii.ting_ccod =4
    join personas_postulante ppc
        on dii.pers_ncorr_codeudor = ppc.pers_ncorr
    join direcciones_publica ddp
        on ppc.pers_ncorr = ddp.pers_ncorr
    join ciudades c  
        on ddp.ciud_ccod=c.ciud_ccod
        and ddp.tdir_ccod =1          
    join ciudades ciu 
        on  ss.ciud_ccod= ciu.ciud_ccod  
  where dii.ding_ndocto=350155
  and dii.ting_ccod=4
  and p.post_ncorr=171945
  and dii.ingr_ncorr=895955   
  and ii.eing_ccod <> 3 