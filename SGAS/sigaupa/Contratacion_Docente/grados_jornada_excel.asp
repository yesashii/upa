<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'Server.ScriptTimeOut = 10000
Response.AddHeader "Content-Disposition", "attachment;filename=grados_academicos.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("Postulacion")

'-----------------------------------------------------------------------
carrera=request.QueryString("carr_ccod")
jorn_ccod=request.QueryString("jorn_ccod")
sede = request.QueryString("sede_ccod")  'negocio.obtenerSede
'------------------------------------------------------------------------------------
if carrera<>"" and carrera<>"-1" then
  nombre_carrera=conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carrera&"'")
end if
if jorn_ccod<>"" and jorn_ccod<>"-1" then
  jorn_tdesc=conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
end if
fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
nombre_sede=conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede&"'")
'------------------------------------------------------------------------------------

set f_grados = new CFormulario
f_grados.Carga_Parametros "grados_jornada.xml", "f_grados"
f_grados.Inicializar conexion

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
		   " where cast(c.carr_ccod  as varchar)='"&carrera&"' "& vbCrLf &_
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
		   " where cast(c.carr_ccod  as varchar)='"&carrera&"' "& vbCrLf &_
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
		   " where cast(c.carr_ccod  as varchar)='"&carrera&"'"& vbCrLf &_
		   " )aaa "		   

'response.Write("<pre>"&consulta&"</pre>")
f_grados.Consultar consulta
%>
<html>
<head>
<title>clasificacion por grado academico</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Clasificaci&oacute;n por grado acad&eacute;mico</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_sede %></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Carrera</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_carrera %></td>
  </tr>
   <tr> 
    <td width="16%"><strong>Jornada</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=jorn_tdesc %></td>
  </tr>
  <tr> 
    <td><strong>Fecha</strong></td>
    <td colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="10%"><div align="left"><strong>DOCENTES</strong></div></td>
    <td width="15%" colspan="2"><div align="center"><strong>DOCTOR</strong></div></td>
    <td width="15%" colspan="2"><div align="center"><strong>MAGISTER</strong></div></td>
	<td width="15%" colspan="2"><div align="center"><strong>LICENCIADOS</strong></div></td>
	<td width="10%" colspan="2"><div align="center"><strong>SIN GRADO</strong></div></td>
    <td width="10%" colspan="2"><div align="center"><strong>TOTAL</strong></div></td>
  </tr>
  <tr> 
    <td><div align="left"><strong>JORNADA</strong></div></td>
    <td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>HORAS</strong></div></td>
	<td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>HORAS</strong></div></td>
	<td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>HORAS</strong></div></td>
	<td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>HORAS</strong></div></td>
	<td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>HORAS</strong></div></td>
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
    while f_grados.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_grados.ObtenerValor("jornada")%></div></td>
    <td><div align="center"><%=f_grados.ObtenerValor("doctor")%></div></td>
	<td><div align="center"><%=f_grados.ObtenerValor("hora_doctor")%></div></td>
    <td><div align="center"><%=f_grados.ObtenerValor("magister")%></div></td>
	<td><div align="center"><%=f_grados.ObtenerValor("hora_magister")%></div></td>
    <td><div align="center"><%=f_grados.ObtenerValor("licenciados")%></div></td>
	<td><div align="center"><%=f_grados.ObtenerValor("hora_licenciados")%></div></td>
	<td><div align="center"><%=f_grados.ObtenerValor("sin_grado")%></div></td>
	<td><div align="center"><%=f_grados.ObtenerValor("hora_sin_grado")%></div></td>
    <td><div align="center"><strong><%=f_grados.ObtenerValor("total_docentes")%></strong></div></td>
	<td><div align="center"><strong><%=f_grados.ObtenerValor("total_horas")%></strong></div></td>
  </tr>
  <% total_doctor= total_doctor +  cint(f_grados.ObtenerValor("doctor"))
     total_magister= total_magister +  cint(f_grados.ObtenerValor("magister"))
	 total_licenciados= total_licenciados +  cint(f_grados.ObtenerValor("licenciados"))
	 total_singrado= total_singrado +  cint(f_grados.ObtenerValor("sin_grado"))
	 total_general= total_general +  cint(f_grados.ObtenerValor("total_docentes"))
	 total_hora_doctor= total_hora_doctor +  cint(f_grados.ObtenerValor("hora_doctor"))
     total_hora_magister= total_hora_magister +  cint(f_grados.ObtenerValor("hora_magister"))
	 total_hora_licenciados= total_hora_licenciados +  cint(f_grados.ObtenerValor("hora_licenciados"))
	 total_hora_singrado= total_hora_singrado +  cint(f_grados.ObtenerValor("hora_sin_grado"))
	 total_hora_general= total_hora_general +  cint(f_grados.ObtenerValor("total_horas"))
    wend %>
  <tr> 
    <td><div align="right"><strong>TOTAL</strong></div></td>
    <td><div align="center"><strong><%=total_doctor%></strong></div></td>
	<td><div align="center"><strong><%=total_hora_doctor%></strong></div></td>
    <td><div align="center"><strong><%=total_magister%></strong></div></td>
	<td><div align="center"><strong><%=total_hora_magister%></strong></div></td>
    <td><div align="center"><strong><%=total_licenciados%></strong></div></td>
	<td><div align="center"><strong><%=total_hora_licenciados%></strong></div></td>
	<td><div align="center"><strong><%=total_singrado%></strong></div></td>
	<td><div align="center"><strong><%=total_hora_singrado%></strong></div></td>
    <td><div align="center"><strong><%=total_general%></strong></div></td>
	<td><div align="center"><strong><%=total_hora_general%></strong></div></td>
  </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>