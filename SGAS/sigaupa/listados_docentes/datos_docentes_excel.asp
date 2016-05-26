<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: LISTADOS DOCENTES
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 28/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=
'LINEA				          : 173
'********************************************************************
Response.AddHeader "Content-Disposition", "attachment;filename=listado_de_profesores.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 4500000
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
peri_ccod=request.QueryString("peri_ccod")
tcar_ccod=request.QueryString("tcar_ccod")
tido_ccod=request.QueryString("tido_ccod")
'jorn_ccod=request.QueryString("jorn_ccod")

'------------------------------------------------------------------------------------


'--------------------------------listado general de docentes (datos reales)--------------------------------



'peri_ccod="&peri_ccod&"
'tcar_ccod=1
'tido_ccod=1
'tcar_tdesc=conexion.ConsultaUno("select tcar_tdesc from tipos_carrera where tcar_ccod="&tcar_ccod&"")
'tido_tdesc=conexion.ConsultaUno("select tido_tdesc from tipos_docente where tido_ccod="&tido_ccod&"")
ano=conexion.ConsultaUno("select anos_ccod from periodos_academicos where peri_ccod="&peri_ccod&"")


'peri_ccod=negocio.obtenerPeriodoAcademico("PLANIFICACIÓN")

'response.Write(peri_ccod)
'response.End()


 set f_docentes = new CFormulario
 f_docentes.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes.Inicializar conexion
 'response.End()
profesores= "select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,"& vbCrLf &_
			"(select sexo_tdesc from sexos where sexo_ccod=aa.sexo_ccod)as sexo,"& vbCrLf &_
			"protic.trunc(pers_fnacimiento)fnacimiento,"& vbCrLf &_
			"(select pais_tdesc from paises where pais_ccod=aa.pais_ccod)as nacionalidad,"& vbCrLf &_
			"(select top 1 ((datepart(yyyy,getdate())+1)-isnull(prof_ingreso_uas,0))from profesores where pers_ncorr=aa.pers_ncorr)as numero_de_años_en_la_institucion,"& vbCrLf &_
			"isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,1,"&peri_ccod&")),'')as Unidad_academica,"& vbCrLf &_
			"(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,1,"&peri_ccod&"))as sss)aaaa)  as region_unidad_academica, "& vbCrLf &_
			"   isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,2,"&peri_ccod&")),'')as Segunda_Unidad_academica"& vbCrLf &_
			",(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,2,"&peri_ccod&"))as sss)aaaa) as region_segunda_academica," & vbCrLf &_
			"isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,3,"&peri_ccod&")),'')as Tercera_Unidad_academica"& vbCrLf &_
			",(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,3,"&peri_ccod&"))as sss)aaaa) as region_tercera_academica,"& vbCrLf &_ 
			" isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,4,"&peri_ccod&")),'')as Cuarta_Unidad_academica"& vbCrLf &_
			",(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,4,"&peri_ccod&"))as sss)aaaa) as region_cuarta_academica,"& vbCrLf &_ 
			" isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,5,"&peri_ccod&")),'')as Quinta_Unidad_academica"& vbCrLf &_
			",(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,5,"&peri_ccod&"))as sss)aaaa) as region_quinta_academica," & vbCrLf &_
			"isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,6,"&peri_ccod&")),'')as Sexta_Unidad_academica"& vbCrLf &_
			",(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,6,"&peri_ccod&"))as sss)aaaa) as region_sexta_academica, "& vbCrLf &_
			"(select  protic.obtener_grado_docente_completados(aa.pers_ncorr,'D'))as titulo_grado_obtenido,"& vbCrLf &_
			"(select case when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='DOCTORADO'then 1 when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='MAGISTER'then 2"& vbCrLf &_
			"when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='MAESTRIA'then 2"& vbCrLf &_
			"when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='PROFESIONAL'then 4 when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='LICENCIADO'then 5"& vbCrLf &_
			"when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='TECNICO'then 6 end)as nivel_fotmacion_Academica_academico,"& vbCrLf &_
			"(select  protic.obtener_grado_docente_completados(aa.pers_ncorr,'I'))as institucion_grado,"& vbCrLf &_
			" (select  protic.obtener_grado_docente_completados(aa.pers_ncorr,'P'))as pais_en_que_lo_obtuvo,"& vbCrLf &_
			"protic.trunc((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'F')))as fecha_que_lo_obtuvo"& vbCrLf &_
			",isnull((select protic.obtener_horas_academicas_x_contrato(aa.pers_ncorr,2,"&peri_ccod&")),0)as horas_academicas_indefinido"& vbCrLf &_
			",isnull((select protic.obtener_horas_academicas_x_contrato(aa.pers_ncorr,3,"&peri_ccod&")),0)as horas_academicas_plazo"& vbCrLf &_
			",isnull((select protic.obtener_horas_academicas_x_contrato(aa.pers_ncorr,1,"&peri_ccod&")),0)as horas_academicas_honorarios"& vbCrLf &_
			",isnull((select protic.obtener_horas_administrativas(aa.pers_ncorr,2,"&peri_ccod&")),0)as horas_administrativas_indefinido"& vbCrLf &_
			" ,isnull((select protic.obtener_horas_administrativas(aa.pers_ncorr,3,"&peri_ccod&")),0)as horas_administrativas_Planta_fijo"& vbCrLf &_
			",isnull((select protic.obtener_horas_administrativas(aa.pers_ncorr,1,"&peri_ccod&")),0)as horas_administrativas_Planta_honorario"& vbCrLf &_
