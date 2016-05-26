<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'Response.AddHeader "Content-Disposition", "attachment;filename=docentes_por_grado_sexo_jornada.xls"
'Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
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



'peri_ccod=210
'tcar_ccod=1
'tido_ccod=1
tcar_tdesc=conexion.ConsultaUno("select tcar_tdesc from tipos_carrera where tcar_ccod="&tcar_ccod&"")
tido_tdesc=conexion.ConsultaUno("select tido_tdesc from tipos_docente where tido_ccod="&tido_ccod&"")
ano=conexion.ConsultaUno("select anos_ccod from periodos_academicos where peri_ccod="&peri_ccod&"")




if tido_ccod=1 or tido_ccod=3 then

 set f_docentes_doctorado_1_19 = new CFormulario
 f_docentes_doctorado_1_19.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_doctorado_1_19"
 f_docentes_doctorado_1_19.Inicializar conexion
 'response.End()
profesores_doctores_1_19= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING( CEILING(cast(sum(hora_semana)as decimal(5,1))))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_1_a_19_Diurnos_DOCTORADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_DOCTORADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_DOCTORADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_DOCTORADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_total_DOCTORADO"
response.Write("<pre>"&profesores_doctores_1_19&"</pre>")
response.end()
f_docentes_doctorado_1_19.Consultar profesores_doctores_1_19
f_docentes_doctorado_1_19.siguiente
'response.end()


set f_docentes_doctorado_20_32 = new CFormulario
 f_docentes_doctorado_20_32.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_doctorado_20_32"
 f_docentes_doctorado_20_32.Inicializar conexion
 'response.End()
profesores_doctores_20_32= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_20_a_32_Diurnos_DOCTORADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_DOCTORADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_DOCTORADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod ="&peri_ccod&"" & vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_DOCTORADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_total_DOCTORADO"
'response.Write("<pre>"&profesores_doctores_20_32&"</pre>")
'response.end()
f_docentes_doctorado_20_32.Consultar profesores_doctores_20_32
f_docentes_doctorado_20_32.siguiente

set f_docentes_doctorado_33_44 = new CFormulario
 f_docentes_doctorado_33_44.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_doctorado_33_44"
 f_docentes_doctorado_33_44.Inicializar conexion
 'response.End()
profesores__doctorado_33_44= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_33_a_44_Diurnos_DOCTORADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_DOCTORADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
")d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_DOCTORADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_DOCTORADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_total_DOCTORADO"
'response.Write("<pre>"&profesores__doctorado_33_44&"</pre>")
'response.end()
f_docentes_doctorado_33_44.Consultar profesores__doctorado_33_44
f_docentes_doctorado_33_44.siguiente



 set f_docentes_magister_1_19 = new CFormulario
 f_docentes_magister_1_19.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_magister_1_19"
 f_docentes_magister_1_19.Inicializar conexion
 'response.End()
profesores_magister_1_19= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_1_a_19_Diurnos_MAGISTER_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_MAGISTER_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_MAGISTER_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_MAGISTER_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_total_MAGISTER"
'response.Write("<pre>"&profesores_magister_1_19&"</pre>")
'response.end()
f_docentes_magister_1_19.Consultar profesores_magister_1_19
f_docentes_magister_1_19.siguiente




set f_docentes_magister_20_32 = new CFormulario
 f_docentes_magister_20_32.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_magister_20_32"
 f_docentes_magister_20_32.Inicializar conexion
 'response.End()
profesores_magister_20_32= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_20_a_32_Diurnos_MAGISTER_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_MAGISTER_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_MAGISTER_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_MAGISTER_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_total_MAGISTER"
'response.Write("<pre>"&profesores_magister_1_19&"</pre>")
'response.end()
f_docentes_magister_20_32.Consultar profesores_magister_20_32
f_docentes_magister_20_32.siguiente
'response.end()


set f_docentes_magister_33_44 = new CFormulario
 f_docentes_magister_33_44.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_magister_33_44"
 f_docentes_magister_33_44.Inicializar conexion
 'response.End()
profesores_magister_33_44= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_33_a_44_Diurnos_MAGISTER_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_MAGISTER_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_MAGISTER_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_MAGISTER_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_total_MAGISTER"
'response.Write("<pre>"&profesores_magister_1_19&"</pre>")
'response.end()
f_docentes_magister_33_44.Consultar profesores_magister_33_44
f_docentes_magister_33_44.siguiente



set f_docentes_licenciado_1_19 = new CFormulario
 f_docentes_licenciado_1_19.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_licenciado_1_19"
 f_docentes_licenciado_1_19.Inicializar conexion
 'response.End()
profesores_licenciado_1_19= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_1_a_19_Diurnos_LICENCIADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_LICENCIADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_LICENCIADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_LICENCIADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_total_LICENCIADO"
'response.Write("<pre>"&profesores_licenciado_1_19&"</pre>")
'response.end()
f_docentes_licenciado_1_19.Consultar profesores_licenciado_1_19
f_docentes_licenciado_1_19.siguiente


set f_docentes_licenciado_20_32 = new CFormulario
 f_docentes_licenciado_20_32.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_licenciado_20_32"
 f_docentes_licenciado_20_32.Inicializar conexion
 'response.End()
profesores_licenciado_20_32= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_20_a_32_Diurnos_LICENCIADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_LICENCIADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_LICENCIADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_LICENCIADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_total_LICENCIADO"
'response.Write("<pre>"&profesores_licenciado_20_32&"</pre>")
'response.end()
f_docentes_licenciado_20_32.Consultar profesores_licenciado_20_32
f_docentes_licenciado_20_32.siguiente



set f_docentes_licenciado_33_44 = new CFormulario
 f_docentes_licenciado_33_44.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_licenciado_33_44"
 f_docentes_licenciado_33_44.Inicializar conexion
 'response.End()
profesores_licenciado_33_44= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_33_a_44_Diurnos_LICENCIADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_LICENCIADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_LICENCIADO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_LICENCIADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_total_LICENCIADO"
'response.Write("<pre>"&profesores_licenciado_20_32&"</pre>")
'response.end()
f_docentes_licenciado_33_44.Consultar profesores_licenciado_33_44
f_docentes_licenciado_33_44.siguiente


set f_docentes_profesional_1_19 = new CFormulario
 f_docentes_profesional_1_19.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_profesional_1_19"
 f_docentes_profesional_1_19.Inicializar conexion
 'response.End()
profesores_licenciado_1_19= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_1_a_19_Diurnos_PROFESIONAL_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_PROFESIONAL_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_PROFESIONAL_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_PROFESIONAL_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_total_PROFESIONAL"
'response.Write("<pre>"&profesores_licenciado_20_32&"</pre>")
'response.end()
f_docentes_profesional_1_19.Consultar profesores_licenciado_1_19
f_docentes_profesional_1_19.siguiente

