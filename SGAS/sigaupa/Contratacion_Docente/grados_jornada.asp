<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Clasificacion por grado academico"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


periodo = negocio.obtenerPeriodoAcademico("Postulacion")
'sede = negocio.obtenerSede
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "grados_jornada.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
jorn_ccod = request.querystring("busqueda[0][jorn_ccod]")
sede_ccod = request.querystring("busqueda[0][sede_ccod]")
'response.Write(carr_ccod)
sede = sede_ccod
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "grados_jornada.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "Select '"&sede_ccod&"' as sede_ccod,'"&carr_ccod&"' as carr_ccod, '"&jorn_ccod&"' as jorn_ccod"
 'f_busqueda.Consultar "select ''"

  consulta_carreras= "select distinct rtrim(ltrim(c.carr_ccod)) as carr_ccod,c.carr_tdesc,d.jorn_ccod,d.jorn_tdesc,e.sede_ccod,e.sede_tdesc"& vbCrLf &_
					" from ofertas_Academicas a, especialidades b, carreras c, jornadas d, sedes e "& vbCrLf &_
					" where a.espe_ccod=b.espe_ccod  and a.sede_ccod=e.sede_ccod"& vbCrLf &_
				    " and b.carr_ccod=c.carr_ccod and a.jorn_ccod=d.jorn_ccod"& vbCrLf &_
					" and cast(a.peri_ccod as varchar)='"&periodo&"' and c.tcar_ccod=1"& vbCrLf &_
				    " order by c.carr_tdesc,d.jorn_tdesc asc"
					
 'f_busqueda.agregaCampoParam "carr_ccod", "destino",consulta_carreras
 'f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta_carreras
 f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_grados = new CFormulario
f_grados.Carga_Parametros "grados_jornada.xml", "f_grados"
f_grados.Inicializar conexion
' consulta = "select a.carr_ccod, a.espe_ccod, b.TTIT_CCOD, b.ttit_tdesc, c.eesp_tdesc, a.espe_tdesc, a.espe_ttitulo, a.espe_nduracion "& vbCrLf &_
'			"from especialidades a, tipos_titulos b, estados_de_especialidad c "& vbCrLf &_
'			"where a.ttit_ccod *= b.ttit_ccod "& vbCrLf &_
'			"  and a.eesp_ccod = c.eesp_ccod "& vbCrLf &_
'			"  and carr_ccod = '" & carr_ccod & "' "& vbCrLf &_
'			"ORDER BY a.espe_fini_vigencia "

