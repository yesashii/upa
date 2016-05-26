 <!-- #include file = "../biblioteca/_conexion_moodle.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->
<% 
'Response.ContentType = "text/plain"
Server.ScriptTimeOut = 200000
peri_ccod=request.QueryString("peri_ccod")
set pagina = new CPagina

set conexion_moodle = new cConexion2
set conexion_sga = new cConexion
'set negocio = new cNegocio

conexion_moodle.inicializar "upacifico"
conexion_sga.inicializar "upacifico"
'negocio.inicializa conexion


consulta_sga="select distinct  idnumber,fullname"& vbCrLf &_
"from moodle_course" & vbCrLf &_
"where periodo is null"& vbCrLf &_ 
"union"& vbCrLf &_
"select idnumber,fullname"& vbCrLf &_
"from moodle_course"& vbCrLf &_
"where cast(asig_ccod as varchar)+'-'+cast(seccion as varchar) in(select distinct rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
"from secciones where peri_ccod=216 and carr_ccod=920)"& vbCrLf &_
"order by idnumber"

response.write("<br>"&consulta_sga)
'response.end()
 
set f_datos_sga  = new cformulario
f_datos_sga.carga_parametros "tabla_vacia.xml", "tabla" 
f_datos_sga.inicializar conexion_sga							
f_datos_sga.consultar consulta_sga

'Response.Write(vbCrLf)

'response.Write("del,student,ID-alumno,ID-Curso")
'Response.Write(vbCrLf)
g=0
 while f_datos_sga.Siguiente
 
 
 idnumber=f_datos_sga.ObtenerValor("idnumber")
 
 upadte_moodle="update mdl_course set enrollable='0' where idnumber='"&idnumber&"'"
 conexion_moodle.ejecutaS (upadte_moodle)
 
'response.Write("<br>"&upadte_moodle)
	
 wend 
%>