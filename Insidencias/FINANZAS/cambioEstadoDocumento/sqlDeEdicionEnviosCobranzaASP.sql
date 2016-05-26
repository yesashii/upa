select a.envi_ncorr, c.ting_ccod, d.ting_tdesc, c.ding_ndocto as c_ding_ndocto, c.ingr_ncorr, c.ding_ndocto, c.ding_mdocto,  
       protic.trunc(e.ingr_fpago) as fecha_envio, protic.tiene_multa_protesto(c.ting_ccod, c.ding_ndocto, c.ingr_ncorr) as multa_protesto, 
	   protic.trunc(c.ding_fdocto) as ding_fdocto, c.ding_tcuenta_corriente, f.edin_tdesc, 
	   protic.obtener_nombre_completo(isnull(c.pers_ncorr_codeudor, protic.ultimo_aval(e.pers_ncorr)),'N') as nombre_apoderado, 
	   protic.obtener_rut(e.pers_ncorr) as rut_alumno, 
	   protic.obtener_rut(isnull(c.pers_ncorr_codeudor, protic.ultimo_aval(e.pers_ncorr))) as rut_apoderado 
from envios a, detalle_envios b, detalle_ingresos c, tipos_ingresos d, ingresos e, estados_detalle_ingresos f 
where a.envi_ncorr = b.envi_ncorr 
  and b.ting_ccod = c.ting_ccod 
  and b.ingr_ncorr = c.ingr_ncorr 
  and b.ding_ndocto = c.ding_ndocto 
  and c.ting_ccod = d.ting_ccod 
  and c.ingr_ncorr = e.ingr_ncorr 
  and c.edin_ccod = f.edin_ccod 
  and cast(a.envi_ncorr as varchar)= '77611'
 Order by c.ding_ndocto asc,c.ting_ccod asc
