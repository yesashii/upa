--##############################################################################################################

--##########    PROCESO QUE LLENA TABLA DE PASO PARA OBTENER LOS DOCUMENTOS QUE ESTAN ABONADOS

--##############################################################################################################

delete from documento_pagado

-- BORRA LA TABLA PARA LUEGO LLENARLA

 

insert into documento_pagado
select  c.ingr_ncorr,'ghernan',getdate()
                          from     
              compromisos a     
              join detalle_compromisos b     
                        on a.tcom_ccod = b.tcom_ccod        
                                   and a.inst_ccod = b.inst_ccod        
                                   and a.comp_ndocto = b.comp_ndocto 
                        and a.ecom_ccod = '1'
            join detalle_ingresos c    
                    on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod
            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto
            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr
            and c.ting_ccod in(3,4,13,51,52)
            and c.edin_ccod not in (6,11)    
        join ingresos e
                on c.ingr_ncorr=e.ingr_ncorr
                and e.eing_ccod not in (3,6)           
        where protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0
        and protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)= c.ding_mdocto


--##############################################################################################################
--###############          FIN TABLA DE PASO
--##############################################################################################################



-- CONSULTA DE FLUJOS (obtiene los montos netos de los documentos, no contempla los saldos de los documentos abonados)

 
select top 10 protic.obtener_rut(a.pers_ncorr) as rut,c.ting_tdesc as tipo_docto, 
b.ding_ndocto as numero_docto,b.ding_ncorrelativo as correlativo,cast(b.ding_mdetalle as numeric) as detalle, 
cast(b.ding_mdocto as numeric) as total_docto,protic.trunc(b.ding_fdocto) as fecha_docto,d.edin_tdesc as estado_docto,
case when a.ting_ccod=15 then
    (select top 1 peri_tdesc from periodos_academicos where anos_ccod>=year(getdate()) and plec_ccod=1 order by peri_ccod asc)
    else (select top 1 peri_tdesc  from abonos ab, periodos_academicos pa where ab.peri_ccod=pa.peri_ccod and ab.ingr_ncorr=a.ingr_ncorr) end as periodo,
    (select sede_tdesc from sedes where sede_ccod in ((isnull((select top 1 sede_ccod from alumnos al, ofertas_academicas oa where al.ofer_ncorr=oa.ofer_ncorr and al.pers_ncorr=a.pers_ncorr 
    and oa.peri_ccod in (select top 1 pa.peri_ccod  from abonos ab, periodos_academicos pa where ab.peri_ccod=pa.peri_ccod and ab.ingr_ncorr=a.ingr_ncorr)),1)))) as sede
from ingresos a, detalle_ingresos b, 
tipos_ingresos c, estados_detalle_ingresos d
where a.ingr_ncorr=b.ingr_ncorr
    and a.eing_ccod=4 -- documentados
    and b.ting_ccod in (3,4,13,51,52) --DOCUMENTOS (3=cheques,4=letras, 13=T Credito, 51=T. Debito, 52=Pagare Tranbank.)
    and convert(datetime,ding_fdocto,103)>=convert(datetime,'12/03/2010',103)
    and b.edin_ccod not in (6,11)
    and b.ingr_ncorr not in (select ingr_ncorr from documento_pagado) --TABLA CON DATOS DOCUMENTOS ABONADOS
    and b.ting_ccod=c.ting_ccod
    and b.edin_ccod=d.edin_ccod
    order by ding_fdocto, b.ting_ccod

--##############################################################################################################
--###############          Listado de los saldos a los documentos abonados  (demora un poco)
--##############################################################################################################

 

select  protic.obtener_rut(e.pers_ncorr) as rut, ting_tdesc as tipo_documento,c.ding_ndocto numero_documento,
c.ding_mdocto- protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo_documento,
protic.trunc(c.ding_fdocto) as fecha_vencimiento
                          from     
               compromisos a     
           join  detalle_compromisos b     
                on a.tcom_ccod = b.tcom_ccod        
                and a.inst_ccod = b.inst_ccod        
                and a.comp_ndocto = b.comp_ndocto 
                and a.ecom_ccod = '1'
            join  detalle_ingresos c
                on c.ting_ccod in(3,4,13,51,52)
                and c.edin_ccod not in (6,11)                 
                and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod
                and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto
                and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr
        join tipos_ingresos d
            on c.ting_ccod=d.ting_ccod
        join  ingresos e
                on c.ingr_ncorr=e.ingr_ncorr
                and e.eing_ccod not in (3,6)           
        where protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0
        and protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)< c.ding_mdocto
 
--################################################
---                 FIN FLUJOS


