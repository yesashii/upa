<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
sapl_ncorr=request.Form("salida[0][sapl_ncorr]")
if EsVacio(sapl_ncorr) then
	sapl_ncorr=conexion.consultaUno("execute obtenerSecuencia 'salidas_plan'")
end if

set f_salida = new CFormulario
f_salida.Carga_Parametros "adm_salidas.xml", "salida"
f_salida.Inicializar conexion
f_salida.ProcesaForm
f_salida.agregacampopost "sapl_ncorr", sapl_ncorr
f_salida.MantieneTablas false
'response.End()

%>


<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>

