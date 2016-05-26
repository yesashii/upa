<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%Server.ScriptTimeOut = 150000
set conectar = new CConexion
conectar.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

'///////////////////////////////////categoria madre///////////////////////////////////////
'response.Write("<br>-------//////////////////categoría madre////////////////////////////")
'iniciamos el código de la ultima categoria registrada


id_forum = 11415
course_modules = 61754
course_display = 124082
block_instance = 71700

set formulario_cursos 		= 		new cFormulario
formulario_cursos.carga_parametros	"tabla_vacia.xml",	"tabla"
formulario_cursos.inicializar		conectar
consulta = "select * from sd_cursos_moodle_sin_bloques where con_bloque='NO' " 
formulario_cursos.consultar 		consulta
'response.Write("<br>-------///////////////////categoría facultad////////////////////////////")
while formulario_cursos.siguiente
	id_course    = formulario_cursos.obtenerValor("id_curso")
	id_seccion  = formulario_cursos.obtenerValor("id_seccion")
	id_forum = id_forum + 1
	c_forum =   " insert into mdl_forum (id,course,type,name,intro,assessed,assesstimestart,assesstimefinish,scale,maxbytes,forcesubscribe,trackingtype,rsstype,rssarticles,timemodified,warnafter,blockafter,blockperiod)"&_ 
			    " values("&id_forum&","&id_course&",'news','Novedades','Novedades y anuncios',0,0,0,0,0,1,1,0,0,1218552810,0,0,0);"
	
	course_modules = course_modules + 1
    c_modulos = " insert into mdl_course_modules (id,course,module,instance,section,added,score,indent,visible,visibleold,groupmode) "&_
				" values ("&course_modules&","&id_course&",5,"&id_forum&","&id_seccion&",1218552810,0,0,1,1,0);"
	
	course_display = course_display + 1
    c_display = " insert into mdl_course_display (id,course,userid,display) " &_
				" values ("&course_display&","&id_course&",2,0);"
	
	block_instance = block_instance + 1
    c_block_1 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",25,"&id_course&",'course-view','l',2,1,'');" 
	block_instance = block_instance + 1 
	c_block_2 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",2,"&id_course&",'course-view','l',3,1,'');"   
	block_instance = block_instance + 1
    c_block_3 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",9,"&id_course&",'course-view','l',4,1,'');"   
	block_instance = block_instance + 1
	c_block_4 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",18,"&id_course&",'course-view','r',0,1,'');"   
	block_instance = block_instance + 1
	c_block_5 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",8,"&id_course&",'course-view','r',1,1,'');"   
	block_instance = block_instance + 1
	c_block_6 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",22,"&id_course&",'course-view','r',2,1,'');"   
	block_instance = block_instance + 1
	c_block_7 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",20,"&id_course&",'course-view','l',0,1,'');"   
	block_instance = block_instance + 1
	c_block_8 = " insert into mdl_block_instance (id,blockid,pageid,pagetype,position,weight,visible,configdata) "&_
				" values ("&block_instance&",1,"&id_course&",'course-view','l',1,1,'');"
		 
		response.Write("<pre>"&c_forum&"</pre>")
		response.Write("<pre>"&c_modulos&"</pre>")
		response.Write("<pre>"&c_display&"</pre>")
		response.Write("<pre>"&c_block_1&"</pre>")
		response.Write("<pre>"&c_block_2&"</pre>")
		response.Write("<pre>"&c_block_3&"</pre>")
		response.Write("<pre>"&c_block_4&"</pre>")
		response.Write("<pre>"&c_block_5&"</pre>")
		response.Write("<pre>"&c_block_6&"</pre>")
		response.Write("<pre>"&c_block_7&"</pre>")
		response.Write("<pre>"&c_block_8&"</pre>")
wend

'response.Write("<br>-------////////////////////////////////////////////////////////////////////")

%>
