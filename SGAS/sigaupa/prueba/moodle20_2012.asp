<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conectar = new CConexion
conectar.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

'/////////////////////////////////categoria madre///////////////////////////////////////
response.Write("<br>-------///////////////////categoría madre////////////////////////////")
'iniciamos el código de la ultima categoria registrada
ultima_categoria = 510
ultimo_contexto = 281129
ultimo_cache_flacs = 165705

ultimo_curso = 16535
ultima_seccion = 89595
block_instance = 106381
ultimo_log = 7588999
id_forum = 21525
course_modules = 108555
ultimo_enrol = 186187
ultimo_user_lastaccess = 186187
ultimo_user_preferencies = 186187

path_contexto = "/1"

c_facultades_nuevas =  "  select count(distinct f.facu_ccod) " & vbCrLf &_
					   "  from alumnos a, ofertas_academicas b, especialidades c, carreras d, areas_academicas e, facultades f,sedes g " & vbCrLf &_
					   "  where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod in (226) " & vbCrLf &_
					   "  and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrLf &_
					   "  and d.area_ccod=e.area_ccod and e.facu_ccod=f.facu_ccod and f.facu_ccod=2 " & vbCrLf &_
					   "  and b.sede_ccod=g.sede_ccod and a.emat_ccod=1 " & vbCrLf &_
					   "  and not exists (select 1 from moodle_course_categories tt where tt.facu_ccod = f.facu_ccod ) " & vbCrLf &_
					   "  and exists(select 1 from secciones aa where peri_ccod in (226) and aa.sede_ccod=b.sede_ccod " & vbCrLf &_
					   "             and aa.carr_ccod=d.carr_ccod and aa.jorn_ccod=b.jorn_ccod) "

facultades_nuevas = conectar.consultaUno(c_facultades_nuevas)


c_escuelas_nuevas = "  select distinct protic.initCap(facu_tdesc) as facu_tdesc, " & vbCrLf &_
					"  ltrim(rtrim(protic.initcap(g.sede_tdesc)))+' : ' + ltrim(rtrim(protic.initcap(d.carr_tdesc)))+ " & vbCrLf &_
					"  case b.jorn_ccod when 1 then ' (D)' else ' (V)' end as escuela,f.facu_ccod,g.sede_ccod,d.carr_ccod,b.jorn_ccod  " & vbCrLf &_
					"  from alumnos a, ofertas_academicas b, especialidades c, carreras d, areas_academicas e, facultades f,sedes g " & vbCrLf &_
					"  where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod in (226) " & vbCrLf &_
					"  and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrLf &_
					"  and d.area_ccod=e.area_ccod and e.facu_ccod=f.facu_ccod " & vbCrLf &_
					"  and b.sede_ccod=g.sede_ccod and a.emat_ccod=1 " & vbCrLf &_
					"  and exists(select 1 from secciones aa where peri_ccod in (226) and aa.sede_ccod=b.sede_ccod " & vbCrLf &_
					"  and aa.carr_ccod=d.carr_ccod and aa.jorn_ccod=b.jorn_ccod) " & vbCrLf &_
					"  and not exists (select 1 from moodle_course_categories  tt where tt.sede_ccod = g.sede_ccod and tt.jorn_ccod = b.jorn_ccod and tt.carr_ccod = d.carr_ccod ) "& vbCrLf &_
					"  and exists(select 1 from moodle_course_categories bb where bb.facu_ccod=f.facu_ccod) "

escuelas_nuevas =conectar.consultaUno(c_escuelas_nuevas)
		

