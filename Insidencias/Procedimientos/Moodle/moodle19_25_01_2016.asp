<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conectar = new CConexion
conectar.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


ultimo_registro = conectar.consultaUno("select max(id) from carga_semanal_moodle_aux")
ultimo_cache_flacs  = 581044 '580944

set f_variables_aux = new CFormulario
f_variables_aux.Carga_Parametros "tabla_vacia.xml", "tabla"
f_variables_aux.Inicializar conectar
sql = "select * from carga_semanal_moodle_aux where id = "&ultimo_registro&""

f_variables_aux.Consultar sql
while f_variables_aux.siguiente
	categoria 		= f_variables_aux.obtenerValor("categoria")
	n_categoria 	= f_variables_aux.obtenerValor("n_categoria")
	curso 				= f_variables_aux.obtenerValor("curso")
	n_curso 			= f_variables_aux.obtenerValor("n_curso")
	seccion 			= f_variables_aux.obtenerValor("seccion")
	n_seccion 		= f_variables_aux.obtenerValor("n_seccion")
	contexto 			= f_variables_aux.obtenerValor("contexto")
	n_contexto 		= f_variables_aux.obtenerValor("n_contexto")
	cache_flacs 	= f_variables_aux.obtenerValor("cache_flacs")
	n_cache_flacs = f_variables_aux.obtenerValor("n_cache_flacs")
	logg 					= f_variables_aux.obtenerValor("logg")
	n_logg 				= f_variables_aux.obtenerValor("n_logg")
	forum 				= f_variables_aux.obtenerValor("forum")
	n_forum 			= f_variables_aux.obtenerValor("n_forum")
	modules 			= f_variables_aux.obtenerValor("modules")
	n_modules 		= f_variables_aux.obtenerValor("n_modules")
	display 			= f_variables_aux.obtenerValor("display")
	n_display 		= f_variables_aux.obtenerValor("n_display")
	block 				= f_variables_aux.obtenerValor("block")
	n_block 			= f_variables_aux.obtenerValor("n_block")
wend

if isnull(categoria) then imprime_cadena "categoria nula", 1 end if
if isnull(curso) then imprime_cadena "curso nula", 1 end if
if isnull(seccion) then imprime_cadena "seccion nula", 1 end if
if isnull(contexto) then imprime_cadena "contexto nula", 1 end if
if isnull(cache_flacs) then imprime_cadena "cache_flacs nula", 1 end if
if isnull(logg) then imprime_cadena "logg nula", 1 end if
if isnull(forum) then imprime_cadena "forum nula", 1 end if
if isnull(modules) then imprime_cadena "modules nula", 1 end if
if isnull(display) then imprime_cadena "display nula", 1 end if
if isnull(block) then imprime_cadena "block nula", 1 end if




'/////////////////////////////////categoria madre///////////////////////////////////////
'response.Write("<br>-------///////////////////categoría madre////////////////////////////")
'iniciamos el código de la ultima categoria registrada
ultima_categoria    = categoria
ultimo_curso        = curso
ultima_seccion      = seccion
ultimo_contexto     = contexto
ultimo_log          = logg
path_contexto       = "/1"

id_forum        = forum
course_modules  = modules
course_display  = display
block_instance  = block

var_peri_ccod = 240
%>
<script>alert("El periodo es: "+var_peri_ccod)</script>
<%
'creamos la categoria escuela---> theme esta en mi base, sin teme en producción
'c_inserta = " insert into mdl_course_categories (id,name,description,parent,sortorder,coursecount,visible,timemodified,depth,path) " & vbCrLf &_
'            " values ("&ultima_categoria&",'UNIVERSIDAD',NULL,0,999,0,1,0,1,'/"&ultima_categoria&"');"
'ultimo_contexto= ultimo_contexto + 1
'path_contexto = path_contexto&"/"&ultimo_contexto
'c_inserta_contexto = " insert into mdl_context (id,contextlevel,instanceid,path,depth) " & vbCrLf &_
'                     " values ("&ultimo_contexto&",40,"&ultima_categoria&",'"&path_contexto&"',2);"

