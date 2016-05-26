--listado de totales por sede

select sum(isnull(BAQUEDANO,0))*-1 as BAQUEDANO,sum(isnull(CONCEPCION,0))*-1 as EONCEPCION,sum(isnull(LASCONDES,0))*-1 as LASCONDES,sum(isnull(MELIPILLA,0))*-1 as MELIPILLA,   
  (sum(isnull(BAQUEDANO,0)) + sum(isnull(CONCEPCION,0)) + sum(isnull(LASCONDES,0)) + sum(isnull(MELIPILLA,0)))*-1 as total    
	from  (   
		select cast(cod_dis as numeric) as codigo,    
		case sede when 'CAMPUS BAQUEDANO' then cast(sum(total) as numeric) end as BAQUEDANO,   
		case sede when 'OFICINA CONCEPCION' then cast(sum(total) as numeric) end as EONCEPCION,   
		case sede when 'SEDE Las EONDES' then cast(sum(total) as numeric) end as LASCONDES,   
		case sede when 'SEDE MELIPILLA' then cast(sum(total) as numeric) end as MELIPILLA   
		from eru_estados_resultados_upa   
		group by cod_dis, sede   
	) as matriz, eru_codigos_estados_upa b   
	where matriz.codigo=b.cod_dis   
	and cod_grupo=1
                            
-- agrupadas por tipos de codigos y su orden respectivo
select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion, 
sum(isnull(BAQUEDANO,0)) as BAQUEDANO,sum(isnull(CONCEPCION,0)) as EONCEPCION,sum(isnull(LASCONDES,0)) as LASCONDES,sum(isnull(MELIPILLA,0)) as MELIPILLA,
sum(isnull(BAQUEDANO,0)) + sum(isnull(CONCEPCION,0)) + sum(isnull(LASCONDES,0)) + sum(isnull(MELIPILLA,0)) as total 
from  (
    select cast(cod_dis as numeric) as codigo, 
    case sede when 'CAMPUS BAQUEDANO' then cast(sum(total) as numeric) end as BAQUEDANO,
    case sede when 'OFICINA CONCEPCION' then cast(sum(total) as numeric) end as EONCEPCION,
    case sede when 'SEDE Las EONDES' then cast(sum(total) as numeric) end as LASCONDES,
    case sede when 'SEDE MELIPILLA' then cast(sum(total) as numeric) end as MELIPILLA
    from eru_estados_resultados_upa
    group by cod_dis, sede
) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c
where matriz.codigo=b.cod_dis
and b.cod_grupo=c.cod_grupo 
group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion
order by b.cod_grupo,b.cod_orden
/********************************************************************************************/

---- LISTADO POR FACULTADES ----
-- lista totales ingreso por facultad
select sum(isnull(F1,0)) as F1,sum(isnull(F2,0)) as F2,sum(isnull(F3,0)) as F3,sum(isnull(F4,0)) as F4,
sum(isnull(F5,0)) as F5,sum(isnull(F6,0)) as F6,sum(isnull(F7,0)) as F7,sum(isnull(F8,0)) as F8,
sum(isnull(F9,0)) as F9,sum(isnull(F10,0)) as F10,sum(isnull(F11,0)) as F11,
sum(isnull(F1,0)) + sum(isnull(F2,0)) + sum(isnull(F3,0)) + sum(isnull(F4,0))+sum(isnull(F5,0)) + sum(isnull(F6,0)) + sum(isnull(F7,0)) + sum(isnull(F8,0)) + sum(isnull(F9,0)) + sum(isnull(F10,0)) + sum(isnull(F11,0)) as total 
from  (
    select cast(cod_dis as numeric) as codigo, 
    case cod_facultad when 1 then cast(sum(total) as numeric) end as F1,
    case cod_facultad when 2 then cast(sum(total) as numeric) end as F2,
    case cod_facultad when 3 then cast(sum(total) as numeric) end as F3,
    case cod_facultad when 4 then cast(sum(total) as numeric) end as F4,
    case cod_facultad when 5 then cast(sum(total) as numeric) end as F5,
    case cod_facultad when 6 then cast(sum(total) as numeric) end as F6,
    case cod_facultad when 7 then cast(sum(total) as numeric) end as F7,
    case cod_facultad when 8 then cast(sum(total) as numeric) end as F8,
    case cod_facultad when 9 then cast(sum(total) as numeric) end as F9,
    case cod_facultad when 10 then cast(sum(total) as numeric) end as F10,
    case cod_facultad when 11 then cast(sum(total) as numeric) end as F11
    from eru_estados_resultados_upa a, eru_facultades_upa b
    where a.facultad=b.facultad
    group by cod_dis, cod_facultad
) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c
where matriz.codigo=b.cod_dis
and b.cod_grupo=c.cod_grupo 
and b.cod_grupo=1


