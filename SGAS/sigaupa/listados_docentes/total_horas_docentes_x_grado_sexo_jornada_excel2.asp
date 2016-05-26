<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'Response.AddHeader "Content-Disposition", "attachment;filename=cantidad_hora_de_docente_por_sede_y_grado.xls"
'Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 4500000
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
peri_ccod=request.QueryString("peri_ccod")
tido_ccod=request.QueryString("tido_ccod")
sede_ccod=request.QueryString("sede_ccod")
tcar_ccod=request.QueryString("tcar_ccod")

'------------------------------------------------------------------------------------


'--------------------------------listado general de docentes (datos reales)--------------------------------


'response.write("<br/>peri_ccod="&peri_ccod&"<br/>")
'response.write("<br/>tido_ccod="&tido_ccod&"<br/>")
'response.write("<br/>sede_ccod="&sede_ccod&"<br/>")
'response.write("<br/>tcar_ccod="&tcar_ccod&"<br/>")
'peri_ccod=210
'tcar_ccod=1
'tido_ccod=3
'sede_ccod=2
 if sede_ccod <> "0" then
	

  	filtro=filtro&"and d.sede_ccod='" &sede_ccod&"'"
  					
end if

 if tido_ccod <> "0" then

filtro2=filtro2&"and f.tido_ccod="&tido_ccod&""

end if


 if tido_ccod <> "0" then

filtro3=filtro3&"and tcar_ccod="&tcar_ccod&""

end if


tcar_tdesc=conexion.ConsultaUno("select tcar_tdesc from tipos_carrera where tcar_ccod="&tcar_ccod&"")
tido_tdesc=conexion.ConsultaUno("select tido_tdesc from tipos_docente where tido_ccod="&tido_ccod&"")
sede=conexion.ConsultaUno("select sede_tdesc from sedes where sede_ccod="&sede_ccod&"")
periodo_academico=conexion.ConsultaUno("select lower(peri_tdesc) from periodos_academicos where peri_ccod="&peri_ccod&"")
'response.End()
ano=conexion.ConsultaUno("select anos_ccod from periodos_academicos where peri_ccod="&peri_ccod&"")
'response.write(sede)
'response.End()
 set f_docentes_doctorado_1_19 = new CFormulario
 f_docentes_doctorado_1_19.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_doctorado_1_19.Inicializar conexion
 'response.End()
 
profesores_doctores_1_19= "select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_
"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_1_a_19_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_
"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_
"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_
"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as cantidad_profesores_1_a_19_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_
"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_
"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_
"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as cantidad_profesores_1_a_19_FEMENINO,"& vbCrLf &_
"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_
"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_
"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_1_a_19_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_
"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_
"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_
"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl"


 
response.Write("<pre>"&profesores_doctores_1_19&"</pre>")
response.end()
f_docentes_doctorado_1_19.Consultar profesores_doctores_1_19
f_docentes_doctorado_1_19.siguiente
'response.end()


set f_docentes_doctorado_20_32 = new CFormulario
 f_docentes_doctorado_20_32.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_doctorado_20_32.Inicializar conexion
 'response.End()
profesores_doctores_20_32= "select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_20_a_32_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as cantidad_profesores_20_a_32_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as cantidad_profesores_20_a_32_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_20_a_32_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"" &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl"


'response.Write("<pre>"&profesores_doctores&"</pre>")
'response.end()
f_docentes_doctorado_20_32.Consultar profesores_doctores_20_32
f_docentes_doctorado_20_32.siguiente

set f_docentes_doctorado_33_44 = new CFormulario
 f_docentes_doctorado_33_44.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_doctorado_33_44.Inicializar conexion
 'response.End()
profesores__doctorado_33_44= "select (select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_33_a_44_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as cantidad_profesores_33_a_44_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as cantidad_profesores_33_a_44_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_33_a_44_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl"

'response.Write("<pre>"&profesores__doctorado_33_44&"</pre>")
'response.end()
f_docentes_doctorado_33_44.Consultar profesores__doctorado_33_44
f_docentes_doctorado_33_44.siguiente



 set f_docentes_magister_1_19 = new CFormulario
 f_docentes_magister_1_19.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_magister_1_19.Inicializar conexion
 'response.End()
profesores_magister_1_19= "select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_1_a_19_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as cantidad_profesores_1_a_19_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as cantidad_profesores_1_a_19_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_1_a_19_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl"

'response.Write("<pre>"&profesores_magister_1_19&"</pre>")
'response.end()
f_docentes_magister_1_19.Consultar profesores_magister_1_19
f_docentes_magister_1_19.siguiente
'
'
'
'
set f_docentes_magister_20_32 = new CFormulario
 f_docentes_magister_20_32.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_magister_20_32.Inicializar conexion
 'response.End()