set f_docentes_profesional_20_32 = new CFormulario
 f_docentes_profesional_20_32.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_profesional_20_32"
 f_docentes_profesional_20_32.Inicializar conexion
 'response.End()
profesores_licenciado_20_32= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_20_a_32_Diurnos_PROFESIONAL_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_PROFESIONAL_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_PROFESIONAL_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_PROFESIONAL_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_total_PROFESIONAL"
'response.Write("<pre>"&profesores_licenciado_20_32&"</pre>")
'response.end()
f_docentes_profesional_20_32.Consultar profesores_licenciado_20_32
f_docentes_profesional_20_32.siguiente


set f_docentes_profesional_33_44 = new CFormulario
 f_docentes_profesional_33_44.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_profesional_33_44"
 f_docentes_profesional_33_44.Inicializar conexion
 'response.End()
profesores_profesional_33_44= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_33_a_44_Diurnos_PROFESIONAL_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_PROFESIONAL_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_PROFESIONAL_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_PROFESIONAL_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_total_PROFESIONAL"
'response.Write("<pre>"&profesores_licenciado_20_32&"</pre>")
'response.end()
f_docentes_profesional_33_44.Consultar profesores_profesional_33_44
f_docentes_profesional_33_44.siguiente




set f_docentes_tecnico_1_19 = new CFormulario
 f_docentes_tecnico_1_19.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_tecnico_1_19"
 f_docentes_tecnico_1_19.Inicializar conexion
 'response.End()
profesores_tecnico_1_19= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_1_a_19_Diurnos_TECNICO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TECNICO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_TECNICO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_TECNICO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_total_TECNICO"
'response.Write("<pre>"&profesores_tecnico_1_19&"</pre>")
'response.end()
f_docentes_tecnico_1_19.Consultar profesores_tecnico_1_19
f_docentes_tecnico_1_19.siguiente



set f_docentes_tecnico_20_32 = new CFormulario
 f_docentes_tecnico_20_32.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_tecnico_20_32"
 f_docentes_tecnico_20_32.Inicializar conexion
 'response.End()
profesores_tecnico_20_32= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_20_a_32_Diurnos_TECNICO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TECNICO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_TECNICO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_TECNICO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_total_TECNICO"
'response.Write("<pre>"&profesores_tecnico_1_19&"</pre>")
'response.end()
f_docentes_tecnico_20_32.Consultar profesores_tecnico_20_32
f_docentes_tecnico_20_32.siguiente


set f_docentes_tecnico_33_44 = new CFormulario
 f_docentes_tecnico_33_44.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_tecnico_33_44"
 f_docentes_tecnico_33_44.Inicializar conexion
 'response.End()
profesores_tecnico_33_44= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_33_a_44_Diurnos_TECNICO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TECNICO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_TECNICO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_TECNICO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_total_TECNICO"
'response.Write("<pre>"&profesores_tecnico_1_19&"</pre>")
'response.end()
f_docentes_tecnico_33_44.Consultar profesores_tecnico_33_44
f_docentes_tecnico_33_44.siguiente



 set f_docentes_sintitulo_1_19 = new CFormulario
 f_docentes_sintitulo_1_19.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_sintitulo_1_19"
 f_docentes_sintitulo_1_19.Inicializar conexion
 'response.End()
profesores_sintitulo_1_19= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_1_a_19_Diurnos_SIN_TITULO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_1_a_19__DIURNO_SIN_TITULO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_1_a_19__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_SIN_TITULO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_SIN_TITULO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 1 and 19"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_1_a_19_VESPERTINO_total_SIN_TITULO"
'response.Write("<pre>"&profesores_doctores&"</pre>")
'response.end()
f_docentes_sintitulo_1_19.Consultar profesores_sintitulo_1_19
f_docentes_sintitulo_1_19.siguiente
'response.end()



 set f_docentes_sintitulo_20_32 = new CFormulario
 f_docentes_sintitulo_20_32.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_sintitulo_20_32"
 f_docentes_sintitulo_20_32.Inicializar conexion
 'response.End()
profesores_sintitulo_20_32= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_20_a_32_Diurnos_SIN_TITULO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_20_a_32__DIURNO_SIN_TITULO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_20_a_32__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_SIN_TITULO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_SIN_TITULO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 20 and 32"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_20_a_32_VESPERTINO_total_SIN_TITULO"
'response.Write("<pre>"&profesores_doctores&"</pre>")
'response.end()
f_docentes_sintitulo_20_32.Consultar profesores_sintitulo_20_32
f_docentes_sintitulo_20_32.siguiente


set f_docentes_sintitulo_33_44 = new CFormulario
 f_docentes_sintitulo_33_44.Carga_Parametros "docentes_x_grado_sexo_jornada.xml", "docentes_sintitulo_33_44"
 f_docentes_sintitulo_33_44.Inicializar conexion
 'response.End()
