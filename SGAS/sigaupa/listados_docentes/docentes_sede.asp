<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Disposicion de Docentes por Sede"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "docentes_sede.xml", "botonera"

'-----------------------------------------------------------------------
sede_ccod = request.querystring("busqueda[0][sede_ccod]")

Sede = conexion.consultauno("SELECT sede_tdesc FROM sedes WHERE cast(sede_ccod as varchar)= '" & sede_ccod & "'")

if sede_ccod <> "" then
	filtro = " and cast(bb.sede_ccod as varchar)='"&sede_ccod&"'"
	Sede = conexion.consultauno("SELECT sede_tdesc FROM sedes WHERE cast(sede_ccod as varchar)= '" & sede_ccod & "'")

else
	filtro = ""
	Sede = "Todas las Sedes"
end if

'----------------------------------------------------------------------------------------------
'-----------a modo de unificar el listado debemos sacar el periodo y el año que se esta consultando---------
periodo = negocio.obtenerPeriodoAcademico("PLANIFICACION")
ano_consulta = conexion.consultaUno("Select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

'response.Write(ano_consulta)

'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "docentes_sede.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
   
 f_busqueda.AgregaCampoCons "sede_ccod", sede_ccod 
 f_busqueda.AgregaCampoParam "sede_ccod","destino","(Select distinct b.sede_ccod,b.sede_tdesc from ofertas_academicas a, sedes b where a.sede_ccod=b.sede_ccod and a.peri_ccod in(164,200,201))a"
 f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
 set f_planes = new CFormulario
 f_planes.Carga_Parametros "docentes_sede.xml", "f_docentes"
 f_planes.Inicializar conexion

 consulta = "  select distinct  sede,carrera,sede_ccod,carr_ccod,Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo as Totales, " & vbCrLf &_
            " Case Doctor When 0 then cast(Doctor as varchar) else '<a href=""listado_docentes_sede.asp?sede_ccod='+cast(sede_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=5"">'+cast(Doctor as varchar)+'</a>' end as Doctor1, " & vbCrLf &_
			" Case Magister When 0 then cast(Magister as varchar) else '<a href=""listado_docentes_sede.asp?sede_ccod='+cast(sede_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=4"">'+cast(Magister as varchar)+'</a>' end as Magister1, " & vbCrLf &_
			" Case Licenciado When 0 then cast(Licenciado as varchar) else '<a href=""listado_docentes_sede.asp?sede_ccod='+cast(sede_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=3"">'+cast(Licenciado as varchar)+'</a>' end as Licenciado1, " & vbCrLf &_
			" Case Profesional When 0 then cast(Profesional as varchar) else '<a href=""listado_docentes_sede.asp?sede_ccod='+cast(sede_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=2"">'+cast(Profesional as varchar)+'</a>' end as Profesional1," & vbCrLf &_
			" Case Tecnico When 0 then cast(Tecnico as varchar) else '<a href=""listado_docentes_sede.asp?sede_ccod='+cast(sede_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=1"">'+cast(Tecnico as varchar)+'</a>' end as Tecnico1," & vbCrLf &_
			" Case sin_grado_titulo When 0 then cast(sin_grado_titulo as varchar) else '<a href=""listado_docentes_sede.asp?sede_ccod='+cast(sede_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=0"">'+cast(sin_grado_titulo as varchar)+'</a>' end as sin_grado_titulo1" & vbCrLf &_
			" from (select dd.sede_tdesc as sede,cc.carr_tdesc as carrera,dd.sede_ccod,cc.carr_ccod, " & vbCrLf &_
			" (select count(distinct c.pers_ncorr) " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and d.egra_ccod in (1,3) and tpro_ccod=1  and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod) as Doctor,  " & vbCrLf &_
			" (select count(distinct c.pers_ncorr) " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea " & vbCrLf &_
		    "  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			"  and d.egra_ccod=1 and tpro_ccod=1 " & vbCrLf &_
			"  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod) as Magister, " & vbCrLf &_
		    " (select count(distinct c.pers_ncorr)  " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
		    "  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1) " & vbCrLf &_
			"  and d.egra_ccod=1 and tpro_ccod=1 " & vbCrLf &_
		    "  and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod) as Licenciado,  " & vbCrLf &_
			" (select count(*) " & vbCrLf &_
			"  from ( " & vbCrLf &_
			"  select distinct c.pers_ncorr " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1) " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			" union all " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d, asignaturas f,periodos_academicos pea  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			" and d.grac_ccod = 2  and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod)a ) as Profesional, " & vbCrLf &_
			" (select count(*) " & vbCrLf &_
			" from ( " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 ) " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
 			" union all " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d, asignaturas f,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			" and d.grac_ccod = 1 and tpro_ccod=1  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod )a" & vbCrLf &_
			" ) as tecnico, " & vbCrLf &_
			" ( select count(*)" & vbCrLf &_
			" from (" & vbCrLf &_
			" select distinct c.pers_ncorr " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea" & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod" & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) ) " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod	and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" union all " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea" & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod" & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf &_
			" and a.sede_ccod=bb.sede_ccod and a.carr_ccod=bb.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod )a) as sin_grado_titulo" & vbCrLf &_
			" from secciones bb,carreras cc,sedes dd,periodos_academicos pa " & vbCrLf &_
			" where  bb.carr_ccod=cc.carr_ccod" & vbCrLf &_
			" and bb.sede_ccod = dd.sede_ccod and bb.peri_ccod = pa.peri_ccod" & vbCrLf &_
			" and cast(pa.anos_ccod as varchar)='"&ano_consulta&"' and cc.tcar_ccod=1" & vbCrLf &_
			" "&filtro&" ) a " & vbCrLf &_
 			" where (Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo) <> 0 " & vbCrLf &_
		    " order by sede,carrera " 
