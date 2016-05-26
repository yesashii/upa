select * from dbo.presupuesto_directo_area_desa where anio = 2016 order by area_ccod desc




select * from buscar_tabla('area_ccod')



select * from areas_academicas

-- ---------------------------------------

select pre.area_ccod,
ara.area_tdesc as area,
pre.tipo_gasto,
pre.cod_pre as codigo,
pre.detalle as Detalle,
pre.ene as Enero,
pre.feb as Febrero,
pre.mar as Marzo,
pre.abr as Abril,
pre.may as Mayo,
pre.jun as Junio,
pre.jul as Julio,
pre.ago as Agosto,
pre.sep as Septiembre,
pre.octu as Octubre,
pre.nov as Noviembre,
pre.dic as Diciembre,
pre.total

from presupuesto_directo_area_desa pre
left outer join area_presupuestal_aux ara
on pre.area_ccod = ara.area_ccod

where anio = 2016 order by ara.area_tdesc asc


-- ------------------------






select * from areas_academicas where area_ccod = 106