c_cursos_nuevos   =   "  select facu_ccod,sede_ccod,carr_ccod,jorn_ccod,asig_ccod,seccion,asig_tdesc + ' ('+seccion+')' as nombre_largo, " & vbCrLf &_
					"  asig_ccod + '('+seccion+')' as nombre_corto, " & vbCrLf &_
				    "  cast(sede_ccod as varchar)+'-'+carr_ccod+'-'+cast(jorn_ccod as varchar)+'-'+asig_ccod+'-'+seccion as id " & vbCrLf &_
					"  from " & vbCrLf &_
					"  ( " & vbCrLf &_
					"  select distinct ltrim(rtrim(a.sede_ccod)) as sede_ccod, ltrim(rtrim(a.carr_ccod)) as carr_ccod,ltrim(rtrim(a.jorn_ccod)) as jorn_ccod, " & vbCrLf &_
					"  ltrim(rtrim(a.asig_ccod)) as asig_ccod, ltrim(rtrim(c.asig_tdesc)) as asig_tdesc, " & vbCrLf &_
					"  substring(ltrim(rtrim(a.secc_tdesc)),1,1) as seccion,f.facu_ccod   " & vbCrLf &_
					"  from secciones a, periodos_academicos b,asignaturas c, carreras d, areas_academicas e, facultades f " & vbCrLf &_
					"  where a.peri_ccod=b.peri_ccod and cast(b.peri_ccod as varchar)='226' " & vbCrLf &_
					"  and a.asig_ccod=c.asig_ccod and a.carr_ccod=d.carr_ccod " & vbCrLf &_
					"  and d.area_ccod=e.area_ccod and e.facu_ccod=f.facu_ccod --and a.carr_ccod not in ('7','500','700','400') " & vbCrLf &_
					"  and exists (select 1 from moodle_course_categories bb where bb.facu_ccod=f.facu_ccod) " & vbCrLf &_
					"  and exists (select 1 from bloques_horarios cc where a.secc_ccod=cc.secc_ccod) " & vbCrLf &_
					"  and not exists (select 1 from moodle_course  tt where tt.asig_ccod=a.asig_ccod and tt.sede_ccod = a.sede_ccod and tt.jorn_ccod = a.jorn_ccod and tt.carr_ccod=a.carr_ccod and cast(tt.seccion as varchar) = substring(a.secc_tdesc,1,1) and isnull(periodo,'0') = '0'" & vbCrLf &_
					"  and isnull((select codigo_en_moodle from moodle_course_categories tt where tt.sede_ccod = a.sede_ccod and tt.jorn_ccod = a.jorn_ccod and tt.carr_ccod = a.carr_ccod),0) <> 0 "& vbCrLf &_
					"  and c.asig_tdesc not like '%seleccion%'  " &vbCrLf &_ 
					"  and c.asig_tdesc not like '%reserva%' " &vbCrLf &_
					"  )table1 " 

cursos_nuevos =conectar.consultaUno(c_cursos_nuevos)

response.End()
			
categoria_padre = ultima_categoria
set formulario_facultad 		= 		new cFormulario
formulario_facultad.carga_parametros	"tabla_vacia.xml",	"tabla"
formulario_facultad.inicializar		conectar
consulta = "  select distinct protic.initCap(facu_tdesc) as facu_tdesc, f.facu_ccod " & vbCrLf &_
		   "  from alumnos a, ofertas_academicas b, especialidades c, carreras d, areas_academicas e, facultades f,sedes g " & vbCrLf &_
		   "  where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod in (226) " & vbCrLf &_
		   "  and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrLf &_
		   "  and d.area_ccod=e.area_ccod and e.facu_ccod=f.facu_ccod and f.facu_ccod=2 " & vbCrLf &_
		   "  and b.sede_ccod=g.sede_ccod and a.emat_ccod=1 " & vbCrLf &_
		   "  and exists(select 1 from secciones aa where peri_ccod in (226) and aa.sede_ccod=b.sede_ccod " & vbCrLf &_
		   "             and aa.carr_ccod=d.carr_ccod and aa.jorn_ccod=b.jorn_ccod) " & vbCrLf &_
		   "  union " & vbCrLf &_
		   "  select protic.initCap('INSTITUCIONALES') as facu_tdesc, 7 as facu_ccod  " & vbCrLf &_
		   "  order by facu_tdesc" 
formulario_facultad.consultar 		consulta
response.Write("<br><br>///////////////////FACULTADES////////////////////////////<br>")
while formulario_facultad.siguiente
	facu_tdesc = formulario_facultad.obtenerValor("facu_tdesc")
	facu_ccod  = formulario_facultad.obtenerValor("facu_ccod")
	path_contexto = conectar.consultaUno("select ltrim(rtrim(path_context)) from moodle_course_categories where cast(id as varchar)='"&categoria_padre&"'")
	grabado = conectar.consultaUno("select count(*) from moodle_course_categories where cast(facu_ccod as varchar)='"&facu_ccod&"'")
	if grabado = "0" then 
		ultima_categoria = ultima_categoria + 1
		codigo_categoria = "/"&categoria_padre&"/"&ultima_categoria
		c_inserta2 = " insert into mdl_course_categories (id,name,id_number,description,descriptionformat,parent,sortorder,coursecount,visible,visibleold,timemodified,depth,path,theme) " & vbCrLf &_ 
					 " values ("&ultima_categoria&",'"&facu_tdesc&"',"&ultima_categoria&",NULL,1,"&categoria_padre&",10000,0,1,1,0,2,'"&codigo_categoria&"',NULL);"
        response.Write("<pre>"&c_inserta2&"</pre>")
        
		ultimo_contexto= ultimo_contexto + 1			
		path_contexto = path_contexto&"/"&ultimo_contexto			
		c_inserta2_contexto = " insert into mdl_context (id,contextlevel,instanceid,path,deph) " & vbCrLf &_ 
        		              " values ("&ultimo_contexto&",40,"&ultima_categoria&",'"&path_contexto&"',3);"
        response.Write("<pre>"&c_inserta2_contexto&"</pre>")
        
		ultimo_cache_flacs = ultimo_cache_flacs + 1
	    c_cache_flacs = " insert into mdl_cache_flags (id,flagtype,name,timemodified,value,expiry) "&_
		  		        " values ("&ultimo_cache_flacs&",'accesslib/dirtycontexts','"&path_contexto&"',1337955500,1,1337962700);"
        response.Write("<pre>"&c_cache_flacs&"</pre>")
		
		
		
		'SIGAUPA
		c_inserta2_sga = " insert into moodle_course_categories (id,name,description,parent,sortorder,coursecount,visible,timemodified,depth,path,facu_ccod,path_context,codigo_en_moodle) " & vbCrLf &_ 
						 " values ("&ultima_categoria&",'"&facu_tdesc&"',NULL,"&categoria_padre&",999,0,1,0,2,'"&codigo_categoria&"',"&facu_ccod&",'"&path_contexto&"',"&ultima_categoria&");"
		conectar.EjecutaS(c_inserta2_sga)
		'--------------------------------

	end if
