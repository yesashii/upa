select a.pers_ncorr_aval,protic.obtener_rut(a.pers_ncorr_aval) as Rut_beneficiario ,protic.obtener_nombre_completo(a.pers_ncorr_aval,'n') as Nombre_beneficiario,
    b.tbol_tdesc as Tipo_boleta,bole_nboleta as Num_boleta,bole_mtotal as Total_boleta,protic.trunc(a.bole_fboleta) as Fecha_boleta,
    ingr_nfolio_referencia as Comprobante,mcaj_ncorr as Caja, c.ebol_tdesc as Estado
From boletas a, tipos_boletas b, estados_boletas c
where a.tbol_ccod=b.tbol_ccod
    and a.ebol_ccod=c.ebol_ccod
    --and convert(datetime,bole_fboleta,103) between '01/01/2006' and '31/01/2006'
    AND convert(datetime,bole_fboleta,103) BETWEEN  isnull(convert(datetime,'01/01/2006',103),convert(datetime,bole_fboleta,103)) and isnull(convert(datetime,'',103),convert(datetime,bole_fboleta,103))
    and a.sede_ccod=1
    --and a.bole_nboleta=38422
order by num_boleta
    
    
select * from boletas where bole_nboleta=38346

select pers_ncorr from personas_postulante where pers_ncorr=17342

                      select top 1 a.peri_ccod,b.post_ncorr , b.pers_ncorr
                from postulantes a, codeudor_postulacion b 
                where a.pers_ncorr=17342
                    and a.post_ncorr=b.post_ncorr
                    order by a.peri_ccod desc,b.post_ncorr desc
                    
select * from detalle_ingresos where ding_ndocto=3752944 and ting_ccod in (38)         

select * from detalle_ingresos_historial where ingr_ncorr_origen=178415 --and ting_ccod in (3)            
   
   
   
   select * from estados_detalle_ingresos