	SELECT
		CAST (a.ofer_ncorr AS VARCHAR) AS ofer_ncorr,
		carrera AS carrera_ofertada,
		orden
	FROM
		ofertas_academicas a,
		sedes b,
		especialidades c,
		carreras d,
		jornadas e,
		orden_carreras_admision f
	WHERE
		a.sede_ccod = b.sede_ccod
	AND a.espe_ccod = c.espe_ccod
	AND c.carr_ccod = d.carr_ccod
	AND a.jorn_ccod = e.jorn_ccod
	AND a.post_bnuevo = 'S'
	AND a.sede_ccod = f.sede_ccod
	AND a.jorn_ccod = f.jorn_ccod
	AND f.carr_ccod = d.carr_ccod
	AND ofer_bactiva = 'S'
and f.sede_ccod = 1
and f.carrera like '%en Marketing y Negocios Internacionales%'
	AND d.tcar_ccod = 2
