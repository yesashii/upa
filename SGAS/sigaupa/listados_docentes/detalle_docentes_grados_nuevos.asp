<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
grado = request.QueryString("tipo")
tipo_jornada = request.QueryString("jornada")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
sede = request.QueryString("sede")

set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar

set pagina = new CPagina

set botonera =  new CFormulario
botonera.carga_parametros "titulos_jornada.xml","botonera"

set docentes = new cformulario
docentes.carga_parametros "docentes_x_sede.xml","lista_docentes_horas"
docentes.inicializar conectar

periodo = negocio.obtenerPeriodoAcademico("Postulacion")
ano_consulta = conectar.consultaUno("Select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")


'-------------------------------------------------------------------------------------------------------------------------
tituloPag = "Listado docentes "
if grado= 5 then
	filtro_estricto = " "
	tituloPag = tituloPag + " con grado académico de Doctor"
elseif grado=4 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) " & vbCrLf 	
		tituloPag = tituloPag + " con grado académico de Magíster"
elseif grado=3 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)) " & vbCrLf 	
	tituloPag = tituloPag + " con grado académico de Licenciado"    
elseif grado=2 then 
	filtro_estricto = "  " & vbCrLf 
		tituloPag = tituloPag + " con Título Profesional "	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
	tituloPag = tituloPag + " Técnicos de nivel súperior"
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	tituloPag = tituloPag + " sin título ni grado académico"
end if
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) >= 33"  
	tituloPag = tituloPag + " y en Jornada Completa"
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) <= 32"  
	tituloPag = tituloPag + " y en Media Jornada"
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) <= 19"  
	tituloPag = tituloPag + " y en Jornada Hora"
end if

pagina.Titulo = tituloPag

'if sede = 2 then
'	filtro_sede= " in ('1','2')"
'else
	filtro_sede= " = '"&sede&"'"
'end if
if grado = 5 then
docentes.agregaCampoParam "grado", "descripcion","Grado Académico"
consulta =  "  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, " & vbCrLf &_
			" gpro_tdescripcion as grado, " & vbCrLf &_
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc,periodos_academicos pea  " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc,periodos_academicos pea  " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'  " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales    " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f, " & vbCrLf &_
			"      periodos_academicos pea,personas e   " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)  " & vbCrLf &_
			" and c.pers_ncorr = e.pers_ncorr " & vbCrLf &_
			" and d.egra_ccod in (1,3) and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			" and cast(a.jorn_ccod as varchar) ='"&jorn_ccod&"' " & vbCrLf &_
			" and cast(a.sede_ccod as varchar) "& filtro_sede & vbCrLf &_
			" "&filtro_horas& vbCrLf &_
			" and  a.carr_ccod='"&carr_ccod&"'" 

elseif grado = 4 then
docentes.agregaCampoParam "grado", "descripcion","Grado Académico"
consulta =  "   select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, " & vbCrLf &_
			" gpro_tdescripcion as grado, " & vbCrLf &_
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc,periodos_academicos pea  " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc,periodos_academicos pea  " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'  " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales    " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f," & vbCrLf &_
			" periodos_academicos pea,personas e  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and c.pers_ncorr = e.pers_ncorr" & vbCrLf &_
			" and d.egra_ccod = 1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			" and cast(a.jorn_ccod as varchar) ='"&jorn_ccod&"' " & vbCrLf &_
			" and cast(a.sede_ccod as varchar) "& filtro_sede & vbCrLf &_
			" "&filtro_horas& vbCrLf &_
			" and  a.carr_ccod='"&carr_ccod&"'" 
elseif grado = 3 then
docentes.agregaCampoParam "grado", "descripcion","Grado Académico"
consulta =  " select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, gpro_tdescripcion as grado, " & vbCrLf &_
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc,periodos_academicos pea  " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc,periodos_academicos pea  " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'  " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales    " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f," & vbCrLf &_
			"  periodos_academicos pea,personas e  " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"  and c.pers_ncorr=e.pers_ncorr" & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1) " & vbCrLf &_
			"  and d.egra_ccod = 1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			"  and cast(a.jorn_ccod as varchar) ='"&jorn_ccod&"' " & vbCrLf &_
			"  and cast(a.sede_ccod as varchar) "& filtro_sede & vbCrLf &_
			" "&filtro_horas& vbCrLf &_
			"  and  a.carr_ccod='"&carr_ccod&"'" 
						
