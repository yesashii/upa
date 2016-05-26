


SELECT
	COUNT (srol_ncorr) AS conteo
FROM
	sis_roles_usuarios
WHERE
	pers_ncorr = (
		SELECT
			pers_ncorr
		FROM
			personas
		WHERE
			pers_nrut = '15350600'
	)
AND srol_ncorr = 343333