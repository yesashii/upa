select aa.sede_ccod,aa.sede_tdesc, aa.carr_ccod, f.carr_tdesc+'- ('+(substring(e.jorn_tdesc,1,1))+')' as carr_tdesc, 
 cast(isnull(MATRICULADOS_n,0)as integer) as MATRICULADOS_n,  
 cast(isnull(MATRICULADOS_a,0)as integer) as MATRICULADOS_a,  
 cast(isnull(MATRICULADOS_n,0)+isnull(MATRICULADOS_a,0)as integer) as MATRICULADOS_t  
from ( select a.sede_ccod,a.sede_tdesc, a.carr_ccod, a.jorn_ccod,
    SUM(case EPOS_CCOD When 1 then (case nuevo when 'S' then total_pos end )else 0 end) as EN_PROCESO_n,  
    SUM(case EPOS_CCOD When 1 then (case nuevo when 'N' then total_pos end )else 0 end) as EN_PROCESO_a, 
    SUM(case EPOS_CCOD When 2 then (case nuevo when 'S' then total_pos end )else 0 end) as ENVIADOS_n,  
    SUM(case EPOS_CCOD When 2 then (case nuevo when 'N' then total_pos end )else 0 end) as ENVIADOS_a  
 from  
 (select b.sede_ccod,sede_tdesc, c.epos_ccod, e.carr_ccod,a.jorn_ccod, protic.es_nuevo_carrera(c.pers_ncorr,e.carr_ccod,a.peri_ccod) as nuevo, count(*) as total_pos  
 from ofertas_academicas a  
 left outer join sedes b  
    on a.sede_ccod=b.sede_ccod  
 left outer join especialidades e  
    on a.espe_ccod = e.espe_ccod  
  join detalle_postulantes d 
        on a.ofer_ncorr =d.ofer_ncorr 
  join postulantes c  
        on d.post_ncorr=c.post_ncorr 
 join periodos_academicos f 
    on  f.peri_ccod='202' 
    and f.plec_ccod in (1,2)  
 where  a.peri_ccod='202' 
   and   a.sede_ccod = '2' 
  and c.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42', 
                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',  
                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',  
                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',  
                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2',  
                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2')  
  group by b.sede_ccod,sede_tdesc, c.epos_ccod,e.carr_ccod,a.jorn_ccod, protic.es_nuevo_carrera(c.pers_ncorr,e.carr_ccod,a.peri_ccod)
  ) a  
 GROUP BY a.sede_ccod,a.SEDE_TDESC,a.carr_ccod,a.jorn_ccod   
 )AA  
 left outer join -- segunda tabla del from (B) 
 ( select c.matr_ncorr,b.sede_ccod,sede_tdesc, d.carr_ccod, a.jorn_ccod,count(*) as MATRICULADOS_n  
 from ofertas_academicas a left outer join sedes b  
    on a.sede_ccod = b.sede_ccod  
 left outer join alumnos c  
    on a.ofer_ncorr  = c.ofer_ncorr  
 left outer join especialidades d  
    on a.espe_ccod   = d.espe_ccod  
 where c.emat_ccod in (1,4,8,2,13)   
 and a.sede_ccod = '2'  
 And c.pers_ncorr > 0  
 and (select isnull(post_bnuevo,'N') from postulantes where post_ncorr=c.post_ncorr) = 'S' 
 and protic.afecta_estadistica(c.matr_ncorr) > 0  
 and a.peri_ccod=protic.retorna_max_periodo_matricula(c.pers_ncorr,'202',d.carr_ccod)  
 and c.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42', 
                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',  
                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',  
                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',  
                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2',  
                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2')  
 group by b.sede_ccod,sede_tdesc, d.carr_ccod,a.jorn_ccod,c.matr_ncorr
 ) B   
    on AA.carr_ccod=B.carr_ccod  
    and AA.jorn_ccod=B.jorn_ccod 
  left outer join --Join tabla virtual  
 ( select c.matr_ncorr,b.sede_ccod,sede_tdesc,d.carr_ccod,a.jorn_ccod, count(*) as MATRICULADOS_a  
 from ofertas_academicas a left outer join sedes b  
    on a.sede_ccod=b.sede_ccod   
 left outer join alumnos c  
    on a.ofer_ncorr = c.ofer_ncorr  
 left outer join especialidades d  
    on a.espe_ccod  = d.espe_ccod  
 where c.emat_ccod in (1,4,8,2,13)   
 and a.sede_ccod = '2'  
 And c.pers_ncorr > 0  
 and (select isnull(post_bnuevo,'N') from postulantes where post_ncorr=c.post_ncorr) = 'N' 
 and protic.afecta_estadistica(c.matr_ncorr) > 0  
 and a.peri_ccod='202'  
 and c.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42', 
                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',  
                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',  
                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',  
                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2',  
                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2')  
 group by b.sede_ccod,sede_tdesc, d.carr_ccod, a.jorn_ccod,c.matr_ncorr 
 ) BB  
    on AA.carr_ccod = BB.carr_ccod 
    and AA.jorn_ccod= BB.jorn_ccod
    and B.matr_ncorr=BB.matr_ncorr  
 join jornadas e 
    on AA.jorn_ccod=e.jorn_ccod 
 join carreras f  
    on AA.carr_ccod = f.carr_ccod 


