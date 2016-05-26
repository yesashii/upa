<%
'Response.Write("Archivo funciones --> Incluido")
Function ObtenerConsultaIngreso(p_facultad,str_select,grupo)

if  p_facultad <> 0   then
sql_ingreso = "Select  cod_grupo,cod_orden,descripcion_grupo,descripcion, "& vbCrLf &_
		" "&str_select&" "& vbCrLf &_
		" from ( "& vbCrLf &_
			" select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion, "& vbCrLf &_
			" sum(isnull(AREA_TECNICA_MELIPILLA,0)) as E1,sum(isnull(CENTRO_DE_COMPETITIVIDAD,0)) as E2, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_AGRONOMIA,0)) as E3,sum(isnull(ESCUELA_DE_COMUNICACION_MULTIMEDIA,0)) as E4, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_CONTADOR_AUDITOR,0)) as E5,sum(isnull(ESCUELA_DE_DIRECCION_Y_PRODUCCION_DE_EVENTOS,0)) as E6, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_DISEÑO,0)) as E7,sum(isnull(ESCUELA_DE_DISEÑO_DE_VESTUARIO_Y_TEXTIL,0)) as E8, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_DISEÑO_GRAFICO,0)) as E9,sum(isnull(ESCUELA_DE_EDUCACION_BASICA,0)) as E10, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_EDUCACION_FISICA,0)) as E11,sum(isnull(ESCUELA_DE_EDUCACION_PARVULARIA,0)) as E12, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_ENFERMERIA,0)) as E13,sum(isnull(ESCUELA_DE_FOTOGRAFIA,0)) as E14, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_GESTION_SOCIAL_E_INTEGRACION_DEL_ADULTO_MAYOR,0)) as E15,sum(isnull(ESCUELA_DE_INGENIERIA_COMERCIAL,0)) as E16, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_AERONAUTICA,0)) as E17,sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_DE_EMPRESAS_DE_SERVICIOS,0)) as E18, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_TURISTICA,0)) as E19,sum(isnull(ESCUELA_DE_INGENIERIA_EN_INFORMATICA,0)) as E20, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_MUSICA_Y_TECNOLOGIA,0)) as E21,sum(isnull(ESCUELA_DE_NUTRICION_Y_DIETETICA,0)) as E22, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_PEDAGOGIA_EN_HISTORIA,0)) as E23,sum(isnull(ESCUELA_DE_PEDAGOGIA_EN_LENGUAJE,0)) as E24, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_PERIODISMO,0)) as E25,sum(isnull(ESCUELA_DE_PREVENCION_DE_RIESGOS,0)) as E26, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_PSICOLOGIA,0)) as E27,sum(isnull(ESCUELA_DE_PUBLICIDAD,0)) as E28, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_RELACIONES_PUBLICAS,0)) as E29,sum(isnull(ESCUELA_DE_TRABAJO_SOCIAL,0)) as E30, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_VETERINARIA,0)) as E31,sum(isnull(EXTENSION,0)) as E32, "& vbCrLf &_
			" sum(isnull(FACULTAD_DE_COMUNICACIONES,0)) as E33,sum(isnull(FACULTAD_DE_NEGOCIOS_Y_MARKETING,0)) as E34, "& vbCrLf &_
			" sum(isnull(LICENCIATURAS,0)) as E35,sum(isnull(PROYECTOS,0)) as E36 "& vbCrLf &_
			" from  ( "& vbCrLf &_
			 "   select cast(cod_dis as numeric) as codigo, "& vbCrLf &_
			 "   case escuela when 'AREA TECNICA MELIPILLA' then cast(sum(total) as numeric) end as 'AREA_TECNICA_MELIPILLA', "& vbCrLf &_
			 "   case escuela when 'CENTRO DE COMPETITIVIDAD' then cast(sum(total) as numeric) end as 'CENTRO_DE_COMPETITIVIDAD', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE AGRONOMIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_AGRONOMIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE COMUNICACIÓN MULTIMEDIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_COMUNICACION_MULTIMEDIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE CONTADOR AUDITOR' then cast(sum(total) as numeric) end as 'ESCUELA_DE_CONTADOR_AUDITOR', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE DIRECCION Y PRODUCCION DE EVENTOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DIRECCION_Y_PRODUCCION_DE_EVENTOS', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE DISEÑO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE DISEÑO DE VESTUARIO Y TEXTIL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO_DE_VESTUARIO_Y_TEXTIL', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE DISEÑO GRAFICO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO_GRAFICO', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE EDUCACION BASICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_BASICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE EDUCACION FISICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_FISICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE EDUCACION PARVULARIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_PARVULARIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE ENFERMERIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_ENFERMERIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE FOTOGRAFIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_FOTOGRAFIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE GESTION SOCIAL E INTEGRACION DEL ADULTO MAYOR' then cast(sum(total) as numeric) end as 'ESCUELA_DE_GESTION_SOCIAL_E_INTEGRACION_DEL_ADULTO_MAYOR', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE INGENIERIA COMERCIAL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_COMERCIAL', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE INGENIERIA EN GESTION AERONAUTICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_AERONAUTICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE INGENIERIA EN GESTION DE EMPRESAS DE SERVICIOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_DE_EMPRESAS_DE_SERVICIOS', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE INGENIERIA EN GESTION TURISTICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_TURISTICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE INGENIERIA EN INFORMATICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_INFORMATICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE MUSICA Y TECNOLOGIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_MUSICA_Y_TECNOLOGIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE NUTRICION Y DIETETICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_NUTRICION_Y_DIETETICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PEDAGOGIA EN HISTORIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PEDAGOGIA_EN_HISTORIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PEDAGOGIA EN LENGUAJE' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PEDAGOGIA_EN_LENGUAJE', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PERIODISMO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PERIODISMO', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PREVENCION DE RIESGOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PREVENCION_DE_RIESGOS', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PSICOLOGIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PSICOLOGIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PUBLICIDAD' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PUBLICIDAD', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE RELACIONES PUBLICAS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_RELACIONES_PUBLICAS', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE TRABAJO SOCIAL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_TRABAJO_SOCIAL', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE VETERINARIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_VETERINARIA', "& vbCrLf &_
			 "   case escuela when 'EXTENSION' then cast(sum(total) as numeric) end as 'EXTENSION', "& vbCrLf &_
			 "   case escuela when 'FACULTAD DE COMUNICACIONES' then cast(sum(total) as numeric) end as 'FACULTAD_DE_COMUNICACIONES', "& vbCrLf &_
			 "   case escuela when 'FACULTAD DE NEGOCIOS Y MARKETING' then cast(sum(total) as numeric) end as 'FACULTAD_DE_NEGOCIOS_Y_MARKETING', "& vbCrLf &_
			 "   case escuela when 'LICENCIATURAS' then cast(sum(total) as numeric) end as 'LICENCIATURAS', "& vbCrLf &_
			 "   case escuela when 'PROYECTOS' then cast(sum(total) as numeric) end as 'PROYECTOS' "& vbCrLf &_
			 "   from eru_estados_resultados_upa "& vbCrLf &_
			 "   group by cod_dis, escuela, facultad "& vbCrLf &_
			" ) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c "& vbCrLf &_
			" where matriz.codigo=b.cod_dis "& vbCrLf &_
			" and b.cod_grupo=c.cod_grupo "& vbCrLf &_
			"   and b.cod_grupo="&grupo&"  "& vbCrLf &_ 
			" group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion "& vbCrLf &_
		" ) as tabla_final "& vbCrLf &_
		" order by cod_grupo,cod_orden "

