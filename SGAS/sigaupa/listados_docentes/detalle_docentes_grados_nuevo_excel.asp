<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_grados_docente.xls"
Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
grado = request.QueryString("tipo")
tipo_jornada = request.QueryString("jornada")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
sede = request.QueryString("sede")

'------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set docentes = new cformulario
docentes.carga_parametros "tabla_vacia.xml","tabla"
docentes.inicializar conectar

periodo = negocio.obtenerPeriodoAcademico("Postulacion")
ano_consulta = conectar.consultaUno("Select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")


tituloPag = "Listado de Docentes "
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


'if sede = 2 then
'	filtro_sede= " in ('1','2')"
'else
	filtro_sede= " = '"&sede&"'"
'end if

if grado = 5 then
docentes.agregaCampoParam "grado", "descripcion","Grado Académico"
consulta =  "  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, " & vbCrLf &_
			" gpro_tdescripcion as grado, " & vbCrLf &_
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc  " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod " & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc  " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod  " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales    " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f, " & vbCrLf &_
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
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod" & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas," & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales	  " & vbCrLf &_
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
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod" & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas," & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales	" & vbCrLf &_
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
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod" & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas," & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales	  " & vbCrLf &_
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
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod" & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas," & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales	   " & vbCrLf &_
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
		   " (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc " & vbCrLf &_
		   " where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
		   " and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
		   " and hdc.carr_ccod= a.carr_ccod " & vbCrLf &_
		   " and hdc.jorn_ccod= a.jorn_ccod ) as horas, " & vbCrLf &_
		   " (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc  " & vbCrLf &_
		   "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod  " & vbCrLf &_
		   "  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales   " & vbCrLf &_
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
		   " (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc  " & vbCrLf &_
		   " where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
		   " and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
           " and hdc.carr_ccod= a.carr_ccod " & vbCrLf &_
           " and hdc.jorn_ccod= a.jorn_ccod ) as horas," & vbCrLf &_
           " (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc " & vbCrLf &_
           "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
           "  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales " & vbCrLf &_
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
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod" & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas," & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales	   " & vbCrLf &_
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
			" (select isnull(sum(horas * 45 / 60),0) from horas_docentes_seccion_final hdc " & vbCrLf &_
			" where hdc.pers_ncorr=e.pers_ncorr " & vbCrLf &_
			" and hdc.sede_ccod= a.sede_ccod" & vbCrLf &_
			" and hdc.carr_ccod= a.carr_ccod" & vbCrLf &_
			" and hdc.jorn_ccod= a.jorn_ccod ) as horas," & vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc " & vbCrLf &_
			"  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod " & vbCrLf &_
			"  and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) as horas_semanales	    " & vbCrLf &_
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
docentes.Consultar consulta &" order by nombre"

cantidad_lista= conectar.consultaUno("select count(distinct a.pers_ncorr) from ("&consulta&")a")
carrera = conectar.consultaUno("Select carr_tdesc from  carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
sede_tdesc = conectar.consultaUno("Select sede_tdesc from  sedes where cast(sede_ccod as varchar)='"&sede&"'")
jorn_tdesc = conectar.consultaUno("Select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")

%>
<html>
<head>
<title> listado de docentes </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
    <td colspan="6"><div align="center"><strong><%=tituloPag%></strong></div></td>
  </tr>
  <tr> 
    <td colspan="6"><div align="center"><strong>&nbsp;</strong></div></td>
  </tr>
  <tr> 
    <td width="11%"><div align="center"><strong>Sede</strong></div></td>
	<td colspan="5"><div align="left"><strong>:</strong> <%=sede_tdesc%></div></td>
  </tr>
  <tr> 
    <td width="11%"><div align="center"><strong>Carrera</strong></div></td>
	<td colspan="5"><div align="left"><strong>:</strong> <%=carrera%></div></td>
  </tr>
  <tr> 
    <td width="11%"><div align="center"><strong>Jornada</strong></div></td>
	<td colspan="5"><div align="left"><strong>:</strong> <%=jorn_tdesc%></div></td>
  </tr>
  <tr> 
    <td width="11%"><div align="center"><strong>Fecha</strong></div></td>
	<td colspan="5"><div align="left"><strong>:</strong> <%=Date%></div></td>
  </tr>
  <tr> 
    <td width="11%"><div align="center"><strong>Cantidad</strong></div></td>
	<td colspan="5"><div align="left"><strong>:</strong> <%=cantidad_lista%> Docente(s)</div></td>
  </tr>
  <tr> 
    <td colspan="6"><div align="center"><strong>&nbsp;</strong></div></td>
  </tr>
  <tr> 
    <td width="3%" bgColor="#c4d7ff"><div align="center"><strong>N°</strong></div></td>
    <td width="15%" bgColor="#c4d7ff"><div align="center"><strong>R.U.T.</strong></div></td>
    <td width="35%" bgColor="#c4d7ff"><div align="center"><strong>Nombre</strong></div></td>
    <td width="20%" bgColor="#c4d7ff"><div align="center"><strong>Grado</strong></div></td>
	<td width="15%" bgColor="#c4d7ff"><div align="center"><strong>Horas Totales</strong></div></td>
	<td width="12%" bgColor="#c4d7ff"><div align="center"><strong>Horas Semanales</strong></div></td>
  </tr>
  <% cantidad = 1 
   while docentes.Siguiente %>
  <tr> 
   <td><div align="left"><%=cantidad%></div></td>
    <td><div align="left"><%=docentes.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=docentes.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=docentes.ObtenerValor("grado")%></div></td>
	<td><div align="center"><%=docentes.ObtenerValor("horas")%></div></td>
	<td><div align="center"><%=docentes.ObtenerValor("horas_semanales")%></div></td>
  </tr>
  <% cantidad= cantidad + 1 
  wend %>
</table>
<div align="center">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>