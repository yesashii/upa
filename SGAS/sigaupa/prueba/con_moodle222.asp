<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->
<% 
Response.AddHeader "Content-Disposition", "attachment;filename=enrolments.txt"
Response.ContentType = "text/plain"
Server.ScriptTimeOut = 400000
set pagina = new CPagina

set conexion_sga = new cConexion
'set negocio = new cNegocio

conexion_sga.inicializar "upacifico"
'negocio.inicializa conexion
peri_ccod="222"

fecha=conexion_sga.ConsultaUno("select protic.trunc(getdate())")




'consulta_sga="select ''"
'consulta_sga="select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
'"a.matr_ncorr,f.secc_ccod"& vbCrLf &_
'",cast(f.sede_ccod as varchar)+'-'+cast(rtrim(f.carr_ccod) as varchar)+'-'+cast(f.jorn_ccod as varchar)+'-'+rtrim(f.asig_ccod)+'-'+cast(SUBSTRING(f.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
'",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
'",'add'as inst,"& vbCrLf &_
'"case when b.secc_ccod=f.secc_ccod then '1' else '2' end as estado"& vbCrLf &_
'"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,cargas_academicas e,secciones f"& vbCrLf &_
'"where a.audi_tusuario like 'Modificada%'"& vbCrLf &_
'"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
'"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
'"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
'"and a.MATR_NCORR=e.MATR_NCORR"& vbCrLf &_
'"and e.SECC_CCOD=f.SECC_CCOD"& vbCrLf &_
'"and b.ASIG_CCOD=f.ASIG_CCOD"& vbCrLf &_
'"and b.SECC_CCOD<>f.SECC_CCOD"& vbCrLf &_
'"and b.carr_ccod  in ('930','810','920')"& vbCrLf &_
'"and d.peri_ccod in (220,221)"& vbCrLf &_
'"--and protic.trunc(a.audi_fmodificacion)=protic.trunc('01-09-2010')"& vbCrLf &_
'"and protic.trunc(a.audi_fmodificacion)>=protic.trunc('01-08-2010')"& vbCrLf &_
'"union"& vbCrLf &_
'"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
'"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
'",cast(b.sede_ccod as varchar)+'-'+cast(rtrim(b.carr_ccod) as varchar)+'-'+cast(b.jorn_ccod as varchar)+'-'+rtrim(b.asig_ccod)+'-'+cast(SUBSTRING(b.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
'",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
'",'del'as inst,"& vbCrLf &_
'"case when b.secc_ccod=f.secc_ccod then '1' else '2' end as estado"& vbCrLf &_
'"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,cargas_academicas e,secciones f"& vbCrLf &_
'"where a.audi_tusuario like 'Modificada%'"& vbCrLf &_
'"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
'"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
'"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
'"and a.MATR_NCORR=e.MATR_NCORR"& vbCrLf &_
'"and e.SECC_CCOD=f.SECC_CCOD"& vbCrLf &_
'"and b.ASIG_CCOD=f.ASIG_CCOD"& vbCrLf &_
'"and b.SECC_CCOD<>f.SECC_CCOD"& vbCrLf &_
'"and b.carr_ccod  in ('930','810','920')"& vbCrLf &_
'"and d.peri_ccod in (220,221)"& vbCrLf &_
'"--and protic.trunc(a.audi_fmodificacion=protic.trunc('01-09-2010')"& vbCrLf &_
'"and convert(datetime,a.audi_fmodificacion,103)>=convert(datetime,'01-08-2010',103)"& vbCrLf &_
'"order by a.audi_fmodificacion"



consulta_sga="select  distinct c.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,a.secc_ccod"& vbCrLf &_
",cast(b.sede_ccod as varchar)+'-'+cast(rtrim(b.carr_ccod) as varchar)+'-'+cast(b.jorn_ccod as varchar)+'-'+rtrim(b.asig_ccod)+'-'+cast(SUBSTRING(b.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'add'as inst"& vbCrLf &_
"from cargas_academicas a,secciones b,alumnos c,postulantes d"& vbCrLf &_
"where a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"--and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"--and a.secc_ccod=47906"& vbCrLf &_
"--and c.matr_ncorr=221904"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&") "& vbCrLf &_
"and 1=2"& vbCrLf &_
"union "& vbCrLf &_
"select  distinct c.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,a.secc_ccod"& vbCrLf &_
",cast(b.sede_ccod as varchar)+'-'+cast(rtrim(b.carr_ccod) as varchar)+'-1-'+rtrim(b.asig_ccod)+'-1' as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'del'as inst"& vbCrLf &_
"from cargas_academicas a,secciones b,alumnos c,postulantes d"& vbCrLf &_
"where a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"--and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"--and a.secc_ccod=47906"& vbCrLf &_
"--and c.matr_ncorr=221904"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
"and 1=2"& vbCrLf &_
"order by a.audi_fmodificacion"


consulta_sga="select distinct top 2 d.pers_ncorr as id, c.audi_fmodificacion,c.matr_ncorr,c.secc_ccod,a.shortname as id_curso,"& vbCrLf &_
"'eliminado' as estado,'del'as inst"& vbCrLf &_
"from moodle_course a, secciones b, cargas_academicas c, alumnos d,situaciones_finales e"& vbCrLf &_
"where isnull(periodo,'') = ''"& vbCrLf &_
"and a.asig_ccod=b.asig_ccod and a.carr_ccod=b.carr_ccod and a.sede_ccod=b.SEDE_CCOD"& vbCrLf &_
"and a.jorn_ccod=b.jorn_ccod"& vbCrLf &_
"and b.peri_ccod=222"& vbCrLf &_
"and b.secc_ccod=c.secc_ccod and c.matr_ncorr=d.matr_ncorr and c.sitf_ccod=e.sitf_ccod"& vbCrLf &_
"and e.sitf_baprueba='S'"

 'Response.Write(consulta_sga)
 'response.end()
set f_datos_sga  = new cformulario
f_datos_sga.carga_parametros "tabla_vacia.xml", "tabla" 
f_datos_sga.inicializar conexion_sga							
f_datos_sga.consultar consulta_sga

'Response.Write(consulta_sga)

 while f_datos_sga.Siguiente
 
 			    accion = f_datos_sga.obtenerValor("inst")
				response.Write(accion&",")
				response.Write("student,")
				id_alumno = f_datos_sga.obtenerValor("id")
				response.Write(id_alumno&",")
				id_curso = f_datos_sga.obtenerValor("id_curso")
				response.Write(id_curso)
				Response.Write(vbCrLf)
'			
	
   wend 
%>