'response.Write("<pre>"&consulta&"</pre>")
f_planes.Consultar consulta

'--------------------------------listado general de docentes (datos reales)--------------------------------
 set f_reales = new CFormulario
 f_reales.Carga_Parametros "docentes_sede.xml", "f_reales"
 f_reales.Inicializar conexion
 
 consulta2 = " select distinct  a.*, Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo as Totales	 " & vbCrLf &_
			" from (select    " & vbCrLf &_
			" (select count(distinct c.pers_ncorr)   " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras e, asignaturas f,periodos_academicos pa  " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)  " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and tpro_ccod=1  " & vbCrLf &_
			"  and d.egra_ccod in (1,3) and a.peri_ccod= pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"'  and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1" & vbCrLf &_
			"  ) as Doctor,   " & vbCrLf &_
			" (select count(distinct c.pers_ncorr)  " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras e,asignaturas f,periodos_academicos pa " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)" & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and tpro_ccod=1  " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			"  and d.egra_ccod=1 and a.peri_ccod = pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"' and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1	 " & vbCrLf &_
			"  ) as Magister, " & vbCrLf &_
			" (select count(distinct c.pers_ncorr) 	 " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, carreras e,asignaturas f,periodos_academicos pa " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and tpro_ccod=1  " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) 	 " & vbCrLf &_	
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
			"  and d.egra_ccod=1 and a.peri_ccod= pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"' and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1	 " & vbCrLf &_
			"  ) as Licenciado, 	 " & vbCrLf &_
			" (select count(*)	 " & vbCrLf &_
			"  from (	 " & vbCrLf &_
			"  select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, carreras e,asignaturas f,periodos_academicos pa " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) 	 " & vbCrLf &_
			" and a.peri_ccod= pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"'	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" union all	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d, carreras e,asignaturas f,periodos_academicos pa " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 	and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and d.grac_ccod = 2 and a.peri_ccod= pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"' and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) 	 " & vbCrLf &_
			" )a ) as Profesional,	 " & vbCrLf &_
			" (select count(*)	 " & vbCrLf &_
			" from (	 " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d	,carreras e, asignaturas f,periodos_academicos pa " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) 	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1) 	 " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 ) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) 	 " & vbCrLf &_
			" and a.peri_ccod= pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"' and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" union all	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,carreras e, asignaturas f,periodos_academicos pa	 " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and d.grac_ccod = 1 and a.peri_ccod= pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"'	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) 	 " & vbCrLf &_
			" )a	 " & vbCrLf &_
			" ) as tecnico,	 " & vbCrLf &_
			" ( select count(*)	 " & vbCrLf &_
			" from (	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras e, asignaturas f,periodos_academicos pa " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) 	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) ) 	 " & vbCrLf &_
			" and a.peri_ccod= pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"'	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" union all	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d, carreras e,asignaturas f,periodos_academicos pa	 " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) 	 " & vbCrLf &_
			" and a.peri_ccod= pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"' and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1" & vbCrLf &_
			" )a) as sin_grado_titulo	 " & vbCrLf &_
			" ) a "