profesores_sintitulo_33_44= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr" & vbCrLf &_   
        "from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			       "      asignaturas j, secciones n,tipos_profesores o,profesores p   "   & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_
 			             "and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			            " and a.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "and b.sede_ccod     =   e.sede_ccod  " & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			            " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_    
 			             "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_    
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3   "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1 " & vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,   " & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_33_a_44_Diurnos_SIN_TITULO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr"& vbCrLf &_    
        "from ("  & vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,   " & vbCrLf &_
 			  "           asignaturas j, secciones n,tipos_profesores o,profesores p      "& vbCrLf &_
 		          "    Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			            " and b.anex_ncorr    =   c.anex_ncorr "  & vbCrLf &_  
 			            " and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			            " and b.sede_ccod     =   e.sede_ccod   "  & vbCrLf &_
 			             "and c.asig_ccod     =   j.asig_ccod"  & vbCrLf &_   
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			             "and p.pers_ncorr    =   d.pers_ncorr " & vbCrLf &_   
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3 "  & vbCrLf &_ 
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1  "& vbCrLf &_  
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
           " group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod"  & vbCrLf &_ 
         ") as aa,  " & vbCrLf &_ 
        "anexos b, duracion_asignatura c   "& vbCrLf &_
       " where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_ 
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_33_a_44__DIURNO_SIN_TITULO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                         " when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
       " from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "  & vbCrLf &_
       " from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
              "From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			      "       asignaturas j, secciones n,tipos_profesores o,profesores p     "& vbCrLf &_ 
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr" & vbCrLf &_    
 			          "   and b.anex_ncorr    =   c.anex_ncorr" & vbCrLf &_    
 			          "   and a.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
 			          "   and b.sede_ccod     =   e.sede_ccod " & vbCrLf &_
 			          "   and c.asig_ccod     =   j.asig_ccod " & vbCrLf &_   
 			          "   and n.secc_ccod     =   c.secc_ccod " & vbCrLf &_   
 			          "   and o.TPRO_CCOD     =   p.TPRO_CCOD " & vbCrLf &_   
 			          "   and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_    
 			          "   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         
                      "   and a.ecdo_ccod     <> 3   "& vbCrLf &_ 
                        " and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1   "& vbCrLf &_ 
                        
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "  & vbCrLf &_
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c   "& vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_33_a_44__DIURNO_TOTAl,"& vbCrLf &_


 "(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
       " from ( " & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			     "        asignaturas j, secciones n,tipos_profesores o,profesores p "& vbCrLf &_     
 		             " Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			           "  and b.anex_ncorr    =   c.anex_ncorr    " & vbCrLf &_
 			           "  and a.pers_ncorr    =   d.pers_ncorr    " & vbCrLf &_
 			           "  and b.sede_ccod     =   e.sede_ccod    " & vbCrLf &_
 			           "  and c.asig_ccod     =   j.asig_ccod    " & vbCrLf &_
 			           "  and n.secc_ccod     =   c.secc_ccod    " & vbCrLf &_
 			           "  and o.TPRO_CCOD     =   p.TPRO_CCOD    " & vbCrLf &_
 			           "  and p.pers_ncorr    =   d.pers_ncorr   "  & vbCrLf &_
 			           "  AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                         "and a.ecdo_ccod     <> 3"  & vbCrLf &_  
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1    "& vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod   "& vbCrLf &_
         ") as aa,   " & vbCrLf &_
        "anexos b, duracion_asignatura c" & vbCrLf &_  
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
       " and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_SIN_TITULO_MASCULINO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                          "when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_  
     "   from (  "& vbCrLf &_
            "select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_  
 			            " asignaturas j, secciones n,tipos_profesores o,profesores p  "    & vbCrLf &_
 		              "Where a.cdoc_ncorr     =   b.cdoc_ncorr "   & vbCrLf &_ 
 			             "and b.anex_ncorr    =   c.anex_ncorr  "  & vbCrLf &_ 
 			             "and a.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "and b.sede_ccod     =   e.sede_ccod "  & vbCrLf &_  
 			             "and c.asig_ccod     =   j.asig_ccod  "  & vbCrLf &_ 
 			             "and n.secc_ccod     =   c.secc_ccod  "  & vbCrLf &_ 
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD"    & vbCrLf &_ 
 			            " and p.pers_ncorr    =   d.pers_ncorr"   & vbCrLf &_  
 			             "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                       " and a.ecdo_ccod     <> 3   " & vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                         "and p.tpro_ccod=1"    & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod  "  & vbCrLf &_
       "  ) as aa, "   & vbCrLf &_
      "  anexos b, duracion_asignatura c "  & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&")"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_SIN_TITULO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,('')as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido,"& vbCrLf &_

"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
                                          "when 'SEMESTRAL'then 18"& vbCrLf &_
                                         " when 'TRIMESTRAL'then 12"& vbCrLf &_
                                          "when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
        "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr    "& vbCrLf &_
        "from ("  & vbCrLf &_
           " select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
             " From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "  & vbCrLf &_
 			             "asignaturas j, secciones n,tipos_profesores o,profesores p    "  & vbCrLf &_
 		            "  Where a.cdoc_ncorr     =   b.cdoc_ncorr     "& vbCrLf &_
 			          "   and b.anex_ncorr    =   c.anex_ncorr "    & vbCrLf &_
 			             "and a.pers_ncorr    =   d.pers_ncorr "   & vbCrLf &_ 
 			             "and b.sede_ccod     =   e.sede_ccod  "  & vbCrLf &_ 
 			             "and c.asig_ccod     =   j.asig_ccod "  & vbCrLf &_  
 			             "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_   
 			             "and o.TPRO_CCOD     =   p.TPRO_CCOD "  & vbCrLf &_  
 			             "and p.pers_ncorr    =   d.pers_ncorr "    & vbCrLf &_
 			            " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
                        " and a.ecdo_ccod     <> 3    "& vbCrLf &_
                         "and b.eane_ccod     <> 3"& vbCrLf &_
                        " and p.tpro_ccod=1 "   & vbCrLf &_
                         
                         
                         "and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
            "group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_  
        " ) as aa,  "  & vbCrLf &_
       " anexos b, duracion_asignatura c"   & vbCrLf &_
        "where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
        "and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
        "group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))d"& vbCrLf &_

"where d.horas between 33 and 44"& vbCrLf &_
"and titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_33_a_44_VESPERTINO_total_SIN_TITULO"
'response.Write("<pre>"&profesores_doctores&"</pre>")
'response.end()
f_docentes_sintitulo_33_44.Consultar profesores_sintitulo_33_44
f_docentes_sintitulo_33_44.siguiente


 'set f_docentes_totales = new CFormulario
 'f_docentes_totales.carga_parametros "docentes_x_grado_sexo_jornada.xml", "docentes_totales" 
 'f_docentes_totales.Inicializar conexion
 
 set f_docentes_totales = new CFormulario
 f_docentes_totales.carga_parametros "tabla_vacia.xml", "tabla" 
 f_docentes_totales.Inicializar conexion

profesores_totales= "select (select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
 "when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr "& vbCrLf &_ 
" from (  "& vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_
    "   asignaturas j, secciones n,tipos_profesores o,profesores p"     & vbCrLf &_
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
   "and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod "& vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod "& vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod "& vbCrLf &_
   "and o.TPRO_CCOD     =   p.TPRO_CCOD "& vbCrLf &_
   "and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
   "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
   "and a.ecdo_ccod     <> 3  " & vbCrLf &_
 "and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1   "& vbCrLf &_

"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod" & vbCrLf &_
" ) as aa,  "& vbCrLf &_
" anexos b, duracion_asignatura c   "& vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))asd"& vbCrLf &_
"where titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
"group by titulo_grado_obtenido)as cantidad_doctorado,"& vbCrLf &_

"(select count(titulo_grado_obtenido)as cantidad_magister"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
 "when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
" from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr " & vbCrLf &_
 "from ("  & vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "& vbCrLf &_
       "asignaturas j, secciones n,tipos_profesores o,profesores p"& vbCrLf &_     
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
  " and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
  " and b.sede_ccod     =   e.sede_ccod "& vbCrLf &_
  " and c.asig_ccod     =   j.asig_ccod "& vbCrLf &_
  " and n.secc_ccod     =   c.secc_ccod "& vbCrLf &_
 "  and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_
 "  and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
"   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
   "and a.ecdo_ccod     <> 3  " & vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1   "& vbCrLf &_

