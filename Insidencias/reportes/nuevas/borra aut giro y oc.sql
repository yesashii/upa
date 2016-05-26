/*  SCRIP PARA LIMPIEZA DE MODELO ORDENES DE COMPRAS Y AUTORIZACIONES DE GIRO

--Limpia BD
select tsol_ccod,* from ocag_orden_compra
select tsol_ccod,* from ocag_solicitud_giro
select tsol_ccod,* from ocag_reembolso_gastos
select tsol_ccod,* from ocag_fondos_a_rendir
select tsol_ccod,* from ocag_solicitud_viatico
select tsol_ccod,* from ocag_devolucion_alumno
select tsol_ccod,* from ocag_fondo_fijo
select tsol_ccod,* from ocag_validacion_contable

-- rendiciones
select * from ocag_rendicion_fondo_fijo
select * from ocag_rendicion_fondos_a_rendir

-- detalles
select * from ocag_detalle_orden_compra
select * from ocag_detalle_pago_validacion
select * from ocag_detalle_reembolso_gasto
select * from ocag_detalle_solicitud_ag
select * from ocag_detalle_solicitud_giro

--otras
select * from ocag_presupuesto_orden_compra
select * from ocag_presupuesto_solicitud
select * from ocag_tipo_gasto_validacion
select * from ocag_centro_costo_validacion
select * from ocag_autoriza_solicitud_giro


-- Borra Tablas

--otras
delete from ocag_presupuesto_orden_compra
delete from ocag_presupuesto_solicitud
delete from ocag_tipo_gasto_validacion
delete from ocag_centro_costo_validacion

delete from ocag_orden_compra
delete from ocag_solicitud_giro
delete from ocag_reembolso_gastos
delete from ocag_fondos_a_rendir
delete from ocag_solicitud_viatico
delete from ocag_devolucion_alumno
delete from ocag_fondo_fijo
delete from ocag_validacion_contable

-- rendiciones
delete from ocag_rendicion_fondo_fijo
delete from ocag_rendicion_fondos_a_rendir

-- detalles
delete from ocag_detalle_orden_compra
delete from ocag_detalle_pago_validacion
delete from ocag_detalle_reembolso_gasto
delete from ocag_detalle_solicitud_ag
delete from ocag_detalle_solicitud_giro
delete from ocag_autoriza_solicitud_giro

