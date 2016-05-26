SELECT
	'' AS ofer_ncorr,
	'Selecciona el Postgrado a Postular' AS carrera_ofertada,
	0 AS orden
UNION
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
	AND CAST (a.peri_ccod AS VARCHAR) = '238'
	AND a.post_bnuevo = 'S'
	AND a.sede_ccod = f.sede_ccod
	AND a.jorn_ccod = f.jorn_ccod
	AND f.carr_ccod = d.carr_ccod
	AND ofer_bactiva = 'S'
	AND ofer_bpublica = 'S'
	AND d.tcar_ccod = 2
	AND NOT EXISTS (
		SELECT
			1
		FROM
			detalle_postulantes bb
		WHERE
			bb.ofer_ncorr = a.ofer_ncorr
		AND CAST (bb.post_ncorr AS VARCHAR) = 'V'
	)
	UNION
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
		AND CAST (a.peri_ccod AS VARCHAR) = '238'
		AND a.post_bnuevo = 'S'
		AND a.sede_ccod = f.sede_ccod
		AND a.jorn_ccod = f.jorn_ccod
		AND f.carr_ccod = d.carr_ccod
		AND ofer_bactiva = 'S'
		AND d.tcar_ccod = 1
		AND d.carr_ccod = '600'
		AND NOT EXISTS (
			SELECT
				1
			FROM
				detalle_postulantes bb
			WHERE
				bb.ofer_ncorr = a.ofer_ncorr
			AND CAST (bb.post_ncorr AS VARCHAR) = 'V'
		)
		ORDER BY
			orden