"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
 ") as aa,  "& vbCrLf &_
 "anexos b, duracion_asignatura c" & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))asd"& vbCrLf &_
"where titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as cantidad_magister,"& vbCrLf &_


"(select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
" when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_
 "from (  "& vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e, " & vbCrLf &_
      " asignaturas j, secciones n,tipos_profesores o,profesores p  "   & vbCrLf &_
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
   "and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod "& vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod "& vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod "& vbCrLf &_
   "and o.TPRO_CCOD     =   p.TPRO_CCOD "& vbCrLf &_
   " and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
   "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
   "and a.ecdo_ccod     <> 3  " & vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1 "  & vbCrLf &_

"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
" ) as aa,  "& vbCrLf &_
" anexos b, duracion_asignatura c "  & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))asd"& vbCrLf &_
"where titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
"group by titulo_grado_obtenido)as cantidad_licenciado,"& vbCrLf &_


"(select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
 "when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_
" from ( " & vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,"  & vbCrLf &_
       "asignaturas j, secciones n,tipos_profesores o,profesores p " & vbCrLf &_   
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
   "and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod "& vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod "& vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod "& vbCrLf &_
   "and o.TPRO_CCOD     =   p.TPRO_CCOD "& vbCrLf &_
   "and p.pers_ncorr    =   d.pers_ncorr" & vbCrLf &_
   "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
  " and a.ecdo_ccod     <> 3   "& vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1  " & vbCrLf &_

"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
" ) as aa,  "& vbCrLf &_
" anexos b, duracion_asignatura c   "& vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))asd"& vbCrLf &_
"where titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
"group by titulo_grado_obtenido)as cantidad_profesional,"& vbCrLf &_


"(select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
 "when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
" from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr "& vbCrLf &_ 
 "from (  "& vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "& vbCrLf &_
      " asignaturas j, secciones n,tipos_profesores o,profesores p  " & vbCrLf &_  
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
   "and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod "& vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod "& vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod "& vbCrLf &_
  " and o.TPRO_CCOD     =   p.TPRO_CCOD "& vbCrLf &_
 "  and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
"   AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
   "and a.ecdo_ccod     <> 3   "& vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1  " & vbCrLf &_
 
"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
" ) as aa, " & vbCrLf &_
" anexos b, duracion_asignatura c  " & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr" & vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"--and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))asd"& vbCrLf &_
"where titulo_grado_obtenido='TECNICO'"& vbCrLf &_
"group by titulo_grado_obtenido)as cantidad_tecnico,"& vbCrLf &_



"(select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
 "when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_
 "from ( " & vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,"  & vbCrLf &_
       "asignaturas j, secciones n,tipos_profesores o,profesores p  "   & vbCrLf &_
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
   "and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod "& vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod "& vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod "& vbCrLf &_
   "and o.TPRO_CCOD     =   p.TPRO_CCOD "& vbCrLf &_
   "and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
  " AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
   "and a.ecdo_ccod     <> 3  " & vbCrLf &_
 "and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1"   & vbCrLf &_
 
"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
 ") as aa, " & vbCrLf &_
 "anexos b, duracion_asignatura c  " & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))asd"& vbCrLf &_
"where titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
"group by titulo_grado_obtenido)as cantidad_sin_titulo,"& vbCrLf &_


"(select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
" when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_
 "from ("  & vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e," & vbCrLf &_ 
       "asignaturas j, secciones n,tipos_profesores o,profesores p   "  & vbCrLf &_
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
  " and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod" & vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod" & vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_
  " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_
  " and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
   "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
  " and a.ecdo_ccod     <> 3 "  & vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1   "& vbCrLf &_
 
"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
 ") as aa,"  & vbCrLf &_
" anexos b, duracion_asignatura c "  & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod="&tcar_ccod&"))asd)as cantidad_total_pregado,"& vbCrLf &_


"(select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
" when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_
 "from ("  & vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e," & vbCrLf &_ 
       "asignaturas j, secciones n,tipos_profesores o,profesores p   "  & vbCrLf &_
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
  " and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod" & vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod" & vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_
  " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_
  " and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
   "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
  " and a.ecdo_ccod     <> 3 "  & vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1   "& vbCrLf &_
 
"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
 ") as aa,"  & vbCrLf &_
" anexos b, duracion_asignatura c "  & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod=1))asd)as cantidad_diurno_pregrado,"& vbCrLf &_


"(select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
" when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_
 "from ("  & vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e," & vbCrLf &_ 
       "asignaturas j, secciones n,tipos_profesores o,profesores p   "  & vbCrLf &_
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
  " and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod" & vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod" & vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_
  " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_
  " and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
   "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
  " and a.ecdo_ccod     <> 3 "  & vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1   "& vbCrLf &_
 
"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
 ") as aa,"  & vbCrLf &_
" anexos b, duracion_asignatura c "  & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod=1))asd)as cantidad_vespertino_pregrado,"& vbCrLf &_

"(select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
" when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_
 "from ("  & vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e," & vbCrLf &_ 
       "asignaturas j, secciones n,tipos_profesores o,profesores p   "  & vbCrLf &_
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
  " and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod" & vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod" & vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_
  " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_
  " and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
   "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
  " and a.ecdo_ccod     <> 3 "  & vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1   "& vbCrLf &_
 
"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
 ") as aa,"  & vbCrLf &_
" anexos b, duracion_asignatura c "  & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod=1))asd)as cantidad_total_pregrado"


'response.Write("<pre>"&profesores_totales&"</pre>")
f_docentes_totales.Consultar profesores_totales
f_docentes_totales.siguiente



 set f_docentes_totales_postgrado = new CFormulario
 f_docentes_totales_postgrado.carga_parametros "tabla_vacia.xml", "tabla" 
 f_docentes_totales_postgrado.Inicializar conexion
 
 
 
profesores_totales_postgrado="select (select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
" when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_
 "from ("  & vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e," & vbCrLf &_ 
       "asignaturas j, secciones n,tipos_profesores o,profesores p   "  & vbCrLf &_
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
  " and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod" & vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod" & vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_
  " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_
  " and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
   "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
  " and a.ecdo_ccod     <> 3 "  & vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1   "& vbCrLf &_
 
"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
 ") as aa,"  & vbCrLf &_
" anexos b, duracion_asignatura c "  & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=1"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod=2))asd)as cantidad_diurno_postgrado,"& vbCrLf &_
"(select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
" when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_
 "from ("  & vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e," & vbCrLf &_ 
       "asignaturas j, secciones n,tipos_profesores o,profesores p   "  & vbCrLf &_
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
  " and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod" & vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod" & vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_
  " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_
  " and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
   "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
  " and a.ecdo_ccod     <> 3 "  & vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1   "& vbCrLf &_
 