"from  personas aa "& vbCrLf &_
"where aa.pers_ncorr in ( "& vbCrLf &_
						" select distinct a.pers_ncorr"& vbCrLf &_
						"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f,contratos_docentes_upa g,anexos h,detalle_anexos i,personas j"& vbCrLf &_
						"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
						"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
						"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
						"and a.tpro_ccod='1'"& vbCrLf &_
						"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
						"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
						"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
						"and a.pers_ncorr=g.pers_ncorr"& vbCrLf &_
						"and g.cdoc_ncorr=h.cdoc_ncorr"& vbCrLf &_
						"and h.anex_ncorr=i.anex_ncorr"& vbCrLf &_
						"and i.secc_ccod=d.secc_ccod"& vbCrLf &_
						"and a.pers_ncorr=j.pers_ncorr"& vbCrLf &_
						"and tcar_ccod=1"& vbCrLf &_
						"and d.sede_ccod <>7"& vbCrLf &_
						"and tido_ccod=1)"& vbCrLf &_
"or aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
			"from profesores a, anos_tipo_docente f,carreras_docente g"& vbCrLf &_
			"where  a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
			"and a.PERS_NCORR=g.PERS_NCORR"& vbCrLf &_
			"and g.PERI_CCOD="&peri_ccod&""& vbCrLf &_
			"and tido_ccod=2)"& vbCrLf &_
"or aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f,contratos_docentes_upa g,anexos h,detalle_anexos i,personas j"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and d.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&ano&")"& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and a.pers_ncorr=g.pers_ncorr"& vbCrLf &_
"and g.cdoc_ncorr=h.cdoc_ncorr"& vbCrLf &_
"and h.anex_ncorr=i.anex_ncorr"& vbCrLf &_
"and i.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.pers_ncorr=j.pers_ncorr"& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and aa.pers_nrut not in (6379490,7186515) "& vbCrLf &_
"order by pers_tape_paterno "


'***************************************************************************
'####################		MODIFICADO POR MRIFFO	########################

