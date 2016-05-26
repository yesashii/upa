-- BORRA LA TABLA PARA LUEGO LLENARLA
delete from protic.documento_pagado
select * from documento_pagado

 
-- inserta documentos en tabla temporal
insert into protic.documento_pagado
select  c.ingr_ncorr,'ghernan',getdate()
                          from     
              protic.compromisos a     
              join protic.detalle_compromisos b     
                        on a.tcom_ccod = b.tcom_ccod        
                        and a.inst_ccod = b.inst_ccod        
                        and a.comp_ndocto = b.comp_ndocto 
                        and a.ecom_ccod = '1'
            join protic.detalle_ingresos c    
                    on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod
            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto
            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr
            and c.ting_ccod in(3,4,13,51,52)
            and c.edin_ccod not in (6,11)    
        join protic.ingresos e
                on c.ingr_ncorr=e.ingr_ncorr
                and e.eing_ccod not in (3,6)           
        where protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0
        and protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)= c.ding_mdocto


--##############################################################################################################
--###############          FIN TABLA DE PASO
--##############################################################################################################


-- CONSULTA DE FLUJOS (obtiene los montos netos de los documentos, no contempla los saldos de los documentos abonados)

select protic.obtener_rut(a.pers_ncorr) as rut,c.ting_tdesc as tipo_docto, 
b.ding_ndocto as numero_docto,b.ding_ncorrelativo as correlativo,cast(b.ding_mdetalle as numeric) as detalle, 
cast(b.ding_mdocto as numeric) as total_docto,protic.trunc(b.ding_fdocto) as fecha_docto,d.edin_tdesc as estado_docto,
case when a.ting_ccod=15 then
(select top 1 peri_tdesc from protic.periodos_academicos where anos_ccod>=year(getdate()) and plec_ccod=1
order by peri_ccod asc)
else (select top 1 peri_tdesc  from protic.abonos ab, protic.periodos_academicos pa where ab.peri_ccod=pa.peri_ccod and ab.ingr_ncorr=a.ingr_ncorr) end as periodo,
(select sede_tdesc from protic.sedes where sede_ccod in ((isnull((select top 1 sede_ccod from protic.alumnos al, protic.ofertas_academicas oa where al.ofer_ncorr=oa.ofer_ncorr and al.pers_ncorr=a.pers_ncorr 
and oa.peri_ccod in (select top 1 pa.peri_ccod  from protic.abonos ab, protic.periodos_academicos pa where ab.peri_ccod=pa.peri_ccod and ab.ingr_ncorr=a.ingr_ncorr)),1)))) as sede
from protic.ingresos a, protic.detalle_ingresos b, protic.tipos_ingresos c, protic.estados_detalle_ingresos d
where a.ingr_ncorr=b.ingr_ncorr
and a.eing_ccod=4 -- documentados
and b.ting_ccod in (3,4,13,51,52) --DOCUMENTOS (3=cheques,4=letras, 13=T Credito, 51=T. Debito, 52=Pagare Tranbank.)
and convert(datetime,ding_fdocto,103)>=convert(datetime,'30/05/2009',103)
and b.edin_ccod not in (6,11)
and b.ingr_ncorr not in (select ingr_ncorr from protic.documento_pagado) --TABLA CON DATOS DOCUMENTOS ABONADOS
and b.ting_ccod=c.ting_ccod
and b.edin_ccod=d.edin_ccod
order by ding_fdocto, b.ting_ccod

--##############################################################################################################
--###############          Listado de los saldos a los documentos abonados  (demora un poco)
--##############################################################################################################

select  protic.obtener_rut(a.pers_ncorr) as rut,c.ding_mdocto as total_docto,f.edin_tdesc as estado_docto,
d.ting_tdesc as tipo_docto,c.ting_ccod as tipo_documento,c.ding_ndocto numero_documento,c.ding_fdocto as fecha_vencimiento,
cast(c.ding_mdocto- protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as numeric) as saldo_documento
    from     
              protic.compromisos a     
            join protic.detalle_compromisos b     
                on a.tcom_ccod = b.tcom_ccod        
                and a.inst_ccod = b.inst_ccod        
                and a.comp_ndocto = b.comp_ndocto 
                and a.ecom_ccod = '1'
            join protic.detalle_ingresos c    
                on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod
                and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto
                and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr
                and c.ting_ccod in(3,4,13,51,52)
                and c.edin_ccod not in (6,11)
                and convert(datetime,c.ding_fdocto,103)>=convert(datetime,'30/05/2009',103)    
            join tipos_ingresos d
                on c.ting_ccod= d.ting_ccod     
            join protic.ingresos e
                on c.ingr_ncorr=e.ingr_ncorr
                and e.eing_ccod not in (3,6)
            join estados_detalle_ingresos f
                on c.edin_ccod=f.edin_ccod                
        where protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0
        and protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)< c.ding_mdocto

--################################################


informaciones@veronicaovalle.cl