<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
q_tcaj_ccod = Request.QueryString("tcaj_ccod")

set conexion = new cConexion
set formulario = new cFormulario
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.Inicializa conexion

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede
if not EsVacio(q_tcaj_ccod) then
	cajero.AsignarTipoCaja q_tcaj_ccod
end if

consulta = "select convert(varchar,getdate(),103)"
MCAJ_FINICIO = conexion.ConsultaUno(consulta)
'response.Write(MCAJ_FINICIO)
mcaj_ncorr = conexion.consultauno("exec obtenersecuencia 'movimientos_cajas'")

formulario.carga_parametros "parametros.xml", "apertura_de_cajas"
formulario.inicializar conexion
formulario.procesaForm
formulario.agregacampopost "MCAJ_FINICIO",MCAJ_FINICIO
formulario.agregacampopost "mcaj_ncorr",mcaj_ncorr
formulario.mantieneTablas false
'response.End()
session("mensajeError") = "Caja abierta. Nº : " & cajero.ObtenerCajaAbierta & "."
response.redirect("../lanzadera/lanzadera.asp")
%>