'response.Write("<pre>"&consulta2&"</pre>")
f_reales.Consultar consulta2		 
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function cargar()
{
  buscador.action="Especialidades.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}


</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td><div align="left">Sede</div></td>
                                <td><div align="center">:</div></td>
                                <td>
                                  <% f_busqueda.dibujaCampo ("sede_ccod") %>
                                </td>
                              </tr>
                           </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                    <br> 
                    <table width="100%" border="0">
                      <tr>
                        <td><table width="99%" border="0" align="left" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Sede</font></b></font></td>
                              <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
                                  </font></b></font></div></td>
                              <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=Sede%></font></b></font></td>
                            </tr>
							<tr> 
                              <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Año</font></b></font></td>
                              <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
                                  </font></b></font></div></td>
                              <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=ano_consulta%></font></b></font></td>
                            </tr>
                            <tr> 
                              <td height="0" colspan="3"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
                            </tr>
                          </table></td>
                      </tr>
                    </table> 
                    <br>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr><td>&nbsp;</td></tr>
				  <tr><td align="left"><%pagina.dibujarSubtitulo("Resumen de docentes reales Universidad")%></td></tr>
				   <tr>
                       <td width="100%"><div align="right">P&aacute;ginas: &nbsp; <%f_reales.AccesoPagina%> </div></td>
				  </tr>
				  <tr>
				  		<td align="center">
                           <% f_reales.DibujaTabla()%>
                        </td>
                  </tr>
				  <tr><td>&nbsp;</td></tr>
				  <tr><td>&nbsp;</td></tr>
				  <tr><td align="left"><%pagina.dibujarSubtitulo("Resumen de docentes Distribuidos por sede y escuela")%></td></tr>
				  <tr><td>&nbsp;</td></tr>
				  <tr>
                       <td width="100%"><div align="right">P&aacute;ginas: &nbsp; <%f_planes.AccesoPagina%> </div></td>
				  </tr>
				  <tr>
				  		<td align="center">
                           <% f_planes.DibujaTabla()%>
                        </td>
                  </tr>
				  <tr>
				  		<td align="center">&nbsp;
                        </td>
                  </tr>
				  <tr>
				  		<td align="center">&nbsp;
                        </td>
                  </tr>
				  <tr>
				  		<td align="center">Si desea ver un listado de profesores de todas las escuelas y sedes, con sus grados académicos, títulos y asignaturas que dicta durante el año, perione el botón <strong>'Listado general docentes'.<br> ATENCIÓN:<br></strong>La generación de dicho listado puede tardar algunos minutos, haga el favor de esperar.
                        </td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
					<td width="14%"> <div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", "docentes_sede_excel.asp?sede_ccod="&sede_ccod
										   botonera.dibujaboton "excel"
										%>
					 </div>
                  </td>
				  <td width="14%"> <div align="center">  <%
					                       botonera.agregabotonparam "excel_general", "url", "listado_general_docentes.asp"
										   botonera.dibujaboton "excel_general"
										%>
					 </div>
                  </td>
				  <td width="14%"> <div align="center">  <%
					                       botonera.agregabotonparam "excel_docentes", "url", "listado_simple_docentes.asp"
										   botonera.dibujaboton "excel_docentes"
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
