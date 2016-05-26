
-- ### CAMBIO DE TIPO COMPROMISO EN TABLA "COMPROMISOS" ###
update compromisos set tcom_ccod=6, audi_tusuario=audi_tusuario+'-camb. tipo' 
where comp_ndocto in ( select comp_ndocto from detalles where tdet_ccod=1226 and tcom_ccod=25)
and tcom_ccod=25

-- ### CAMBIO DE TIPO COMPROMISO EN TABLA "DETALLE_COMPROMISOS" ###
update detalle_compromisos set tcom_ccod=6, audi_tusuario=audi_tusuario+'-camb. tipo' 
where comp_ndocto in ( select comp_ndocto from detalles where tdet_ccod=1226 and tcom_ccod=25)
and tcom_ccod=25

-- ### CAMBIO DE TIPO COMPROMISO EN TABLA "ABONOS" ###
update abonos set tcom_ccod=6, audi_tusuario=audi_tusuario+'-camb. tipo' 
where comp_ndocto in ( select comp_ndocto from detalles where tdet_ccod=1226 and tcom_ccod=25)
and tcom_ccod=25

-- ### CAMBIO DE TIPO COMPROMISO Y TIPO DETALLE EN TABLA "DETALLES" ###
update detalles set tdet_ccod=1439, tcom_ccod=6, audi_tusuario=audi_tusuario+'-camb. tipo' where tdet_ccod=1226 