-- agrupadas por tipos de codigos y su orden respectivo
select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion, 
sum(isnull(F1,0)) as F1,sum(isnull(F2,0)) as F2,sum(isnull(F3,0)) as F3,sum(isnull(F4,0)) as F4,
sum(isnull(F5,0)) as F5,sum(isnull(F6,0)) as F6,sum(isnull(F7,0)) as F7,sum(isnull(F8,0)) as F8,
sum(isnull(F9,0)) as F9,sum(isnull(F10,0)) as F10,sum(isnull(F11,0)) as F11,
sum(isnull(F1,0)) + sum(isnull(F2,0)) + sum(isnull(F3,0)) + sum(isnull(F4,0))+sum(isnull(F5,0)) + sum(isnull(F6,0)) + sum(isnull(F7,0)) + sum(isnull(F8,0)) + sum(isnull(F9,0)) + sum(isnull(F10,0)) + sum(isnull(F11,0)) as total 
from  (
    select cast(cod_dis as numeric) as codigo, 
    case cod_facultad when 1 then cast(sum(total) as numeric) end as F1,
    case cod_facultad when 2 then cast(sum(total) as numeric) end as F2,
    case cod_facultad when 3 then cast(sum(total) as numeric) end as F3,
    case cod_facultad when 4 then cast(sum(total) as numeric) end as F4,
    case cod_facultad when 5 then cast(sum(total) as numeric) end as F5,
    case cod_facultad when 6 then cast(sum(total) as numeric) end as F6,
    case cod_facultad when 7 then cast(sum(total) as numeric) end as F7,
    case cod_facultad when 8 then cast(sum(total) as numeric) end as F8,
    case cod_facultad when 9 then cast(sum(total) as numeric) end as F9,
    case cod_facultad when 10 then cast(sum(total) as numeric) end as F10,
    case cod_facultad when 11 then cast(sum(total) as numeric) end as F11
    from eru_estados_resultados_upa a, eru_facultades_upa b
    where a.facultad=b.facultad
    group by cod_dis, cod_facultad
) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c
where matriz.codigo=b.cod_dis
and b.cod_grupo=c.cod_grupo 
group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion
order by b.cod_grupo,b.cod_orden


/****************************************************/



---- listado de escuelas por facultad ----
------------------------------------------