profesores_magister_20_32="select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_20_a_32_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as cantidad_profesores_20_a_32_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as cantidad_profesores_20_a_32_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_20_a_32_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl" 
'response.Write("<pre>"&profesores_magister_1_19&"</pre>")
'response.end()
f_docentes_magister_20_32.Consultar profesores_magister_20_32
f_docentes_magister_20_32.siguiente
'response.end()
'
'
set f_docentes_magister_33_44 = new CFormulario
 f_docentes_magister_33_44.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_magister_33_44"
 f_docentes_magister_33_44.Inicializar conexion
 'response.End()
profesores_magister_33_44="select (select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_33_a_44_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as cantidad_profesores_33_a_44_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as cantidad_profesores_33_a_44_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_33_a_44_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl" 
'response.Write("<pre>"&profesores_magister_1_19&"</pre>")
'response.end()
f_docentes_magister_33_44.Consultar profesores_magister_33_44
f_docentes_magister_33_44.siguiente

'
'
set f_docentes_licenciado_1_19 = new CFormulario
 f_docentes_licenciado_1_19.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_licenciado_1_19.Inicializar conexion
 'response.End()
profesores_licenciado_1_19= "select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_1_a_19_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as cantidad_profesores_1_a_19_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as cantidad_profesores_1_a_19_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_1_a_19_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl"
'response.Write("<pre>"&profesores_licenciado_1_19&"</pre>")
'response.end()
f_docentes_licenciado_1_19.Consultar profesores_licenciado_1_19
f_docentes_licenciado_1_19.siguiente
'
'
set f_docentes_licenciado_20_32 = new CFormulario
 f_docentes_licenciado_20_32.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_licenciado_20_32.Inicializar conexion
 'response.End()
profesores_licenciado_20_32="select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_20_a_32_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as cantidad_profesores_20_a_32_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as cantidad_profesores_20_a_32_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_20_a_32_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl" 

'response.Write("<pre>"&profesores_licenciado_20_32&"</pre>")
'response.end()
f_docentes_licenciado_20_32.Consultar profesores_licenciado_20_32
f_docentes_licenciado_20_32.siguiente
'
'
'
set f_docentes_licenciado_33_44 = new CFormulario
 f_docentes_licenciado_33_44.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_licenciado_33_44.Inicializar conexion
 'response.End()
profesores_licenciado_33_44="select (select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_33_a_44_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as cantidad_profesores_33_a_44_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as cantidad_profesores_33_a_44_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_33_a_44_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl" 
'response.Write("<pre>"&profesores_licenciado_20_32&"</pre>")
'response.end()
f_docentes_licenciado_33_44.Consultar profesores_licenciado_33_44
f_docentes_licenciado_33_44.siguiente
'
'
set f_docentes_profesional_1_19 = new CFormulario
 f_docentes_profesional_1_19.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_profesional_1_19.Inicializar conexion
 'response.End()
profesores_licenciado_1_19="select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_1_a_19_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as cantidad_profesores_1_a_19_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as cantidad_profesores_1_a_19_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_1_a_19_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl"
'response.Write("<pre>"&profesores_licenciado_20_32&"</pre>")
'response.end()
f_docentes_profesional_1_19.Consultar profesores_licenciado_1_19
f_docentes_profesional_1_19.siguiente
'
set f_docentes_profesional_20_32 = new CFormulario
 f_docentes_profesional_20_32.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_profesional_20_32.Inicializar conexion
 'response.End()
profesores_licenciado_20_32="select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_20_a_32_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as cantidad_profesores_20_a_32_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as cantidad_profesores_20_a_32_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_20_a_32_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl" 
'response.end()
f_docentes_profesional_20_32.Consultar profesores_licenciado_20_32
f_docentes_profesional_20_32.siguiente
'
'
set f_docentes_profesional_33_44 = new CFormulario
 f_docentes_profesional_33_44.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_profesional_33_44.Inicializar conexion
 'response.End()
profesores_profesional_33_44="select (select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_33_a_44_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as cantidad_profesores_33_a_44_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as cantidad_profesores_33_a_44_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_33_a_44_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl"
'response.Write("<pre>"&profesores_licenciado_20_32&"</pre>")
'response.end()
f_docentes_profesional_33_44.Consultar profesores_profesional_33_44
f_docentes_profesional_33_44.siguiente

'
'
'
set f_docentes_tecnico_1_19 = new CFormulario
 f_docentes_tecnico_1_19.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_tecnico_1_19.Inicializar conexion
 'response.End()
profesores_tecnico_1_19= "select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_1_a_19_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as cantidad_profesores_1_a_19_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as cantidad_profesores_1_a_19_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_1_a_19_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl"
'response.Write("<pre>"&profesores_tecnico_1_19&"</pre>")
'response.end()
f_docentes_tecnico_1_19.Consultar profesores_tecnico_1_19
f_docentes_tecnico_1_19.siguiente
'
'
'
set f_docentes_tecnico_20_32 = new CFormulario
 f_docentes_tecnico_20_32.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_tecnico_20_32.Inicializar conexion
 'response.End()
