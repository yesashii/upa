<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%

set conexion = new cConexion
set formulario = new cFormulario
set negocio = new cNegocio

conexion.inicializar "desauas"

formulario.carga_parametros "parametros.xml", "rendicion_de_cajas"
formulario.inicializar conexion
formulario.procesaForm
formulario.mantieneTablas false
response.redirect("../lanzadera/lanzadera.asp")
%>