'c_inserta_sga = " insert into moodle_course_categories (id,name,description,parent,sortorder,coursecount,visible,timemodified,depth,path,theme,path_context) " & vbCrLf &_
'                " values ("&ultima_categoria&",'UNIVERSIDAD',NULL,0,999,0,1,0,1,'/"&ultima_categoria&"',null,'"&path_contexto&"')"
'conectar.EjecutaS(c_inserta_sga)
'response.Write("<pre>"&c_inserta&"</pre>")
'response.Write("<pre>"&c_inserta_contexto&"</pre>")
categoria_padre = ultima_categoria
'response.Write("<br>-------////////////////////////////////////////////////////////////////////")

set formulario_facultad 		= 		new cFormulario
formulario_facultad.carga_parametros	"tabla_vacia.xml",	"tabla"
formulario_facultad.inicializar		conectar
consulta = "  select distinct protic.initCap(facu_tdesc) as facu_tdesc, f.facu_ccod " & vbCrLf &_
		   "  from alumnos a, ofertas_academicas b, especialidades c, carreras d, areas_academicas e, facultades f,sedes g " & vbCrLf &_
		   "  where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod in ("&var_peri_ccod&") " & vbCrLf &_
		   "  and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrLf &_
		   "  and d.area_ccod=e.area_ccod and e.facu_ccod=f.facu_ccod --and f.facu_ccod=2 " & vbCrLf &_
		   "  and b.sede_ccod=g.sede_ccod and a.emat_ccod=1 AND D.TCAR_CCOD=1 " & vbCrLf &_
		   "  and exists(select 1 from secciones aa where peri_ccod in ("&var_peri_ccod&") and aa.sede_ccod=b.sede_ccod " & vbCrLf &_
		   "             and aa.carr_ccod=d.carr_ccod and aa.jorn_ccod=b.jorn_ccod) " & vbCrLf &_
		   "  union " & vbCrLf &_
		   "  select protic.initCap('INSTITUCIONALES') as facu_tdesc, 7 as facu_ccod  " & vbCrLf &_
		   "  order by facu_tdesc"
formulario_facultad.consultar 		consulta
'response.Write("<br>-------///////////////////categoría facultad////////////////////////////")
while formulario_facultad.siguiente
	facu_tdesc = formulario_facultad.obtenerValor("facu_tdesc")
	facu_ccod  = formulario_facultad.obtenerValor("facu_ccod")
	path_contexto = conectar.consultaUno("select ltrim(rtrim(path_context)) from moodle_course_categories where cast(id as varchar)='"&categoria_padre&"'")
	grabado = conectar.consultaUno("select count(*) from moodle_course_categories where cast(facu_ccod as varchar)='"&facu_ccod&"'")
	if grabado = "0" then
		ultima_categoria = ultima_categoria + 1
		codigo_categoria = "/"&categoria_padre&"/"&ultima_categoria
		c_inserta2 = " insert into mdl_course_categories (id,name,description,parent,sortorder,coursecount,visible,timemodified,depth,path) " & vbCrLf &_
					 " values ("&ultima_categoria&",'"&facu_tdesc&"',NULL,"&categoria_padre&",999,0,1,0,2,'"&codigo_categoria&"');"

        ultimo_contexto= ultimo_contexto + 1
		path_contexto = path_contexto&"/"&ultimo_contexto
		c_inserta2_contexto = " insert into mdl_context (id,contextlevel,instanceid) " & vbCrLf &_
        		              " values ("&ultimo_contexto&",40,"&ultima_categoria&");"


		c_inserta2_sga = " insert into moodle_course_categories (id,name,description,parent,sortorder,coursecount,visible,timemodified,depth,path,facu_ccod,path_context,codigo_en_moodle) " & vbCrLf &_
						 " values ("&ultima_categoria&",'"&facu_tdesc&"',NULL,"&categoria_padre&",999,0,1,0,2,'"&codigo_categoria&"',"&facu_ccod&",'"&path_contexto&"',"&ultima_categoria&");"
		conectar.EjecutaS(c_inserta2_sga)
		response.Write("<pre>"&c_inserta2&"</pre>")
		response.Write("<pre>"&c_inserta2_contexto&"</pre>")
	end if