'consulta= " select *, Doctor + Magister + Licenciados + sin_grado as total_docentes, "& vbCrLf &_
'		  " hora_Doctor + hora_Magister + hora_Licenciados + hora_sin_grado as total_horas "& vbCrLf &_
'		  " from( "& vbCrLf &_
'		  " select 3 as orden,'HORA' as jornada, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod= c.carr_ccod"& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 1 and 19) as Doctor, "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0) "& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1"& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 1 and 19 )aa)as hora_Doctor, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 1 and 19) as Magister,  "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0) "& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 1 and 19 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5))aa)as hora_Magister, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5))"& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 1 and 19) as Licenciados,  "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0)"& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1"& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3"& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 1 and 19 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)))aa)as hora_Licenciados, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,curriculum_docente b1 "& vbCrLf &_
'		  " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod in (1,2) "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5))"& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 1 and 19) as sin_grado,  "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0) "& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,curriculum_docente b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod  "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod in (1,2) "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 1 and 19 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)))aa)as hora_sin_grado "& vbCrLf &_
'		  " from carreras c "& vbCrLf &_
'		  " where cast(c.carr_ccod  as varchar)='" & carr_ccod & "' "& vbCrLf &_
'		  " union "& vbCrLf &_
'		  " select 2 as orden,'MEDIA' as jornada, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 20 and 31) as Doctor, "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0) "& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod  "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 20 and 31 )aa)as hora_Doctor, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod= c.carr_ccod  "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 20 and 31) as Magister,  "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0) "& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4"& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 20 and 31 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5))aa)as hora_Magister, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5))"& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 20 and 31) as Licenciados,  "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0) "& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 20 and 31 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)))aa)as hora_Licenciados, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,curriculum_docente b1 "& vbCrLf &_
'		  " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod in (1,2) "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 20 and 31) as sin_grado,  "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0) "& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,curriculum_docente b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod  "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod in (1,2) "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") between 20 and 31 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)))aa)as hora_sin_grado  "& vbCrLf &_
'		  " from carreras c "& vbCrLf &_
'		  " where cast(c.carr_ccod  as varchar)='" & carr_ccod & "' "& vbCrLf &_
'		  " union "& vbCrLf &_
'		  " select 1 as orden,'COMPLETA' as jornada, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") > 31) as Doctor, "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0) "& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") >31 )aa)as hora_Doctor, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") > 31) as Magister,  "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0) "& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod  "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") > 31 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5))aa)as hora_Magister, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod  "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)) "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") > 31) as Licenciados,  "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0)			"& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") > 31 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)))aa)as hora_Licenciados, "& vbCrLf &_
'		  " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
'		  " from carreras_docente a1,curriculum_docente b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod  "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod in (1,2) "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") > 31) as sin_grado,  "& vbCrLf &_
'		  " (select isnull(sum(protic.retorna_horas_docente_Carrera(aa.pers_ncorr,"&sede&",aa.carr_ccod,"&periodo&")),0) "& vbCrLf &_
'		  " from (select distinct a1.pers_ncorr,a1.carr_ccod "& vbCrLf &_
'		  " from carreras_docente a1,curriculum_docente b1 "& vbCrLf &_
'		  " where a1.carr_ccod=c.carr_ccod "& vbCrLf &_
'		  " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod in (1,2) "& vbCrLf &_
'		  " and protic.retorna_horas_docente_Carrera(a1.pers_ncorr,"&sede&",a1.carr_ccod,"&periodo&") > 31 "& vbCrLf &_
'		  " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)))aa)as hora_sin_grado "& vbCrLf &_
'		  " from carreras c  "& vbCrLf &_
'		  " where cast(c.carr_ccod  as varchar)='" & carr_ccod & "') aaa"			

