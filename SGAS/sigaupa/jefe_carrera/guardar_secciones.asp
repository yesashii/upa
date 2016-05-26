
 <!-- #include file="../biblioteca/_conexion.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
mall_ccod	=	request.Form("d[0][asignatura]")
seccion		=	request.form("d[0][secc_ccod]")
matricula	=	request.form("d[0][matr_ncorr]")

set conectar 	= new cconexion
set formulario 	= new cformulario
set carga		= new cformulario
conectar.inicializar "upacifico"
'response.Write("select count(*) from cargas_academicas where cast(matr_ncorr as varchar)='"& matricula&"' and cast(secc_ccod as varchar)='"& seccion &"'<br>")
existe_ca	=clng(conectar.consultauno("select count(*) from cargas_academicas where cast(matr_ncorr as varchar)='"& matricula&"' and cast(secc_ccod as varchar)='"& seccion &"' and sitf_ccod=null and carg_nnota_final=null"))
existe_eq	=clng(conectar.consultauno("select count(*) from equivalencias where cast(matr_ncorr as varchar)='"& matricula&"' and cast(secc_ccod as varchar)='"& seccion &"'"))

if existe_ca > 0  or existe_eq > 0 then
	conectar.EstadoTransaccion false
end if  
'response.Write("<hr>existe_ca "&existe_ca&" existe_eq "&existe_eq&"<hr>")
formulario.carga_parametros "equivalencias.xml", "equivalencias"
formulario.inicializar conectar

carga.carga_parametros "equivalencias.xml", "cargas"
carga.inicializar conectar

asignatura=conectar.consultauno("select asig_ccod from malla_curricular where cast(mall_ccod as varchar)='"& mall_ccod &"'")

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
'response.End()
%>