<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->
<% 
Response.AddHeader "Content-Disposition", "attachment;filename=enrolments.txt"
Response.ContentType = "text/plain"
Server.ScriptTimeOut = 400000
set pagina = new CPagina

set conexion_sga = new cConexion


conexion_sga.inicializar "upacifico"
'negocio.inicializa conexion


consulta_sga="select * from"& vbCrLf &_ 
"(select  distinct a.matr_ncorr,b.secc_ccod,"& vbCrLf &_ 
"d.pers_ncorr as id"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
"from cargas_academicas a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and b.carr_ccod  in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod=217"& vbCrLf &_
"union"& vbCrLf &_
"select  distinct a.matr_ncorr,b.secc_ccod,"& vbCrLf &_ 
"d.pers_ncorr as id"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
"from cargas_academicas a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod=216)a"& vbCrLf &_
"where a.id_curso in ('2-920-2-FPOPA022-1')"& vbCrLf &_

"order by a.id_curso"




set f_datos_sga  = new cformulario
f_datos_sga.carga_parametros "tabla_vacia.xml", "tabla" 
f_datos_sga.inicializar conexion_sga							
f_datos_sga.consultar consulta_sga


 while f_datos_sga.Siguiente
 
 			    accion = f_datos_sga.obtenerValor("inst")
				response.Write("add,")
				response.Write("student,")
				id_alumno = f_datos_sga.obtenerValor("id")
				response.Write(id_alumno&",")
				id_curso = f_datos_sga.obtenerValor("id_curso")
				response.Write(id_curso)
				Response.Write(vbCrLf)
				

   wend 
%>