profesores_tecnico_20_32= "select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_20_a_32_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as cantidad_profesores_20_a_32_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as cantidad_profesores_20_a_32_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_20_a_32_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl" 
'response.Write("<pre>"&profesores_tecnico_1_19&"</pre>")
'response.end()
f_docentes_tecnico_20_32.Consultar profesores_tecnico_20_32
f_docentes_tecnico_20_32.siguiente
'
'
set f_docentes_tecnico_33_44 = new CFormulario
 f_docentes_tecnico_33_44.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_tecnico_33_44.Inicializar conexion
 'response.End()
profesores_tecnico_33_44= "select (select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_33_a_44_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as cantidad_profesores_33_a_44_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as cantidad_profesores_33_a_44_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_33_a_44_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl"
'response.Write("<pre>"&profesores_tecnico_1_19&"</pre>")
'response.end()
f_docentes_tecnico_33_44.Consultar profesores_tecnico_33_44
f_docentes_tecnico_33_44.siguiente
'
'
'
 set f_docentes_sintitulo_1_19 = new CFormulario
 f_docentes_sintitulo_1_19.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_sintitulo_1_19.Inicializar conexion
 'response.End()
profesores_sintitulo_1_19= "select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as profesores_1_a_19_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as cantidad_profesores_1_a_19_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as cantidad_profesores_1_a_19_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as profesores_1_a_19_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl"
'response.Write("<pre>"&profesores_doctores&"</pre>")
'response.end()
f_docentes_sintitulo_1_19.Consultar profesores_sintitulo_1_19
f_docentes_sintitulo_1_19.siguiente
'response.end()
'
'
'
 set f_docentes_sintitulo_20_32 = new CFormulario
 f_docentes_sintitulo_20_32.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_sintitulo_20_32.Inicializar conexion
 'response.End()
profesores_sintitulo_20_32= "select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as profesores_20_a_32_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as cantidad_profesores_20_a_32_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as cantidad_profesores_20_a_32_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as profesores_20_a_32_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl"
'response.Write("<pre>"&profesores_doctores&"</pre>")
'response.end()
f_docentes_sintitulo_20_32.Consultar profesores_sintitulo_20_32
f_docentes_sintitulo_20_32.siguiente
'
'
set f_docentes_sintitulo_33_44 = new CFormulario
 f_docentes_sintitulo_33_44.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_sintitulo_33_44.Inicializar conexion
 'response.End()
profesores_sintitulo_33_44="select (select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as profesores_33_a_44_MASCULINO,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_


"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as cantidad_profesores_33_a_44_MASCULINO,"& vbCrLf &_




"(select count(d.pers_nrut) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as cantidad_profesores_33_a_44_FEMENINO,"& vbCrLf &_


"(select isnull(sum(horas),0) as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_



"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as profesores_33_a_44_FEMENINO,"& vbCrLf &_

"(select isnull(sum(horas),0)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_

"cast(protic.obtener_horas_academicas(aa.pers_ncorr,"&peri_ccod&")as numeric)as horas"& vbCrLf &_

"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
" " &filtro&" "& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl" 
          
  

'response.Write("<pre>"&profesores_doctores&"</pre>")
'response.end()
f_docentes_sintitulo_33_44.Consultar profesores_sintitulo_33_44
f_docentes_sintitulo_33_44.siguiente
'
'



%>

<html>
<head>
<title>docentes por grado, sexo  y jornada</title>
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
    <td colspan="2"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Docentes <%=periodo_academico%> <%if sede <> null then%> Sede <%=sede%><%end if%> </font></div>
	  <div align="right"></div></td>
  </tr>
 
