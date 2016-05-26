select protic.format_rut(d.pers_nrut)as rut,  d.pers_tape_paterno+' '+d.pers_tape_materno +' '+ d.pers_tnombre as nombre,  
		  pama_nporc_matricula as porc_matricula,pama_nporc_colegiatura as porc_colegiatura,e.carr_tdesc as carrera,a.pama_tobservaciones as tipo,  
		  cast(DATEPART(day,a.audi_fmodificacion)as varchar)+'-'+cast(DATEPART(month,a.audi_fmodificacion)as varchar)+'-'+cast(DATEPART(year,a.audi_fmodificacion)as varchar)as fecha,  
		  case (select count(*)  from alumnos a, ofertas_academicas b, personas c where c.pers_nrut= d.pers_nrut  and c.pers_ncorr=a.pers_ncorr  and a.ofer_ncorr=b.ofer_ncorr  and a.emat_ccod=1  and b.peri_ccod=230) when 0 then 'No Matriculado' else 'Matriculado' end as estado  
		  from pase_matricula a, ofertas_academicas b,especialidades c,personas d,carreras e   
		  where a.ofer_ncorr=b.ofer_ncorr  
		  and b.espe_ccod=c.espe_ccod  
		  and c.carr_ccod=e.carr_ccod  
		  and a.pers_ncorr=d.pers_ncorr 
		  and a.peri_ccod=230
order by nombre          