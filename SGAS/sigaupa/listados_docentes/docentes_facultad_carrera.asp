<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeOut = 150000
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "distribución de docentes por facultad"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "docentes_facultad_carrera.xml", "botonera"

'----------------------------------------------------------------------------------------------
'-----------a modo de unificar el listado debemos sacar el periodo y el año que se esta consultando---------
periodo = negocio.obtenerPeriodoAcademico("PLANIFICACION")
ano_consulta = conexion.consultaUno("Select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

'response.Write(ano_consulta)

'-----------------------------------------------------------------------
facu_ccod = request.querystring("busqueda[0][facu_ccod]")
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'response.Write("facu_ccod "&facu_ccod&" carr_ccod "&carr_ccod)
if carr_ccod = "-1" then
	carr_ccod=""
end if

if facu_ccod <> "" then
	filtro1= " and cast(aa.facu_ccod as varchar)='"&facu_ccod&"'"
else
    filtro1=""	
end if 

if carr_ccod <> "" then
	filtro2= " and cast(dd.carr_ccod as varchar)='"&carr_ccod&"'"
else
    filtro2=""	
end if 
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
facultad = conexion.consultauno("SELECT facu_tdesc FROM facultades WHERE facu_ccod = '" & facu_ccod & "'")

'response.Write(espe_ccod & ":"& especialidad & "<BR><BR>")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "docentes_facultad_carrera.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 	if  carr_ccod <> "" then
		f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
	end if
	if  facu_ccod <> "" then
	   	f_busqueda.Agregacampoparam "carr_ccod", "destino" , "(select carr_ccod,carr_tdesc,facu_ccod from carreras_facultad where cast(facu_ccod as varchar)='"&facu_ccod&"')a"
	end if
 
   consulta_facultades = " (select distinct a.facu_ccod,a.facu_tdesc " & vbCrLf &_
					   " from facultades a, areas_academicas b, carreras c, secciones d,periodos_academicos pa " & vbCrLf &_
					   " where a.facu_ccod=b.facu_ccod and b.area_ccod =  c.area_ccod " & vbCrLf &_
					   " and c.carr_ccod= d.carr_ccod " & vbCrLf &_
					   " and d.peri_ccod= pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"')a" 
 
 f_busqueda.AgregaCampoParam "facu_ccod","destino",consulta_facultades
 f_busqueda.AgregaCampoCons "facu_ccod", facu_ccod 
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 

 f_busqueda.Siguiente
  
 'ultimo = carr_ccod

'response.Write("<pre>"&consulta_facultades&"</pre>")

'---------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------
 set f_planes = new CFormulario
 f_planes.Carga_Parametros "docentes_facultad_carrera.xml", "f_docentes"
 f_planes.Inicializar conexion

 consulta = "  select distinct facultad,carrera,Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo as Totales, " & vbCrLf &_
			" Case Doctor When 0 then cast(Doctor as varchar) else '<a href=""listado_docentes_facultad.asp?facu_ccod='+cast(facu_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=5"">'+cast(Doctor as varchar)+'</a>' end as Doctor1, " & vbCrLf &_
			" Case Magister When 0 then cast(Magister as varchar) else '<a href=""listado_docentes_facultad.asp?facu_ccod='+cast(facu_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=4"">'+cast(Magister as varchar)+'</a>' end as Magister1, " & vbCrLf &_
			" Case Licenciado When 0 then cast(Licenciado as varchar) else '<a href=""listado_docentes_facultad.asp?facu_ccod='+cast(facu_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=3"">'+cast(Licenciado as varchar)+'</a>' end as Licenciado1, " & vbCrLf &_
			" Case Profesional When 0 then cast(Profesional as varchar) else '<a href=""listado_docentes_facultad.asp?facu_ccod='+cast(facu_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=2"">'+cast(Profesional as varchar)+'</a>' end as Profesional1," & vbCrLf &_
			" Case Tecnico When 0 then cast(Tecnico as varchar) else '<a href=""listado_docentes_facultad.asp?facu_ccod='+cast(facu_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=1"">'+cast(Tecnico as varchar)+'</a>' end as Tecnico1," & vbCrLf &_
			" Case sin_grado_titulo When 0 then cast(sin_grado_titulo as varchar) else '<a href=""listado_docentes_facultad.asp?facu_ccod='+cast(facu_ccod as varchar)+'&carr_ccod='+cast(carr_ccod as varchar)+'&grado=0"">'+cast(sin_grado_titulo as varchar)+'</a>' end as sin_grado_titulo1" & vbCrLf &_
			" from (select aa.facu_ccod,cc.carr_ccod,aa.facu_tdesc as facultad,cc.carr_tdesc as carrera,   " & vbCrLf &_
			" (select count(distinct c.pers_ncorr)   " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea   " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)  " & vbCrLf &_
			"  and d.egra_ccod in (1,3) and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and  a.carr_ccod=dd.carr_ccod) as Doctor,   " & vbCrLf &_
			" (select count(distinct c.pers_ncorr)  " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea  " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			"  and d.egra_ccod=1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and  a.carr_ccod=dd.carr_ccod) as Magister,  " & vbCrLf &_
			" (select count(distinct c.pers_ncorr)   " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
			"  and d.egra_ccod=1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and  a.carr_ccod=dd.carr_ccod) as Licenciado,   " & vbCrLf &_
			" (select count(*)  " & vbCrLf &_
			"  from (  " & vbCrLf &_
			"  select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
			" and  a.carr_ccod=dd.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" union " & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and d.grac_ccod = 2  and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod)a ) as Profesional,  " & vbCrLf &_
			" (select count(*)  " & vbCrLf &_
			" from (  " & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" union" & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and d.grac_ccod = 1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
			" and  a.carr_ccod=dd.carr_ccod)a " & vbCrLf &_
			" ) as tecnico,  " & vbCrLf &_
			" ( select count(*) " & vbCrLf &_
			" from ( " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod	 " & vbCrLf &_
			" union" & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod)a) as sin_grado_titulo " & vbCrLf &_
			" from facultades aa, areas_academicas bb, carreras cc, secciones dd,periodos_academicos pa " & vbCrLf &_
			" where aa.facu_ccod=bb.facu_ccod and bb.area_ccod =  cc.area_ccod " & vbCrLf &_
			" and cc.carr_ccod= dd.carr_ccod " & vbCrLf &_
			" and dd.peri_ccod = pa.peri_ccod" & vbCrLf &_
			" and cast(pa.anos_ccod as varchar)='"&ano_consulta&"' and cc.tcar_ccod = 1" & vbCrLf &_
			" "&filtro1&" "&filtro2&" ) a  " & vbCrLf &_
			" where (Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo) <> 0  " & vbCrLf &_
			" order by facultad,carrera " 
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

		 
consulta = "SELECT carr_ccod, carr_tdesc, facu_ccod  FROM carreras_facultad"