else

			sql_ingreso	=   " select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,   "& vbCrLf &_
							"	sum(isnull(F1,0)) as F1,sum(isnull(F2,0)) as F2,sum(isnull(F3,0)) as F3,sum(isnull(F4,0)) as F4,  "& vbCrLf &_
							"	sum(isnull(F5,0)) as F5,sum(isnull(F6,0)) as F6,sum(isnull(F7,0)) as F7,sum(isnull(F8,0)) as F8,  "& vbCrLf &_
							"	sum(isnull(F9,0)) as F9,sum(isnull(F10,0)) as F10,sum(isnull(F11,0)) as F11,  "& vbCrLf &_
							"	sum(isnull(F1,0)) + sum(isnull(F2,0)) + sum(isnull(F3,0)) + sum(isnull(F4,0))+sum(isnull(F5,0)) + sum(isnull(F6,0)) + sum(isnull(F7,0)) + sum(isnull(F8,0)) + sum(isnull(F9,0)) + sum(isnull(F10,0)) + sum(isnull(F11,0)) as total   "& vbCrLf &_
							"	from  (  "& vbCrLf &_
							"		select cast(cod_dis as numeric) as codigo,   "& vbCrLf &_
							"		case cod_facultad when 1 then cast(sum(total) as numeric) end as F1,  "& vbCrLf &_
							"		case cod_facultad when 2 then cast(sum(total) as numeric) end as F2,  "& vbCrLf &_
							"		case cod_facultad when 3 then cast(sum(total) as numeric) end as F3,  "& vbCrLf &_
							"		case cod_facultad when 4 then cast(sum(total) as numeric) end as F4,  "& vbCrLf &_
							"		case cod_facultad when 5 then cast(sum(total) as numeric) end as F5,  "& vbCrLf &_
							"		case cod_facultad when 6 then cast(sum(total) as numeric) end as F6,  "& vbCrLf &_
							"		case cod_facultad when 7 then cast(sum(total) as numeric) end as F7,  "& vbCrLf &_
							"		case cod_facultad when 8 then cast(sum(total) as numeric) end as F8,  "& vbCrLf &_
							"		case cod_facultad when 9 then cast(sum(total) as numeric) end as F9,  "& vbCrLf &_
							"		case cod_facultad when 10 then cast(sum(total) as numeric) end as F10,  "& vbCrLf &_
							"		case cod_facultad when 11 then cast(sum(total) as numeric) end as F11  "& vbCrLf &_
							"		from eru_estados_resultados_upa a, eru_facultades_upa b  "& vbCrLf &_
							"		where a.facultad=b.facultad  "& vbCrLf &_
							"		group by cod_dis, cod_facultad  "& vbCrLf &_
							"	) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
							"	where matriz.codigo=b.cod_dis  "& vbCrLf &_
							"	and b.cod_grupo=c.cod_grupo   "& vbCrLf &_
							"   and b.cod_grupo="&grupo&"  "& vbCrLf &_
							"	group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion  "& vbCrLf &_
							"	order by b.cod_grupo,b.cod_orden "
							