elseif grado = 2 then
docentes.agregaCampoParam "grado", "descripcion","Título"
consulta = "  select * " & vbCrLf &_
			" from (  " & vbCrLf &_
			" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, gpro_tdescripcion as grado, " & vbCrLf &_
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc,periodos_academicos pea  " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc,periodos_academicos pea  " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'  " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales    " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f," & vbCrLf &_
			" periodos_academicos pea,personas e  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  and c.pers_ncorr=e.pers_ncorr" & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1) " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
			" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			" and cast(a.jorn_ccod as varchar) ='"&jorn_ccod&"'" & vbCrLf &_
			" and cast(a.sede_ccod as varchar) "& filtro_sede & vbCrLf &_
			" "&filtro_horas& vbCrLf &_
			" and  a.carr_ccod='"&carr_ccod&"'" & vbCrLf &_
			" union" & vbCrLf &_
			" select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, d.cudo_titulo as grado, " & vbCrLf &_
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc,periodos_academicos pea  " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc,periodos_academicos pea  " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'  " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales    " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f," & vbCrLf &_
			" periodos_academicos pea, personas e  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and c.pers_ncorr=e.pers_ncorr" & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and d.grac_ccod = 2  and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
			" and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			" and cast(a.jorn_ccod as varchar) ='"&jorn_ccod&"'" & vbCrLf &_
			" and cast(a.sede_ccod as varchar) "& filtro_sede & vbCrLf &_
			" "&filtro_horas& vbCrLf &_
			" and  a.carr_ccod='"&carr_ccod&"')a" 

elseif grado = 1 then
docentes.agregaCampoParam "grado", "descripcion","Título"
consulta = "  select * " & vbCrLf &_
		   " from (  " & vbCrLf &_
		   " select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, gpro_tdescripcion as grado, " & vbCrLf &_
		   " (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc,periodos_academicos pea  " & vbCrLf &_
		   " where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
		   " and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
		   " and hdc.carr_ccod= a.carr_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'" & vbCrLf &_
		   " and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
		   " (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc,periodos_academicos pea  " & vbCrLf &_
		   "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'  " & vbCrLf &_
		   "  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales    " & vbCrLf &_
		   " from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f, " & vbCrLf &_
		   " periodos_academicos pea,personas e  " & vbCrLf &_
		   " where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	  " & vbCrLf &_
		   " and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
		   " and c.pers_ncorr = e.pers_ncorr " & vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
		   " and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
		   " and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
		   " and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
		   " and cast(a.jorn_ccod as varchar) ='"&jorn_ccod&"' " & vbCrLf &_
		   " and cast(a.sede_ccod as varchar) "& filtro_sede & vbCrLf &_
		   " "&filtro_horas& vbCrLf &_
		   " and  a.carr_ccod='"&carr_ccod&"' " & vbCrLf &_
		   " union " & vbCrLf &_
		   " select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, d.cudo_titulo as grado,  " & vbCrLf &_
		   " (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc,periodos_academicos pea  " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc,periodos_academicos pea  " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'  " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales    " & vbCrLf &_
           " from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f, " & vbCrLf &_
		   " periodos_academicos pea,personas e   " & vbCrLf &_
		   " where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
		   " and c.pers_ncorr = e.pers_ncorr " & vbCrLf &_
		   " and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
		   " and d.grac_ccod = 1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod " & vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
           " and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
		   " and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
		   " and cast(a.jorn_ccod as varchar) ='"&jorn_ccod&"' " & vbCrLf &_
		   " and cast(a.sede_ccod as varchar) "& filtro_sede & vbCrLf &_
		   " "&filtro_horas& vbCrLf &_
		   " and  a.carr_ccod='"&carr_ccod&"')a" 