wend
'response.Write("<br>-------////////////////////////////////////////////////////////////////////")
set formulario_escuela 		= 		new cFormulario
formulario_escuela.carga_parametros	"tabla_vacia.xml",	"tabla"
formulario_escuela.inicializar		conectar
consulta_escuela =  "  select distinct protic.initCap(facu_tdesc) as facu_tdesc, " & vbCrLf &_
					"  ltrim(rtrim(protic.initcap(g.sede_tdesc)))+' : ' + ltrim(rtrim(protic.initcap(d.carr_tdesc)))+ " & vbCrLf &_
					"  case b.jorn_ccod when 1 then ' (D)' else ' (V)' end as escuela,f.facu_ccod,g.sede_ccod,d.carr_ccod,b.jorn_ccod  " & vbCrLf &_
					"  from alumnos a, ofertas_academicas b, especialidades c, carreras d, areas_academicas e, facultades f,sedes g " & vbCrLf &_
					"  where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod in ("&var_peri_ccod&") " & vbCrLf &_
					"  and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrLf &_
					"  and d.area_ccod=e.area_ccod and e.facu_ccod=f.facu_ccod " & vbCrLf &_
					"  and b.sede_ccod=g.sede_ccod and a.emat_ccod=1 AND D.TCAR_CCOD=1 " & vbCrLf &_
					"  and exists(select 1 from secciones aa where peri_ccod in ("&var_peri_ccod&") and aa.sede_ccod=b.sede_ccod " & vbCrLf &_
					"  and aa.carr_ccod=d.carr_ccod and aa.jorn_ccod=b.jorn_ccod) " & vbCrLf &_
					"  and exists(select 1 from moodle_course_categories bb where bb.facu_ccod=f.facu_ccod) " & vbCrLf &_
					"  order by facu_tdesc, escuela "
formulario_escuela.consultar  consulta_escuela
'response.Write("<br>-------///////////////////categoría escuela////////////////////////////")
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
		c_inserta3 = " insert into mdl_course_categories (id,name,description,parent,sortorder,coursecount,visible,timemodified,depth,path) " & vbCrLf &_
					" values ("&ultima_categoria&",'"&escuela&"',NULL,"&padre&",999,0,1,0,3,'"&codigo_categoria&"');"

		ultimo_contexto= ultimo_contexto + 1
		path_contexto = path_contexto&"/"&ultimo_contexto
		c_inserta3_contexto = " insert into mdl_context (id,contextlevel,instanceid) " & vbCrLf &_
        		             " values ("&ultimo_contexto&",40,"&ultima_categoria&");"

		c_inserta3_sga = " insert into moodle_course_categories (id,name,description,parent,sortorder,coursecount,visible,timemodified,depth,path,sede_ccod,carr_ccod,jorn_ccod,path_context,codigo_en_moodle) " & vbCrLf &_
						 " values ("&ultima_categoria&",'"&escuela&"',NULL,"&padre&",999,0,1,0,3,'"&codigo_categoria&"',"&sede_ccod&",'"&carr_ccod&"',"&jorn_ccod&",'"&path_contexto&"',"&ultima_categoria&");"
		conectar.EjecutaS(c_inserta3_sga)
		response.Write("<pre>"&c_inserta3&"</pre>")
		response.Write("<pre>"&c_inserta3_contexto&"</pre>")
	end if
