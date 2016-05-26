<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
caje_ccod = trim(request.form("cajas[0][caje_ccod]"))
eren_ccod = trim(request.form("cajas[0][eren_ccod]"))
sede_ccod = trim(request.form("cajas[0][sede_ccod]"))
tcaj_ccod = trim(request.form("cajas[0][tcaj_ccod]"))
mcaj_mrendicion = request.Form("cajas[0][mcaj_mrendicion]")


set conexion = new cConexion
'set formulario = new cFormulario
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.Inicializa conexion

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede
usuario = negocio.ObtenerUsuario
'response.Write("Usuario: " &usuario)
mcaj_ncorr = conexion.consultauno("exec obtenersecuencia 'movimientos_cajas'")

conexion.EjecutaS("insert into MOVIMIENTOS_CAJAS (CAJE_CCOD, EREN_CCOD, MCAJ_FINICIO, MCAJ_MRENDICION, MCAJ_NCORR, SEDE_CCOD, TCAJ_CCOD, AUDI_FMODIFICACION, AUDI_TUSUARIO) values (upper('"&caje_ccod&"'), "&eren_ccod&", getdate(), "&mcaj_mrendicion&", "&mcaj_ncorr&", "&sede_ccod&", "&tcaj_ccod&", getdate(), '"&usuario&"')")

'formulario.carga_parametros "parametros.xml", "apertura_de_cajas"
'formulario.inicializar conexion
'formulario.procesaForm
'formulario.agregacampopost "caje_ccod",caje_ccod
'formulario.agregacampopost "mcaj_ncorr",mcaj_ncorr
'formulario.agregacampopost "mcaj_finicio",mcaj_finicio
'formulario.mantieneTablas true
session("mensajeError") = "Caja abierta. Nº : " & cajero.ObtenerCajaAbierta & "."
response.redirect("../lanzadera/lanzadera.asp")
%>