consulta = "select *, Doctor + Magister + Licenciados + sin_grado as total_docentes, "& vbCrLf &_
		   " hora_Doctor + hora_Magister + hora_Licenciados + hora_sin_grado as total_horas "& vbCrLf &_
		   " from( "& vbCrLf &_
		   " select 1 as orden,'COMPLETA' as jornada, "& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and    (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') > 31) as Doctor,"& vbCrLf &_
		   "       "& vbCrLf &_   
		   " (select isnull(sum(a1.prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') > 31 )as hora_Doctor, "& vbCrLf &_
		   " ----------------------------------------------------------------------------------------------------        "& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) "& vbCrLf &_
 		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') > 31) as Magister, "& vbCrLf &_
		   "          "& vbCrLf &_
		   " (select isnull(sum(prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') > 31 "& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5))as hora_Magister, "& vbCrLf &_
		   " --------------------------------------------------------------------------------------------------------------"& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5))"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "          where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') > 31) as Licenciados,  "& vbCrLf &_
           " 	"& vbCrLf &_
		   " (select isnull(sum(prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr  and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') > 31 "& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)))as hora_Licenciados, "& vbCrLf &_
		   " --------------------------------------------------------------------------------------------------------------- "& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod not in (3,4,5) and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5))"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') > 31) as sin_grado,"& vbCrLf &_
		   "           "& vbCrLf &_
		   " (select isnull(sum(prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod  and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod not in (5,4,3) and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') > 31 "& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)))as hora_sin_grado "& vbCrLf &_
		   " from carreras c "& vbCrLf &_
		   " where cast(c.carr_ccod  as varchar)='"&carr_ccod&"' "& vbCrLf &_
		   " union "& vbCrLf &_
		   " select 2 as orden,'MEDIA' as jornada, "& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and    (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 20 and 31) as Doctor, "& vbCrLf &_
           "	"& vbCrLf &_
		   " (select isnull(sum(a1.prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 20 and 31 )as hora_Doctor, "& vbCrLf &_
		   " ----------------------------------------------------------------------------------------------------  "& vbCrLf &_      
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) "& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 20 and 31) as Magister, 	"& vbCrLf &_
		   "          "& vbCrLf &_
		   " (select isnull(sum(prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 20 and 31 "& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5))as hora_Magister, "& vbCrLf &_
		   " -------------------------------------------------------------------------------------------------------------- "& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5))"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 20 and 31) as Licenciados,  "& vbCrLf &_
		   "         "& vbCrLf &_
		   " (select isnull(sum(prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 20 and 31 "& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)))as hora_Licenciados, "& vbCrLf &_
		   " --------------------------------------------------------------------------------------------------------------- "& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod not in (3,4,5) and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) "& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 20 and 31) as sin_grado,"& vbCrLf &_
		   "           "& vbCrLf &_
		   " (select isnull(sum(prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod  and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod not in (3,4,5) and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 20 and 31 "& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)))as hora_sin_grado "& vbCrLf &_
		   " from carreras c "& vbCrLf &_
		   " where cast(c.carr_ccod  as varchar)='"&carr_ccod&"' "& vbCrLf &_
		   " union  "& vbCrLf &_
		   " select 3 as orden,'HORA' as jornada, "& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and    (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 1 and 19) as Doctor, "& vbCrLf &_
		   "          "& vbCrLf &_
		   " (select isnull(sum(a1.prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 1 and 19 )as hora_Doctor, "& vbCrLf &_
		   " ----------------------------------------------------------------------------------------------------        "& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) "& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 1 and 19) as Magister, "& vbCrLf &_
           "		"& vbCrLf &_
		   " (select isnull(sum(prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 1 and 19 "& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5))as hora_Magister, "& vbCrLf &_
		   " -------------------------------------------------------------------------------------------------------------- "& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
 		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)) "& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 1 and 19) as Licenciados,  "& vbCrLf &_
		   "         "& vbCrLf &_
		   " (select isnull(sum(prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"' "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 1 and 19 "& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)))as hora_Licenciados, "& vbCrLf &_
		   " --------------------------------------------------------------------------------------------------------------- "& vbCrLf &_
		   " (select count(distinct a1.pers_ncorr) "& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod= c.carr_ccod "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod not in (3,4,5) and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) "& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 1 and 19) as sin_grado, "& vbCrLf &_
           "	"& vbCrLf &_
		   " (select isnull(sum(prof_nhoras),0) "& vbCrLf &_
		   " from horas_docentes_carrera a1,grados_profesor b1 "& vbCrLf &_
		   " where a1.carr_ccod=c.carr_ccod and cast(a1.peri_ccod as varchar)='"&periodo&"' and cast(a1.sede_ccod as varchar)='"&sede&"' "& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod not in (3,4,5) and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   "         and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 1 and 19 "& vbCrLf &_
		   " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)))as hora_sin_grado "& vbCrLf &_
		   " from carreras c "& vbCrLf &_
		   " where cast(c.carr_ccod  as varchar)='"&carr_ccod&"'"& vbCrLf &_
		   " )aaa "
'response.write("<pre>"&consulta&"</pre>")
f_grados.Consultar consulta

'---------------------------------------------------------------------------------------------------

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
colores = Array(3);
	colores[0] = '';
	//colores[1] = '#97AAC6';
	//colores[2] = '#C0C0C0';
	colores[1] = '#FFECC6';
	colores[2] = '#FFECC6';