wend
'response.Write("<br>-------////////////////////////////////////////////////////////////////////")
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
					"  where a.peri_ccod=b.peri_ccod and cast(b.peri_ccod as varchar)='"&var_peri_ccod&"' " & vbCrLf &_
					"  and a.asig_ccod=c.asig_ccod and a.carr_ccod=d.carr_ccod  AND D.TCAR_CCOD=1 " & vbCrLf &_
					"  and d.area_ccod=e.area_ccod and e.facu_ccod=f.facu_ccod " & vbCrLf &_
					"  and exists (select 1 from moodle_course_categories bb where bb.facu_ccod=f.facu_ccod) " & vbCrLf &_
					"  and exists (select 1 from bloques_horarios cc where a.secc_ccod=cc.secc_ccod) " & vbCrLf &_
					"  --and exists (select 1 from cargas_academicas dd where a.secc_ccod=dd.secc_ccod) " & vbCrLf &_
					"  and c.asig_tdesc not like '%seleccion%'  " &vbCrLf &_
					"  and c.asig_tdesc not like '%reserva%' " &vbCrLf &_
					"  )table1 " & vbCrLf &_
					"  order by sede_ccod,jorn_ccod,asig_ccod,seccion "
formulario_cursos.consultar  consulta_cursos
'response.Write("<br>-------///////////////////categoría escuela////////////////////////////")
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
	path_contexto = conectar.consultaUno("select ltrim(rtrim(path_context)) from moodle_course_categories where cast(id as varchar)='"&padre&"'")
	grabado = conectar.consultaUno("select count(*) from moodle_course where asig_ccod='"&asig_ccod&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' and carr_ccod='"&carr_ccod&"' and cast(seccion as varchar)='"&seccion&"' and isnull(periodo,'0') = '0'")
	if grabado = "0" and padre <> "" then
		ultimo_curso = ultimo_curso + 1
        ultima_seccion = ultima_seccion + 1
		c_inserta4 = " insert into mdl_course (id,category,sortorder,password,fullname,shortname,idnumber,summary,format,showgrades,modinfo,newsitems,teacher, " & vbCrLf &_
                     " teachers,student,students,guest,startdate,enrolperiod,numsections,marker,maxbytes,showreports,visible, " & vbCrLf &_
                     " hiddensections,groupmode,groupmodeforce,lang,theme,cost,currency,timecreated, " & vbCrLf &_
                     " timemodified,metacourse,requested,restrictmodules,expirynotify,expirythreshold,notifystudents, " & vbCrLf &_
                     " enrollable,enrolstartdate,enrolenddate,enrol,defaultrole)   " & vbCrLf &_
					 " values("&ultimo_curso&","&padre&",2003,'','"&nombre_largo&"','"&id&"','"&id&"','BIENVENIDO A LA ASIGNATURA "&nombre_largo&"','topics',1,'',5,'Profesor','Profesores','Estudiante','Estudiantes',0,1218423600,0,6,0,268435456,0,1,0,0,0,'','','','USD',1217598726,1217599526,0,0,0,0,0,0,0,0,0,'',0);"

		c_inserta4_sesion = " insert into mdl_course_sections (id,course,section,summary,sequence,visible) " & vbCrLf &_
					        " values ("&ultima_seccion&","&ultimo_curso&",0,NULL,3,1); "

        ultimo_contexto= ultimo_contexto + 1
		path_contexto = path_contexto&"/"&ultimo_contexto
		path_contexto_curso = path_contexto
		c_inserta4_contexto = " insert into mdl_context (id,contextlevel,instanceid,path) " & vbCrLf &_
        		              " values ("&ultimo_contexto&",50,"&ultimo_curso&",'"&path_contexto&"');"

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

	id_course    = ultimo_curso

	block_instance = block_instance + 1
	c_block_6 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",22,"&id_course&",'course-view','r',2,1,'');"
	ultimo_contexto= ultimo_contexto + 1
	path_contexto = path_contexto_curso&"/"&ultimo_contexto
	c_inserta4_contexto1 = " insert into mdl_context (id,contextlevel,instanceid,path) " & vbCrLf &_
        		           " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"');"
    block_instance = block_instance + 1
	c_block_5 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",8,"&id_course&",'course-view','r',1,1,'');"
	ultimo_contexto= ultimo_contexto + 1
	path_contexto = path_contexto_curso&"/"&ultimo_contexto
	c_inserta4_contexto2 = " insert into mdl_context (id,contextlevel,instanceid,path) " & vbCrLf &_
        		           " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"');"
	block_instance = block_instance + 1
	c_block_4 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",18,"&id_course&",'course-view','r',0,1,'');"
	ultimo_contexto= ultimo_contexto + 1
	path_contexto = path_contexto_curso&"/"&ultimo_contexto
	c_inserta4_contexto3 = " insert into mdl_context (id,contextlevel,instanceid,path) " & vbCrLf &_
        		           " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"');"
	block_instance = block_instance + 1
    c_block_3 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",9,"&id_course&",'course-view','l',4,1,'');"
	ultimo_contexto= ultimo_contexto + 1
	path_contexto = path_contexto_curso&"/"&ultimo_contexto
	c_inserta4_contexto4 = " insert into mdl_context (id,contextlevel,instanceid,path) " & vbCrLf &_
        		           " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"');"
	block_instance = block_instance + 1
	c_block_2 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",2,"&id_course&",'course-view','l',3,1,'');"
	ultimo_contexto= ultimo_contexto + 1
	path_contexto = path_contexto_curso&"/"&ultimo_contexto
	c_inserta4_contexto5 = " insert into mdl_context (id,contextlevel,instanceid,path) " & vbCrLf &_
        		           " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"');"
	block_instance = block_instance + 1
    c_block_1 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",25,"&id_course&",'course-view','l',2,1,'');"
	ultimo_contexto= ultimo_contexto + 1
	path_contexto = path_contexto_curso&"/"&ultimo_contexto
	c_inserta4_contexto6 = " insert into mdl_context (id,contextlevel,instanceid,path) " & vbCrLf &_
        		           " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"');"
	block_instance = block_instance + 1
	c_block_7 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",20,"&id_course&",'course-view','l',0,1,'');"
	ultimo_contexto= ultimo_contexto + 1
	path_contexto = path_contexto_curso&"/"&ultimo_contexto
	c_inserta4_contexto7 = " insert into mdl_context (id,contextlevel,instanceid,path) " & vbCrLf &_
        		           " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"');"
	block_instance = block_instance + 1
	c_block_8 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",1,"&id_course&",'course-view','l',1,1,'');"
	ultimo_contexto= ultimo_contexto + 1
	path_contexto = path_contexto_curso&"/"&ultimo_contexto
	c_inserta4_contexto8 = " insert into mdl_context (id,contextlevel,instanceid,path) " & vbCrLf &_
        		           " values ("&ultimo_contexto&",80,"&block_instance&",'"&path_contexto&"');"

    ultimo_cache_flacs = ultimo_cache_flacs + 1
	c_cache_flacs = " insert into mdl_cache_flags (id,flagtype,name,timemodified,value,expiry) "&_
				    " values ("&ultimo_cache_flacs&",'accesslib/dirtycontexts','"&path_contexto&"',1308938225,1,1308945425);"

    ultimo_log = ultimo_log + 1
	c_mdl_log = " insert into mdl_log (id,time,userid,ip,course,module,cmid,action,url,info) "&_
				" values ("&ultimo_log&",1176479579,2,'200.6.18.10',1,'course',0,'new','view.php?id="&id_course&"','ID "&id_course&"' );"

	id_seccion   = ultima_seccion
	id_forum = id_forum + 1
	c_forum =   " insert into mdl_forum (id,course,type,name,intro,assessed,assesstimestart,assesstimefinish,scale,maxbytes,forcesubscribe,trackingtype,rsstype,rssarticles,timemodified,warnafter,blockafter,blockperiod)"&_
			    " values("&id_forum&","&id_course&",'news','Novedades','Novedades y anuncios',0,0,0,0,0,1,1,0,0,1308944405,0,0,0);"

	course_modules = course_modules + 1
    c_modulos = " insert into mdl_course_modules (id,course,module,instance,section,idnumber,added,score,indent,visible,visibleold,groupmode,groupingid,groupmembersonly) "&_
				" values ("&course_modules&","&id_course&",5,"&id_forum&","&id_seccion&",NULL,1218552810,0,0,1,1,0,0,0);"

	course_display = course_display + 1
    c_display = " insert into mdl_course_display (id,course,userid,display) " &_
				" values ("&course_display&","&id_course&",2,0);"


    	ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion2 = " insert into mdl_course_sections (id,course,section,summary,sequence,visible) " & vbCrLf &_
					        " values ("&ultima_seccion&","&id_course&",1,'',NULL,1); "
        ultima_seccion = ultima_seccion + 1
		c_inserta4_sesion3 = " insert into mdl_course_sections (id,course,section,summary,sequence,visible) " & vbCrLf &_
					        " values ("&ultima_seccion&","&id_course&",2,'',NULL,1); "

		ultimo_log = ultimo_log + 1
		c_mdl_log2 = " insert into mdl_log (id,time,userid,ip,course,module,cmid,action,url,info) "&_
					 " values ("&ultimo_log&",1176479579,2,'200.6.18.10',"&id_course&",'course',0,'new','view.php?id="&id_course&"','ID "&id_course&"' );"

		response.Write("<pre>"&c_inserta4&"</pre>")
		response.Write("<pre>"&c_inserta4_sesion&"</pre>")
		response.Write("<pre>"&c_inserta4_contexto&"</pre>")

		response.Write("<pre>"&c_block_1&"</pre>")
		response.Write("<pre>"&c_inserta4_contexto1&"</pre>")
		response.Write("<pre>"&c_block_2&"</pre>")
		response.Write("<pre>"&c_inserta4_contexto2&"</pre>")
		response.Write("<pre>"&c_block_3&"</pre>")
		response.Write("<pre>"&c_inserta4_contexto3&"</pre>")
		response.Write("<pre>"&c_block_4&"</pre>")
		response.Write("<pre>"&c_inserta4_contexto4&"</pre>")
		response.Write("<pre>"&c_block_5&"</pre>")
		response.Write("<pre>"&c_inserta4_contexto5&"</pre>")
		response.Write("<pre>"&c_block_6&"</pre>")
		response.Write("<pre>"&c_inserta4_contexto6&"</pre>")
		response.Write("<pre>"&c_block_7&"</pre>")
		response.Write("<pre>"&c_inserta4_contexto7&"</pre>")
		response.Write("<pre>"&c_block_8&"</pre>")
		response.Write("<pre>"&c_inserta4_contexto8&"</pre>")
		response.Write("<pre>"&c_cache_flacs&"</pre>")
		'response.Write("<pre>"&c_mdl_log&"</pre>")

		response.Write("<pre>"&c_forum&"</pre>")
		response.Write("<pre>"&c_modulos&"</pre>")
		response.Write("<pre>"&c_display&"</pre>")

		response.Write("<pre>"&c_inserta4_sesion2&"</pre>")
		response.Write("<pre>"&c_inserta4_sesion3&"</pre>")
        'response.Write("<pre>"&c_mdl_log2&"</pre>")


	end if
wend
'response.Write("<br>-------//////////////////////////////////////////////////////////////////")

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
'response.Write("<br>-------///////////////////Actualizar////////////////////////////")
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
