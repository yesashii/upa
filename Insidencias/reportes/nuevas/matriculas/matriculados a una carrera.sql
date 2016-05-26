select matr_ncorr,emat_ccod,protic.trunc(c.audi_fmodificacion) as fecha,sede_tdesc, carr_tdesc, protic.obtener_rut(c.pers_ncorr), 
(select post_bnuevo from postulantes where post_ncorr=c.post_ncorr) as es_nuevo
from ofertas_academicas a 
	left outer join sedes b 
		on a.sede_ccod=b.sede_ccod 
	left outer join alumnos c 
		on a.ofer_ncorr = c.ofer_ncorr 
	right outer join especialidades d 
		on a.espe_ccod = d.espe_ccod
    join carreras e
        on d.carr_ccod=e.carr_ccod     
where protic.afecta_estadistica(c.matr_ncorr) > 0 and c.audi_tusuario not like '%ajunte matricula%'
	and a.peri_ccod =protic.retorna_max_periodo_matricula(c.pers_ncorr,'222',d.carr_ccod)
    and e.carr_ccod in ('45')
    and isnull(c.alum_nmatricula,0) not in (7777) 
	and c.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',
		   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno', 
		   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65', 
		   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN', 
		   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2', 
		   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2') 
		and c.emat_ccod in (1,4,8,2,15,16)  
		And c.pers_ncorr > 0 
order by matr_ncorr desc       


--select * from carreras

