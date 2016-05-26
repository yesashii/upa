
 <!-- #include file="../biblioteca/_conexion.asp" -->
<%

for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
mall_ccod	=	request.Form("d[0][asignatura]")
seccion		=	request.form("d[0][secc_ccod]")
matricula	=	request.form("d[0][matr_ncorr]")

set conectar 	= new cconexion
set formulario 	= new cformulario
set carga		= new cformulario
conectar.inicializar "upacifico"

existe_ca	=clng(conectar.consultauno("select count(*) from cargas_academicas where matr_ncorr='"& matricula&"' and secc_ccod='"& seccion &"'"))

existe_eq	=clng(conectar.consultauno("select count(*) from equivalencias where matr_ncorr='"& matricula&"' and secc_ccod='"& seccion &"'"))

if existe_ca > 0  or existe_eq > 0 then
	conectar.EstadoTransaccion false
end if  

formulario.carga_parametros "equivalencias.xml", "equivalencias"
formulario.inicializar conectar

carga.carga_parametros "equivalencias.xml", "cargas"
carga.inicializar conectar

asignatura=conectar.consultauno("select asig_ccod from malla_curricular where mall_ccod='"& mall_ccod &"'")

carga.procesaForm

'formulario.listarpost

carga.mantienetablas false

formulario.procesaForm

formulario.agregacampopost	"mall_ccod" ,mall_ccod
formulario.agregacampopost	"asig_ccod"	,asignatura
'formulario.listarpost
formulario.mantienetablas false
session("mensajeError") = "Equivalencia Guardada"
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>