'profesores="select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre, "& vbCrLf &_
'			"(select sexo_tdesc from sexos where sexo_ccod=aa.sexo_ccod)as sexo,protic.trunc(pers_fnacimiento)fnacimiento, "& vbCrLf &_
'			"(select pais_tdesc from paises where pais_ccod=aa.pais_ccod)as nacionalidad, "& vbCrLf &_
'			"(select top 1 ((datepart(yyyy,getdate())+1)-isnull(prof_ingreso_uas,0))from profesores where pers_ncorr=aa.pers_ncorr)as numero_de_años_en_la_institucion, "& vbCrLf &_
'			"isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,1,"&peri_ccod&")),'')as Unidad_academica, "& vbCrLf &_
'			"(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,1,"&peri_ccod&"))as sss)aaaa)  as region_unidad_academica,  "& vbCrLf &_
'			"isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,2,"&peri_ccod&")),'')as Segunda_Unidad_academica "& vbCrLf &_
'			",(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,2,"&peri_ccod&"))as sss)aaaa) as region_segunda_academica, "& vbCrLf &_
'			"isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,3,"&peri_ccod&")),'')as Tercera_Unidad_academica "& vbCrLf &_
'			",(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,3,"&peri_ccod&"))as sss)aaaa) as region_tercera_academica, "& vbCrLf &_
'			"isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,4,"&peri_ccod&")),'')as Cuarta_Unidad_academica "& vbCrLf &_
'			",(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,4,"&peri_ccod&"))as sss)aaaa) as region_cuarta_academica, "& vbCrLf &_
'			"isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,5,"&peri_ccod&")),'')as Quinta_Unidad_academica "& vbCrLf &_
'			",(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,5,"&peri_ccod&"))as sss)aaaa) as region_quinta_academica, "& vbCrLf &_
'			"isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,6,"&peri_ccod&")),'')as Sexta_Unidad_academica "& vbCrLf &_
'			",(select  case when sss is null then ' ' else '15' end  from (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr,6,"&peri_ccod&"))as sss)aaaa) as region_sexta_academica,  "& vbCrLf &_
'			"(select  protic.obtener_grado_docente_completados(aa.pers_ncorr,'D'))as titulo_grado_obtenido, "& vbCrLf &_
'			"(select case when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='DOCTORADO'then 1 when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='MAGISTER'then 2 "& vbCrLf &_
'			"when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='MAESTRIA'then 2 "& vbCrLf &_
'			"when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='PROFESIONAL'then 4 when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='LICENCIADO'then 5 "& vbCrLf &_
'			"when protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')='TECNICO'then 6 end)as nivel_fotmacion_Academica_academico, "& vbCrLf &_
'			"(select  protic.obtener_grado_docente_completados(aa.pers_ncorr,'I'))as institucion_grado, "& vbCrLf &_
'			"(select  protic.obtener_grado_docente_completados(aa.pers_ncorr,'P'))as pais_en_que_lo_obtuvo, "& vbCrLf &_
'			"protic.trunc((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'F')))as fecha_que_lo_obtuvo "& vbCrLf &_
'			",isnull((select protic.obtener_horas_academicas_x_contrato(aa.pers_ncorr,2,"&peri_ccod&")),0)as horas_academicas_indefinido "& vbCrLf &_
'			",isnull((select protic.obtener_horas_academicas_x_contrato(aa.pers_ncorr,3,"&peri_ccod&")),0)as horas_academicas_plazo "& vbCrLf &_
'			",isnull((select protic.obtener_horas_academicas_x_contrato(aa.pers_ncorr,1,"&peri_ccod&")),0)as horas_academicas_honorarios "& vbCrLf &_
'			",isnull((select protic.obtener_horas_administrativas(aa.pers_ncorr,2,"&peri_ccod&")),0)as horas_administrativas_indefinido "& vbCrLf &_
'			",isnull((select protic.obtener_horas_administrativas(aa.pers_ncorr,3,"&peri_ccod&")),0)as horas_administrativas_Planta_fijo "& vbCrLf &_
'			",isnull((select protic.obtener_horas_administrativas(aa.pers_ncorr,1,"&peri_ccod&")),0)as horas_administrativas_Planta_honorario "& vbCrLf &_
'			"from  personas aa "& vbCrLf &_
'			"where aa.pers_ncorr in ( "& vbCrLf &_
'			"    select distinct a.pers_ncorr "& vbCrLf &_
'			"    from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f,contratos_docentes_upa g,anexos h,detalle_anexos i,personas j "& vbCrLf &_
'			"    where a.pers_ncorr=b.pers_ncorr  "& vbCrLf &_
'			"    and b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
'			"    and c.secc_ccod=d.secc_ccod "& vbCrLf &_
'			"    and a.tpro_ccod='1' "& vbCrLf &_
'			"    and a.pers_ncorr*=f.pers_ncorr "& vbCrLf &_
'			"    and d.peri_ccod="&peri_ccod&" "& vbCrLf &_
'			"    and d.carr_ccod=e.carr_ccod "& vbCrLf &_
'			"    and a.pers_ncorr=g.pers_ncorr "& vbCrLf &_
'			"    and g.cdoc_ncorr=h.cdoc_ncorr "& vbCrLf &_
'			"    and h.anex_ncorr=i.anex_ncorr "& vbCrLf &_
'			"    and i.secc_ccod=d.secc_ccod "& vbCrLf &_
'			"    and a.pers_ncorr=j.pers_ncorr "& vbCrLf &_
'			"    and tcar_ccod=1 "& vbCrLf &_
'			"    and d.sede_ccod  not in (3,5,6,7) "& vbCrLf &_
'			"    and isnull(f.tido_ccod,1)=1 "& vbCrLf &_
'			"    and g.tpro_ccod=1 "& vbCrLf &_
'			"union "& vbCrLf &_
'			"    select distinct a.pers_ncorr "& vbCrLf &_
'			"    from profesores a, anos_tipo_docente f,carreras_docente g "& vbCrLf &_
'			"    where  a.pers_ncorr=f.pers_ncorr "& vbCrLf &_
'			"    and a.PERS_NCORR=g.PERS_NCORR "& vbCrLf &_
'			"    and g.PERI_CCOD="&peri_ccod&" "& vbCrLf &_
'			"    and f.tido_ccod=2 "& vbCrLf &_
'			"union "& vbCrLf &_
'			"    select distinct a.pers_ncorr "& vbCrLf &_
'			"    from profesores a, contratos_docentes_upa g,anos_tipo_docente f, anexos h "& vbCrLf &_
'			"    where a.pers_ncorr=g.pers_ncorr   "& vbCrLf &_
'			"    and g.ano_contrato="&ano&" "& vbCrLf &_
'			"    and a.pers_ncorr=f.pers_ncorr "& vbCrLf &_
'			"    and f.tido_ccod=3 "& vbCrLf &_
'			"    and g.tpro_ccod=1 "& vbCrLf &_
'			"	and g.cdoc_ncorr=h.cdoc_ncorr "& vbCrLf &_
'    		"	and h.eane_ccod=1  "& vbCrLf &_
'			") "& vbCrLf &_
'			"and aa.pers_nrut not in (6379490,7186515) "& vbCrLf &_
'			"order by pers_tape_paterno  "