wend
response.Write("<br><br>-------////////////////////CARRERAS///////////////////////////////</br>")
set formulario_escuela 		= 		new cFormulario
formulario_escuela.carga_parametros	"tabla_vacia.xml",	"tabla"
formulario_escuela.inicializar		conectar
consulta_escuela =  "  select distinct protic.initCap(facu_tdesc) as facu_tdesc, " & vbCrLf &_
					"  ltrim(rtrim(protic.initcap(g.sede_tdesc)))+' : ' + ltrim(rtrim(protic.initcap(d.carr_tdesc)))+ " & vbCrLf &_
					"  case b.jorn_ccod when 1 then ' (D)' else ' (V)' end as escuela,f.facu_ccod,g.sede_ccod,d.carr_ccod,b.jorn_ccod  " & vbCrLf &_
					"  from alumnos a, ofertas_academicas b, especialidades c, carreras d, areas_academicas e, facultades f,sedes g " & vbCrLf &_
					"  where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod in (226) " & vbCrLf &_
					"  and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrLf &_
					"  and d.area_ccod=e.area_ccod and e.facu_ccod=f.facu_ccod " & vbCrLf &_
					"  and b.sede_ccod=g.sede_ccod and a.emat_ccod=1 " & vbCrLf &_
					"  and exists(select 1 from secciones aa where peri_ccod in (226) and aa.sede_ccod=b.sede_ccod " & vbCrLf &_
					"  and aa.carr_ccod=d.carr_ccod and aa.jorn_ccod=b.jorn_ccod) " & vbCrLf &_
					"  and exists(select 1 from moodle_course_categories bb where bb.facu_ccod=f.facu_ccod) " & vbCrLf &_
					"  order by facu_tdesc, escuela " 