"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
 ") as aa,"  & vbCrLf &_
" anexos b, duracion_asignatura c "  & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and jorn_ccod=2"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod=2))asd)as cantidad_vespertino_postgrado,"& vbCrLf &_

"(select count(titulo_grado_obtenido)as cantidad_doctorado"& vbCrLf &_
"from(select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_
"isnull((select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G')),'SIN_TITULO')as titulo_grado_obtenido,"& vbCrLf &_
"isnull((select  FLOOR(horas) from   (select  CEILING(cast(sum(hora_semana)as decimal(5,1)))as horas,pers_ncorr from( select ((horas*75)/60)/case regimen when 'ANUAL'then 36"& vbCrLf &_
 "when 'SEMESTRAL'then 18"& vbCrLf &_
" when 'TRIMESTRAL'then 12"& vbCrLf &_
"when 'PERIODO'then 12 end  as hora_semana,pers_ncorr"& vbCrLf &_
 "from( select cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen,pers_ncorr  "& vbCrLf &_
 "from ("  & vbCrLf &_
"select (c.dane_nsesiones/2) as sesiones,c.duas_ccod, b.anex_ncorr,a.pers_ncorr"& vbCrLf &_
"From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e," & vbCrLf &_ 
       "asignaturas j, secciones n,tipos_profesores o,profesores p   "  & vbCrLf &_
"Where a.cdoc_ncorr     =   b.cdoc_ncorr"& vbCrLf &_
   "and b.anex_ncorr    =   c.anex_ncorr"& vbCrLf &_
  " and a.pers_ncorr    =   d.pers_ncorr"& vbCrLf &_
   "and b.sede_ccod     =   e.sede_ccod" & vbCrLf &_
   "and c.asig_ccod     =   j.asig_ccod" & vbCrLf &_
   "and n.secc_ccod     =   c.secc_ccod" & vbCrLf &_
  " and o.TPRO_CCOD     =   p.TPRO_CCOD" & vbCrLf &_
  " and p.pers_ncorr    =   d.pers_ncorr "& vbCrLf &_
   "AND b.SEDE_CCOD     =   p.sede_ccod"& vbCrLf &_
  " and a.ecdo_ccod     <> 3 "  & vbCrLf &_
" and b.eane_ccod     <> 3"& vbCrLf &_
"and p.tpro_ccod=1   "& vbCrLf &_
 
"and n.peri_ccod = "&peri_ccod&""& vbCrLf &_
"group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc ,c.duas_ccod "& vbCrLf &_
 ") as aa,"  & vbCrLf &_
" anexos b, duracion_asignatura c "  & vbCrLf &_
"where aa.anex_ncorr=b.anex_ncorr"& vbCrLf &_
"and  aa.duas_ccod=c.duas_ccod"& vbCrLf &_
"group by b.anex_ncorr,b.anex_nhoras_coordina,b.anex_ncuotas ,duas_tdesc,pers_ncorr)asd)asdd group by pers_ncorr)aaa where aaa.pers_ncorr=aa.pers_ncorr),0)as horas"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a, bloques_profesores b,bloques_horarios c,secciones d,carreras e,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
"and b.bloq_ccod=c.bloq_ccod"& vbCrLf &_
"and c.secc_ccod=d.secc_ccod"& vbCrLf &_
"and a.tpro_ccod='1'"& vbCrLf &_
"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and tido_ccod="&tido_ccod&""& vbCrLf &_
"and d.peri_ccod="&peri_ccod&""& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
"and tcar_ccod=2))asd)as cantidad_total_postgrado"

f_docentes_totales_postgrado.Consultar profesores_totales_postgrado
f_docentes_totales_postgrado.siguiente
end if 

if tido_ccod=2 then
 set f_docentes_doctorado= new CFormulario
 f_docentes_doctorado.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_docentes_doctorado.Inicializar conexion
 'response.End()
profesores_doctores= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
      
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where  titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_DOCTORADO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_DOCTORADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
         
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3))d"& vbCrLf &_

"where titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
")as profesores_DOCTORADO_TOTAl"


'response.Write("<pre>"&profesores_doctores&"</pre>")
'response.end()
f_docentes_doctorado.Consultar profesores_doctores
f_docentes_doctorado.siguiente

set f_docentes_magister= new CFormulario
 f_docentes_magister.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_docentes_magister.Inicializar conexion
 'response.End()
profesores_magister= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
      
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_MAGISTER,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_DOCTORADO_MAGISTER,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
         
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3))d"& vbCrLf &_

"where titulo_grado_obtenido='MAGISTER' or titulo_grado_obtenido='MAESTRIA'"& vbCrLf &_
")as profesores_MAGISTER_TOTAl"


'response.Write("<pre>"&profesores_magister&"</pre>")
'response.end()
f_docentes_magister.Consultar profesores_magister
f_docentes_magister.siguiente

set f_docentes_licenciados= new CFormulario
 f_docentes_licenciados.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_docentes_licenciados.Inicializar conexion
 'response.End()
profesores_licenciados= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
      
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_LICENCIADO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_LICENCIADO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
         
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3))d"& vbCrLf &_

"where titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
")as profesores_LICENCIADO_TOTAl"


'response.Write("<pre>"&profesores_licenciados&"</pre>")
'response.end()
f_docentes_licenciados.Consultar profesores_licenciados
f_docentes_licenciados.siguiente


set f_docentes_profesionales= new CFormulario
 f_docentes_profesionales.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_docentes_profesionales.Inicializar conexion
 'response.End()
profesores_profesionales= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
      
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_PROFESIONAL,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_PROFESIONAL_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
         
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3))d"& vbCrLf &_

"where titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
")as profesores_PROFESIONAL_TOTAl"


'response.Write("<pre>"&profesores_profesionales&"</pre>")
'response.end()
f_docentes_profesionales.Consultar profesores_profesionales
f_docentes_profesionales.siguiente

set f_docentes_tecnicos= new CFormulario
 f_docentes_tecnicos.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_docentes_tecnicos.Inicializar conexion
 'response.End()
profesores_tecnicos= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
      
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_TECNICO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_TECNICO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
         
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3))d"& vbCrLf &_

"where titulo_grado_obtenido='TECNICO'"& vbCrLf &_
")as profesores_TECNICO_TOTAl"


'response.Write("<pre>"&profesores_tecnicos&"</pre>")
'response.end()
f_docentes_tecnicos.Consultar profesores_tecnicos
f_docentes_tecnicos.siguiente


set f_docentes_sin_titulo= new CFormulario
 f_docentes_sin_titulo.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_docentes_sin_titulo.Inicializar conexion
 'response.End()
profesores_sin_titulo= "select (select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
      
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=1)d"& vbCrLf &_