else
docentes.agregaCampoParam "grado", "descripcion","Información"
consulta =  "select * " & vbCrLf &_
			" from ( " & vbCrLf &_
			" select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, gpro_tdescripcion as grado, " & vbCrLf &_
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc,periodos_academicos pea  " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc,periodos_academicos pea  " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'  " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales    " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f," & vbCrLf &_
			" periodos_academicos pea,personas e " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			" and c.pers_ncorr = e.pers_ncorr " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))" & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1) " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) ) " & vbCrLf &_
			" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			" and cast(a.jorn_ccod as varchar) ='"&jorn_ccod&"'" & vbCrLf &_
			" and cast(a.sede_ccod as varchar) "& filtro_sede & vbCrLf &_
			" "&filtro_horas& vbCrLf &_
			" and  a.carr_ccod='"&carr_ccod&"'" & vbCrLf &_
			" union" & vbCrLf &_
			" select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, d.cudo_titulo as grado, " & vbCrLf &_
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc,periodos_academicos pea  " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc,periodos_academicos pea  " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'  " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales    " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f," & vbCrLf &_
			" periodos_academicos pea,personas e " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod  " & vbCrLf &_
			" and c.pers_ncorr = e.pers_ncorr" & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))" & vbCrLf &_
			" and cast(pea.anos_ccod as varchar)='"&ano_consulta&"'" & vbCrLf &_
			" and cast(a.jorn_ccod as varchar) ='"&jorn_ccod&"'" & vbCrLf &_
			" and cast(a.sede_ccod as varchar) "& filtro_sede & vbCrLf &_
			" "&filtro_horas& vbCrLf &_
			" and  a.carr_ccod='"&carr_ccod&"')a " 

end if

'--------------------------------------------------------------------------------------------------------------------------
'response.Write("<pre>"&consulta &" order by nombre</pre>")
docentes.Consultar consulta &" order by nombre"
cantidad_lista= conectar.consultaUno("select count(distinct a.pers_ncorr) from ("&consulta&")a")


url_excel="detalle_docentes_grados_nuevo_excel.asp?tipo="&grado&"&jornada="&tipo_jornada&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&sede="&sede
carrera = conectar.consultaUno("Select carr_tdesc from  carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
sede_tdesc = conectar.consultaUno("Select sede_tdesc from  sedes where cast(sede_ccod as varchar)='"&sede&"'")
jorn_tdesc = conectar.consultaUno("Select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")

%>
<html>
<head>
<title>LISTADO DOCENTES</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
                <td>
                  <%'pagina.dibujartitulopagina %>
                </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                    <p align="left">&nbsp; </p>
                    <table width="100%" border="0">
                      <tr> 
                        <td align="center"><strong>
                        <%pagina.DibujarSubtitulo pagina.titulo%>
</strong></td>
                      </tr>
                    </table>
                    <form name="edicion">
                      <div align="left">
                        <input name="url" type="hidden" value="<%=request.ServerVariables("HTTP_REFERER")%>">
                      </div>
                      <table width="98%" align="center">
					    <tr>
                          <td width="10%"><strong>Sedes</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=sede_tdesc%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Carrera</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=carrera%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Jornada</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=jorn_tdesc%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Cantidad</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=cantidad_lista%> docente(s)</td>
                        </tr>
						<tr>
                          <td align="center" colspan="3"> <div align="right">P&aacute;ginas: 
                              <%docentes.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center" colspan="3">&nbsp; <%docentes.dibujatabla()%> </td>
                        </tr>
                      </table>
                    </form>
                    <br>
                    <br>
                  </div>
                </td>
              </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28">
		 <table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
			 
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <% 
							botonera.agregabotonparam "anterior","url","GRADOS_JORNADA_NUEVO.ASP?busqueda[0][carr_ccod]="&carr_ccod&"&busqueda[0][jorn_ccod]="&jorn_ccod&"&busqueda[0][sede_ccod]="&sede
							botonera.dibujaboton("anterior") %>
                          </div></td>
                  <td><div align="center"> </div></td>
                  <td><div align="center">
                            <% botonera.dibujaboton("lanzadera") %>
                          </div></td>
				  <td> <div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", url_excel
										   botonera.dibujaboton "excel"
										%>
					 </div>  
                  </td>
				  </tr>
              </table>
			
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
