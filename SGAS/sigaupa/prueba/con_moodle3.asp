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
peri_ccod="220,221"

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
"and a.secc_ccod=47906"& vbCrLf &_
"and d.peri_ccod in (220,221) "& vbCrLf &_
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
"and a.secc_ccod=47906"& vbCrLf &_
"and d.peri_ccod in (220,221)"& vbCrLf &_
"order by a.audi_fmodificacion"




consulta_sga="select  distinct b.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,a.secc_ccod"& vbCrLf &_
",cast(c.sede_ccod as varchar)+'-'+cast(rtrim(d.carr_ccod) as varchar)+'-'+cast(c.jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'del'as inst"& vbCrLf &_
"from cargas_academicas_log a, alumnos b, ofertas_academicas c,especialidades d,secciones e"& vbCrLf &_
"where a.MATR_NCORR=b.MATR_NCORR"& vbCrLf &_
"and b.OFER_NCORR=c.OFER_NCORR"& vbCrLf &_
"and c.ESPE_CCOD=d.ESPE_CCOD"& vbCrLf &_
"and a.SECC_CCOD=e.SECC_CCOD"& vbCrLf &_
"and c.PERI_CCOD=226"& vbCrLf &_
"and convert(datetime,a.AUDI_FMODIFICACION,103) between convert(datetime,'08-03-2012',103) and convert(datetime,'13-03-2012',103)"& vbCrLf &_
"and (select count(*) from cargas_academicas zz  where a.matr_ncorr=zz.MATR_NCORR and a.secc_ccod=zz.SECC_CCOD)=0"



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
	'LACM_NCORR=conexion_sga.ConsultaUno("exec ObtenerSecuencia 'LOG_AUTO_ACTUALIZACION_MOODLE'")
			
	'insr="insert into LOG_AUTO_ACTUALIZACION_MOODLE (LACM_NCORR,pers_ncorr,id_curso,accion,AUDI_FMODIFICACION)values ("&LACM_NCORR&","&id_alumno&",'"&id_curso&"','"&accion&"',getdate())"
	''Response.Write("<br>"&insr)
	'conexion_sga.ejecutaS (insr)	
	
   wend 
%>