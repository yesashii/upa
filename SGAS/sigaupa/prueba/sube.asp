<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->
<% 
Response.AddHeader "Content-Disposition", "attachment;filename=enrolments.txt"
Response.ContentType = "text/plain"
Server.ScriptTimeOut = 200000
set pagina = new CPagina

set conexion_sga = new cConexion
'set negocio = new cNegocio

conexion_sga.inicializar "upacifico"
'negocio.inicializa conexion


consulta_sga="select  distinct d.pers_ncorr as id,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'add'as inst"& vbCrLf &_
"from cargas_academicas a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and d.peri_ccod=214"& vbCrLf &_
"and a.secc_ccod  in (41978,42968,42002)"



'"select  distinct d.pers_ncorr as id,"& vbCrLf &_
'"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
'",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
'",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
'",'del'as inst"& vbCrLf &_
'"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
'"where a.audi_tusuario like 'Eliminado%'"& vbCrLf &_
'"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
'"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
'"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
'"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
'"and d.peri_ccod=216"& vbCrLf &_
'"and protic.trunc(a.audi_fmodificacion)=protic.trunc(getdate())"& vbCrLf &_
'"union"& vbCrLf &_
'"select  distinct d.pers_ncorr as id,"& vbCrLf &_
'"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
'",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
'",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
'",'add'as inst"& vbCrLf &_
'"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
'"where a.audi_tusuario like 'Agregada%'"& vbCrLf &_
'"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
'"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
'"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
'"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
'"and d.peri_ccod=216"& vbCrLf &_
'"and protic.trunc(a.audi_fmodificacion)=protic.trunc(getdate())"& vbCrLf &_
'"order by  estado desc"

'


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
				
	LACM_NCORR=conexion_sga.ConsultaUno("exec ObtenerSecuencia 'LOG_AUTO_ACTUALIZACION_MOODLE'")
			
	insr="insert into LOG_AUTO_ACTUALIZACION_MOODLE (LACM_NCORR,pers_ncorr,id_curso,accion,AUDI_FMODIFICACION)values ("&LACM_NCORR&","&id_alumno&",'"&id_curso&"','"&accion&"',getdate())"
	'Response.Write("<br>"&insr)
	conexion_sga.ejecutaS (insr)	
	
   wend 
%>