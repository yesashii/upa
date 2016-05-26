<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_movimiento_caja = new CFormulario
f_movimiento_caja.Carga_Parametros "rendicion_cajas.xml", "movimiento_caja"
f_movimiento_caja.Inicializar conexion
f_movimiento_caja.ProcesaForm
f_movimiento_caja.AgregaCampoPost "eren_ccod", "2"
f_movimiento_caja.MantieneTablas false


set f_documentos_caja = new CFormulario
f_documentos_caja.Carga_Parametros "rendicion_cajas.xml", "documentos_caja"
f_documentos_caja.Inicializar conexion
f_documentos_caja.ProcesaForm
f_documentos_caja.MantieneTablas false

'if conexion.ObtenerEstadoTransaccion then
'	conexion.MensajeError "Caja cerrada."
'end if


v_mcaj_ncorr=request.Form("movimientos_cajas[0][mcaj_ncorr]") 
url="rendicion_cajas_imprimir.asp?mcaj_ncorr="&v_mcaj_ncorr
v_referer="../lanzadera/lanzadera.asp"
%>
<script>
window.open("<%=url%>","<%=v_mcaj_ncorr%>");
variable=1+2;

</script>
<script language="JavaScript">
   location.reload("<%=v_referer%>"); 
</script>