"where titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_SIN_TITULO,"& vbCrLf &_


"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
      
          
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3)"& vbCrLf &_
"and sexo_ccod=2)d"& vbCrLf &_

"where titulo_grado_obtenido is null"& vbCrLf &_
")as profesores_SIN_TITULO_FEMENINO,"& vbCrLf &_

"(select count(d.pers_nrut)as mediaycompletadiurna"& vbCrLf &_

"from (select   pers_nrut,(select sexo_tdesc from sexos a where aa.sexo_ccod=a.sexo_ccod)as sexo,"& vbCrLf &_


"(select protic.obtener_grado_docente_completados(aa.pers_ncorr,'G'))as titulo_grado_obtenido"& vbCrLf &_
         
  
"from  personas aa"& vbCrLf &_
"where aa.pers_ncorr in (select distinct a.pers_ncorr"& vbCrLf &_
"from profesores a,anos_tipo_docente f"& vbCrLf &_
"where a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and f.anos_ccod="&ano&""& vbCrLf &_
"and tido_ccod=3))d"& vbCrLf &_

"where titulo_grado_obtenido is null"& vbCrLf &_

")as profesores_SIN_TITULO_TOTAl"


'response.Write("<pre>"&profesores_sin_titulo&"</pre>")
'response.end()
f_docentes_sin_titulo.Consultar profesores_sin_titulo
f_docentes_sin_titulo.siguiente

end if

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
    <td colspan="2"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Docentes </font></div>
	  <div align="right"></div></td>
  </tr>
 
</table>
<p>&nbsp;</p>

<%if tido_ccod=1 or tido_ccod=3 then %>
<table width="100%" border="1">
    <tr borderColor="#999999" bgColor="#c4d7ff">
		<td colspan="7" align="center"><FONT color="#333333">&nbsp;</font>
		<div align="center"><font color="#333333"><strong>RESUMEN DE GRADO DE <%=tido_tdesc%> DE <%=tcar_tdesc%> </strong></font></div></td>
	</tr>
	<tr borderColor="#999999" bgColor="#c4d7ff">
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Doctores</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Magister</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Licenciados</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Profesionales</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Técnicos</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Sin grado-título</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Totales</strong></div></font></td>
	</tr>
	
	<tr bgcolor="#FFFFFF">
		<td><div align="center" class="Estilo4"><%=f_docentes_totales.ObtenerValor("cantidad_doctorado")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes_totales.ObtenerValor("cantidad_magister")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes_totales.ObtenerValor("cantidad_licenciado")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes_totales.ObtenerValor("cantidad_profesional")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes_totales.ObtenerValor("cantidad_tecnico")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes_totales.ObtenerValor("cantidad_sin_titulo")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes_totales.ObtenerValor("cantidad_total_pregado")%></td>
	</tr>
	
</table>


<p>&nbsp;</p>
<table width="100%" border="1">
    <tr borderColor="#999999" bgColor="#c4d7ff">
		<td colspan="7" align="center"><FONT color="#333333">&nbsp;</font>
		<div align="center"><font color="#333333"><strong>RESUMEN DE <%=tido_tdesc%> DE PREGRADO</strong></font></div></td>
	</tr>
	<tr borderColor="#999999" bgColor="#c4d7ff">
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Profesores Pregrado Diurnos</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Profesores Pregrado Vespertinos</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Total Profesores Pregrado</strong></div></font></td>

	</tr>
	
	<tr bgcolor="#FFFFFF">
		<td><div align="center" class="Estilo4"><%=f_docentes_totales.ObtenerValor("cantidad_diurno_pregrado")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes_totales.ObtenerValor("cantidad_vespertino_pregrado")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes_totales.ObtenerValor("cantidad_total_pregrado")%></td>
	
	</tr>
	
</table>
<p>&nbsp;</p>
<table width="100%" border="1">
    <tr borderColor="#999999" bgColor="#c4d7ff">
		<td colspan="7" align="center"><FONT color="#333333">&nbsp;</font>
		<div align="center"><font color="#333333"><strong>RESUMEN DE <%=tido_tdesc%> DE POSTGRADO </strong></font></div></td>
	</tr>
	<tr borderColor="#999999" bgColor="#c4d7ff">
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Profesores Postgrado Diurnos</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Profesores Postgrado Vespertinos</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Total Profesores Postgrado</strong></div></font></td>

	</tr>
	
	<tr bgcolor="#FFFFFF">
		<td><div align="center" class="Estilo4"><%=f_docentes_totales_postgrado.ObtenerValor("cantidad_diurno_postgrado")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes_totales_postgrado.ObtenerValor("cantidad_vespertino_postgrado")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes_totales_postgrado.ObtenerValor("cantidad_total_postgrado")%></td>
	
	</tr>
	
