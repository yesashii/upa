<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
'response.Write("<br>RUT="&RUT)
'response.Write("<br>rut2="&rut2)
'
'response.End()


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usu=negocio.ObtenerUsuario
set f_agrega = new CFormulario
f_agrega.Carga_Parametros "encuesta_satifaccion.xml", "reenvio"
f_agrega.Inicializar conexion
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

REES_NCORR = f_agrega.ObtenerValorPost (filai, "REES_NCORR")
next	

response.Redirect("http://admision.upacifico.cl/encuesta_satisfaccion/www/reenvia_encuesta.php?user="&usu&"&rees_ncorr="&REES_NCORR&"")

'if devuelta="si" then
'response.Redirect("../lanzadera/lanzadera.asp")
'else
'usu=negocio.obtenerUsuario
'
'end if
'------------------------------------------------------------------------------------------------------
%>