conexion.Ejecuta consulta
set rec_carreras = conexion.ObtenerRS



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


arr_carreras = new Array();

<%
rec_carreras.MoveFirst
i = 0
while not rec_carreras.Eof
%>
arr_carreras[<%=i%>] = new Array();
arr_carreras[<%=i%>]["carr_ccod"] = '<%=rec_carreras("carr_ccod")%>';
arr_carreras[<%=i%>]["carr_tdesc"] = '<%=rec_carreras("carr_tdesc")%>';
arr_carreras[<%=i%>]["facu_ccod"] = '<%=rec_carreras("facu_ccod")%>';
<%	
	rec_carreras.MoveNext
	i = i + 1
wend
%>

function CargarCarreras(formulario, facu_ccod)
{
	formulario.elements["busqueda[0][carr_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Todas";
	formulario.elements["busqueda[0][carr_ccod]"].add(op)
	for (i = 0; i < arr_carreras.length; i++)
	  { 
		if (arr_carreras[i]["facu_ccod"] == facu_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_carreras[i]["carr_ccod"];
			op.text = arr_carreras[i]["carr_tdesc"];
			formulario.elements["busqueda[0][carr_ccod]"].add(op)			
		 }
	}	
}

function inicio()
{
  <%if facu_ccod <> "" then%>
    CargarCarreras(buscador, <%=facu_ccod%>);
	buscador.elements["busqueda[0][carr_ccod]"].value ='<%=carr_ccod%>'; 
  <%end if%>
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
                                <td><div align="left">Facultad</div></td>
                                <td><div align="center">:</div></td>
                                <td>
                                  <% f_busqueda.dibujaCampo ("facu_ccod") %>
                                </td>
                              </tr>
                              <tr> 
                                <td width="15%"><div align="left">Carrera</div></td>
                                <td width="4%"><div align="center">:</div></td>
                                <td width="81%"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
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
     <%if carrera <> "" then%> 
 <tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Facultad</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=facultad%></font></b></font></td>
  </tr>
  <tr> 
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Carrera</font></b></font></td>
    <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=carrera%></font></b></font></td>
  </tr>
  <%end if%>
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
				  <tr><td align="left"><%pagina.dibujarSubtitulo("Resumen de docentes Distribuidos por facultad y escuela")%></td></tr>
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
                  <td><div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", "docentes_facultad_excel.asp?facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod
										   botonera.dibujaboton "excel"
										%></td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
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
