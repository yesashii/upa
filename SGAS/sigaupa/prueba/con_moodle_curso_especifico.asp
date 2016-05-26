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
'fecha_corte="and protic.trunc(a.audi_fmodificacion)=protic.trunc(getdate())"
fecha_corte="--and convert(datetime,protic.trunc(a.audi_fmodificacion),103)>=convert(datetime,getdate(),103)"

consulta_sga="select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'del'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.audi_tusuario like 'Eliminado%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod=216"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"and cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) in ('1-23-1-FPODV007-3')"& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'del'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.audi_tusuario like 'Eliminado%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and b.carr_ccod  in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod=217"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"and cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) in ('1-23-1-FPODV007-3')"& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'add'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.audi_tusuario like 'Agregada%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod=216"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"and cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) in ('1-23-1-FPODV007-3')"& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'add'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.audi_tusuario like 'Agregada%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and b.carr_ccod  in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod=217"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"and cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) in ('1-23-1-FPODV007-3')"& vbCrLf &_
"order by  a.audi_fmodificacion"



consulta_sga="select distinct (select pers_ncorr from alumnos bb where bb.matr_ncorr=aaa.matr_ncorr) as id,matr_ncorr,secc_ccod,estaba,cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso,'del' as inst"& vbCrLf &_
"from(select a.matr_ncorr,a.secc_ccod,(select count(*) from sbd03.sigaupa.dbo.cargas_academicas sa,sbd03.sigaupa.dbo.alumnos sb,sbd03.sigaupa.dbo.ofertas_academicas sc"& vbCrLf &_
"where sa.MATR_NCORR=sb.MATR_NCORR"& vbCrLf &_
"and sb.OFER_NCORR=sc.OFER_NCORR"& vbCrLf &_
"and sc.PERI_CCOD=224"& vbCrLf &_
"and sa.matr_ncorr=a.MATR_NCORR"& vbCrLf &_
"and sa.secc_ccod=a.SECC_CCOD)as estaba,d.carr_ccod,c.sede_ccod,secc_tdesc,c.jorn_ccod,asig_ccod"& vbCrLf &_
"from cargas_academicas_log a,"& vbCrLf &_
"alumnos b,"& vbCrLf &_
"ofertas_academicas c,"& vbCrLf &_
"especialidades d,"& vbCrLf &_
"secciones e"& vbCrLf &_
"where a.MATR_NCORR=b.MATR_NCORR"& vbCrLf &_
"and b.OFER_NCORR=c.OFER_NCORR"& vbCrLf &_
"and c.espe_ccod=d.espe_ccod"& vbCrLf &_
"and a.secc_ccod=e.secc_ccod"& vbCrLf &_
"and c.PERI_CCOD=224)aaa"& vbCrLf &_
"where estaba=0"


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
				
	'LACM_NCORR=conexion_sga.ConsultaUno("exec ObtenerSecuencia 'LOG_AUTO_ACTUALIZACION_MOODLE'")
			
	'insr="insert into LOG_AUTO_ACTUALIZACION_MOODLE (LACM_NCORR,pers_ncorr,id_curso,accion,AUDI_FMODIFICACION)values ("&LACM_NCORR&","&id_alumno&",'"&id_curso&"','"&accion&"',getdate())"
	'Response.Write("<br>"&insr)
	'conexion_sga.ejecutaS (insr)	
	
   wend 
%>