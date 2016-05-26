


update top(2) solicitud_seguro_escolaridad 
set    pers_ncorr_contratante = 273667 
where  pers_ncorr_contratante = 273668 

/* Affected rows: 1  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,031 sec. */



update top(30) DETALLE_INGRESOS_HISTORIAL 
set    pers_ncorr_codeudor_origen = 273667 
where  pers_ncorr_codeudor_origen = 273668 

/* Affected rows: 29  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 3,697 sec. */



update top(13) DETALLE_INGRESOS 
set    pers_ncorr_codeudor = 273667 
where  pers_ncorr_codeudor = 273668 

/* Affected rows: 24  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,405 sec. */



update top(11) SIM_DETALLES_REPACTACION 
set    pers_ncorr_codeudor = 273667 
where  pers_ncorr_codeudor = 273668 

/* Affected rows: 10  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,125 sec. */




update top(2) SIM_FORMA_REPACTACIONES 
set    pers_ncorr_codeudor = 273667 
where  pers_ncorr_codeudor = 273668 

/* Affected rows: 1  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,031 sec. */



update top(3) BOLETAS 
set    pers_ncorr_aval = 273667 
where  pers_ncorr_aval = 273668 

/* Affected rows: 2  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,062 sec. */



update top(4) CODEUDOR_POSTULACION 
set    pers_ncorr = 273667 
where  pers_ncorr = 273668 

/* Affected rows: 3  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,000 sec. */



delete top(2) from direcciones 
where  pers_ncorr = 273668 

/* Affected rows: 1  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,000 sec. */



delete top(2) from DIRECCIONES_PUBLICA 
where  pers_ncorr = 273668 

/* Affected rows: 1  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,016 sec. */



delete top(2) from PERSONAS 
where  pers_ncorr = 273668 

/* Affected rows: 1  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,562 sec. */


delete top(2) from PERSONAS_POSTULANTE 
where  pers_ncorr = 273668 

/* Affected rows: 1  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,015 sec. */
-- Fin actualización pers_ncorr 



update top(3) traspasos_cajas_softland 
set    pers_nrut = 8946677, 
       pers_xdv = 6 
where  pers_nrut = 8946777 

/* Affected rows: 2  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 3,370 sec. */







 



