end if							
		ObtenerConsultaIngreso=sql_ingreso				

end function


Function ObtenerConsultaTotal(p_facultad,str_select)

if p_facultad <>0 then

sql_totales	= " Select "&str_select&" "& vbCrLf &_
			" from ( select  "& vbCrLf &_
			" sum(isnull(AREA_TECNICA_MELIPILLA,0)) as E1,sum(isnull(CENTRO_DE_COMPETITIVIDAD,0)) as E2, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_AGRONOMIA,0)) as E3,sum(isnull(ESCUELA_DE_COMUNICACION_MULTIMEDIA,0)) as E4, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_CONTADOR_AUDITOR,0)) as E5,sum(isnull(ESCUELA_DE_DIRECCION_Y_PRODUCCION_DE_EVENTOS,0)) as E6, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_DISEÑO,0)) as E7,sum(isnull(ESCUELA_DE_DISEÑO_DE_VESTUARIO_Y_TEXTIL,0)) as E8, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_DISEÑO_GRAFICO,0)) as E9,sum(isnull(ESCUELA_DE_EDUCACION_BASICA,0)) as E10, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_EDUCACION_FISICA,0)) as E11,sum(isnull(ESCUELA_DE_EDUCACION_PARVULARIA,0)) as E12, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_ENFERMERIA,0)) as E13,sum(isnull(ESCUELA_DE_FOTOGRAFIA,0)) as E14, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_GESTION_SOCIAL_E_INTEGRACION_DEL_ADULTO_MAYOR,0)) as E15,sum(isnull(ESCUELA_DE_INGENIERIA_COMERCIAL,0)) as E16, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_AERONAUTICA,0)) as E17,sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_DE_EMPRESAS_DE_SERVICIOS,0)) as E18, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_INGENIERIA_EN_GESTION_TURISTICA,0)) as E19,sum(isnull(ESCUELA_DE_INGENIERIA_EN_INFORMATICA,0)) as E20, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_MUSICA_Y_TECNOLOGIA,0)) as E21,sum(isnull(ESCUELA_DE_NUTRICION_Y_DIETETICA,0)) as E22, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_PEDAGOGIA_EN_HISTORIA,0)) as E23,sum(isnull(ESCUELA_DE_PEDAGOGIA_EN_LENGUAJE,0)) as E24, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_PERIODISMO,0)) as E25,sum(isnull(ESCUELA_DE_PREVENCION_DE_RIESGOS,0)) as E26, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_PSICOLOGIA,0)) as E27,sum(isnull(ESCUELA_DE_PUBLICIDAD,0)) as E28, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_RELACIONES_PUBLICAS,0)) as E29,sum(isnull(ESCUELA_DE_TRABAJO_SOCIAL,0)) as E30, "& vbCrLf &_
			" sum(isnull(ESCUELA_DE_VETERINARIA,0)) as E31,sum(isnull(EXTENSION,0)) as E32, "& vbCrLf &_
			" sum(isnull(FACULTAD_DE_COMUNICACIONES,0)) as E33,sum(isnull(FACULTAD_DE_NEGOCIOS_Y_MARKETING,0)) as E34, "& vbCrLf &_
			" sum(isnull(LICENCIATURAS,0)) as E35,sum(isnull(PROYECTOS,0)) as E36 "& vbCrLf &_
			" from  ( "& vbCrLf &_
			 "   select cast(cod_dis as numeric) as codigo, "& vbCrLf &_
			 "   case escuela when 'AREA TECNICA MELIPILLA' then cast(sum(total) as numeric) end as 'AREA_TECNICA_MELIPILLA', "& vbCrLf &_
			 "   case escuela when 'CENTRO DE COMPETITIVIDAD' then cast(sum(total) as numeric) end as 'CENTRO_DE_COMPETITIVIDAD', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE AGRONOMIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_AGRONOMIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE COMUNICACIÓN MULTIMEDIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_COMUNICACION_MULTIMEDIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE CONTADOR AUDITOR' then cast(sum(total) as numeric) end as 'ESCUELA_DE_CONTADOR_AUDITOR', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE DIRECCION Y PRODUCCION DE EVENTOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DIRECCION_Y_PRODUCCION_DE_EVENTOS', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE DISEÑO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE DISEÑO DE VESTUARIO Y TEXTIL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO_DE_VESTUARIO_Y_TEXTIL', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE DISEÑO GRAFICO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_DISEÑO_GRAFICO', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE EDUCACION BASICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_BASICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE EDUCACION FISICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_FISICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE EDUCACION PARVULARIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_EDUCACION_PARVULARIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE ENFERMERIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_ENFERMERIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE FOTOGRAFIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_FOTOGRAFIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE GESTION SOCIAL E INTEGRACION DEL ADULTO MAYOR' then cast(sum(total) as numeric) end as 'ESCUELA_DE_GESTION_SOCIAL_E_INTEGRACION_DEL_ADULTO_MAYOR', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE INGENIERIA COMERCIAL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_COMERCIAL', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE INGENIERIA EN GESTION AERONAUTICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_AERONAUTICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE INGENIERIA EN GESTION DE EMPRESAS DE SERVICIOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_DE_EMPRESAS_DE_SERVICIOS', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE INGENIERIA EN GESTION TURISTICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_GESTION_TURISTICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE INGENIERIA EN INFORMATICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_INGENIERIA_EN_INFORMATICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE MUSICA Y TECNOLOGIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_MUSICA_Y_TECNOLOGIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE NUTRICION Y DIETETICA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_NUTRICION_Y_DIETETICA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PEDAGOGIA EN HISTORIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PEDAGOGIA_EN_HISTORIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PEDAGOGIA EN LENGUAJE' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PEDAGOGIA_EN_LENGUAJE', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PERIODISMO' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PERIODISMO', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PREVENCION DE RIESGOS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PREVENCION_DE_RIESGOS', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PSICOLOGIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PSICOLOGIA', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE PUBLICIDAD' then cast(sum(total) as numeric) end as 'ESCUELA_DE_PUBLICIDAD', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE RELACIONES PUBLICAS' then cast(sum(total) as numeric) end as 'ESCUELA_DE_RELACIONES_PUBLICAS', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE TRABAJO SOCIAL' then cast(sum(total) as numeric) end as 'ESCUELA_DE_TRABAJO_SOCIAL', "& vbCrLf &_
			 "   case escuela when 'ESCUELA DE VETERINARIA' then cast(sum(total) as numeric) end as 'ESCUELA_DE_VETERINARIA', "& vbCrLf &_
			 "   case escuela when 'EXTENSION' then cast(sum(total) as numeric) end as 'EXTENSION', "& vbCrLf &_
			 "   case escuela when 'FACULTAD DE COMUNICACIONES' then cast(sum(total) as numeric) end as 'FACULTAD_DE_COMUNICACIONES', "& vbCrLf &_
			 "   case escuela when 'FACULTAD DE NEGOCIOS Y MARKETING' then cast(sum(total) as numeric) end as 'FACULTAD_DE_NEGOCIOS_Y_MARKETING', "& vbCrLf &_
			 "   case escuela when 'LICENCIATURAS' then cast(sum(total) as numeric) end as 'LICENCIATURAS', "& vbCrLf &_
			 "   case escuela when 'PROYECTOS' then cast(sum(total) as numeric) end as 'PROYECTOS' "& vbCrLf &_
			 "   from eru_estados_resultados_upa "& vbCrLf &_
			 "   group by cod_dis, escuela, facultad "& vbCrLf &_
			" ) as matriz,eru_codigos_estados_upa b, eru_grupos_estados c "& vbCrLf &_
			" where matriz.codigo=b.cod_dis "& vbCrLf &_
			" and b.cod_grupo=c.cod_grupo "& vbCrLf &_
			" and b.cod_grupo=1 "& vbCrLf &_
			"	) as tabla_final "

