-- Eliminar ingresos y abonos facturas
update ingresos set eing_ccod=3, audi_tusuario='anula-ingr-fact', audi_fmodificacion=getdate() 
where ingr_nfolio_referencia=340802

update ingresos set eing_ccod=3, audi_tusuario='anula-abon-fact', audi_fmodificacion=getdate() 
where ingr_nfolio_referencia in (select folio_abono_factura from facturas where ingr_nfolio_referencia=340802)



-- Eliminar compromisos Asociados
update detalle_compromisos set ecom_ccod=3, audi_tusuario='anula-comp-fact', audi_fmodificacion=getdate()
where comp_ndocto in (
    select top 1 comp_ndocto from abonos 
    where ingr_ncorr in (select ingr_ncorr 
    from ingresos 
    where ingr_nfolio_referencia=340802)
)
and tcom_ccod=9

update compromisos set ecom_ccod=3, audi_tusuario='anula-comp-fact', audi_fmodificacion=getdate()
where comp_ndocto in (
    select top 1 comp_ndocto from abonos 
    where ingr_ncorr in (select ingr_ncorr 
    from ingresos 
    where ingr_nfolio_referencia=340802)
)
and tcom_ccod=9


-- Eliminar registros de facturas
delete from postulantes_cargos_factura 
        where fact_ncorr in (select fact_ncorr from facturas where ingr_nfolio_referencia=340802 )

-- Anular facturas
update facturas set efac_ccod=3,audi_tusuario='anula-factura', audi_fmodificacion=getdate() 
where fact_ncorr in (select fact_ncorr from facturas where ingr_nfolio_referencia=340802 )

-- Cambiar estado a Orden de compra factura
update detalle_ingresos set edin_ccod=1,audi_tusuario='cambia-estado-OC', audi_fmodificacion=getdate() 
where ingr_ncorr in (
            select ingr_ncorr from detalle_ingresos where ingr_ncorr in (
                select ingr_ncorr from ingresos where ingr_ncorr in (
                    select ingr_ncorr from abonos where comp_ndocto in (
                       select comp_ndocto from abonos where ingr_ncorr in (
                        select ingr_ncorr from ingresos 
                        where ingr_nfolio_referencia in (select folio_abono_factura from facturas where ingr_nfolio_referencia=340802)
                        )
                        and tcom_ccod=7
                    )
                )
                and ting_ccod=33
                and eing_ccod=4
            ) and ting_ccod=5
        )
and edin_ccod=6