'----------------------------------------------------------------------------------------------------------Nueva consulta 2008
profesores = " select pers_nrut,                                                                                                                             " & vbCrLf &_
"       pers_xdv,                                                                                                                                            " & vbCrLf &_
"       pers_tape_paterno,                                                                                                                                   " & vbCrLf &_
"       pers_tape_materno,                                                                                                                                   " & vbCrLf &_
"       pers_tnombre,                                                                                                                                        " & vbCrLf &_
"       (select sexo_tdesc                                                                                                                                   " & vbCrLf &_
"        from   sexos                                                                                                                                        " & vbCrLf &_
"        where  sexo_ccod = aa.sexo_ccod)                                                                          as sexo,                                  " & vbCrLf &_
"       protic.trunc(pers_fnacimiento)                                                                             fnacimiento,                              " & vbCrLf &_
"       (select pais_tdesc                                                                                                                                   " & vbCrLf &_
"        from   paises                                                                                                                                       " & vbCrLf &_
"        where  pais_ccod = aa.pais_ccod)                                                                          as nacionalidad,                          " & vbCrLf &_
"       (select top 1 ( ( datepart(yyyy, getdate()) + 1 ) - isnull(prof_ingreso_uas, 0) )                                                                    " & vbCrLf &_
"        from   profesores                                                                                                                                   " & vbCrLf &_
"        where  pers_ncorr = aa.pers_ncorr)                                                                        as numero_de_años_en_la_institucion,      " & vbCrLf &_
"       isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 1, "&peri_ccod&")), '')                 as unidad_academica,                      " & vbCrLf &_
"       (select case                                                                                                                                         " & vbCrLf &_
"                 when sss is null then ' '                                                                                                                  " & vbCrLf &_
"                 else '15'                                                                                                                                  " & vbCrLf &_
"               end                                                                                                                                          " & vbCrLf &_
"        from   (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 1, "&peri_ccod&"))as sss)aaaa) as region_unidad_academica,               " & vbCrLf &_
"       isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 2, "&peri_ccod&")), '')                 as segunda_unidad_academica,              " & vbCrLf &_
"       (select case                                                                                                                                         " & vbCrLf &_
"                 when sss is null then ' '                                                                                                                  " & vbCrLf &_
"                 else '15'                                                                                                                                  " & vbCrLf &_
"               end                                                                                                                                          " & vbCrLf &_
"        from   (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 2, "&peri_ccod&"))as sss)aaaa) as region_segunda_academica,              " & vbCrLf &_
"       isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 3, "&peri_ccod&")), '')                 as tercera_unidad_academica,              " & vbCrLf &_
"       (select case                                                                                                                                         " & vbCrLf &_
"                 when sss is null then ' '                                                                                                                  " & vbCrLf &_
"                 else '15'                                                                                                                                  " & vbCrLf &_
"               end                                                                                                                                          " & vbCrLf &_
"        from   (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 3, "&peri_ccod&"))as sss)aaaa) as region_tercera_academica,              " & vbCrLf &_
"       isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 4, "&peri_ccod&")), '')                 as cuarta_unidad_academica,               " & vbCrLf &_
"       (select case                                                                                                                                         " & vbCrLf &_
"                 when sss is null then ' '                                                                                                                  " & vbCrLf &_
"                 else '15'                                                                                                                                  " & vbCrLf &_
"               end                                                                                                                                          " & vbCrLf &_
"        from   (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 4, "&peri_ccod&"))as sss)aaaa) as region_cuarta_academica,               " & vbCrLf &_
"       isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 5, "&peri_ccod&")), '')                 as quinta_unidad_academica,               " & vbCrLf &_
"       (select case                                                                                                                                         " & vbCrLf &_
"                 when sss is null then ' '                                                                                                                  " & vbCrLf &_
"                 else '15'                                                                                                                                  " & vbCrLf &_
"               end                                                                                                                                          " & vbCrLf &_
"        from   (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 5, "&peri_ccod&"))as sss)aaaa) as region_quinta_academica,               " & vbCrLf &_
"       isnull((select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 6, "&peri_ccod&")), '')                 as sexta_unidad_academica,                " & vbCrLf &_
"       (select case                                                                                                                                         " & vbCrLf &_
"                 when sss is null then ' '                                                                                                                  " & vbCrLf &_
"                 else '15'                                                                                                                                  " & vbCrLf &_
"               end                                                                                                                                          " & vbCrLf &_
"        from   (select (select protic.obtener_carrera_con_mas_horas(aa.pers_ncorr, 6, "&peri_ccod&"))as sss)aaaa) as region_sexta_academica,                " & vbCrLf &_
"       (select protic.obtener_grado_docente_completados(aa.pers_ncorr, 'D'))                                      as titulo_grado_obtenido,                 " & vbCrLf &_
"       (select case                                                                                                                                         " & vbCrLf &_
"                 when protic.obtener_grado_docente_completados(aa.pers_ncorr, 'G') = 'DOCTORADO'then 1                                                      " & vbCrLf &_
"                 when protic.obtener_grado_docente_completados(aa.pers_ncorr, 'G') = 'MAGISTER'then 2                                                       " & vbCrLf &_
"                 when protic.obtener_grado_docente_completados(aa.pers_ncorr, 'G') = 'MAESTRIA'then 2                                                       " & vbCrLf &_
"                 when protic.obtener_grado_docente_completados(aa.pers_ncorr, 'G') = 'PROFESIONAL'then 4                                                    " & vbCrLf &_
"                 when protic.obtener_grado_docente_completados(aa.pers_ncorr, 'G') = 'LICENCIADO'then 5                                                     " & vbCrLf &_
"                 when protic.obtener_grado_docente_completados(aa.pers_ncorr, 'G') = 'TECNICO'then 6                                                        " & vbCrLf &_
"               end)                                                                                               as nivel_fotmacion_academica_academico,   " & vbCrLf &_
"       (select protic.obtener_grado_docente_completados(aa.pers_ncorr, 'I'))                                      as institucion_grado,                     " & vbCrLf &_
"       (select protic.obtener_grado_docente_completados(aa.pers_ncorr, 'P'))                                      as pais_en_que_lo_obtuvo,                 " & vbCrLf &_
"       protic.trunc((select protic.obtener_grado_docente_completados(aa.pers_ncorr, 'F')))                        as fecha_que_lo_obtuvo,                   " & vbCrLf &_
"       isnull((select protic.obtener_horas_academicas_x_contrato(aa.pers_ncorr, 2, "&peri_ccod&")), 0)            as horas_academicas_indefinido,           " & vbCrLf &_
"       isnull((select protic.obtener_horas_academicas_x_contrato(aa.pers_ncorr, 3, "&peri_ccod&")), 0)            as horas_academicas_plazo,                " & vbCrLf &_
"       isnull((select protic.obtener_horas_academicas_x_contrato(aa.pers_ncorr, 1, "&peri_ccod&")), 0)            as horas_academicas_honorarios,           " & vbCrLf &_
"       isnull((select protic.obtener_horas_administrativas(aa.pers_ncorr, 2, "&peri_ccod&")), 0)                  as horas_administrativas_indefinido,      " & vbCrLf &_
"       isnull((select protic.obtener_horas_administrativas(aa.pers_ncorr, 3, "&peri_ccod&")), 0)                  as horas_administrativas_planta_fijo,     " & vbCrLf &_
"       isnull((select protic.obtener_horas_administrativas(aa.pers_ncorr, 1, "&peri_ccod&")), 0)                  as horas_administrativas_planta_honorario " & vbCrLf &_
"from   personas as aa                                                                                                                                       " & vbCrLf &_
"where  aa.pers_ncorr in (select distinct a.pers_ncorr                                                                                                       " & vbCrLf &_
"                         from   profesores as a                                                                                                             " & vbCrLf &_
"                                inner join bloques_profesores as b                                                                                          " & vbCrLf &_
"                                        on a.pers_ncorr = b.pers_ncorr                                                                                      " & vbCrLf &_
"                                inner join bloques_horarios as c                                                                                            " & vbCrLf &_
"                                        on b.bloq_ccod = c.bloq_ccod                                                                                        " & vbCrLf &_
"                                inner join secciones as d                                                                                                   " & vbCrLf &_
"                                        on c.secc_ccod = d.secc_ccod                                                                                        " & vbCrLf &_
"                                           and d.peri_ccod = "&peri_ccod&"                                                                                  " & vbCrLf &_
"                                           and d.sede_ccod not in ( 3, 5, 6, 7 )                                                                            " & vbCrLf &_
"                                inner join carreras as e                                                                                                    " & vbCrLf &_
"                                        on d.carr_ccod = e.carr_ccod                                                                                        " & vbCrLf &_
"                                left outer join anos_tipo_docente as f                                                                                      " & vbCrLf &_
"                                             on a.pers_ncorr = f.pers_ncorr                                                                                 " & vbCrLf &_
"                                                and isnull(f.tido_ccod, 1) = 1                                                                              " & vbCrLf &_
"                                inner join contratos_docentes_upa as g                                                                                      " & vbCrLf &_
"                                        on a.pers_ncorr = g.pers_ncorr                                                                                      " & vbCrLf &_
"                                           and g.tpro_ccod = 1                                                                                              " & vbCrLf &_
"                                inner join anexos as h                                                                                                      " & vbCrLf &_
"                                        on g.cdoc_ncorr = h.cdoc_ncorr                                                                                      " & vbCrLf &_
"                                inner join detalle_anexos as i                                                                                              " & vbCrLf &_
"                                        on h.anex_ncorr = i.anex_ncorr                                                                                      " & vbCrLf &_
"                                           and d.secc_ccod = i.secc_ccod                                                                                    " & vbCrLf &_
"                                inner join personas as j                                                                                                    " & vbCrLf &_
"                                        on a.pers_ncorr = j.pers_ncorr                                                                                      " & vbCrLf &_
"                         where  a.tpro_ccod = '1'                                                                                                           " & vbCrLf &_
"                                and tcar_ccod = 1                                                                                                           " & vbCrLf &_
"                         union                                                                                                                              " & vbCrLf &_
"                         select distinct a.pers_ncorr                                                                                                       " & vbCrLf &_
"                         from   profesores as a                                                                                                             " & vbCrLf &_
"                                inner join anos_tipo_docente as f                                                                                           " & vbCrLf &_
"                                        on a.pers_ncorr = f.pers_ncorr                                                                                      " & vbCrLf &_
"                                           and f.tido_ccod = 2                                                                                              " & vbCrLf &_
"                                inner join carreras_docente as g                                                                                            " & vbCrLf &_
"                                        on a.pers_ncorr = g.pers_ncorr                                                                                      " & vbCrLf &_
"                                           and g.peri_ccod = "&peri_ccod&"                                                                                  " & vbCrLf &_
"                         union                                                                                                                              " & vbCrLf &_
"                         select distinct a.pers_ncorr                                                                                                       " & vbCrLf &_
"                         from   profesores as a                                                                                                             " & vbCrLf &_
"                                inner join contratos_docentes_upa as g                                                                                      " & vbCrLf &_
"                                        on a.pers_ncorr = g.pers_ncorr                                                                                      " & vbCrLf &_
"                                           and g.ano_contrato = "&ano&"                                                                                     " & vbCrLf &_
"                                           and g.tpro_ccod = 1                                                                                              " & vbCrLf &_
"                                inner join anos_tipo_docente as f                                                                                           " & vbCrLf &_
"                                        on a.pers_ncorr = f.pers_ncorr                                                                                      " & vbCrLf &_
"                                           and f.tido_ccod = 3                                                                                              " & vbCrLf &_
"                                inner join anexos as h                                                                                                      " & vbCrLf &_
"                                        on g.cdoc_ncorr = h.cdoc_ncorr                                                                                      " & vbCrLf &_
"                                           and h.eane_ccod = 1)                                                                                             " & vbCrLf &_
"       and aa.pers_nrut not in ( 6379490, 7186515 )                                                                                                         " & vbCrLf &_
"order  by pers_tape_paterno                                                                                                                                 " 
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008

