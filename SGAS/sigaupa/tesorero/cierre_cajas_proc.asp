<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%

set conexion = new cConexion
set formulario = new cFormulario
set negocio = new cNegocio

conexion.inicializar "upacifico"

formulario.carga_parametros "parametros.xml", "cierre_de_cajas"
formulario.inicializar conexion
formulario.procesaForm
formulario.mantieneTablas false

'conexion.estadotransaccion	false
response.redirect(request.ServerVariables("HTTP_REFERER"))
%>