else
	sql_totales	=   " select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,   "& vbCrLf &_
					"	sum(isnull(F1,0)) as F1,sum(isnull(F2,0)) as F2,sum(isnull(F3,0)) as F3,sum(isnull(F4,0)) as F4,  "& vbCrLf &_
					"	sum(isnull(F5,0)) as F5,sum(isnull(F6,0)) as F6,sum(isnull(F7,0)) as F7,sum(isnull(F8,0)) as F8,  "& vbCrLf &_
					"	sum(isnull(F9,0)) as F9,sum(isnull(F10,0)) as F10,sum(isnull(F11,0)) as F11,  "& vbCrLf &_
					"	sum(isnull(F1,0)) + sum(isnull(F2,0)) + sum(isnull(F3,0)) + sum(isnull(F4,0))+sum(isnull(F5,0)) + sum(isnull(F6,0)) + sum(isnull(F7,0)) + sum(isnull(F8,0)) + sum(isnull(F9,0)) + sum(isnull(F10,0)) + sum(isnull(F11,0)) as total   "& vbCrLf &_
					"	from  (  "& vbCrLf &_
					"		select cast(cod_dis as numeric) as codigo,   "& vbCrLf &_
					"		case cod_facultad when 1 then cast(sum(total) as numeric) end as F1,  "& vbCrLf &_
					"		case cod_facultad when 2 then cast(sum(total) as numeric) end as F2,  "& vbCrLf &_
					"		case cod_facultad when 3 then cast(sum(total) as numeric) end as F3,  "& vbCrLf &_
					"		case cod_facultad when 4 then cast(sum(total) as numeric) end as F4,  "& vbCrLf &_
					"		case cod_facultad when 5 then cast(sum(total) as numeric) end as F5,  "& vbCrLf &_
					"		case cod_facultad when 6 then cast(sum(total) as numeric) end as F6,  "& vbCrLf &_
					"		case cod_facultad when 7 then cast(sum(total) as numeric) end as F7,  "& vbCrLf &_
					"		case cod_facultad when 8 then cast(sum(total) as numeric) end as F8,  "& vbCrLf &_
					"		case cod_facultad when 9 then cast(sum(total) as numeric) end as F9,  "& vbCrLf &_
					"		case cod_facultad when 10 then cast(sum(total) as numeric) end as F10,  "& vbCrLf &_
					"		case cod_facultad when 11 then cast(sum(total) as numeric) end as F11  "& vbCrLf &_
					"		from eru_estados_resultados_upa a, eru_facultades_upa b  "& vbCrLf &_
					"		where a.facultad=b.facultad  "& vbCrLf &_
					"		group by cod_dis, cod_facultad  "& vbCrLf &_
					"	) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
					"	where matriz.codigo=b.cod_dis  "& vbCrLf &_
					"	and b.cod_grupo=c.cod_grupo   "& vbCrLf &_
					"   and b.cod_grupo=3  "& vbCrLf &_
					"	group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion  "& vbCrLf &_
					"	order by b.cod_grupo,b.cod_orden "

end if
					
'response.Write("<pre>"&sql_facultad&"</pre>")
		ObtenerConsultaTotal=sql_totales				
end function

%>