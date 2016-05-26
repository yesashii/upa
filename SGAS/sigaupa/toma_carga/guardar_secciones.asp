
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

rut_01=conectar.consultaUno("select pers_nrut from personas a, alumnos b where cast(b.matr_ncorr as varchar)='"&matricula&"' and a.pers_ncorr=b.pers_ncorr")
xdv_01=conectar.consultaUno("select pers_xdv from personas a, alumnos b where cast(b.matr_ncorr as varchar)='"&matricula&"' and a.pers_ncorr=b.pers_ncorr")

existe_ca	=clng(conectar.consultauno("select count(*) from cargas_academicas where cast(matr_ncorr as varchar)='"& matricula&"' and cast(secc_ccod as varchar)='"& seccion &"'"))

existe_eq	=clng(conectar.consultauno("select count(*) from equivalencias where cast(matr_ncorr as varchar)='"& matricula&"' and cast(secc_ccod as varchar)='"& seccion &"'"))

if existe_ca > 0  or existe_eq > 0 then
	conectar.EstadoTransaccion false
end if  

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
'conectar.estadoTransaccion false
cadena="toma_carga.asp?rut="&rut_01&"&dv="&xdv_01
session("mensajeError") = "Equivalencia Guardada"
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.Redirect(cadena)
%>
<html>
<head>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
</head>
</html>