select 
sum(isnull(AREA_TECNICA_MELIPILLA,0)) as E1,sum(isnull(CENTRO_DE_COMPETITIVIDAD,0)) as E2,
sum(isnull(ESCUELA_DE_AGRONOMIA,0)) as E3,sum(isnull(ESCUELA_DE_COMUNICACION_MULTIMEDIA,0)) as E4,
sum(isnull(ESCUELA_DE_CONTADOR_AUDITOR,0)) as E5,sum(isnull(ESCUELA_DE_DIRECCION_Y_PRODUCCION_DE_EVENTOS,0)) as E6,
sum(isnull(ESCUELA_DE_DISEÑO,0)) as E7,sum(isnull(ESCUELA_DE_DISEÑO_DE_VESTUARIO_Y_TEXTIL,0)) as E8,
sum(isnull(ESCUELA_DE_DISEÑO_GRAFICO,0)) as E9,sum(isnull(ESCUELA_DE_EDUCACION_BASICA,0)) as E10,
sum(isnull(ESCUELA_DE_EDUCACION_FISICA,0)) as E11,sum(isnull(ESCUELA_DE_EDUCACION_PARVULARIA,0)) as E12,
sum(isnull(ESCUELA_DE_ENFERMERIA,0)) as E13,sum(isnull(ESCUELA_DE_FOTOGRAFIA,0)) as E14,
sum(isnull(ESCUELA_DE_GESTION_SOCIAL_E_INTEGRACION_DEL_ADULTO_MAYOR,0)) as E15,sum(isnull(ESCUELA_DE_INGENIERIA_COMERCIAL,0)) as E16,
sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_AERONAUTICA,0)) as E17,sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_DE_EMPRESAS_DE_SERVICIOS,0)) as E18,
sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_TURISTICA,0)) as E19,sum(isnull(ESCUELA_DE_INGENIERIA_EN_INFORMATICA,0)) as E20,
sum(isnull(ESCUELA_DE_MUSICA_Y_TECNOLOGIA,0)) as E21,sum(isnull(ESCUELA_DE_NUTRICION_Y_DIETETICA,0)) as E22,
sum(isnull(ESCUELA_DE_PEDAGOGIA_EN_HISTORIA,0)) as E23,sum(isnull(ESCUELA_DE_PEDAGOGIA_EN_LENGUAJE,0)) as E24,
sum(isnull(ESCUELA_DE_PERIODISMO,0)) as E25,sum(isnull(ESCUELA_DE_PREVENCION_DE_RIESGOS,0)) as E26,
sum(isnull(ESCUELA_DE_PSICOLOGIA,0)) as E27,sum(isnull(ESCUELA_DE_PUBLICIDAD,0)) as E28,
sum(isnull(ESCUELA_DE_RELACIONES_PUBLICAS,0)) as E29,sum(isnull(ESCUELA_DE_TRABAJO_SOCIAL,0)) as E30,
sum(isnull(ESCUELA_DE_VETERINARIA,0)) as E31,sum(isnull(EXTENSION,0)) as E32,
sum(isnull(FACULTAD_DE_COMUNICACIONES,0)) as E33,sum(isnull(FACULTAD_DE_NEGOCIOS_Y_MARKETING,0)) as E34,
sum(isnull(LICENCIATURAS,0)) as E35,sum(isnull(PROYECTOS,0)) as E36
from  (
    select cast(cod_dis as numeric) as codigo,
    case escuela when 'AREA TECNICA MELIPILLA' then cast(sum(total) as numeric) end as 'AREA_TECNICA_MELIPILLA',
    case escuela when 'CENTRO DE COMPETITIVIDAD' then cast(sum(total) as numeric) end as 'CENTRO_DE_COMPETITIVIDAD',
    case escuela when 'ESCUELA DE AGRONOMIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_AGRONOMIA',
    case escuela when 'ESCUELA DE COMUNICACI? MULTIMEDIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_COMUNICACION_MULTIMEDIA',
    case escuela when 'ESCUELA DE CONTADOR AUDITOR' then cast(sum(total) as numeric) end as 'ESCUELA_DE_CONTADOR_AUDITOR',
    case escuela when 'ESCUELA DE DIRECCION Y PRODUCCION DE EVENTOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DIRECCION_Y_PRODUCCION_DE_EVENTOS',
    case escuela when 'ESCUELA DE DISEÑO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO',
    case escuela when 'ESCUELA DE DISEÑO DE VESTUARIO Y TEXTIL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO_DE_VESTUARIO_Y_TEXTIL',
    case escuela when 'ESCUELA DE DISEÑO GRAFICO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO_GRAFICO',
    case escuela when 'ESCUELA DE EDUCACION BASICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_BASICA',
    case escuela when 'ESCUELA DE EDUCACION FISICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_FISICA',
    case escuela when 'ESCUELA DE EDUCACION PARVULARIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_PARVULARIA',
    case escuela when 'ESCUELA DE ENFERMERIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_ENFERMERIA',
    case escuela when 'ESCUELA DE FOTOGRAFIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_FOTOGRAFIA',
    case escuela when 'ESCUELA DE GESTION SOCIAL E INTEGRACION DEL ADULTO MAYOR' then cast(sum(total) as numeric) end as 'ESCUELA_DE_GESTION_SOCIAL_E_INTEGRACION_DEL_ADULTO_MAYOR',
    case escuela when 'ESCUELA DE INGENIERIA COMERCIAL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_COMERCIAL',
    case escuela when 'ESCUELA DE INGENIERIA EN GESTION AERONAUTICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_AERONAUTICA',
    case escuela when 'ESCUELA DE INGENIERIA EN GESTION DE EMPRESAS DE SERVICIOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_DE_EMPRESAS_DE_SERVICIOS',
    case escuela when 'ESCUELA DE INGENIERIA EN GESTION TURISTICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_TURISTICA',
    case escuela when 'ESCUELA DE INGENIERIA EN INFORMATICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_INFORMATICA',
    case escuela when 'ESCUELA DE MUSICA Y TECNOLOGIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_MUSICA_Y_TECNOLOGIA',
    case escuela when 'ESCUELA DE NUTRICION Y DIETETICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_NUTRICION_Y_DIETETICA',
    case escuela when 'ESCUELA DE PEDAGOGIA EN HISTORIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PEDAGOGIA_EN_HISTORIA',
    case escuela when 'ESCUELA DE PEDAGOGIA EN LENGUAJE' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PEDAGOGIA_EN_LENGUAJE',
    case escuela when 'ESCUELA DE PERIODISMO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PERIODISMO',
    case escuela when 'ESCUELA DE PREVENCION DE RIESGOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PREVENCION_DE_RIESGOS',
    case escuela when 'ESCUELA DE PSICOLOGIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PSICOLOGIA',
    case escuela when 'ESCUELA DE PUBLICIDAD' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PUBLICIDAD',
    case escuela when 'ESCUELA DE RELACIONES PUBLICAS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_RELACIONES_PUBLICAS',
    case escuela when 'ESCUELA DE TRABAJO SOCIAL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_TRABAJO_SOCIAL',
    case escuela when 'ESCUELA DE VETERINARIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_VETERINARIA',
    case escuela when 'EXTENSION' then cast(sum(total) as numeric) end as 'EXTENSION',
    case escuela when 'FACULTAD DE COMUNICACIONES' then cast(sum(total) as numeric) end as 'FACULTAD_DE_COMUNICACIONES',
    case escuela when 'FACULTAD DE NEGOCIOS Y MARKETING' then cast(sum(total) as numeric) end as 'FACULTAD_DE_NEGOCIOS_Y_MARKETING',
    case escuela when 'LICENCIATURAS' then cast(sum(total) as numeric) end as 'LICENCIATURAS',
    case escuela when 'PROYECTOS' then cast(sum(total) as numeric) end as 'PROYECTOS'
    from eru_estados_resultados_upa
    group by cod_dis, escuela, facultad
) as matriz,eru_codigos_estados_upa b, eru_grupos_estados c
where matriz.codigo=b.cod_dis
and b.cod_grupo=c.cod_grupo 
and b.cod_grupo=1


