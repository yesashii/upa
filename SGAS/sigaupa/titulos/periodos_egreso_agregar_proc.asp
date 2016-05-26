<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_periodos = new CFormulario
f_periodos.Carga_Parametros "periodos_egreso.xml", "f_nuevo"
f_periodos.Inicializar conexion
f_periodos.ProcesaForm
'f_planes.ListarPost

peri_ccod = request.querystring("peri_ccod")
pegr_ncorr = request.querystring("pegr_ncorr")

f_periodos.AgregaCampoPost "peri_ccod", peri_ccod
 'f_planes.AgregaCampoPost "epes_ccod", 1

if pegr_ncorr = "" then
   pegr_ncorr = conexion.consultauno("exec ObtenerSecuencia 'pre_periodos_egreso'")
   f_periodos.AgregaCampoPost "pegr_ncorr", pegr_ncorr
   f_periodos.AgregaCampoPost "peri_ccod", peri_ccod
else
   f_periodos.AgregaCampoPost "pegr_ncorr", pegr_ncorr
   f_periodos.AgregaCampoPost "peri_ccod", peri_ccod
end if


f_periodos.MantieneTablas false
'response.End()

%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>