</table>
<p>&nbsp;</p>
<table width="1230">
  <tr width="50%">
    <td><table width="100%" border="1">
      <tr bordercolor="#999999" bgcolor="#c4d7ff">
        <td width="70%" colspan="4" valign="bottom"><font color="#333333">
          <div align="center"><strong>GRADOS DE <%=tido_tdesc%> DE <%=tcar_tdesc%> </strong></div>
        </font></td>
      </tr>
      <tr bordercolor="#999999" bgcolor="#c4d7ff">
        <td width="60%" rowspan="1" valign="bottom"><font color="#333333">
          <div align="center">Grados</div>
        </font></td>
        <td width="10%" colspan="1" valign="bottom"><font color="#333333">
          <div align="center">Hombres</div>
        </font></td>
        <td width="10%" colspan="1" valign="top"><font color="#333333">&nbsp;
          </font>
        <div align="center"><font color="#333333">Cantidad de Horas Acad&eacute;micas </font></div>
        </td>
      </tr>
     
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Jornada Completa </td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_33_44.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_33_44.ObtenerValor("profesores_33_a_44_MASCULINO")%></td>
      </tr>
     
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Media Jornada </td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_20_32.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_20_32.ObtenerValor("profesores_20_a_32_MASCULINO")%></td>
      </tr>
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Jornada Hora</td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_1_19.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_1_19.ObtenerValor("profesores_1_a_19_MASCULINO")%></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_33_44.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_33_44.ObtenerValor("profesores_33_a_44_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_20_32.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_20_32.ObtenerValor("profesores_20_a_32_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada Hora  </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_1_19.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_1_19.ObtenerValor("profesores_1_a_19_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Liceciados Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_33_44.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_33_44.ObtenerValor("profesores_33_a_44_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Liceciados Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_20_32.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_20_32.ObtenerValor("profesores_20_a_32_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Liceciados Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_1_19.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_1_19.ObtenerValor("profesores_1_a_19_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada Completa</span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_33_44.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_33_44.ObtenerValor("profesores_33_a_44_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Media Jornada </span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_20_32.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_20_32.ObtenerValor("profesores_20_a_32_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada Hora </span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_1_19.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_1_19.ObtenerValor("profesores_1_a_19_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_33_44.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_33_44.ObtenerValor("profesores_33_a_44_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_20_32.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_20_32.ObtenerValor("profesores_20_a_32_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_1_19.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_1_19.ObtenerValor("profesores_1_a_19_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_33_44.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_33_44.ObtenerValor("profesores_33_a_44_MASCULINO")%>
        </div></td>
      </tr>
	  <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_20_32.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_20_32.ObtenerValor("profesores_20_a_32_MASCULINO")%>
        </div></td>
      </tr>
	  <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_1_19.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_1_19.ObtenerValor("profesores_1_a_19_MASCULINO")%>
        </div></td>
      </tr>
    </table></td>
    <td><table width="100%" border="1">
      <tr bordercolor="#999999" bgcolor="#c4d7ff">
        <td width="70%" colspan="4" valign="bottom"><font color="#333333">
          <div align="center"><strong>GRADOS DE <%=tido_tdesc%> DE <%=tcar_tdesc%> </strong></div>
        </font></td>
      </tr>
      <tr bordercolor="#999999" bgcolor="#c4d7ff">
        <td width="60%" rowspan="1" valign="bottom"><font color="#333333">
          <div align="center">Grados</div>
        </font></td>
        <td width="10%" colspan="1" valign="bottom"><font color="#333333">
          <div align="center">Mujeres</div>
        </font></td>
        <td width="10%" colspan="1" valign="top"><font color="#333333">&nbsp;
          </font><div align="center"><font color="#333333">Cantidad de Horas Acad&eacute;micas </font></div>
        </td>
      </tr>
      
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Jornada Completa </td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_33_44.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_33_44.ObtenerValor("profesores_33_a_44_FEMENINO")%></td>
      </tr>
      
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Media Jornada </td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_20_32.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_20_32.ObtenerValor("profesores_20_a_32_FEMENINO")%></td>
      </tr>
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Jornada Hora </td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_1_19.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_1_19.ObtenerValor("profesores_1_a_19_FEMENINO")%></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_33_44.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_33_44.ObtenerValor("profesores_33_a_44_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_20_32.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_20_32.ObtenerValor("profesores_20_a_32_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada Hora  </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_1_19.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_1_19.ObtenerValor("profesores_1_a_19_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Liceciados Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_33_44.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_33_44.ObtenerValor("profesores_33_a_44_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Liceciados Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_20_32.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_20_32.ObtenerValor("profesores_20_a_32_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Liceciados Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_1_19.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_1_19.ObtenerValor("profesores_1_a_19_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada Completa</span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_33_44.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_33_44.ObtenerValor("profesores_33_a_44_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Media Jornada </span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_20_32.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_20_32.ObtenerValor("profesores_20_a_32_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada Hora </span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_1_19.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_1_19.ObtenerValor("profesores_1_a_19_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel SúperiorJornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_33_44.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_33_44.ObtenerValor("profesores_33_a_44_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_20_32.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_20_32.ObtenerValor("profesores_20_a_32_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_1_19.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_1_19.ObtenerValor("profesores_1_a_19_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_33_44.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_33_44.ObtenerValor("profesores_33_a_44_FEMENINO")%>
        </div></td>
      </tr>
	     <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_20_32.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_20_32.ObtenerValor("profesores_20_a_32_FEMENINO")%>
        </div></td>
      </tr>
	     <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_1_19.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_1_19.ObtenerValor("profesores_1_a_19_FEMENINO")%>
        </div></td>
      </tr>
    </table></td>
  </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>