/*******************************************/

-- agrupadas por tipos de codigos y su orden respectivo
select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,
sum(isnull(AREA_TECNICA_MELIPILLA,0)) as E1,sum(isnull(CENTRO_DE_COMPETITIVIDAD,0)) as E2,
sum(isnull(ESCUELA_DE_AGRONOMIA,0)) as E3,sum(isnull(ESCUELA_DE_COMUNICACION_MULTIMEDIA,0)) as E4,
sum(isnull(ESCUELA_DE_CONTADOR_AUDITOR,0)) as E5,sum(isnull(ESCUELA_DE_DIRECCION_Y_PRODUCCION_DE_EVENTOS,0)) as E6,
sum(isnull(ESCUELA_DE_DISEÑO,0)) as E7,sum(isnull(ESCUELA_DE_DISEÑO_DE_VESTUARIO_Y_TEXTIL,0)) as E8,
sum(isnull(ESCUELA_DE_DISEÑO_GRAFICO,0)) as E9,sum(isnull(ESCUELA_DE_EDUCACION_BASICA,0)) as E10,
sum(isnull(ESCUELA_DE_EDUCACION_FISICA,0)) as E11,sum(isnull(ESCUELA_DE_EDUCACION_PARVULARIA,0)) as E12,
sum(isnull(ESCUELA_DE_ENFERMERIA,0)) as E13,sum(isnull(ESCUELA_DE_FOTOGRAFIA,0)) as E14,
sum(isnull(ESCUELA_DE_GESTION_SOCIAL_E_INTEGRACION_DEL_ADULTO_MAYOR,0)) as E15,sum(isnull(ESCUELA_DE_INGENIERIA_COMERCIAL,0)) as E16,
sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_AERONAUTICA,0)) as E17,sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_DE_EMPRESAS_DE_SERVICIOS,0)) as E18,
sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_TURISTICA,0)) as E19,sum(isnull(ESCUELA_DE_INGENIERIA_EN_INFORMATICA,0)) as E20,
sum(isnull(ESCUELA_DE_MUSICA_Y_TECNOLOGIA,0)) as E21,sum(isnull(ESCUELA_DE_NUTRICION_Y_DIETETICA,0)) as E22,
sum(isnull(ESCUELA_DE_PEDAGOGIA_EN_HISTORIA,0)) as E23,sum(isnull(ESCUELA_DE_PEDAGOGIA_EN_LENGUAJE,0)) as E24,
sum(isnull(ESCUELA_DE_PERIODISMO,0)) as E25,sum(isnull(ESCUELA_DE_PREVENCION_DE_RIESGOS,0)) as E26,
sum(isnull(ESCUELA_DE_PSICOLOGIA,0)) as E27,sum(isnull(ESCUELA_DE_PUBLICIDAD,0)) as E28,
sum(isnull(ESCUELA_DE_RELACIONES_PUBLICAS,0)) as E29,sum(isnull(ESCUELA_DE_TRABAJO_SOCIAL,0)) as E30,
sum(isnull(ESCUELA_DE_VETERINARIA,0)) as E31,sum(isnull(EXTENSION,0)) as E32,
sum(isnull(FACULTAD_DE_COMUNICACIONES,0)) as E33,sum(isnull(FACULTAD_DE_NEGOCIOS_Y_MARKETING,0)) as E34,
sum(isnull(LICENCIATURAS,0)) as E35,sum(isnull(PROYECTOS,0)) as E36
from  (
    select cast(cod_dis as numeric) as codigo,
    case escuela when 'AREA TECNICA MELIPILLA' then cast(sum(total) as numeric) end as 'AREA_TECNICA_MELIPILLA',
    case escuela when 'CENTRO DE COMPETITIVIDAD' then cast(sum(total) as numeric) end as 'CENTRO_DE_COMPETITIVIDAD',
    case escuela when 'ESCUELA DE AGRONOMIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_AGRONOMIA',
    case escuela when 'ESCUELA DE COMUNICACI? MULTIMEDIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_COMUNICACION_MULTIMEDIA',
    case escuela when 'ESCUELA DE CONTADOR AUDITOR' then cast(sum(total) as numeric) end as 'ESCUELA_DE_CONTADOR_AUDITOR',
    case escuela when 'ESCUELA DE DIRECCION Y PRODUCCION DE EVENTOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DIRECCION_Y_PRODUCCION_DE_EVENTOS',
    case escuela when 'ESCUELA DE DISEÑO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO',
    case escuela when 'ESCUELA DE DISEÑO DE VESTUARIO Y TEXTIL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO_DE_VESTUARIO_Y_TEXTIL',
    case escuela when 'ESCUELA DE DISEÑO GRAFICO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO_GRAFICO',
    case escuela when 'ESCUELA DE EDUCACION BASICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_BASICA',
    case escuela when 'ESCUELA DE EDUCACION FISICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_FISICA',
    case escuela when 'ESCUELA DE EDUCACION PARVULARIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_PARVULARIA',
    case escuela when 'ESCUELA DE ENFERMERIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_ENFERMERIA',
    case escuela when 'ESCUELA DE FOTOGRAFIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_FOTOGRAFIA',
    case escuela when 'ESCUELA DE GESTION SOCIAL E INTEGRACION DEL ADULTO MAYOR' then cast(sum(total) as numeric) end as 'ESCUELA_DE_GESTION_SOCIAL_E_INTEGRACION_DEL_ADULTO_MAYOR',
    case escuela when 'ESCUELA DE INGENIERIA COMERCIAL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_COMERCIAL',
    case escuela when 'ESCUELA DE INGENIERIA EN GESTION AERONAUTICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_AERONAUTICA',
    case escuela when 'ESCUELA DE INGENIERIA EN GESTION DE EMPRESAS DE SERVICIOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_DE_EMPRESAS_DE_SERVICIOS',
    case escuela when 'ESCUELA DE INGENIERIA EN GESTION TURISTICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_TURISTICA',
    case escuela when 'ESCUELA DE INGENIERIA EN INFORMATICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_INFORMATICA',
    case escuela when 'ESCUELA DE MUSICA Y TECNOLOGIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_MUSICA_Y_TECNOLOGIA',
    case escuela when 'ESCUELA DE NUTRICION Y DIETETICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_NUTRICION_Y_DIETETICA',
    case escuela when 'ESCUELA DE PEDAGOGIA EN HISTORIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PEDAGOGIA_EN_HISTORIA',
    case escuela when 'ESCUELA DE PEDAGOGIA EN LENGUAJE' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PEDAGOGIA_EN_LENGUAJE',
    case escuela when 'ESCUELA DE PERIODISMO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PERIODISMO',
    case escuela when 'ESCUELA DE PREVENCION DE RIESGOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PREVENCION_DE_RIESGOS',
    case escuela when 'ESCUELA DE PSICOLOGIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PSICOLOGIA',
    case escuela when 'ESCUELA DE PUBLICIDAD' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PUBLICIDAD',
    case escuela when 'ESCUELA DE RELACIONES PUBLICAS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_RELACIONES_PUBLICAS',
    case escuela when 'ESCUELA DE TRABAJO SOCIAL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_TRABAJO_SOCIAL',
    case escuela when 'ESCUELA DE VETERINARIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_VETERINARIA',
    case escuela when 'EXTENSION' then cast(sum(total) as numeric) end as 'EXTENSION',
    case escuela when 'FACULTAD DE COMUNICACIONES' then cast(sum(total) as numeric) end as 'FACULTAD_DE_COMUNICACIONES',
    case escuela when 'FACULTAD DE NEGOCIOS Y MARKETING' then cast(sum(total) as numeric) end as 'FACULTAD_DE_NEGOCIOS_Y_MARKETING',
    case escuela when 'LICENCIATURAS' then cast(sum(total) as numeric) end as 'LICENCIATURAS',
    case escuela when 'PROYECTOS' then cast(sum(total) as numeric) end as 'PROYECTOS'
    from eru_estados_resultados_upa
    group by cod_dis, escuela, facultad
) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c
where matriz.codigo=b.cod_dis
and b.cod_grupo=c.cod_grupo 
group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion
order by b.cod_grupo,b.cod_orden