function cargar()
{
  buscador.action="grados_jornada.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}
</script>
<% f_busqueda.generaJS %>
<style type="text/css">
<!--
.Estilo2 {color: #000000}
.Estilo3 {font-weight: bold}
.Estilo4 {color: #000000; font-weight: bold; }
-->
</style>
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
                                <td width="12%"><div align="left">Sede</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><%f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="12%"><div align="left">Carrera</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><%f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="12%"><div align="left">Jornada</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><%f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
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
                    <br><%pagina.DibujarSubtitulo carrera%>
                  
                  </div>
              <form name="edicion">
                <br>
				<!---------------------------------OTRA TABLA-------------------------------------->
				<tr>
                    <td align="center">
						    <table width="650" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
                              <!--DWLayoutTable-->
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <th width="100" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center"><strong>DOCENTES</strong></div></font></th>
                                <th width="110" colspan="2" valign="top"><FONT color="#333333"><div align="center"><strong>DOCTOR</strong></div></font></th>
                                <th width="110" colspan="2" valign="top"><FONT color="#333333"><div align="center"><strong>MAGISTER</strong></div></font></th>
                                <th width="110" colspan="2" valign="top"><FONT color="#333333"><div align="center"><strong>LICENCIADOS</strong></div></font></th>
                                <th width="110" colspan="2" valign="top"><FONT color="#333333"><div align="center"><strong>SIN GRADO</strong></div></font></th>
								<th width="110" colspan="2" valign="top"><FONT color="#333333"><div align="center"><strong>TOTAL</strong></div></font></th>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <th><FONT color="#333333"><div align="center">JORNADA</div></font></th>
								<th><FONT color="#333333"><div align="center">N°</div></font></th>
                                <th><FONT color="#333333"><div align="center">HORAS</div></font></th>
                                <th><FONT color="#333333"><div align="center">N°</div></font></th>
                                <th><FONT color="#333333"><div align="center">HORAS</div></font></th>
								<th><FONT color="#333333"><div align="center">N°</div></font></th>
                                <th><FONT color="#333333"><div align="center">HORAS</div></font></th>
                                <th><FONT color="#333333"><div align="center">N°</div></font></th>
                                <th><FONT color="#333333"><div align="center">HORAS</div></font></th>
                                <th><FONT color="#333333"><div align="center"><strong>N°</strong></div></font></th>
                                <th><FONT color="#333333"><div align="center"><strong>HORAS</strong></div></font></th>
                              </tr>
							  <%  
							    total_doctor=0
								total_magister=0
								total_licenciado=0
								total_singrado=0
								total_general=0
								total_hora_doctor=0
								total_hora_magister=0
								total_hora_licenciado=0
								total_hora_singrado=0
								total_hora_general=0
    							while f_grados.Siguiente 
									 total_doctor= total_doctor +  cint(f_grados.ObtenerValor("doctor"))
									 total_magister= total_magister +  cint(f_grados.ObtenerValor("magister"))
									 total_licenciados= total_licenciados +  cint(f_grados.ObtenerValor("licenciados"))
									 total_singrado= total_singrado +  cint(f_grados.ObtenerValor("sin_grado"))
									 total_general= total_general +  cint(f_grados.ObtenerValor("total_docentes"))
									 total_hora_doctor= total_hora_doctor +  cint(f_grados.ObtenerValor("hora_doctor"))
									 total_hora_magister= total_hora_magister +  cint(f_grados.ObtenerValor("hora_magister"))
									 total_hora_licenciados= total_hora_licenciados +  cint(f_grados.ObtenerValor("hora_licenciados"))
									 total_hora_singrado= total_hora_singrado +  cint(f_grados.ObtenerValor("hora_sin_grado"))
									 total_hora_general= total_hora_general +  cint(f_grados.ObtenerValor("total_horas"))%>
									 <tr bgcolor="#FFFFFF">
										<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("jornada")%></div></td>
                                		<td class='click' onClick='irA("detalle_docentes_grados.asp?tipo=5&jornada=<%=f_grados.obtenerValor("orden")%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("doctor")%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("hora_doctor")%></div></td>
										<td class='click' onClick='irA("detalle_docentes_grados.asp?tipo=4&jornada=<%=f_grados.obtenerValor("orden")%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("magister")%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("hora_magister")%></div></td>
										<td class='click' onClick='irA("detalle_docentes_grados.asp?tipo=3&jornada=<%=f_grados.obtenerValor("orden")%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("licenciados")%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("hora_licenciados")%></div></td>
										<td class='click' onClick='irA("detalle_docentes_grados.asp?tipo=0&jornada=<%=f_grados.obtenerValor("orden")%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("sin_grado")%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("hora_sin_grado")%></div></td>
										<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("total_docentes")%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=f_grados.obtenervalor("total_horas")%></div></td>
  	                            	</tr>
								<%
								wend							
								%>
									<tr bgcolor="#FFFFFF"> 
										<td><div align="right" class="Estilo2"><strong>TOTAL</strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_doctor%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_hora_doctor%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_magister%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_hora_magister%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_licenciados%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_hora_licenciados%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_singrado%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_hora_singrado%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_general%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_hora_general%></strong></div></td>
									</tr>
						  </table>
					</td>
				</tr>
				<!----------------------------------FIN TABLA-------------------------------------->			
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
					                       botonera.agregabotonparam "excel", "url", "grados_jornada_excel.asp?carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&sede_ccod="&sede_ccod
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