formulario_escuela.consultar  consulta_escuela
while formulario_escuela.siguiente
	facu_tdesc = formulario_escuela.obtenerValor("facu_tdesc")
	facu_ccod  = formulario_escuela.obtenerValor("facu_ccod")
	sede_ccod  = formulario_escuela.obtenerValor("sede_ccod")
	carr_ccod  = formulario_escuela.obtenerValor("carr_ccod")
	jorn_ccod  = formulario_escuela.obtenerValor("jorn_ccod")
	escuela    = formulario_escuela.obtenerValor("escuela")
	padre = conectar.consultaUno("select codigo_en_moodle from moodle_course_categories where cast(facu_ccod as varchar)='"&facu_ccod&"'")
	categoria_padre = conectar.consultaUno("select path from moodle_course_categories where cast(facu_ccod as varchar)='"&facu_ccod&"'")
	path_contexto = conectar.consultaUno("select ltrim(rtrim(path_context)) from moodle_course_categories where cast(id as varchar)='"&padre&"'")
	grabado = conectar.consultaUno("select count(*) from moodle_course_categories where cast(sede_ccod as varchar)='"&sede_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' and carr_ccod='"&carr_ccod&"'")
	if grabado = "0" then 
		ultima_categoria = ultima_categoria + 1
		codigo_categoria = categoria_padre&"/"&ultima_categoria
		c_inserta3 = " insert into mdl_course_categories (id,name,idnumber,description,descriptionformat,parent,sortorder,coursecount,visible,visibleold,timemodified,depth,path,theme) " & vbCrLf &_ 
					" values ("&ultima_categoria&",'"&escuela&"',"&ultima_categoria&",NULL,1,"&padre&",30000,1,1,1,0,3,'"&codigo_categoria&"',NULL);"
		response.Write("<pre>"&c_inserta3&"</pre>")
		
		ultimo_contexto= ultimo_contexto + 1			
		path_contexto = path_contexto&"/"&ultimo_contexto			
		c_inserta3_contexto = " insert into mdl_context (id,contextlevel,instanceid,path,depth) " & vbCrLf &_ 
        		             " values ("&ultimo_contexto&",40,"&ultima_categoria&",'"&path_contexto&"',4);"
		response.Write("<pre>"&c_inserta3_contexto&"</pre>")
		
		ultimo_cache_flacs = ultimo_cache_flacs + 1
	    c_cache_flacs = " insert into mdl_cache_flags (id,flagtype,name,timemodified,value,expiry) "&_
		  		        " values ("&ultimo_cache_flacs&",'accesslib/dirtycontexts','"&path_contexto&"',1337955500,1,1337962700);"
		response.Write("<pre>"&c_cache_flacs&"</pre>")
		
		
		'SIGAUPA
		c_inserta3_sga = " insert into moodle_course_categories (id,name,description,parent,sortorder,coursecount,visible,timemodified,depth,path,sede_ccod,carr_ccod,jorn_ccod,path_context,codigo_en_moodle) " & vbCrLf &_ 
						 " values ("&ultima_categoria&",'"&escuela&"',NULL,"&padre&",999,0,1,0,3,'"&codigo_categoria&"',"&sede_ccod&",'"&carr_ccod&"',"&jorn_ccod&",'"&path_contexto&"',"&ultima_categoria&");"
		conectar.EjecutaS(c_inserta3_sga)
		'--------------------------------					 
		
	end if
wend
response.Write("<br><br>////////////////////////ASIGNATURAS/////////////////////////////<br>")
set formulario_cursos 		= 		new cFormulario
formulario_cursos.carga_parametros	"tabla_vacia.xml",	"tabla"
formulario_cursos.inicializar		conectar
consulta_cursos =   "  select facu_ccod,sede_ccod,carr_ccod,jorn_ccod,asig_ccod,seccion,asig_tdesc + ' ('+seccion+')' as nombre_largo, " & vbCrLf &_
					"  asig_ccod + '('+seccion+')' as nombre_corto, " & vbCrLf &_
				    "  cast(sede_ccod as varchar)+'-'+carr_ccod+'-'+cast(jorn_ccod as varchar)+'-'+asig_ccod+'-'+seccion as id " & vbCrLf &_
					"  from " & vbCrLf &_
					"  ( " & vbCrLf &_
					"  select distinct ltrim(rtrim(a.sede_ccod)) as sede_ccod, ltrim(rtrim(a.carr_ccod)) as carr_ccod,ltrim(rtrim(a.jorn_ccod)) as jorn_ccod, " & vbCrLf &_
					"  ltrim(rtrim(a.asig_ccod)) as asig_ccod, ltrim(rtrim(c.asig_tdesc)) as asig_tdesc, " & vbCrLf &_
					"  substring(ltrim(rtrim(a.secc_tdesc)),1,1) as seccion,f.facu_ccod   " & vbCrLf &_
					"  from secciones a, periodos_academicos b,asignaturas c, carreras d, areas_academicas e, facultades f " & vbCrLf &_
					"  where a.peri_ccod=b.peri_ccod and cast(b.peri_ccod as varchar)='226' " & vbCrLf &_
					"  and a.asig_ccod=c.asig_ccod and a.carr_ccod=d.carr_ccod " & vbCrLf &_
					"  and d.area_ccod=e.area_ccod and e.facu_ccod=f.facu_ccod --and a.carr_ccod not in ('7','500','700','400') " & vbCrLf &_
					"  and exists (select 1 from moodle_course_categories bb where bb.facu_ccod=f.facu_ccod) " & vbCrLf &_
					"  and exists (select 1 from bloques_horarios cc where a.secc_ccod=cc.secc_ccod) " & vbCrLf &_
					"  --and exists (select 1 from cargas_academicas dd where a.secc_ccod=dd.secc_ccod) " & vbCrLf &_
					"  and c.asig_tdesc not like '%seleccion%'  " &vbCrLf &_ 
					"  and c.asig_tdesc not like '%reserva%' " &vbCrLf &_
					"  )table1 " & vbCrLf &_
					"  order by sede_ccod,jorn_ccod,asig_ccod,seccion "  
formulario_cursos.consultar  consulta_cursos
while formulario_cursos.siguiente
	facu_ccod  = formulario_cursos.obtenerValor("facu_ccod")
	sede_ccod  = formulario_cursos.obtenerValor("sede_ccod")
	carr_ccod  = formulario_cursos.obtenerValor("carr_ccod")
	jorn_ccod  = formulario_cursos.obtenerValor("jorn_ccod")
	asig_ccod  = formulario_cursos.obtenerValor("asig_ccod")
	seccion  = formulario_cursos.obtenerValor("seccion")
	nombre_largo    = formulario_cursos.obtenerValor("nombre_largo")
	nombre_corto    = formulario_cursos.obtenerValor("nombre_corto")
	id    = formulario_cursos.obtenerValor("id")
	padre = conectar.consultaUno("select codigo_en_moodle from moodle_course_categories where cast(sede_ccod as varchar)='"&sede_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' and carr_ccod='"&carr_ccod&"'")
	path_contexto = conectar.consultaUno("select ltrim(rtrim(path_context)) from . where cast(id as varchar)='"&padre&"'")
	grabado = conectar.consultaUno("select count(*) from moodle_course where asig_ccod='"&asig_ccod&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' and carr_ccod='"&carr_ccod&"' and cast(seccion as varchar)='"&seccion&"' and isnull(periodo,'0') = '0'")
	if grabado = "0" and padre <> "" then 
		
		ultimo_curso = ultimo_curso + 1
        c_inserta4 = " insert into mdl_course (id,category,sortorder,fullname,shortname,idnumber,summary,summaryformat,format,showgrades,modinfo,newsitems,startdate,numsections,marker,maxbytes,legacyfiles,showreports,visible,visibleold,hiddensections,groupmode,groupmodeforce,defaultgroupingid,lang,theme,timecreated,timemodified,requested,restrictmodules,enablecompletion,completionstartonenrol,completionnotify) " & vbCrLf &_
					 " values("&ultimo_curso&","&padre&",30001,'"&nombre_largo&"','"&id&"','"&id&"','BIENVENIDO A LA ASIGNATURA "&nombre_largo&"',1,'topics',1,'',5,1218423600,10,0,268435456,0,0,1,1,0,0,0,0,0,'','',1337956708,1337956708,0,0,0,0,0);"
        response.Write("<pre>"&c_inserta4&"</pre>")
		
		ultima_seccion = ultima_seccion + 1
		primera_seccion = ultima_seccion
		c_inserta4_sesion = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					        " values ("&ultima_seccion&","&ultimo_curso&",0,NULL,NULL,1,2,1); "
		response.Write("<pre>"&c_inserta4_sesion&"</pre>")
							
        ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion1 = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					         " values ("&ultima_seccion&","&ultimo_curso&",1,NULL,'',1,null,1); "
		response.Write("<pre>"&c_inserta4_sesion1&"</pre>")

		ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion2 = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					         " values ("&ultima_seccion&","&ultimo_curso&",2,NULL,'',1,null,1); "
		response.Write("<pre>"&c_inserta4_sesion2&"</pre>")
		
        ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion3 = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					         " values ("&ultima_seccion&","&ultimo_curso&",3,NULL,'',1,null,1); "
		response.Write("<pre>"&c_inserta4_sesion3&"</pre>")
		
		ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion4 = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					         " values ("&ultima_seccion&","&ultimo_curso&",4,NULL,'',1,null,1); "
		response.Write("<pre>"&c_inserta4_sesion4&"</pre>")
 
		ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion5 = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					         " values ("&ultima_seccion&","&ultimo_curso&",5,NULL,'',1,null,1); "
		response.Write("<pre>"&c_inserta4_sesion5&"</pre>")
		
		ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion6 = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					         " values ("&ultima_seccion&","&ultimo_curso&",6,NULL,'',1,null,1); "
		response.Write("<pre>"&c_inserta4_sesion6&"</pre>")
		
		ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion7 = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					         " values ("&ultima_seccion&","&ultimo_curso&",7,NULL,'',1,null,1); "
		response.Write("<pre>"&c_inserta4_sesion7&"</pre>")
		
		ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion8 = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					         " values ("&ultima_seccion&","&ultimo_curso&",8,NULL,'',1,null,1); "
		response.Write("<pre>"&c_inserta4_sesion8&"</pre>")
		
		ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion9 = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					         " values ("&ultima_seccion&","&ultimo_curso&",9,NULL,'',1,null,1); "
		response.Write("<pre>"&c_inserta4_sesion9&"</pre>")
		
		ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion10 = " insert into mdl_course_sections (id,course,section,name,summary,summaryformat,sequence,visible) " & vbCrLf &_
					         " values ("&ultima_seccion&","&ultimo_curso&",10,NULL,'',1,null,1); "							 							
		response.Write("<pre>"&c_inserta4_sesion10&"</pre>")
					 
        ultimo_contexto= ultimo_contexto + 1			
		path_contexto = path_contexto&"/"&ultimo_contexto
		path_contexto_curso = path_contexto			
		c_inserta4_contexto = " insert into mdl_context (id,contextlevel,instanceid,path,depth) " & vbCrLf &_ 
        		              " values ("&ultimo_contexto&",50,"&ultimo_curso&",'"&path_contexto&"',5);"					 					 
        response.Write("<pre>"&c_inserta4_contexto&"</pre>")

	   id_course    = ultimo_curso
       id_context_curso = ultimo_contexto
	
	   block_instance = block_instance + 1
	   c_block_0 = " insert into mdl_block_instance (id,blockname,parentcontextid,showinsubcontexts,pagetypepattern,subpagepattern,defaultregion,defaultweight,configdata) "&_
		     	   " values ("&block_instance&",'search_forums',"&id_context_curso&",0,'course-view-*',NULL,'side-post',0,'');"  
	   response.Write("<pre>"&c_block_0&"</pre>")

	   ultimo_contexto= ultimo_contexto + 1			
	   path_contexto = path_contexto_curso&"/"&ultimo_contexto			
	   c_inserta4_contexto1 = " insert into mdl_context (id,contextlevel,instanceid,path,depth) " & vbCrLf &_ 
          		              " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"',6);"
   	   response.Write("<pre>"&c_inserta4_contexto1&"</pre>")
	
	   block_instance = block_instance + 1
	   c_block_1 = " insert into mdl_block_instance (id,blockname,parentcontextid,showinsubcontexts,pagetypepattern,subpagepattern,defaultregion,defaultweight,configdata) "&_
		   		   " values ("&block_instance&",'news_items',"&id_context_curso&",0,'course-view-*',NULL,'side-post',1,'');" 
       response.Write("<pre>"&c_block_1&"</pre>")

	   ultimo_contexto= ultimo_contexto + 1			
	   path_contexto = path_contexto_curso&"/"&ultimo_contexto			
	   c_inserta4_contexto2 = " insert into mdl_context (id,contextlevel,instanceid,path,depth) " & vbCrLf &_ 
          		              " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"',6);"
	   response.Write("<pre>"&c_inserta4_contexto2&"</pre>")

	   block_instance = block_instance + 1
	   c_block_2 = " insert into mdl_block_instance (id,blockname,parentcontextid,showinsubcontexts,pagetypepattern,subpagepattern,defaultregion,defaultweight,configdata) "&_
				   " values ("&block_instance&",'calendar_upcoming',"&id_context_curso&",0,'course-view-*',NULL,'side-post',2,'');"  
       response.Write("<pre>"&c_block_2&"</pre>")
	
	   ultimo_contexto= ultimo_contexto + 1			
	   path_contexto = path_contexto_curso&"/"&ultimo_contexto			
	   c_inserta4_contexto3 = " insert into mdl_context (id,contextlevel,instanceid,path,depth) " & vbCrLf &_ 
           		              " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"',6);"
       response.Write("<pre>"&c_inserta4_contexto3&"</pre>")
		   	
 	   block_instance = block_instance + 1
       c_block_3 = " insert into mdl_block_instance (id,blockname,parentcontextid,showinsubcontexts,pagetypepattern,subpagepattern,defaultregion,defaultweight,configdata) "&_
		   		   " values ("&block_instance&",'recent_activity',"&id_context_curso&",0,'course-view-*',NULL,'side-post',3,'');"
	   response.Write("<pre>"&c_block_3&"</pre>")
		
	   ultimo_contexto= ultimo_contexto + 1			
	   path_contexto = path_contexto_curso&"/"&ultimo_contexto			
	   c_inserta4_contexto4 = " insert into mdl_context (id,contextlevel,instanceid,path,depth) " & vbCrLf &_ 
          		              " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"',6);"
       response.Write("<pre>"&c_inserta4_contexto4&"</pre>")
		
       ultimo_cache_flacs = ultimo_cache_flacs + 1
	   c_cache_flacs = " insert into mdl_cache_flags (id,flagtype,name,timemodified,value,expiry) "&_
				       " values ("&ultimo_cache_flacs&",'accesslib/dirtycontexts','"&path_contexto_curso&"',1337956708,1,1337963908);"
       response.Write("<pre>"&c_cache_flacs&"</pre>")
		
       ultimo_log = ultimo_log + 1
	   c_mdl_log = " insert into mdl_log (id,time,userid,ip,course,module,cmid,action,url,info) "&_
				   " values ("&ultimo_log&",1337956709,2,'0:0:0:0:0:0:0:1',1,'course',0,'new','view.php?id="&id_course&"','"&nombre_largo&" (ID "&id_course&")' );"
	   response.Write("<pre>"&c_mdl_log&"</pre>")
		
	   ultimo_log = ultimo_log + 1
	   c_mdl_log2= " insert into mdl_log (id,time,userid,ip,course,module,cmid,action,url,info) "&_
		   		   " values ("&ultimo_log&",1337956709,2,'0:0:0:0:0:0:0:1',"&id_course&",'course',0,'new','view.php?id="&id_course&"','"&id_course&"');"
	   response.Write("<pre>"&c_mdl_log2&"</pre>")
	
	   ultimo_log = ultimo_log + 1
	   c_mdl_log3= " insert into mdl_log (id,time,userid,ip,course,module,cmid,action,url,info) "&_
				   " values ("&ultimo_log&",1337956709,2,'0:0:0:0:0:0:0:1',"&id_course&",'course',0,'new','view.php?id="&id_course&"','"&id_course&"');"
	   response.Write("<pre>"&c_mdl_log3&"</pre>")

	   ultimo_log = ultimo_log + 1
	   c_mdl_log4= " insert into mdl_log (id,time,userid,ip,course,module,cmid,action,url,info) "&_
				   " values ("&ultimo_log&",1337956709,2,'0:0:0:0:0:0:0:1',"&id_course&",'course',0,'new','view.php?id="&id_course&"','"&id_course&"');"			
	   response.Write("<pre>"&c_mdl_log4&"</pre>")
		
	   id_seccion   = ultima_seccion
	   id_forum = id_forum + 1
	   c_forum =   " insert into mdl_forum (id,course,type,name,intro,introformat,assessed,assesstimestart,assesstimefinish,scale,maxbytes,maxattachments,forcesubscribe,trackingtype,rsstype,rssarticles,timemodified,warnafter,blockafter,blockperiod,completiondiscussions,completionreplies,completionposts)"&_ 
			    " values("&id_forum&","&id_course&",'news','Novedades','Novedades y anuncios',0,0,0,0,0,0,1,1,1,0,0,1337956721,0,0,0,0,0,0);"
	   response.Write("<pre>"&c_forum&"</pre>")
	   
	
	   course_modules = course_modules + 1
       c_modulos = " insert into mdl_course_modules (id,course,module,instance,section,idnumber,added,score,indent,visible,visibleold,groupmode,groupingid,groupmembersonly,completion,completiongradeitemnumber,completionview,completionexpected,availablefrom,availableuntil,showavailability,showdescription) "&_
		   		   " values ("&course_modules&","&id_course&",7,"&id_forum&","&primera_seccion&",NULL,1337956721,0,0,1,1,0,0,0,0,NULL,0,0,0,0,0,0);"
	   response.Write("<pre>"&c_modulos&"</pre>")
	   
       ultimo_contexto= ultimo_contexto + 1			
	   path_contexto = path_contexto_curso&"/"&ultimo_contexto			
	   c_inserta4_contexto5 = " insert into mdl_context (id,contextlevel,instanceid,path,depth) " & vbCrLf &_ 
        		              " values ("&ultimo_contexto&",70,"&id_forum&",'"&path_contexto&"',6);"
	   response.Write("<pre>"&c_inserta4_contexto5&"</pre>")
	   
		ultimo_enrol= ultimo_enrol + 1			
		c_inserta_enrol = " insert into mdl_enrol (id,enrol,status,courseid,sortorder,name,enrolperiod,enrolstartdate,enrolenddate,expirynotify,expirythreshold,notifyall,password,cost,currency,roleid,customint1,customint2,customint3,customint4,customchar1,customchar2,customdec1,customdec2,customtext1,customtext2,timecreated,timemodified) " & vbCrLf &_ 
						  " values ("&ultimo_enrol&",'manual',0,"&id_course&",0,NULL,0,0,0,0,0,0,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1337956709,1337956709);"
		response.Write("<pre>"&c_inserta_enrol&"</pre>")
	
		ultimo_enrol= ultimo_enrol + 1			
		c_inserta_enrol2= " insert into mdl_enrol (id,enrol,status,courseid,sortorder,name,enrolperiod,enrolstartdate,enrolenddate,expirynotify,expirythreshold,notifyall,password,cost,currency,roleid,customint1,customint2,customint3,customint4,customchar1,customchar2,customdec1,customdec2,customtext1,customtext2,timecreated,timemodified) " & vbCrLf &_ 
						  " values ("&ultimo_enrol&",'guest',1,"&id_course&",1,NULL,0,0,0,0,0,0,'',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1337956709,1337956709);"
		response.Write("<pre>"&c_inserta_enrol2&"</pre>")
	  
		ultimo_enrol= ultimo_enrol + 1			
		c_inserta_enrol3= " insert into mdl_enrol (id,enrol,status,courseid,sortorder,name,enrolperiod,enrolstartdate,enrolenddate,expirynotify,expirythreshold,notifyall,password,cost,currency,roleid,customint1,customint2,customint3,customint4,customchar1,customchar2,customdec1,customdec2,customtext1,customtext2,timecreated,timemodified) " & vbCrLf &_ 
						  " values ("&ultimo_enrol&",'self',2,"&id_course&",0,NULL,0,0,0,0,0,0,NULL,NULL,NULL,5,0,0,0,1,NULL,NULL,NULL,NULL,NULL,NULL,1337956709,1337956709);"
		response.Write("<pre>"&c_inserta_enrol3&"</pre>")
	
		ultimo_user_lastaccess= ultimo_user_lastaccess + 1			
		c_inserta_user_lastaccess = " insert into mdl_user_lastaccess (id,userid,courseid,timeaccess) " & vbCrLf &_ 
									" values ("&ultimo_user_lastaccess&",2,"&id_course&",1337956709);"
		response.Write("<pre>"&c_inserta_user_lastaccess&"</pre>")
	
		ultimo_user_preferencies= ultimo_user_preferencies + 1			
		c_inserta_user_preferencies = " insert into mdl_user_preferencies (id,userid,name,value) " & vbCrLf &_ 
									  " values ("&ultimo_user_preferencies&",2,'course_edit_form_showadvanced',1);"
		response.Write("<pre>"&c_inserta_user_preferencies&"</pre>")
		

		'SIGAUPA
		c_inserta4_sga = " insert into moodle_course (id,category,sortorder,password,fullname,shortname,idnumber,summary,format,showgrades,modinfo,newsitems,teacher, " & vbCrLf &_
                         " teachers,student,students,guest,startdate,enrolperiod,numsections,marker,maxbytes,showreports,visible, " & vbCrLf &_
                         " hiddensections,groupmode,groupmodeforce,lang,theme,cost,currency,timecreated, " & vbCrLf &_
                         " timemodified,metacourse,requested,restrictmodules,expirynotify,expirythreshold,notifystudents, " & vbCrLf &_
                         " enrollable,enrolstartdate,enrolenddate,enrol,defaultrole,sede_ccod,carr_ccod,jorn_ccod,asig_ccod,seccion,path_context)   " & vbCrLf &_
					     " values("&ultimo_curso&","&padre&",2003,'','"&nombre_largo&"','"&id&"','"&id&"','','topics',1,'',5,'Profesor','Profesores','Estudiante','Estudiantes',0,1218423600,0,6,0,268435456,0,1,0,0,0,'','','','USD',1217598726,1217599526,0,0,0,0,0,0,1,0,0,'',0,"&sede_ccod&",'"&carr_ccod&"',"&jorn_ccod&",'"&asig_ccod&"',"&seccion&",'"&path_contexto&"');"
		conectar.EjecutaS(c_inserta4_sga)	
		
		c_bloque_SGA = " insert into sd_cursos_moodle_sin_bloques (id_seccion,id_curso,con_bloque) " & vbCrLf &_
					   " values ("&ultima_seccion&","&ultimo_curso&",'NO')"
		conectar.EjecutaS(c_bloque_SGA)
		'------------------------------		 
		
	end if
wend

set formulario_actualiza =	new cFormulario
formulario_actualiza.carga_parametros	"tabla_vacia.xml",	"tabla"
formulario_actualiza.inicializar		conectar
consulta = "  select a.id, a.sede_ccod,a.carr_ccod,a.jorn_ccod, " & vbCrLf &_
		   "  (select count(*) from moodle_course b where a.sede_ccod=b.sede_ccod and a.carr_ccod=b.carr_ccod and a.jorn_ccod=b.jorn_ccod and isnull(periodo,'0') = '0') as total_cursos " & vbCrLf &_
		   "  from moodle_course_categories a " & vbCrLf &_
		   "  where isnull(a.sede_ccod,0) <> 0 " & vbCrLf &_
		   "  and isnull(a.carr_ccod,'0') <> '0' " & vbCrLf &_
		   "  and isnull(a.jorn_ccod,0) <> 0 " 
		   
formulario_actualiza.consultar 		consulta
response.Write("<br><br>-------///////////////////Actualizar////////////////////////////")
while formulario_actualiza.siguiente
	id = formulario_actualiza.obtenerValor("id")
	sede_ccod = formulario_actualiza.obtenerValor("sede_ccod")
	carr_ccod = formulario_actualiza.obtenerValor("carr_ccod")
	jorn_ccod = formulario_actualiza.obtenerValor("jorn_ccod")
	total = formulario_actualiza.obtenerValor("total_cursos")
	c_update5 = " update mdl_course_categories  set coursecount = "&total & vbCrLf &_ 
    		   " where id="&id&";"
	'c_inserta = " insert into mdl_course_categories (id,name,description,parent,sortorder,coursecount,visible,timemodified,depth,path,theme) " & vbCrLf &_ 
	'            " values ("&ultima_categoria&",'"&facu_tdesc&"',NULL,"&categoria_padre&",999,0,1,0,2,'"&codigo_categoria&"',null);"
 	c_update5_sga = " update moodle_course_categories  set coursecount = "&total & vbCrLf &_ 
    		       " where id="&id&";"
	conectar.EjecutaS(c_update5_sga)					 
	response.Write("<pre>"&c_update5&"</pre>")
wend
'response.Write("<br>-------////////////////////////////////////////////////////////////////////")

%>
