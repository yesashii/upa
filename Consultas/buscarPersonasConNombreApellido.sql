-- Con el nombre y apellido, se encuentra a la persona.

SELECT
	*
FROM
	personas
WHERE
	PERSONAS.PERS_TNOMBRE LIKE '%francisco%'
AND PERSONAS.PERS_TAPE_PATERNO LIKE '%olave%'