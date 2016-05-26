select * from SIS_USUARIOS where pers_ncorr = 110474

-- regina villouta




-- --------------------------------------------------------------------------

SELECT
case b.jorn_ccod when 2 then 
	cast(REPLACE(secc_tdesc, ' - - (V)', '') as int) 
else 
	cast(REPLACE(secc_tdesc, ' - - (D)', '') as int) 
end
as orden,
	isnull(b.secc_ccod, 0) AS secc_ccod_paso,
	a.asig_ccod,
	a.asig_tdesc,
	c.ssec_ncorr,
	'Editar' AS subsecciones,
	b.*
FROM
	asignaturas a,
	secciones b,
	sub_secciones c
WHERE
	a.asig_ccod = b.asig_ccod
AND b.secc_ccod = c.secc_ccod
AND CAST (b.jorn_ccod AS VARCHAR) IN ('2')
AND b.sede_ccod = 1
AND CAST (b.asig_ccod AS VARCHAR) = 'MAGTS013'
AND b.peri_ccod = 240
AND c.tsse_ccod = 1
AND CAST (b.carr_ccod AS VARCHAR) = '500'
AND secc_finicio_sec IS NOT NULL
AND secc_ftermino_sec IS NOT NULL
ORDER BY
orden ASC







select * from secciones where secc_ccod = 64563





select * from SUB_SECCIONES where ssec_ncorr = 62910



BEGIN TRANSACTION
delete from SUB_SECCIONES where ssec_ncorr = 62910

COMMIT

-- ---------------------------------

select * from SECCIONES where secc_ccod = 64622;

-- ---------------------------------

BEGIN TRANSACTION

delete from SECCIONES where secc_ccod = 64622;


delete from SECCIONES

where secc_ccod in (
64642,
64651,
64652,
64653,
64654,
64655,
64656,
64657,
64643,
64644,
64645,
64646,
64647,
64648,
64649,
64650
);
COMMIT



-- ------------------------------
BEGIN TRANSACTION
delete from SUB_SECCIONES

where ssec_ncorr in (
63034,
63043,
63044,
63045,
63046,
63047,
63048,
63049,
63035,
63036,
63037,
63038,
63039,
63040,
63041,
63042

);

-- --------------------------

delete from SUB_SECCIONES
where secc_ccod in (
64642,
64651,
64652,
64653,
64654,
64655,
64656,
64657,
64643,
64644,
64645,
64646,
64647,
64648,
64649,
64650
);



-- -----------------------------------------------------------------------------------------------------------

select * 
from secciones 
where cast(asig_ccod as varchar) = 'MAGTS013' 
	and cast(sede_ccod as varchar) = '1' 
	and cast(peri_ccod as varchar)= 240 
	and cast(carr_ccod as varchar) = '500' 
	and secc_ccod not in (0) 


select * from SUB_SECCIONES where secc_ccod = 64660

select * from SECCIONES where peri_ccod = 240 and cast(carr_ccod as varchar) = '500' 

-- ------------------------------------


*
delete from SUB_SECCIONES where secc_ccod = 64660

delete from SECCIONES where secc_ccod = 64563


-- ------------------------------------

ALTER FUNCTION PROX_SECC_TDESC (@p_carr_ccod  varchar(3), @p_asig_ccod varchar(10), @p_peri_ccod numeric, @p_sede_ccod numeric, @p_jorn_ccod numeric) 



select protic.prox_secc_tdesc('500', 'MAGTS013', 240, 1, 2)

select protic.prox_secc_tdesc('500', 'MAGTS013', 240, 1, 2)

select protic.prox_secc_tdesc('500', 'MAGTS013', 240, 1, 2)


-- ---------------------------------------
@p_carr_ccod = '500'


-- -----------
@v_carr_tsigla	= 'MFIA'
@b_listo 				= 0
@i 							= 1


select isnull(carr_tsigla,'-')  from carreras where cast(carr_ccod as varchar)= '500'

select  '-'  from carreras where cast(carr_ccod as varchar)= '500'

-- ---------------------------------------------------------------------------------------
@v_cuenta_secciones= 

select  count(*) 
		from secciones
		where sede_ccod = 1
		  and cast(carr_ccod as varchar)= '500'
		  and peri_ccod = 240
		  and cast(asig_ccod as varchar)= 'MAGTS013'
		  and jorn_ccod = 2
		  and secc_tdesc like cast(1 as varchar) + ' - ' + ' - ' '%'


-- -------------------------------------------------------------


SELECT
	mall_ccod,
	rtrim(
		ltrim(
			CAST (
				mall_nota_presentacion AS DECIMAL (3, 1)
			)
		)
	) AS mall_nota_presentacion,
	rtrim(
		ltrim(
			CAST (
				mall_porcentaje_presentacion AS DECIMAL (3, 1)
			)
		)
	) AS mall_porcentaje_presentacion,
	rtrim(
		ltrim(
			CAST (
				mall_nevaluacion_minima AS DECIMAL (3, 1)
			)
		)
	) AS mall_nevaluacion_minima,
	rtrim(
		ltrim(
			CAST (
				mall_porcentaje_asistencia AS DECIMAL (3, 1)
			)
		)
	) AS mall_porcentaje_asistencia,
	rtrim(
		ltrim(
			CAST (
				mall_nota_eximicion AS DECIMAL (3, 1)
			)
		)
	) AS mall_nota_eximicion,
	rtrim(
		ltrim(
			CAST (
				mall_min_examen AS DECIMAL (3, 1)
			)
		)
	) AS mall_min_examen
FROM
	malla_curricular
WHERE
	CAST (mall_ccod AS VARCHAR) = '14278'



-- ----------------------------------------------------------------

select * from PERSONAS where pers_tape_paterno like '%araya%'

select * from sis_usuarios where pers_ncorr = 156955



select * from estados_boletas



select * from BOLETAS where mcaj_ncorr = 22650

select * from BOLETAS where pers_ncorr = 156955




select * from CAJEROS where pers_ncorr = 156955


select * from MOVIMIENTOS_CAJAS where pers_ncorr = 156955

-- -----------------------------------------------------------

select * from personas where pers_nrut = 11667970


select * from CAJEROS 











