</table>
<p>&nbsp;</p>
<table width="100%" border="1">
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333">
                                <div align="center"><strong> <%=tido_tdesc%> DE GRADOS</strong></div>
                                </font></td>
                              </tr>
							    <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="60%" rowspan="1" valign="bottom"><FONT color="#333333">
                                <div align="center">Grados</div>
                                </font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Hombres</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mujeres</div></font></td>
                                <td width="20%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Total</div></font></td>
                              </tr>
							  <tr bgcolor="#0000FF"> 
										<td class="estilo3" align="left">Doctores Jornada completa Diurno </td>
								<td class="estilo3" align="center"><%=f_docentes_doctorado_33_44.ObtenerValor("profesores_33_a_44_Diurnos_DOCTORADO_MASCULINO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_33_44.ObtenerValor("profesores_33_a_44__DIURNO_DOCTORADO_FEMENINO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_33_44.ObtenerValor("profesores_33_a_44__DIURNO_TOTAl")%></td>
							 </tr>
							  <tr bgcolor="#0000FF"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Doctores Jornada completa Vespertino </div></td>
										<td class="estilo3" align="center"><div align="center" class="estilo3 "><%=f_docentes_doctorado_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_DOCTORADO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="estilo3 "><%=f_docentes_doctorado_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_DOCTORADO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="estilo3 "><%=f_docentes_doctorado_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_total_DOCTORADO")%></div></td>
							 </tr>
							 	 
							 	 <tr bgcolor="#0000FF"> 
										<td class="estilo3" align="left">Doctores Media Jornada Diurno </td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_20_32.ObtenerValor("profesores_20_a_32_Diurnos_DOCTORADO_MASCULINO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_20_32.ObtenerValor("profesores_20_a_32__DIURNO_DOCTORADO_FEMENINO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_20_32.ObtenerValor("profesores_20_a_32__DIURNO_TOTAl")%></td>
							 </tr>
							 <tr bgcolor="#0000FF"> 
										<td class="estilo3" align="left">Doctores Media Jornada Vespertino </td>
							   <td class="estilo3" align="center"><%=f_docentes_doctorado_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_DOCTORADO_MASCULINO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_DOCTORADO_FEMENINO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_total_DOCTORADO")%></td>
							 </tr>
							 <tr bgcolor="#0000FF"> 
										<td class="estilo3" align="left">Doctores Jornada Hora Diurno </td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_1_19.ObtenerValor("profesores_1_a_19_Diurnos_DOCTORADO_MASCULINO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_1_19.ObtenerValor("profesores_1_a_19__DIURNO_DOCTORADO_FEMENINO")%></td>
							   <td class="estilo3" align="center"><%=f_docentes_doctorado_1_19.ObtenerValor("profesores_1_a_19__DIURNO_TOTAl")%></td>
							 </tr>
							 <tr bgcolor="#0000FF"> 
										<td class="estilo3" align="left">Doctores Jornada Hora Vespertino</td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_DOCTORADO_MASCULINO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_DOCTORADO_FEMENINO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_total_DOCTORADO")%></td>
							 </tr>
							
							 <tr bgcolor="#003300"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada completa Diurno </div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_33_44.ObtenerValor("profesores_33_a_44_Diurnos_MAGISTER_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_33_44.ObtenerValor("profesores_33_a_44__DIURNO_MAGISTER_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_33_44.ObtenerValor("profesores_33_a_44__DIURNO_TOTAl")%></div></td>
							 </tr>
							 <tr bgcolor="#003300"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada completa Vespertino </div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_MAGISTER_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_MAGISTER_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_total_MAGISTER")%></div></td>
							 </tr>
							 <tr bgcolor="#003300"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Media Jornada Diurno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_20_32.ObtenerValor("profesores_20_a_32_Diurnos_MAGISTER_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_20_32.ObtenerValor("profesores_20_a_32__DIURNO_MAGISTER_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_20_32.ObtenerValor("profesores_20_a_32__DIURNO_TOTAl")%></div></td>
							 </tr>
							 <tr bgcolor="#003300"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Media Jornada Vespertino</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_MAGISTER_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_MAGISTER_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_total_MAGISTER")%></div></td>
							 </tr>
							 <tr bgcolor="#003300"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada Hora Diurno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_1_19.ObtenerValor("profesores_1_a_19_Diurnos_MAGISTER_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_1_19.ObtenerValor("profesores_1_a_19__DIURNO_MAGISTER_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_1_19.ObtenerValor("profesores_1_a_19__DIURNO_TOTAl")%></div></td>
							 </tr>
							  <tr bgcolor="#003300"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada Hora Vespertino</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_MAGISTER_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_MAGISTER_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_total_MAGISTER")%></div></td>
							 </tr>
							 <tr bgcolor="#00CC66"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados Jornada completa Diurno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_33_44.ObtenerValor("profesores_33_a_44_Diurnos_LICENCIADO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_33_44.ObtenerValor("profesores_33_a_44__DIURNO_LICENCIADO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_33_44.ObtenerValor("profesores_33_a_44__DIURNO_TOTAl")%></div></td>
							 </tr>
							  <tr bgcolor="#00CC66"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados Jornada completa Vespertino</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_LICENCIADO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_LICENCIADO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_total_LICENCIADO")%></div></td>
							 </tr>
							 <tr bgcolor="#00CC66"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados Media Jornada Diurno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_20_32.ObtenerValor("profesores_20_a_32_Diurnos_LICENCIADO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_20_32.ObtenerValor("profesores_20_a_32__DIURNO_LICENCIADO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_20_32.ObtenerValor("profesores_20_a_32__DIURNO_TOTAl")%></div></td>
							 </tr>
							  <tr bgcolor="#00CC66"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados Media Jornada Vespertino</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_LICENCIADO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_LICENCIADO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_total_LICENCIADO")%></div></td>
							 </tr>
							 <tr bgcolor="#00CC66"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Liceciados Jornada Hora Diurno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_1_19.ObtenerValor("profesores_1_a_19_Diurnos_LICENCIADO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_1_19.ObtenerValor("profesores_1_a_19__DIURNO_LICENCIADO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_1_19.ObtenerValor("profesores_1_a_19__DIURNO_TOTAl")%></div></td>
							 </tr>
							 <tr bgcolor="#00CC66"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Liceciados Jornada Hora Vespertino</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_LICENCIADO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_LICENCIADO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_total_LICENCIADO")%></div></td>
							 </tr>
							 <tr bgcolor="#99FFCC"> 
										<td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada completa Diurno</div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_33_44.ObtenerValor("profesores_33_a_44_Diurnos_PROFESIONAL_MASCULINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_33_44.ObtenerValor("profesores_33_a_44__DIURNO_PROFESIONAL_FEMENINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_33_44.ObtenerValor("profesores_33_a_44__DIURNO_TOTAl")%></div></td>
							 </tr>
							 <tr bgcolor="#99FFCC"> 
										<td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada completa Vespertino</div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_PROFESIONAL_MASCULINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_PROFESIONAL_FEMENINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_total_PROFESIONAL")%></div></td>
							 </tr>
							 <tr bgcolor="#99FFCC"> 
										<td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Media Jornada Diurno</div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_20_32.ObtenerValor("profesores_20_a_32_Diurnos_PROFESIONAL_MASCULINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_20_32.ObtenerValor("profesores_20_a_32__DIURNO_PROFESIONAL_FEMENINO")%></div></td>
										<td><div align="center" class="Estilo4"><%=f_docentes_profesional_20_32.ObtenerValor("profesores_20_a_32__DIURNO_TOTAl")%></div></td>
							 </tr>
							 <tr bgcolor="#99FFCC"> 
										<td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Media Jornada Vespertino</div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_PROFESIONAL_MASCULINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_PROFESIONAL_FEMENINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_total_PROFESIONAL")%></div></td>
							 </tr>
							 <tr bgcolor="#99FFCC"> 
										<td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada Hora Diurno</div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_1_19.ObtenerValor("profesores_1_a_19_Diurnos_PROFESIONAL_MASCULINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_1_19.ObtenerValor("profesores_1_a_19__DIURNO_PROFESIONAL_FEMENINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_1_19.ObtenerValor("profesores_1_a_19__DIURNO_TOTAl")%></div></td>
							 </tr>
							 <tr bgcolor="#99FFCC"> 
										<td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada Hora Vespertino</div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_PROFESIONAL_MASCULINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_PROFESIONAL_FEMENINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesional_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_total_PROFESIONAL")%></div></td>
							 </tr>
							 <tr bgcolor="#996600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Jornada completa Diurno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_33_44.ObtenerValor("profesores_33_a_44_Diurnos_TECNICO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_33_44.ObtenerValor("profesores_33_a_44__DIURNO_TECNICO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_33_44.ObtenerValor("profesores_33_a_44__DIURNO_TOTAl")%></div></td>
							 </tr>
							  <tr bgcolor="#996600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Jornada completa Vespertino</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_TECNICO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_TECNICO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_total_TECNICO")%></div></td>
							 </tr>
							 <tr bgcolor="#996600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Media Jornada Diurno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_20_32.ObtenerValor("profesores_20_a_32_Diurnos_TECNICO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_20_32.ObtenerValor("profesores_20_a_32__DIURNO_TECNICO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_20_32.ObtenerValor("profesores_20_a_32__DIURNO_TOTAl")%></div></td>
							 </tr>
							  <tr bgcolor="#996600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Media Jornada Vespertino</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_TECNICO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_TECNICO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_total_TECNICO")%></div></td>
							 </tr>
							 <tr bgcolor="#996600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Jornada Hora Diurno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_1_19.ObtenerValor("profesores_1_a_19_Diurnos_TECNICO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_1_19.ObtenerValor("profesores_1_a_19__DIURNO_TECNICO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_1_19.ObtenerValor("profesores_1_a_19__DIURNO_TOTAl")%></div></td>
							 </tr>
							 <tr bgcolor="#996600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Jornada Hora Vespertino</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnico_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_TECNICO_MASCULINO")%></div></td>
										<td><div align="center" class="Estilo3"><%=f_docentes_tecnico_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_TECNICO_FEMENINO")%></div></td>
										<td><div align="center" class="Estilo3"><%=f_docentes_tecnico_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_total_TECNICO")%></div></td>
							 </tr>
							 <tr bgcolor="#CC6600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada completa Diurno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_33_44.ObtenerValor("profesores_33_a_44_Diurnos_SIN_TITULO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_33_44.ObtenerValor("profesores_33_a_44__DIURNO_SIN_TITULO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_33_44.ObtenerValor("profesores_33_a_44__DIURNO_TOTAl")%></div></td>
							 </tr>
							  <tr bgcolor="#CC6600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada completa Vespertino</div></td>
									<td class="estilo3" align="center"><div align="center" class="Estilo4"><%=f_docentes_sintitulo_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_SIN_TITULO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_SIN_TITULO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_33_44.ObtenerValor("profesores_33_a_44_VESPERTINO_total_SIN_TITULO")%></div></td>
							 </tr>
							 <tr bgcolor="#CC6600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Media Jornada Diurno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_20_32.ObtenerValor("profesores_20_a_32_Diurnos_SIN_TITULO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_20_32.ObtenerValor("profesores_20_a_32__DIURNO_SIN_TITULO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_20_32.ObtenerValor("profesores_20_a_32__DIURNO_TOTAl")%></div></td>
							 </tr>
							 <tr bgcolor="#CC6600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Media Jornada Vespertino</div></td>
									<td class="estilo3" align="center"><div align="center" class="Estilo4"><%=f_docentes_sintitulo_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_SIN_TITULO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_SIN_TITULO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_20_32.ObtenerValor("profesores_20_a_32_VESPERTINO_total_SIN_TITULO")%></div></td>
							 </tr>
							 <tr bgcolor="#CC6600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada Hora Diruno</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_1_19.ObtenerValor("profesores_1_a_19_Diurnos_SIN_TITULO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_1_19.ObtenerValor("profesores_1_a_19__DIURNO_SIN_TITULO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_1_19.ObtenerValor("profesores_1_a_19__DIURNO_TOTAl")%></div></td>
							 </tr>
							  <tr bgcolor="#CC6600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada Hora Vespertino</div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_SIN_TITULO_MASCULINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_SIN_TITULO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sintitulo_1_19.ObtenerValor("profesores_1_a_19_VESPERTINO_total_SIN_TITULO")%></div></td>
							 </tr>
							 
</table>

<%end if%>

<%if tido_ccod=2 then%>


<table width="100%" border="1">
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333">
                                <div align="center"><strong> GRADOS <%=tido_tdesc%></strong></div>
                                </font></td>
                              </tr>
							    <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="60%" rowspan="1" valign="bottom"><FONT color="#333333">
                                <div align="center">Grados</div>
                                </font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Hombres</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mujeres</div></font></td>
                                <td width="20%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Total</div></font></td>
                              </tr>
							  <tr bgcolor="#0000FF"> 
										<td class="estilo3" align="left">Doctores  </td>
								        <td class="estilo3" align="center"><%=f_docentes_doctorado.ObtenerValor("profesores_DOCTORADO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado.ObtenerValor("profesores_DOCTORADO_FEMENINO")%></td>
										<td class="estilo3" align="center"><%=f_docentes_doctorado.ObtenerValor("profesores_DOCTORADO_TOTAl")%></td>
							 </tr>
							
							 	 
							 	
							
							
							 <tr bgcolor="#003300"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster   </div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister.ObtenerValor("profesores_MAGISTER")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister.ObtenerValor("profesores_DOCTORADO_MAGISTER")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_magister.ObtenerValor("profesores_MAGISTER_TOTAl")%></div></td>
							 </tr>
							 
							
							  
							 <tr bgcolor="#00CC66"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados </div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciados.ObtenerValor("profesores_LICENCIADO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciados.ObtenerValor("profesores_LICENCIADO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciados.ObtenerValor("profesores_LICENCIADO_TOTAl")%></div></td>
							 </tr>
							
							 
							 
							 <tr bgcolor="#99FFCC"> 
										<td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales </div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesionales.ObtenerValor("profesores_PROFESIONAL")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesionales.ObtenerValor("profesores_PROFESIONAL_FEMENINO")%></div></td>
										<td class="estilo4" align="center"><div align="center" class="Estilo4"><%=f_docentes_profesionales.ObtenerValor("profesores_PROFESIONAL_TOTAl")%></div></td>
							 </tr>
							 
							 
							 
							 <tr bgcolor="#996600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior </div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnicos.ObtenerValor("profesores_TECNICO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnicos.ObtenerValor("profesores_TECNICO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_tecnicos.ObtenerValor("profesores_TECNICO_TOTAl")%></div></td>
							 </tr>
							  
							 
							 
							 <tr bgcolor="#CC6600"> 
										<td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado </div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sin_titulo.ObtenerValor("profesores_SIN_TITULO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sin_titulo.ObtenerValor("profesores_SIN_TITULO_FEMENINO")%></div></td>
										<td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_sin_titulo.ObtenerValor("profesores_SIN_TITULO_TOTAl")%></div></td>
							 </tr>
							  
							 
							  
							 
</table>

<%end if%>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>