'response.Write("<pre>"&profesores&"</pre>")
'response.end()
f_docentes.Consultar profesores
f_docentes.siguiente
'response.end()




%>

<html>
<head>
<title>Listado de Docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
<style type="text/css">
<!--
.estilo1 {
font-family: Arial, Helvetica, sans-serif;
font-size: 12px;
color: #003366;
}
.estilo2 {
color: #990000;
font-weight: bold;
}
.estilo3 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #ffffff; }

.estilo4 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #000000; }
-->
</style>

</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
 <tr> 
    <td colspan="2"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Docentes </font></div>
	  <div align="right"></div></td>
  </tr>
 
</table>

<table width="100%" border="1">
    
	<tr borderColor="#999999" bgColor="#c4d7ff">
		<td width="19%"><FONT color="#333333">
	  <div align="center"><strong>Rut</strong></div></font></td>
		<td width="4%"><FONT color="#333333">
	  <div align="center"><strong>Dv</strong></div></font></td>
		<td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Apellido Paterno</strong></div></font></td>
<td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Apellido Materno</strong></div></font></td>
	  <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Nombre</strong></div></font></td>
	  <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Sexo</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Fecha de Nacimiento</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Nacionalidad</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Número de años en la Institución</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Principal Unidad Acádemica donde se desempeña</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Región de la Unidad Acádemica donde se desempeña</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Segunda Unidad Acádemica donde se desempeña</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Región de la Unidad Acádemica donde se desempeña</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Tercera Unidad Acádemica donde se desempeña</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Región de la Unidad Acádemica donde se desempeña</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Cuarta Unidad Acádemica donde se desempeña</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Región de la Unidad Acádemica donde se desempeña</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Quinta Unidad Acádemica donde se desempeña</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Región de la Unidad Acádemica donde se desempeña</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Sexta Unidad Acádemica donde se desempeña</strong></div></font></td>
	  <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Región de la Unidad Acádemica donde se desempeña</strong></div></font></td>
	
	  <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Nivel de Formación Acádemica del Docente</strong></div></font></td>
	  
	   <td width="77%"><FONT color="#333333">
	    <div align="center"><strong>Nombre del Grado</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>País donde lo Obtuvo </strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Fecha en que lo Obtuvo</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>Institución en que lo Obtuvo</strong></div></font></td>
	  <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>N° de Horas Académicas con Contrato de Planta</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>N° de Horas Académicas Plazo Fijo</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>N° de Horas Académicas a Honorarios</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>N° de Horas Administrativas con Contrato de Planta</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>N° de Horas Administrativas Plazo Fijo</strong></div></font></td>
	   <td width="77%"><FONT color="#333333">
	  <div align="center"><strong>N° de Horas Administrativas a Honorarios</strong></div></font></td>
	</tr>
	
	<%while f_docentes.siguiente %>
	<tr bgcolor="#FFFFFF">
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("pers_nrut")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("pers_xdv")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("pers_tape_paterno")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("pers_tape_materno")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("pers_tnombre")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("sexo")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("fnacimiento")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("nacionalidad")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("numero_de_años_en_la_institucion")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("Unidad_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("region_unidad_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("Segunda_Unidad_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("region_segunda_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("Tercera_Unidad_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("region_tercera_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("Cuarta_Unidad_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("region_cuarta_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("Quinta_Unidad_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("region_quinta_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("Sexta_Unidad_academica")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("region_sexta_academica")%></td>
	
		
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("nivel_fotmacion_Academica_academico")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("titulo_grado_obtenido")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("pais_en_que_lo_obtuvo")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("fecha_que_lo_obtuvo")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("institucion_grado")%></td>
		
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("horas_academicas_indefinido")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("horas_academicas_plazo")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("horas_academicas_honorarios")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("horas_administrativas_indefinido")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("horas_administrativas_Planta_fijo")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("horas_administrativas_Planta_honorario")%></td>
		
	</tr>
	<%wend%>
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>