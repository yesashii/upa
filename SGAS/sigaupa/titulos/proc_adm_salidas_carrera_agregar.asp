<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
saca_ncorr=request.Form("salida[0][saca_ncorr]")
variable1 = "0"
if EsVacio(saca_ncorr) then
    variable1 = "1" 'ocupada sólo para incorporar la carrera en la salida
	saca_ncorr=conexion.consultaUno("execute obtenerSecuencia 'salidas_carrera'")
	plan_ccod=request.Form("salida[0][plan_ccod]")
	carr_ccod = conexion.consultaUno("select carr_ccod from planes_estudio a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.plan_ccod as varchar)='"&plan_ccod&"'")
end if

set f_salida = new CFormulario
f_salida.Carga_Parametros "adm_salidas_carrera.xml", "salida"
f_salida.Inicializar conexion
f_salida.ProcesaForm
f_salida.agregacampopost "saca_ncorr", saca_ncorr
if variable1 = "1" then
	f_salida.agregacampopost "carr_ccod", carr_ccod
end if
f_salida.MantieneTablas false
'response.End()

%>


<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>

