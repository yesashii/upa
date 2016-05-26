select top 10 e.comp_ndocto,f.comp_ndocto,
protic.nro_letra_pactada(dii.ding_ndocto, dii.ingr_ncorr, e.comp_ndocto,7) as valores, protic.obtener_rut(p.pers_ncorr) as rut_post, 
       g.tdet_tdesc as carrera, n.ciud_tdesc as ciudad_sede, 
	   convert (varchar,dii.DING_FDOCTO,103) as fecha_entera_v, 
	   (select mes_tdesc from meses Where mes_ccod=datepart (month,dii.DING_FDOCTO)) as mes_v, 
	   datepart (dd,dii.DING_FDOCTO) as dd_v, 
	   datepart (yyyy,dii.DING_FDOCTO) as ano_v, 
	   (select mes_tdesc from meses Where mes_ccod=datepart(month,e.COMP_FDOCTO)) as mes_e, 
	   datepart (dd,e.COMP_FDOCTO) as dd_e, 
	   datepart (yyyy,e.COMP_FDOCTO) as ano_e, 'Curso' as descripcion,  
	   dii.ding_mdetalle as monto, dii.ding_ndocto as nro_docto, 
	   protic.obtener_rut(j.pers_ncorr) as rut_codeudor, j.pers_tfono as fono_codeudor, protic.obtener_nombre(j.pers_ncorr,'c') as nombre_codeudor, 
       protic.obtener_direccion(j.pers_ncorr, 1,'CN') as direccion, l.ciud_tdesc as ciudad, l.ciud_tcomuna as comuna 
  from detalle_ingresos dii, ingresos b, abonos c, detalle_compromisos d, compromisos e, sim_pactaciones f, tipos_detalle g, 
	   personas p, personas j, direcciones k, ciudades l, 
	 sedes m, ciudades n 
  where dii.ingr_ncorr = b.ingr_ncorr
      and dii.ding_ndocto=351557
    and dii.ting_ccod=4
    and dii.ingr_ncorr=917470 
	and b.ingr_ncorr = c.ingr_ncorr 
	and c.tcom_ccod = d.tcom_ccod 
	and c.inst_ccod = d.inst_ccod 
	and c.comp_ndocto = d.comp_ndocto 
	and c.dcom_ncompromiso = d.dcom_ncompromiso 
	and d.tcom_ccod = e.tcom_ccod 
	and d.inst_ccod = e.inst_ccod 
	and d.comp_ndocto = e.comp_ndocto 			
	and e.inst_ccod = f.inst_ccod 
	and protic.compromiso_origen_repactacion(e.comp_ndocto, 'comp_ndocto') = f.comp_ndocto 
	and f.tdet_ccod = g.tdet_ccod 
	and e.pers_ncorr = p.pers_ncorr 			
	and dii.pers_ncorr_codeudor = j.pers_ncorr 
	and j.pers_ncorr = k.pers_ncorr 
	and k.ciud_ccod = l.ciud_ccod 
	and e.sede_ccod = m.sede_ccod 
	and m.ciud_ccod = n.ciud_ccod 
	and k.tdir_ccod = 1 


select * from ingresos where ingr_nfolio_referencia=464823
select * from abonos where ingr_ncorr=917470

select protic.compromiso_origen_repactacion(170030, 'comp_ndocto') 

select  protic.compromiso_origen_repactacion(122271, 'tcom_ccod')


select * from sim_pactaciones

select d.cont_ncorr
from repactaciones a, compromisos b, postulantes c, contratos d
where a.comp_ndocto = b.comp_ndocto
  and a.tcom_ccod = b.tcom_ccod
  and b.pers_ncorr = c.pers_ncorr
  and c.post_ncorr = d.post_ncorr
  and d.econ_ccod = 1
  and a.repa_ncorr = 122271
order by d.peri_ccod desc