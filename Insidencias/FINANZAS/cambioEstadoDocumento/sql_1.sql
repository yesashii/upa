


select * from estados_detalle_ingresos



select * from compromisos

select * from detalle_ingresos

-- --------------------

select table_name,
column_name,
is_nullable,
ordinal_position

from buscar_tabla('TING_CCOD')

order by ordinal_position

-- -----------------------

select ing.ingr_ncorr as ingresos, dei.ingr_ncorr as detalle_ingresos

from ingresos as ing
RIGHT join detalle_ingresos as dei
on ing.ingr_ncorr = dei.ingr_ncorr

ORDER BY ingresos

-- -----------------------------------------------------------


select b.ting_ccod ,						
a.* 									

from detalle_ingresos 		as a
inner join TIPOS_INGRESOS 	as b
on a.ting_ccod = b.ting_ccod

ORDER BY detalle_ingresos



select * from TIPOS_INGRESOS

-- -------------------------------------

select DISTINCT ingr_ncorr from INGRESOS


select DISTINCT ingr_ncorr from detalle_ingresos



select * from INGRESOS where ingr_ncorr in (select DISTINCT ingr_ncorr from detalle_ingresos)


select * from detalle_ingresos where ingr_ncorr in (select DISTINCT ingr_ncorr from INGRESOS)



select ingr_ncorr from INGRESOS ORDER BY ingr_ncorr

select  ingr_ncorr from detalle_ingresos ORDER BY ingr_ncorr

-- ------------------------------------
select * from detalle_ingresos 
WHERE ting_ccod = 3
and ding_ndocto = 33
and ingr_ncorr = 1497697
-- ---------------------------------------


BEGIN TRANSACTION
update detalle_ingresos

set edin_ccod = 100
WHERE ting_ccod = 3
and ding_ndocto = 33
and ingr_ncorr = 1497697

COMMIT

-- -----------------------------------------------

select * from detalle_ingresos 
WHERE ting_ccod = 3
and ding_ndocto = 32
and ingr_ncorr = 1497696


BEGIN TRANSACTION
update detalle_ingresos

set edin_ccod = 100
WHERE ting_ccod = 3
and ding_ndocto = 32
and ingr_ncorr = 1497696

COMMIT















